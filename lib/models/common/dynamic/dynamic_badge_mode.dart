import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/models/common/enum_with_label.dart';

enum DynamicBadgeMode implements EnumWithLabel {
  hidden,
  point,
  number,
  ;

  @override
  String get label => switch (this) {
    hidden => L10n.current.hide,
    point => L10n.current.dynamicBadgeModePointLabel,
    number => L10n.current.dynamicBadgeModeNumberLabel,
  };
}
