import 'package:PiliPlus/models/video/play/CDN.dart';
import 'package:PiliPlus/models/video/play/url.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter/material.dart';

import '../models/live/room_info.dart';

class VideoUtils {
  static String getCdnUrl(dynamic item, [defaultCDNService]) {
    String? backupUrl;
    String? videoUrl;
    defaultCDNService ??= GStorage.setting
        .get(SettingBoxKey.CDNService, defaultValue: CDNService.backupUrl.code);
    if (item is AudioItem) {
      if (GStorage.setting
          .get(SettingBoxKey.disableAudioCDN, defaultValue: true)) {
        return item.backupUrl.isNullOrEmpty.not
            ? item.backupUrl!
            : item.baseUrl ?? "";
      }
    }
    if (defaultCDNService == CDNService.baseUrl.code) {
      return (item.baseUrl as String?).isNullOrEmpty.not
          ? item.baseUrl
          : item.backupUrl ?? "";
    }
    if (item is CodecItem) {
      backupUrl = (item.urlInfo?.first.host)! +
          item.baseUrl! +
          item.urlInfo!.first.extra!;
    } else {
      backupUrl = item.backupUrl;
    }
    if (defaultCDNService == CDNService.backupUrl.code) {
      return backupUrl.isNullOrEmpty.not ? backupUrl : item.baseUrl ?? "";
    }
    videoUrl = backupUrl.isNullOrEmpty ? item.baseUrl : backupUrl;

    if (videoUrl.isNullOrEmpty) {
      return "";
    }
    debugPrint("videoUrl:$videoUrl");

    String defaultCDNHost = CDNServiceCode.fromCode(defaultCDNService)!.host;
    debugPrint("defaultCDNHost:$defaultCDNHost");
    if (videoUrl!.contains("szbdyd.com")) {
      final uri = Uri.parse(videoUrl);
      String hostname = uri.queryParameters['xy_usource'] ?? defaultCDNHost;
      videoUrl = uri.replace(host: hostname, port: 443).toString();
    } else if (videoUrl.contains(".mcdn.bilivideo") ||
        videoUrl.contains("/upgcxcode/")) {
      videoUrl = Uri.parse(videoUrl)
          .replace(host: defaultCDNHost, port: 443)
          .toString();
      // videoUrl =
      //     'https://proxy-tf-all-ws.bilivideo.com/?url=${Uri.encodeComponent(videoUrl)}';
    }
    debugPrint("videoUrl:$videoUrl");

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
