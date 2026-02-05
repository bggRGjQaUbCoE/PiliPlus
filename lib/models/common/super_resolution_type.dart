import 'package:PiliPlus/models/common/enum_with_label.dart';

enum SuperResolutionType with EnumWithLabel {
  disable('禁用'),
  efficiency('效率'),
  quality('画质')
  ;

  @override
  final String label;
  const SuperResolutionType(this.label);
}
