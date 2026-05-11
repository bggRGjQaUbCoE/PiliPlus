import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_pref.dart';

abstract final class GlobalData {
  static int imgQuality = Pref.picQuality;

  static double? coins;

  static void afterCoin(num coin) {
    if (coins != null) {
      coins = coins! - coin;
      GStorage.userInfo.put(
        'userInfoCache',
        Pref.userInfoCache!..money = coins,
      );
    }
  }

  static Set<int> blackMids = Pref.blackMids;

  static bool dynamicsWaterfallFlow = Pref.dynamicsWaterfallFlow;
}
