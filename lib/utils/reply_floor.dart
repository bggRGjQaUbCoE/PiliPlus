import 'dart:async';
import 'dart:convert' show base64, jsonEncode;

import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/reply.dart';
import 'package:PiliPlus/utils/wbi_sign.dart';
import 'package:flutter/foundation.dart';

/// Comment floor numbers (楼层号).
///
/// Bilibili stopped showing floors in 2019, but every top level comment still
/// gets one: the comment list sorted by time is ordered by floor, and its
/// paging cursor *is* the floor. The web API also accepts a page size, so
///
///   query(cursor, ps) → the `ps` comments with floor < cursor, newest first,
///                        and the floor of the last one
///
/// Floors count from 0 (the first comment, 1L, is floor 0).
///
/// Deleted or hidden comments keep their floor, so a page usually skips some
/// numbers. Where a run of comments spans exactly as many floors as it has
/// comments, their floors follow; otherwise the run is split by pinning the
/// middle comment with another query. Every floor shown is therefore exact.
///
/// Comments far down the list (hot or pinned ones) are found by a binary
/// search instead: floors grow with the post time (give or take a second),
/// so the search narrows on time, then picks the comment out of the few
/// around it by id and pins its floor.

/// Comments returned by one [FloorFetcher] call, newest first.
class FloorChunk {
  const FloorChunk({
    required this.rpids,
    required this.ctimes,
    required this.lastFloor,
    required this.isEnd,
  });

  final List<int> rpids;
  final List<int> ctimes;

  /// Floor of the last comment in [rpids].
  final int lastFloor;
  final bool isEnd;
}

/// Returns up to [ps] top level comments with a floor below [cursor] (the
/// newest ones when [cursor] is null), or null when the request failed.
typedef FloorFetcher = Future<FloorChunk?> Function(int? cursor, int ps);

/// Resolves floors of one comment area on demand, newest first, with
/// sequential, rate limited requests.
class ReplyFloorResolver extends ChangeNotifier {
  ReplyFloorResolver({
    required this.fetch,
    this.minInterval = const Duration(milliseconds: 350),
    this.maxRequests = 800,
  });

  final FloorFetcher fetch;
  final Duration minInterval;

  /// Safety cap for one comment area.
  final int maxRequests;

  static const int _chunkSize = 20;

  /// Comments posted this much later than the oldest comment walked so far
  /// can no longer show up further down.
  static const int _ctimeSlack = 120;

  /// Allowed disorder of post times between neighbouring floors (seconds).
  static const int _timeJitter = 5;

  final Map<int, int> _floors = {};
  final Map<int, int> _pending = {}; // rpid -> ctime, walked
  final Map<int, int> _searchPending = {}; // rpid -> ctime, searched

  /// Known (floor, post time) pairs, to narrow searches.
  final List<(int, int)> _samples = [];
  int? _topFloor;

  int? _cursor; // floors below this are not walked yet; null: from the top
  bool _end = false;
  int? _walkedCtime;
  bool _running = false;
  bool _disposed = false;
  bool _stopped = false;
  int requests = 0;
  DateTime? _lastRequest;

  int? floorOf(int rpid) => _floors[rpid];

  /// Asks for the floor of a top level comment; listeners are notified once
  /// it is known.
  ///
  /// Comments of the list sorted by time are resolved by walking down from
  /// the newest; others (hot, pinned) with [search].
  void request(int rpid, int ctime, {bool search = false}) {
    if (_disposed || _floors.containsKey(rpid)) return;
    (search ? _searchPending : _pending)[rpid] = ctime;
    unawaited(_run());
  }

  /// Walks from the newest comment again (after a refresh); known floors
  /// are kept since they never change.
  void restart() {
    _cursor = null;
    _end = false;
    _walkedCtime = null;
  }

