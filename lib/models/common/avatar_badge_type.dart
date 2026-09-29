import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/utils/bili_colors.dart';
import 'package:material_ui/material_ui.dart';

enum BadgeType {
  none,
  vip,
  person(BiliColors.yellow),
  institution(Colors.lightBlueAccent),
  ;

  String? get desc => switch (this) {
    none => null,
    vip => L10n.current.premiumMember,
    person => L10n.current.verifiedPerson,
    institution => L10n.current.verifiedOrganisation,
  };
  final Color? color;
  const BadgeType([this.color]);
}
