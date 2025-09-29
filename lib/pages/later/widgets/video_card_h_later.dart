import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/button/icon_button.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/progress_bar/video_progress_indicator.dart';
import 'package:PiliPlus/common/widgets/select_mask.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models/common/stat_type.dart';
import 'package:PiliPlus/models/search/result.dart';
import 'package:PiliPlus/models_new/later/list.dart';
import 'package:PiliPlus/pages/later/controller.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

// 视频卡片 - 水平布局
class VideoCardHLater extends StatelessWidget {
  const VideoCardHLater({
    super.key,
    required this.ctr,
    required this.index,
    required this.videoItem,
    required this.onViewLater,
  });
  final int index;
  final BaseLaterController ctr;
  final LaterItemModel videoItem;
  final ValueChanged<int> onViewLater;

  @override
  Widget build(BuildContext context) {
    String type = 'video';
    if (videoItem case SearchVideoItemModel item) {
      var typeOrNull = item.type;
      if (typeOrNull?.isNotEmpty == true) {
        type = typeOrNull!;
      }
    }
    final theme = Theme.of(context);
    final enableMultiSelect = ctr.enableMultiSelect.value;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onLongPress: enableMultiSelect
            ? null
            : () => ctr
                ..enableMultiSelect.value = true
                ..onSelect(videoItem),
        onTap: enableMultiSelect
            ? () => ctr.onSelect(videoItem)
            : () async {
                if (type == 'ketang') {
                  PageUtils.viewPugv(seasonId: videoItem.aid);
                  return;
                }
                if (videoItem.isPgc == true) {
                  if (videoItem.bangumi?.epId != null) {
                    PageUtils.viewPgc(epId: videoItem.bangumi!.epId);
                  } else if (videoItem.redirectUrl?.isNotEmpty == true) {
                    PageUtils.viewPgcFromUri(videoItem.redirectUrl!);
                  }
                  return;
                }
                try {
                  final int? cid =
                      videoItem.cid ??
                      await SearchHttp.ab2c(
                        aid: videoItem.aid,
                        bvid: videoItem.bvid,
                      );
                  if (cid != null) {
                    onViewLater(cid);
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
                    num? progress = videoItem.progress;
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        NetworkImgLayer(
                          src: videoItem.pic,
                          width: maxWidth,
                          height: maxHeight,
                        ),
                        if (videoItem.isCharging == true)
                          const PBadge(
                            text: '充电专属',
                            top: 6.0,
                            right: 6.0,
                            type: PBadgeType.error,
                          )
                        else if (videoItem.rights?.isCooperation == 1)
                          const PBadge(
                            text: '合作',
                            top: 6.0,
                            right: 6.0,
                          )
                        else if (videoItem.pgcLabel != null)
                          PBadge(
                            text: videoItem.pgcLabel,
                            top: 6.0,
                            right: 6.0,
                          )
                        else if (type == 'ketang')
                          const PBadge(
                            text: '课堂',
                            top: 6.0,
                            right: 6.0,
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
                                  : progress / videoItem.duration!,
                            ),
                          ),
                        ] else if (videoItem.duration! > 0)
                          PBadge(
                            text: DurationUtils.formatDuration(
                              videoItem.duration,
                            ),
                            right: 6.0,
                            bottom: 6.0,
                            type: PBadgeType.gray,
                          ),
                        Positioned.fill(
                          child: selectMask(
                            theme,
                            videoItem.checked == true,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              content(context, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget content(BuildContext context, ThemeData theme) {
    final isPgc = videoItem.isPgc == true && videoItem.bangumi != null;
    Widget stat = StatWidget(
      type: StatType.play,
      value: videoItem.stat?.view,
    );
    return Expanded(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: isPgc
                ? [
                    Text(
                      videoItem.bangumi!.season!.title!,
                      style: TextStyle(
                        fontSize: theme.textTheme.bodyMedium!.fontSize,
                        height: 1.42,
                        letterSpacing: 0.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      videoItem.subtitle!,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.outline,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    stat,
                  ]
                : [
                    Expanded(
                      child: Text(
                        videoItem.title!,
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
                      videoItem.owner!.name!,
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
                        stat,
                        StatWidget(
                          type: StatType.danmaku,
                          value: videoItem.stat?.danmaku,
                        ),
                      ],
                    ),
                  ],
          ),
          Positioned(
            right: 0,
            bottom: -8,
            child: iconButton(
              tooltip: '移除',
              context: context,
              onPressed: () => ctr.toViewDel(context, index, videoItem.aid),
              icon: Icons.clear,
              iconColor: theme.colorScheme.outline,
              bgColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
