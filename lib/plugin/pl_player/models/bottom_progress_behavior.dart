import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/models/common/enum_with_label.dart';

enum BtmProgressBehavior implements EnumWithLabel {
  alwaysShow,
  alwaysHide,
  onlyShowFullScreen,
  onlyHideFullScreen,
  ;

  @override
  String get label => switch (this) {
    alwaysShow => L10n.current.btmProgressBehaviorAlwaysShowLabel,
    alwaysHide => L10n.current.btmProgressBehaviorAlwaysHideLabel,
    onlyShowFullScreen =>
      L10n.current.btmProgressBehaviorOnlyShowFullScreenLabel,
    onlyHideFullScreen =>
      L10n.current.btmProgressBehaviorOnlyHideFullScreenLabel,
  };
}
