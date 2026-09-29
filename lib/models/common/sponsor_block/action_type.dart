import 'package:PiliPlus/l10n/l10n.dart';

enum ActionType {
  skip,
  mute,
  full,
  poi,
  ;

  String get title => switch (this) {
    skip => L10n.current.actionTypeSkipTitle,
    mute => L10n.current.actionTypeMuteTitle,
    full => L10n.current.actionTypeFullTitle,
    poi => L10n.current.actionTypePoiTitle,
  };
}
