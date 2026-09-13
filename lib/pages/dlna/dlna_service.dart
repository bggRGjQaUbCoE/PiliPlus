import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/video_utils.dart';
import 'package:dlna_dart/dlna.dart';
import 'package:dlna_dart/xmlParser.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

/// 内存中的投屏设备列表缓存
final Map<String, DLNADevice> dlnaDeviceCache = {};

/// 从持久化存储（Hive localCache）初始化设备缓存
void initDlnaDeviceCache() {
  if (dlnaDeviceCache.isNotEmpty) return;
  try {
    final raw = GStorage.localCache.get(LocalCacheKey.dlnaDevices);
    if (raw is List) {
      for (final item in raw) {
        if (item is Map) {
          final urlBase = item['URLBase']?.toString() ?? '';
          final deviceType = item['deviceType']?.toString() ?? '';
          final friendlyName = item['friendlyName']?.toString() ?? '';
          final rawServiceList = item['serviceList'];
          final List<dynamic> serviceList = rawServiceList is List
              ? rawServiceList.map((e) => e is Map ? Map<String, dynamic>.from(e) : e).toList()
              : [];
          if (urlBase.isNotEmpty && friendlyName.isNotEmpty) {
            final info = DeviceInfo(urlBase, deviceType, friendlyName, serviceList);
            dlnaDeviceCache[urlBase] = DLNADevice(info);
          }
        }
      }
    }
  } catch (e) {
    // 忽略异常，降级为空缓存
  }
}

/// 保存搜到的设备列表并持久化存储
void saveDlnaDevices(Map<String, DLNADevice> devices) {
  dlnaDeviceCache.addAll(devices);
  try {
    final list = dlnaDeviceCache.values.map((device) {
      final info = device.info;
      return {
        'URLBase': info.URLBase,
        'deviceType': info.deviceType,
        'friendlyName': info.friendlyName,
        'serviceList': info.serviceList,
      };
    }).toList();
    GStorage.localCache.put(LocalCacheKey.dlnaDevices, list);
  } catch (e) {
    // 忽略异常
  }
}

/// 把媒体投到指定设备
Future<void> castDlnaDevice(
  DLNADevice device, {
  required String url,
  String? title,
}) async {
  await device.setUrl(url, title: title ?? '');
  await device.play();
}
/// 通用快捷投屏到指定已缓存设备
Future<void> castToCachedDevice({
  required DLNADevice device,
  required int cid,
  required int objectId,
  required int playurlType,
  String? title,
  int? qn,
}) async {
  SmartDialog.showLoading(msg: '正在投屏至 ${device.info.friendlyName}...');
  try {
    final play = await VideoHttp.tvPlayUrl(
      cid: cid,
      objectId: objectId,
      playurlType: playurlType,
      qn: qn ?? 80,
    );
    if (play case Success(response: final playInfo)) {
      final first = playInfo.durl?.firstOrNull;
      if (first != null && first.playUrls.isNotEmpty) {
        final cdnUrl = VideoUtils.getCdnUrl(first.playUrls);
        await castDlnaDevice(device, url: cdnUrl, title: title);
        SmartDialog.dismiss();
        SmartDialog.showToast('已投屏至 ${device.info.friendlyName}');
        return;
      }
    }
    SmartDialog.dismiss();
    SmartDialog.showToast('投屏失败: 无法获取播放地址');
  } catch (e) {
    SmartDialog.dismiss();
    SmartDialog.showToast('投屏失败: $e');
  }
}

/// 从 UGC 视频上下文解析可投屏的播放地址（按当前选中的清晰度与 CDN）
Future<String?> resolveUgcCastUrl({
  required int aid,
  required int cid,
  required int videoQa,
}) async {
  try {
    final play = await VideoHttp.tvPlayUrl(
      cid: cid,
      objectId: aid,
      playurlType: 1,
      qn: videoQa,
    );
    if (play case Success(response: final playInfo)) {
      final first = playInfo.durl?.firstOrNull;
      if (first != null && first.playUrls.isNotEmpty) {
        return VideoUtils.getCdnUrl(first.playUrls);
      }
    }
    return null;
  } catch (_) {
    return null;
  }
}

/// 从 PGC 影视上下文解析可投屏的播放地址
Future<String?> resolvePgcCastUrl({
  required int epId,
  required int cid,
  required int videoQa,
}) async {
  try {
    final play = await VideoHttp.tvPlayUrl(
      cid: cid,
      objectId: epId,
      playurlType: 2,
      qn: videoQa,
    );
    if (play case Success(response: final playInfo)) {
      final first = playInfo.durl?.firstOrNull;
      if (first != null && first.playUrls.isNotEmpty) {
        return VideoUtils.getCdnUrl(first.playUrls);
      }
    }
    return null;
  } catch (_) {
    return null;
  }
}
