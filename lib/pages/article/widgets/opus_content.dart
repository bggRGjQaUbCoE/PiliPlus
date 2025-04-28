import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/interactiveviewer_gallery/interactiveviewer_gallery.dart'
    show SourceModel;
import 'package:PiliPlus/common/widgets/network_img_layer.dart';
import 'package:PiliPlus/models/dynamics/article_content_model.dart'
    show ArticleContentModel, Style, Word;
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:re_highlight/languages/all.dart';
import 'package:re_highlight/re_highlight.dart';
import 'package:re_highlight/styles/all.dart';

class OpusContent extends StatelessWidget {
  final List<ArticleContentModel> opus;
  final void Function(List<String>, int)? callback;
  final double maxWidth;

  const OpusContent({
    super.key,
    required this.opus,
    this.callback,
    required this.maxWidth,
  });

  static TextStyle _getStyle(Style? style, [Color? color, double? fontSize]) =>
      TextStyle(
        decoration:
            style?.strikethrough == true ? TextDecoration.lineThrough : null,
        fontStyle: style?.italic == true ? FontStyle.italic : null,
        fontWeight: style?.bold == true ? FontWeight.bold : null,
        color: color,
        fontSize: fontSize,
      );

  static TextSpan _getSpan(Word? word) => TextSpan(
      text: word?.words,
      style: _getStyle(
        word?.style,
        word?.color != null ? Color(word!.color!) : null,
        word?.fontSize,
      ));

  @override
  Widget build(BuildContext context) {
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
            case 1:
              return SelectableText.rich(
                textAlign: element.align == 1 ? TextAlign.center : null,
                TextSpan(
                    children: element.text?.nodes?.map<TextSpan>((item) {
                  if (item.rich != null) {
                    return TextSpan(
                      text: '\u{1F517}${item.rich?.text}',
                      style: _getStyle(item.rich?.style, colorScheme.primary),
                      recognizer: item.rich?.jumpUrl == null
                          ? null
                          : (TapGestureRecognizer()
                            ..onTap = () {
                              PiliScheme.routePushFromUrl(item.rich!.jumpUrl!);
                            }),
                    );
                  }
                  return _getSpan(item.word);
                }).toList()),
              );
            case 4:
              return Container(
                padding: const EdgeInsets.only(left: 8),
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(color: Color(0xFFE0E0E0), width: 4),
                  ),
                ),
                child: SelectableText.rich(
                  textAlign: element.align == 1 ? TextAlign.center : null,
                  TextSpan(
                      children: element.text?.nodes?.map<TextSpan>((item) {
                    if (item.rich != null) {
                      return TextSpan(
                        text: '\u{1F517}${item.rich?.text}',
                        style: _getStyle(item.rich?.style, colorScheme.primary),
                        recognizer: item.rich?.jumpUrl == null
                            ? null
                            : (TapGestureRecognizer()
                              ..onTap = () {
                                PiliScheme.routePushFromUrl(
                                    item.rich!.jumpUrl!);
                              }),
                      );
                    }
                    return TextSpan(
                        text: item.word?.words,
                        style: _getStyle(
                          item.word?.style,
                          item.word?.color != null
                              ? Color(item.word!.color!).withOpacity(0.7)
                              : colorScheme.onSurface.withOpacity(0.7),
                          item.word?.fontSize,
                        ));
                  }).toList()),
                ),
              );
            case 2 when (element.pic != null):
              element.pic!.pics!.first.onCalHeight(maxWidth);
              return Hero(
                tag: element.pic!.pics!.first.url!,
                child: GestureDetector(
                  onTap: () {
                    if (callback != null) {
                      callback!([element.pic!.pics!.first.url!], 0);
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
                    height: element.pic!.pics!.first.calHeight,
                    src: element.pic!.pics!.first.url!,
                    quality: 60,
                  ),
                ),
              );
            case 3 when (element.line != null):
              return CachedNetworkImage(
                width: maxWidth,
                fit: BoxFit.contain,
                height: element.line!.pic!.height?.toDouble(),
                imageUrl: Utils.thumbnailImgUrl(element.line!.pic!.url!),
              );
            case 5 when (element.list != null):
              return SelectableText.rich(
                TextSpan(
                  children: element.list!.items?.indexed.map((entry) {
                    return TextSpan(
                      children: [
                        WidgetSpan(
                          child: Icon(MdiIcons.circleMedium),
                          alignment: PlaceholderAlignment.middle,
                        ),
                        ...entry.$2.nodes!.map((item) {
                          return _getSpan(item.word);
                        }),
                        if (entry.$1 < element.list!.items!.length - 1)
                          const TextSpan(text: '\n'),
                      ],
                    );
                  }).toList(),
                ),
              );
            case 6 when (element.linkCard?.card?.ugc != null):
              return Material(
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
                          width: 65 * StyleString.aspectRatio,
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
            case 7 when (element.code != null):
              final Highlight highlight = Highlight()
                ..registerLanguages(builtinAllLanguages);
              final HighlightResult result = highlight.highlightAuto(
                  element.code!.content!,
                  element.code!.lang == 'language-clike'
                      ? const ['c', 'java']
                      : [
                          element.code!.lang!
                              .replaceAll('language-', '')
                              .replaceAll('like', ''),
                        ]);
              final TextSpanRenderer renderer = TextSpanRenderer(
                  const TextStyle(), builtinAllThemes['github']!);
              result.render(renderer);
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  color: colorScheme.onInverseSurface,
                ),
                width: double.infinity,
                child: SelectableText.rich(renderer.span!),
              );
            default:
              debugPrint('unknown type ${element.paraType}');
              if (element.text?.nodes?.isNotEmpty == true) {
                return SelectableText.rich(
                  textAlign: element.align == 1 ? TextAlign.center : null,
                  TextSpan(
                      children: element.text!.nodes!
                          .map<TextSpan>((item) => _getSpan(item.word))
                          .toList()),
                );
              }

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
}
