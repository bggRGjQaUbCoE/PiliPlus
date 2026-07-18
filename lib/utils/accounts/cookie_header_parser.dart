import 'dart:io';

typedef ParsedCookieHeader = ({Map<String, String> cookies, String header});

ParsedCookieHeader parseCookieHeader(String source) {
  final cookies = <String, String>{};
  for (final segment in source.split(';')) {
    try {
      final cookie = Cookie.fromSetCookieValue(segment.trim());
      cookies[cookie.name] = cookie.value;
    } on FormatException {
      continue;
    } on HttpException {
      continue;
    }
  }

  final validatedCookies = Map<String, String>.unmodifiable(cookies);
  return (
    cookies: validatedCookies,
    header: validatedCookies.entries
        .map((entry) => '${entry.key}=${entry.value}')
        .join('; '),
  );
}
