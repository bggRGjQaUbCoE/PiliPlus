#include "AppDnsResolver.h"

#include <arpa/inet.h>
#include <ctype.h>
#include <dlfcn.h>
#include <netdb.h>
#include <pthread.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>

typedef struct AppDnsHostEntry {
  char *host;
  char **addresses;
  size_t address_count;
  struct AppDnsHostEntry *next;
} AppDnsHostEntry;

static pthread_rwlock_t g_lock = PTHREAD_RWLOCK_INITIALIZER;
static AppDnsHostEntry *g_hosts = NULL;

static int (*g_original_getaddrinfo)(
    const char *restrict,
    const char *restrict,
    const struct addrinfo *restrict,
    struct addrinfo **restrict) = NULL;

static void free_entry(AppDnsHostEntry *entry) {
  if (entry == NULL) {
    return;
  }
  free(entry->host);
  for (size_t i = 0; i < entry->address_count; i++) {
    free(entry->addresses[i]);
  }
  free(entry->addresses);
  free(entry);
}

static char *copy_normalized_host(const char *host) {
  if (host == NULL || host[0] == '\0') {
    return NULL;
  }
  size_t length = strlen(host);
  while (length > 0 && host[length - 1] == '.') {
    length--;
  }
  if (length == 0) {
    return NULL;
  }
  char *result = malloc(length + 1);
  if (result == NULL) {
    return NULL;
  }
  for (size_t i = 0; i < length; i++) {
    result[i] = (char)tolower((unsigned char)host[i]);
  }
  result[length] = '\0';
  return result;
}

static AppDnsHostEntry *find_entry(const char *host) {
  for (AppDnsHostEntry *entry = g_hosts; entry != NULL; entry = entry->next) {
    if (strcmp(entry->host, host) == 0) {
      return entry;
    }
  }
  return NULL;
}

static bool parse_port(
    const char *service,
    const struct addrinfo *hints,
    uint16_t *port) {
  if (service == NULL || service[0] == '\0') {
    *port = 0;
    return true;
  }

  char *end = NULL;
  unsigned long value = strtoul(service, &end, 10);
  if (end != NULL && *end == '\0' && value <= 65535) {
    *port = (uint16_t)value;
    return true;
  }

  const char *protocol = NULL;
  if (hints != NULL) {
    if (hints->ai_socktype == SOCK_STREAM) {
      protocol = "tcp";
    } else if (hints->ai_socktype == SOCK_DGRAM) {
      protocol = "udp";
    }
  }
  struct servent *entry = getservbyname(service, protocol);
  if (entry == NULL) {
    return false;
  }
  *port = ntohs((uint16_t)entry->s_port);
  return true;
}

static bool address_family(const char *address, int *family) {
  struct in_addr ipv4;
  if (inet_pton(AF_INET, address, &ipv4) == 1) {
    *family = AF_INET;
    return true;
  }

  struct in6_addr ipv6;
  if (inet_pton(AF_INET6, address, &ipv6) == 1) {
    *family = AF_INET6;
    return true;
  }
  return false;
}

static int append_addrinfo(
    struct addrinfo **head,
    struct addrinfo **tail,
    const char *address,
    const char *hostname,
    uint16_t port,
    const struct addrinfo *hints) {
  int family = AF_UNSPEC;
  if (!address_family(address, &family)) {
    return 0;
  }
  if (hints != NULL &&
      hints->ai_family != AF_UNSPEC &&
      hints->ai_family != family) {
    return 0;
  }

  struct addrinfo *info = calloc(1, sizeof(struct addrinfo));
  if (info == NULL) {
    return EAI_MEMORY;
  }
  info->ai_family = family;
  info->ai_socktype = hints == NULL ? 0 : hints->ai_socktype;
  info->ai_protocol = hints == NULL ? 0 : hints->ai_protocol;

  if (family == AF_INET) {
    struct sockaddr_in *socket_address = calloc(1, sizeof(struct sockaddr_in));
    if (socket_address == NULL) {
      free(info);
      return EAI_MEMORY;
    }
    socket_address->sin_family = AF_INET;
    socket_address->sin_port = htons(port);
    inet_pton(AF_INET, address, &socket_address->sin_addr);
    info->ai_addr = (struct sockaddr *)socket_address;
    info->ai_addrlen = sizeof(struct sockaddr_in);
  } else {
    struct sockaddr_in6 *socket_address =
        calloc(1, sizeof(struct sockaddr_in6));
    if (socket_address == NULL) {
      free(info);
      return EAI_MEMORY;
    }
    socket_address->sin6_family = AF_INET6;
    socket_address->sin6_port = htons(port);
    inet_pton(AF_INET6, address, &socket_address->sin6_addr);
    info->ai_addr = (struct sockaddr *)socket_address;
    info->ai_addrlen = sizeof(struct sockaddr_in6);
  }

  if (hints != NULL && (hints->ai_flags & AI_CANONNAME) != 0) {
    info->ai_canonname = strdup(hostname);
    if (info->ai_canonname == NULL) {
      free(info->ai_addr);
      free(info);
      return EAI_MEMORY;
    }
  }

  if (*tail == NULL) {
    *head = info;
  } else {
    (*tail)->ai_next = info;
  }
  *tail = info;
  return 0;
}

