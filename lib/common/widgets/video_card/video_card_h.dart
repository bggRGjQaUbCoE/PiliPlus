import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/flutter/layout_builder.dart';
import 'package:PiliPlus/common/widgets/image/image_save.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/progress_bar/video_progress_indicator.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/common/widgets/video_popup_menu.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/models/horizontal_video_model.dart';
import 'package:PiliPlus/models_new/video/video_detail/dimension.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:flutter/material.dart' hide LayoutBuilder;

// 视频卡片 - 水平布局
class VideoCardH extends StatelessWidget {
  const VideoCardH({
    super.key,
    required this.videoItem,
    this.onTap,
    this.onViewLater,
    this.onRemove,
  });
  final HorizontalVideoModel videoItem;
  final VoidCallback? onTap;
  final ValueChanged<int>? onViewLater;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    void onLongPress() => imageSaveDialog(
      bvid: videoItem.bvid,
      title: videoItem.title,
      cover: videoItem.cover,
    );
    final theme = Theme.of(context);
    return Material(
      type: .transparency,
      child: Stack(
        clipBehavior: .none,
        children: [
          InkWell(
            onLongPress: onLongPress,
            onSecondaryTap: PlatformUtils.isMobile ? null : onLongPress,
            onTap:
                onTap ??
                () async {
                  if (videoItem.isPugv ?? false) {
                    PageUtils.viewPugv(seasonId: videoItem.seasonId);
                    return;
                  }

                  if (videoItem.isLive ?? false) {
                    if (videoItem.roomId case final roomId?) {
                      PageUtils.toLiveRoom(roomId);
                    }
                    return;
                  }

                  if (videoItem.redirectUrl?.isNotEmpty == true &&
                      PageUtils.viewPgcFromUri(videoItem.redirectUrl!)) {
                    return;
                  }

                  int? cid = videoItem.cid;
                  Dimension? dimension = videoItem.dimension;
                  if (cid == null) {
                    if (await SearchHttp.ab2cWithDimension(
                          aid: videoItem.aid,
                          bvid: videoItem.bvid,
                        )
                        case final res?) {
                      cid = res.cid;
                      dimension = res.dimension;
                    }
                  }
                  if (cid != null) {
                    PageUtils.toVideoPage(
                      bvid: videoItem.bvid,
                      cid: cid,
                      cover: videoItem.cover,
                      title: videoItem.title,
                      dimension: dimension,
                    );
                  }
                },
            child: Padding(
              padding: const .symmetric(
                horizontal: Style.safeSpace,
                vertical: 5,
              ),
              child: Row(
                crossAxisAlignment: .start,
                children: [
                  AspectRatio(
                    aspectRatio: Style.aspectRatio,
                    child: LayoutBuilder(
                      builder: (context, boxConstraints) {
                        final double maxWidth = boxConstraints.maxWidth;
                        final double maxHeight = boxConstraints.maxHeight;

                        final progress = videoItem.progress;

                        return Stack(
                          clipBehavior: .none,
                          children: [
                            NetworkImgLayer(
                              src: videoItem.cover,
                              width: maxWidth,
                              height: maxHeight,
                            ),
                            if (videoItem.badge case final badge?)
                              PBadge(
                                text: badge,
                                top: 6.0,
                                right: 6.0,
                                type: switch (badge) {
                                  '充电专属' => .error,
                                  _ => .primary,
                                },
                              ),
                            if (progress != null && progress != 0) ...[
                              PBadge(
                                text: progress == -1
                                    ? '已看完'
                                    : '${DurationUtils.formatDuration(progress)}/${DurationUtils.formatDuration(videoItem.duration)}',
                                right: 6,
                                bottom: 8,
                                type: .gray,
                              ),
                              Positioned(
                                left: 0,
                                bottom: 0,
                                right: 0,
                                child: VideoProgressIndicator(
                                  color: theme.colorScheme.primary,
                                  backgroundColor:
                                      theme.colorScheme.secondaryContainer,
                                  progress: progress == -1
                                      ? 1
                                      : progress / videoItem.duration,
                                ),
                              ),
                            ] else if (videoItem.duration > 0)
                              PBadge(
                                text: DurationUtils.formatDuration(
                                  videoItem.duration,
                                ),
                                right: 6.0,
                                bottom: 6.0,
                                type: .gray,
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  content(theme),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 12,
            width: 29,
            height: 29,
            child: VideoPopupMenu(
              iconSize: 17,
              videoItem: videoItem,
              onRemove: onRemove,
            ),
          ),
        ],
      ),
    );
  }

  Widget content(ThemeData theme) {
    String pubdate = DateFormatUtils.dateFormat(videoItem.pubdate!);
    if (pubdate != '') pubdate += '  ';
    return Expanded(
      child: Column(
        crossAxisAlignment: .start,
        children: [
          if (videoItem.titleList?.isNotEmpty == true)
            Expanded(
              child: Text.rich(
                overflow: .ellipsis,
                maxLines: 2,
                TextSpan(
                  children: videoItem.titleList!
                      .map(
                        (e) => TextSpan(
                          text: e.text,
                          style: TextStyle(
                            fontSize: theme.textTheme.bodyMedium!.fontSize,
                            height: 1.42,
                            letterSpacing: 0.3,
                            color: e.isEm
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            )
          else
            Expanded(
              child: Text(
                videoItem.title,
                textAlign: .start,
                style: TextStyle(
                  fontSize: theme.textTheme.bodyMedium!.fontSize,
                  height: 1.42,
                  letterSpacing: 0.3,
                ),
                maxLines: 2,
                overflow: .ellipsis,
              ),
            ),
          Text(
            "$pubdate${videoItem.owner.name}",
            maxLines: 1,
            style: TextStyle(
              fontSize: 12,
              height: 1,
              color: theme.colorScheme.outline,
              overflow: .clip,
            ),
          ),
          const SizedBox(height: 3),
          Row(
            spacing: 8,
            children: [
              StatWidget(
                type: .play,
                value: videoItem.stat.view,
              ),
              StatWidget(
                type: .danmaku,
                value: videoItem.stat.danmu,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
