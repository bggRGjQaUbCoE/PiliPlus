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
