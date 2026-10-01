import 'package:PiliPlus/models/dynamics/up.dart';
import 'package:PiliPlus/utils/parse_int.dart';

/// 按内容维护未读、已读证据和扫描进度；所有状态均由控制器按主账号独立保存。
///
/// 同一作者的视频与图文可以同时未读。阅读最新内容推进该作者的已读水位，
/// 视频只推进视频水位，动态推进全部动态水位；打开作者列表清除当前全部更新。
/// 已读证据先记录再删除内容，使尚未返回的扫描响应也不能重新点亮已读内容。
class DynamicUnreadState {
  /// 只有完成整个增量区间才推进此基线，未完成部分由 progress 续扫。
  int baselineId = 0;
  DynamicUpScanProgress? progress;

  /// 观看历史同样有界翻页；较老记录在后台续查，完成范围用于避免重复扫全历史。
  int? historyMax;
  int? historyViewAt;
  int historyNewestAt = 0;
  int historyFloorAt = 0;

  /// 动态 id 全局唯一，直接作为内容去重和精确已读的键。
  final Map<int, DynamicUpdateEntry> _contents = {};

  /// 官方提供的作者级红点没有内容身份，只能用于所有动态模式的补充提醒。
  final Map<int, UpItem> _officialUnread = {};
  final Set<int> _dismissedOfficial = {};

  /// 保存已读水位与内容身份，阻止续扫、失败重试和延迟响应重新插入旧内容。
  final Set<int> _readIds = {};
  final Map<int, int> _readUpAt = {};
  final Map<int, int> _readVideoUpAt = {};
  final Map<int, int> _readVideoAt = {};
  final Map<String, int> _readBvidAt = {};

  /// 当前已知未读视频的最早发布时间，用于限制观看历史翻页。
  int? get oldestVideoAt {
    final times = _contents.values
        .where((entry) => entry.up?.isVideo == true)
        .map((entry) => entry.up?.latestUpdateAt ?? 0)
        .where((time) => time > 0);
    return times.isEmpty ? null : times.reduce((a, b) => a < b ? a : b);
  }

  /// 判断内容是否已有精确或作者级已读证据，未知类型不使用视频历史推断。
  bool _wasRead(DynamicUpdateEntry entry) {
    if (_readIds.contains(entry.dynamicId)) return true;
    final up = entry.up!;
    final publishedAt = up.latestUpdateAt ?? 0;
    final readUpAt = _readUpAt[up.mid];
    if (publishedAt > 0 && readUpAt != null && publishedAt <= readUpAt) {
      return true;
    }
    if (up.isVideo != true) return false;
    if (publishedAt > 0 && publishedAt <= (_readVideoUpAt[up.mid] ?? 0)) {
      return true;
    }
    final aidTime = _readVideoAt[entry.videoAid] ?? 0;
    final bvidTime = _readBvidAt[entry.videoBvid] ?? 0;
    // 缺少时间的内容只能由精确 id 清除，不能把未知时间当作很早发布。
    return publishedAt > 0 &&
        (aidTime >= publishedAt || bvidTime >= publishedAt);
  }

  /// 合并一个扫描批次，返回本批实际插入的作者用于保护尚未同步的官方状态。
  Set<int> mergeBatch(DynamicUpUpdateResult result) {
    final freshMids = <int>{};
    for (final entry in result.entries) {
      if (entry.dynamicId <= 0 || entry.up == null) continue;
      // 历史可能先于动态返回；精确匹配到已看视频后仍需推进作者的视频水位。
      if (entry.up!.isVideo == true &&
          (entry.up!.latestUpdateAt ?? 0) > 0 &&
          ((_readVideoAt[entry.videoAid] ?? 0) >= entry.up!.latestUpdateAt! ||
              (_readBvidAt[entry.videoBvid] ?? 0) >=
                  entry.up!.latestUpdateAt!)) {
        _advanceVideoWatermark(entry.up!.mid, entry.up!.latestUpdateAt!);
      }
      if (_wasRead(entry)) continue;
      if (!_contents.containsKey(entry.dynamicId)) freshMids.add(entry.up!.mid);
      _contents[entry.dynamicId] = entry;
    }
    // 同批次较早条目可能先插入，读到较新视频后一起清除这些较早视频。
    _contents.removeWhere((_, entry) => _wasRead(entry));
    progress = result.progress;
    final next = safeToInt(result.updateBaseline);
    if (result.isComplete && next != null && next > baselineId) {
      baselineId = next;
      // 完整基线之前的记录不会再扫描，可以释放对应的内容级已读证据。
      _readIds.removeWhere((id) => id <= baselineId);
    }
    return freshMids;
  }

