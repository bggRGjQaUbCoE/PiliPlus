import 'package:PiliPlus/features/shielding/shielding.dart';
import 'package:PiliPlus/pages/setting/models/shielding_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('shielding setting labels', () {
    test('summarizes total and enabled rule counts', () {
      final rules = [
        _rule(id: 'a', pattern: '猫'),
        _rule(id: 'b', pattern: '狗', enabled: false),
      ];

      expect(shieldRuleSummary(rules), '1/2 条规则启用');
    });

    test('describes empty rule list', () {
      expect(shieldRuleSummary(const []), '还未添加规则');
    });

    test('formats editable rule labels', () {
      final rule = _rule(
        id: 'allow-uid',
        type: ShieldRuleType.uid,
        matchMode: ShieldMatchMode.exact,
        scope: ShieldScope.comment,
        action: ShieldAction.allow,
        pattern: '42',
      );

      expect(shieldRuleTitle(rule), '允许 用户 UID: 42');
      expect(shieldRuleSubtitle(rule), '评论 / 精确匹配 / 已启用');
    });
  });
}

ShieldRule _rule({
  required String id,
  ShieldRuleType type = ShieldRuleType.keyword,
  ShieldMatchMode matchMode = ShieldMatchMode.token,
  ShieldScope scope = ShieldScope.both,
  ShieldAction action = ShieldAction.block,
  required String pattern,
  bool enabled = true,
}) =>
    ShieldRule(
      id: id,
      type: type,
      matchMode: matchMode,
      scope: scope,
      action: action,
      pattern: pattern,
      enabled: enabled,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(1),
    );
