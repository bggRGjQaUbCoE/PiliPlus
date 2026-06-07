import 'dart:async';
import 'dart:io';

import 'package:PiliPlus/features/shielding/shielding.dart';
import 'package:PiliPlus/features/shielding/shielding_recommend_tag_enricher.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/video/video_tag/data.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';

/// A controllable tag-fetch stub for tests.
class _FakeTagFetcher {
  _FakeTagFetcher();

  final Map<String, List<VideoTagItem>?> _responses = {};
  final Map<String, Duration> _delays = {};
  final List<String> fetchLog = [];
  int _activeWorkers = 0;
  int maxConcurrentObserved = 0;

  void setResponse(String bvid, List<VideoTagItem>? tags) {
    _responses[bvid] = tags;
  }

  void setDelay(String bvid, Duration delay) {
    _delays[bvid] = delay;
  }

  Future<LoadingState<List<VideoTagItem>?>> call(
    String bvid,
    Object? cid,
  ) async {
    fetchLog.add(bvid);
    _activeWorkers++;
    if (_activeWorkers > maxConcurrentObserved) {
      maxConcurrentObserved = _activeWorkers;
    }
    try {
      final delay = _delays[bvid] ?? Duration.zero;
      if (delay > Duration.zero) {
        await Future.delayed(delay);
      }
      final tags = _responses[bvid];
      if (tags == null) {
        // Simulate an API error
        return const Error('simulated failure');
      }
      return Success(tags);
    } finally {
      _activeWorkers--;
    }
  }
}

List<VideoTagItem> _tags(List<String> names) =>
    names.map((n) => VideoTagItem(tagName: n)).toList();

ShieldRuleSet _tagBlockRuleSet(String blockedTag) => ShieldRuleSet(
  rules: [
    ShieldRule(
      id: 'block-tag',
      type: ShieldRuleType.tag,
      matchMode: ShieldMatchMode.exact,
      scope: ShieldScope.recommendation,
      action: ShieldAction.block,
      pattern: blockedTag,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(1),
    ),
  ],
);

