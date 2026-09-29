import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/models/common/enum_with_label.dart';

enum PlayRepeat implements EnumWithLabel {
  pause,
  listOrder,
  singleCycle,
  listCycle,
  autoPlayRelated,
  ;

  @override
  String get label => switch (this) {
    pause => L10n.current.playRepeatPauseLabel,
    listOrder => L10n.current.playSequentially,
    singleCycle => L10n.current.playRepeatSingleCycleLabel,
    listCycle => L10n.current.playRepeatListCycleLabel,
    autoPlayRelated => L10n.current.playRepeatAutoPlayRelatedLabel,
  };
}
