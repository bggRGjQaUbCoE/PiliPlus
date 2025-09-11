class FavUtils {
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
}
