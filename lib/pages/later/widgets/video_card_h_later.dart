import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/progress_bar/video_progress_indicator.dart';
import 'package:PiliPlus/common/widgets/select_mask.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/models_new/later/list.dart';
import 'package:PiliPlus/pages/later/controller.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
    final theme = Theme.of(context);
    final enableMultiSelect = ctr.enableMultiSelect.value;

    final onLongPress = enableMultiSelect
        ? null
        : () => ctr
            ..enableMultiSelect.value = true
            ..onSelect(videoItem);

    return Material(
      type: .transparency,
      child: InkWell(
        onLongPress: onLongPress,
        onSecondaryTap: PlatformUtils.isMobile ? null : onLongPress,
        onTap: enableMultiSelect
            ? () => ctr.onSelect(videoItem)
            : () async {
                if (videoItem.isPugv ?? false) {
                  PageUtils.viewPugv(seasonId: videoItem.aid);
                  return;
                }
                if (videoItem.isPgc ?? false) {
                  if (videoItem.bangumi?.epId != null) {
                    PageUtils.viewPgc(epId: videoItem.bangumi!.epId);
                  } else if (videoItem.redirectUrl?.isNotEmpty == true) {
                    PageUtils.viewPgcFromUri(videoItem.redirectUrl!);
                  }
                  return;
                }
                try {
                  final cid =
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
                    num? progress = videoItem.progress;
                    return Stack(
                      clipBehavior: .none,
                      children: [
                        NetworkImgLayer(
                          src: videoItem.pic,
                          width: maxWidth,
                          height: maxHeight,
                          cacheWidthBool: videoItem.dimension?.cacheWidth,
                        ),
                        if (videoItem.isCharging == true)
                          const PBadge(
                            text: '充电专属',
                            top: 6.0,
                            right: 6.0,
                            type: .error,
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
                        else if (videoItem.isPugv ?? false)
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
                            type: .gray,
                          ),
                        Positioned.fill(
                          child: selectMask(
                            theme.colorScheme,
                            videoItem.checked,
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
      type: .play,
      value: videoItem.stat?.view,
    );
    return Expanded(
      child: Stack(
        clipBehavior: .none,
        children: [
          Column(
            crossAxisAlignment: .start,
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
                      overflow: .ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      videoItem.subtitle!,
                      textAlign: .start,
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.outline,
                      ),
                      maxLines: 2,
                      overflow: .ellipsis,
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
                        overflow: .ellipsis,
                      ),
                    ),
                    Text(
                      videoItem.owner!.name!,
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
                        stat,
                        StatWidget(
                          type: .danmaku,
                          value: videoItem.stat?.danmaku,
                        ),
                      ],
                    ),
                  ],
          ),
          Positioned(
            right: 0,
            bottom: -8,
            width: 29,
            height: 29,
            child: PopupMenuButton(
              padding: .zero,
              tooltip: '功能菜单',
              icon: Icon(
                Icons.more_vert_outlined,
                color: theme.colorScheme.outline,
                size: 18,
              ),
              position: .under,
              itemBuilder: (_) => [
                PopupMenuItem(
                  onTap: () =>
                      Get.toNamed('/member?mid=${videoItem.owner?.mid}'),
                  height: 38,
                  child: Row(
                    children: [
                      const Icon(MdiIcons.accountCircleOutline, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        '访问：${videoItem.owner?.name}',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  onTap: () => ctr.toViewDel(context, index, videoItem.aid),
                  height: 38,
                  child: const Row(
                    children: [
                      Icon(Icons.close_outlined, size: 16),
                      SizedBox(width: 6),
                      Text('移除', style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
