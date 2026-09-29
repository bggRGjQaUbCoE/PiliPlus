import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/models/model_video.dart';
import 'package:PiliPlus/models_new/video/video_detail/dimension.dart';

abstract class HorizontalVideoModel extends BaseVideoItemModel {
  bool? isPugv;
  int? seasonId;

  int? roomId;
  bool? isLive;

  Dimension? dimension;

  String? badge;

  String? get badgeLabel => switch (badge) {
    '课堂' => L10n.current.badgeCourse,
    '充电专属' => L10n.current.badgeChargingExclusive,
    '直播' => L10n.current.live,
    '合作' => L10n.current.badgeCollaboration,
    _ => badge,
  };

  num? progress;

  String? redirectUrl;

  // search
  List<({bool isEm, String text})>? titleList;
}
