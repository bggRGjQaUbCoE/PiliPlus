import 'package:PiliPlus/models/common/video/cdn_type.dart';
import 'package:PiliPlus/models/video/play/url.dart';
import 'package:PiliPlus/models_new/live/live_room_play_info/codec.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/storage_pref.dart';

abstract class VideoUtils {
  static String cdnService = Pref.defaultCDNService;
  static bool disableAudioCDN = Pref.disableAudioCDN;

  static String getCdnUrl(dynamic item, [String? defaultCDNService]) {
    String? backupUrl;
    String? videoUrl;
    defaultCDNService ??= cdnService;
    if (item is AudioItem) {
      if (disableAudioCDN) {
        return item.backupUrl?.isNotEmpty == true
            ? item.backupUrl!
            : item.baseUrl ?? "";
      }
    }
    if (defaultCDNService == CDNService.baseUrl.code) {
      return (item.baseUrl as String?)?.isNotEmpty == true
          ? item.baseUrl
          : item.backupUrl ?? "";
    }
    if (item is CodecItem) {
      backupUrl =
          (item.urlInfo?.first.host)! +
          item.baseUrl! +
          item.urlInfo!.first.extra!;
    } else {
      backupUrl = item.backupUrl;
    }
    if (defaultCDNService == CDNService.backupUrl.code) {
      return backupUrl?.isNotEmpty == true ? backupUrl : item.baseUrl ?? "";
    }
    videoUrl = backupUrl?.isNotEmpty == true ? backupUrl : item.baseUrl;

    if (videoUrl.isNullOrEmpty) {
      return "";
    }
    // if (kDebugMode) debugPrint("videoUrl:$videoUrl");

    String defaultCDNHost = CDNService.fromCode(defaultCDNService).host;
    // if (kDebugMode) debugPrint("defaultCDNHost:$defaultCDNHost");
    if (videoUrl!.contains("szbdyd.com")) {
      final uri = Uri.parse(videoUrl);
      String hostname = uri.queryParameters['xy_usource'] ?? defaultCDNHost;
      videoUrl = uri.replace(host: hostname, port: 443).toString();
    } else if (videoUrl.contains(".mcdn.bilivideo") ||
        videoUrl.contains("/upgcxcode/")) {
      videoUrl = Uri.parse(
        videoUrl,
      ).replace(host: defaultCDNHost, port: 443).toString();
      // videoUrl =
      //     'https://proxy-tf-all-ws.bilivideo.com/?url=${Uri.encodeComponent(videoUrl)}';
    }
    // if (kDebugMode) debugPrint("videoUrl:$videoUrl");

    // /// 先获取backupUrl 一般是upgcxcode地址 播放更稳定
    // if (item is VideoItem) {
    //   backupUrl = item.backupUrl ?? "";
    //   videoUrl = backupUrl.contains("http") ? backupUrl : (item.baseUrl ?? "");
    // } else if (item is AudioItem) {
    //   backupUrl = item.backupUrl ?? "";
    //   videoUrl = backupUrl.contains("http") ? backupUrl : (item.baseUrl ?? "");
    // } else if (item is CodecItem) {
    //   backupUrl = (item.urlInfo?.first.host)! +
    //       item.baseUrl! +
    //       item.urlInfo!.first.extra!;
    //   videoUrl = backupUrl.contains("http") ? backupUrl : (item.baseUrl ?? "");
    // } else {
    //   return "";
    // }
    //
    // /// issues #70
    // if (videoUrl.contains(".mcdn.bilivideo")) {
    //   videoUrl =
    //       'https://proxy-tf-all-ws.bilivideo.com/?url=${Uri.encodeComponent(videoUrl)}';
    // } else if (videoUrl.contains("/upgcxcode/")) {
    //   //CDN列表
    //   var cdnList = {
    //     'ali': 'upos-sz-mirrorali.bilivideo.com',
    //     'cos': 'upos-sz-mirrorcos.bilivideo.com',
    //     'hw': 'upos-sz-mirrorhw.bilivideo.com',
    //   };
    //   //取一个CDN
    //   var cdn = cdnList['cos'] ?? "";
    //   var reg = RegExp(r'(http|https)://(.*?)/upgcxcode/');
    //   videoUrl = videoUrl.replaceAll(reg, "https://$cdn/upgcxcode/");
    // }

    return videoUrl;
  }
}
