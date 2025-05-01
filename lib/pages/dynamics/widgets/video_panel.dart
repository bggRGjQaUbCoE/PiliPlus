// 视频or合集
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/network_img_layer.dart';
import 'package:PiliPlus/utils/utils.dart';

import 'rich_node_panel.dart';

Widget videoSeasonWidget(
  ThemeData theme,
  String? source,
  DynamicItemModel item,
  BuildContext context,
  String type, {
  floor = 1,
}) {
  if (item.modules.moduleDynamic?.major?.type == 'MAJOR_TYPE_NONE') {
    return item.modules.moduleDynamic?.major?.none?.tips != null
        ? Row(
            children: [
              Icon(
                Icons.error,
                size: 18,
                color: theme.colorScheme.outline,
              ),
              const SizedBox(width: 5),
              Text(
                item.modules.moduleDynamic!.major!.none!.tips!,
                style: TextStyle(
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          )
        : const SizedBox.shrink();
  }

  // type archive  ugcSeason
  // archive 视频/显示发布人
  // ugcSeason 合集/不显示发布人

  // floor 1 2
  // 1 投稿视频 铺满 borderRadius 0
  // 2 转发视频 铺满 borderRadius 6

  DynamicArchiveModel? content = switch (type) {
    'ugcSeason' => item.modules.moduleDynamic?.major?.ugcSeason,
    'archive' => item.modules.moduleDynamic?.major?.archive,
    'pgc' => item.modules.moduleDynamic?.major?.pgc,
    _ => null,
  };

  if (content == null) {
    return const SizedBox.shrink();
  }

  TextSpan? richNodes = richNode(theme, item, context);

  Widget buildCover() {
    return LayoutBuilder(
      builder: (context, box) {
        double width = box.maxWidth;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            NetworkImgLayer(
              width: width,
              height: width / StyleString.aspectRatio,
              src: content.cover,
            ),
            if (content.badge?['text'] != null)
              PBadge(
                text: content.badge!['text'],
                top: 8.0,
                right: 10.0,
                bottom: null,
                left: null,
                type: content.badge!['text'] == '充电专属' ? 'error' : 'primary',
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 70,
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.fromLTRB(10, 0, 8, 8),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black54,
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: StyleString.imgRadius,
                    bottomRight: StyleString.imgRadius,
                  ),
                ),
                child: DefaultTextStyle.merge(
                  style: TextStyle(
                    fontSize: theme.textTheme.labelMedium!.fontSize,
                    color: Colors.white,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (content.durationText != null) ...[
                        Text(
                          content.durationText!,
                          semanticsLabel:
                              '时长${Utils.durationReadFormat(content.durationText!)}',
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text('${content.stat?.play}次围观'),
                      const SizedBox(width: 6),
                      Text('${content.stat?.danmu}条弹幕'),
                      const Spacer(),
                      Image.asset(
                        'assets/images/play.png',
                        width: 50,
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      if (floor == 2) ...[
        Row(
          children: [
            GestureDetector(
              onTap: () => Get.toNamed(
                '/member?mid=${item.modules.moduleAuthor!.mid}',
                arguments: {'face': item.modules.moduleAuthor!.face},
              ),
              child: Text(
                item.modules.moduleAuthor?.type == null
                    ? '@${item.modules.moduleAuthor!.name}'
                    : item.modules.moduleAuthor!.name!,
                style: TextStyle(color: theme.colorScheme.primary),
              ),
            ),
            const SizedBox(width: 6),
            if (item.modules.moduleAuthor?.pubTs != null)
              Text(
                Utils.dateFormat(item.modules.moduleAuthor!.pubTs),
                style: TextStyle(
                  color: theme.colorScheme.outline,
                  fontSize: theme.textTheme.labelSmall!.fontSize,
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
      ],
      if (floor == 2 && content.desc != null && richNodes != null) ...[
        Text.rich(richNodes),
        const SizedBox(height: 6),
      ],
      if (content.cover != null)
        if (item.isForwarded == true)
          buildCover()
        else
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: StyleString.safeSpace),
            child: buildCover(),
          ),
      const SizedBox(height: 6),
      if (content.title != null)
        Padding(
          padding: floor == 1
              ? const EdgeInsets.only(left: 12, right: 12)
              : EdgeInsets.zero,
          child: Text(
            content.title!,
            maxLines: source == 'detail' ? null : 1,
            style: const TextStyle(fontWeight: FontWeight.bold),
            overflow: source == 'detail' ? null : TextOverflow.ellipsis,
          ),
        ),
    ],
  );
}
