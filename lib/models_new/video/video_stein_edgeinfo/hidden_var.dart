/// 隐藏变量：/x/stein/edgeinfo_v2 的 `data.hidden_vars[n]`。
class HiddenVar {
  /// 变量 id（兼容格式，如 "H7g@PG2EVS"）
  String? id;

  /// 变量 id（主键，表达式引用时的 `$xxx`，如 "$H7g_64_PG2EVS"）
  String? idV2;

  /// 初始值（随机变量为服务端掷出的值；可能是整数、小数或数字字符串）
  double? value;

  /// 变量类型：1 普通变量；2 随机变量
  int? type;

  /// 是否展示给用户（作者设置）
  bool isShow;

  /// 变量名（展示用）
  String? name;

  /// 是否跳过覆盖：1 表示进入模块时保留会话当前值
  bool skipOverwrite;

  /// 原始 JSON（诊断用）
  final Map<String, dynamic>? raw;

  HiddenVar({
    this.id,
    this.idV2,
    this.value,
    this.type,
    this.isShow = false,
    this.name,
    this.skipOverwrite = false,
    this.raw,
  });

  static const int typeNormal = 1;
  static const int typeRandom = 2;

  bool get isRandom => type == typeRandom;

  static double? _asDouble(dynamic v) {
    if (v is num) {
      return v.toDouble();
    }
    if (v is String) {
      return double.tryParse(v);
    }
    return null;
  }

  factory HiddenVar.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return HiddenVar();
    }
    return HiddenVar(
      id: json['id'] is String ? json['id'] as String : null,
      idV2: json['id_v2'] is String ? json['id_v2'] as String : null,
      value: _asDouble(json['value']),
      type: json['type'] is int ? json['type'] as int : null,
      isShow: json['is_show'] is num ? (json['is_show'] as num) != 0 : false,
      name: json['name'] is String ? json['name'] as String : null,
      skipOverwrite: json['skip_overwrite'] is num
          ? (json['skip_overwrite'] as num) != 0
          : false,
      raw: json,
    );
  }

  /// 变量键：优先 id_v2（与表达式引用一致），回退 id。
  String get key => idV2 ?? id ?? '';
}
