import 'dart:convert';
import 'dart:math';

import 'package:PiliPlus/utils/reply_floor.dart';
import 'package:flutter_test/flutter_test.dart';

/// A comment area with the semantics of the web API (verified against
/// bilibili): floors increase with time, deleted floors are skipped, and
/// query(cursor, ps) returns the newest `ps` comments with floor < cursor.
///
/// Post times grow with the floor like on bilibili: some comments share a
/// second, and neighbours are occasionally out of order by a second (seen
/// on av10001: #553 posted a second before #552).
class _Area {
  _Area(int floors, {double deleted = 0, int seed = 1}) : _rnd = Random(seed) {
    for (var f = 1; f <= floors; f++) {
      if (_rnd.nextDouble() >= deleted) _add(f);
    }
  }

  final Random _rnd;
  final floorOf = <int, int>{}; // rpid -> floor
  final _ctime = <int, int>{}; // floor -> post time
  final _visible = <int>[]; // floors, ascending
  var _clock = 1700000000;

  int ctimeOf(int rpid) => _ctime[floorOf[rpid]!]!;

  int calls = 0;
  bool fail = false;

  void _add(int floor) {
    // 0-30 s apart, a third of them in the same second
    if (_rnd.nextDouble() > 0.33) _clock += _rnd.nextInt(30) + 1;
    // occasionally a second out of order
    final jitter = _rnd.nextDouble() < 0.05 ? -1 : 0;
    _visible.add(floor);
    floorOf[1000000 + floor] = floor;
    _ctime[floor] = _clock + jitter;
  }

  int get top => _visible.last;

  /// Posts a new comment (next floor).
  void post() => _add(top + 1);

  Future<FloorChunk?> fetch(int? cursor, int ps) async {
    calls++;
    if (fail) return null;
    final below = _visible.reversed
        .where((f) => cursor == null || f < cursor)
        .take(ps)
        .toList();
    return FloorChunk(
      rpids: [for (final f in below) 1000000 + f],
      ctimes: [for (final f in below) _ctime[f]!],
      lastFloor: below.isEmpty ? 0 : below.last,
      isEnd: below.isEmpty || below.last == _visible.first,
    );
  }

  List<int> newest(int n) => [
    for (final f in _visible.reversed.take(n)) 1000000 + f,
  ];
}

