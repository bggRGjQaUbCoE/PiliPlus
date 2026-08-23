import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/utils/video_utils.dart';
import 'package:dlna_dart/dlna.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

/// 会话级缓存：上次成功搜索到的投屏设备列表（key 为设备地址）。
/// 进入投屏页先复用它直接展示（可立即点击投屏），后台再重新搜索刷新；
/// 分享弹窗中也会列出所有已缓存设备，点击即可直接投屏。
final Map<String, DLNADevice> dlnaDeviceCache = {};

/// 投屏到指定设备。
Future<void> castDlnaDevice(
  DLNADevice device, {
  required String url,
  String? title,
}) async {
  await device.setUrl(url, title: title ?? '');
  await device.play();
}

/// 点击分享弹窗里的 DLNA 设备直接投屏
Future<void> castToCachedDevice({
  required DLNADevice device,
  required int cid,
  required int objectId,
  required int playurlType,
  required String? title,
  int? qn,
}) async {
  SmartDialog.showLoading(msg: '解析投屏地址...');
  try {
    final res = await VideoHttp.tvPlayUrl(
      cid: cid,
      objectId: objectId,
      playurlType: playurlType,
      qn: qn,
    );
    if (res case Success(response: final response)) {
      final first = response.durl?.firstOrNull;
      if (first == null || first.playUrls.isEmpty) {
        SmartDialog.dismiss();
        SmartDialog.showToast('不支持投屏');
        return;
      }
      final url = VideoUtils.getCdnUrl(first.playUrls);
      SmartDialog.showLoading(msg: '正在投屏到 ${device.info.friendlyName}...');
      await castDlnaDevice(device, url: url, title: title);
      SmartDialog.dismiss();
      SmartDialog.showToast('已投屏至 ${device.info.friendlyName}');
    } else {
      SmartDialog.dismiss();
      res.toast();
    }
  } catch (e) {
    SmartDialog.dismiss();
    SmartDialog.showToast('投屏失败: $e');
  }
}
