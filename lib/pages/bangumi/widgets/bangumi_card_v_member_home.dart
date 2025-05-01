import 'package:PiliPlus/common/widgets/image_save.dart';
import 'package:PiliPlus/models/space_archive/item.dart';
import 'package:PiliPlus/utils/page_utils.dart';
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
          PageUtils.viewBangumi(seasonId: seasonId);
        },
        onLongPress: () => imageSaveDialog(
          title: bangumiItem.title,
          cover: bangumiItem.cover,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  return Hero(
                    tag: heroTag,
                    child: NetworkImgLayer(
                      src: bangumiItem.cover,
                      width: boxConstraints.maxWidth,
                      height: boxConstraints.maxHeight,
                    ),
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
      padding: const EdgeInsets.fromLTRB(4, 5, 0, 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bangumiItem.title,
            textAlign: TextAlign.start,
            style: const TextStyle(
              letterSpacing: 0.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 1),
        ],
      ),
    ),
  );
}
