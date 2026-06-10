import 'package:PiliPlus/models/common/video/cdn_type.dart';
import 'package:PiliPlus/models_new/live/live_room_play_info/codec.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;

abstract final class VideoUtils {
  static CDNService cdnService = Pref.defaultCDNService;
  static String? customCDNUrl = _readCustomCDNUrl();
  static String? liveCdnUrl = Pref.liveCdnUrl;
  static bool disableAudioCDN = Pref.disableAudioCDN;

  static const _proxyTf = 'proxy-tf-all-ws.bilivideo.com';

  static const _replaceableCdnHostParts = [
    'bilivideo',
    'acgvideo',
    'edge.mountaintoys.cn',
    'akamaized.net',
  ];

  static const _apiHostParts = [
    'api',
    'bvc',
    'data',
    'pbp',
  ];

  static final _mirrorRegex = RegExp(
    r'^https?://(?:upos-\w+-(?!302)\w+|(?:upos|proxy)-tf-[^/]+)\.(?:bilivideo|akamaized)\.(?:com|net)/upgcxcode',
  );

  static final _mCdnTfRegex = RegExp(
    r'^https?://(?:(?:(?:\d{1,3}\.){3}\d{1,3}|[^/]+\.mcdn\.bilivideo\.(?:com|cn|net))(?:\:\d{1,5})?/v\d/resource)',
  );

  static String getCdnUrl(
    Iterable<String> urls, {
    CDNService? defaultCDNService,
    String? customCDNUrl,
    bool isAudio = false,
  }) {
    defaultCDNService ??= cdnService;
    customCDNUrl = normalizeCustomCDNHost(
      customCDNUrl ?? VideoUtils.customCDNUrl,
    );

    if (customCDNUrl != null && !(isAudio && disableAudioCDN)) {
      for (final url in urls) {
        final replaced = _replaceWithCustomCdn(url, customCDNUrl);
        if (replaced != null) {
          return replaced;
        }
      }
    }

    if (defaultCDNService == CDNService.baseUrl) {
      return urls.first;
    }

    String? mcdnTf;
    String? mcdnUpgcxcode;

    String last = '';
    for (final url in urls) {
      last = url;
      if (_mirrorRegex.hasMatch(url)) {
        final uri = Uri.parse(url);
        if (uri.queryParameters['os'] == 'mcdn') {
          // upos-sz-mirrorcoso1.bilivideo.com os=mcdn
          mcdnUpgcxcode = url;
        } else {
          if (defaultCDNService == CDNService.backupUrl ||
              (isAudio && disableAudioCDN)) {
            return url;
          }
          return uri.replace(host: defaultCDNService.host).toString();
        }
      }

      if (_mCdnTfRegex.hasMatch(url)) {
        mcdnTf = url;
        continue;
      }

      // upos-\w*-302.* & bcache & mcdn host but upgcxcode path
      if (url.contains('/upgcxcode/')) {
        mcdnUpgcxcode = url;
        continue;
      }

      // may be deprecated
      if (url.contains('szbdyd.com')) {
        final uri = Uri.parse(url);
        final hostname =
            uri.queryParameters['xy_usource'] ?? defaultCDNService.host;
        return uri
            .replace(scheme: 'https', host: hostname, port: 443)
            .toString();
      }

      if (kDebugMode) {
        debugPrint('unknown cdn type: $url');
      }
    }

    return mcdnUpgcxcode == null
        ? mcdnTf == null
              ? last
              : Uri(
                  scheme: 'https',
                  host: _proxyTf,
                  queryParameters: {'url': mcdnTf},
                ).toString()
        : Uri.parse(mcdnUpgcxcode)
              .replace(host: defaultCDNService.host ?? CDNService.ali.host)
              .toString();
  }

  static String? normalizeCustomCDNHost(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }

    final uri = Uri.tryParse(trimmed);
    if (uri == null) {
      return null;
    }

    if (uri.hasScheme) {
      return uri.host.isEmpty ? null : uri.host;
    }

    if (trimmed.contains('/') ||
        trimmed.contains('?') ||
        trimmed.contains('#')) {
      return null;
    }
    return trimmed;
  }

  static String effectiveCdnDesc({
    CDNService? service,
    String? customCDNUrl,
  }) {
    final host = normalizeCustomCDNHost(
      customCDNUrl ?? VideoUtils.customCDNUrl,
    );
    return host == null ? (service ?? cdnService).desc : '自定义：$host';
  }

  static String? _replaceWithCustomCdn(String url, String customHost) {
    final uri = Uri.tryParse(url);
    if (uri == null || uri.host.isEmpty) {
      return null;
    }
    if (!_isReplaceableMediaHost(uri.host)) {
      return null;
    }
    return uri.replace(host: customHost).toString();
  }

  static bool _isReplaceableMediaHost(String host) {
    final lowerHost = host.toLowerCase();
    if (_apiHostParts.any(lowerHost.contains)) {
      return false;
    }
    return _replaceableCdnHostParts.any(lowerHost.contains);
  }

  static String? _readCustomCDNUrl() {
    try {
      return Pref.customCDNUrl;
    } catch (_) {
      return null;
    }
  }

  static String getLiveCdnUrl(CodecItem e) {
    return (liveCdnUrl ?? e.urlInfo!.first.host!) +
        e.baseUrl! +
        e.urlInfo!.first.extra!;
  }
}
