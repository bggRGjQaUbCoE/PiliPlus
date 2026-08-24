import 'package:PiliPlus/common/widgets/svg/level_icon.dart';
import 'package:material_ui/material_ui.dart';

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

  static const _liveGuard1 =
      'https://i0.hdslb.com/bfs/live/a454275dea465ac15a03f121f0d7edaf96e30bcf.png';
  static const _liveGuard2 =
      'https://i0.hdslb.com/bfs/live/3b46129e796df42ec7356fcba77c8a79d47db682.png';
  static const _liveGuard3 =
      'https://i0.hdslb.com/bfs/live/80f732943cc3367029df65e267960d56736a82ee.png';

  static String? liveGuardPendant(int guardLevel) => switch (guardLevel) {
    1 => _liveGuard1,
    2 => _liveGuard2,
    3 => _liveGuard3,
    _ => null,
  };
}
