import 'package:PiliPlus/utils/storage_pref.dart';

abstract final class GlobalData {
  static int imgQuality = Pref.picQuality;

  static num? coins;

  static void afterCoin(num coin) {
    if (coins != null) {
      coins = coins! - coin;
    }
  }

  static Set<int> blackMids = Pref.blackMids;

  static bool dynamicsWaterfallFlow = Pref.dynamicsWaterfallFlow;
}
