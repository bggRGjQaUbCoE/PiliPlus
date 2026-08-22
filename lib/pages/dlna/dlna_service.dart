import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/video_utils.dart';
import 'package:dlna_dart/dlna.dart';

/// 会话级缓存：上次成功搜索到的投屏设备列表（key 为设备地址）。
/// 进入投屏页先复用它直接展示（可立即点击投屏），后台再重新搜索刷新；
/// 分享页也复用它直接列出设备投屏，无需重新搜索。
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

/// 把分享卡片内容解析成可投屏的媒体地址。
/// 目前仅支持 UGC 视频（`source == 5`，尽力而为，音频会自动失败）；
/// 直播/PGC/文章/动态的分享卡片不含可直接投屏的媒体地址，返回 null。
Future<String?> resolveCastUrl(Map content) async {
  try {
    if (content['source'] != 5) return null;
    final aid = int.tryParse('${content['id']}');
    if (aid == null) return null;
    final info = await VideoHttp.videoIntro(bvid: IdUtils.av2bv(aid));
    if (info case Success(response: final videoInfo)) {
      final cid = videoInfo.cid ?? videoInfo.pages?.firstOrNull?.cid;
      if (cid != null) {
        final play = await VideoHttp.tvPlayUrl(
          cid: cid,
          objectId: aid,
          playurlType: 1,
        );
        if (play case Success(response: final playInfo)) {
          final first = playInfo.durl?.firstOrNull;
          if (first != null && first.playUrls.isNotEmpty) {
            return VideoUtils.getCdnUrl(first.playUrls);
          }
        }
      }
    }
    return null;
  } catch (_) {
    return null;
  }
}
