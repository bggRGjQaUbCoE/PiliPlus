bool isSameOrSubdomain(String host, String domain) {
  String normalize(String value) {
    final normalized = value.toLowerCase();
    return normalized.endsWith('.')
        ? normalized.substring(0, normalized.length - 1)
        : normalized;
  }

  host = normalize(host);
  domain = normalize(domain);
  return host == domain || host.endsWith('.$domain');
}
