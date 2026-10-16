import 'dart:async';

import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/dynamics/up.dart';
import 'package:PiliPlus/models/dynamics/up_updates.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _entry(
  int id,
  int mid, {
  int time = 1000,
  dynamic following = 1,
  bool pinned = false,
}) => {
  'id_str': '$id',
  'type': 'DYNAMIC_TYPE_AV',
  'modules': {
    'module_author': {
      'mid': mid,
      'name': 'UP $mid',
      'face': 'https://example.com/$mid.jpg',
      'pub_ts': time,
      'following': following,
      'is_top': pinned,
    },
  },
};

DynamicUpPage _page(
  List<Map<String, dynamic>> entries, {
  bool more = false,
  String? offset,
  int baseline = 0,
}) => DynamicUpPage.fromJson({
  'items': entries,
  'has_more': more,
  'offset': offset,
  'update_baseline': '$baseline',
});

FollowUpModel _ups(List<int> mids) => FollowUpModel.fromUpList({
  'items': [
    for (final mid in mids) {'mid': mid, 'has_update': false},
  ],
});

void main() {
  test(
    'an author omitted by portal is promoted from real feed shape',
    () async {
      final state = DynamicUpUpdates();
      final data = _ups([1, 2, 42]);
      state.applyOfficial(data.upList!);
      await state.scan(
        (_) async => Success(_page([_entry(300, 42)])),
        now: 1100,
      );
      state.apply(data);
      expect(data.upList!.map((item) => item.mid), [42, 1, 2]);
      expect(data.upList!.first.hasUpdate, isTrue);
    },
  );

  test(
    'unlisted updated authors are inserted and newest update is first',
    () async {
      final state = DynamicUpUpdates();
      await state.scan(
        (_) async => Success(
          _page([
            _entry(200, 2),
            _entry(400, 42),
            _entry(300, 3),
            _entry(100, 2),
          ]),
        ),
        now: 1100,
      );
      final data = _ups([9, 2]);
      state.apply(data);
      expect(data.upList!.map((item) => item.mid), [42, 3, 2, 9]);
      expect(data.upList!.first.uname, 'UP 42');
    },
  );

  test(
    'official false and following-list merges cannot erase local unread',
    () async {
      final state = DynamicUpUpdates();
      await state.scan(
        (_) async => Success(_page([_entry(300, 42)])),
        now: 1100,
      );
      final data = _ups([1, 42]);
      state.applyOfficial(data.upList!);
      data.addAllUpList([UpItem(mid: 42), UpItem(mid: 3)]);
      state.apply(data);
      expect(data.upList!.first.mid, 42);
      expect(data.upList!.first.hasUpdate, isTrue);
      expect(data.upList!.where((item) => item.mid == 42).length, 1);
    },
  );

  test('click clears the dot across refresh and application restart', () async {
    final state = DynamicUpUpdates();
    await state.scan((_) async => Success(_page([_entry(300, 42)])), now: 1100);
    state.markRead(42, 1100);
    final restored = DynamicUpUpdates.fromJson(state.toJson())
      ..applyOfficial([UpItem(mid: 42, hasUpdate: true)]);
    await restored.scan(
      (_) async => Success(_page([_entry(300, 42)])),
      now: 1200,
    );
    final data = _ups([1, 42]);
    restored.apply(data);
    expect(data.upList!.map((item) => item.mid), [1, 42]);
    expect(data.upList!.last.hasUpdate, isFalse);
  });

  test(
    'a genuinely new update after reading relights and promotes the author',
    () async {
      final state = DynamicUpUpdates();
      await state.scan(
        (_) async => Success(_page([_entry(300, 42)])),
        now: 1100,
      );
      state.markRead(42, 1100);
      await state.scan(
        (_) async => Success(_page([_entry(500, 42, time: 1200)])),
        now: 1300,
      );
      final data = _ups([1, 42]);
      state.apply(data);
      expect(data.upList!.first.mid, 42);
      expect(data.upList!.first.hasUpdate, isTrue);
    },
  );

  test(
    'a late scan response does not restore content published before click',
    () async {
      final state = DynamicUpUpdates()..markRead(42, 1100);
      await state.scan(
        (_) async => Success(_page([_entry(300, 42, time: 1000)])),
        now: 1200,
      );
      final data = _ups([1, 42]);
      state.apply(data);
      expect(data.upList!.every((item) => item.hasUpdate == false), isTrue);
    },
  );

  test('accepts integer and boolean following, excludes nonfollowing and original authors', () async {
    final state = DynamicUpUpdates();
    await state.scan(
      (_) async => Success(
        _page([
          _entry(400, 1, following: true),
          _entry(300, 2),
          {..._entry(200, 3, following: false), 'orig': _entry(100, 42)},
          _entry(150, 4, following: 0),
        ]),
      ),
      now: 1100,
    );
    final data = _ups([]);
    state.apply(data);
    expect(data.upList!.map((item) => item.mid), [1, 2]);
  });

  for (final following in [false, 0]) {
    test('explicit nonfollowing $following removes cached and visible UPs', () async {
      final state = DynamicUpUpdates();
      await state.scan(
        (_) async => Success(_page([_entry(300, 42)])),
        now: 1100,
      );
      final data = _ups([1, 42]);
      state
        ..applyOfficial([UpItem(mid: 42, hasUpdate: true)])
        ..apply(data);
      // An old dynamic can still carry the author's current follow status.
      await state.scan(
        (_) async => Success(_page([_entry(200, 42, following: following)])),
        now: 1200,
      );
      state.apply(data);
      expect(data.upList!.map((item) => item.mid), [1]);
      // A stale portal response must not reinsert an explicitly unfollowed UP.
      final refreshed = _ups([1, 42]);
      final restored = DynamicUpUpdates.fromJson(state.toJson())
        ..applyOfficial([UpItem(mid: 42, hasUpdate: true)])
        ..apply(refreshed);
      expect(refreshed.upList!.map((item) => item.mid), [1]);
      expect(restored.toJson()['latest'], isEmpty);
    });
  }

  test('missing follow status does not erase a cached unread author', () async {
    final state = DynamicUpUpdates();
    await state.scan((_) async => Success(_page([_entry(300, 42)])), now: 1100);
    await state.scan(
      (_) async => Success(_page([_entry(400, 42, following: null)])),
      now: 1200,
    );
    final data = _ups([1]);
    state.apply(data);
    expect(data.upList!.first.mid, 42);
    expect(data.upList!.first.hasUpdate, isTrue);
  });

  test('a refollowed author can receive new unread updates', () async {
    final state = DynamicUpUpdates();
    await state.scan((_) async => Success(_page([_entry(300, 42)])), now: 1100);
    state.markRead(42, 1100);
    await state.scan(
      (_) async => Success(_page([_entry(400, 42, following: false)])),
      now: 1200,
    );
    final restored = DynamicUpUpdates.fromJson(state.toJson());
    await restored.scan(
      (_) async => Success(_page([_entry(500, 42, time: 1300)])),
      now: 1400,
    );
    final data = _ups([1]);
    restored.apply(data);
    expect(data.upList!.map((item) => item.mid), [42, 1]);
    expect(data.upList!.first.hasUpdate, isTrue);
  });

  test('unfinished scans preserve cursor across restart without advancing baseline', () async {
    final state = DynamicUpUpdates();
    await state.scan(
      (_) async => Success(
        _page([_entry(300, 42)], more: true, offset: 'next', baseline: 350),
      ),
      now: 1100,
      maxPages: 1,
    );
    expect(state.baseline, 0);
    expect(state.hasPending, isTrue);
    final restored = DynamicUpUpdates.fromJson(state.toJson());
    await restored.scan((offset) async {
      expect(offset, 'next');
      return Success(_page([_entry(200, 2)]));
    }, now: 1200);
    expect(restored.baseline, 350);
    expect(restored.hasPending, isFalse);
    final data = _ups([]);
    restored.apply(data);
    expect(data.upList!.map((item) => item.mid), [42, 2]);
  });

  test(
    'incremental scans continue across batches until the previous baseline',
    () async {
      final state = DynamicUpUpdates();
      await state.scan(
        (_) async => Success(_page([_entry(100, 1)])),
        now: 1100,
      );
      await state.scan(
        (_) async => Success(_page([_entry(500, 42)], more: true, offset: 'a')),
        now: 1200,
        maxPages: 1,
      );
      expect(state.baseline, 100);
      final offsets = <String?>[];
      await state.scan((offset) async {
        offsets.add(offset);
        return Success(
          offset == 'a'
              ? _page([_entry(400, 2)], more: true, offset: 'b')
              : _page([_entry(100, 1)], more: true, offset: 'unused'),
        );
      }, now: 1300);
      expect(offsets, ['a', 'b']);
      expect(state.baseline, 500);
    },
  );

  test('an old pinned entry does not prematurely end scanning', () async {
    final state = DynamicUpUpdates();
    await state.scan((_) async => Success(_page([_entry(100, 1)])), now: 1100);
    final offsets = <String?>[];
    await state.scan((offset) async {
      offsets.add(offset);
      return Success(
        offset == null
            ? _page(
                [_entry(50, 9, pinned: true), _entry(500, 42)],
                more: true,
                offset: 'a',
              )
            : _page([_entry(400, 2)]),
      );
    }, now: 1200);
    expect(offsets, [null, 'a']);
    final data = _ups([]);
    state.apply(data);
    expect(data.upList!.map((item) => item.mid), [42, 2, 1]);
  });

  test('network failure keeps the completed baseline and can resume', () async {
    final state = DynamicUpUpdates();
    await state.scan((_) async => Success(_page([_entry(100, 1)])), now: 1100);
    final result = await state.scan(
      (offset) async => offset == null
          ? Success(_page([_entry(400, 42)], more: true, offset: 'next'))
          : const Error('offline'),
      now: 1200,
    );
    expect(result, isA<Error>());
    expect(state.baseline, 100);
    await state.scan((offset) async {
      expect(offset, 'next');
      return Success(_page([_entry(300, 2)]));
    }, now: 1300);
    expect(state.baseline, 400);
  });

  test(
    'repeated cursor stops without accepting an incomplete baseline',
    () async {
      final state = DynamicUpUpdates();
      var calls = 0;
      final result = await state.scan((_) async {
        calls++;
        return Success(_page([_entry(300, 42)], more: true, offset: 'same'));
      }, now: 1100);
      expect(result, isA<Error>());
      expect(calls, 2);
      expect(state.baseline, 0);
    },
  );

  test(
    'initial backfill stops at seven days, later scans use the saved baseline',
    () async {
      const now = 1000000;
      final state = DynamicUpUpdates();
      final offsets = <String?>[];
      await state.scan((offset) async {
        offsets.add(offset);
        return Success(
          offset == null
              ? _page(
                  [_entry(500, 42, time: now - 10)],
                  more: true,
                  offset: 'a',
                )
              : _page([_entry(100, 2, time: 1)], more: true, offset: 'unused'),
        );
      }, now: now);
      expect(offsets, [null, 'a']);
      final data = _ups([]);
      state.apply(data);
      expect(data.upList!.single.mid, 42);
      expect(state.baseline, 500);
    },
  );

  test(
    'click during an in-flight request protects against its older response',
    () async {
      final state = DynamicUpUpdates();
      final response = Completer<LoadingState<DynamicUpPage>>();
      final scanning = state.scan((_) => response.future, now: 1200);
      state.markRead(42, 1100);
      response.complete(Success(_page([_entry(300, 42, time: 1000)])));
      await scanning;
      final data = _ups([42]);
      state.apply(data);
      expect(data.upList!.single.hasUpdate, isFalse);
    },
  );

  test(
    'a cursor cycle spanning batches is detected after cache restore',
    () async {
      var state = DynamicUpUpdates();
      await state.scan(
        (_) async => Success(_page([_entry(500, 42)], more: true, offset: 'a')),
        now: 1100,
        maxPages: 1,
      );
      state = DynamicUpUpdates.fromJson(state.toJson());
      await state.scan(
        (_) async => Success(_page([_entry(400, 2)], more: true, offset: 'b')),
        now: 1100,
        maxPages: 1,
      );
      final result = await state.scan(
        (_) async => Success(_page([_entry(300, 3)], more: true, offset: 'a')),
        now: 1100,
        maxPages: 1,
      );
      expect(result, isA<Error>());
      expect(state.baseline, 0);
      expect(state.hasPending, isFalse);
    },
  );
}