Future<void> _settle(ReplyFloorResolver r) async {
  for (var i = 0; i < 2000; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

ReplyFloorResolver _resolver(_Area area) =>
    ReplyFloorResolver(fetch: area.fetch, minInterval: Duration.zero);

void main() {
  test('游标编码与网页接口一致', () {
    // captured from the web client: {1: 1, 6: {1: 160548}}
    expect(
      base64.decode(ReplyFloorHttp.encodeOffset(160548)),
      [0x08, 0x01, 0x32, 0x04, 0x08, 0xa4, 0xe6, 0x09],
    );
  });

  for (final (name, deleted) in [
    ('没有删除', 0.0),
    ('少量删除（几百条视频的实测比例）', 0.15),
    ('大量删除（大热视频）', 0.4),
  ]) {
    test('每条都准：$name', () async {
      final area = _Area(500, deleted: deleted, seed: 7);
      final r = _resolver(area);
      final shown = area.newest(60); // three pages scrolled
      for (final rpid in shown) {
        r.request(rpid, area.ctimeOf(rpid));
      }
      await _settle(r);
      for (final rpid in shown) {
        expect(r.floorOf(rpid), area.floorOf[rpid], reason: 'rpid $rpid');
      }
      // ignore: avoid_print
      print('$name: 60 条用了 ${area.calls} 次请求');
    });
  }

  test('没有删除时每 20 条只需 1 次请求（首页 2 次）', () async {
    final area = _Area(500);
    final r = _resolver(area);
    for (final rpid in area.newest(60)) {
      r.request(rpid, area.ctimeOf(rpid));
    }
    await _settle(r);
    expect(area.calls, 4);
  });

  test('只在需要时才继续往下走', () async {
    final area = _Area(500, deleted: 0.2, seed: 3);
    final r = _resolver(area);
    final first = area.newest(1).first;
    r.request(first, area.ctimeOf(first));
    await _settle(r);
    final calls = area.calls;
    expect(r.floorOf(first), area.floorOf[first]);
    await _settle(r);
    expect(area.calls, calls, reason: 'idle until more comments are shown');
  });

  test('走查过程中有新评论发出，楼层号仍然准确', () async {
    final area = _Area(300, deleted: 0.2, seed: 5);
    final shown = area.newest(40);
    final r = ReplyFloorResolver(
      fetch: (cursor, ps) {
        if (area.calls == 1) area.post(); // arrives after the first request
        return area.fetch(cursor, ps);
      },
      minInterval: Duration.zero,
    );
    for (final rpid in shown) {
      r.request(rpid, area.ctimeOf(rpid));
    }
    await _settle(r);
    for (final rpid in shown) {
      final floor = r.floorOf(rpid);
      if (floor != null) expect(floor, area.floorOf[rpid]);
    }
    expect(shown.where((e) => r.floorOf(e) != null).length, greaterThan(30));
  });

  test('置顶等不在时间序列里的旧评论：走过它的时间后放弃，不会一直往下请求', () async {
    final area = _Area(2000, deleted: 0.1, seed: 9);
    final r = _resolver(area);
    final newest = area.newest(20);
    for (final rpid in newest) {
      r.request(rpid, area.ctimeOf(rpid));
    }
    // an unknown comment whose time is far newer than anything below
    r.request(42, area.ctimeOf(area.newest(1).first) + 10000);
    await _settle(r);
    expect(r.floorOf(42), isNull);
    expect(area.calls, lessThan(20));
  });

  test('热评（不在按时间列表里）：二分查找，楼层号全部准确', () async {
    for (final (deleted, seed) in [(0.0, 11), (0.15, 12), (0.4, 13)]) {
      final area = _Area(20000, deleted: deleted, seed: seed);
      final r = _resolver(area);
      final rnd = Random(seed);
      final rpids = area.floorOf.keys.toList();
      final hot = [
        for (var i = 0; i < 8; i++) rpids[rnd.nextInt(rpids.length)],
      ];
      for (final rpid in hot) {
        r.request(rpid, area.ctimeOf(rpid), search: true);
      }
      await _settle(r);
      for (final rpid in hot) {
        expect(r.floorOf(rpid), area.floorOf[rpid], reason: 'rpid $rpid');
      }
      // ignore: avoid_print
      print('删除 ${(deleted * 100).round()}%，2 万楼里查 8 条热评共 ${area.calls} 次请求');
      expect(area.calls / hot.length, lessThan(25));
    }
  });

  test('查不到的评论不显示楼层号，请求次数有上限', () async {
    final area = _Area(5000, seed: 21);
    final r = _resolver(area);
    final some = area.newest(3000).last;
    r.request(424242, area.ctimeOf(some), search: true); // not in the area
    await _settle(r);
    expect(r.floorOf(424242), isNull);
    expect(area.calls, lessThan(25));
  });

  test('热评和按时间列表同时进行', () async {
    final area = _Area(3000, deleted: 0.15, seed: 31);
    final r = _resolver(area);
    final rpids = area.floorOf.keys.toList();
    final hot = [rpids[100], rpids[1500]];
    final latest = area.newest(40);
    for (final rpid in hot) {
      r.request(rpid, area.ctimeOf(rpid), search: true);
    }
    for (final rpid in latest) {
      r.request(rpid, area.ctimeOf(rpid));
    }
    await _settle(r);
    for (final rpid in [...hot, ...latest]) {
      expect(r.floorOf(rpid), area.floorOf[rpid]);
    }
  });

  test('请求失败后停止，不会反复重试', () async {
    final area = _Area(200)..fail = true;
    final r = _resolver(area);
    for (final rpid in area.newest(20)) {
      r.request(rpid, 0);
    }
    await _settle(r);
    expect(area.calls, 1);
  });
}
