import 'package:PiliPlus/models/common/enum_with_label.dart';

enum SuperChatType implements EnumWithLabel {
  valid('有效时间内显示'),
  persist('常驻显示'),
  disable('不显示'),
  ;

  @override
  final String label;
  const SuperChatType(this.label);
}
