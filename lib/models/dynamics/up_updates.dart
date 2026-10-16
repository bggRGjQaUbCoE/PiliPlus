import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/dynamics/up.dart';
import 'package:PiliPlus/utils/parse_int.dart';

class DynamicUpEntry {
  DynamicUpEntry.fromJson(Map json) {
    id = safeToInt(json['id_str']) ?? 0;
    final author = json['modules']?['module_author'];
    if (author is Map) {
      mid = safeToInt(author['mid']) ?? 0;
      publishedAt = safeToInt(author['pub_ts']) ?? 0;
      pinned = author['is_top'] == true || author['is_top'] == 1;
      final value = author['following'];
      following = value == true || value == 1
          ? true
          : value == false || value == 0
          ? false
          : null;
      if (following == true && mid > 0) {
        up = UpItem(mid: mid, uname: author['name'], face: author['face']);
      }
    }
  }

  late final int id;
  int mid = 0;
  bool? following;
  int publishedAt = 0;
  bool pinned = false;
  UpItem? up;

  Map<String, dynamic> toJson() => {
    'id_str': '$id',
    'modules': {
      'module_author': {
        'mid': up!.mid,
        'name': up!.uname,
        'face': up!.face,
        'following': 1,
        'pub_ts': publishedAt,
      },
    },
  };
}

class DynamicUpPage {
  DynamicUpPage.fromJson(Map<String, dynamic> json)
    : entries = [
        for (final item in json['items'] as List? ?? const [])
          if (item is Map) DynamicUpEntry.fromJson(item),
      ],
      offset = json['offset']?.toString(),
      hasMore = json['has_more'] == true || json['has_more'] == 1,
      baseline = safeToInt(json['update_baseline']) ?? 0;

  final List<DynamicUpEntry> entries;
  final String? offset;
  final bool hasMore;
  final int baseline;
}

/// The official UP list covers only part of the followed authors. Track actual
/// feed entries locally; reading one author's feed must not mark other UPs read.
class DynamicUpUpdates {
  int baseline = 0;
  int _target = 0;
  int _initialSince = 0;
  String? _offset;
  final _latest = <int, DynamicUpEntry>{};
  final _readIds = <int, int>{};
  final _readAt = <int, int>{};
  final _official = <int, UpItem>{};
  final _dismissed = <int>{};
  final _unfollowed = <int>{};
  final _visited = <String>{};

  bool get hasPending => _offset?.isNotEmpty == true;

  Future<LoadingState<bool>> scan(
    Future<LoadingState<DynamicUpPage>> Function(String? offset) loadPage, {
    required int now,
    int maxPages = 4,
  }) async {
    // First use has no historical read evidence. Backfill the last seven days;
    // subsequent scans continue all the way back to the last completed baseline.
    if (baseline == 0 && _initialSince == 0) {
      _initialSince = now - const Duration(days: 7).inSeconds;
    }
    for (var count = 0; count < maxPages; count++) {
      final result = await loadPage(_offset);
      if (result case Error(:final errMsg)) return Error(errMsg);
      if (result is! Success<DynamicUpPage>) {
        return const Error('更新动态加载失败');
      }
      final page = result.response;
      if (_target == 0) {
        _target = page.baseline;
        for (final entry in page.entries) {
          if (entry.id > _target) _target = entry.id;
        }
      }
      for (final entry in page.entries) {
        // Follow status is current even when this dynamic predates the baseline.
        if (entry.mid > 0 && entry.following == false) {
          _latest.remove(entry.mid);
          _official.remove(entry.mid);
          _dismissed.remove(entry.mid);
          _unfollowed.add(entry.mid);
          continue;
        }
        if (entry.following == true) _unfollowed.remove(entry.mid);
        if (entry.id <= baseline || entry.id <= 0 || entry.up == null) continue;
        if (baseline == 0 && entry.publishedAt < _initialSince) continue;
        final old = _latest[entry.up!.mid];
        if (old == null || entry.id > old.id) {
          _latest[entry.up!.mid] = entry;
        }
      }
      final ordered = page.entries.where((entry) => !entry.pinned).toList();
      final passed =
          ordered.isNotEmpty &&
          ordered.every(
            (entry) => baseline > 0
                ? entry.id > 0 && entry.id <= baseline
                : entry.publishedAt > 0 && entry.publishedAt < _initialSince,
          );
      if (!page.hasMore || passed) {
        if (_target > baseline) baseline = _target;
        _target = 0;
        _offset = null;
        _visited.clear();
        return const Success(true);
      }
      final next = page.offset;
      if (next == null ||
          next.isEmpty ||
          next == _offset ||
          !_visited.add(next)) {
        // A broken cursor cannot establish a complete baseline. Rescan the
        // interval from its beginning next time, keeping already collected UPs.
        _offset = null;
        _target = 0;
        _visited.clear();
        return const Error('更新动态分页未推进，请刷新重试');
      }
      _offset = next;
    }
    return const Success(false);
  }

