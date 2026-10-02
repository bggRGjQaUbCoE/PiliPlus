// Inspired by pakku.js (https://github.com/xmcp/pakku.js)
// References:
// - pakkujs/core/combine_worker.ts
// - pakkujs/core/scheduler.ts

import 'dart:collection';

import 'package:PiliPlus/grpc/bilibili/community/service/dm/v1.pb.dart';
import 'package:PiliPlus/utils/danmaku_merge/models.dart';
import 'package:PiliPlus/utils/danmaku_merge/normalizer.dart';
import 'package:PiliPlus/utils/danmaku_merge/pinyin_encoder.dart';
import 'package:PiliPlus/utils/danmaku_merge/similarity_matcher.dart';

class DanmakuClusterer {
  DanmakuClusterer({
    required this.config,
    required DanmakuPinyinEncoder pinyinEncoder,
    DanmakuPreparedText Function(String text)? prepareText,
  }) : _matcher = DanmakuSimilarityMatcher(config: config),
       _prepareText =
           prepareText ??
           ((text) => DanmakuClusterer.prepareText(text, pinyinEncoder));

  final DanmakuMergeConfig config;
  final DanmakuSimilarityMatcher _matcher;
  final DanmakuPreparedText Function(String text) _prepareText;

  static DanmakuPreparedText prepareText(
    String text,
    DanmakuPinyinEncoder pinyinEncoder,
  ) {
    final normalizedText = DanmakuNormalizer.normalize(text);
    final charTokens = normalizedText.runes.toList(growable: false);
    final gramCounts = DanmakuSimilarityMatcher.countTokens(
      DanmakuSimilarityMatcher.buildGramTokens(normalizedText),
    );
    var gramSelfDot = 0;
    for (final value in gramCounts.values) {
      gramSelfDot += value * value;
    }
    final pinyinTokens = pinyinEncoder.encode(normalizedText);
    return DanmakuPreparedText(
      normalizedText: normalizedText,
      charLength: charTokens.length,
      charCounts: DanmakuSimilarityMatcher.countTokens(charTokens),
      gramCounts: gramCounts,
      gramSelfDot: gramSelfDot,
      pinyinLength: pinyinTokens.length,
      pinyinCounts: DanmakuSimilarityMatcher.countTokens(pinyinTokens),
    );
  }

