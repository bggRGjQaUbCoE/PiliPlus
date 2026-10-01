import 'package:PiliPlus/models_new/live/live_superchat/item.dart';

enum SuperChatMerge { inserted, updated, ignored }

/// Server IDs and deletion tombstones are retained for the room lifetime.
/// Expiry belongs to the room clock, rather than to whichever cards happen to
/// be rendered. Reconnect snapshots therefore cannot resurrect deleted SCs.
class SuperChatTimeline {
  SuperChatTimeline(
    this.roomId, {
    this.limit = 500,
    this.identityLimit = 10000,
  });

  final int roomId;
  final int limit;
  final int identityLimit;
  final _items = <int, SuperChatItem>{};
  final _deleted = <int>{};
  final _seen = <int>{};
  bool _saturated = false;
  bool get saturated => _saturated;

  bool _remember(int id) {
    if (_seen.contains(id)) return true;
    if (_seen.length >= identityLimit) {
      // Do not evict deletion tombstones and let an old snapshot resurrect an
      // SC. A pathological room session instead stops accepting SC additions.
      _saturated = true;
      return false;
    }
    _seen.add(id);
    return true;
  }

  SuperChatMerge merge(SuperChatItem item, int nowSeconds) {
    if (_saturated ||
        item.roomid != roomId ||
        item.id <= 0 ||
        _deleted.contains(item.id)) {
      return SuperChatMerge.ignored;
    }
    final existing = _items[item.id];
    if (existing != null && existing.ts >= item.ts) {
      return SuperChatMerge.ignored;
    }
    final inserted = !_seen.contains(item.id);
    if (!_remember(item.id)) return SuperChatMerge.ignored;
    item.expired = item.endTime <= nowSeconds;
    _items[item.id] = item;
    if (_items.length > limit) {
      final oldest = _items.values.reduce(
        (a, b) =>
            a.startSime < b.startSime ||
                (a.startSime == b.startSime && a.id < b.id)
            ? a
            : b,
      );
      _items.remove(oldest.id);
    }
    return inserted ? SuperChatMerge.inserted : SuperChatMerge.updated;
  }

  void delete(Iterable<int> ids) {
    for (final id in ids.where((id) => id > 0)) {
      if (_remember(id)) _deleted.add(id);
      _items.remove(id)?.deleted = true;
    }
  }

  bool expire(int nowSeconds) {
    var changed = false;
    for (final item in _items.values) {
      if (!item.expired && item.endTime <= nowSeconds) {
        item.expired = true;
        changed = true;
      }
    }
    return changed;
  }

  List<SuperChatItem> visible({required bool persistent}) {
    final result =
        _items.values
            .where((item) => !item.deleted && (persistent || !item.expired))
            .toList()
          ..sort((a, b) {
            final time = b.startSime.compareTo(a.startSime);
            return time != 0 ? time : b.id.compareTo(a.id);
          });
    return result;
  }

  void clear() {
    _items.clear();
    _deleted.clear();
    _seen.clear();
    _saturated = false;
  }
}
