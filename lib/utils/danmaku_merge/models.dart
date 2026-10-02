// Inspired by pakku.js (https://github.com/xmcp/pakku.js)
// This file defines internal merge models used by the danmaku merge pipeline.

import 'package:PiliPlus/grpc/bilibili/community/service/dm/v1.pb.dart';

enum DanmakuMergeReason {
  exact,
  charDistance,
  pinyinDistance,
  cosineDistance,
}

class DanmakuMergeConfig {
  const DanmakuMergeConfig({
    required this.enabled,
    required this.windowMs,
    required this.maxDistance,
    required this.maxCosine,
    required this.representativePercent,
    required this.usePinyin,
    required this.crossMode,
    required this.skipSubtitle,
    required this.skipAdvanced,
    required this.skipBottom,
  });

  final bool enabled;
  final int windowMs;
  final int maxDistance;
  final int maxCosine;
  final int representativePercent;
  final bool usePinyin;
  final bool crossMode;
  final bool skipSubtitle;
  final bool skipAdvanced;
  final bool skipBottom;
}

class DanmakuPreparedText {
  const DanmakuPreparedText({
    required this.normalizedText,
    required this.charLength,
    required this.charCounts,
    required this.gramCounts,
    required this.gramSelfDot,
    required this.pinyinLength,
    required this.pinyinCounts,
  });

  final String normalizedText;

  // Token-count bags (and the gram self dot product) are precomputed once per
  // unique text so per-pair comparisons in DanmakuSimilarityMatcher never
  // rebuild hash maps inside the O(N x K) matching loop.
  final int charLength;
  final Map<int, int> charCounts;
  final Map<int, int> gramCounts;
  final int gramSelfDot;
  final int pinyinLength;
  final Map<int, int> pinyinCounts;
}

class DanmakuMergeCandidate {
  const DanmakuMergeCandidate({
    required this.element,
    required this.segmentIndex,
    required this.prepared,
  });

  final DanmakuElem element;
  final int segmentIndex;
  final DanmakuPreparedText prepared;

  String get normalizedText => prepared.normalizedText;
  int get mode => element.mode;
  int get progress => element.progress;
}

class DanmakuSimilarityMatchResult {
  const DanmakuSimilarityMatchResult({
    required this.reason,
    required this.distance,
  });

  final DanmakuMergeReason reason;
  final int distance;
}

class DanmakuMergeCluster {
  DanmakuMergeCluster(this.root) : peers = <DanmakuMergeCandidate>[root];

  final DanmakuMergeCandidate root;
  final List<DanmakuMergeCandidate> peers;

  int get progress => root.progress;

  void add(DanmakuMergeCandidate candidate) {
    peers.add(candidate);
  }
}