  List<DanmakuElem> mergeSegment({
    required int segmentIndex,
    required List<DanmakuElem> currentSegment,
    required List<DanmakuElem> nextSegmentPrefix,
  }) {
    if (!config.enabled || currentSegment.isEmpty) {
      return currentSegment;
    }

    final current = List<DanmakuElem>.from(currentSegment)
      ..sort((a, b) => a.progress.compareTo(b.progress));
    final next = List<DanmakuElem>.from(nextSegmentPrefix)
      ..sort((a, b) => a.progress.compareTo(b.progress));

    final output = <DanmakuElem>[];

    final ListQueue<DanmakuMergeCluster>? activeClustersFlat =
        config.crossMode ? ListQueue<DanmakuMergeCluster>() : null;
    final Map<int, ListQueue<DanmakuMergeCluster>>? activeClustersByMode =
        config.crossMode ? null : <int, ListQueue<DanmakuMergeCluster>>{};

    final exactMatchMap = <String, DanmakuMergeCluster>{};

    String getExactKey(DanmakuMergeCandidate c) =>
        config.crossMode ? c.normalizedText : '${c.mode}:${c.normalizedText}';

    void removeCluster(DanmakuMergeCluster cluster) {
      output.add(_buildRepresentative(cluster));
      for (final peer in cluster.peers) {
        exactMatchMap.remove(getExactKey(peer));
      }
    }

    // Inspired by pakku's active-cluster queue: clusters are emitted once they
    // are outside the configured merge window.
    void flushExpired(int currentProgress) {
      if (config.crossMode) {
        while (activeClustersFlat!.isNotEmpty &&
            currentProgress - activeClustersFlat.first.progress >
                config.windowMs) {
          removeCluster(activeClustersFlat.removeFirst());
        }
      } else {
        for (final clusters in activeClustersByMode!.values) {
          while (clusters.isNotEmpty &&
              currentProgress - clusters.first.progress > config.windowMs) {
            removeCluster(clusters.removeFirst());
          }
        }
      }
    }

    for (final element in current) {
      flushExpired(element.progress);
      if (!_isMergeable(element)) {
        output.add(element);
        continue;
      }

      final candidate = _toCandidate(element, segmentIndex);
      var matched = false;

      final exactKey = getExactKey(candidate);
      final exactCluster = exactMatchMap[exactKey];
      if (exactCluster != null) {
        exactCluster.add(candidate);
        continue;
      }

      final Iterable<DanmakuMergeCluster> searchSpace = config.crossMode
          ? activeClustersFlat!
          : activeClustersByMode!.putIfAbsent(candidate.mode, ListQueue.new);

      for (final cluster in searchSpace) {
        final result = _matcher.match(candidate, cluster.root);
        if (result != null) {
          cluster.add(candidate);
          exactMatchMap[exactKey] = cluster;
          matched = true;
          break;
        }
      }

      if (!matched) {
        final newCluster = DanmakuMergeCluster(candidate);
        exactMatchMap[exactKey] = newCluster;
        if (config.crossMode) {
          activeClustersFlat!.add(newCluster);
        } else {
          activeClustersByMode![candidate.mode]!.add(newCluster);
        }
      }
    }

    // Adapted from pakku's next-chunk prefix matching to reduce segment-edge
    // misses without requiring a full multi-segment scheduler.
    for (final element in next) {
      flushExpired(element.progress);
      if (!_isMergeable(element)) {
        continue;
      }
      final candidate = _toCandidate(element, segmentIndex + 1);

      final exactKey = getExactKey(candidate);
      final exactCluster = exactMatchMap[exactKey];
      if (exactCluster != null) {
        exactCluster.add(candidate);
        continue;
      }

      final Iterable<DanmakuMergeCluster> searchSpace = config.crossMode
          ? activeClustersFlat!
          : (activeClustersByMode![candidate.mode] ?? const []);

      for (final cluster in searchSpace) {
        final result = _matcher.match(candidate, cluster.root);
        if (result != null) {
          cluster.add(candidate);
          exactMatchMap[exactKey] = cluster;
          break;
        }
      }
    }

    if (config.crossMode) {
      while (activeClustersFlat!.isNotEmpty) {
        removeCluster(activeClustersFlat.removeFirst());
      }
    } else {
      for (final clusters in activeClustersByMode!.values) {
        while (clusters.isNotEmpty) {
          removeCluster(clusters.removeFirst());
        }
      }
    }
    output.sort((a, b) => a.progress.compareTo(b.progress));
    return output;
  }

  bool _isMergeable(DanmakuElem element) {
    if (element.isSelf) {
      return false;
    }
    if (element.mode == 8 || element.mode == 9) {
      return false;
    }
    if (config.skipSubtitle && element.pool == 1) {
      return false;
    }
    if (config.skipAdvanced && element.mode == 7) {
      return false;
    }
    if (config.skipBottom && element.mode == 4) {
      return false;
    }
    return true;
  }

  DanmakuMergeCandidate _toCandidate(DanmakuElem element, int segmentIndex) {
    return DanmakuMergeCandidate(
      element: element,
      segmentIndex: segmentIndex,
      prepared: _prepareText(element.content),
    );
  }

  DanmakuElem _buildRepresentative(DanmakuMergeCluster cluster) {
    final chosenText = _chooseText(cluster);
    final representativePeer = _pickRepresentativePeer(cluster);
    final representative = representativePeer.element.deepCopy()
      ..content = chosenText
      ..count = cluster.peers.length;
    return representative;
  }

  DanmakuMergeCandidate _pickRepresentativePeer(DanmakuMergeCluster cluster) {
    final index = ((cluster.peers.length * config.representativePercent) / 100)
        .floor()
        .clamp(0, cluster.peers.length - 1);
    return cluster.peers[index];
  }

  String _chooseText(DanmakuMergeCluster cluster) {
    if (cluster.peers.length == 1) {
      return cluster.root.element.content;
    }

    final textCounts = <String, int>{};
    var bestCount = 0;
    var bestTexts = <String>[];
    for (final peer in cluster.peers) {
      final count = (textCounts[peer.normalizedText] ?? 0) + 1;
      textCounts[peer.normalizedText] = count;
      if (count > bestCount) {
        bestCount = count;
        bestTexts = <String>[peer.element.content];
      } else if (count == bestCount) {
        bestTexts.add(peer.element.content);
      }
    }

    bestTexts.sort((a, b) => a.length.compareTo(b.length));
    return bestTexts[bestTexts.length ~/ 2];
  }
}
