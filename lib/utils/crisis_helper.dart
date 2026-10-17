/// 心理危机干预相关的常量与判定。
///
/// 服务端会在搜索接口的 `tips` 模块里下发关怀卡片；但部分高危词
/// （如「自杀」）服务端只压制结果、不下发卡片，需要在客户端兜底。
abstract final class CrisisHelper {
  /// 全国24小时免费心理咨询热线（北京心理危机研究与干预中心）。
  static const String hotline = '010-82951332';

  /// 官方「能量加油站」页面。
  static const String energyStationUrl =
      'https://www.bilibili.com/blackboard/era/3ERAmwloghvazr00.html';

  /// 高风险关键词。
  ///
  /// 仅当服务端没有下发 `tips` 卡片时才会用到，因此与官方行为保持一致：
  /// 「跳楼」等服务端已覆盖的词仍走官方小卡片 + 正常搜索结果，
  /// 「自杀」这类被服务端静默压制的词才由本地兜底成完整关怀页。
  static const List<String> keywords = [
    '自杀',
    '自尽',
    '自缢',
    '轻生',
    '想死',
    '不想活',
    '活不下去',
    '结束生命',
    '跳楼',
    '跳桥',
    '割腕',
    '自残',
    '烧炭',
  ];

  static bool isCrisis(String keyword) {
    final kw = keyword.trim();
    if (kw.isEmpty) {
      return false;
    }
    return keywords.any((e) => kw.contains(e));
  }
}
