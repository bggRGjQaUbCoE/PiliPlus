abstract final class BiliUtils {
  static bool isDefaultFav(int? attr) {
    if (attr == null) {
      return false;
    }
    return (attr & 2) == 0;
  }

  static String isPublicFavText(int? attr) {
    if (attr == null) {
      return '';
    }
    return isPublicFav(attr) ? '公开' : '私密';
  }

  static bool isPublicFav(int attr) {
    return (attr & 1) == 0;
  }

  static bool isCustomFollowTag(int? tagid) {
    return tagid != null && tagid != 0 && tagid != -10 && tagid != -2;
  }

  static String levelName(
    Object level, {
    bool isSeniorMember = false,
  }) => 'assets/images/lv/lv${isSeniorMember ? '6_s' : level}.png';
}
