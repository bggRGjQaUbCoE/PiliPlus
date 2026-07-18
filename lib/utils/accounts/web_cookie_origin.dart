String webCookieOrigin(String? domain) {
  var host = domain?.trim();
  while (host?.startsWith('.') == true) {
    host = host!.substring(1);
  }
  if (host == null || host.isEmpty) {
    throw ArgumentError.value(
      domain,
      'domain',
      'must contain a cookie domain',
    );
  }
  return Uri(scheme: 'https', host: host, path: '/').toString();
}
