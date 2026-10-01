/// API-issued addresses are retained verbatim. Synthetic mirrors are limited
/// to ordinary HTTPS upgcxcode URLs; peer, redirect and Akamai URLs are not donors.
class CdnResolver {
  static List<Uri> resolve({
    required String original,
    required Iterable<String> playUrls,
    Iterable<String> mirrorHosts = const [],
    bool allowMirrors = true,
  }) {
    final result = <Uri>[];
    void add(String value) {
      final uri = Uri.tryParse(value);
      if (uri == null ||
          !['http', 'https'].contains(uri.scheme) ||
          uri.host.isEmpty ||
          uri.userInfo.isNotEmpty) {
        return;
      }
      if (!result.contains(uri)) result.add(uri);
    }

    add(original);
    for (final url in playUrls) {
      add(url);
    }
    if (allowMirrors) {
      final donors = result.where(
        (u) =>
            u.scheme == 'https' &&
            !u.hasPort &&
            RegExp(r'^upos-[\w]+-(?!302)[\w]+\.bilivideo\.com$')
                .hasMatch(u.host) &&
            u.path.startsWith('/upgcxcode/') &&
            u.queryParameters['os'] != 'mcdn',
      );
      final donor = donors.firstOrNull;
      if (donor != null) {
        for (final host in mirrorHosts) {
          if (RegExp(r'^[a-z0-9-]+\.bilivideo\.com$').hasMatch(host)) {
            add(donor.replace(host: host).toString());
          }
        }
      }
    }
    return List.unmodifiable(result);
  }
}
