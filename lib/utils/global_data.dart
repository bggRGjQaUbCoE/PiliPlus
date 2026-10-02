import 'package:get/get.dart';
import 'package:PiliPlus/utils/storage_pref.dart';

class GlobalData {
  int imgQuality = Pref.picQuality;

  num? coins;

  void afterCoin(num coin) {
    if (coins != null) {
      coins = coins! - coin;
    }
  }

  Set<int> blackMids = Pref.blackMids;

  Set<int> dynamicsBlockedMids = Pref.dynamicsBlockedMids;

  Map<int, String> whitelistMids = Pref.whitelistMids;

  Map<int, String> remarkMids = Pref.remarkMids;

  Map<int, String> recommendBlockedMids = Pref.recommendBlockedMids;

  bool dynamicsWaterfallFlow = Pref.dynamicsWaterfallFlow;

  bool showMedal = Pref.showMedal;

  bool remarkReplaceName = Pref.remarkReplaceName;

  final RxInt remarkVersion = 0.obs;

  // 私有构造函数
  GlobalData._();

  // 单例实例
  static final GlobalData _instance = GlobalData._();

  // 获取全局实例
  factory GlobalData() => _instance;
}

/// 取备注原文（含换行），无备注返回 null。
/// 不受替换开关影响——追加位与备注行都用它。
String? remarkOf(int? mid) {
  GlobalData().remarkVersion.value; // Obx 订阅点，勿删
  if (mid == null) return null;
  final remark = GlobalData().remarkMids[mid];
  return (remark == null || remark.isEmpty) ? null : remark;
}

/// 名字位的统一入口：返回应当显示在名字位上的文本。
/// 未开启替换 / mid 为空 / 无备注 → 原样返回 rawName。
/// 开启替换且有备注 → 返回备注首行。
String remarkedName(int? mid, String rawName) {
  if (!GlobalData().remarkReplaceName) return rawName;
  final remark = remarkOf(mid);
  if (remark == null) return rawName;
  final firstLine = remark.split('\n').first.trim();
  return firstLine.isEmpty ? rawName : firstLine;
}
