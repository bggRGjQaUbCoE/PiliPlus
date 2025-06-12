// 视频or合集
import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';

Widget videoSeasonWidget(
  ThemeData theme,
  bool isSave,
  bool isDetail,
  DynamicItemModel item,
  BuildContext context,
  String type,
  Function(List<String>, int)? callback, {
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
                style: TextStyle(color: theme.colorScheme.outline),
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

  DynamicArchiveModel? itemContent = switch (type) {
    'ugcSeason' => item.modules.moduleDynamic?.major?.ugcSeason,
    'archive' => item.modules.moduleDynamic?.major?.archive,
    'pgc' => item.modules.moduleDynamic?.major?.pgc,
    _ => null,
  };

  if (itemContent == null) {
    return const SizedBox.shrink();
  }

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
              src: itemContent.cover,
              quality: 40,
            ),
            if (itemContent.badge?.text != null)
              PBadge(
                text: itemContent.badge!.text,
                top: 8.0,
                right: 10.0,
                bottom: null,
                left: null,
                type: switch (itemContent.badge!.text) {
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
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black54,
                    ],
                  ),
                  borderRadius: BorderRadius.only(
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
                      if (itemContent.durationText != null) ...[
                        DecoratedBox(
                          decoration: const BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          child: Text(' ${itemContent.durationText} '),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text('${Utils.numFormat(itemContent.stat?.play)}次围观'),
                      const SizedBox(width: 6),
                      Text('${Utils.numFormat(itemContent.stat?.danmu)}条弹幕'),
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
      if (itemContent.cover != null)
        Padding(
          padding: floor == 1
              ? const EdgeInsets.symmetric(horizontal: StyleString.safeSpace)
              : EdgeInsets.zero,
          child: buildCover(),
        ),
      const SizedBox(height: 6),
      if (itemContent.title != null)
        Padding(
          padding: floor == 1
              ? const EdgeInsets.only(left: 12, right: 12)
              : EdgeInsets.zero,
          child: Text(
            itemContent.title!,
            maxLines: isDetail ? null : 1,
            style: const TextStyle(fontWeight: FontWeight.bold),
            overflow: isDetail ? null : TextOverflow.ellipsis,
          ),
        ),
    ],
  );
}
