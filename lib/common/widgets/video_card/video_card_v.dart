import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/motion/cover_motion.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/video_fit_type.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/image/image_save.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/common/widgets/video_popup_menu.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/models/home/rcmd/result.dart';
import 'package:PiliPlus/models/model_rec_video_item.dart';
import 'package:PiliPlus/models_new/video/video_detail/dimension.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/extension/dimension_ext.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

// 视频卡片 - 垂直布局
class VideoCardV extends StatefulWidget {
  final BaseRcmdVideoItemModel videoItem;
  final VoidCallback? onRemove;
  final bool coverMotion;

  const VideoCardV({
    super.key,
    required this.videoItem,
    this.onRemove,
    this.coverMotion = false,
  });

  static final shortFormat = DateFormat('M-d');
  static final longFormat = DateFormat('yy-M-d');

  @override
  State<VideoCardV> createState() => _VideoCardVState();
}

class _VideoCardVState extends State<VideoCardV> {
  BaseRcmdVideoItemModel get videoItem => widget.videoItem;
  VoidCallback? get onRemove => widget.onRemove;
  Object _coverTag = Object();
  ImageProvider? _coverImage;
  bool _opening = false;
  double? get _videoAspectRatio {
    if (videoItem.uri case final uri?) {
      final params = Uri.tryParse(uri)?.queryParameters;
      final width = int.tryParse(params?['player_width'] ?? '');
      final height = int.tryParse(params?['player_height'] ?? '');
      final rotate = int.tryParse(params?['player_rotate'] ?? '');
      if (width == null ||
          height == null ||
          width <= 0 ||
          height <= 0 ||
          rotate == null ||
          rotate < 0 ||
          rotate > 1) {
        return null;
      }
      return rotate == 1 ? height / width : width / height;
    }
    return null;
  }

  bool get _candidate {
    if (!widget.coverMotion ||
        !Pref.coverPageTransition ||
        videoItem.goto != 'av' ||
        videoItem.cid == null ||
        videoItem is! RcmdVideoItemAppModel ||
        videoItem.uri == null) {
      return false;
    }
    final aspectRatio = _videoAspectRatio;
    if (aspectRatio == null || aspectRatio == 1) return false;
    if (aspectRatio > 1) return true;
    final fit = VideoFitType.values[Pref.cacheVideoFit];
    return fit == VideoFitType.fill || fit == VideoFitType.contain;
  }

