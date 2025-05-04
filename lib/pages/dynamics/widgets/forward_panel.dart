// 转发
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/image/image_save.dart';
import 'package:PiliPlus/common/widgets/image/image_view.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/article/widgets/opus_content.dart';
import 'package:PiliPlus/pages/dynamics/widgets/additional_panel.dart';
import 'package:PiliPlus/pages/dynamics/widgets/article_panel.dart';
import 'package:PiliPlus/pages/dynamics/widgets/live_panel.dart';
import 'package:PiliPlus/pages/dynamics/widgets/live_rcmd_panel.dart';
import 'package:PiliPlus/pages/dynamics/widgets/pic_panel.dart';
import 'package:PiliPlus/pages/dynamics/widgets/rich_node_panel.dart';
import 'package:PiliPlus/pages/dynamics/widgets/video_panel.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

InlineSpan picsNodes(
  List<OpusPicsModel> pics,
  Function(List<String>, int)? callback,
) {
  return WidgetSpan(
    child: LayoutBuilder(
      builder: (context, constraints) => imageView(
        constraints.maxWidth,
        pics
            .map(
              (item) => ImageModel(
                width: item.width,
                height: item.height,
                url: item.url ?? '',
                liveUrl: item.liveUrl,
              ),
            )
            .toList(),
        callback: callback,
      ),
    ),
  );
}

Widget _blockedItem(ThemeData theme, ModuleBlocked moduleBlocked) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 1),
    child: LayoutBuilder(
      builder: (context, constraints) {
        return moduleBlockedItem(theme, moduleBlocked, constraints.maxWidth);
      },
    ),
  );
}

