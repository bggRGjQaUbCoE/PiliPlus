import 'package:PiliPlus/pages/video/channel_quiet/channel_quiet_rule.dart';
import 'package:PiliPlus/pages/video/channel_quiet/channel_quiet_store.dart';
import 'package:PiliPlus/pages/video/channel_quiet/channel_quiet_target.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChannelQuietTarget', () {
    test('UGC target has correct fields', () {
      const target = ChannelQuietTarget(
        key: 'ugc:42',
        channelUid: '42',
        channelName: 'TestUP',
      );
      expect(target.key, 'ugc:42');
      expect(target.channelUid, '42');
      expect(target.channelName, 'TestUP');
    });

    test('PGC target has correct fields', () {
      const target = ChannelQuietTarget(
        key: 'pgc:888',
        channelUid: '888',
        channelName: 'BangumiShow',
      );
      expect(target.key, 'pgc:888');
      expect(target.channelUid, '888');
      expect(target.channelName, 'BangumiShow');
    });

    test('equality compares key, channelUid, channelName', () {
      const a = ChannelQuietTarget(
        key: 'ugc:1',
        channelUid: '1',
        channelName: 'A',
      );
      const b = ChannelQuietTarget(
        key: 'ugc:1',
        channelUid: '1',
        channelName: 'A',
      );
      const c = ChannelQuietTarget(
        key: 'ugc:2',
        channelUid: '2',
        channelName: 'C',
      );

      expect(a, equals(b));
      expect(a, isNot(c));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('toString includes key and channel name', () {
      const target = ChannelQuietTarget(
        key: 'ugc:42',
        channelUid: '42',
        channelName: 'TestUP',
      );
      final str = target.toString();
      expect(str, contains('ugc:42'));
      expect(str, contains('TestUP'));
    });
  });

  group('channelQuietActionLabel', () {
    test('returns add label when no existing rule', () {
      expect(channelQuietActionLabel(null), '添加频道屏蔽');
    });

    test('returns edit label when rule exists', () {
      final rule = ChannelQuietRule(
        key: 'ugc:1',
        channelUid: '1',
        channelName: 'Test',
        createdAt: DateTime.fromMillisecondsSinceEpoch(100),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(200),
      );
      expect(channelQuietActionLabel(rule), '编辑频道屏蔽');
    });
  });

  group('channelQuietEditorTitle', () {
    test('returns add title when no existing rule', () {
      expect(channelQuietEditorTitle(null), '新增频道屏蔽');
    });

    test('returns edit title when rule exists', () {
      final rule = ChannelQuietRule(
        key: 'ugc:1',
        channelUid: '1',
        channelName: 'Test',
        createdAt: DateTime.fromMillisecondsSinceEpoch(100),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(200),
      );
      expect(channelQuietEditorTitle(rule), '编辑频道屏蔽');
    });
  });

  group('ChannelQuietTarget key construction', () {
    test('ugcKey matches target key format', () {
      final target = ChannelQuietTarget(
        key: ChannelQuietRule.ugcKey(42),
        channelUid: '42',
        channelName: '',
      );
      expect(target.key, 'ugc:42');
    });

    test('pgcKey matches target key format', () {
      final target = ChannelQuietTarget(
        key: ChannelQuietRule.pgcKey(888),
        channelUid: '888',
        channelName: '',
      );
      expect(target.key, 'pgc:888');
    });
  });

  group('save/update/remove persistence semantics', () {
    late ChannelQuietStore store;
    late _MemoryBox box;

    setUp(() {
      box = _MemoryBox();
      store = ChannelQuietStore(box: box);
    });

    test('add creates rule with fresh createdAt', () async {
      final target = const ChannelQuietTarget(
        key: 'ugc:42',
        channelUid: '42',
        channelName: 'TestUP',
      );
      final before = DateTime.now().millisecondsSinceEpoch;

      final rule = await store.add(
        key: target.key,
        channelUid: target.channelUid,
        channelName: target.channelName,
        hideComments: true,
        hideDanmaku: false,
      );

      final after = DateTime.now().millisecondsSinceEpoch;
      expect(rule.key, target.key);
      expect(rule.channelName, target.channelName);
      expect(rule.hideComments, isTrue);
      expect(rule.hideDanmaku, isFalse);
      expect(
        rule.createdAt.millisecondsSinceEpoch,
        greaterThanOrEqualTo(before),
      );
      expect(
        rule.createdAt.millisecondsSinceEpoch,
        lessThanOrEqualTo(after),
      );
    });

    test('update preserves createdAt and changes fields', () async {
      final target = const ChannelQuietTarget(
        key: 'ugc:42',
        channelUid: '42',
        channelName: 'OldName',
      );
      await store.add(
        key: target.key,
        channelUid: target.channelUid,
        channelName: 'OldName',
      );
      final original = store.lookup(target.key)!;
      final originalCreated = original.createdAt;

      await Future<void>.delayed(const Duration(milliseconds: 5));

      final updated = await store.update(
        key: target.key,
        channelName: 'NewName',
        hideComments: true,
        hideDanmaku: true,
      );

      expect(updated, isNotNull);
      expect(updated!.channelName, 'NewName');
      expect(updated.hideComments, isTrue);
      expect(updated.hideDanmaku, isTrue);
      expect(updated.createdAt, originalCreated);
      expect(
        updated.updatedAt.millisecondsSinceEpoch,
        greaterThan(originalCreated.millisecondsSinceEpoch),
      );

      // Verify cached state reflects update
      final cached = store.lookup(target.key);
      expect(cached, isNotNull);
      expect(cached!.channelName, 'NewName');
    });

    test('delete removes rule from store', () async {
      final target = const ChannelQuietTarget(
        key: 'ugc:42',
        channelUid: '42',
        channelName: 'TestUP',
      );
      await store.add(
        key: target.key,
        channelUid: target.channelUid,
        channelName: target.channelName,
      );

      final deleted = await store.delete(target.key);
      expect(deleted, isTrue);

      final found = store.lookup(target.key);
      expect(found, isNull);
    });

    test('add for existing key acts as upsert', () async {
      final target = const ChannelQuietTarget(
        key: 'ugc:42',
        channelUid: '42',
        channelName: 'TestUP',
      );
      await store.add(
        key: target.key,
        channelUid: target.channelUid,
        channelName: target.channelName,
        hideComments: false,
      );
      // Second add with same key replaces
      final second = await store.add(
        key: target.key,
        channelUid: target.channelUid,
        channelName: 'UpdatedName',
        hideComments: true,
      );

      expect(second.channelName, 'UpdatedName');
      expect(second.hideComments, isTrue);
      // Only one rule with this key should exist
      final all = store.listAll();
      expect(all, hasLength(1));
      expect(all.single.key, target.key);
    });

    test('lookup returns null for missing target', () {
      final found = store.lookup(ChannelQuietRule.ugcKey(99999));
      expect(found, isNull);
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