  /// 合并具有明确字段的官方作者状态，未知状态不清除任何本地红点。
  void applyOfficial(Iterable<UpItem> ups, {Set<int> freshMids = const {}}) {
    for (final up in ups) {
      if (up.mid <= 0) continue;
      if (up.hasUpdate == true) {
        if (!_dismissedOfficial.contains(up.mid)) _officialUnread[up.mid] = up;
      } else if (up.hasUpdate == false && !freshMids.contains(up.mid)) {
        _officialUnread.remove(up.mid);
        _dismissedOfficial.remove(up.mid);
        // 服务端明确已读时，同步记录内容级证据以防续扫再次插入相同内容。
        _contents.removeWhere((id, entry) {
          if (entry.up?.mid != up.mid) return false;
          _readIds.add(id);
          return true;
        });
      }
    }
  }

  /// 打开作者列表视为已读该作者当前全部内容，并记录时间水位保护在途扫描。
  void markUpRead(int mid, int readAt) {
    if (mid <= 0) return;
    final old = _readUpAt[mid] ?? 0;
    if (readAt > old) _readUpAt[mid] = readAt;
    _contents.removeWhere((id, entry) {
      if (entry.up?.mid != mid) return false;
      _readIds.add(id);
      return true;
    });
    _officialUnread.remove(mid);
    _dismissedOfficial.add(mid);
  }

  /// 阅读动态后推进其作者的动态水位，保留发布时间更晚的更新。
  void markDynamicRead(int dynamicId, int? mid, {int? publishedAt}) {
    if (dynamicId <= 0) return;
    _readIds.add(dynamicId);
    final removed = _contents.remove(dynamicId);
    final authorMid = removed?.up?.mid ?? mid;
    final cutoff = removed?.up?.latestUpdateAt ?? publishedAt ?? 0;
    if (authorMid != null && authorMid > 0 && cutoff > 0) {
      final old = _readUpAt[authorMid] ?? 0;
      if (cutoff > old) _readUpAt[authorMid] = cutoff;
      _contents.removeWhere((id, entry) {
        if (!_wasRead(entry)) return false;
        _readIds.add(id);
        return true;
      });
    }
    // 未知旧动态不能作为“作者所有内容已读”的证据，只有可靠发布时间才推进水位。
    if (removed != null || cutoff > 0) _dismissIfEmpty(authorMid);
  }

  /// 精确找到看过的视频后推进作者的视频水位，清较早视频并保留更晚视频和图文。
  void markVideoRead({
    int? aid,
    String? bvid,
    required int viewedAt,
    int? mid,
    int? publishedAt,
  }) {
    if (viewedAt <= 0) return;
    if (aid != null && aid > 0 && viewedAt > (_readVideoAt[aid] ?? 0)) {
      _readVideoAt[aid] = viewedAt;
    }
    if (bvid != null &&
        bvid.isNotEmpty &&
        viewedAt > (_readBvidAt[bvid] ?? 0)) {
      _readBvidAt[bvid] = viewedAt;
    }
    if (mid != null &&
        mid > 0 &&
        publishedAt != null &&
        publishedAt > 0 &&
        publishedAt <= viewedAt) {
      _advanceVideoWatermark(mid, publishedAt);
    }
    for (final entry in _contents.values) {
      final up = entry.up!;
      final published = up.latestUpdateAt ?? 0;
      final matches =
          aid != null && aid > 0 && entry.videoAid == aid ||
          bvid != null && bvid.isNotEmpty && entry.videoBvid == bvid;
      if (up.isVideo == true &&
          matches &&
          published > 0 &&
          published <= viewedAt) {
        _advanceVideoWatermark(up.mid, published);
      }
    }
    final affectedMids = <int>{};
    _contents.removeWhere((id, entry) {
      if (!_wasRead(entry)) return false;
      _readIds.add(id);
      affectedMids.add(entry.up!.mid);
      return true;
    });
    for (final mid in affectedMids) {
      _dismissIfEmpty(mid);
    }
  }

  /// 视频水位只按作者和发布时间推进，不允许读旧视频后回退水位。
  void _advanceVideoWatermark(int mid, int publishedAt) {
    if (publishedAt > (_readVideoUpAt[mid] ?? 0)) {
      _readVideoUpAt[mid] = publishedAt;
    }
  }

  /// 作者已知内容全读完后屏蔽旧的官方快照，直到服务端明确清零再接受下一次提醒。
  void _dismissIfEmpty(int? mid) {
    if (mid == null ||
        mid <= 0 ||
        _contents.values.any((entry) => entry.up?.mid == mid)) {
      return;
    }
    _officialUnread.remove(mid);
    _dismissedOfficial.add(mid);
  }

