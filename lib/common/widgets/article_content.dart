import 'package:PiliPlus/common/widgets/interactiveviewer_gallery/interactiveviewer_gallery.dart'
    show SourceModel;
import 'package:PiliPlus/common/widgets/network_img_layer.dart';
import 'package:PiliPlus/models/dynamics/article_content_model.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget articleContent({
  required BuildContext context,
  required List<ArticleContentModel> list,
  Function(List<String>, int)? callback,
  required double maxWidth,
}) {
  debugPrint('articleContent');
  List<String>? imgList = list
      .where((item) => item.pic != null)
      .map((item) => item.pic?.pics?.first.url ?? '')
      .toList();
  return SliverList.separated(
    itemCount: list.length,
    itemBuilder: (context, index) {
      ArticleContentModel item = list[index];
      if (item.text != null) {
        List<InlineSpan>? spanList = item.text?.nodes?.map((item) {
          return TextSpan(
            text: item.word?.words,
            style: TextStyle(
              letterSpacing: 0.3,
              fontSize: 17,
              height: 1.5, // LineHeight.percent(125).size
              fontStyle:
                  item.word?.style?.italic == true ? FontStyle.italic : null,
              color: item.word?.color != null
                  ? Color(int.parse(
                      item.word!.color!.replaceFirst('#', 'FF'),
                      radix: 16,
                    ))
                  : null,
              decoration: item.word?.style?.strikethrough == true
                  ? TextDecoration.lineThrough
                  : null,
              fontWeight:
                  item.word?.style?.bold == true ? FontWeight.bold : null,
            ),
          );
        }).toList();
        return SelectableText.rich(TextSpan(children: spanList));
      } else if (item.line != null) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: CachedNetworkImage(
            imageUrl: item.line?.pic?.url?.http2https ?? '',
            height: item.line?.pic?.height?.toDouble(),
          ),
        );
      } else if (item.pic != null) {
        return Hero(
          tag: item.pic!.pics!.first.url!,
          child: GestureDetector(
            onTap: () {
              if (callback != null) {
                callback(
                  imgList,
                  imgList.indexOf(item.pic!.pics!.first.url!),
                );
              } else {
                context.imageView(
                  initialPage: imgList.indexOf(item.pic!.pics!.first.url!),
                  imgList: imgList.map((url) => SourceModel(url: url)).toList(),
                );
              }
            },
            child: NetworkImgLayer(
              width: maxWidth,
              height: maxWidth *
                  item.pic!.pics!.first.height! /
                  item.pic!.pics!.first.width!,
              src: item.pic!.pics!.first.url,
            ),
          ),
        );
      } else {
        return const SizedBox.shrink();
        // return Text('unsupported content');
      }
    },
    separatorBuilder: (context, index) => const SizedBox(height: 10),
  );
}
