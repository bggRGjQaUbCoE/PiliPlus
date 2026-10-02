import 'package:PiliPlus/models/common/enum_with_label.dart';

/// Source used for the high-energy/danmaku-density progress chart.
enum DmChartSource with EnumWithLabel {
  disabled('禁用'),
  officialFirst('官方优先'),
  danmakuDensity('仅弹幕密度'),
  officialOnly('只用官方'),
  ;

  @override
  final String label;
  const DmChartSource(this.label);

  String get desc => switch (this) {
    disabled => '不显示高能进度条，也不请求相关数据',
    officialFirst => '优先使用 B 站官方数据，缺失时用弹幕密度生成',
    danmakuDensity => '始终根据弹幕列表计算密度曲线',
    officialOnly => '仅使用 B 站官方高能进度条数据',
  };

  bool get enableOfficial => switch (this) {
    officialFirst || officialOnly => true,
    _ => false,
  };

  bool get enableLocalDensity => switch (this) {
    officialFirst || danmakuDensity => true,
    _ => false,
  };

  bool get isEnabled => this != disabled;
}
