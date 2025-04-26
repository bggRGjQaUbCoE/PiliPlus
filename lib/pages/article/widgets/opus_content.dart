import 'package:PiliPlus/common/widgets/interactiveviewer_gallery/interactiveviewer_gallery.dart'
    show SourceModel;
import 'package:PiliPlus/common/widgets/network_img_layer.dart';
import 'package:PiliPlus/models/dynamics/article_content_model.dart'
    show ArticleContentModel;
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

Widget opusContent({
  required BuildContext context,
  required List<ArticleContentModel> opus,
  Function(List<String>, int)? callback,
  required double maxWidth,
}) {
  debugPrint('opusContent');

  if (opus.isEmpty) {
    return const SliverToBoxAdapter();
  }
  final colorScheme = Theme.of(context).colorScheme;
  return SliverList.separated(
    itemCount: opus.length,
    itemBuilder: (context, index) {
      final element = opus[index];
      try {
        switch (element.paraType) {
          case 1 || 4:
            return SelectableText.rich(
              textAlign: element.align == 1 ? TextAlign.center : null,
              TextSpan(
                  children: element.text?.nodes!.map<TextSpan>((item) {
                if (item.rich != null) {
                  return TextSpan(
                    text: '\u{1F517}${item.rich?.text}',
                    style: TextStyle(
                      decoration: item.rich?.style?.strikethrough == true
                          ? TextDecoration.lineThrough
                          : null,
                      fontStyle: item.rich?.style?.italic == true
                          ? FontStyle.italic
                          : null,
                      fontWeight: item.rich?.style?.bold == true
                          ? FontWeight.bold
                          : null,
                      color: colorScheme.primary,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        if (item.rich!.jumpUrl != null) {
                          PiliScheme.routePushFromUrl(item.rich!.jumpUrl!);
                        }
                      },
                  );
                }
                Color? color;
                if (item.word?.color?.isNotEmpty == true) {
                  var colorValue = int.tryParse(
                      item.word!.color!.replaceFirst('#', 'FF'),
                      radix: 16);
                  if (colorValue != null) {
                    color = Color(colorValue);
                  }
                }
                return TextSpan(
                  text: item.word?.words,
                  style: TextStyle(
                    decoration: item.word?.style?.strikethrough == true
                        ? TextDecoration.lineThrough
                        : null,
                    fontStyle: item.word?.style?.italic == true
                        ? FontStyle.italic
                        : null,
                    fontWeight:
                        item.word?.style?.bold == true ? FontWeight.bold : null,
                    color: color,
                    fontSize: item.word?.fontSize?.toDouble(),
                  ),
                );
              }).toList()),
            );
          case 2:
            element.pic!.pics!.first.onCalHeight(maxWidth);
            return Hero(
              tag: element.pic!.pics!.first.url!,
              child: GestureDetector(
                onTap: () {
                  if (callback != null) {
                    callback(
                      [element.pic!.pics!.first.url!],
                      0,
                    );
                  } else {
                    context.imageView(
                      initialPage: 0,
                      imgList: [
                        SourceModel(url: element.pic!.pics!.first.url!)
                      ],
                    );
                  }
                },
                child: NetworkImgLayer(
                  width: maxWidth,
                  height: element.pic?.pics?.first.calHeight,
                  src: element.pic!.pics!.first.url!,
                  quality: 60,
                ),
              ),
            );
          case 3:
            return CachedNetworkImage(
              width: maxWidth,
              fit: BoxFit.contain,
              height: element.line?.pic?.height?.toDouble(),
              imageUrl: Utils.thumbnailImgUrl(element.line!.pic!.url!),
            );
          case 6 when (element.linkCard?.card?.ugc != null):
            return Card(
              margin: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              color: colorScheme.onInverseSurface,
              child: InkWell(
                onTap: () {
                  try {
                    PiliScheme.videoPush(
                      int.parse(element.linkCard!.card!.oid!),
                      null,
                    );
                  } catch (_) {}
                },
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      NetworkImgLayer(
                        radius: 6,
                        width: 65 * 16 / 10,
                        height: 65,
                        src: element.linkCard!.card!.ugc!.cover,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(element.linkCard!.card!.ugc!.title!),
                            Text(
                              element.linkCard!.card!.ugc!.descSecond!,
                              style: TextStyle(
                                fontSize: 13,
                                color: colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          default:
            return SelectableText('不支持的类型 (${element.paraType})',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ));
        }
      } catch (e) {
        return SelectableText('错误的类型 $e',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ));
      }
    },
    separatorBuilder: (context, index) => const SizedBox(height: 10),
  );
}
