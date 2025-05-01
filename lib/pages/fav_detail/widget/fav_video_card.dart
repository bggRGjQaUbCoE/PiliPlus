import 'package:PiliPlus/common/widgets/icon_button.dart';
import 'package:PiliPlus/common/widgets/image_save.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/models/user/fav_detail.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/page_utils.dart';
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
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;
  final VoidCallback? onDelFav;
  final VoidCallback? onViewFav;
  final bool? isSort;

  const FavVideoCardH({
    super.key,
    required this.videoItem,
    this.onDelFav,
    this.onTap,
    this.onLongPress,
    this.onViewFav,
    this.isSort,
  });

  @override
  Widget build(BuildContext context) {
    int id = videoItem.id!;
    String bvid = videoItem.bvid ?? IdUtils.av2bv(id);
    return InkWell(
      onTap: isSort == true
          ? null
          : () async {
              if (onTap != null) {
                onTap!();
                return;
              }
              String? epId;
              if (videoItem.type == 24) {
                videoItem.cid = await SearchHttp.ab2c(bvid: bvid);
                dynamic seasonId = videoItem.ogv!['season_id'];
                epId = videoItem.epId;
                PageUtils.viewBangumi(seasonId: seasonId, epId: epId);
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
              onViewFav?.call();
            },
      onLongPress: isSort == true
          ? null
          : () {
              if (onLongPress != null) {
                onLongPress!();
              } else {
                imageSaveDialog(
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
                    clipBehavior: Clip.none,
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
                      PBadge(
                        text: videoItem.ogv?['type_name'],
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
      ),
    );
  }

  Widget videoContent(context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  videoItem.title,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    letterSpacing: 0.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${Utils.dateFormat(videoItem.favTime)} ${videoItem.owner.name}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  height: 1,
                  fontSize: 12,
                  color: theme.colorScheme.outline,
                ),
              ),
              const SizedBox(height: 3),
              Row(
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
            ],
          ),
          if (onDelFav != null)
            Positioned(
              right: 0,
              bottom: -8,
              child: iconButton(
                context: context,
                icon: Icons.clear,
                tooltip: '取消收藏',
                iconColor: theme.colorScheme.outline,
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
                              style:
                                  TextStyle(color: theme.colorScheme.outline),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.back();
                              onDelFav!();
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
