import 'package:PiliPlus/common/widgets/image_save.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/network_img_layer.dart';
import 'package:PiliPlus/utils/utils.dart';

import '../../../models/user/sub_folder.dart';

class SubItem extends StatelessWidget {
  final SubFolderItemData subFolderItem;
  final Function(SubFolderItemData) cancelSub;
  const SubItem({
    super.key,
    required this.subFolderItem,
    required this.cancelSub,
  });

  @override
  Widget build(BuildContext context) {
    String heroTag = Utils.makeHeroTag(subFolderItem.id);
    return InkWell(
      onTap: () => Get.toNamed(
        '/subDetail',
        arguments: subFolderItem,
        parameters: {
          'heroTag': heroTag,
          'id': subFolderItem.id.toString(),
        },
      ),
      onLongPress: () => imageSaveDialog(
        title: subFolderItem.title,
        cover: subFolderItem.cover,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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
                  return Hero(
                    tag: heroTag,
                    child: NetworkImgLayer(
                      src: subFolderItem.cover,
                      width: maxWidth,
                      height: maxHeight,
                    ),
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
    // subFolderItem.type == 11：播单
    // subFolderItem.type == 21：合集
    // 其它：其它
    String typeString = subFolderItem.type == 11
        ? '播单'
        : subFolderItem.type == 21
            ? '合集'
            : '其它:${subFolderItem.type}';
    return Expanded(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subFolderItem.title!,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '[$typeString] UP主：${subFolderItem.upper!.name!}',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: theme.textTheme.labelMedium!.fontSize,
                  color: theme.colorScheme.outline,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${subFolderItem.mediaCount}个视频',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: theme.textTheme.labelMedium!.fontSize,
                  color: theme.colorScheme.outline,
                ),
              ),
              const Spacer(),
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: SizedBox(
              height: 35,
              width: 35,
              child: IconButton(
                onPressed: () => cancelSub(subFolderItem),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.outline,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                ),
                icon: const Icon(Icons.delete_outline, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
