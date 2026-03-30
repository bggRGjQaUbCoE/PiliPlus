import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/button/icon_button.dart';
import 'package:PiliPlus/common/widgets/flutter/layout_builder.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/models/common/stat_type.dart';
import 'package:PiliPlus/models_new/fav/fav_article/item.dart';
import 'package:flutter/material.dart' hide LayoutBuilder;
import 'package:get/get.dart';

class FavArticleItem extends StatelessWidget {
  const FavArticleItem({
    super.key,
    required this.item,
    required this.onDelete,
  });

  final FavArticleItemModel item;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          InkWell(
            onTap: () => Get.toNamed(
              '/articlePage',
              parameters: {
                'id': item.opusId!.toString(),
                'type': 'opus',
              },
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Style.safeSpace,
                vertical: 5,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.cover != null) ...[
                    AspectRatio(
                      aspectRatio: Style.aspectRatio,
                      child: LayoutBuilder(
                        builder: (context, boxConstraints) {
                          return NetworkImgLayer(
                            src: item.cover!.url,
                            width: boxConstraints.maxWidth,
                            height: boxConstraints.maxHeight,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.content!,
                            style: TextStyle(
                              fontSize: theme.textTheme.bodyMedium!.fontSize,
                              height: 1.42,
                              letterSpacing: 0.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          item.author!.name!,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1,
                            color: theme.colorScheme.outline,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            StatWidget(
                              type: StatType.like,
                              value: item.stat!.like,
                              color: theme.colorScheme.outline,
                            ),
                            Text(
                              '  ·  ${item.pubTime}',
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 13,
                                height: 1,
                                color: theme.colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 12,
            bottom: -6,
            child: iconButton(
              iconSize: 18,
              onPressed: onDelete,
              icon: const Icon(Icons.clear),
              iconColor: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}
