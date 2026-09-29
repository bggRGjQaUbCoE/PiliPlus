import 'package:PiliPlus/l10n/l10n.dart';

enum UserOrderType {
  def(0, ''),
  fansDesc(0, 'fans'),
  fansAsc(1, 'fans'),
  levelDesc(0, 'level'),
  levelAsc(1, 'level'),
  ;

  String get label => switch (this) {
    def => L10n.current.archiveFilterTypeTotalrankDesc,
    fansDesc => L10n.current.userOrderTypeFansDescLabel,
    fansAsc => L10n.current.userOrderTypeFansAscLabel,
    levelDesc => L10n.current.userOrderTypeLevelDescLabel,
    levelAsc => L10n.current.userOrderTypeLevelAscLabel,
  };
  final int orderSort;
  final String order;
  const UserOrderType(this.orderSort, this.order);
}

enum UserType {
  all,
  up,
  common,
  verified,
  ;

  String get label => switch (this) {
    all => L10n.current.userTypeAllLabel,
    up => L10n.current.userTypeUpLabel,
    common => L10n.current.userTypeCommonLabel,
    verified => L10n.current.userTypeVerifiedLabel,
  };
}
