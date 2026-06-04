import 'dart:convert';

import 'package:PiliPlus/features/shielding/shielding.dart';
import 'package:PiliPlus/pages/setting/models/shielding_settings.dart';
import 'package:PiliPlus/pages/shielding_settings/view.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

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
      expect(shieldRuleSubtitle(rule), '评论 / 完全相同 / 已启用');
    });

    test(
      'labels keyword exact semantics as contains instead of exact equality',
      () {
        final rule = _rule(
          id: 'keyword',
          type: ShieldRuleType.keyword,
          matchMode: ShieldMatchMode.exact,
          pattern: '猫',
        );

        expect(shieldMatchModeLabel(rule.matchMode, type: rule.type), '包含文字');
        expect(shieldRuleSubtitle(rule), '推荐和评论 / 包含文字 / 已启用');
        expect(shieldMatchModeLabel(ShieldMatchMode.exact), '完全相同');
      },
    );

    test('labels user keyword separately from generic keyword', () {
      expect(shieldRuleTypeLabel(ShieldRuleType.keyword), '标题/正文关键词');
      expect(shieldRuleTypeLabel(ShieldRuleType.userKeyword), '用户/UP关键词');
      expect(shieldRuleTypeLabel(ShieldRuleType.reasonKeyword), '推荐理由');
    });

    test('provides horizontal category navigation labels', () {
      expect(
        shieldingRuleCategoryLabels,
        containsAll([
          '用户/UP',
          '标题关键词',
          '推荐理由',
          '标签',
          '分区',
          '评论关键词',
        ]),
      );
      expect(shieldingRuleCategoryLabels, isNot(contains('精确文本')));
      expect(shieldingRuleCategoryLabels, isNot(contains('旧规则兼容')));
    });

    test('categorizes quick recommendation keyword exact as title keyword', () {
      final rule = _rule(
        id: 'quick-title',
        type: ShieldRuleType.keyword,
        matchMode: ShieldMatchMode.exact,
        scope: ShieldScope.recommendation,
        source: ShieldRuleSource.quickAction,
        pattern: '猫',
      );

      expect(shieldingRuleCategoryFor(rule), '标题关键词');
    });

    test('categorizes quick comment keyword exact as comment keyword', () {
      final rule = _rule(
        id: 'quick-comment',
        type: ShieldRuleType.keyword,
        matchMode: ShieldMatchMode.exact,
        scope: ShieldScope.comment,
        source: ShieldRuleSource.quickAction,
        pattern: '剧透',
      );

      expect(shieldingRuleCategoryFor(rule), '评论关键词');
    });

    test('categorizes both-scope keyword exact as title keyword', () {
      final rule = _rule(
        id: 'both-keyword',
        type: ShieldRuleType.keyword,
        matchMode: ShieldMatchMode.exact,
        scope: ShieldScope.both,
        pattern: '猫',
      );

      expect(shieldingRuleCategoryFor(rule), '标题关键词');
    });

    test('categorizes user keyword as user UP', () {
      final rule = _rule(
        id: 'user-keyword',
        type: ShieldRuleType.userKeyword,
        matchMode: ShieldMatchMode.token,
        scope: ShieldScope.recommendation,
        source: ShieldRuleSource.quickAction,
        pattern: '测试UP',
      );

      expect(shieldingRuleCategoryFor(rule), '用户/UP');
    });

    test('categorizes reason keyword as recommendation reason', () {
      final rule = _rule(
        id: 'reason',
        type: ShieldRuleType.reasonKeyword,
        matchMode: ShieldMatchMode.exact,
        scope: ShieldScope.recommendation,
        source: ShieldRuleSource.quickAction,
        pattern: '因为你看过游戏',
      );

      expect(shieldingRuleCategoryFor(rule), '推荐理由');
    });

    test('categorizes imported rules by actual type', () {
      final importedTitle = _rule(
        id: 'imported-title',
        type: ShieldRuleType.keyword,
        matchMode: ShieldMatchMode.exact,
        scope: ShieldScope.recommendation,
        source: ShieldRuleSource.imported,
        pattern: '猫',
      );
      final importedCategory = _rule(
        id: 'imported-category',
        type: ShieldRuleType.category,
        matchMode: ShieldMatchMode.exact,
        scope: ShieldScope.recommendation,
        source: ShieldRuleSource.imported,
        pattern: '游戏',
      );

      expect(shieldingRuleCategoryFor(importedTitle), '标题关键词');
      expect(shieldingRuleCategoryFor(importedCategory), '分区');
    });
  });

  group('ShieldingSettingsPage', () {
    testWidgets('new manual rule editor shows type match and action controls', (
      tester,
    ) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: ShieldingSettingsPage(
            store: ShieldSettingsStore(box: _MemoryBox()),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byTooltip('新增').first);
      await tester.pumpAndSettle();

      expect(find.text('类型'), findsOneWidget);
      expect(find.text('匹配方式'), findsOneWidget);
      expect(find.text('动作'), findsOneWidget);
      expect(find.text('启用'), findsOneWidget);
    });

    testWidgets('manual rule editor hides deprecated token match mode', (
      tester,
    ) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: ShieldingSettingsPage(
            store: ShieldSettingsStore(box: _MemoryBox()),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byTooltip('新增').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('包含文字'));
      await tester.pumpAndSettle();

      expect(find.text('包含文字'), findsWidgets);
      expect(find.text('正则匹配'), findsOneWidget);
      expect(find.text('词元匹配'), findsNothing);
    });

    testWidgets('loaded legacy token rule is shown as regex in UI', (
      tester,
    ) async {
      final seed = ShieldRuleSet(
        rules: [
          _rule(
            id: 'legacy-token',
            type: ShieldRuleType.userKeyword,
            matchMode: ShieldMatchMode.token,
            scope: ShieldScope.recommendation,
            pattern: '测试UP',
          ),
        ],
      );
      final store = ShieldSettingsStore(
        box: _MemoryBox({
          ShieldSettingsStore.rulesKey: jsonEncode(seed.toJson()),
        }),
      );

      await tester.pumpWidget(
        GetMaterialApp(home: ShieldingSettingsPage(store: store)),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('正则匹配'), findsOneWidget);
      expect(find.textContaining('词元匹配'), findsNothing);
    });

    testWidgets('shows same-row shielding category navigation', (tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: ShieldingSettingsPage(
            store: ShieldSettingsStore(box: _MemoryBox()),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('用户/UP'), findsOneWidget);
      expect(find.text('标题关键词'), findsOneWidget);
      expect(find.text('推荐理由'), findsOneWidget);
      expect(find.text('精确文本'), findsNothing);
      expect(find.text('旧规则兼容'), findsNothing);
    });
  });
}

ShieldRule _rule({
  required String id,
  ShieldRuleType type = ShieldRuleType.keyword,
  ShieldMatchMode matchMode = ShieldMatchMode.token,
  ShieldScope scope = ShieldScope.both,
  ShieldAction action = ShieldAction.block,
  ShieldRuleSource source = ShieldRuleSource.manual,
  required String pattern,
  bool enabled = true,
}) => ShieldRule(
  id: id,
  type: type,
  matchMode: matchMode,
  scope: scope,
  action: action,
  pattern: pattern,
  enabled: enabled,
  updatedAt: DateTime.fromMillisecondsSinceEpoch(1),
  source: source,
);

class _MemoryBox implements ShieldSettingsBox {
  _MemoryBox([Map<String, Object?>? values]) : values = values ?? {};

  final Map<String, Object?> values;

  @override
  Object? get(String key, {Object? defaultValue}) =>
      values.containsKey(key) ? values[key] : defaultValue;

  @override
  Future<void> put(String key, Object? value) async {
    values[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    values.remove(key);
  }
}
