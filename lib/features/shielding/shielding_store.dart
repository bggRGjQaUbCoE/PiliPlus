import 'dart:convert';

import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/features/shielding/shielding_models.dart';

abstract interface class ShieldSettingsBox {
  Object? get(String key, {Object? defaultValue});
  Future<void> put(String key, Object? value);
  Future<void> delete(String key);
}

class HiveShieldSettingsBox implements ShieldSettingsBox {
  HiveShieldSettingsBox(this._box);

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

class ShieldSettingsStore {
  ShieldSettingsStore({ShieldSettingsBox? box})
    : _box = box ?? HiveShieldSettingsBox(GStorage.setting) {
    if (box != null) {
      _cachedSnapshot = null;
    }
  }

  static const namespace = 'piliavalon.shielding.v1';
  static const rulesKey = '$namespace.rules';
  static const globalEnabledKey = '$namespace.global_enabled';
  static const recommendationEnabledKey = '$namespace.recommendation_enabled';
  static const commentEnabledKey = '$namespace.comment_enabled';
  static const versionKey = '$namespace.version';
  static const lastLoadedAtKey = '$namespace.last_loaded_at';
  static const legacyTextImportedKey = '$namespace.legacy_text_imported';

  final ShieldSettingsBox _box;

  static ShieldRuleSet? _cachedSnapshot;

  Future<ShieldRuleSet> load() async {
    try {
      final raw = _box.get(rulesKey);
      if (raw != null && raw is! String) {
        throw FormatException(
          'Invalid shielding payload type: ${raw.runtimeType}',
        );
      }
      final json = raw is String
          ? jsonDecode(raw) as Map<String, dynamic>
          : <String, dynamic>{};
      final ruleSet = ShieldRuleSet.tryFromJson(json.cast<String, Object?>());
      final loadedAt = DateTime.now();
      await _box.put(lastLoadedAtKey, loadedAt.millisecondsSinceEpoch);
      final loadedEpoch = _box.get(lastLoadedAtKey) as int?;
      final resolved = _withLegacyRules(
        ruleSet.copyWith(
          globalEnabled:
              _box.get(globalEnabledKey) as bool? ?? ruleSet.globalEnabled,
          recommendationEnabled:
              _box.get(recommendationEnabledKey) as bool? ??
              ruleSet.recommendationEnabled,
          commentEnabled:
              _box.get(commentEnabledKey) as bool? ?? ruleSet.commentEnabled,
          version: _box.get(versionKey) as int? ?? ruleSet.version,
          lastLoadedAt: loadedEpoch == null
              ? loadedAt
              : DateTime.fromMillisecondsSinceEpoch(loadedEpoch),
        ),
      );
      _cachedSnapshot = resolved;
      return resolved;
    } catch (e) {
      return ShieldRuleSet.disabledWithError(e);
    }
  }

  ShieldRuleSet snapshot() {
    final cached = _cachedSnapshot;
    if (cached != null) return cached;
    final raw = _box.get(rulesKey);
    if (raw == null) {
      return _withLegacyRules(
        ShieldRuleSet(
          globalEnabled: _box.get(globalEnabledKey) as bool? ?? true,
          recommendationEnabled:
              _box.get(recommendationEnabledKey) as bool? ?? true,
          commentEnabled: _box.get(commentEnabledKey) as bool? ?? true,
          version: _box.get(versionKey) as int? ?? 1,
        ),
      );
    }
    if (raw is! String || raw.isEmpty) {
      return ShieldRuleSet(globalEnabled: false, rules: const []);
    }
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final ruleSet = ShieldRuleSet.tryFromJson(json.cast<String, Object?>());
      final loadedEpoch = _box.get(lastLoadedAtKey) as int?;
      final resolved = _withLegacyRules(
        ruleSet.copyWith(
          globalEnabled:
              _box.get(globalEnabledKey) as bool? ?? ruleSet.globalEnabled,
          recommendationEnabled:
              _box.get(recommendationEnabledKey) as bool? ??
              ruleSet.recommendationEnabled,
          commentEnabled:
              _box.get(commentEnabledKey) as bool? ?? ruleSet.commentEnabled,
          version: _box.get(versionKey) as int? ?? ruleSet.version,
          lastLoadedAt: loadedEpoch == null
              ? ruleSet.lastLoadedAt
              : DateTime.fromMillisecondsSinceEpoch(loadedEpoch),
        ),
      );
      _cachedSnapshot = resolved;
      return resolved;
    } catch (_) {
      return ShieldRuleSet(globalEnabled: false, rules: const []);
    }
  }

