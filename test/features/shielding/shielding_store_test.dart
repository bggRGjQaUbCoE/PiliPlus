import 'dart:convert';

import 'package:PiliPlus/features/shielding/shielding.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ShieldRuleSet', () {
    test('round trips JSON and preserves version fields', () {
      final loadedAt = DateTime.fromMillisecondsSinceEpoch(1234);
      final ruleSet = ShieldRuleSet(
        globalEnabled: false,
        recommendationEnabled: true,
        commentEnabled: false,
        version: 7,
        lastLoadedAt: loadedAt,
        rules: [
          ShieldRule(
            id: 'a',
            type: ShieldRuleType.uid,
            matchMode: ShieldMatchMode.exact,
            scope: ShieldScope.comment,
            action: ShieldAction.allow,
            pattern: '42',
            enabled: false,
            updatedAt: DateTime.fromMillisecondsSinceEpoch(99),
            source: ShieldRuleSource.imported,
          ),
        ],
      );

      final decoded = ShieldRuleSet.fromJson(ruleSet.toJson());

      expect(decoded.globalEnabled, isFalse);
      expect(decoded.recommendationEnabled, isTrue);
      expect(decoded.commentEnabled, isFalse);
      expect(decoded.version, 7);
      expect(decoded.lastLoadedAt, loadedAt);
      expect(decoded.rules.single.source, ShieldRuleSource.imported);
      expect(decoded.rules.single.updatedAt.millisecondsSinceEpoch, 99);
    });

    test('damaged JSON bypasses shielding instead of throwing', () {
      final decoded = ShieldRuleSet.tryFromJson({
        'version': 'broken',
        'rules': [
          {'type': 'unknown'},
        ],
      });

      expect(decoded.globalEnabled, isFalse);
      expect(decoded.rules, isEmpty);
      expect(decoded.loadErrors, isNotEmpty);
    });
  });

  group('ShieldSettingsStore', () {
    test('loads damaged raw payload as disabled fallback', () async {
      final box = _MemoryBox({
        ShieldSettingsStore.rulesKey: 'not-json',
      });
      final store = ShieldSettingsStore(box: box);

      final ruleSet = await store.load();

      expect(ruleSet.globalEnabled, isFalse);
      expect(ruleSet.rules, isEmpty);
      expect(ruleSet.loadErrors, isNotEmpty);
    });

    test('rejects invalid regex without overwriting previous payload', () async {
      final box = _MemoryBox();
      final store = ShieldSettingsStore(box: box);
      final valid = ShieldRuleSet(rules: [
        ShieldRule(
          id: 'valid',
          type: ShieldRuleType.keyword,
          matchMode: ShieldMatchMode.regex,
          scope: ShieldScope.both,
          action: ShieldAction.block,
          pattern: 'cat.*',
          updatedAt: DateTime.fromMillisecondsSinceEpoch(1),
        ),
      ]);
      await store.save(valid);
      final before = box.values[ShieldSettingsStore.rulesKey];

      final invalid = ShieldRuleSet(rules: [
        ShieldRule(
          id: 'invalid',
          type: ShieldRuleType.keyword,
          matchMode: ShieldMatchMode.regex,
          scope: ShieldScope.both,
          action: ShieldAction.block,
          pattern: '[',
          updatedAt: DateTime.fromMillisecondsSinceEpoch(2),
        ),
      ]);

      expect(store.save(invalid), throwsA(isA<ShieldStoreException>()));
      expect(box.values[ShieldSettingsStore.rulesKey], before);
    });

    test('adds quickAction block rule without rebuilding existing namespace', () async {
      final box = _MemoryBox();
      final store = ShieldSettingsStore(box: box);
      final existing = ShieldRule(
        id: 'existing',
        type: ShieldRuleType.uid,
        matchMode: ShieldMatchMode.exact,
        scope: ShieldScope.comment,
        action: ShieldAction.allow,
        pattern: '42',
        updatedAt: DateTime.fromMillisecondsSinceEpoch(1),
      );
      await store.save(
        ShieldRuleSet(
          globalEnabled: false,
          recommendationEnabled: false,
          commentEnabled: true,
          version: 9,
          rules: [existing],
        ),
      );

      final added = await store.addQuickActionRule(
        type: ShieldRuleType.keyword,
        scope: ShieldScope.recommendation,
        pattern: '  Cat  ',
      );
      final loaded = store.snapshot();

      expect(added, isNotNull);
      expect(loaded.globalEnabled, isFalse);
      expect(loaded.recommendationEnabled, isFalse);
      expect(loaded.commentEnabled, isTrue);
      expect(loaded.version, 9);
      expect(loaded.rules, hasLength(2));
      expect(loaded.rules.first.id, 'existing');
      expect(loaded.rules.last.type, ShieldRuleType.keyword);
      expect(loaded.rules.last.matchMode, ShieldMatchMode.exact);
      expect(loaded.rules.last.scope, ShieldScope.recommendation);
      expect(loaded.rules.last.action, ShieldAction.block);
      expect(loaded.rules.last.source, ShieldRuleSource.quickAction);
      expect(loaded.rules.last.pattern, 'Cat');
      expect(loaded.rules.last.enabled, isTrue);
    });

    test('quickAction preserves existing namespace flags without rules payload', () async {
      final box = _MemoryBox({
        ShieldSettingsStore.globalEnabledKey: false,
        ShieldSettingsStore.recommendationEnabledKey: false,
        ShieldSettingsStore.commentEnabledKey: true,
        ShieldSettingsStore.versionKey: 5,
      });
      final store = ShieldSettingsStore(box: box);

      await store.addQuickActionRule(
        type: ShieldRuleType.keyword,
        scope: ShieldScope.recommendation,
        pattern: 'Cat',
      );
      final loaded = store.snapshot();

      expect(loaded.globalEnabled, isFalse);
      expect(loaded.recommendationEnabled, isFalse);
      expect(loaded.commentEnabled, isTrue);
      expect(loaded.version, 5);
      expect(loaded.rules.single.pattern, 'Cat');
    });

    test('dedupes quickAction rules by type scope and trimmed pattern ignoring case', () async {
      final box = _MemoryBox();
      final store = ShieldSettingsStore(box: box);

      final first = await store.addQuickActionRule(
        type: ShieldRuleType.keyword,
        scope: ShieldScope.both,
        pattern: ' Cat ',
      );
      final duplicate = await store.addQuickActionRule(
        type: ShieldRuleType.keyword,
        scope: ShieldScope.both,
        pattern: 'cat',
      );
      final differentScope = await store.addQuickActionRule(
        type: ShieldRuleType.keyword,
        scope: ShieldScope.comment,
        pattern: 'cat',
      );

      expect(first, isNotNull);
      expect(duplicate, isNull);
      expect(differentScope, isNotNull);
      expect(store.snapshot().rules, hasLength(2));
    });

    test('quickAction loads persisted rules before appending without cached snapshot', () async {
      final existing = ShieldRule(
        id: 'persisted',
        type: ShieldRuleType.uid,
        matchMode: ShieldMatchMode.exact,
        scope: ShieldScope.comment,
        action: ShieldAction.allow,
        pattern: '42',
        updatedAt: DateTime.fromMillisecondsSinceEpoch(1),
      );
      final seed = ShieldRuleSet(
        globalEnabled: false,
        recommendationEnabled: true,
        commentEnabled: false,
        version: 3,
        rules: [existing],
      );
      final box = _MemoryBox({
        ShieldSettingsStore.rulesKey: jsonEncode(seed.toJson()),
        ShieldSettingsStore.globalEnabledKey: false,
        ShieldSettingsStore.recommendationEnabledKey: true,
        ShieldSettingsStore.commentEnabledKey: false,
        ShieldSettingsStore.versionKey: 3,
      });
      final store = ShieldSettingsStore(box: box);

      await store.addQuickActionRule(
        type: ShieldRuleType.keyword,
        scope: ShieldScope.recommendation,
        pattern: 'cat',
      );

      final loaded = store.snapshot();
      expect(loaded.globalEnabled, isFalse);
      expect(loaded.commentEnabled, isFalse);
      expect(loaded.version, 3);
      expect(loaded.rules.map((rule) => rule.id), contains('persisted'));
      expect(loaded.rules, hasLength(2));
    });
  });
}

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
