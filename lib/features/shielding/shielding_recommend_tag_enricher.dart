import 'dart:async';

import 'package:PiliPlus/features/shielding/shielding_matcher.dart';
import 'package:PiliPlus/features/shielding/shielding_models.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/models_new/video/video_tag/data.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';

// -- internal constants (not user-facing) ---------------------------
const bool _tagEnrichmentEnabled = true;
const int _defaultConcurrency = 5;
const int _defaultTimeoutSeconds = 3;
const Duration _tagCacheTTL = Duration(minutes: 30);
const int _tagCacheMaxEntries = 200;

/// Reads the configured concurrency cap from settings, clamping to [1, 10].
int get tagEnrichConcurrency {
  final raw = GStorage.setting.get(
    SettingBoxKey.tagEnrichConcurrency,
    defaultValue: _defaultConcurrency,
  );
  if (raw is! int) return _defaultConcurrency;
  return raw.clamp(1, 10);
}

/// Reads the configured per-request timeout from settings, clamping to [1, 10]
/// seconds.
Duration get tagEnrichTimeout {
  final raw = GStorage.setting.get(
    SettingBoxKey.tagEnrichTimeout,
    defaultValue: _defaultTimeoutSeconds,
  );
  if (raw is! int) return const Duration(seconds: _defaultTimeoutSeconds);
  return Duration(seconds: raw.clamp(1, 10));
}

// -- cache entry -----------------------------------------------------

class _TagCacheEntry {
  const _TagCacheEntry({required this.tagNames, required this.fetchedAt});
  final List<String> tagNames;
  final DateTime fetchedAt;
}

/// Drives detail-tag enrichment + tag-only second-pass shielding for
/// recommendation survivors.
///
/// The default [fetchTags] uses [UserHttp.videoTags].  Tests inject a
/// stub so they never hit the network.
class RecommendationTagEnricher {
  RecommendationTagEnricher({
    Future<LoadingState<List<VideoTagItem>?>> Function(
      String bvid,
      Object? cid,
    )?
    fetchTags,
  }) : _fetchTags =
           fetchTags ??
           ((String bvid, Object? cid) =>
               UserHttp.videoTags(bvid: bvid, cid: cid));

  final Future<LoadingState<List<VideoTagItem>?>> Function(
    String bvid,
    Object? cid,
  )
  _fetchTags;

  static final Map<String, _TagCacheEntry> _cache = {};

  /// Clears the shared static cache. Intended for tests; production
  /// code should not need to call this.
  static void resetCache() => _cache.clear();

  /// Returns the current number of cached entries. Intended for tests.
  static int get cacheEntryCount => _cache.length;

  // ---- public API --------------------------------------------------

  /// Returns the subset of [survivors] that pass the tag-only second
  /// shielding pass after their detail tags are enriched.
  ///
  /// [getBvid] / [getCid] extract the identifiers from a survivor item.
  /// Items whose bvid is `null` or whose tag fetch fails are kept
  /// (fail-open).
  Future<List<T>> enrichAndFilter<T>(
    List<T> survivors,
    ShieldRuleSet shieldRuleSet, {
    required String? Function(T item) getBvid,
    required Object? Function(T item) getCid,
  }) async {
    if (!_tagEnrichmentEnabled || survivors.isEmpty) return survivors;

    _evictExpiredCache();
    _evictOverflow();

    // We use a dense result array indexed by the survivor position so
    // that ordering is preserved.
    final results = List<T?>.filled(survivors.length, null);
    final pendingIndices = <int>[];

    for (int i = 0; i < survivors.length; i++) {
      final item = survivors[i];
      final bvid = getBvid(item);
      if (bvid == null) {
        // No bvid → cannot fetch → fail-open (keep the item).
        results[i] = item;
        continue;
      }

      final cached = _cache[bvid];
      if (cached != null) {
        if (_tagOnlySecondPass(cached.tagNames, shieldRuleSet)) {
          results[i] = item;
        }
        // else: blocked by detail tags → drop
      } else {
        pendingIndices.add(i);
      }
    }

    if (pendingIndices.isNotEmpty) {
      await _fetchWithConcurrency(
        survivors,
        pendingIndices,
        results,
        shieldRuleSet,
        getBvid,
        getCid,
      );
      _evictOverflow();
    }

    return results.whereType<T>().toList();
  }

  // ---- internals ---------------------------------------------------

  bool _tagOnlySecondPass(
    List<String> tagNames,
    ShieldRuleSet shieldRuleSet,
  ) {
    final candidate = ShieldCandidate(
      scope: ShieldScope.recommendation,
      tags: tagNames,
    );
    return ShieldMatcher.match(candidate, shieldRuleSet).visible;
  }

  Future<void> _fetchWithConcurrency<T>(
    List<T> survivors,
    List<int> pendingIndices,
    List<T?> results,
    ShieldRuleSet shieldRuleSet,
    String? Function(T item) getBvid,
    Object? Function(T item) getCid,
  ) async {
    // Protect against mutation during concurrent work.
    final queue = pendingIndices.toList();

    Future<void> worker() async {
      while (queue.isNotEmpty) {
        final index = queue.removeLast();
        final item = survivors[index];
        final bvid = getBvid(item)!; // safe: null-bvid items never reach here
        final cid = getCid(item);

        List<String>? tagNames;
        try {
          final res = await _fetchTags(bvid, cid).timeout(tagEnrichTimeout);
          final tags = res.dataOrNull;
          if (tags != null && tags.isNotEmpty) {
            tagNames = tags
                .map((t) => t.tagName)
                .whereType<String>()
                .where((n) => n.trim().isNotEmpty)
                .toList();
            if (tagNames.isEmpty) tagNames = null;
          }
        } catch (_) {
          // fail-open: any error leaves tagNames as null
        }

        if (tagNames != null && tagNames.isNotEmpty) {
          // Success: cache and then run second pass.
          _cache[bvid] = _TagCacheEntry(
            tagNames: tagNames,
            fetchedAt: DateTime.now(),
          );
          if (_tagOnlySecondPass(tagNames, shieldRuleSet)) {
            results[index] = item;
          }
          // else: blocked by detail tags → drop
        } else {
          // No usable tags (empty, fetch failed, etc.) → fail-open.
          results[index] = item;
        }
      }
    }

    final concurrency = tagEnrichConcurrency;
    final workerCount = concurrency < pendingIndices.length
        ? concurrency
        : pendingIndices.length;
    await Future.wait(
      List.generate(workerCount, (_) => worker()),
    );
  }

  static void _evictExpiredCache() {
    final cutoff = DateTime.now().subtract(_tagCacheTTL);
    _cache.removeWhere((_, entry) => entry.fetchedAt.isBefore(cutoff));
  }

  static void _evictOverflow() {
    if (_cache.length <= _tagCacheMaxEntries) return;
    // Evict oldest entries first (FIFO).
    final sorted = _cache.entries.toList()
      ..sort((a, b) => a.value.fetchedAt.compareTo(b.value.fetchedAt));
    final toDrop = sorted.take(_cache.length - _tagCacheMaxEntries);
    for (final entry in toDrop) {
      _cache.remove(entry.key);
    }
  }
}
