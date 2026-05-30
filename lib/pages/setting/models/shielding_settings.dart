import 'package:PiliPlus/features/shielding/shielding.dart';

String shieldRuleSummary(List<ShieldRule> rules) {
  if (rules.isEmpty) return '还未添加规则';
  final enabled = rules.where((rule) => rule.enabled).length;
  return '$enabled/${rules.length} 条规则启用';
}

String shieldRuleTitle(ShieldRule rule) =>
    '${shieldActionLabel(rule.action)} ${shieldRuleTypeLabel(rule.type)}: ${rule.pattern}';

String shieldRuleSubtitle(ShieldRule rule) =>
    '${shieldScopeLabel(rule.scope)} / '
    '${shieldMatchModeLabel(rule.matchMode, type: rule.type)} / '
    '${rule.enabled ? '已启用' : '已停用'}';

String shieldRuleTypeLabel(ShieldRuleType type) => switch (type) {
  ShieldRuleType.keyword => '关键词',
  ShieldRuleType.uid => '用户 UID',
  ShieldRuleType.category => '分区',
  ShieldRuleType.tag => '标签',
};

String shieldMatchModeLabel(
  ShieldMatchMode mode, {
  ShieldRuleType? type,
}) => switch (mode) {
  ShieldMatchMode.exact =>
    type == ShieldRuleType.keyword ? '包含文字' : '完全相同',
  ShieldMatchMode.regex => '正则匹配',
  ShieldMatchMode.token => '词元匹配',
};

String shieldScopeLabel(ShieldScope scope) => switch (scope) {
  ShieldScope.recommendation => '推荐',
  ShieldScope.comment => '评论',
  ShieldScope.both => '推荐和评论',
};

String shieldActionLabel(ShieldAction action) => switch (action) {
  ShieldAction.block => '屏蔽',
  ShieldAction.allow => '允许',
};
