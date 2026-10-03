/// 列表（收藏夹、稍后再看等）中可缓存视频的基本信息
class DownloadVideoInfo {
  /// av 号
  final int avid;

  /// bv 号
  final String bvid;

  /// 分 p cid
  final int cid;

  /// 视频标题
  final String title;

  /// 封面
  final String cover;

  /// 时长（秒）
  final int duration;

  /// 弹幕数
  final int danmaku;

  /// up 主 mid
  final int? ownerId;

  /// up 主昵称
  final String? ownerName;

  const DownloadVideoInfo({
    required this.avid,
    required this.bvid,
    required this.cid,
    required this.title,
    required this.cover,
    this.duration = 0,
    this.danmaku = 0,
    this.ownerId,
    this.ownerName,
  });
}
