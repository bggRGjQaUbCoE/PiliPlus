import 'package:PiliPlus/models/common/enum_with_label.dart';

/// 首页推荐来源
///
/// - [app]：官方 App 端推荐接口（`/x/v2/feed/index`）
/// - [web]：主页 Web 端推荐接口（`/x/web-interface/wbi/index/top/feed/rcmd`）
/// - [desktop]：与 Web 端同一个公开网页接口，改用哔哩哔哩官方 Windows
///   客户端首页实际发送的参数组合（`plat=1`、`feed_version=V1`、
///   `fresh_type` 操作类型、`x_num`/`y_num` 网格尺寸、`ps=30`），
///   不涉及私有接口或设备指纹。
enum RcmdSource implements EnumWithLabel {
  app('App 端'),
  web('Web 端'),
  desktop('桌面端 / PC'),
  ;

  @override
  final String label;

  const RcmdSource(this.label);
}
