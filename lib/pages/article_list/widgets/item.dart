import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/flutter/layout_builder.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/models/common/stat_type.dart';
import 'package:PiliPlus/models_new/article/article_list/article.dart';
import 'package:flutter/material.dart' hide LayoutBuilder;
import 'package:get/get.dart';

class ArticleListItem extends StatelessWidget {
  const ArticleListItem({
    super.key,
    required this.item,
  });

  final ArticleListItemModel item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
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
            horizontal: Style.safeSpace,
            vertical: 5,
          ),
          child: Row(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.imageUrls?.isNotEmpty == true)
                AspectRatio(
                  aspectRatio: Style.aspectRatio,
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
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title!,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.42,
                        letterSpacing: 0.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    if (item.summary != null)
                      Text(
                        item.summary!,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.outline,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const Spacer(),
                    Row(
                      spacing: 16,
                      children: [
                        StatWidget(
                          value: item.stats?.view,
                          color: theme.colorScheme.outline,
                          type: StatType.view,
                        ),
                        StatWidget(
                          type: StatType.like,
                          value: item.stats?.like,
                          color: theme.colorScheme.outline,
                        ),
                        StatWidget(
                          type: StatType.reply,
                          value: item.stats?.reply,
                          color: theme.colorScheme.outline,
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
    );
  }
}