  @override
  void didUpdateWidget(VideoCardV oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoItem != videoItem) {
      _coverTag = Object();
      _coverImage = null;
    }
  }

  void _onCoverImageReady(ImageProvider image) {
    if (_coverImage == image) return;
    setState(() => _coverImage = image);
  }

  Future<void> onPushDetail() async {
    switch (videoItem.goto) {
      case 'bangumi':
        PageUtils.viewPgc(epId: videoItem.param!);
        break;
      case 'av':
        if ((widget.coverMotion ? Scrollable.maybeOf(context)?.position : null)
            case final ScrollPositionWithSingleContext position
            when position.isScrollingNotifier.value && !position.outOfRange) {
          position.goIdle();
        }
        var bvid = videoItem.bvid ?? IdUtils.av2bv(videoItem.aid!);
        var cid = videoItem.cid;
        bool isVertical = false;
        Dimension? dimension;
        if (videoItem is RcmdVideoItemAppModel) {
          if (videoItem.uri case final uri?) {
            isVertical = uri.isVerticalFromUri;
          }
        }
        if (cid == null) {
          if (await SearchHttp.ab2cWithDimension(aid: videoItem.aid, bvid: bvid)
              case final res?) {
            cid = res.cid;
            dimension = res.dimension;
          }
        }
        if (dimension == null && videoItem is RcmdVideoItemAppModel) {
          final params = Uri.tryParse(videoItem.uri ?? '')?.queryParameters;
          final width = int.tryParse(params?['player_width'] ?? '');
          final height = int.tryParse(params?['player_height'] ?? '');
          final rotate = int.tryParse(params?['player_rotate'] ?? '');
          if (params != null &&
              width != null &&
              height != null &&
              width > 0 &&
              height > 0 &&
              (rotate == 0 || rotate == 1)) {
            dimension = Dimension.fromJson({
              'width': width,
              'height': height,
              'rotate': rotate,
            });
          }
        }
        if (!mounted) return;
        if (cid != null) {
          final motion =
              _candidate &&
                  _coverImage != null &&
                  !MediaQuery.disableAnimationsOf(context) &&
                  PlPlayerController.instance?.videoController == null
              ? CoverTransitionData(
                  tag: _coverTag,
                  image: _coverImage!,
                  radius: const BorderRadius.vertical(top: Radius.circular(12)),
                  contentAspectRatio: _videoAspectRatio! < 1
                      ? _videoAspectRatio
                      : null,
                )
              : null;
          if (motion != null && _opening) return;
          if (motion != null) _opening = true;
          try {
            await PageUtils.toVideoPage(
              coverTransition: motion,
              aid: videoItem.aid,
              bvid: bvid,
              cid: cid,
              cover: videoItem.cover,
              title: videoItem.title,
              isVertical: isVertical,
              dimension: dimension,
            );
          } finally {
            _opening = false;
          }
        }
        break;
      // 动态
      case 'picture':
        try {
          PiliScheme.routePushFromUrl(videoItem.uri!);
        } catch (err) {
          SmartDialog.showToast(err.toString());
        }
        break;
      default:
        if (videoItem.uri?.isNotEmpty == true) {
          PiliScheme.routePushFromUrl(videoItem.uri!);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final coverImage = _coverImage;
    void onLongPress() => imageSaveDialog(
      title: videoItem.title,
      cover: videoItem.cover,
      bvid: videoItem.bvid,
    );
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Card(
          child: InkWell(
            onTap: onPushDetail,
            onLongPress: onLongPress,
            onSecondaryTap: PlatformUtils.isMobile ? null : onLongPress,
            borderRadius: const .all(.circular(12)),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                AspectRatio(
                  aspectRatio: Style.aspectRatio,
                  child: LayoutBuilder(
                    builder: (context, boxConstraints) {
                      double maxWidth = boxConstraints.maxWidth;
                      double maxHeight = boxConstraints.maxHeight;
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          HeroMode(
                            enabled:
                                _candidate &&
                                !MediaQuery.disableAnimationsOf(context),
                            child: Hero(
                              tag: _coverTag,
                              curve: CoverTransitionData.motionCurve,
                              reverseCurve: CoverTransitionData.motionCurve,
                              flightShuttleBuilder: CoverTransitionData.flight,
                              child: NetworkImgLayer(
                                onImageReady: widget.coverMotion
                                    ? _onCoverImageReady
                                    : null,
                                getPlaceHolder: coverImage == null
                                    ? null
                                    : () => Image(
                                        image: coverImage,
                                        width: maxWidth,
                                        height: maxHeight,
                                        fit: BoxFit.cover,
                                        alignment: Alignment.center,
                                        gaplessPlayback: true,
                                        filterQuality: FilterQuality.low,
                                        colorBlendMode: NetworkImgLayer.reduce
                                            ? BlendMode.modulate
                                            : null,
                                        color: NetworkImgLayer.reduce
                                            ? NetworkImgLayer.reduceLuxColor
                                            : null,
                                      ),
                                src: videoItem.cover,
                                width: maxWidth,
                                height: maxHeight,
                                borderRadius: const .vertical(
                                  top: .circular(12),
                                ),
                              ),
                            ),
                          ),
                          if (videoItem.duration > 0)
                            PBadge(
                              bottom: 6,
                              right: 7,
                              size: .small,
                              type: .gray,
                              text: DurationUtils.formatDuration(
                                videoItem.duration,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
                content(context),
              ],
            ),
          ),
        ),
        if (videoItem.goto == 'av')
          Positioned(
            right: -5,
            bottom: -2,
            width: 29,
            height: 29,
            child: VideoPopupMenu(
              iconSize: 17,
              videoItem: videoItem,
              onRemove: onRemove,
            ),
          ),
      ],
    );
  }

  Widget content(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Padding(
        padding: const .fromLTRB(6, 5, 6, 5),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Expanded(
              child: Text(
                videoItem.title,
                maxLines: 2,
                overflow: .ellipsis,
                style: const TextStyle(height: 1.38),
              ),
            ),
            videoStat(theme),
            Row(
              spacing: 2,
              children: [
                if (videoItem.goto == 'bangumi')
                  PBadge(
                    text: videoItem.pgcBadge,
                    isStack: false,
                    size: .small,
                    type: .line_primary,
                    fontSize: 9,
                  ),
                if (videoItem.rcmdReason != null)
                  PBadge(
                    text: videoItem.rcmdReason,
                    isStack: false,
                    size: .small,
                    type: .secondary,
                  ),
                if (videoItem.goto == 'picture')
                  const PBadge(
                    text: '动态',
                    isStack: false,
                    size: .small,
                    type: .line_primary,
                    fontSize: 9,
                  ),
                if (videoItem.isFollowed)
                  const PBadge(
                    text: '已关注',
                    isStack: false,
                    size: .small,
                    type: .secondary,
                  ),
                Expanded(
                  flex: 1,
                  child: Text(
                    videoItem.owner.name.toString(),
                    maxLines: 1,
                    overflow: .ellipsis,
                    semanticsLabel: 'UP：${videoItem.owner.name}',
                    style: TextStyle(
                      height: 1.5,
                      fontSize: theme.textTheme.labelMedium!.fontSize,
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ),
                if (videoItem.goto == 'av') const SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget videoStat(ThemeData theme) {
    return Row(
      children: [
        StatWidget(
          type: .play,
          value: videoItem.stat.view,
        ),
        if (videoItem.goto != 'picture') ...[
          const SizedBox(width: 4),
          StatWidget(
            type: .danmaku,
            value: videoItem.stat.danmu,
          ),
        ],
        if (videoItem is RcmdVideoItemModel) ...[
          const Spacer(),
          Text.rich(
            maxLines: 1,
            TextSpan(
              style: TextStyle(
                fontSize: theme.textTheme.labelSmall!.fontSize,
                color: theme.colorScheme.outline.withValues(alpha: 0.8),
              ),
              text: DateFormatUtils.dateFormat(
                videoItem.pubdate,
                short: VideoCardV.shortFormat,
                long: VideoCardV.longFormat,
              ),
            ),
          ),
          const SizedBox(width: 2),
        ],
      ],
    );
  }
}
