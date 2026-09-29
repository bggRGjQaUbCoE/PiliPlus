import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/models/common/enum_with_label.dart';

enum UpPanelPosition implements EnumWithLabel {
  top,
  leftFixed,
  rightFixed,
  leftDrawer,
  rightDrawer,
  ;

  @override
  String get label => switch (this) {
    top => L10n.current.upPanelPositionTopLabel,
    leftFixed => L10n.current.upPanelPositionLeftFixedLabel,
    rightFixed => L10n.current.upPanelPositionRightFixedLabel,
    leftDrawer => L10n.current.upPanelPositionLeftDrawerLabel,
    rightDrawer => L10n.current.upPanelPositionRightDrawerLabel,
  };
}
