import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/models_new/article/article_view/ops.dart';
import 'package:PiliPlus/pages/dynamics/widgets/vote.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArticleOpus extends StatelessWidget {
  const ArticleOpus({super.key, required this.ops});

  final List<ArticleOps>? ops;

  @override
  Widget build(BuildContext context) {
    if (ops.isNullOrEmpty) {
      return const SliverToBoxAdapter();
    }

    return SliverList.separated(
      itemCount: ops!.length,
      itemBuilder: (context, index) {
        try {
          final item = ops![index];
          if (item.insert is String) {
            return SelectableText(item.insert);
          }

          if (item.insert is Insert) {
            InsertCard card = item.insert.card;
            if (card.url?.isNotEmpty == true) {
              return GestureDetector(
                onTap: () {
                  switch (item.attributes?.clazz) {
                    case 'article-card card':
                      if (card.id != null) {
                        Get.toNamed(
                          '/articlePage',
                          parameters: {
                            'id': card.id!.substring(2),
                            'type': 'read',
                          },
                        );
                      }
                    case 'video-card card':
                      if (card.id != null) {
                        PiliScheme.videoPush(null, card.id);
                      }
                    case 'vote-card card':
                      if (card.id != null) {
                        showVoteDialog(context, int.parse(card.id!));
                      }
                  }
                },
                child: ClipRRect(
                  borderRadius: StyleString.mdRadius,
                  child: CachedNetworkImage(
                    imageUrl: ImageUtils.thumbnailUrl(card.url, 60),
                  ),
                ),
              );
            }
          }

          return Text('${item.attributes}');
        } catch (e) {
          return Text(e.toString());
        }
      },
      separatorBuilder: (context, index) => const SizedBox(height: 10),
    );
  }
}
