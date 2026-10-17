import 'package:PiliPlus/models_new/video/video_detail/episode.dart';

/// 选项：/x/stein/edgeinfo_v2 的 `data.edges.questions[n].choices[m]`。
/// 继承 [BaseEpisodeItem] 以复用切集逻辑；`id` 是下一模块的 edge_id，`cid`
/// 是下一模块分P cid。
class Choice extends BaseEpisodeItem {
  /// 选项文案，如 "A <你现在的身份是萌新> 开始循环！"
  String? option;

  /// 客户端内置动作（如 "JUMP 22453494 245681715"），本项目暂不执行
  String? platformAction;

  /// 变量运算语句（如 `$a=$a+1.00;$b=$b-2.00`），进入下一模块前执行
  String? nativeAction;

  /// 展示条件表达式（如 `$a>=1.00 && $a<=80.00`），空串视为无条件
  String? condition;

  /// 是否为默认选项（倒计时结束/自动节点提交）
  bool isDefault;

  /// 是否隐藏（不作为普通按钮展示，可参与条件自动跳转）
  bool isHidden;

  /// 坐标定点模式的横坐标（接口 x，原始视频像素）。
  double? x;

  /// 坐标定点模式的纵坐标（接口 y，原始视频像素）。
  double? y;

  /// 接口提供的文字对齐方式。
  int? textAlign;

  /// 旧客户端百分比坐标，保留但不与 x/y 混用。
  double? posX;

  /// 坐标定点模式的纵坐标（视频高度的百分比，0-100）
  double? posY;

  /// 坐标定点模式图标的宽（视频宽度的百分比）
  double? fuxianX;

  /// 坐标定点模式的图标高（视频高度的百分比）
  double? fuxianY;

  /// 原始 JSON（诊断用）
  Map<String, dynamic>? raw;

  Choice({
    this.option,
    this.platformAction,
    this.nativeAction,
    this.condition,
    this.isDefault = false,
    this.isHidden = false,
    this.x,
    this.y,
    this.textAlign,
    this.posX,
    this.posY,
    this.fuxianX,
    this.fuxianY,
    this.raw,
    super.id,
    super.cid,
    super.aid,
    super.epId,
    super.bvid,
    super.badge,
    super.title,
    super.cover,
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

  static double? _asDouble(dynamic v) {
    if (v is num) {
      return v.toDouble();
    }
    if (v is String) {
      return double.tryParse(v);
    }
    return null;
  }

  static bool _flag(dynamic v) => v is num ? v != 0 : false;

  factory Choice.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return Choice();
    }
    return Choice(
      id: _asInt(json['id']),
      cid: _asInt(json['cid']),
      option: json['option'] is String ? json['option'] as String : null,
      platformAction: json['platform_action'] is String
          ? json['platform_action'] as String
          : null,
      nativeAction: json['native_action'] is String
          ? json['native_action'] as String
          : null,
      condition: json['condition'] is String
          ? json['condition'] as String
          : null,
      isDefault: _flag(json['is_default']),
      isHidden: _flag(json['is_hidden']),
      x: _asDouble(json['x']),
      y: _asDouble(json['y']),
      textAlign: _asInt(json['text_align']),
      posX: _asDouble(json['pos_x']),
      posY: _asDouble(json['pos_y']),
      fuxianX: _asDouble(json['fuxian_x']),
      fuxianY: _asDouble(json['fuxian_y']),
      aid: _asInt(json['aid']),
      epId: _asInt(json['ep_id'] ?? json['epid']),
      bvid: json['bvid'] is String ? json['bvid'] as String : null,
      badge: json['badge'] is String ? json['badge'] as String : null,
      title: json['title'] is String ? json['title'] as String : null,
      cover: json['cover'] is String ? json['cover'] as String : null,
      raw: json,
    );
  }

  @override
  String toString() => 'Choice(id:$id, cid:$cid, option:$option)';
}
