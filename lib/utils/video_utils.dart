import 'package:PiliPlus/models/common/video/cdn_type.dart';
import 'package:PiliPlus/models_new/live/live_room_play_info/codec.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/foundation.dart';

abstract final class VideoUtils {
  static String cdnService = Pref.defaultCDNService;
  static bool disableAudioCDN = Pref.disableAudioCDN;

  static const _proxyTf = 'proxy-tf-all-ws.bilivideo.com';

  static final _mirrorRegex = RegExp(
    r'^https?://(?:upos-\w+-(?!302)\w+|(?:upos|proxy)-tf-[^/]+)\.(?:bilivideo|akamaized)\.(?:com|net)/upgcxcode',
  );

  static final _mCdnTfRegex = RegExp(
    r'^https?://(?:(?:(?:\d{1,3}\.){3}\d{1,3}|[^/]+\.mcdn\.bilivideo\.(?:com|cn|net))(?:\:\d{1,5})?/v\d/resource)',
  );

  static String getCdnUrl(
    Iterable<String> urls, {
    String? defaultCDNService,
    bool isAudio = false,
  }) {
    defaultCDNService ??= cdnService;
    late final defaultCDNHost = CDNService.fromCode(defaultCDNService!).host;

    if (defaultCDNService == CDNService.baseUrl.code) {
      return urls.first;
    }

    String? mcdnTf;
    String? mcdnUpgcxcode;

    String last = '';
    for (var url in urls) {
      last = url;
      if (_mirrorRegex.hasMatch(url)) {
        final uri = Uri.parse(url);
        if (uri.queryParameters['os'] == 'mcdn') {
          // upos-sz-mirrorcoso1.bilivideo.com os=mcdn
          mcdnUpgcxcode = url;
        } else {
          if (defaultCDNService == CDNService.backupUrl.code ||
              (isAudio && disableAudioCDN)) {
            return url;
          }
          return uri.replace(host: defaultCDNHost).toString();
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
        final hostname = uri.queryParameters['xy_usource'] ?? defaultCDNHost;
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
              .replace(
                host: defaultCDNService.isEmpty
                    ? CDNService.ali.host
                    : defaultCDNService,
              )
              .toString();
  }

  static String getLiveCdnUrl(CodecItem e) {
    return e.urlInfo!.first.host! + e.baseUrl! + e.urlInfo!.first.extra!;
  }
}
