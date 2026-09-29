import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/models/common/enum_with_label.dart';

enum ReplySortType implements EnumWithLabel {
  time,
  hot,
  select,
  ;

  @override
  String get label => switch (this) {
    time => L10n.current.replySortTypeTimeLabel,
    hot => L10n.current.replySortTypeHotLabel,
    select => '',
  };
  String get desc => switch (this) {
    time => L10n.current.replySortTypeTimeDesc,
    hot => L10n.current.replySortTypeHotDesc,
    select => L10n.current.replySortTypeSelectDesc,
  };
  String get descShort => switch (this) {
    time => L10n.current.newest,
    hot => L10n.current.hottest,
    select => L10n.current.replySortTypeSelectDescShort,
  };
}
