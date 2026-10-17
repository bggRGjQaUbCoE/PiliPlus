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

  /// 人工客服会话的 App 深链。
  ///
  /// 能量加油站页面里的「客服」按钮跳的就是这条，参数含义：
  /// `situation`（会话场景）、`gid` / `skill_group_id`（技能组路由）。
  /// 需要设备已安装哔哩哔哩官方客户端。
  static const String customerChatScheme =
      'bilibili://link/customer/chat?shop_id=0&shop_father_id=0'
      '&situation=10&gid=164&skill_group_id=164';

  /// 人工客服会话的 Web 版（官方 PC 消息中心）。
  ///
  /// 注意：这是 `message-pc` 的产物，页面没有响应式布局，也没有 UA 分流，
  /// 移动端只能靠缩放查看。因此优先用 [customerChatScheme] 唤起官方 App，
  /// 未安装时再降级到这里，并由 WebView 改写 viewport 以适配屏幕宽度。
  static const String customerServiceUrl =
      'https://message.bilibili.com/#/whisper/customer/shop0'
      '?shop_father_id=0&shop_id=0&situation=2&gid=164&skill_group_id=164'
      '&first_domain=.bilibili.com';

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
