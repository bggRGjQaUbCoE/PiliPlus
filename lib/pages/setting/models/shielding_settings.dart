import 'package:PiliPlus/features/shielding/shielding.dart';

String shieldRuleSummary(List<ShieldRule> rules) {
  if (rules.isEmpty) return '还未添加规则';
  final enabled = rules.where((rule) => rule.enabled).length;
  return '$enabled/${rules.length} 条规则启用';
}

String shieldRuleTitle(ShieldRule rule) {
  final display = _displayPattern(rule);
  return '${shieldActionLabel(rule.action)} ${shieldRuleTypeLabel(rule.type)}: $display';
}

/// Returns the user-facing display text for a rule's pattern.
///
/// Prefers [ShieldRule.displayPattern] when set.
/// For old user/UP keyword rules whose pattern is a generated regex
/// from [shieldTokenPatternRegex], extracts and unescapes the original keyword.
/// Falls back to the raw [pattern] for manual regex, UID, and other rules.
String _displayPattern(ShieldRule rule) {
  // 1. Use explicit displayPattern when available.
  if (rule.displayPattern != null && rule.displayPattern!.isNotEmpty) {
    return rule.displayPattern!;
  }

  // 2. For user/UP keyword regex rules, try to recover keyword from
  //    the generated token pattern shape.
  if (rule.type == ShieldRuleType.userKeyword &&
      rule.matchMode == ShieldMatchMode.regex) {
    final extracted = _extractKeywordFromTokenPattern(rule.pattern);
    if (extracted != null) return extracted;
  }

  // 3. Fallback: show the raw pattern (UID, manual regex, etc.).
  return rule.pattern;
}

/// Detects a pattern produced by [shieldTokenPatternRegex] and extracts
/// the original keyword (with regex escaping reversed).
String? _extractKeywordFromTokenPattern(String pattern) {
  const prefix = r'(^|[\s,，。！？!?:：;；_\-])';
  const suffix = r'($|[\s,，。！？!?:：;；_\-])';
  if (pattern.startsWith(prefix) && pattern.endsWith(suffix)) {
    final escaped = pattern.substring(
      prefix.length,
      pattern.length - suffix.length,
    );
    if (escaped.isNotEmpty) {
      return _unescapeRegex(escaped);
    }
  }
  return null;
}

/// Reverses [RegExp.escape] — strips single backslashes before special
/// regex characters and collapses double backslashes to single ones.
String _unescapeRegex(String s) {
  final buffer = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (s[i] == '\\' && i + 1 < s.length) {
      buffer.write(s[i + 1]);
      i++;
    } else {
      buffer.write(s[i]);
    }
  }
  return buffer.toString();
}

String shieldRuleSubtitle(ShieldRule rule) =>
    '${shieldScopeLabel(rule.scope)} / '
    '${shieldMatchModeLabel(rule.matchMode, type: rule.type)} / '
    '${rule.enabled ? '已启用' : '已停用'}';

String shieldRuleTypeLabel(ShieldRuleType type) => switch (type) {
  ShieldRuleType.keyword => '标题/正文关键词',
  ShieldRuleType.userKeyword => '用户/UP关键词',
  ShieldRuleType.reasonKeyword => '推荐理由',
  ShieldRuleType.uid => '用户 UID',
  ShieldRuleType.category => '分区',
  ShieldRuleType.tag => '标签',
};

const shieldingRuleCategoryLabels = [
  '用户/UP',
  '标题关键词',
  '推荐理由',
  '标签',
  '分区',
  '评论关键词',
];

String shieldingRuleCategoryFor(ShieldRule rule) {
  if (rule.type == ShieldRuleType.uid ||
      rule.type == ShieldRuleType.userKeyword) {
    return '用户/UP';
  }
  if (rule.type == ShieldRuleType.reasonKeyword) return '推荐理由';
  if (rule.type == ShieldRuleType.keyword &&
      rule.scope == ShieldScope.comment) {
    return '评论关键词';
  }
  if (rule.type == ShieldRuleType.keyword &&
      (rule.scope == ShieldScope.recommendation ||
          rule.scope == ShieldScope.both)) {
    return '标题关键词';
  }
  return switch (rule.type) {
    ShieldRuleType.keyword => '标题关键词',
    ShieldRuleType.userKeyword || ShieldRuleType.uid => '用户/UP',
    ShieldRuleType.reasonKeyword => '推荐理由',
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
