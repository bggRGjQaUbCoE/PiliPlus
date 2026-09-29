import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/models/common/enum_with_label.dart';

enum DynamicsTabType implements EnumWithLabel {
  all,
  video,
  pgc,
  article,
  up,
  ;

  @override
  String get label => switch (this) {
    all => L10n.current.all,
    video => L10n.current.dynamicsTabTypeVideoLabel,
    pgc => L10n.current.bangumi,
    article => L10n.current.article,
    up => L10n.current.dynamicsTabTypeUpLabel,
  };
}
