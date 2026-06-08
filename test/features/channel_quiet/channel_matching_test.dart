import 'package:PiliPlus/pages/video/channel_quiet/channel_quiet_rule.dart';
import 'package:PiliPlus/pages/video/channel_quiet/channel_quiet_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('comment-gate channel matching helpers', () {
    late ChannelQuietStore store;
    late _MemoryBox box;

    setUp(() {
      box = _MemoryBox();
      store = ChannelQuietStore(box: box);
    });

    test('UGC owner mid maps to ugc:<mid> lookup key', () async {
      const mid = 12345;
      const name = 'TestUP';
      await store.add(
        key: ChannelQuietRule.ugcKey(mid),
        channelUid: mid.toString(),
        channelName: name,
        hideComments: true,
        hideDanmaku: false,
      );

      final found = store.lookup(ChannelQuietRule.ugcKey(mid));
      expect(found, isNotNull);
      expect(found!.channelName, name);
      expect(found.hideComments, isTrue);
      expect(found.hideDanmaku, isFalse);
    });

    test('missing UGC owner mid produces null lookup', () {
      final found = store.lookup(ChannelQuietRule.ugcKey(99999));
      expect(found, isNull);
    });

    test('PGC season id maps to pgc:<seasonId> lookup key', () async {
      const seasonId = 888;
      const title = 'BangumiShow';
      await store.add(
        key: ChannelQuietRule.pgcKey(seasonId),
        channelUid: seasonId.toString(),
        channelName: title,
        hideComments: false,
        hideDanmaku: true,
      );

      final found = store.lookup(ChannelQuietRule.pgcKey(seasonId));
      expect(found, isNotNull);
      expect(found!.channelName, title);
      expect(found.hideComments, isFalse);
      expect(found.hideDanmaku, isTrue);
    });

    test('matched hideComments true implies persistentRuleHideReply true',
        () async {
      await store.add(
        key: ChannelQuietRule.ugcKey(1),
        channelUid: '1',
        channelName: 'HiddenChannel',
        hideComments: true,
        hideDanmaku: false,
      );

      final rule = store.lookup(ChannelQuietRule.ugcKey(1));
      final persistentRuleHideReply = rule?.hideComments ?? false;
      expect(persistentRuleHideReply, isTrue);
    });

    test(
        'matched hideDanmaku-only rule does not imply '
            'persistentRuleHideReply', () async {
      await store.add(
        key: ChannelQuietRule.ugcKey(2),
        channelUid: '2',
        channelName: 'DanmakuOnly',
        hideComments: false,
        hideDanmaku: true,
      );

      final rule = store.lookup(ChannelQuietRule.ugcKey(2));
      final persistentRuleHideReply = rule?.hideComments ?? false;
      expect(persistentRuleHideReply, isFalse);
    });

    test('null match implies persistentRuleHideReply false', () {
      final rule = store.lookup(ChannelQuietRule.ugcKey(999));
      final persistentRuleHideReply = rule?.hideComments ?? false;
      expect(persistentRuleHideReply, isFalse);
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
