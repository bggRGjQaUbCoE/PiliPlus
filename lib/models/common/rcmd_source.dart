import 'package:PiliPlus/models/common/enum_with_label.dart';

/// 首页推荐来源
///
/// - [app]：官方 App 端推荐接口（`/x/v2/feed/index`）
/// - [web]：主页 Web 端推荐接口（`/x/web-interface/wbi/index/top/feed/rcmd`）
/// - [desktop]：与 Web 端同一个公开接口，但使用 PC 端的公开参数组合
///   （`fresh_type=8`、`web_location=1430650`、`fresh_idx_1h`、`ps=30`），
///   参数依据见 bilibili-API-collect「获取首页视频推荐列表（web端）」
///   与 Bilibili-Gate 的 PC 桌面端推荐参数，不涉及私有接口或设备指纹。
enum RcmdSource implements EnumWithLabel {
  app('App 端'),
  web('Web 端'),
  desktop('桌面端 / PC'),
  ;

  @override
  final String label;

  const RcmdSource(this.label);
}
