import 'package:PiliPlus/models_new/video/video_stein_edgeinfo/choice.dart';

/// 问题：/x/stein/edgeinfo_v2 的 `data.edges.questions[n]`。
class Question {
  /// 问题 id
  int? id;

  /// 选项显示模式：0 不显示选项；1 底部选项模式；2 坐标定点模式；3/127 未知
  int? type;

  /// 300 或 duration（官方语义未完全确认，见 [showAtOffset]）
  int? startTimeR;

  /// 回答限时（毫秒，-1 不限时）
  int? duration;

  /// 是否暂停播放视频
  bool pauseVideo;

  /// 问题标题（真实样本为空串）
  String? title;

  /// 选项列表
  List<Choice>? choices;

  /// 选项淡入时间（毫秒）
  int? fadeInTime;

  /// 选项淡出时间（毫秒）
  int? fadeOutTime;

  Question({
    this.id,
    this.type,
    this.startTimeR,
    this.duration,
    this.pauseVideo = false,
    this.title,
    this.choices,
    this.fadeInTime,
    this.fadeOutTime,
  });

  static const int typeNone = 0;
  static const int typeBottom = 1;
  static const int typeHotspot = 2;

  /// 不向用户展示选项（自动节点）
  bool get isAutoType => type == typeNone;

  /// 坐标定点模式
  bool get isHotspotType => type == typeHotspot;

  /// 底部选项模式
  bool get isBottomType => type == typeBottom;

  /// 回答是否限时
  bool get isTimed => (duration ?? -1) > 0;

  /// 淡入时长
  Duration get fadeIn =>
      Duration(milliseconds: (fadeInTime ?? 0).clamp(0, 1 << 31));

  /// 淡出时长
  Duration get fadeOut =>
      Duration(milliseconds: (fadeOutTime ?? 0).clamp(0, 1 << 31));

  /// 限时倒计时
  Duration? get countdown => isTimed ? Duration(milliseconds: duration!) : null;

  factory Question.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return Question();
    }
    return Question(
      id: _asInt(json['id']),
      type: _asInt(json['type']),
      startTimeR: _asInt(json['start_time_r']),
      duration: _asInt(json['duration']),
      pauseVideo: _asInt(json['pause_video']) != 0,
      title: json['title'] is String ? json['title'] as String : null,
      // 无 id 也无 cid 的脏数据（坏元素 / null）直接丢弃，不进入选项列表。
      choices: _list(
        json['choices'],
        Choice.fromJson,
      )?.where((Choice c) => c.id != null || c.cid != null).toList(),
      fadeInTime: _asInt(json['fade_in_time']),
      fadeOutTime: _asInt(json['fade_out_time']),
    );
  }

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

  static List<T>? _list<T>(dynamic list, T Function(dynamic) parse) {
    if (list is! List) {
      return null;
    }
    final List<T> result = <T>[];
    for (final dynamic item in list) {
      try {
        result.add(parse(item));
      } catch (_) {}
    }
    return result;
  }
}
