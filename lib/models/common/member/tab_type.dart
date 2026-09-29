import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/utils/storage_pref.dart';

enum MemberTabType {
  def,
  home,
  dynamic,
  contribute,
  favorite,
  bangumi,
  cheese,
  shop,
  ;

  static bool showMemberShop = Pref.showMemberShop;

  static bool contains(String type) {
    if (type == shop.name && !showMemberShop) {
      return false;
    }
    for (final e in MemberTabType.values) {
      if (e.name == type) {
        return true;
      }
    }
    return false;
  }

  String get title => switch (this) {
    def => L10n.current.defaultOption,
    home => L10n.current.memberTabTypeHomeTitle,
    dynamic => L10n.current.dynamics,
    contribute => L10n.current.dynamicsTabTypeVideoLabel,
    favorite => L10n.current.favourite,
    bangumi => L10n.current.bangumi,
    cheese => L10n.current.favTabTypeCheeseTitle,
    shop => L10n.current.memberTabTypeShopTitle,
  };
}
