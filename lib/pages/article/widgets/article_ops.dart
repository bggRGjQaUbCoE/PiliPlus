import 'dart:math' as math;

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/models_new/article/article_view/ops.dart';
import 'package:PiliPlus/pages/dynamics/widgets/vote.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArticleOpus extends StatelessWidget {
  const ArticleOpus({
    super.key,
    required List<ArticleOps>? ops,
    required this.maxWidth,
  }) : _ops = ops;

  final List<ArticleOps>? _ops;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    if (_ops == null || _ops.isEmpty) {
      return const SliverToBoxAdapter();
    }

    return SliverList.separated(
      itemCount: _ops.length,
      itemBuilder: (context, index) {
        try {
          final item = _ops[index];
          switch (item.insert) {
            case String e:
              return SelectableText(e);
            case Insert(:final card):
              if (card != null) {
                if (card.url?.isNotEmpty == true) {
                  double? width = card.width == null
                      ? null
                      : math.min(maxWidth, card.width!);
                  final height = width == null || card.height == null
                      ? null
                      : width * card.height! / card.width!;
                  width ??= maxWidth;
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
                        width: width,
                        height: height,
                        memCacheWidth: width.cacheSize(context),
                        imageUrl: ImageUtils.thumbnailUrl(card.url, 60),
                        placeholder: (_, _) => const SizedBox.shrink(),
                      ),
                    ),
                  );
                }
              }
          }
          return Text(item.attributes.toString());
        } catch (e) {
          return Text(e.toString());
        }
      },
      separatorBuilder: (context, index) => const SizedBox(height: 10),
    );
  }
}