  Future<void> _run() async {
    if (_running) return;
    _running = true;
    try {
      while (!_disposed && !_stopped && requests < maxRequests) {
        _searchPending.removeWhere((rpid, _) => _floors.containsKey(rpid));
        if (_searchPending.isNotEmpty) {
          // hot and pinned comments sit at the top of the list: first
          final MapEntry(:key, :value) = _searchPending.entries.first;
          _searchPending.remove(key);
          await _search(key, value);
          continue;
        }
        final walked = _walkedCtime;
        _pending.removeWhere(
          (rpid, ctime) =>
              _floors.containsKey(rpid) ||
              (walked != null && ctime > walked + _ctimeSlack),
        );
        if (_pending.isEmpty || _end) break;
        if (!await _walkChunk()) break;
      }
    } catch (e) {
      if (kDebugMode) debugPrint('ReplyFloorResolver: $e');
    } finally {
      _running = false;
    }
  }

  Future<FloorChunk?> _query(int? cursor, int ps) async {
    if (_disposed || _stopped || requests >= maxRequests) return null;
    final last = _lastRequest;
    if (last != null) {
      final wait = minInterval - DateTime.now().difference(last);
      if (wait > Duration.zero) await Future<void>.delayed(wait);
    }
    if (_disposed) return null;
    requests++;
    _lastRequest = DateTime.now();
    final res = await fetch(cursor, ps);
    if (res == null) {
      // failed or rate limited: stop instead of hammering the API
      _stopped = true;
    }
    return res;
  }

  /// Resolves the next chunk below [_cursor]; returns false to stop.
  Future<bool> _walkChunk() async {
    final chunk = await _query(_cursor, _chunkSize);
    if (chunk == null) return false;
    final rpids = chunk.rpids;
    final n = rpids.length;
    if (n == 0) {
      _end = true;
      return false;
    }
    final floors = List<int?>.filled(n, null);
    floors[n - 1] = chunk.lastFloor;

    if (n > 1) {
      if (_cursor case final cursor?) {
        await _solve(rpids, floors, 0, n - 1, cursor - 1);
      } else {
        // the newest comment has no upper bound: pin it
        final first = await _query(null, 1);
        if (first == null) return false;
        if (first.rpids.isNotEmpty) {
          _floors[first.rpids.first] = first.lastFloor;
        }
        if (first.rpids.isNotEmpty && first.rpids.first == rpids.first) {
          floors[0] = first.lastFloor;
          await _solve(rpids, floors, 1, n - 1, first.lastFloor - 1);
        } else if (first.rpids.isNotEmpty) {
          // a newer comment arrived in between; its floor still bounds the
          // whole chunk from above
          await _solve(rpids, floors, 0, n - 1, first.lastFloor - 1);
        }
      }
    }

    for (var i = 0; i < n; i++) {
      if (floors[i] case final floor?) {
        _floors[rpids[i]] = floor;
        _samples.add((floor, chunk.ctimes[i]));
      }
    }
    _topFloor ??= floors[0];
    _cursor = chunk.lastFloor;
    _walkedCtime = chunk.ctimes.last;
    _end = chunk.isEnd;
    _notify();
    return !_end;
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  /// Queries one comment below [cursor] and records its floor.
  Future<FloorChunk?> _probe(int? cursor) async {
    final res = await _query(cursor, 1);
    if (res != null && res.rpids.isNotEmpty) {
      _floors[res.rpids.first] = res.lastFloor;
      _samples.add((res.lastFloor, res.ctimes.first));
      if (cursor == null) _topFloor = res.lastFloor;
    }
    return res;
  }

  /// Finds the floor of comment [rpid] posted at [ctime] by a binary search
  /// on post time. Shows nothing rather than a guess when it cannot be
  /// confirmed by id.
  Future<void> _search(int rpid, int ctime) async {
    if (_topFloor == null) {
      if (await _probe(null) == null) return;
      if (_floors.containsKey(rpid)) {
        _notify();
        return;
      }
    }
    final top = _topFloor;
    if (top == null) return;

    // smallest floor posted clearly after the comment: it is just below
    final after = ctime + _timeJitter;
    var lo = 0;
    var hi = top + 1;
    for (final (floor, time) in _samples) {
      if (time > after) {
        if (floor < hi) hi = floor;
      } else if (floor + 1 > lo && time < ctime - _timeJitter) {
        lo = floor + 1;
      }
    }
    if (lo > hi) lo = hi;
    while (lo < hi) {
      final mid = (lo + hi) ~/ 2;
      final res = await _probe(mid + 1);
      if (res == null) return;
      if (_floors.containsKey(rpid)) {
        _notify();
        return;
      }
      if (res.rpids.isEmpty) {
        lo = mid + 1;
      } else if (res.ctimes.first > after) {
        hi = res.lastFloor;
      } else {
        lo = mid + 1;
      }
    }

    // pick it out of the comments just below by id, then pin its floor
    var cursor = lo;
    for (var round = 0; round < 3; round++) {
      final window = await _query(cursor, _chunkSize);
      if (window == null || window.rpids.isEmpty) return;
      final index = window.rpids.indexOf(rpid);
      if (index != -1) {
        final pinned = index == window.rpids.length - 1
            ? window
            : await _query(cursor, index + 1);
        if (pinned != null && pinned.rpids.lastOrNull == rpid) {
          _floors[rpid] = pinned.lastFloor;
          _samples.add((pinned.lastFloor, ctime));
          _notify();
        }
        return;
      }
      if (window.ctimes.last < ctime - _timeJitter) return; // passed it
      cursor = window.lastFloor;
    }
  }

  /// Fills `floors[lo..hi-1]`; `floors[hi]` is known and comment [lo] has a
  /// floor of at most [bound].
  Future<void> _solve(
    List<int> rpids,
    List<int?> floors,
    int lo,
    int hi,
    int bound,
  ) async {
    if (lo >= hi) return;
    final known = floors[hi]!;
    if (bound - known == hi - lo) {
      // as many floors as comments: no gap
      for (var k = lo; k < hi; k++) {
        floors[k] = known + (hi - k);
      }
      return;
    }
    final mid = (lo + hi - 1) ~/ 2;
    final res = await _query(bound + 1, mid - lo + 1);
    if (res == null || res.rpids.isEmpty) return;
    if (!listEquals(res.rpids, rpids.sublist(lo, mid + 1))) {
      // the area changed in between; keep the floor that is certain
      _floors[res.rpids.last] = res.lastFloor;
      return;
    }
    floors[mid] = res.lastFloor;
    await _solve(rpids, floors, lo, mid, bound);
    await _solve(rpids, floors, mid + 1, hi, res.lastFloor - 1);
  }

  @override
  void dispose() {
    _disposed = true;
    _pending.clear();
    _searchPending.clear();
    super.dispose();
  }
}

abstract final class ReplyFloorHttp {
  /// `pagination_str` offset for the time sorted list starting below
  /// [cursor]: protobuf {1: 1, 6: {1: cursor}}.
  @visibleForTesting
  static String encodeOffset(int cursor) {
    final varint = <int>[];
    var v = cursor;
    while (v >= 0x80) {
      varint.add((v & 0x7f) | 0x80);
      v >>= 7;
    }
    varint.add(v);
    final inner = [0x08, ...varint];
    return base64.encode([0x08, 0x01, 0x32, inner.length, ...inner]);
  }

