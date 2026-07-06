import 'package:PiliPlus/common/widgets/svg/level_icon.dart';
import 'package:flutter/material.dart';

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

  // https://s1.hdslb.com/bfs/svg-next/font/2025-10-27/freshspace-zpjpp3aqht.css
  static Widget levelPicture(
    int level, {
    bool isSeniorMember = false,
    double height = 11,
  }) {
    return UserLevel(level, height: height, flash: isSeniorMember);
  }
}
