import 'package:PiliPlus/common/widgets/icon_button.dart';
import 'package:PiliPlus/common/widgets/image_save.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/models/user/fav_detail.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:PiliPlus/common/widgets/network_img_layer.dart';
import '../../../common/widgets/badge.dart';

// 收藏视频卡片 - 水平布局
class FavVideoCardH extends StatelessWidget {
  final FavDetailItemData videoItem;
  final Function? callFn;
  final int? searchType;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;
  final bool isOwner;
  final VoidCallback onViewFav;

  const FavVideoCardH({
    super.key,
    required this.videoItem,
    this.callFn,
    this.searchType,
    this.onTap,
    this.onLongPress,
    this.isOwner = false,
    required this.onViewFav,
  });

  @override
  Widget build(BuildContext context) {
    int id = videoItem.id!;
    String bvid = videoItem.bvid ?? IdUtils.av2bv(id);
    return InkWell(
      onTap: () async {
        if (onTap != null) {
          onTap!();
          return;
        }
        String? epId;
        if (videoItem.type == 24) {
          videoItem.cid = await SearchHttp.ab2c(bvid: bvid);
          dynamic seasonId = videoItem.ogv!['season_id'];
          epId = videoItem.epId;
          Utils.viewBangumi(seasonId: seasonId, epId: epId);
          return;
        } else if (videoItem.page == 0 || videoItem.page! > 1) {
          var result = await VideoHttp.videoIntro(bvid: bvid);
          if (result['status']) {
            epId = result['data'].epId;
          } else {
            SmartDialog.showToast(result['msg']);
          }
        }

        if ([0, 16].contains(videoItem.attr).not) {
          Get.toNamed('/member?mid=${videoItem.owner.mid}');
          return;
        }
        onViewFav();
        // Utils.toViewPage(
        //   'bvid=$bvid&cid=${videoItem.cid}${epId?.isNotEmpty == true ? '&epId=$epId' : ''}',
        //   arguments: {
        //     'videoItem': videoItem,
        //     'heroTag': Utils.makeHeroTag(id),
        //     'videoType':
        //         epId != null ? SearchType.media_bangumi : SearchType.video,
        //   },
        // );
      },
      onLongPress: () {
        if (onLongPress != null) {
          onLongPress!();
        } else {
          imageSaveDialog(
            context: context,
            title: videoItem.title,
            cover: videoItem.pic,
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: StyleString.safeSpace,
          vertical: 5,
        ),
        child: LayoutBuilder(
          builder: (context, boxConstraints) {
            double width =
                (boxConstraints.maxWidth - StyleString.cardSpace * 6) / 2;
            return SizedBox(
              height: width / StyleString.aspectRatio,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: StyleString.aspectRatio,
                    child: LayoutBuilder(
                      builder: (context, boxConstraints) {
                        double maxWidth = boxConstraints.maxWidth;
                        double maxHeight = boxConstraints.maxHeight;
                        return Stack(
                          children: [
                            NetworkImgLayer(
                              src: videoItem.pic,
                              width: maxWidth,
                              height: maxHeight,
                            ),
                            PBadge(
                              text: Utils.timeFormat(videoItem.duration),
                              right: 6.0,
                              bottom: 6.0,
                              type: 'gray',
                            ),
                            if (videoItem.ogv != null)
                              PBadge(
                                text: videoItem.ogv!['type_name'],
                                top: 6.0,
                                right: 6.0,
                                bottom: null,
                                left: null,
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  videoContent(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget videoContent(context) {
    return Expanded(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                videoItem.title,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  letterSpacing: 0.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (videoItem.ogv != null)
                Text(
                  videoItem.desc!,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              const Spacer(),
              Text(
                Utils.dateFormat(videoItem.favTime),
                style: TextStyle(
                    fontSize: 11, color: Theme.of(context).colorScheme.outline),
              ),
              if (!videoItem.owner.name.isNullOrEmpty)
                Text(
                  videoItem.owner.name!,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Row(
                  children: [
                    StatView(
                      context: context,
                      theme: 'gray',
                      value: videoItem.stat.viewStr,
                    ),
                    const SizedBox(width: 8),
                    StatDanMu(
                      context: context,
                      theme: 'gray',
                      value: videoItem.stat.danmuStr,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ],
          ),
          if (searchType != 1 && isOwner)
            Positioned(
              right: 0,
              bottom: 0,
              child: iconButton(
                context: context,
                icon: Icons.clear,
                tooltip: '取消收藏',
                iconColor: Theme.of(context).colorScheme.onSurfaceVariant,
                bgColor: Colors.transparent,
                onPressed: () {
                  showDialog(
                    context: Get.context!,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('提示'),
                        content: const Text('要取消收藏吗?'),
                        actions: [
                          TextButton(
                            onPressed: Get.back,
                            child: Text(
                              '取消',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.outline),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              await callFn?.call();
                              Get.back();
                            },
                            child: const Text('确定取消'),
                          )
                        ],
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
