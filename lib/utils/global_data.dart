import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:get/get.dart';

class GlobalData {
  int imgQuality = Pref.picQuality;

  num? coins;

  void afterCoin(num coin) {
    if (coins != null) {
      coins = coins! - coin;
    }
  }

  /// Ordered local IDs; newest blocks are appended.
  final RxList<int> localBlackMids = Pref.localBlackMids.obs;

  /// IDs from the online blacklist, kept separate from local blocks.
  Set<int> onlineBlackMids = Pref.blackMids;

  /// Combined filter set: both local and online blocks hide matching users.
  Set<int> blackMids = {...Pref.blackMids, ...Pref.localBlackMids};

  bool dynamicsWaterfallFlow = Pref.dynamicsWaterfallFlow;

  bool showMedal = Pref.showMedal;

  // 私有构造函数
  GlobalData._();

  // 单例实例
  static final GlobalData _instance = GlobalData._();

  // 获取全局实例
  factory GlobalData() => _instance;
}

extension IterableExt<E> on Iterable<E> {
  Iterable<E> whereNotBlocked(Object? /* mid */ Function(E element) test) =>
      where((e) => !GlobalData().blackMids.contains(test(e)));
}