static int build_addrinfo(
    const AppDnsHostEntry *entry,
    const char *service,
    const struct addrinfo *hints,
    struct addrinfo **result) {
  uint16_t port = 0;
  if (!parse_port(service, hints, &port)) {
    return EAI_SERVICE;
  }

  struct addrinfo *head = NULL;
  struct addrinfo *tail = NULL;
  for (size_t i = 0; i < entry->address_count; i++) {
    const int code = append_addrinfo(
        &head,
        &tail,
        entry->addresses[i],
        entry->host,
        port,
        hints);
    if (code != 0) {
      if (head != NULL) {
        freeaddrinfo(head);
      }
      return code;
    }
  }

  if (head == NULL) {
    return EAI_NONAME;
  }
  *result = head;
  return 0;
}

static int original_getaddrinfo(
    const char *restrict hostname,
    const char *restrict service,
    const struct addrinfo *restrict hints,
    struct addrinfo **restrict result) {
  if (g_original_getaddrinfo == NULL) {
    g_original_getaddrinfo = dlsym(RTLD_NEXT, "getaddrinfo");
  }
  if (g_original_getaddrinfo == NULL) {
    return EAI_FAIL;
  }
  return g_original_getaddrinfo(hostname, service, hints, result);
}

static int app_dns_getaddrinfo(
    const char *restrict hostname,
    const char *restrict service,
    const struct addrinfo *restrict hints,
    struct addrinfo **restrict result) {
  if (result != NULL) {
    *result = NULL;
  }
  if (hostname == NULL ||
      result == NULL ||
      (hints != NULL && (hints->ai_flags & AI_NUMERICHOST) != 0)) {
    return original_getaddrinfo(hostname, service, hints, result);
  }

  char *host = copy_normalized_host(hostname);
  if (host == NULL) {
    return original_getaddrinfo(hostname, service, hints, result);
  }

  pthread_rwlock_rdlock(&g_lock);
  AppDnsHostEntry *entry = find_entry(host);
  int code = EAI_NONAME;
  if (entry != NULL) {
    code = build_addrinfo(entry, service, hints, result);
  }
  pthread_rwlock_unlock(&g_lock);

  free(host);
  return entry == NULL
      ? original_getaddrinfo(hostname, service, hints, result)
      : code;
}

int PiliPlusAppDnsSetHost(const char *host, const char *addresses) {
  char *normalized_host = copy_normalized_host(host);
  if (normalized_host == NULL || addresses == NULL) {
    free(normalized_host);
    return -1;
  }

  AppDnsHostEntry *new_entry = calloc(1, sizeof(AppDnsHostEntry));
  if (new_entry == NULL) {
    free(normalized_host);
    return -1;
  }
  new_entry->host = normalized_host;

  char *addresses_copy = strdup(addresses);
  if (addresses_copy == NULL) {
    free_entry(new_entry);
    return -1;
  }

  char *token = strtok(addresses_copy, "\n,; ");
  while (token != NULL) {
    int family = AF_UNSPEC;
    if (address_family(token, &family)) {
      char **items = realloc(
          new_entry->addresses,
          sizeof(char *) * (new_entry->address_count + 1));
      if (items == NULL) {
        free(addresses_copy);
        free_entry(new_entry);
        return -1;
      }
      new_entry->addresses = items;
      new_entry->addresses[new_entry->address_count] = strdup(token);
      if (new_entry->addresses[new_entry->address_count] == NULL) {
        free(addresses_copy);
        free_entry(new_entry);
        return -1;
      }
      new_entry->address_count++;
    }
    token = strtok(NULL, "\n,; ");
  }
  free(addresses_copy);

  if (new_entry->address_count == 0) {
    free_entry(new_entry);
    return -1;
  }

  pthread_rwlock_wrlock(&g_lock);
  AppDnsHostEntry **current = &g_hosts;
  while (*current != NULL) {
    if (strcmp((*current)->host, normalized_host) == 0) {
      AppDnsHostEntry *old = *current;
      new_entry->next = old->next;
      *current = new_entry;
      pthread_rwlock_unlock(&g_lock);
      free_entry(old);
      return 0;
    }
    current = &(*current)->next;
  }
  new_entry->next = g_hosts;
  g_hosts = new_entry;
  pthread_rwlock_unlock(&g_lock);
  return 0;
}

void PiliPlusAppDnsClearHosts(void) {
  pthread_rwlock_wrlock(&g_lock);
  AppDnsHostEntry *entry = g_hosts;
  g_hosts = NULL;
  pthread_rwlock_unlock(&g_lock);

  while (entry != NULL) {
    AppDnsHostEntry *next = entry->next;
    free_entry(entry);
    entry = next;
  }
}

__attribute__((used)) static struct {
  const void *replacement;
  const void *replacee;
} app_dns_interposers[] __attribute__((section("__DATA,__interpose"))) = {
    {(const void *)app_dns_getaddrinfo, (const void *)getaddrinfo},
};
