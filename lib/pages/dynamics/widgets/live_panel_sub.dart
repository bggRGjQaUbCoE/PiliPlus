import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:flutter/material.dart';

Widget livePanelSub(
  BuildContext context, {
  required int floor,
  required ThemeData theme,
  required DynamicItemModel item,
  required bool isDetail,
  required double maxWidth,
}) {
  LivePlayInfo? live = item
      .modules
      .moduleDynamic!
      .major
      ?.subscriptionNew
      ?.liveRcmd
      ?.content
      ?.livePlayInfo;
  if (live == null) {
    return const SizedBox.shrink();
  }
  EdgeInsets padding;
  if (floor == 1) {
    maxWidth -= 24;
    padding = const EdgeInsets.symmetric(horizontal: 12);
  } else {
    padding = EdgeInsets.zero;
  }
  return Padding(
    padding: padding,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            NetworkImgLayer(
              width: maxWidth,
              height: maxWidth / StyleString.aspectRatio,
              src: live.cover,
              quality: 40,
            ),
            PBadge(
              text: live.watchedShow?.textLarge,
              top: 6,
              right: 65,
              fontSize: 10.5,
              type: PBadgeType.gray,
            ),
            if (live.liveStatus == 1)
              Positioned(
                right: 6,
                top: 6,
                child: Image.asset(
                  height: 16,
                  'assets/images/live/live.gif',
                  filterQuality: FilterQuality.low,
                ),
              )
            else
              const PBadge(
                text: '直播结束',
                top: 6,
                right: 6,
              ),
            if (live.areaName case final areaName?)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 80,
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.fromLTRB(12, 0, 10, 10),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.transparent,
                        Colors.black45,
                      ],
                    ),
                    borderRadius: BorderRadius.vertical(
                      bottom: StyleString.imgRadius,
                    ),
                  ),
                  child: Text(
                    areaName,
                    style: TextStyle(
                      fontSize: theme.textTheme.labelMedium!.fontSize,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        if (live.title case final title?)
          Text(
            title,
            maxLines: isDetail ? null : 1,
            style: const TextStyle(fontWeight: FontWeight.bold),
            overflow: isDetail ? null : TextOverflow.ellipsis,
          ),
        const SizedBox(height: 2),
      ],
    ),
  );
}