void main() {
  setUpAll(() async {
    try {
      final dir = Directory.systemTemp.createTempSync('hive_test_');
      Hive.init(dir.path);
      GStorage.setting = await Hive.openBox('setting');
    } catch (_) {
      // Already initialized by another test file in the same isolate.
    }
  });

  group('RecommendationTagEnricher', () {
    setUp(() {
      RecommendationTagEnricher.resetCache();
      // Reset settings to defaults between tests.
      GStorage.setting.delete(SettingBoxKey.tagEnrichConcurrency);
      GStorage.setting.delete(SettingBoxKey.tagEnrichTimeout);
      GStorage.setting.delete(SettingBoxKey.tagEnrichCacheMaxMb);
    });

    // -- Survivor-only enrichment ----------------------------------------

    test('only enriches survivors, not blocked first-pass items', () async {
      final fetcher = _FakeTagFetcher()..setResponse('BV1', _tags(['tag-a']));

      final enricher = RecommendationTagEnricher(fetchTags: fetcher.call);

      // "survivors" represents items that already passed first pass.
      // No blocked items are passed in — the caller only sends survivors.
      final result = await enricher.enrichAndFilter<int>(
        [1, 2], // simulated survivors with bvid BV1, BV2
        ShieldRuleSet(),
        getBvid: (i) => i == 1 ? 'BV1' : 'BV2',
        getCid: (_) => null,
      );

      // Only BV1 was in the fetch responses; BV2 has no stub so it gets
      // a simulated error (null response), which means fail-open → kept.
      expect(fetcher.fetchLog, contains('BV1'));
      // BV2 also triggers a fetch since it's not mocked
      expect(result, containsAll([1, 2]));
    });

    test('does not fetch for items with null bvid', () async {
      final fetcher = _FakeTagFetcher();

      final enricher = RecommendationTagEnricher(fetchTags: fetcher.call);

      final result = await enricher.enrichAndFilter<int>(
        [1, 2],
        ShieldRuleSet(),
        getBvid: (i) => i == 1 ? null : 'BV2',
        getCid: (_) => null,
      );

      // Item 1 (null bvid) should be kept (fail-open) without any fetch.
      // Item 2 will trigger a fetch.
      expect(fetcher.fetchLog, isNot(contains(null)));
      expect(fetcher.fetchLog.length, 1); // Only BV2
      expect(result, containsAll([1, 2]));
    });

    // -- Tag-only second pass --------------------------------------------

    test('tag-only second pass blocks by detail tag', () async {
      final fetcher = _FakeTagFetcher()
        ..setResponse('BV1', _tags(['blocked-tag']))
        ..setResponse('BV2', _tags(['safe-tag']));

      final enricher = RecommendationTagEnricher(fetchTags: fetcher.call);
      final ruleSet = _tagBlockRuleSet('blocked-tag');

      final result = await enricher.enrichAndFilter<String>(
        ['item-1', 'item-2'],
        ruleSet,
        getBvid: (s) => s == 'item-1' ? 'BV1' : 'BV2',
        getCid: (_) => null,
      );

      expect(result, ['item-2']);
    });

    test(
      'tag-only second pass does not re-run title/user/reason/category rules',
      () async {
        final fetcher = _FakeTagFetcher()
          ..setResponse('BV1', _tags(['detail-safe']));

        // Rule set has a keyword block that would match a title, but the
        // second pass uses a tag-only candidate so keyword rules are not
        // checked.
        final ruleSet = ShieldRuleSet(
          rules: [
            ShieldRule(
              id: 'kw-block',
              type: ShieldRuleType.keyword,
              matchMode: ShieldMatchMode.exact,
              scope: ShieldScope.recommendation,
              action: ShieldAction.block,
              pattern: 'bad-title',
              updatedAt: DateTime.fromMillisecondsSinceEpoch(1),
            ),
            ShieldRule(
              id: 'uid-block',
              type: ShieldRuleType.uid,
              matchMode: ShieldMatchMode.exact,
              scope: ShieldScope.recommendation,
              action: ShieldAction.block,
              pattern: '42',
              updatedAt: DateTime.fromMillisecondsSinceEpoch(1),
            ),
            ShieldRule(
              id: 'cat-block',
              type: ShieldRuleType.category,
              matchMode: ShieldMatchMode.exact,
              scope: ShieldScope.recommendation,
              action: ShieldAction.block,
              pattern: '游戏',
              updatedAt: DateTime.fromMillisecondsSinceEpoch(1),
            ),
            ShieldRule(
              id: 'reason-block',
              type: ShieldRuleType.reasonKeyword,
              matchMode: ShieldMatchMode.exact,
              scope: ShieldScope.recommendation,
              action: ShieldAction.block,
              pattern: 'bad-reason',
              updatedAt: DateTime.fromMillisecondsSinceEpoch(1),
            ),
          ],
        );

        final enricher = RecommendationTagEnricher(fetchTags: fetcher.call);

        final result = await enricher.enrichAndFilter<String>(
          ['item'],
          ruleSet,
          getBvid: (_) => 'BV1',
          getCid: (_) => null,
        );

        // The item has detail tags that don't match any tag rule, and
        // the non-tag rules are not re-run → item survives.
        expect(result, ['item']);
      },
    );

    // -- Fail-open -------------------------------------------------------

    test('fail-open: fetch timeout keeps item visible', () async {
      final fetcher = _FakeTagFetcher();
      // Set a very long delay to trigger timeout in the enricher.
      // But the enricher uses a 3s timeout. We'll use a short timeout
      // approach: make the fetch throw a TimeoutException.
      // Actually, the enricher's .timeout() wraps the call, so we
      // just make the delay longer than 3s. But that makes the test slow.
      // Instead, let's make fetch throw immediately.
      final enricher = RecommendationTagEnricher(
        fetchTags: (bvid, cid) async {
          fetcher.fetchLog.add(bvid);
          await Future.delayed(const Duration(milliseconds: 10));
          throw TimeoutException('simulated timeout');
        },
      );

      final result = await enricher.enrichAndFilter<String>(
        ['item'],
        _tagBlockRuleSet('any-tag'),
        getBvid: (_) => 'BV1',
        getCid: (_) => null,
      );

      // Fail-open: item is kept even though tag fetch timed out.
      expect(result, ['item']);
    });

    test('fail-open: thrown error keeps item visible', () async {
      final enricher = RecommendationTagEnricher(
        fetchTags: (bvid, cid) {
          throw Exception('network error');
        },
      );

      final result = await enricher.enrichAndFilter<String>(
        ['item'],
        _tagBlockRuleSet('any-tag'),
        getBvid: (_) => 'BV1',
        getCid: (_) => null,
      );

      expect(result, ['item']);
    });

    test('fail-open: failed LoadingState keeps item visible', () async {
      final enricher = RecommendationTagEnricher(
        fetchTags: (bvid, cid) async => const Error('API returned error'),
      );

      final result = await enricher.enrichAndFilter<String>(
        ['item'],
        _tagBlockRuleSet('any-tag'),
        getBvid: (_) => 'BV1',
        getCid: (_) => null,
      );

      expect(result, ['item']);
    });

    test('fail-open: empty tag list keeps item visible', () async {
      final enricher = RecommendationTagEnricher(
        fetchTags: (bvid, cid) async => const Success([]),
      );

      final result = await enricher.enrichAndFilter<String>(
        ['item'],
        _tagBlockRuleSet('any-tag'),
        getBvid: (_) => 'BV1',
        getCid: (_) => null,
      );

      expect(result, ['item']);
    });

    test(
      'fail-open: tags with only empty/whitespace names kept visible',
      () async {
        final enricher = RecommendationTagEnricher(
          fetchTags: (bvid, cid) async => Success([
            VideoTagItem(tagName: ''),
            VideoTagItem(tagName: '   '),
          ]),
        );

        final result = await enricher.enrichAndFilter<String>(
          ['item'],
          _tagBlockRuleSet('any-tag'),
          getBvid: (_) => 'BV1',
          getCid: (_) => null,
        );

        expect(result, ['item']);
      },
    );

    // -- Bounded concurrency ---------------------------------------------

    test('no more than 5 fetches active at once', () async {
      final fetcher = _FakeTagFetcher();
      // Set up 10 items with a small delay so they're all in flight.
      for (int i = 0; i < 10; i++) {
        final bvid = 'BV$i';
        fetcher
          ..setResponse(bvid, _tags(['safe']))
          ..setDelay(bvid, const Duration(milliseconds: 50));
      }

      final enricher = RecommendationTagEnricher(fetchTags: fetcher.call);

      await enricher.enrichAndFilter<int>(
        List.generate(10, (i) => i),
        ShieldRuleSet(),
        getBvid: (i) => 'BV$i',
        getCid: (_) => null,
      );

      expect(fetcher.maxConcurrentObserved, lessThanOrEqualTo(5));
    });

    // -- Cache ----------------------------------------------------------

    test('successful tag fetch result is cached and reused', () async {
      final fetcher = _FakeTagFetcher()
        ..setResponse('BV1', _tags(['cached-tag']));

      final enricher = RecommendationTagEnricher(fetchTags: fetcher.call);

      // First enrichment: fetches BV1.
      await enricher.enrichAndFilter<String>(
        ['item-1'],
        ShieldRuleSet(),
        getBvid: (_) => 'BV1',
        getCid: (_) => null,
      );

      expect(fetcher.fetchLog.length, 1);

      // Second enrichment with same bvid: should use cache, no fetch.
      await enricher.enrichAndFilter<String>(
        ['item-2'],
        _tagBlockRuleSet('cached-tag'),
        getBvid: (_) => 'BV1',
        getCid: (_) => null,
      );

      // Fetch log should still have only 1 entry.
      expect(fetcher.fetchLog.length, 1);
      // And the cached tags should block item-2.
      final result = await enricher.enrichAndFilter<String>(
        ['item-3'],
        _tagBlockRuleSet('cached-tag'),
        getBvid: (_) => 'BV1',
        getCid: (_) => null,
      );
      expect(result, isEmpty);
    });

    test('failed tag fetch is not cached', () async {
      final fetcher = _FakeTagFetcher();
      // First call: simulate failure by not setting a response.
      // The fake returns Error by default when no response is set.
      // Wait, looking at _FakeTagFetcher, null in _responses means Error.

      final enricher = RecommendationTagEnricher(fetchTags: fetcher.call);

      // First call: no response set → Error → fail-open.
      await enricher.enrichAndFilter<String>(
        ['item-1'],
        ShieldRuleSet(),
        getBvid: (_) => 'BV1',
        getCid: (_) => null,
      );

      final firstCallCount = fetcher.fetchLog.length;

      // Now set a success response. Since failure wasn't cached, a
      // second call should fetch again.
      fetcher.setResponse('BV1', _tags(['now-available']));

      await enricher.enrichAndFilter<String>(
        ['item-2'],
        ShieldRuleSet(),
        getBvid: (_) => 'BV1',
        getCid: (_) => null,
      );

      // Should have fetched again (not from cache).
      expect(fetcher.fetchLog.length, greaterThan(firstCallCount));
    });

    test(
      'successful fetch cached by first instance is reused by a second instance',
      () async {
        final fetcher1 = _FakeTagFetcher()
          ..setResponse('BV1', _tags(['shared-tag']));
        final enricher1 = RecommendationTagEnricher(fetchTags: fetcher1.call);

        // First instance fetches and caches BV1.
        await enricher1.enrichAndFilter<String>(
          ['item-1'],
          ShieldRuleSet(),
          getBvid: (_) => 'BV1',
          getCid: (_) => null,
        );
        expect(fetcher1.fetchLog.length, 1);

        // Second instance with a different fetcher stub (no response set
        // for BV1). If the cache is shared, it should reuse the cached
        // tags and NOT call fetcher2 at all.
        final fetcher2 = _FakeTagFetcher();
        final enricher2 = RecommendationTagEnricher(fetchTags: fetcher2.call);

        // The cached tag 'shared-tag' is blocked → item should be dropped.
        final result = await enricher2.enrichAndFilter<String>(
          ['item-2'],
          _tagBlockRuleSet('shared-tag'),
          getBvid: (_) => 'BV1',
          getCid: (_) => null,
        );

        expect(fetcher2.fetchLog, isEmpty);
        expect(result, isEmpty);
      },
    );

    test('cache clear resets estimated bytes', () async {
      final fetcher = _FakeTagFetcher()..setResponse('BV1', _tags(['缓存标签']));

      final enricher = RecommendationTagEnricher(fetchTags: fetcher.call);
      await enricher.enrichAndFilter<String>(
        ['item'],
        ShieldRuleSet(),
        getBvid: (_) => 'BV1',
        getCid: (_) => null,
      );

      expect(RecommendationTagEnricher.cacheEntryCount, 1);
      expect(RecommendationTagEnricher.cacheEstimatedBytes, greaterThan(0));

      RecommendationTagEnricher.resetCache();

      expect(RecommendationTagEnricher.cacheEntryCount, 0);
      expect(RecommendationTagEnricher.cacheEstimatedBytes, 0);
    });

    test('cache overflow is corrected by estimated byte limit', () async {
      GStorage.setting.put(SettingBoxKey.tagEnrichCacheMaxMb, 1);
      final fetcher = _FakeTagFetcher();

      for (int i = 0; i < 450; i++) {
        fetcher.setResponse(
          'BV-large-$i',
          _tags([List.filled(1000, '标签$i').join()]),
        );
      }

      final enricher = RecommendationTagEnricher(fetchTags: fetcher.call);
      await enricher.enrichAndFilter<int>(
        List.generate(450, (i) => i),
        ShieldRuleSet(),
        getBvid: (i) => 'BV-large-$i',
        getCid: (_) => null,
      );

      expect(
        RecommendationTagEnricher.cacheEstimatedBytes,
        lessThanOrEqualTo(tagEnrichCacheMaxBytes),
        reason: 'cache must not exceed configured estimated byte budget',
      );
    });

    // -- Scope guard ----------------------------------------------------

    test('tag-only second pass uses ShieldScope.recommendation', () async {
      final fetcher = _FakeTagFetcher()..setResponse('BV1', _tags(['blocked']));

      // Rule with scope=comment should NOT block a recommendation candidate.
      final ruleSet = ShieldRuleSet(
        rules: [
          ShieldRule(
            id: 'tag-block-comment',
            type: ShieldRuleType.tag,
            matchMode: ShieldMatchMode.exact,
            scope: ShieldScope.comment,
            action: ShieldAction.block,
            pattern: 'blocked',
            updatedAt: DateTime.fromMillisecondsSinceEpoch(1),
          ),
        ],
      );

      final enricher = RecommendationTagEnricher(fetchTags: fetcher.call);

      final result = await enricher.enrichAndFilter<String>(
        ['item'],
        ruleSet,
        getBvid: (_) => 'BV1',
        getCid: (_) => null,
      );

      // Scope is recommendation, rule is comment → no match → item survives.
      expect(result, ['item']);
    });

    // -- With CID -------------------------------------------------------

    test('passes cid to tag fetch function', () async {
      String? receivedCid;
      final enricher = RecommendationTagEnricher(
        fetchTags: (bvid, cid) async {
          receivedCid = cid as String?;
          return const Success([]);
        },
      );

      await enricher.enrichAndFilter<String>(
        ['item'],
        ShieldRuleSet(),
        getBvid: (_) => 'BV1',
        getCid: (_) => '123',
      );

      expect(receivedCid, '123');
    });

    // -- Empty survivors ------------------------------------------------

    test('empty survivor list returns empty without any fetch', () async {
      final fetcher = _FakeTagFetcher();
      final enricher = RecommendationTagEnricher(fetchTags: fetcher.call);

      final result = await enricher.enrichAndFilter<int>(
        [],
        ShieldRuleSet(),
        getBvid: (_) => 'BV1',
        getCid: (_) => null,
      );

      expect(result, isEmpty);
      expect(fetcher.fetchLog, isEmpty);
    });

    // -- Configurable concurrency / timeout -----------------------------

    test('default concurrency is 5', () {
      expect(tagEnrichConcurrency, 5);
    });

    test('default timeout is 3 seconds', () {
      expect(tagEnrichTimeout, const Duration(seconds: 3));
    });

    test('default cache max size is 10 MB', () {
      expect(tagEnrichCacheMaxMb, 10);
      expect(tagEnrichCacheMaxBytes, 10 * 1024 * 1024);
    });

    test('custom concurrency is read from settings and enforced', () async {
      GStorage.setting.put(SettingBoxKey.tagEnrichConcurrency, 2);

      final fetcher = _FakeTagFetcher();
      for (int i = 0; i < 8; i++) {
        final bvid = 'BV$i';
        fetcher
          ..setResponse(bvid, _tags(['safe']))
          ..setDelay(bvid, const Duration(milliseconds: 50));
      }

      final enricher = RecommendationTagEnricher(fetchTags: fetcher.call);
      await enricher.enrichAndFilter<int>(
        List.generate(8, (i) => i),
        ShieldRuleSet(),
        getBvid: (i) => 'BV$i',
        getCid: (_) => null,
      );

      expect(fetcher.maxConcurrentObserved, lessThanOrEqualTo(2));
    });

    test('invalid concurrency value is clamped to defaults', () {
      GStorage.setting.put(SettingBoxKey.tagEnrichConcurrency, 999);
      expect(tagEnrichConcurrency, 10); // clamped to max 10

      GStorage.setting.put(SettingBoxKey.tagEnrichConcurrency, -5);
      expect(tagEnrichConcurrency, 1); // clamped to min 1

      GStorage.setting.put(SettingBoxKey.tagEnrichConcurrency, 'abc');
      expect(tagEnrichConcurrency, 5); // non-int → default
    });

    test('invalid timeout value is clamped to defaults', () {
      GStorage.setting.put(SettingBoxKey.tagEnrichTimeout, 999);
      expect(tagEnrichTimeout, const Duration(seconds: 10)); // clamped to max

      GStorage.setting.put(SettingBoxKey.tagEnrichTimeout, 0);
      expect(tagEnrichTimeout, const Duration(seconds: 1)); // clamped to min

      GStorage.setting.put(SettingBoxKey.tagEnrichTimeout, 'xyz');
      expect(tagEnrichTimeout, const Duration(seconds: 3)); // non-int → default
    });

    test('invalid cache max size is clamped to defaults', () {
      GStorage.setting.put(SettingBoxKey.tagEnrichCacheMaxMb, 999);
      expect(tagEnrichCacheMaxMb, 50);

      GStorage.setting.put(SettingBoxKey.tagEnrichCacheMaxMb, 0);
      expect(tagEnrichCacheMaxMb, 1);

      GStorage.setting.put(SettingBoxKey.tagEnrichCacheMaxMb, 'xyz');
      expect(tagEnrichCacheMaxMb, 10);
    });
  });
}
