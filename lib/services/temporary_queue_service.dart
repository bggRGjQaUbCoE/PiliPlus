import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:flutter/foundation.dart';

/// A local queue item identifies one video part. New additions resolve the cid
/// before persisting so different parts of one video never collapse together.
@immutable
class TemporaryQueueEntry {
  final String bvid;
  final int? cid;
  final int? aid;
  final String title;
  final String? cover;
  final String? failureReason;

  const TemporaryQueueEntry({
    required this.bvid,
    required this.cid,
    required this.title,
    this.aid,
    this.cover,
    this.failureReason,
  });

  Map<String, Object?> toJson() => {
    'bvid': bvid,
    'cid': cid,
    'aid': aid,
    'title': title,
    'cover': cover,
    if (failureReason != null) 'failureReason': failureReason,
  };

  factory TemporaryQueueEntry.fromJson(Map<dynamic, dynamic> json) =>
      TemporaryQueueEntry(
        bvid: json['bvid'] as String,
        cid: json['cid'] as int?,
        aid: json['aid'] as int?,
        title: json['title'] as String? ?? '',
        cover: json['cover'] as String?,
        failureReason: json['failureReason'] as String?,
      );

  bool samePart(TemporaryQueueEntry other) =>
      bvid == other.bvid && cid == other.cid;

  TemporaryQueueEntry withFailure(String? reason) => TemporaryQueueEntry(
    bvid: bvid,
    cid: cid,
    aid: aid,
    title: title,
    cover: cover,
    failureReason: reason,
  );

  TemporaryQueueEntry merge(TemporaryQueueEntry other) => TemporaryQueueEntry(
    bvid: bvid,
    cid: other.cid ?? cid,
    aid: other.aid ?? aid,
    title: other.title.isNotEmpty ? other.title : title,
    cover: other.cover ?? cover,
    failureReason: null,
  );
}

@immutable
class TemporaryQueueAttempt {
  final String token;
  final String accountScope;
  final int playbackMid;
  final String bvid;
  final int cid;

  const TemporaryQueueAttempt({
    required this.token,
    required this.accountScope,
    required this.playbackMid,
    required this.bvid,
    required this.cid,
  });

  bool matches({
    required String token,
    required String accountScope,
    required int playbackMid,
    required String bvid,
    required int cid,
  }) =>
      this.token == token &&
      this.accountScope == accountScope &&
      this.playbackMid == playbackMid &&
      this.bvid == bvid &&
      this.cid == cid;
}

@immutable
class TemporaryQueueFailureTransition {
  final TemporaryQueueEntry failed;
  final TemporaryQueueEntry? next;
  final TemporaryQueueAttempt? nextAttempt;

  const TemporaryQueueFailureTransition({
    required this.failed,
    this.next,
    this.nextAttempt,
  });
}

@immutable
class TemporaryQueueChange {
  final int position;
  final int length;
  final bool moved;
  final bool alreadyPlaying;

  const TemporaryQueueChange({
    required this.position,
    required this.length,
    this.moved = false,
    this.alreadyPlaying = false,
  });
}

/// Pure queue rules. Only explicitly queued items are kept in [items].
/// [current] is an ephemeral cursor owned by the active player.
class TemporaryQueueState {
  final List<TemporaryQueueEntry> items;
  TemporaryQueueEntry? current;
  Object? currentOwner;

  TemporaryQueueState({List<TemporaryQueueEntry>? items, this.current})
    : items = List.of(items ?? const []);

  List<TemporaryQueueEntry> get visibleItems => [
    ?current,
    ...items.where((item) => current?.samePart(item) != true),
  ];

  int indexOf(TemporaryQueueEntry item) =>
      items.indexWhere((entry) => entry.samePart(item));

  TemporaryQueueChange add(
    TemporaryQueueEntry entry, {
    required bool next,
  }) {
    final existing = indexOf(entry);
    if (current?.samePart(entry) == true) {
      return TemporaryQueueChange(
        position: 0,
        length: items.length,
        alreadyPlaying: true,
      );
    }
    final item = existing < 0 ? entry : items.removeAt(existing).merge(entry);
    final insertAt = next && current != null ? 0 : items.length;
    items.insert(insertAt, item);
    return TemporaryQueueChange(
      position: insertAt,
      length: items.length,
      moved: existing >= 0,
    );
  }

  void markCurrent(TemporaryQueueEntry entry, {Object? ownerToken}) {
    final existing = indexOf(entry);
    final item = existing < 0 ? entry : items.removeAt(existing).merge(entry);
    current = item.withFailure(null);
    currentOwner = ownerToken;
  }

  /// A media session can move from a disposed detail route through the mini
  /// player into a new route without emitting another `playing` event.
  bool transferCurrentOwner(
    TemporaryQueueEntry entry, {
    required Object newOwnerToken,
  }) {
    if (current?.samePart(entry) != true) return false;
    currentOwner = newOwnerToken;
    return true;
  }