  Future<void> save(ShieldRuleSet ruleSet) async {
    final resolved = _withLegacyRules(ruleSet);
    final errors = _validate(resolved);
    if (errors.isNotEmpty) {
      throw ShieldStoreException(errors.join('\n'));
    }
    try {
      final payload = jsonEncode(resolved.toJson());
      await _box.put(rulesKey, payload);
      await _box.put(globalEnabledKey, resolved.globalEnabled);
      await _box.put(
        recommendationEnabledKey,
        resolved.recommendationEnabled,
      );
      await _box.put(commentEnabledKey, resolved.commentEnabled);
      await _box.put(versionKey, resolved.version);
      await _box.put(legacyTextImportedKey, true);
      _cachedSnapshot = resolved;
    } catch (e) {
      throw ShieldStoreException('Failed to save shielding settings: $e');
    }
  }

  Future<ShieldRule?> addQuickActionRule({
    required ShieldRuleType type,
    required ShieldScope scope,
    required String pattern,
    ShieldMatchMode matchMode = ShieldMatchMode.exact,
  }) async {
    final trimmed = pattern.trim();
    if (trimmed.isEmpty) {
      throw const ShieldStoreException('Rule pattern is empty');
    }

    final current = await load();
    final normalized = trimmed.toLowerCase();
    final exists = current.rules.any(
      (rule) =>
          rule.type == type &&
          rule.scope == scope &&
          rule.matchMode == matchMode &&
          rule.pattern.trim().toLowerCase() == normalized,
    );
    if (exists) return null;

    final rule = ShieldRule(
      id: 'quickAction-${DateTime.now().microsecondsSinceEpoch}',
      type: type,
      matchMode: matchMode,
      scope: scope,
      action: ShieldAction.block,
      pattern: trimmed,
      enabled: true,
      updatedAt: DateTime.now(),
      source: ShieldRuleSource.quickAction,
    );
    await save(current.copyWith(rules: [...current.rules, rule]));
    return rule;
  }

  Future<void> setGlobalEnabled(bool enabled) async {
    await _box.put(globalEnabledKey, enabled);
    _cachedSnapshot = snapshot().copyWith(globalEnabled: enabled);
  }

  Future<void> setRecommendationEnabled(bool enabled) async {
    await _box.put(recommendationEnabledKey, enabled);
    _cachedSnapshot = snapshot().copyWith(recommendationEnabled: enabled);
  }

  Future<void> setCommentEnabled(bool enabled) async {
    await _box.put(commentEnabledKey, enabled);
    _cachedSnapshot = snapshot().copyWith(commentEnabled: enabled);
  }

  Future<void> clear() async {
    await _box.delete(rulesKey);
    await _box.delete(globalEnabledKey);
    await _box.delete(recommendationEnabledKey);
    await _box.delete(commentEnabledKey);
    await _box.delete(versionKey);
    await _box.delete(lastLoadedAtKey);
    await _box.delete(legacyTextImportedKey);
    _cachedSnapshot = null;
  }

