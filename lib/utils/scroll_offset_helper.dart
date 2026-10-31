import 'dart:math' as math;

import 'package:PiliPlus/models_new/video/video_detail/episode.dart' as ugc;

const double _kTopPadding = 7;
const double _kBottomPadding = 100;

const double _kItemHeight = 112;
const double _kMultiItemHeight = 167;

double adjustScrollOffset({
  double extent = _kItemHeight,
  required double offset,
  required double remain,
  required double viewportDimension,
  bool isReversed = false,
}) {
  if (isReversed) {
    final total = offset + extent;
    if (total >= viewportDimension) {
      return total - viewportDimension;
    } else if (total < viewportDimension) {
      return 0.0;
    }
  }
  final total = remain + extent;
  if (total < viewportDimension) {
    return math.max(0.0, offset - viewportDimension + total);
  }
  return offset;
}

double calcItemHeight(ugc.BaseEpisodeItem episode) {
  if (episode is ugc.EpisodeItem && episode.pages!.length > 1) {
    return _kMultiItemHeight; // 110 + 2 + 10 + 45
  }
  return _kItemHeight;
}

(double height, double offset, double remain) calcItemOffset({
  required int index,
  required List<ugc.BaseEpisodeItem> episodes,
  bool isReversed = false,
  double topPadding = _kTopPadding,
  double bottomPadding = _kBottomPadding,
}) {
  double offset = 0;
  for (var i = 0; i < index; i++) {
    offset += calcItemHeight(episodes[i]);
  }
  final remain = (episodes.length - index - 1) * _kItemHeight /* min */;
  return (
    calcItemHeight(episodes[index]),
    offset + (isReversed ? bottomPadding : topPadding),
    remain + (isReversed ? topPadding : bottomPadding),
  );
}

(double offset, double remain) calcFixedItemOffset({
  required int index,
  required int itemCount,
  double extent = _kItemHeight,
  bool isReversed = false,
  double topPadding = _kTopPadding,
  double bottomPadding = _kBottomPadding,
}) {
  double offset = extent * index;
  final remain = (itemCount - index - 1) * extent;
  return (
    offset + (isReversed ? bottomPadding : topPadding),
    remain + (isReversed ? topPadding : bottomPadding),
  );
}

const double kPageItemExtent = 150;

double calcPageItemOffset({
  required int index,
  required int itemCount,
  double extent = kPageItemExtent,
  double itemExtent = kPageItemExtent,
  required double viewportDimension,
}) {
  if (index <= 0) return 0.0;
  final halfExtent = itemExtent / 2.0;
  final offset = math.max(0.0, index * itemExtent - halfExtent);
  final remain = (itemCount - index - 1) * extent;
  final total = remain + extent + halfExtent;
  if (total < viewportDimension) {
    return math.max(0.0, offset - viewportDimension + total);
  }
  return offset;
}

double calcPageItemOffsetSeparated({
  required int index,
  required int itemCount,
  required double extent,
  required double separator,
  double itemExtent = kPageItemExtent,
  required double viewportDimension,
}) {
  if (index <= 0) return 0.0;
  final totalExtent = extent + separator;
  final halfExtent = extent / 2.0;
  final offset = math.max(
    0.0,
    index * totalExtent - halfExtent,
  );
  final remain = (itemCount - index - 1) * totalExtent;
  final total = remain + extent + halfExtent;
  if (total < viewportDimension) {
    return math.max(0.0, offset - viewportDimension + total);
  }
  return offset;
}
