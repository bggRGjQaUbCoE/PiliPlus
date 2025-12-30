import 'dart:async';

import 'package:PiliPlus/models/common/sponsor_block/segment_model.dart';
import 'package:PiliPlus/models/common/sponsor_block/skip_type.dart';

typedef SponsorBlockSkipCallback = FutureOr<void> Function(SegmentModel item);
typedef SponsorBlockManualCallback = void Function(SegmentModel item);

class SponsorBlockAutoSkipper {
  SponsorBlockAutoSkipper({
    required List<SegmentModel> Function() segments,
    required SponsorBlockSkipCallback onSkip,
    SponsorBlockManualCallback? onManual,
  })  : _segments = segments,
        _onSkip = onSkip,
        _onManual = onManual;

  final List<SegmentModel> Function() _segments;
  final SponsorBlockSkipCallback _onSkip;
  final SponsorBlockManualCallback? _onManual;

  void handlePosition(int msPos, {bool isInit = false}) {
    final segments = _segments();
    if (segments.isEmpty) return;
    for (final item in segments) {
      final shouldSkip = isInit
          ? (msPos >= item.segment.first && msPos < item.segment.second)
          : (msPos <= item.segment.first &&
              item.segment.first <= msPos + 1000);
      if (!shouldSkip) {
        continue;
      }
      switch (item.skipType) {
        case SkipType.alwaysSkip:
          _onSkip(item);
          break;
        case SkipType.skipOnce:
          if (!item.hasSkipped) {
            item.hasSkipped = true;
            _onSkip(item);
          }
          break;
        case SkipType.skipManually:
          _onManual?.call(item);
          break;
        case SkipType.showOnly:
        case SkipType.disable:
          break;
      }
      break;
    }
  }
}
