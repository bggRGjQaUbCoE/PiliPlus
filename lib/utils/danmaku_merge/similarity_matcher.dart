// Inspired by pakku.js (https://github.com/xmcp/pakku.js)
// Reference: pakkujs/similarity/repo-cpp/src/main.cpp

import 'dart:collection';
import 'dart:math' show max;

import 'package:PiliPlus/utils/danmaku_merge/models.dart';

class DanmakuSimilarityMatcher {
  static const int _hashMod = 1007;

  DanmakuSimilarityMatcher({required this.config});

  final DanmakuMergeConfig config;

  DanmakuSimilarityMatchResult? match(
    DanmakuMergeCandidate source,
    DanmakuMergeCandidate target,
  ) {
    if (!config.crossMode && source.mode != target.mode) {
      return null;
    }

    final sourceText = source.prepared;
    final targetText = target.prepared;
    if (sourceText.normalizedText == targetText.normalizedText) {
      return const DanmakuSimilarityMatchResult(
        reason: DanmakuMergeReason.exact,
        distance: 0,
      );
    }

    final lenSum = sourceText.charLength + targetText.charLength;
    int? charDist;
    if ((sourceText.charLength - targetText.charLength).abs() <=
        config.maxDistance) {
      charDist = _bagDistance(sourceText.charCounts, targetText.charCounts);
      if (_withinDistance(charDist, lenSum)) {
        return DanmakuSimilarityMatchResult(
          reason: DanmakuMergeReason.charDistance,
          distance: charDist,
        );
      }
    }

    if (config.usePinyin &&
        (sourceText.pinyinLength - targetText.pinyinLength).abs() <=
            config.maxDistance) {
      final pinyinDist = _bagDistance(
        sourceText.pinyinCounts,
        targetText.pinyinCounts,
      );
      if (_withinDistance(
        pinyinDist,
        sourceText.pinyinLength + targetText.pinyinLength,
      )) {
        return DanmakuSimilarityMatchResult(
          reason: DanmakuMergeReason.pinyinDistance,
          distance: pinyinDist,
        );
      }
    }

    if (config.maxCosine <= 100) {
      // pakku's no-common-char guard, reusing the char distance computed
      // above instead of recomputing it.
      final noCommonChar = charDist != null && charDist >= lenSum;
      if (!noCommonChar) {
        final cosine = _cosineSimilarity(sourceText, targetText);
        if (cosine >= config.maxCosine) {
          return DanmakuSimilarityMatchResult(
            reason: DanmakuMergeReason.cosineDistance,
            distance: cosine,
          );
        }
      }
    }

    return null;
  }

  static List<int> buildGramTokens(String text) {
    if (text.isEmpty) {
      return const <int>[];
    }

    final runes = text.runes.toList(growable: false);
    final grams = <int>[];
    var previous = runes.last % _hashMod;
    for (final rune in runes) {
      final current = rune % _hashMod;
      grams.add(previous * _hashMod + current);
      previous = current;
    }
    return grams;
  }

  static HashMap<int, int> countTokens(List<int> tokens) {
    final counts = HashMap<int, int>();
    for (final token in tokens) {
      counts[token] = (counts[token] ?? 0) + 1;
    }
    return counts;
  }

  int charDistance(DanmakuPreparedText source, DanmakuPreparedText target) =>
      _bagDistance(source.charCounts, target.charCounts);

  int pinyinDistance(DanmakuPreparedText source, DanmakuPreparedText target) =>
      _bagDistance(source.pinyinCounts, target.pinyinCounts);

  int cosineSimilarity(
    DanmakuPreparedText source,
    DanmakuPreparedText target,
  ) => _cosineSimilarity(source, target);

  // Adapted from pakku's O(n) bag-distance approximation instead of using a
  // textbook edit distance, to keep matching fast in danmaku-heavy segments.
  bool _withinDistance(int distance, int lenSum) {
    final minDanmakuSize = max(1, config.maxDistance * 2);
    return lenSum < minDanmakuSize
        ? distance < config.maxDistance * lenSum / minDanmakuSize
        : distance <= config.maxDistance;
  }

  int _bagDistance(Map<int, int> source, Map<int, int> target) {
    var distance = 0;
    for (final entry in source.entries) {
      distance += (entry.value - (target[entry.key] ?? 0)).abs();
    }
    for (final entry in target.entries) {
      if (!source.containsKey(entry.key)) {
        distance += entry.value;
      }
    }
    return distance;
  }

  int _cosineSimilarity(
    DanmakuPreparedText source,
    DanmakuPreparedText target,
  ) {
    final y = source.gramSelfDot;
    final z = target.gramSelfDot;
    if (y == 0 || z == 0) {
      return 0;
    }

    var small = source.gramCounts;
    var large = target.gramCounts;
    if (small.length > large.length) {
      final swap = small;
      small = large;
      large = swap;
    }
    var x = 0;
    for (final entry in small.entries) {
      final other = large[entry.key];
      if (other != null) {
        x += entry.value * other;
      }
    }
    if (x == 0) {
      return 0;
    }

    final score = (100 * x * x) / (y * z);
    return score.floor();
  }
}
