import 'dart:io' show Platform;

import 'package:PiliPlus/common/widgets/motion/cover_motion.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/page_utils.dart';
// 视频or合集
import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/svg/play_icon.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:material_ui/material_ui.dart';

class VideoSeasonPanel extends StatefulWidget {
  const VideoSeasonPanel({
    super.key,
    required this.floor,
    required this.theme,
    required this.item,
    required this.isSave,
    required this.isDetail,
  });
  final int floor;
  final ThemeData theme;
  final DynamicItemModel item;
  final bool isSave;
  final bool isDetail;

  @override
  State<VideoSeasonPanel> createState() => _VideoSeasonPanelState();
}

class _VideoSeasonPanelState extends State<VideoSeasonPanel> {
  Object _coverTag = Object();
  ImageProvider? _coverImage;
  bool _opening = false;
  bool get _ordinary =>
      widget.item.type == 'DYNAMIC_TYPE_AV' &&
      widget.item.modules.moduleDynamic?.major?.archive?.type != 2;
  bool get _candidate =>
      _ordinary && !widget.isSave && Pref.coverPageTransition;

  @override
  void didUpdateWidget(VideoSeasonPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item != widget.item) {
      _coverTag = Object();
      _coverImage = null;
    }
  }

  Future<void> _open() async {
    if (!_candidate) return PageUtils.pushDynDetail(widget.item);
    if (_opening) return;
    _opening = true;
    final item = widget.item;
    try {
      await PageUtils.pushDynDetail(
        item,
        openVideo: (cid, dimension) async {
          if (!mounted ||
              !identical(item, widget.item) ||
              !ModalRoute.of(context)!.isCurrent) {
            return;
          }
          final width = dimension?.width, height = dimension?.height;
          final portraitAspectRatio = CoverTransitionData.portraitAspectRatio(
            width,
            height,
          );
          final motion =
              _candidate &&
                  width != null &&
                  height != null &&
                  width > 0 &&
                  height > 0 &&
                  (width > height || portraitAspectRatio != null) &&
                  _coverImage != null &&
                  !MediaQuery.disableAnimationsOf(context) &&
                  (PlPlayerController.instance?.videoController == null ||
                      Platform.isAndroid)
              ? CoverTransitionData(
                  tag: _coverTag,
                  image: _coverImage!,
                  radius: Style.mdRadius,
                  contentAspectRatio: portraitAspectRatio,
                )
              : null;
          final archive = item.modules.moduleDynamic!.major!.archive!;
          await PageUtils.toVideoPage(
            bvid: archive.bvid!,
            cid: cid,
            cover: archive.cover,
            title: archive.title,
            dimension: dimension,
            coverTransition: motion,
          );
        },
      );
    } finally {
      _opening = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item, theme = widget.theme;
    final floor = widget.floor, isDetail = widget.isDetail;
    // type archive  ugcSeason
    // archive 视频/显示发布人
    // ugcSeason 合集/不显示发布人

    DynamicArchiveModel? video = switch (item.type) {
      'DYNAMIC_TYPE_AV' => item.modules.moduleDynamic?.major?.archive,
      'DYNAMIC_TYPE_UGC_SEASON' => item.modules.moduleDynamic?.major?.ugcSeason,
      'DYNAMIC_TYPE_PGC' ||
      'DYNAMIC_TYPE_PGC_UNION' => item.modules.moduleDynamic?.major?.pgc,
      'DYNAMIC_TYPE_COURSES_SEASON' =>
        item.modules.moduleDynamic?.major?.courses,
      _ => null,
    };

    if (video == null) {
      return const SizedBox.shrink();
    }

    EdgeInsets padding;
    if (floor == 1) {
      padding = const EdgeInsets.symmetric(horizontal: 12);
    } else {
      padding = EdgeInsets.zero;
    }
    final content = Column(
      spacing: 6,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (video.cover case final cover?)
          Stack(
            clipBehavior: Clip.none,
            children: [
              LayoutBuilder(
                builder: (context, constraints) => HeroMode(
                  enabled:
                      _candidate && !MediaQuery.disableAnimationsOf(context),
                  child: Hero(
                    tag: _coverTag,
                    curve: CoverTransitionData.motionCurve,
                    reverseCurve: CoverTransitionData.motionCurve,
                    flightShuttleBuilder: CoverTransitionData.flight,
                    child: NetworkImgLayer(
                      width: constraints.maxWidth,
                      height: constraints.maxWidth / Style.aspectRatio,
                      src: cover,
                      quality: 40,
                      onImageReady: _candidate
                          ? (image) => _coverImage = image
                          : null,
                    ),
                  ),
                ),
              ),
              if (video.badge?.text case final badge?)
                PBadge(
                  text: badge,
                  top: 8.0,
                  right: 10.0,
                  bottom: null,
                  left: null,
                  type: switch (badge) {
                    '充电专属' => PBadgeType.error,
                    _ => PBadgeType.primary,
                  },
                ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 70,
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.fromLTRB(10, 0, 8, 8),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black54,
                      ],
                    ),
                    borderRadius: .vertical(bottom: Style.imgRadius),
                  ),
                  child: DefaultTextStyle.merge(
                    style: TextStyle(
                      fontSize: theme.textTheme.labelMedium!.fontSize,
                      color: Colors.white,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (video.durationText case final durationText?) ...[
                          DecoratedBox(
                            decoration: const BoxDecoration(
                              color: Colors.black45,
                              borderRadius: .all(.circular(4)),
                            ),
                            child: Text(' $durationText '),
                          ),
                          const SizedBox(width: 6),
                        ],
                        if (video.stat case final stat?) ...[
                          Text('${NumUtils.numFormat(stat.play)}播放'),
                          const SizedBox(width: 6),
                          Text('${NumUtils.numFormat(stat.danmu)}弹幕'),
                        ],
                        const Spacer(),
                        const PlayIcon(size: 50),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        if (video.title case final title?)
          Text(
            title,
            maxLines: isDetail ? null : 1,
            style: const TextStyle(fontWeight: FontWeight.bold),
            overflow: isDetail ? null : TextOverflow.ellipsis,
          ),
      ],
    );
    return Padding(
      padding: padding,
      child: _ordinary && !widget.isSave
          ? InkWell(onTap: _open, child: content)
          : content,
    );
  }
}
