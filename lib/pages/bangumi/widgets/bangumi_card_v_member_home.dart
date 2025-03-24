import 'package:PiliPlus/common/widgets/image_save.dart';
import 'package:PiliPlus/models/space_archive/item.dart';
import 'package:flutter/material.dart';
import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:PiliPlus/common/widgets/network_img_layer.dart';

// 视频卡片 - 垂直布局
class BangumiCardVMemberHome extends StatelessWidget {
  const BangumiCardVMemberHome({
    super.key,
    required this.bangumiItem,
  });

  final Item bangumiItem;

  @override
  Widget build(BuildContext context) {
    String heroTag = Utils.makeHeroTag(bangumiItem.param);
    return Card(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () async {
          final int seasonId = int.tryParse(bangumiItem.param ?? '') ?? -1;
          Utils.viewBangumi(seasonId: seasonId);
        },
        onLongPress: () => imageSaveDialog(
          context: context,
          title: bangumiItem.title,
          cover: bangumiItem.cover,
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: StyleString.imgRadius,
                topRight: StyleString.imgRadius,
                bottomLeft: StyleString.imgRadius,
                bottomRight: StyleString.imgRadius,
              ),
              child: AspectRatio(
                aspectRatio: 0.75,
                child: LayoutBuilder(builder: (context, boxConstraints) {
                  final double maxWidth = boxConstraints.maxWidth;
                  final double maxHeight = boxConstraints.maxHeight;
                  return Stack(
                    children: [
                      Hero(
                        tag: heroTag,
                        child: NetworkImgLayer(
                          src: bangumiItem.cover,
                          width: maxWidth,
                          height: maxHeight,
                        ),
                      ),
                      // if (bangumiItem.badge != null)
                      //   PBadge(
                      //       text: bangumiItem.badge,
                      //       top: 6,
                      //       right: 6,
                      //       bottom: null,
                      //       left: null),
                      // if (bangumiItem.order != null)
                      //   PBadge(
                      //     text: bangumiItem.order,
                      //     top: null,
                      //     right: null,
                      //     bottom: 6,
                      //     left: 6,
                      //     type: 'gray',
                      //   ),
                    ],
                  );
                }),
              ),
            ),
            bangumiContent(bangumiItem)
          ],
        ),
      ),
    );
  }
}

Widget bangumiContent(Item bangumiItem) {
  return Expanded(
    child: Padding(
      // 多列
      padding: const EdgeInsets.fromLTRB(4, 5, 0, 3),
      // 单列
      // padding: const EdgeInsets.fromLTRB(14, 10, 4, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                bangumiItem.title,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  letterSpacing: 0.3,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
            ],
          ),
          const SizedBox(height: 1),
          // if (bangumiItem.indexShow != null)
          //   Text(
          //     bangumiItem.indexShow,
          //     maxLines: 1,
          //     style: TextStyle(
          //       fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
          //       color: Theme.of(context).colorScheme.outline,
          //     ),
          //   ),
          // if (bangumiItem.progress != null)
          //   Text(
          //     bangumiItem.progress,
          //     maxLines: 1,
          //     style: TextStyle(
          //       fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
          //       color: Theme.of(context).colorScheme.outline,
          //     ),
          //   ),
        ],
      ),
    ),
  );
}
