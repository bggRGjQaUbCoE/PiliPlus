import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/models_new/fav/fav_folder/list.dart';
import 'package:PiliPlus/utils/fav_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavFolderItem extends StatelessWidget {
  const FavFolderItem({
    super.key,
    required this.item,
    required this.callback,
    required this.heroTag,
  });

  final FavFolderInfo item;
  final VoidCallback callback;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.zero,
      child: GestureDetector(
        onTap: () {
          Get.toNamed(
            '/favDetail',
            arguments: item,
            parameters: {
              'mediaId': item.id.toString(),
              'heroTag': heroTag,
            },
          )?.whenComplete(callback);
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.onInverseSurface.withValues(
                      alpha: 0.4,
                    ),
                    offset: const Offset(4, -12),
                    blurRadius: 0.0,
                    spreadRadius: 0.0,
                  ),
                ],
              ),
              child: Hero(
                tag: heroTag,
                child: NetworkImgLayer(
                  src: item.cover,
                  width: 180,
                  height: 110,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              ' ${item.title}',
              overflow: TextOverflow.fade,
              maxLines: 1,
            ),
            Text(
              ' 共${item.mediaCount}条视频 · ${FavUtils.isPublicFavText(item.attr)}',
              style: theme.textTheme.labelSmall!.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
