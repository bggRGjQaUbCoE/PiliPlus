import 'dart:convert';

import 'package:PiliPlus/utils/storage.dart';

import 'channel_quiet_rule.dart';

abstract interface class ChannelQuietBox {
  Object? get(String key, {Object? defaultValue});
  Future<void> put(String key, Object? value);
  Future<void> delete(String key);
}

class HiveChannelQuietBox implements ChannelQuietBox {
  HiveChannelQuietBox(this._box);

  final dynamic _box;

  @override
  Object? get(String key, {Object? defaultValue}) =>
      _box.get(key, defaultValue: defaultValue);

  @override
  Future<void> put(String key, Object? value) async {
    await _box.put(key, value);
  }

  @override
  Future<void> delete(String key) async {
    await _box.delete(key);
  }
}

class ChannelQuietStore {
  ChannelQuietStore({ChannelQuietBox? box})
      : _box = box ?? HiveChannelQuietBox(GStorage.setting) {
    if (box != null) {
      _cachedRules = null;
    }
  }

  static const namespace = 'piliavalon.channel_quiet.v1';
  static const rulesKey = '$namespace.rules';

  final ChannelQuietBox _box;
  List<ChannelQuietRule>? _cachedRules;

  /// Async load from storage. Returns empty list when no data or corrupt.
  Future<List<ChannelQuietRule>> load() async {
    try {
      final raw = _box.get(rulesKey);
      if (raw == null) {
        _cachedRules = [];
        return [];
      }
      if (raw is! String) {
        _cachedRules = [];
        return [];
      }
      final list = jsonDecode(raw) as List<dynamic>;
      final rules = <ChannelQuietRule>[];
      for (final item in list) {
        try {
          rules.add(ChannelQuietRule.fromJson(item as Map<String, dynamic>));
        } catch (_) {
          // skip damaged entries
        }
      }
      _cachedRules = List.unmodifiable(rules);
      return _cachedRules!;
    } catch (_) {
      _cachedRules = [];
      return [];
    }
  }

  /// Synchronous read from in-memory cache or storage directly.
  List<ChannelQuietRule> snapshot() {
    if (_cachedRules != null) return _cachedRules!;
    try {
      final raw = _box.get(rulesKey);
      if (raw == null || raw is! String) {
        _cachedRules = [];
        return [];
      }
      final list = jsonDecode(raw) as List<dynamic>;
      final rules = <ChannelQuietRule>[];
      for (final item in list) {
        try {
          rules.add(ChannelQuietRule.fromJson(item as Map<String, dynamic>));
        } catch (_) {
          // skip damaged entries
        }
      }
      _cachedRules = List.unmodifiable(rules);
      return _cachedRules!;
    } catch (_) {
      _cachedRules = [];
      return [];
    }
  }

  /// Atomically persist a rule list and refresh the cache.
  Future<void> _saveAll(List<ChannelQuietRule> rules) async {
    final payload = jsonEncode(rules.map((r) => r.toJson()).toList());
    await _box.put(rulesKey, payload);
    _cachedRules = List.unmodifiable(rules);
  }

  /// Add a rule (replace existing with same key). Returns the new rule.
  Future<ChannelQuietRule> add({
    required String key,
    required String channelUid,
    required String channelName,
    bool hideComments = false,
    bool hideDanmaku = false,
  }) async {
    final rules = await load();
    final now = DateTime.now();
    final rule = ChannelQuietRule(
      key: key,
      channelUid: channelUid,
      channelName: channelName,
      hideComments: hideComments,
      hideDanmaku: hideDanmaku,
      createdAt: now,
      updatedAt: now,
    );
    // Replace if key already exists (upsert).
    final filtered = rules.where((r) => r.key != key).toList();
    filtered.add(rule);
    await _saveAll(filtered);
    return rule;
  }

  /// Update fields for an existing rule. Returns null when key unknown.
  Future<ChannelQuietRule?> update({
    required String key,
    String? channelName,
    bool? hideComments,
    bool? hideDanmaku,
  }) async {
    final rules = await load();
    final index = rules.indexWhere((r) => r.key == key);
    if (index == -1) return null;
    final existing = rules[index];
    final updated = existing.copyWith(
      channelName: channelName ?? existing.channelName,
      hideComments: hideComments ?? existing.hideComments,
      hideDanmaku: hideDanmaku ?? existing.hideDanmaku,
      updatedAt: DateTime.now(),
    );
    final newRules = rules.toList();
    newRules[index] = updated;
    await _saveAll(newRules);
    return updated;
  }

  /// Delete the rule with [key]. Returns true when a rule was removed.
  Future<bool> delete(String key) async {
    final rules = await load();
    final removed = rules.where((r) => r.key != key).toList();
    if (removed.length == rules.length) return false;
    await _saveAll(removed);
    return true;
  }

  /// Look up a rule by key. Returns null when not found.
  ChannelQuietRule? lookup(String key) {
    final rules = snapshot();
    try {
      return rules.firstWhere((r) => r.key == key);
    } catch (_) {
      return null;
    }
  }

  /// Return every stored rule.
  List<ChannelQuietRule> listAll() => snapshot();

  /// Remove all channel quiet data from storage.
  Future<void> clear() async {
    await _box.delete(rulesKey);
    _cachedRules = null;
  }
}
