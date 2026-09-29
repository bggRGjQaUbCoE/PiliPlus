import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/models/common/enum_with_label.dart';

enum ArchiveSortTypeApp with EnumWithLabel {
  desc,
  asc,
  ;

  @override
  String get label => switch (this) {
    desc => L10n.current.defaultOption,
    asc => L10n.current.archiveSortTypeAppAscLabel,
  };
}
