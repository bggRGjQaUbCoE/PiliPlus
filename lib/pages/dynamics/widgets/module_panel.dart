import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/dyn/ink_well.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/dynamics/widgets/forward_panel.dart';
import 'package:PiliPlus/pages/dynamics/widgets/live_panel.dart';
import 'package:PiliPlus/pages/dynamics/widgets/live_panel_sub.dart';
import 'package:PiliPlus/pages/dynamics/widgets/live_rcmd_panel.dart';
import 'package:PiliPlus/pages/dynamics/widgets/video_panel.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide InkWell;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget noneWidget(ThemeData theme, String? tips) => Row(
  spacing: 5,
  children: [
    Icon(
      Icons.error,
      size: 18,
      color: theme.colorScheme.outline,
    ),
    Text(
      tips ?? '已失效',
      style: TextStyle(color: theme.colorScheme.outline),
    ),
  ],
);

Widget module(
  BuildContext context, {
  required int floor,
  required ThemeData theme,
  required DynamicItemModel item,
  required bool isSave,
  required bool isDetail,
  required double maxWidth,
}) {
  final moduleDynamic = item.modules.moduleDynamic;
  final major = moduleDynamic?.major;

  if (major?.type == 'MAJOR_TYPE_NONE') {
    return noneWidget(theme, major?.none?.tips);
  }

  switch (item.type) {
    case 'DYNAMIC_TYPE_NONE':
      return Row(
        spacing: 4,
        children: [
          const Icon(FontAwesomeIcons.ghost, size: 14),
          Text(major!.none!.tips!),
        ],
      );
    // 图文
    case 'DYNAMIC_TYPE_DRAW':
    // 文章
    case 'DYNAMIC_TYPE_ARTICLE':
    case 'DYNAMIC_TYPE_WORD':
      return const SizedBox.shrink();
    // 视频
    case 'DYNAMIC_TYPE_AV':
    case 'DYNAMIC_TYPE_UGC_SEASON':
    case 'DYNAMIC_TYPE_PGC':
    case 'DYNAMIC_TYPE_PGC_UNION':
    case 'DYNAMIC_TYPE_COURSES_SEASON':
      return videoSeasonWidget(
        context,
        theme: theme,
        item: item,
        floor: floor,
        isSave: isSave,
        isDetail: isDetail,
        maxWidth: maxWidth,
      );
    // 转发
    case 'DYNAMIC_TYPE_FORWARD':
      return forwardPanel(
        context,
        theme: theme,
        isSave: isSave,
        orig: item.orig!,
        isDetail: isDetail,
        floor: floor + 1,
        maxWidth: maxWidth,
      );
    // 直播
    case 'DYNAMIC_TYPE_LIVE_RCMD':
      return liveRcmdPanel(
        context,
        theme: theme,
        isDetail: isDetail,
        item: item,
        floor: floor,
        maxWidth: maxWidth,
      );
    // 直播
    case 'DYNAMIC_TYPE_LIVE':
      return livePanel(
        context,
        theme: theme,
        item: item,
        floor: floor,
        isDetail: isDetail,
        maxWidth: maxWidth,
      );
    // 活动
    case 'DYNAMIC_TYPE_COMMON_SQUARE':
      return Material(
        color: floor == 1
            ? theme.dividerColor.withValues(alpha: 0.08)
            : theme.colorScheme.surface,
        shape: floor == 1
            ? null
            : const RoundedRectangleBorder(borderRadius: StyleString.mdRadius),
        child: InkWell(
          borderRadius: floor == 1 ? null : StyleString.mdRadius,
          onTap: () {
            try {
              String url = major.common!.jumpUrl!;
              if (url.contains('bangumi/play') &&
                  PageUtils.viewPgcFromUri(url)) {
                return;
              }
              PageUtils.handleWebview(url, inApp: true);
            } catch (_) {}
          },
          child: Padding(
            padding: const EdgeInsets.only(
              left: 12,
              top: 10,
              right: 12,
              bottom: 10,
            ),
            child: Row(
              spacing: 10,
              children: [
                if (item
                        .modules
                        .moduleDynamic!
                        .major!
                        .common!
                        .cover
                        ?.isNotEmpty ==
                    true)
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    child: CachedNetworkImage(
                      width: 45,
                      height: 45,
                      fit: BoxFit.cover,
                      imageUrl: item
                          .modules
                          .moduleDynamic!
                          .major!
                          .common!
                          .cover!
                          .http2https,
                    ),
                  ),
                Expanded(
                  child: Column(
                    spacing: 2,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        major!.common!.title!,
                        style: TextStyle(color: theme.colorScheme.primary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (item
                              .modules
                              .moduleDynamic!
                              .major!
                              .common!
                              .desc
                              ?.isNotEmpty ==
                          true)
                        Text(
                          major.common!.desc!,
                          style: TextStyle(
                            color: theme.colorScheme.outline,
                            fontSize: theme.textTheme.labelMedium!.fontSize,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    case 'DYNAMIC_TYPE_MUSIC':
      final Map music = major!.music!;
      return InkWell(
        onTap: () => PageUtils.handleWebview("https:${music['jump_url']}"),
        child: Container(
          padding: const EdgeInsets.only(
            left: 12,
            top: 10,
            right: 12,
            bottom: 10,
          ),
          color: theme.dividerColor.withValues(alpha: 0.08),
          child: Row(
            children: [
              NetworkImgLayer(
                radius: 8,
                width: 45,
                height: 45,
                src: music['cover'],
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    music['title'],
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    music['label'],
                    style: TextStyle(
                      color: theme.colorScheme.outline,
                      fontSize: theme.textTheme.labelMedium!.fontSize,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    case 'DYNAMIC_TYPE_MEDIALIST':
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (floor == 1) const SizedBox(width: 12),
          if (major?.medialist?.cover?.isNotEmpty == true) ...[
            Stack(
              clipBehavior: Clip.none,
              children: [
                Hero(
                  tag: major!.medialist!.cover!,
                  child: NetworkImgLayer(
                    width: 180,
                    height: 110,
                    src: major.medialist!.cover,
                  ),
                ),
                PBadge(
                  right: 6,
                  top: 6,
                  text: major.medialist!.badge?.text,
                ),
              ],
            ),
            const SizedBox(width: 14),
          ],
          Expanded(
            child: SizedBox(
              height: 110,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    major!.medialist!.title!,
                    style: TextStyle(
                      fontSize: theme.textTheme.titleMedium!.fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (major.medialist?.subTitle != null) ...[
                    const Spacer(),
                    Text(
                      major.medialist!.subTitle!,
                      style: TextStyle(
                        fontSize: theme.textTheme.labelLarge!.fontSize,
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (floor == 1) const SizedBox(width: 12),
        ],
      );

    case 'DYNAMIC_TYPE_SUBSCRIPTION_NEW'
        when major?.type == 'MAJOR_TYPE_SUBSCRIPTION_NEW':
      return livePanelSub(
        context,
        theme: theme,
        isDetail: isDetail,
        item: item,
        floor: floor,
        maxWidth: maxWidth,
      );

    default:
      return Padding(
        padding: floor == 1
            ? const EdgeInsets.symmetric(horizontal: 12)
            : EdgeInsets.zero,
        child: Text('暂未支持的类型: \n${item.idStr}\n${item.type}'),
      );
  }
}
