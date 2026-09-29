import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/models/common/enum_with_label.dart';

enum BarHideType with EnumWithLabel {
  instant,
  sync,
  ;

  @override
  String get label => switch (this) {
    instant => L10n.current.barHideTypeInstantLabel,
    sync => L10n.current.barHideTypeSyncLabel,
  };
}
