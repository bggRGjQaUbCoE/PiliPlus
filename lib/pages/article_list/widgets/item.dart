import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/models/space_article/item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArticleListItem extends StatelessWidget {
  const ArticleListItem({
    super.key,
    required this.item,
  });

  final SpaceArticleItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        final dynIdStr = item.dynIdStr;
        Get.toNamed(
          '/articlePage',
          parameters: {
            'id': dynIdStr ?? item.id!.toString(),
            'type': dynIdStr != null ? 'opus' : 'read',
          },
        );
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
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title!,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.42,
                      letterSpacing: 0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  if (item.summary != null)
                    Text(
                      item.summary!,
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.outline,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const Spacer(),
                  Row(
                    children: [
                      StatView(
                        context: context,
                        value: item.stats?.view ?? 0,
                        goto: 'picture',
                        textColor: theme.colorScheme.outline,
                      ),
                      const SizedBox(width: 16),
                      StatView(
                        context: context,
                        goto: 'like',
                        value: item.stats?.like ?? 0,
                        textColor: theme.colorScheme.outline,
                      ),
                      const SizedBox(width: 16),
                      StatView(
                        context: context,
                        goto: 'reply',
                        value: item.stats?.reply ?? 0,
                        textColor: theme.colorScheme.outline,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (item.imageUrls?.isNotEmpty == true) ...[
              const SizedBox(width: 10),
              AspectRatio(
                aspectRatio: StyleString.aspectRatio,
                child: LayoutBuilder(
                  builder: (context, boxConstraints) {
                    return NetworkImgLayer(
                      src: item.imageUrls!.first,
                      width: boxConstraints.maxWidth,
                      height: boxConstraints.maxHeight,
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