  TemporaryQueueEntry? get firstPlayable {
    for (final item in items) {
      if (item.failureReason == null && item.cid != null) return item;
    }
    return null;
  }

  TemporaryQueueEntry? advance() {
    if (current == null) return null;
    current = null;
    currentOwner = null;
    return firstPlayable;
  }

  TemporaryQueueEntry markFailed(TemporaryQueueEntry entry, String reason) {
    final playing = current?.samePart(entry) == true ? current : null;
    if (current?.samePart(entry) == true) {
      current = null;
      currentOwner = null;
    }
    final index = indexOf(entry);
    final failed = (index < 0 ? playing ?? entry : items.removeAt(index))
        .withFailure(reason);
    items.insert(0, failed);
    return failed;
  }

  TemporaryQueueEntry? retryFailed(
    TemporaryQueueEntry entry, {
    TemporaryQueueEntry? resolved,
  }) {
    final index = indexOf(entry);
    if (index < 0 || items[index].failureReason == null) return null;
    final old = items.removeAt(index);
    final retry = (resolved ?? old).withFailure(null);
    items.removeWhere((item) => item.samePart(retry));
    items.insert(0, retry);
    return retry;
  }

  bool clearCurrentIfMatches(
    TemporaryQueueEntry entry, {
    Object? ownerToken,
  }) {
    if (current?.samePart(entry) != true ||
        !identical(currentOwner, ownerToken)) {
      return false;
    }
    current = null;
    currentOwner = null;
    return true;
  }

  bool reorder(int oldIndex, int newIndex) {
    if (oldIndex < 0 || oldIndex >= items.length) return false;
    if (newIndex > oldIndex) newIndex--;
    if (newIndex < 0 || newIndex >= items.length) return false;
    if (newIndex == oldIndex || newIndex >= items.length) return false;
    items.insert(newIndex, items.removeAt(oldIndex));
    return true;
  }
}

class TemporaryQueueService extends ChangeNotifier {
  TemporaryQueueService._();
  static final TemporaryQueueService instance = TemporaryQueueService._();

  static const String _storagePrefix = 'temporaryQueueV1:';
  static const String attemptArgument = '_piliTemporaryQueueAttempt';
  String? _loadedAccount;
  TemporaryQueueState _state = TemporaryQueueState();
  TemporaryQueueAttempt? _activeAttempt;
  int _attemptSequence = 0;

  String get _accountKey =>
      Accounts.main.isLogin ? 'uid:${Accounts.main.mid}' : 'guest';
  String get _storageKey => '$_storagePrefix$_accountKey';

  bool get enabled => GStorage.setting.get(
    SettingBoxKey.enableTemporaryQueue,
    defaultValue: true,
  ) as bool;

  Future<void> setEnabled(bool value) async {
    await GStorage.setting.put(SettingBoxKey.enableTemporaryQueue, value);
    notifyListeners();
  }

  void _ensureLoaded() {
    final account = _accountKey;
    if (_loadedAccount == account) return;
    _loadedAccount = account;
    final stored = GStorage.localCache.get(_storageKey);
    final items = <TemporaryQueueEntry>[];
    if (stored is List) {
      for (final raw in stored) {
        if (raw is! Map) continue;
        try {
          var item = TemporaryQueueEntry.fromJson(raw);
          if (item.cid == null && item.failureReason == null) {
            item = item.withFailure('缺少分 P 信息，请手动重试');
          }
          if (item.bvid.isNotEmpty &&
              !items.any((entry) => entry.samePart(item))) {
            items.add(item);
          }
        } catch (_) {
          // Corrupt local entries are ignored, not copied across accounts.
        }
      }
    }
    _state = TemporaryQueueState(items: items);
    _activeAttempt = null;
  }

  /// Re-evaluate the active account when a queue screen returns to foreground.
  /// The old account's in-memory cursor is discarded before notifying the UI.
  void refreshAccount() {
    _ensureLoaded();
    notifyListeners();
  }

  List<TemporaryQueueEntry> get items {
    _ensureLoaded();
    return List.unmodifiable(_state.items);
  }

  List<TemporaryQueueEntry> get visibleItems {
    _ensureLoaded();
    return List.unmodifiable(_state.visibleItems);
  }

  TemporaryQueueEntry? get current {
    _ensureLoaded();
    return _state.current;
  }

  bool get hasPending {
    _ensureLoaded();
    return _state.current != null && _state.firstPlayable != null;
  }

  TemporaryQueueAttempt beginAttempt(TemporaryQueueEntry entry) {
    _ensureLoaded();
    final cid = entry.cid;
    if (cid == null) throw ArgumentError('Queue attempt requires a cid');
    final attempt = TemporaryQueueAttempt(
      token: '${DateTime.now().microsecondsSinceEpoch}:${++_attemptSequence}',
      accountScope: _accountKey,
      playbackMid: Accounts.video.mid,
      bvid: entry.bvid,
      cid: cid,
    );
    _activeAttempt = attempt;
    notifyListeners();
    return attempt;
  }

