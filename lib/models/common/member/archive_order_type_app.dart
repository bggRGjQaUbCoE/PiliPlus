import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/models/common/enum_with_label.dart';

enum ArchiveOrderTypeApp with EnumWithLabel {
  pubdate,
  click,
  ;

  @override
  String get label => switch (this) {
    pubdate => L10n.current.archiveOrderTypeWebPubdateLabel,
    click => L10n.current.archiveOrderTypeWebClickLabel,
  };
}