Widget forWard(
  ThemeData theme,
  bool isSave,
  DynamicItemModel item,
  BuildContext context,
  source,
  callback, {
  floor = 1,
}) {
  switch (item.type) {
    // 图文
    case 'DYNAMIC_TYPE_DRAW':
      TextSpan? richNodes = richNode(theme, item, context);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (floor == 2) ...[
            Row(
              children: [
                GestureDetector(
                  onTap: () => Get.toNamed(
                      '/member?mid=${item.modules.moduleAuthor!.mid}',
                      arguments: {'face': item.modules.moduleAuthor!.face}),
                  child: Text(
                    '@${item.modules.moduleAuthor!.name}',
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  Utils.dateFormat(item.modules.moduleAuthor!.pubTs),
                  style: TextStyle(
                      color: theme.colorScheme.outline,
                      fontSize: theme.textTheme.labelSmall!.fontSize),
                ),
              ],
            ),
            const SizedBox(height: 2),
            if (richNodes != null)
              Text.rich(
                richNodes,
                // 被转发状态(floor=2) 隐藏
                maxLines: isSave
                    ? null
                    : source == 'detail' && floor != 2
                        ? null
                        : 4,
                overflow: isSave
                    ? null
                    : source == 'detail' && floor != 2
                        ? null
                        : TextOverflow.ellipsis,
              ),
            if (item.modules.moduleDynamic?.major?.opus?.pics?.isNotEmpty ==
                true)
              Text.rich(
                picsNodes(
                    item.modules.moduleDynamic!.major!.opus!.pics!, callback),
              ),
            const SizedBox(height: 4),
          ],
          Padding(
            padding: floor == 2
                ? EdgeInsets.zero
                : const EdgeInsets.only(left: 12, right: 12),
            child: picWidget(item, context, callback),
          ),

          /// 附加内容 商品信息、直播预约等等
          if (item.modules.moduleDynamic?.additional != null)
            addWidget(
              theme,
              item,
              context,
              item.modules.moduleDynamic?.additional?.type,
              floor: floor,
            ),
          if (item.modules.moduleDynamic?.major?.blocked != null)
            _blockedItem(theme, item.modules.moduleDynamic!.major!.blocked!),
        ],
      );
    // 视频
    case 'DYNAMIC_TYPE_AV':
      return videoSeasonWidget(theme, source, item, context, 'archive',
          floor: floor);
    // 文章
    case 'DYNAMIC_TYPE_ARTICLE':
      return item.isForwarded == true
          ? articlePanel(theme, source, item, context, callback, floor: floor)
          : item.modules.moduleDynamic?.major?.blocked != null
              ? _blockedItem(theme, item.modules.moduleDynamic!.major!.blocked!)
              : const SizedBox.shrink();
    // 转发
    case 'DYNAMIC_TYPE_FORWARD':
      final isNoneMajor =
          item.orig?.modules.moduleDynamic?.major?.type == 'MAJOR_TYPE_NONE';
      return InkWell(
        onTap: isNoneMajor
            ? null
            : () => PageUtils.pushDynDetail(item.orig!, floor + 1),
        onLongPress: isNoneMajor
            ? null
            : () {
                late String? title, cover;
                late var origMajor = item.orig?.modules.moduleDynamic?.major;
                late var major = item.modules.moduleDynamic?.major;
                switch (item.orig?.type) {
                  case 'DYNAMIC_TYPE_AV':
                    title = origMajor?.archive?.title;
                    cover = origMajor?.archive?.cover;
                    break;
                  case 'DYNAMIC_TYPE_UGC_SEASON':
                    title = origMajor?.ugcSeason?.title;
                    cover = origMajor?.ugcSeason?.cover;
                    break;
                  case 'DYNAMIC_TYPE_PGC' || 'DYNAMIC_TYPE_PGC_UNION':
                    title = origMajor?.pgc?.title;
                    cover = origMajor?.pgc?.cover;
                    break;
                  case 'DYNAMIC_TYPE_LIVE_RCMD':
                    title = major?.liveRcmd?.title;
                    cover = major?.liveRcmd?.cover;
                    break;
                  case 'DYNAMIC_TYPE_LIVE':
                    title = major?.live?.title;
                    cover = major?.live?.cover;
                    break;
                  default:
                    return;
                }
                imageSaveDialog(
                  title: title,
                  cover: cover,
                );
              },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          color: theme.dividerColor.withOpacity(0.08),
          child: forWard(theme, isSave, item.orig!, context, source, callback,
              floor: floor + 1),
        ),
      );
    // 直播
    case 'DYNAMIC_TYPE_LIVE_RCMD':
      return liveRcmdPanel(theme, source, item, context, floor: floor);
    // 直播
    case 'DYNAMIC_TYPE_LIVE':
      return livePanel(theme, source, item, context, floor: floor);
    // 合集
    case 'DYNAMIC_TYPE_UGC_SEASON':
      return videoSeasonWidget(theme, source, item, context, 'ugcSeason');
    case 'DYNAMIC_TYPE_WORD':
      late TextSpan? richNodes = richNode(theme, item, context);
      return floor == 2
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.toNamed(
                          '/member?mid=${item.modules.moduleAuthor?.mid}',
                          arguments: {'face': item.modules.moduleAuthor?.face}),
                      child: Text(
                        '@${item.modules.moduleAuthor?.name}',
                        style: TextStyle(color: theme.colorScheme.primary),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      Utils.dateFormat(item.modules.moduleAuthor?.pubTs),
                      style: TextStyle(
                          color: theme.colorScheme.outline,
                          fontSize: theme.textTheme.labelSmall!.fontSize),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (richNodes != null)
                  Text.rich(
                    richNodes,
                    // 被转发状态(floor=2) 隐藏
                    maxLines: isSave
                        ? null
                        : source == 'detail' && floor != 2
                            ? null
                            : 4,
                    overflow: isSave
                        ? null
                        : source == 'detail' && floor != 2
                            ? null
                            : TextOverflow.ellipsis,
                  ),
              ],
            )
          : item.modules.moduleDynamic?.additional != null
              ? addWidget(
                  theme,
                  item,
                  context,
                  item.modules.moduleDynamic!.additional!.type,
                  floor: floor,
                )
              : item.modules.moduleDynamic?.major?.blocked != null
                  ? _blockedItem(
                      theme, item.modules.moduleDynamic!.major!.blocked!)
                  : const SizedBox.shrink();
    case 'DYNAMIC_TYPE_PGC':
      return videoSeasonWidget(theme, source, item, context, 'pgc',
          floor: floor);
    case 'DYNAMIC_TYPE_PGC_UNION':
      return videoSeasonWidget(theme, source, item, context, 'pgc',
          floor: floor);
    // 直播结束
    case 'DYNAMIC_TYPE_NONE':
      return Row(
        children: [
          const Icon(
            FontAwesomeIcons.ghost,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(item.modules.moduleDynamic!.major!.none!.tips!)
        ],
      );
    // 课堂
    case 'DYNAMIC_TYPE_COURSES_SEASON':
      return Row(
        children: [
          Expanded(
            child: Text(
              "课堂💪：${item.modules.moduleDynamic!.major!.courses!['title']}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      );
    // 活动
    case 'DYNAMIC_TYPE_COMMON_SQUARE':
      return InkWell(
        onTap: () {
          try {
            String url = item.modules.moduleDynamic!.major!.common!['jump_url'];
            if (url.contains('bangumi/play') && PageUtils.viewPgcFromUri(url)) {
              return;
            }
            PageUtils.handleWebview(url, inApp: true);
          } catch (_) {}
        },
        child: Container(
          width: double.infinity,
          padding:
              const EdgeInsets.only(left: 12, top: 10, right: 12, bottom: 10),
          color: theme.dividerColor.withOpacity(0.08),
          child: Row(
            children: [
              NetworkImgLayer(
                type: 'cover',
                radius: 8,
                width: 45,
                height: 45,
                src: item.modules.moduleDynamic!.major!.common!['cover'],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.modules.moduleDynamic!.major!.common!['title'],
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.modules.moduleDynamic!.major!.common!['desc'],
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
      );
    case 'DYNAMIC_TYPE_MUSIC':
      final Map music = item.modules.moduleDynamic!.major!.music!;
      return InkWell(
        onTap: () {
          PageUtils.handleWebview("https:${music['jump_url']}");
        },
        child: Container(
          width: double.infinity,
          padding:
              const EdgeInsets.only(left: 12, top: 10, right: 12, bottom: 10),
          color: theme.dividerColor.withOpacity(0.08),
          child: Row(
            children: [
              NetworkImgLayer(
                type: 'cover',
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
              )
            ],
          ),
        ),
      );
    case 'DYNAMIC_TYPE_MEDIALIST':
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (floor == 2) ...[
            GestureDetector(
              onTap: () {
                Get.toNamed(
                  '/member?mid=${item.modules.moduleAuthor!.mid}',
                );
              },
              child: Row(
                children: [
                  NetworkImgLayer(
                    width: 28,
                    height: 28,
                    type: 'avatar',
                    src: item.modules.moduleAuthor!.face,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    item.modules.moduleAuthor!.name!,
                    style: TextStyle(
                      color: item.modules.moduleAuthor!.vip != null &&
                              item.modules.moduleAuthor!.vip!.status > 0 &&
                              item.modules.moduleAuthor!.vip!.type == 2
                          ? context.vipColor
                          : theme.colorScheme.onSurface,
                      fontSize: theme.textTheme.titleMedium!.fontSize,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (floor == 1) const SizedBox(width: 12),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Hero(
                    tag: item.modules.moduleDynamic!.major!.medialist!['cover'],
                    child: NetworkImgLayer(
                      width: 180,
                      height: 110,
                      src: item
                          .modules.moduleDynamic!.major!.medialist!['cover'],
                    ),
                  ),
                  PBadge(
                    right: 6,
                    top: 6,
                    text: item.modules.moduleDynamic!.major!.medialist!['badge']
                        ?['text'],
                  )
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: SizedBox(
                  height: 110,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        item.modules.moduleDynamic!.major!.medialist!['title'],
                        style: TextStyle(
                            fontSize: theme.textTheme.titleMedium!.fontSize,
                            fontWeight: FontWeight.bold),
                      ),
                      if (item.modules.moduleDynamic?.major
                              ?.medialist?['sub_title'] !=
                          null) ...[
                        const Spacer(),
                        Text(
                          item.modules.moduleDynamic!.major!
                              .medialist!['sub_title'],
                          style: TextStyle(
                              fontSize: theme.textTheme.labelLarge!.fontSize,
                              color: theme.colorScheme.outline),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (floor == 1) const SizedBox(width: 12),
            ],
          ),
        ],
      );

    default:
      return const SizedBox(
        width: double.infinity,
        child: Text('🙏 暂未支持的类型，请联系开发者反馈 '),
      );
  }
}
