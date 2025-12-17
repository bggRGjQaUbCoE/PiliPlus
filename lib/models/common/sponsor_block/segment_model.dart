import 'package:PiliPlus/models/common/sponsor_block/segment_type.dart';
import 'package:PiliPlus/models/common/sponsor_block/skip_type.dart';
import 'package:PiliPlus/models_new/sponsor_block/segment_item.dart';
import 'package:PiliPlus/utils/storage_pref.dart';

class SegmentModel implements Comparable<SegmentModel> {
  static final blockLimit = Pref.blockLimit;
  static final blockSettings = Pref.blockSettings;
  static final enableList = blockSettings
      .where((item) => item.second != SkipType.disable)
      .map((item) => item.first.name)
      .toSet();

  SegmentModel({
    required this.uuid,
    required this.segmentType,
    required this.segment,
    required this.skipType,
  });
  final String uuid;
  final SegmentType segmentType;
  final (int, int) segment;
  final SkipType skipType;
  bool hasSkipped = false;

  factory SegmentModel.fromItemModel(
    SegmentItemModel model,
    bool isBlock,
  ) {
    final segmentType = SegmentType.values.byName(model.category);
    final segment = (model.segment[0], model.segment[1]);
    SkipType skipType;
    if (isBlock) {
      skipType = blockSettings[segmentType.index].second;
      if (skipType != SkipType.showOnly) {
        if (segment.isEq || segment.length < blockLimit) {
          skipType = SkipType.showOnly;
        }
      }
    } else {
      skipType = Pref.pgcSkipType;
    }

    return SegmentModel(
      uuid: model.uuid,
      segmentType: segmentType,
      segment: segment,
      skipType: skipType,
    );
  }

  @override
  int compareTo(SegmentModel other) => segment.$1.compareTo(other.segment.$1);
}

extension IntRecordExt on (int, int) {
  bool get isEq => $1 == $2;
  int get length => $2 - $1;
  bool contains(num other) => $1 <= other && other < $2;
}
