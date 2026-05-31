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
  ShieldRuleType.keyword => '标题/正文关键词',
  ShieldRuleType.userKeyword => '用户/UP关键词',
  ShieldRuleType.uid => '用户 UID',
  ShieldRuleType.category => '分区',
  ShieldRuleType.tag => '标签',
};

const shieldingRuleCategoryLabels = [
  '用户/UP',
  '标题关键词',
  '标签',
  '分区',
  '评论关键词',
  '精确文本',
  '旧规则兼容',
];

String shieldingRuleCategoryFor(ShieldRule rule) {
  if (rule.source == ShieldRuleSource.imported) return '旧规则兼容';
  if (rule.type == ShieldRuleType.uid ||
      rule.type == ShieldRuleType.userKeyword) {
    return '用户/UP';
  }
  if (rule.type == ShieldRuleType.keyword &&
      rule.scope == ShieldScope.comment) {
    return '评论关键词';
  }
  if (rule.type == ShieldRuleType.keyword &&
      rule.matchMode == ShieldMatchMode.exact) {
    return '精确文本';
  }
  return switch (rule.type) {
    ShieldRuleType.keyword => '标题关键词',
    ShieldRuleType.userKeyword || ShieldRuleType.uid => '用户/UP',
    ShieldRuleType.category => '分区',
    ShieldRuleType.tag => '标签',
  };
}

String shieldMatchModeLabel(
  ShieldMatchMode mode, {
  ShieldRuleType? type,
}) => switch (mode) {
  ShieldMatchMode.exact => type == ShieldRuleType.keyword ? '包含文字' : '完全相同',
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