  void applyOfficial(Iterable<UpItem> ups, {bool replace = true}) {
    if (replace) _official.clear();
    for (final up in ups) {
      if (_unfollowed.contains(up.mid)) continue;
      if (up.hasUpdate == true) {
        if (!_dismissed.contains(up.mid)) _official[up.mid] = up;
      } else if (up.hasUpdate == false) {
        _official.remove(up.mid);
        _dismissed.remove(up.mid);
      }
    }
  }

  bool _isUnread(DynamicUpEntry entry) {
    final mid = entry.up!.mid;
    return entry.id > (_readIds[mid] ?? 0) &&
        (entry.publishedAt == 0 || entry.publishedAt >= (_readAt[mid] ?? 0));
  }

  void markRead(int mid, int now) {
    if (mid <= 0) return;
    final id = _latest[mid]?.id ?? 0;
    if (id > (_readIds[mid] ?? 0)) _readIds[mid] = id;
    if (now > (_readAt[mid] ?? 0)) _readAt[mid] = now;
    _official.remove(mid);
    _dismissed.add(mid);
  }

  void apply(FollowUpModel data, {bool sort = true}) {
    final unread = <int, UpItem>{
      ..._official,
      for (final entry in _latest.values)
        if (_isUnread(entry)) entry.up!.mid: entry.up!,
    };
    final list = (data.upList ??= [])
      ..removeWhere((item) => _unfollowed.contains(item.mid));
    final mids = {for (final item in list) item.mid};
    list.addAll(
      unread.values
          .where((item) => mids.add(item.mid))
          .map(
            (item) => UpItem(mid: item.mid, uname: item.uname, face: item.face),
          ),
    );
    for (final item in list) {
      item.hasUpdate = unread.containsKey(item.mid);
    }
    if (!sort) return;
    final positions = {
      for (final (index, item) in list.indexed) item.mid: index,
    };
    list.sort((a, b) {
      final flags = (b.hasUpdate == true ? 1 : 0).compareTo(
        a.hasUpdate == true ? 1 : 0,
      );
      if (flags != 0) return flags;
      if (a.hasUpdate == true) {
        final latest = (_latest[b.mid]?.id ?? 0).compareTo(
          _latest[a.mid]?.id ?? 0,
        );
        if (latest != 0) return latest;
      }
      return positions[a.mid]!.compareTo(positions[b.mid]!);
    });
  }

  Map<String, dynamic> toJson() => {
    'baseline': baseline,
    'target': _target,
    'offset': _offset,
    'since': _initialSince,
    'latest': _latest.values.map((entry) => entry.toJson()).toList(),
    'read_ids': _readIds.map((mid, id) => MapEntry('$mid', id)),
    'read_at': _readAt.map((mid, time) => MapEntry('$mid', time)),
    'dismissed': _dismissed.toList(),
    'unfollowed': _unfollowed.toList(),
    'visited': _visited.toList(),
  };

  static DynamicUpUpdates fromJson(dynamic json) {
    final state = DynamicUpUpdates();
    if (json is! Map) return state;
    state
      ..baseline = safeToInt(json['baseline']) ?? 0
      .._target = safeToInt(json['target']) ?? 0
      .._offset = json['offset'] is String ? json['offset'] : null
      .._initialSince = safeToInt(json['since']) ?? 0;
    if (state._offset == null) state._target = 0;
    for (final raw in json['latest'] is List ? json['latest'] : const []) {
      if (raw is! Map) continue;
      final entry = DynamicUpEntry.fromJson(raw);
      if (entry.id > 0 && entry.up != null) {
        state._latest[entry.up!.mid] = entry;
      }
    }
    for (final (key, target) in [
      ('read_ids', state._readIds),
      ('read_at', state._readAt),
    ]) {
      final raw = json[key];
      if (raw is! Map) continue;
      for (final entry in raw.entries) {
        final mid = safeToInt(entry.key);
        final value = safeToInt(entry.value);
        if (mid != null && mid > 0 && value != null && value > 0) {
          target[mid] = value;
        }
      }
    }
    final dismissed = json['dismissed'];
    if (dismissed is List) {
      state._dismissed.addAll(dismissed.map(safeToInt).whereType<int>());
    }
    if (json['unfollowed'] case final List unfollowed) {
      state._unfollowed.addAll(unfollowed.map(safeToInt).whereType<int>());
      state._latest.removeWhere((mid, _) => state._unfollowed.contains(mid));
    }
    if (json['visited'] case final List visited) {
      state._visited.addAll(visited.whereType<String>());
    }
    return state;
  }
}
