import 'package:PiliPlus/l10n/l10n.dart';
import 'package:material_ui/material_ui.dart' show Alignment;

enum UserInfoType {
  fan(.centerLeft),
  follow(.center),
  like(.centerRight),
  ;

  String get title => switch (this) {
    fan => L10n.current.followers,
    follow => L10n.current.follow,
    like => L10n.current.userInfoTypeLikeTitle,
  };
  final Alignment alignment;

  const UserInfoType(this.alignment);
}
