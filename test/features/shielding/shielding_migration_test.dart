import 'package:PiliPlus/features/shielding/shielding.dart';
import 'package:PiliPlus/utils/recommend_filter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RecommendFilterAnalyzer', () {
    setUp(() {
      // 重置 RecommendFilter 到默认值，避免访问 Hive Pref
      RecommendFilter.rcmdRegExp = RegExp('', caseSensitive: false);
      RecommendFilter.minDurationForRcmd = 0;
      RecommendFilter.minPlayForRcmd = 0;
      RecommendFilter.minLikeRatioForRecommend = 0;
      RecommendFilter.exemptFilterForFollowed = false;
      RecommendFilter.applyFilterToRelatedVideos = false;
    });

    test('all-zero config produces no direct migration rules', () {
      // setUp 已重置为零值
      final report = RecommendFilterAnalyzer.analyze();

      // All zero-value settings should have suggestedRule == null
      for (final candidate in report.candidates) {
        if (candidate.confidence == 0.0) {
          expect(candidate.suggestedRule, isNull,
              reason: '${candidate.oldSettingKey} should have no suggested rule');
          expect(candidate.toBeApplied(), isNull);
        }
      }
    });

    test('pipe-separated ban words produce one keyword rule per word', () {
      RecommendFilter.rcmdRegExp = RegExp('猫|狗|鱼', caseSensitive: false);

      final report = RecommendFilterAnalyzer.analyze();
      final banCandidates = report.candidates
          .where((c) => c.oldSettingKey == 'banWordForRecommend')
          .toList();

      // 3 words → 3 candidates
      expect(banCandidates, hasLength(3));
      for (final candidate in banCandidates) {
        expect(candidate.feasibility, MigrationFeasibility.direct);
        expect(candidate.suggestedRule, isNotNull);
        expect(candidate.suggestedRule!.type, ShieldRuleType.keyword);
        expect(candidate.suggestedRule!.matchMode, ShieldMatchMode.exact);
        expect(candidate.suggestedRule!.action, ShieldAction.block);
        expect(candidate.suggestedRule!.scope, ShieldScope.recommendation);
        expect(candidate.suggestedRule!.source, ShieldRuleSource.imported);
        expect(candidate.suggestedRule!.enabled, isTrue);

        // toBeApplied returns the rule without side effects
        final applied = candidate.toBeApplied();
        expect(applied, same(candidate.suggestedRule));
      }

      // Each word is a separate rule
      expect(banCandidates.map((c) => c.suggestedRule!.pattern),
          containsAll(['猫', '狗', '鱼']));
    });

    test('complex regex ban word produces single regex rule', () {
      RecommendFilter.rcmdRegExp =
          RegExp(r'测试\d{3,}', caseSensitive: false);

      final report = RecommendFilterAnalyzer.analyze();
      final banCandidates = report.candidates
          .where((c) => c.oldSettingKey == 'banWordForRecommend')
          .toList();

      // Complex regex → single regex rule
      expect(banCandidates, hasLength(1));
      final candidate = banCandidates.single;
      expect(candidate.feasibility, MigrationFeasibility.direct);
      expect(candidate.suggestedRule!.matchMode, ShieldMatchMode.regex);
      expect(candidate.suggestedRule!.pattern, r'测试\d{3,}');
    });

    test('duration threshold is unsupported and has no suggested rule', () {
      RecommendFilter.minDurationForRcmd = 60;

      final report = RecommendFilterAnalyzer.analyze();
      final durCandidate = report.candidates
          .firstWhere((c) => c.oldSettingKey == 'minDurationForRcmd');

      expect(durCandidate.feasibility, MigrationFeasibility.unsupported);
      expect(durCandidate.suggestedRule, isNull);
      expect(durCandidate.toBeApplied(), isNull);
    });

    test('play count threshold is unsupported', () {
      RecommendFilter.minPlayForRcmd = 100;

      final report = RecommendFilterAnalyzer.analyze();
      final playCandidate = report.candidates
          .firstWhere((c) => c.oldSettingKey == 'minPlayForRcmd');

      expect(playCandidate.feasibility, MigrationFeasibility.unsupported);
      expect(playCandidate.suggestedRule, isNull);
    });

    test('like ratio threshold is unsupported', () {
      RecommendFilter.minLikeRatioForRecommend = 2;

      final report = RecommendFilterAnalyzer.analyze();
      final likeCandidate = report.candidates
          .firstWhere((c) => c.oldSettingKey == 'minLikeRatioForRecommend');

      expect(likeCandidate.feasibility, MigrationFeasibility.unsupported);
      expect(likeCandidate.suggestedRule, isNull);
    });

    test('exemptFollowed is partial and notes mention isFollowed gap', () {
      RecommendFilter.exemptFilterForFollowed = true;

      final report = RecommendFilterAnalyzer.analyze();
      final exemptCandidate = report.candidates
          .firstWhere((c) => c.oldSettingKey == 'exemptFilterForFollowed');

      expect(exemptCandidate.feasibility, MigrationFeasibility.partial);
      expect(exemptCandidate.notes, contains('isFollowed'));
    });

    test('applyToRelatedVideos notes Phase 1 behavior', () {
      RecommendFilter.applyFilterToRelatedVideos = true;

      final report = RecommendFilterAnalyzer.analyze();
      final relatedCandidate = report.candidates
          .firstWhere((c) => c.oldSettingKey == 'applyFilterToRelatedVideos');

      expect(relatedCandidate.feasibility, MigrationFeasibility.partial);
      expect(relatedCandidate.notes, contains('Phase 1'));
    });

    test('tag capability analysis reports ready state regardless of config', () {
      // setUp 已重置
      final report = RecommendFilterAnalyzer.analyze();
      final tagCandidate = report.candidates
          .firstWhere((c) => c.oldSettingKey == 'tag');

      expect(tagCandidate.feasibility, MigrationFeasibility.direct);
      expect(tagCandidate.suggestedRule, isNull); // no old data to map
      expect(tagCandidate.notes, contains('ShieldRuleType.tag'));
    });

    test('report aggregates counts correctly', () {
      RecommendFilter.rcmdRegExp = RegExp('猫|狗', caseSensitive: false);
      RecommendFilter.minDurationForRcmd = 60;
      RecommendFilter.minPlayForRcmd = 100;
      RecommendFilter.minLikeRatioForRecommend = 2;
      RecommendFilter.exemptFilterForFollowed = false;
      RecommendFilter.applyFilterToRelatedVideos = false;

      final report = RecommendFilterAnalyzer.analyze();

      // 2 ban words → 2 direct + tag direct
      expect(report.directCount, greaterThanOrEqualTo(2));
      // duration + play + like → 3 unsupported
      expect(report.unsupportedCount, greaterThanOrEqualTo(3));
      expect(report.candidates, isNotEmpty);
    });
  });

  group('ShieldMigrationCandidate', () {
    test('direct candidate toBeApplied returns suggestedRule', () {
      final candidate = ShieldMigrationCandidate(
        oldSettingKey: 'banWordForRecommend',
        oldSettingValue: 'test',
        feasibility: MigrationFeasibility.direct,
        suggestedRule: ShieldRule(
          id: 'test',
          type: ShieldRuleType.keyword,
          matchMode: ShieldMatchMode.exact,
          scope: ShieldScope.recommendation,
          action: ShieldAction.block,
          pattern: 'test',
          updatedAt: DateTime.fromMillisecondsSinceEpoch(1),
          source: ShieldRuleSource.imported,
        ),
      );

      expect(candidate.toBeApplied(), isNotNull);
      expect(candidate.toBeApplied()!.pattern, 'test');
    });

    test('unsupported candidate toBeApplied returns null', () {
      final candidate = const ShieldMigrationCandidate(
        oldSettingKey: 'minDurationForRcmd',
        oldSettingValue: '60',
        feasibility: MigrationFeasibility.unsupported,
      );

      expect(candidate.toBeApplied(), isNull);
    });
  });
}
