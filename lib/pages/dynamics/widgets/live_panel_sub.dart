import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget livePanelSub(
  ThemeData theme,
  bool isDetail,
  DynamicItemModel item,
  BuildContext context, {
  int floor = 1,
}) {
  SubscriptionNew? subItem = item.modules.moduleDynamic!.major?.subscriptionNew;
  LivePlayInfo? content = subItem?.liveRcmd?.content?.livePlayInfo;
  if (subItem == null || content == null) {
    return const SizedBox.shrink();
  }
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: StyleString.safeSpace),
        child: GestureDetector(
          onTap: () => Get.toNamed('/liveRoom?roomid=${content.roomId}'),
          child: LayoutBuilder(
            builder: (context, box) {
              double width = box.maxWidth;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Hero(
                    tag: content.roomId.toString(),
                    child: NetworkImgLayer(
                      width: width,
                      height: width / StyleString.aspectRatio,
                      src: content.cover,
                      quality: 40,
                    ),
                  ),
                  PBadge(
                    text: content.watchedShow?.textLarge,
                    top: 6,
                    right: 65,
                    fontSize: 10.5,
                    type: PBadgeType.gray,
                  ),
                  if (content.liveStatus == 1)
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
                  if (content.areaName != null)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 80,
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.fromLTRB(12, 0, 10, 10),
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              Colors.transparent,
                              Colors.black45,
                            ],
                          ),
                          borderRadius: floor == 1
                              ? const BorderRadius.only(
                                  bottomLeft: StyleString.imgRadius,
                                  bottomRight: StyleString.imgRadius,
                                )
                              : const BorderRadius.only(
                                  bottomLeft: Radius.circular(6),
                                  bottomRight: Radius.circular(6),
                                ),
                        ),
                        child: Text(
                          content.areaName!,
                          style: TextStyle(
                            fontSize: theme.textTheme.labelMedium!.fontSize,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
      const SizedBox(height: 6),
      if (content.title != null)
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: StyleString.safeSpace),
          child: Text(
            content.title!,
            maxLines: isDetail ? null : 1,
            style: const TextStyle(fontWeight: FontWeight.bold),
            overflow: isDetail ? null : TextOverflow.ellipsis,
          ),
        ),
      const SizedBox(height: 2),
    ],
  );
}
