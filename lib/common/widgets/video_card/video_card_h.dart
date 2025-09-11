import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/image/image_save.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/progress_bar/video_progress_indicator.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/common/widgets/video_popup_menu.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models/common/stat_type.dart';
import 'package:PiliPlus/models/model_hot_video_item.dart';
import 'package:PiliPlus/models/model_video.dart';
import 'package:PiliPlus/models/search/result.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

// 视频卡片 - 水平布局
class VideoCardH extends StatelessWidget {
  const VideoCardH({
    super.key,
    required this.videoItem,
    this.onTap,
    this.onLongPress,
    this.onViewLater,
    this.onRemove,
  });
  final BaseVideoItemModel videoItem;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final ValueChanged<int>? onViewLater;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    String type = 'video';
    String? badge;
    if (videoItem case SearchVideoItemModel item) {
      var typeOrNull = item.type;
      if (typeOrNull?.isNotEmpty == true) {
        type = typeOrNull!;
        if (type == 'ketang') {
          badge = '课堂';
        } else if (type == 'live_room') {
          badge = '直播';
        }
      }
      if (item.isUnionVideo == 1) {
        badge = '合作';
      }
    } else if (videoItem case HotVideoItemModel item) {
      if (item.isCharging == true) {
        badge = '充电专属';
      } else if (item.isCooperation == 1) {
        badge = '合作';
      } else {
        badge = item.pgcLabel;
      }
    }
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          InkWell(
            onLongPress:
                onLongPress ??
                () => imageSaveDialog(
                  bvid: videoItem.bvid,
                  title: videoItem.title,
                  cover: videoItem.cover,
                ),
            onTap:
                onTap ??
                () async {
                  if (type == 'ketang') {
                    PageUtils.viewPugv(seasonId: videoItem.aid);
                    return;
                  } else if (type == 'live_room') {
                    if (videoItem case SearchVideoItemModel item) {
                      int? roomId = item.id;
                      if (roomId != null) {
                        PageUtils.toLiveRoom(roomId);
                      }
                    } else {
                      SmartDialog.showToast(
                        'err: live_room : ${videoItem.runtimeType}',
                      );
                    }
                    return;
                  }
                  if (videoItem case HotVideoItemModel item) {
                    if (item.redirectUrl?.isNotEmpty == true &&
                        PageUtils.viewPgcFromUri(item.redirectUrl!)) {
                      return;
                    }
                  }

                  try {
                    final int? cid =
                        videoItem.cid ??
                        await SearchHttp.ab2c(
                          aid: videoItem.aid,
                          bvid: videoItem.bvid,
                        );
                    if (cid != null) {
                      PageUtils.toVideoPage(
                        bvid: videoItem.bvid,
                        cid: cid,
                        cover: videoItem.cover,
                        title: videoItem.title,
                      );
                    }
                  } catch (err) {
                    SmartDialog.showToast(err.toString());
                  }
                },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: StyleString.safeSpace,
                vertical: 5,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: StyleString.aspectRatio,
                    child: LayoutBuilder(
                      builder: (context, boxConstraints) {
                        final double maxWidth = boxConstraints.maxWidth;
                        final double maxHeight = boxConstraints.maxHeight;
                        num? progress;
                        if (videoItem case HotVideoItemModel item) {
                          progress = item.progress;
                        }

                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            NetworkImgLayer(
                              src: videoItem.cover,
                              width: maxWidth,
                              height: maxHeight,
                            ),
                            if (badge != null)
                              PBadge(
                                text: badge,
                                top: 6.0,
                                right: 6.0,
                                type: switch (badge) {
                                  '充电专属' => PBadgeType.error,
                                  _ => PBadgeType.primary,
                                },
                              ),
                            if (progress != null && progress != 0) ...[
                              PBadge(
                                text: progress == -1
                                    ? '已看完'
                                    : '${DurationUtils.formatDuration(progress)}/${DurationUtils.formatDuration(videoItem.duration)}',
                                right: 6,
                                bottom: 8,
                                type: PBadgeType.gray,
                              ),
                              Positioned(
                                left: 0,
                                bottom: 0,
                                right: 0,
                                child: videoProgressIndicator(
                                  progress == -1
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
                                type: PBadgeType.gray,
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  content(context),
                ],
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
              onRemove: onRemove,
            ),
          ),
        ],
      ),
    );
  }

  Widget content(BuildContext context) {
    final theme = Theme.of(context);
    String pubdate = DateFormatUtils.dateFormat(videoItem.pubdate!);
    if (pubdate != '') pubdate += '  ';
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (videoItem case SearchVideoItemModel item) ...[
            if (item.titleList?.isNotEmpty == true)
              Expanded(
                child: Text.rich(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  TextSpan(
                    children: item.titleList!
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
              ),
          ] else
            Expanded(
              child: Text(
                videoItem.title,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: theme.textTheme.bodyMedium!.fontSize,
                  height: 1.42,
                  letterSpacing: 0.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          Text(
            "$pubdate${videoItem.owner.name}",
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