  /// Top level comments of an area sorted by time, below [cursor].
  /// Sent without the account's cookies.
  static Future<FloorChunk?> fetch({
    required int oid,
    required int type,
    required int? cursor,
    required int ps,
  }) async {
    try {
      final params = await WbiSign.makSign({
        'type': type,
        'oid': oid,
        'mode': 2,
        'pagination_str': jsonEncode({
          'offset': cursor == null ? '' : encodeOffset(cursor),
        }),
        'plat': 1,
        'web_location': 1315875,
        'ps': ps,
      });
      final res = await Request().get(
        '${Api.replyList}/wbi/main',
        queryParameters: params,
        options: ReplyHttp.options,
      );
      final data = res.data;
      if (data is! Map || data['code'] != 0) return null;
      final body = data['data'] as Map;
      final cursorInfo = body['cursor'] as Map;
      final replies = (body['replies'] as List?) ?? const [];
      return FloorChunk(
        rpids: [for (final e in replies) (e['rpid'] as num).toInt()],
        ctimes: [for (final e in replies) (e['ctime'] as num).toInt()],
        lastFloor: (cursorInfo['next'] as num).toInt(),
        isEnd: cursorInfo['is_end'] == true,
      );
    } catch (e) {
      if (kDebugMode) debugPrint('ReplyFloorHttp: $e');
      return null;
    }
  }
}
