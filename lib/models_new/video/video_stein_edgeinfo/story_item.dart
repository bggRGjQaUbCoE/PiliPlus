/// 进度回溯项：/x/stein/edgeinfo_v2 的 `data.story_list[n]`。
class StoryItem {
  /// 节点 id
  int? nodeId;

  /// 模块 id
  int? edgeId;

  /// 模块分P cid
  int? cid;

  /// 该模块在分P中的播放进度（毫秒，未播放为 0）
  int? startPosition;

  /// 封面
  String? cover;

  /// 是否为当前节点
  bool isCurrent;

  /// 回溯光标（0 表示不可回溯；>0 时可从 cursor 对应节点开始回溯）
  int? cursor;

  StoryItem({
    this.nodeId,
    this.edgeId,
    this.cid,
    this.startPosition,
    this.cover,
    this.isCurrent = false,
    this.cursor,
  });

  static int? _asInt(dynamic v) {
    if (v is int) {
      return v;
    }
    if (v is num) {
      return v.toInt();
    }
    if (v is String) {
      return int.tryParse(v) ?? double.tryParse(v)?.toInt();
    }
    return null;
  }

  factory StoryItem.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return StoryItem();
    }
    return StoryItem(
      nodeId: _asInt(json['node_id']),
      edgeId: _asInt(json['edge_id']),
      cid: _asInt(json['cid']),
      startPosition: _asInt(json['start_pos']),
      cover:
          json['cover'] is String && (json['cover'] as String).trim().isNotEmpty
          ? (json['cover'] as String).trim()
          : null,
      isCurrent: json['is_current'] is num
          ? (json['is_current'] as num) != 0
          : false,
      cursor: _asInt(json['cursor']),
    );
  }
}