  List<String> _validate(ShieldRuleSet ruleSet) {
    final errors = <String>[];
    for (final rule in ruleSet.rules) {
      if (rule.pattern.trim().isEmpty) {
        errors.add('Rule ${rule.id} has empty pattern');
      }
      if (rule.matchMode == ShieldMatchMode.regex) {
        try {
          RegExp(rule.pattern);
        } catch (_) {
          errors.add('Rule ${rule.id} has invalid regex');
        }
      }
    }
    return errors;
  }

  ShieldRuleSet _withLegacyRules(ShieldRuleSet ruleSet) {
    if (_box.get(legacyTextImportedKey) == true) {
      return ruleSet;
    }
    final legacyRules = _legacyRules();
    if (legacyRules.isEmpty) return ruleSet;

    final merged = [...ruleSet.rules];
    for (final legacyRule in legacyRules) {
      final exists = merged.any(
        (rule) =>
            rule.type == legacyRule.type &&
            rule.scope == legacyRule.scope &&
            rule.matchMode == legacyRule.matchMode &&
            rule.pattern.trim().toLowerCase() ==
                legacyRule.pattern.trim().toLowerCase(),
      );
      if (!exists) {
        merged.add(legacyRule);
      }
    }
    return ruleSet.copyWith(rules: merged);
  }

  List<ShieldRule> _legacyRules() {
    final now = DateTime.fromMillisecondsSinceEpoch(0);
    return [
      ..._legacyTextRules(
        key: SettingBoxKey.banWordForRecommend,
        type: ShieldRuleType.keyword,
        scope: ShieldScope.recommendation,
        updatedAt: now,
      ),
      ..._legacyTextRules(
        key: SettingBoxKey.banWordForZone,
        type: ShieldRuleType.category,
        scope: ShieldScope.recommendation,
        updatedAt: now,
      ),
      ..._legacyTextRules(
        key: SettingBoxKey.banWordForReply,
        type: ShieldRuleType.keyword,
        scope: ShieldScope.comment,
        updatedAt: now,
      ),
    ];
  }

  List<ShieldRule> _legacyTextRules({
    required String key,
    required ShieldRuleType type,
    required ShieldScope scope,
    required DateTime updatedAt,
  }) {
    final pattern = (_box.get(key, defaultValue: '') as String?)?.trim() ?? '';
    if (pattern.isEmpty) return const [];

    final simpleParts = _simplePipeParts(pattern);
    if (simpleParts != null) {
      return [
        for (final part in simpleParts)
          _legacyRule(
            key: key,
            type: type,
            scope: scope,
            matchMode: ShieldMatchMode.exact,
            pattern: part,
            updatedAt: updatedAt,
          ),
      ];
    }

    return [
      _legacyRule(
        key: key,
        type: type,
        scope: scope,
        matchMode: ShieldMatchMode.regex,
        pattern: pattern,
        updatedAt: updatedAt,
      ),
    ];
  }

  List<String>? _simplePipeParts(String pattern) {
    final parts = pattern.split('|').map((part) => part.trim()).toList();
    if (parts.any((part) => part.isEmpty)) return null;
    final literal = RegExp(r'^[\w\u4e00-\u9fff]+$');
    if (parts.every(literal.hasMatch)) return parts;
    return null;
  }

  ShieldRule _legacyRule({
    required String key,
    required ShieldRuleType type,
    required ShieldScope scope,
    required ShieldMatchMode matchMode,
    required String pattern,
    required DateTime updatedAt,
  }) {
    final idPattern = pattern.toLowerCase();
    return ShieldRule(
      id: 'legacy-$key-${scope.name}-${type.name}-${matchMode.name}-$idPattern',
      type: type,
      matchMode: matchMode,
      scope: scope,
      action: ShieldAction.block,
      pattern: pattern,
      enabled: true,
      updatedAt: updatedAt,
      source: ShieldRuleSource.imported,
    );
  }
}

class ShieldStoreException implements Exception {
  const ShieldStoreException(this.message);

  final String message;

  @override
  String toString() => message;
}
