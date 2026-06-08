import 'dart:convert';

import 'package:PiliPlus/pages/video/channel_quiet/channel_quiet_rule.dart';
import 'package:PiliPlus/pages/video/channel_quiet/channel_quiet_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChannelQuietRule key creation', () {
    test('UGC key creates stable string', () {
      expect(ChannelQuietRule.ugcKey(12345), 'ugc:12345');
      expect(ChannelQuietRule.ugcKey(0), 'ugc:0');
    });

    test('PGC key creates stable string', () {
      expect(ChannelQuietRule.pgcKey(999), 'pgc:999');
      expect(ChannelQuietRule.pgcKey(1), 'pgc:1');
    });
  });

  group('ChannelQuietRule serialization round-trip', () {
    test('UGC rule round-trips through JSON', () {
      final created = DateTime.fromMillisecondsSinceEpoch(1000);
      final updated = DateTime.fromMillisecondsSinceEpoch(2000);
      final rule = ChannelQuietRule(
        key: ChannelQuietRule.ugcKey(42),
        channelUid: '42',
        channelName: 'TestChannel',
        hideComments: true,
        hideDanmaku: false,
        createdAt: created,
        updatedAt: updated,
      );

      final json = rule.toJson();
      expect(json['key'], 'ugc:42');
      expect(json['channel_uid'], '42');
      expect(json['channel_name'], 'TestChannel');
      expect(json['hide_comments'], isTrue);
      expect(json['hide_danmaku'], isFalse);
      expect(json['created_at'], 1000);
      expect(json['updated_at'], 2000);

      final decoded = ChannelQuietRule.fromJson(json);
      expect(decoded.key, 'ugc:42');
      expect(decoded.channelUid, '42');
      expect(decoded.channelName, 'TestChannel');
      expect(decoded.hideComments, isTrue);
      expect(decoded.hideDanmaku, isFalse);
      expect(decoded.createdAt, created);
      expect(decoded.updatedAt, updated);
    });

    test('PGC rule round-trips through JSON', () {
      final created = DateTime.fromMillisecondsSinceEpoch(5000);
      final updated = DateTime.fromMillisecondsSinceEpoch(6000);
      final rule = ChannelQuietRule(
        key: ChannelQuietRule.pgcKey(77),
        channelUid: '77',
        channelName: 'BangumiShow',
        hideComments: false,
        hideDanmaku: true,
        createdAt: created,
        updatedAt: updated,
      );

      final decoded = ChannelQuietRule.fromJson(rule.toJson());
      expect(decoded.key, 'pgc:77');
      expect(decoded.channelUid, '77');
      expect(decoded.channelName, 'BangumiShow');
      expect(decoded.hideComments, isFalse);
      expect(decoded.hideDanmaku, isTrue);
    });

    test('fromJson handles missing optional fields gracefully', () {
      final json = <String, dynamic>{
        'key': 'ugc:1',
        'channel_uid': '1',
        'created_at': 100,
        'updated_at': 200,
      };

      final decoded = ChannelQuietRule.fromJson(json);
      expect(decoded.key, 'ugc:1');
      expect(decoded.channelName, '');
      expect(decoded.hideComments, isFalse);
      expect(decoded.hideDanmaku, isFalse);
    });
  });

  group('ChannelQuietStore CRUD', () {
    late ChannelQuietStore store;
    late _MemoryBox box;

    setUp(() {
      box = _MemoryBox();
      store = ChannelQuietStore(box: box);
    });

    test('add stores created/updated times', () async {
      final before = DateTime.now().millisecondsSinceEpoch;
      final rule = await store.add(
        key: ChannelQuietRule.ugcKey(42),
        channelUid: '42',
        channelName: 'Test',
      );
      final after = DateTime.now().millisecondsSinceEpoch;

      expect(rule.key, 'ugc:42');
      expect(
        rule.createdAt.millisecondsSinceEpoch,
        greaterThanOrEqualTo(before),
      );
      expect(
        rule.createdAt.millisecondsSinceEpoch,
        lessThanOrEqualTo(after),
      );
      expect(rule.updatedAt, rule.createdAt);
    });

    test('update preserves created time and advances updated time', () async {
      await store.add(
        key: ChannelQuietRule.ugcKey(42),
        channelUid: '42',
        channelName: 'OldName',
      );

      final original = store.lookup('ugc:42')!;
      final originalCreated = original.createdAt;

      // small delay to ensure timestamp difference
      await Future<void>.delayed(const Duration(milliseconds: 5));

      final updated = await store.update(
        key: 'ugc:42',
        channelName: 'NewName',
        hideComments: true,
      );

      expect(updated, isNotNull);
      expect(updated!.channelName, 'NewName');
      expect(updated.hideComments, isTrue);
      expect(updated.createdAt, originalCreated);
      expect(
        updated.updatedAt.millisecondsSinceEpoch,
        greaterThan(originalCreated.millisecondsSinceEpoch),
      );
    });

    test('update returns null for unknown key', () async {
      final result = await store.update(
        key: 'ugc:999',
        channelName: 'Nowhere',
      );
      expect(result, isNull);
    });

    test('delete removes by key', () async {
      await store.add(
        key: ChannelQuietRule.ugcKey(1),
        channelUid: '1',
        channelName: 'A',
      );
      await store.add(
        key: ChannelQuietRule.ugcKey(2),
        channelUid: '2',
        channelName: 'B',
      );

      final deleted = await store.delete('ugc:1');
      expect(deleted, isTrue);

      final all = store.listAll();
      expect(all, hasLength(1));
      expect(all.single.key, 'ugc:2');
    });

    test('delete returns false for unknown key', () async {
      final deleted = await store.delete('ugc:unknown');
      expect(deleted, isFalse);
    });

    test('lookup returns right rule and null for unmatched', () async {
      await store.add(
        key: ChannelQuietRule.ugcKey(1),
        channelUid: '1',
        channelName: 'A',
      );
      await store.add(
        key: ChannelQuietRule.pgcKey(100),
        channelUid: '100',
        channelName: 'B',
      );

      final found = store.lookup('ugc:1');
      expect(found, isNotNull);
      expect(found!.channelName, 'A');

      final notFound = store.lookup('ugc:99');
      expect(notFound, isNull);
    });

    test('listAll returns empty list when no rules', () {
      expect(store.listAll(), isEmpty);
    });
  });

  group('ChannelQuietStore persistence', () {
    test('reload from stored JSON preserves rules', () async {
      final box = _MemoryBox();
      final storeA = ChannelQuietStore(box: box);
      await storeA.add(
        key: ChannelQuietRule.ugcKey(42),
        channelUid: '42',
        channelName: 'Persisted',
        hideComments: true,
        hideDanmaku: true,
      );

      final storeB = ChannelQuietStore(box: box);
      final rules = await storeB.load();
      expect(rules, hasLength(1));
      expect(rules.single.key, 'ugc:42');
      expect(rules.single.channelUid, '42');
      expect(rules.single.channelName, 'Persisted');
      expect(rules.single.hideComments, isTrue);
      expect(rules.single.hideDanmaku, isTrue);
    });

    test('load returns empty list when no stored data', () async {
      final box = _MemoryBox();
      final store = ChannelQuietStore(box: box);
      final rules = await store.load();
      expect(rules, isEmpty);
    });

    test('damaged JSON bypasses rules with empty state', () async {
      final box = _MemoryBox({
        ChannelQuietStore.rulesKey: 'this is not json at all {{{',
      });
      final store = ChannelQuietStore(box: box);
      final rules = await store.load();
      expect(rules, isEmpty);
    });

    test('damaged JSON via snapshot also returns empty', () {
      final box = _MemoryBox({
        ChannelQuietStore.rulesKey: 'not json',
      });
      final store = ChannelQuietStore(box: box);
      final rules = store.snapshot();
      expect(rules, isEmpty);
    });

    test('non-string payload returns empty state', () async {
      final box = _MemoryBox({
        ChannelQuietStore.rulesKey: 12345,
      });
      final store = ChannelQuietStore(box: box);
      final rules = await store.load();
      expect(rules, isEmpty);
    });

    test('skips damaged entries in otherwise valid JSON array', () async {
      final box = _MemoryBox({
        ChannelQuietStore.rulesKey: jsonEncode([
          {
            'key': 'ugc:1',
            'channel_uid': '1',
            'channel_name': 'Good',
            'created_at': 100,
            'updated_at': 200,
          },
          'plain string instead of map',
          {
            'key': 'ugc:2',
            'channel_uid': '2',
            'channel_name': 'AlsoGood',
            'created_at': 300,
            'updated_at': 400,
          },
        ]),
      });
      final store = ChannelQuietStore(box: box);
      final rules = await store.load();
      expect(rules, hasLength(2));
      expect(rules[0].key, 'ugc:1');
      expect(rules[1].key, 'ugc:2');
    });

    test('clear removes all data', () async {
      final box = _MemoryBox();
      final store = ChannelQuietStore(box: box);
      await store.add(
        key: ChannelQuietRule.ugcKey(1),
        channelUid: '1',
        channelName: 'A',
      );
      await store.clear();
      expect(store.listAll(), isEmpty);
      expect(
        box.values.containsKey(ChannelQuietStore.rulesKey),
        isFalse,
      );
    });
  });
}

class _MemoryBox implements ChannelQuietBox {
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