  /// 按模式生成独立列表摘要，不向 UI 暴露缓存里的可变对象。
  Map<int, UpItem> summaries({required bool onlyVideo}) {
    final result = <int, UpItem>{};
    if (!onlyVideo) {
      for (final up in _officialUnread.values) {
        result[up.mid] = UpItem(
          mid: up.mid,
          face: up.face,
          uname: up.uname,
          hasUpdate: true,
          latestUpdateAt: up.latestUpdateAt,
        );
      }
    }
    for (final entry in _contents.values) {
      final up = entry.up!;
      if (onlyVideo && up.isVideo != true) continue;
      final old = result[up.mid];
      final latest =
          old == null || (up.latestUpdateAt ?? 0) > (old.latestUpdateAt ?? 0)
          ? up
          : old;
      result[up.mid] = UpItem(
        mid: up.mid,
        face: latest.face,
        uname: latest.uname,
        hasUpdate: true,
        latestUpdateAt: latest.latestUpdateAt,
        isVideo: old?.isVideo == true || up.isVideo == true,
      );
    }
    return result;
  }

  /// 把账号的进度、未读和已读证据作为一个快照写入，避免分开写基线丢失状态。
  Map<String, dynamic> toJson() => {
    'baseline': baselineId,
    'progress': progress?.toJson(),
    'history_max': historyMax,
    'history_view_at': historyViewAt,
    'history_newest': historyNewestAt,
    'history_floor': historyFloorAt,
    'contents': _contents.values
        .map(
          (entry) => {
            'id': entry.dynamicId,
            'up': _upJson(entry.up!),
            'aid': entry.videoAid,
            'bvid': entry.videoBvid,
          },
        )
        .toList(),
    'official': _officialUnread.values.map(_upJson).toList(),
    'dismissed': _dismissedOfficial.toList(),
    'read_ids': _readIds.toList(),
    'read_up': _readUpAt.map((mid, time) => MapEntry('$mid', time)),
    'read_video_up': _readVideoUpAt.map((mid, time) => MapEntry('$mid', time)),
    'read_video': _readVideoAt.map((aid, time) => MapEntry('$aid', time)),
    'read_bvid': Map<String, int>.of(_readBvidAt),
  };

  /// 序列化作者身份与内容类型，供未读条目和官方未知类型摘要共同使用。
  static Map<String, dynamic> _upJson(UpItem up) => {
    'mid': up.mid,
    'face': up.face,
    'uname': up.uname,
    'has_update': true,
    'latest_update_at': up.latestUpdateAt,
    'is_video': up.isVideo,
  };

  /// 逐条恢复缓存；损坏条目跳过，不能阻断整个账号的动态页。
  static DynamicUnreadState fromJson(dynamic value) {
    final state = DynamicUnreadState();
    if (value is! Map) return state;
    state
      ..baselineId = safeToInt(value['baseline']) ?? 0
      ..progress = DynamicUpScanProgress.fromJson(value['progress'])
      ..historyMax = safeToInt(value['history_max'])
      ..historyViewAt = safeToInt(value['history_view_at'])
      ..historyNewestAt = safeToInt(value['history_newest']) ?? 0
      ..historyFloorAt = safeToInt(value['history_floor']) ?? 0;
    if (state.progress?.baselineId != state.baselineId) state.progress = null;
    for (final raw
        in value['contents'] is List ? value['contents'] : const []) {
      try {
        if (raw is! Map || raw['up'] is! Map) continue;
        final id = safeToInt(raw['id']) ?? 0;
        final up = UpItem.fromJson(Map<String, dynamic>.from(raw['up']));
        if (id <= 0 || up.mid <= 0) continue;
        state._contents[id] = DynamicUpdateEntry(
          dynamicId: id,
          up: up,
          videoAid: safeToInt(raw['aid']),
          videoBvid: raw['bvid'] is String ? raw['bvid'] : null,
        );
      } catch (_) {
        // 只丢弃损坏内容，其他缓存及已读证据继续生效。
      }
    }
    for (final raw
        in value['official'] is List ? value['official'] : const []) {
      try {
        if (raw is! Map) continue;
        final up = UpItem.fromJson(Map<String, dynamic>.from(raw));
        if (up.mid > 0) state._officialUnread[up.mid] = up;
      } catch (_) {
        // 官方摘要损坏时跳过，等待下一次官方请求补齐。
      }
    }
    for (final (key, target) in [
      ('dismissed', state._dismissedOfficial),
      ('read_ids', state._readIds),
    ]) {
      final raw = value[key];
      if (raw is! List) continue;
      target.addAll(raw.map(safeToInt).whereType<int>().where((id) => id > 0));
    }
    for (final (key, target) in [
      ('read_up', state._readUpAt),
      ('read_video_up', state._readVideoUpAt),
      ('read_video', state._readVideoAt),
    ]) {
      final raw = value[key];
      if (raw is! Map) continue;
      for (final item in raw.entries) {
        final id = safeToInt(item.key);
        final time = safeToInt(item.value);
        if (id != null && id > 0 && time != null && time > 0) target[id] = time;
      }
    }
    final rawBvid = value['read_bvid'];
    if (rawBvid is Map) {
      for (final item in rawBvid.entries) {
        final time = safeToInt(item.value);
        if (item.key is String && time != null && time > 0) {
          state._readBvidAt[item.key] = time;
        }
      }
    }
    return state;
  }
}