  TemporaryQueueAttempt? attemptFor(TemporaryQueueEntry entry) {
    _ensureLoaded();
    final attempt = _activeAttempt;
    if (attempt == null ||
        attempt.bvid != entry.bvid ||
        attempt.cid != entry.cid) {
      return null;
    }
    return attempt;
  }

  void cancelAttempt(TemporaryQueueAttempt attempt) {
    _ensureLoaded();
    if (_activeAttempt?.token == attempt.token) {
      _activeAttempt = null;
      notifyListeners();
    }
  }

  TemporaryQueueFailureTransition? reportTerminalFailure({
    required TemporaryQueueAttempt attempt,
    required String bvid,
    required int cid,
    required int playbackMid,
    required String reason,
  }) {
    _ensureLoaded();
    if (_activeAttempt?.matches(
              token: attempt.token,
              accountScope: _accountKey,
              playbackMid: playbackMid,
              bvid: bvid,
              cid: cid,
            ) !=
            true ||
        !attempt.matches(
          token: attempt.token,
          accountScope: _accountKey,
          playbackMid: playbackMid,
          bvid: bvid,
          cid: cid,
        ) ||
        Accounts.video.mid != playbackMid) {
      return null;
    }
    _activeAttempt = null;
    final failed = _state.markFailed(
      TemporaryQueueEntry(bvid: bvid, cid: cid, title: bvid),
      reason,
    );
    _save();
    final next = _state.firstPlayable;
    return TemporaryQueueFailureTransition(
      failed: failed,
      next: next,
      nextAttempt: next == null ? null : beginAttempt(next),
    );
  }

  TemporaryQueueAttempt? retryFailed(
    TemporaryQueueEntry entry, {
    TemporaryQueueEntry? resolved,
  }) {
    _ensureLoaded();
    final retry = _state.retryFailed(entry, resolved: resolved);
    if (retry == null) return null;
    _save();
    return beginAttempt(retry);
  }

  void _save() {
    final key = _storageKey;
    final data = _state.items.map((item) => item.toJson()).toList();
    GStorage.localCache.put(key, data);
    notifyListeners();
  }

  TemporaryQueueChange addNext(TemporaryQueueEntry entry) {
    _ensureLoaded();
    final result = _state.add(entry, next: true);
    _save();
    return result;
  }

  TemporaryQueueChange addLast(TemporaryQueueEntry entry) {
    _ensureLoaded();
    final result = _state.add(entry, next: false);
    _save();
    return result;
  }

  void markCurrent(TemporaryQueueEntry entry, {Object? ownerToken}) {
    if (!enabled) return;
    _ensureLoaded();
    _state.markCurrent(entry, ownerToken: ownerToken);
    if (_activeAttempt case final attempt?
        when attempt.bvid != entry.bvid || attempt.cid != entry.cid) {
      _activeAttempt = null;
    }
    _save();
  }

  bool transferCurrentOwner(
    TemporaryQueueEntry entry, {
    required Object newOwnerToken,
  }) {
    _ensureLoaded();
    final transferred = _state.transferCurrentOwner(
      entry,
      newOwnerToken: newOwnerToken,
    );
    if (transferred) notifyListeners();
    return transferred;
  }

  void clearCurrent() {
    _ensureLoaded();
    _state.current = null;
    _state.currentOwner = null;
    notifyListeners();
  }

  /// A previous route may dispose after a new video has started. Only that
  /// route's own cursor may be cleared, leaving the new session untouched.
  void clearCurrentIfMatches(
    TemporaryQueueEntry entry, {
    Object? ownerToken,
  }) {
    _ensureLoaded();
    if (_state.clearCurrentIfMatches(entry, ownerToken: ownerToken)) {
      notifyListeners();
    }
  }

  /// Call only for natural completion. This peeks without consuming; playback
  /// opening the returned item calls [markCurrent] after it actually starts.
  TemporaryQueueEntry? nextAfterCompletion() {
    if (!enabled) return null;
    _ensureLoaded();
    final next = _state.advance();
    _activeAttempt = null;
    if (next != null) beginAttempt(next);
    notifyListeners();
    return next;
  }

  bool reorder(int oldIndex, int newIndex) {
    _ensureLoaded();
    final changed = _state.reorder(oldIndex, newIndex);
    if (changed) _save();
    return changed;
  }

  bool remove(TemporaryQueueEntry entry) {
    _ensureLoaded();
    final index = _state.indexOf(entry);
    if (index < 0) return false;
    _state.items.removeAt(index);
    _save();
    return true;
  }

  void clearPending() {
    _ensureLoaded();
    _state.items.clear();
    _save();
  }
}
