import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/image/image_save.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/progress_bar/video_progress_indicator.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/common/widgets/video_popup_menu.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models/common/stat_type.dart';
import 'package:PiliPlus/models_new/space/space_archive/item.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

// 视频卡片 - 水平布局
class VideoCardHMemberVideo extends StatelessWidget {
  const VideoCardHMemberVideo({
    super.key,
    required this.videoItem,
    this.onTap,
    this.bvid,
    this.fromViewAid,
  });
  final SpaceArchiveItem videoItem;
  final VoidCallback? onTap;
  final dynamic bvid;
  final String? fromViewAid;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          InkWell(
            onLongPress: () => imageSaveDialog(
              title: videoItem.title,
              cover: videoItem.cover,
              bvid: videoItem.bvid,
            ),
            onTap:
                onTap ??
                () async {
                  final isPgc = videoItem.isPgc == true;
                  final isPugv = videoItem.isPugv == true;
                  if ((isPgc || isPugv) && videoItem.uri?.isNotEmpty == true) {
                    if (PageUtils.viewPgcFromUri(
                      videoItem.uri!,
                      isPgc: isPgc,
                    )) {
                      return;
                    }
                  }
                  if (videoItem.bvid == null || videoItem.cid == null) {
                    return;
                  }
                  try {
                    PageUtils.toVideoPage(
                      bvid: videoItem.bvid,
                      cid: videoItem.cid!,
                      cover: videoItem.cover,
                      title: videoItem.title,
                    );
                  } catch (err) {
                    SmartDialog.showToast(err.toString());
                  }
                },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: StyleString.safeSpace,
                vertical: 5,
              ),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints boxConstraints) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: StyleString.aspectRatio,
                        child: LayoutBuilder(
                          builder:
                              (
                                BuildContext context,
                                BoxConstraints boxConstraints,
                              ) {
                                final double maxWidth = boxConstraints.maxWidth;
                                final double maxHeight =
                                    boxConstraints.maxHeight;
                                return Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    NetworkImgLayer(
                                      src: videoItem.cover,
                                      width: maxWidth,
                                      height: maxHeight,
                                    ),
                                    if (fromViewAid == videoItem.param)
                                      const Positioned.fill(
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            borderRadius: StyleString.mdRadius,
                                            color: Colors.black54,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '上次观看',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                letterSpacing: 5,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (videoItem.badges?.isNotEmpty == true)
                                      PBadge(
                                        text: videoItem.badges!
                                            .map((item) => item.text)
                                            .join('|'),
                                        right: 6.0,
                                        top: 6.0,
                                        type:
                                            videoItem.badges!.first.text ==
                                                '充电专属'
                                            ? PBadgeType.error
                                            : PBadgeType.primary,
                                      ),
                                    if (videoItem.history != null) ...[
                                      Builder(
                                        builder: (context) {
                                          try {
                                            return Positioned(
                                              left: 0,
                                              right: 0,
                                              bottom: 0,
                                              child: videoProgressIndicator(
                                                videoItem.history!.progress! /
                                                    videoItem
                                                        .history!
                                                        .duration!,
                                              ),
                                            );
                                          } catch (_) {
                                            return const SizedBox.shrink();
                                          }
                                        },
                                      ),
                                      Builder(
                                        builder: (context) {
                                          try {
                                            return PBadge(
                                              text:
                                                  videoItem.history!.progress ==
                                                      videoItem
                                                          .history!
                                                          .duration
                                                  ? '已看完'
                                                  : '${DurationUtils.formatDuration(videoItem.history!.progress)}/${DurationUtils.formatDuration(videoItem.history!.duration)}',
                                              right: 6.0,
                                              bottom: 6.0,
                                              type: PBadgeType.gray,
                                            );
                                          } catch (_) {
                                            return PBadge(
                                              text:
                                                  DurationUtils.formatDuration(
                                                    videoItem.duration,
                                                  ),
                                              right: 6.0,
                                              bottom: 6.0,
                                              type: PBadgeType.gray,
                                            );
                                          }
                                        },
                                      ),
                                    ] else if (videoItem.duration > 0)
                                      PBadge(
                                        text: DurationUtils.formatDuration(
                                          videoItem.duration,
                                        ),
                                        right: 6.0,
                                        bottom: 6.0,
                                        type: PBadgeType.gray,
                                      ),
                                  ],
                                );
                              },
                        ),
                      ),
                      const SizedBox(width: 10),
                      content(context, theme),
                    ],
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 12,
            child: VideoPopupMenu(
              size: 29,
              iconSize: 17,
              videoItem: videoItem,
            ),
          ),
        ],
      ),
    );
  }

  Widget content(BuildContext context, ThemeData theme) {
    final isCurr =
        fromViewAid == videoItem.param ||
        (videoItem.bvid != null && videoItem.bvid == bvid);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              videoItem.title,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: isCurr ? FontWeight.bold : null,
                fontSize: theme.textTheme.bodyMedium!.fontSize,
                height: 1.42,
                letterSpacing: 0.3,
                color: isCurr ? theme.colorScheme.primary : null,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            videoItem.season != null
                ? DateFormatUtils.dateFormat(videoItem.season!.mtime)
                : videoItem.publishTimeText ?? '',
            maxLines: 1,
            style: TextStyle(
              fontSize: 12,
              height: 1,
              color: theme.colorScheme.outline,
              overflow: TextOverflow.clip,
            ),
          ),
          const SizedBox(height: 3),
          Row(
            spacing: 8,
            children: [
              StatWidget(
                type: StatType.play,
                value: videoItem.stat.view,
              ),
              StatWidget(
                type: StatType.danmaku,
                value: videoItem.stat.danmu,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
