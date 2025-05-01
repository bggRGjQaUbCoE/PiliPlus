import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/icon_button.dart';
import 'package:PiliPlus/common/widgets/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavArticleItem extends StatelessWidget {
  const FavArticleItem({
    super.key,
    required this.item,
    required this.onDelete,
  });

  final dynamic item;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          InkWell(
            onTap: () {
              Get.toNamed(
                '/articlePage',
                parameters: {
                  'id': item['opus_id'],
                  'type': 'opus',
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
                  if (item['cover'] != null) ...[
                    AspectRatio(
                      aspectRatio: StyleString.aspectRatio,
                      child: LayoutBuilder(
                        builder: (BuildContext context,
                            BoxConstraints boxConstraints) {
                          return NetworkImgLayer(
                            src: item['cover']['url'],
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
                            item['content'],
                            style: TextStyle(
                              fontSize: theme.textTheme.bodyMedium!.fontSize,
                              height: 1.42,
                              letterSpacing: 0.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            // StatView(
                            //   context: context,
                            //   value: item['stat']['view'],
                            //   goto: 'picture',
                            //   textColor: theme.colorScheme.outline,
                            // ),
                            // const SizedBox(width: 16),
                            StatView(
                              context: context,
                              goto: 'like',
                              value: item['stat']['like'] == ''
                                  ? 0
                                  : item['stat']['like'],
                              textColor: theme.colorScheme.outline,
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${item['author']['name']} · ${item['pub_time']}',
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1,
                            color: theme.colorScheme.outline,
                            overflow: TextOverflow.clip,
                          ),
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
              context: context,
              onPressed: onDelete,
              icon: Icons.clear,
              iconColor: theme.colorScheme.outline,
              bgColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
