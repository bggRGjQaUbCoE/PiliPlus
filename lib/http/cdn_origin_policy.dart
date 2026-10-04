/// Region groups follow Bilibili-thread-ripper's mainland service-host list.
/// They describe the intended route, not a live IP geolocation guarantee.
/// Source: MrTangLuyao/Bilibili-thread-ripper, ee870916, src/cdn-resolver.js.
final class CdnOrigin {
  const CdnOrigin(this.uri, {this.mainland = false});
  final Uri uri;
  final bool mainland;
}

typedef CdnOriginResolver = List<CdnOrigin> Function(List<Uri> originals);

abstract final class CdnOriginPolicy {
  static const mainlandHosts = [
    'upos-sz-mirrorali.bilivideo.com',
    'upos-sz-mirrorhw.bilivideo.com',
    'upos-sz-mirrorbos.bilivideo.com',
    'upos-sz-mirror08c.bilivideo.com',
    'upos-sz-mirrorbd.bilivideo.com',
    'upos-sz-mirror14b.bilivideo.com',
    'upos-sz-estgoss.bilivideo.com',
    'upos-sz-mirrorcos.bilivideo.com',
  ];

  /// Startup preference only. The first useful range wins; geography is not a
  /// requirement. Keep Huawei as the known-good baseline, then API alternatives.
  static List<CdnOrigin> measured(List<Uri> originals) {
    final all = resolve(originals);
    final seen = <Uri>{};
    return [
      for (final origin in [
        ...all
            .where((o) => o.uri.host == 'upos-sz-mirrorhw.bilivideo.com')
            .take(1),
        ...originals.map(CdnOrigin.new),
        ...all,
      ])
        if (seen.add(origin.uri)) CdnOrigin(origin.uri),
    ];
  }

  static bool isMedia(Uri uri) {
    final host = uri.host.toLowerCase();
    return (uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.userInfo.isEmpty &&
        (!uri.hasPort || uri.port == 80 || uri.port == 443) &&
        const [
          'bilivideo.com',
          'bilivideo.cn',
          'bilivideo.net',
          'akamaized.net',
        ].any((domain) => host == domain || host.endsWith('.$domain')) &&
        uri.path.startsWith('/upgcxcode/') &&
        (uri.path.endsWith('.m4s') || uri.path.endsWith('.mp4'));
  }

  /// Never rank by latency or throughput. API alternatives must refer to the
  /// same path; each CDN will also be checked for matching bytes before use.
  static List<CdnOrigin> resolve(List<Uri> originals) {
    if (originals.isEmpty) return const [];
    final sources = originals
        .where((uri) => uri.path == originals.first.path)
        .take(4)
        .toList();
    final result = <CdnOrigin>[];
    final seen = <Uri>{};
    void add(Uri uri, bool mainland) {
      if (seen.add(uri)) result.add(CdnOrigin(uri, mainland: mainland));
    }

    final hostOrder = <String>{
      for (final uri in sources)
        if (mainlandHosts.contains(uri.host.toLowerCase()))
          uri.host.toLowerCase(),
      ...mainlandHosts,
    };
    final byHost = <String, List<Uri>>{
      for (final host in hostOrder) host: [],
    };
    void queue(Uri uri) {
      final candidates = byHost[uri.host.toLowerCase()]!;
      if (!candidates.contains(uri)) candidates.add(uri);
    }

    for (final uri in sources) {
      if (mainlandHosts.contains(uri.host.toLowerCase())) queue(uri);
    }
    // Known ordinary VOD paths only: never rewrite peer-CDN /vN/resource URLs.
    // Keep API-provided addresses first for their hosts, then retain every
    // other signed donor as a later candidate for that same host.
    for (final uri in sources.where(isMedia)) {
      for (final host in hostOrder) {
        queue(
          uri.replace(host: host, port: uri.scheme == 'https' ? 443 : 80),
        );
      }
    }
    // Emit one address per host each round. Multiple signatures must not make
    // consecutive chunks use the same CDN before trying other mainland hosts.
    for (var round = 0; ; round++) {
      var found = false;
      for (final candidates in byHost.values) {
        if (round < candidates.length) {
          add(candidates[round], true);
          found = true;
        }
      }
      if (!found) break;
    }
    for (final uri in sources) {
      add(uri, mainlandHosts.contains(uri.host.toLowerCase()));
    }
    return result;
  }
}
