import 'package:PiliPlus/http/dynamics_up_list.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/dynamics/up.dart';
import 'package:flutter_test/flutter_test.dart';

FollowUpModel _page(
  List<(int, bool)> ups, {
  bool hasMore = false,
  String? offset,
}) => FollowUpModel.fromUpList({
  'items': [
    for (final (mid, hasUpdate) in ups) {'mid': mid, 'has_update': hasUpdate},
  ],
  'has_more': hasMore,
  'offset': offset,
});

void main() {
  test('loads unread UPs beyond the portal page before read UPs', () async {
    final first = _page([(1, true), (2, false)], hasMore: true, offset: 'a');
    final requested = <String>[];
    final result = await loadAllDynamicUps(first, (offset) async {
      requested.add(offset);
      return Success(switch (offset) {
        'a' => _page([(3, true), (4, false)], hasMore: true, offset: 'b'),
        'b' => _page([(5, true)]),
        _ => throw StateError('Unexpected offset: $offset'),
      });
    });

    expect(requested, ['a', 'b']);
    expect(result.data.upList!.map((item) => item.mid), [1, 3, 5, 2, 4]);
    expect(
      result.data.upList!.take(3).every((item) => item.hasUpdate!),
      isTrue,
    );
    expect(result.data.hasMore, isFalse);
  });

  test('deduplicates page boundaries without losing unread flags', () async {
    final first = _page([(1, false), (2, true)], hasMore: true, offset: 'a');
    final result = await loadAllDynamicUps(first, (_) async {
      return Success(_page([(1, true), (2, false), (3, false)]));
    });

    expect(result.data.upList!.map((item) => item.mid), [1, 2, 3]);
    expect(result.data.upList![0].hasUpdate, isTrue);
    expect(result.data.upList![1].hasUpdate, isTrue);
  });

  test('keeps live users from the portal response', () async {
    final first = FollowUpModel.fromJson({
      'live_users': {
        'count': 1,
        'items': [
          {'mid': 99, 'room_id': 100},
        ],
      },
      'up_list': {
        'items': [
          {'mid': 1, 'has_update': true},
        ],
        'has_more': true,
        'offset': 'a',
      },
    });
    final liveUsers = first.liveUsers;
    final result = await loadAllDynamicUps(
      first,
      (_) async => Success(_page([(2, true)])),
    );

    expect(result.data.liveUsers, same(liveUsers));
    expect(result.data.liveUsers!.items!.single.roomId, 100);
  });

  test('followings cannot replace dynamic flags or add duplicate UPs', () {
    final dynamicUps = _page([(1, true), (2, false)]);
    final firstFollowingPage = FollowUpModel.fromFollowList({
      'list': [
        {'mid': 1, 'uname': 'first'},
        {'mid': 3, 'uname': 'third'},
      ],
    });
    final secondFollowingPage = FollowUpModel.fromFollowList({
      'list': [
        {'mid': 3, 'uname': 'third'},
        {'mid': 4, 'uname': 'fourth'},
      ],
    });

    dynamicUps
      ..addAllUpList(firstFollowingPage.upList!)
      ..addAllUpList(secondFollowingPage.upList!);

    expect(dynamicUps.upList!.map((item) => item.mid), [1, 2, 3, 4]);
    expect(dynamicUps.upList!.first.hasUpdate, isTrue);
    expect(dynamicUps.upList![2].uname, 'third');
  });

  test('an empty dynamic list can still receive followed UPs', () async {
    final result = await loadAllDynamicUps(
      _page([]),
      (_) async => throw StateError('No next page expected'),
    );
    result.data.addAllUpList([UpItem(mid: 1)]);

    expect(result.data.upList!.single.mid, 1);
  });

  test(
    'does not fetch another page when the portal list is complete',
    () async {
      final result = await loadAllDynamicUps(
        _page([(1, false), (2, true)]),
        (_) async => throw StateError('No next page expected'),
      );

      expect(result.data.upList!.map((item) => item.mid), [2, 1]);
    },
  );

  test('continues through an empty page with a next cursor', () async {
    final requested = <String>[];
    final result = await loadAllDynamicUps(
      _page([(1, false)], hasMore: true, offset: 'a'),
      (offset) async {
        requested.add(offset);
        return Success(
          offset == 'a'
              ? _page([], hasMore: true, offset: 'b')
              : _page([(2, true)]),
        );
      },
    );

    expect(requested, ['a', 'b']);
    expect(result.data.upList!.map((item) => item.mid), [2, 1]);
  });

  test(
    'returns page failures instead of accepting incomplete unread data',
    () async {
      const failure = Error('request failed', code: -1);
      final result = await loadAllDynamicUps(
        _page([(1, false)], hasMore: true, offset: 'a'),
        (_) async => failure,
      );

      expect(result, same(failure));
    },
  );

  test('stops a repeated cursor instead of requesting forever', () async {
    var calls = 0;
    final result = await loadAllDynamicUps(
      _page([(1, true)], hasMore: true, offset: 'a'),
      (_) async {
        calls++;
        return Success(_page([(2, true)], hasMore: true, offset: 'a'));
      },
    );

    expect(result, isA<Error>());
    expect(calls, 1);
  });

  test('does not accept a truncated list with a missing next cursor', () async {
    final result = await loadAllDynamicUps(
      _page([(1, false)], hasMore: true),
      (_) async => throw StateError('No valid cursor to request'),
    );

    expect(result, isA<Error>());
  });

  test(
    'refresh discovers a new update after the old dot was cleared',
    () async {
      final firstResult = await loadAllDynamicUps(
        _page([(1, true)]),
        (_) async => throw StateError('No next page expected'),
      );
      firstResult.data.upList!.single.hasUpdate = false;
      final refreshed = await loadAllDynamicUps(
        _page([(2, false)], hasMore: true, offset: 'new'),
        (_) async => Success(_page([(1, true)])),
      );

      expect(refreshed.data.upList!.first.mid, 1);
      expect(refreshed.data.upList!.first.hasUpdate, isTrue);
    },
  );
}
