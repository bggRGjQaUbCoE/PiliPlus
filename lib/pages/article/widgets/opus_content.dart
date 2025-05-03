import 'dart:math';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/interactiveviewer_gallery/interactiveviewer_gallery.dart'
    show SourceModel;
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/pages/dynamics/widgets/vote.dart';
import 'package:PiliPlus/models/dynamics/article_content_model.dart'
    show ArticleContentModel, Style, Word;
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_svg_image/cached_network_svg_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  static TextSpan _getSpan(Word? word, [Color? defaultColor]) => TextSpan(
      text: word?.words,
      style: _getStyle(
        word?.style,
        word?.color != null ? Color(word!.color!) : defaultColor,
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
            case 1 || 4:
              final isQuote = element.paraType == 4;
              Widget widget = SelectableText.rich(
                textAlign: element.align == 1 ? TextAlign.center : null,
                TextSpan(
                    children: element.text?.nodes?.map<TextSpan>((item) {
                  if (item.rich != null) {
                    return TextSpan(
                      text: '\u{1F517}${item.rich!.text}',
                      style: _getStyle(item.rich!.style, colorScheme.primary),
                      recognizer: item.rich!.jumpUrl == null
                          ? null
                          : (TapGestureRecognizer()
                            ..onTap = () {
                              PiliScheme.routePushFromUrl(item.rich!.jumpUrl!);
                            }),
                    );
                  } else if (item.formula != null) {
                    // TEXT_NODE_TYPE_FORMULA
                    return TextSpan(
                      children: [
                        WidgetSpan(
                          child: SizedBox(
                            height: 65,
                            child: CachedNetworkSVGImage(
                              'https://api.bilibili.com/x/web-frontend/mathjax/tex?formula=${Uri.encodeComponent(item.formula!.latexContent!)}',
                              colorFilter: ColorFilter.mode(
                                colorScheme.onSurfaceVariant,
                                BlendMode.srcIn,
                              ),
                              alignment: Alignment.centerLeft,
                              placeholderBuilder: (context) =>
                                  const SizedBox.shrink(),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return _getSpan(
                      item.word, isQuote ? colorScheme.onSurfaceVariant : null);
                }).toList()),
              );
              if (isQuote) {
                widget = Container(
                  padding: const EdgeInsets.only(
                      left: 8, top: 4, right: 4, bottom: 4),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                          color: colorScheme.outlineVariant, width: 4),
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    color: colorScheme.onInverseSurface,
                  ),
                  child: widget,
                );
              }
              return widget;
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
            case 6:
              return Material(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                color: colorScheme.onInverseSurface,
                child: InkWell(
                  onTap: () {
                    try {
                      if (element.linkCard!.card!.type ==
                          'LINK_CARD_TYPE_VOTE') {
                        showVoteDialog(
                          context,
                          element.linkCard!.card!.vote?.voteId ??
                              int.parse(element.linkCard!.card!.oid!),
                        );
                        return;
                      }
                      String? url = switch (element.linkCard!.card!.type) {
                        'LINK_CARD_TYPE_UGC' =>
                          element.linkCard!.card!.ugc!.jumpUrl,
                        'LINK_CARD_TYPE_COMMON' =>
                          element.linkCard!.card!.common!.jumpUrl,
                        'LINK_CARD_TYPE_LIVE' =>
                          element.linkCard!.card!.live!.jumpUrl,
                        'LINK_CARD_TYPE_OPUS' =>
                          element.linkCard!.card!.opus!.jumpUrl,
                        'LINK_CARD_TYPE_MUSIC' =>
                          element.linkCard!.card!.music!.jumpUrl,
                        'LINK_CARD_TYPE_GOODS' =>
                          element.linkCard!.card!.goods!.jumpUrl,
                        _ => null,
                      };
                      if (url != null) {
                        PiliScheme.routePushFromUrl(url);
                      }
                    } catch (_) {}
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: switch (element.linkCard?.card?.type) {
                      'LINK_CARD_TYPE_UGC' => Row(
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
                      'LINK_CARD_TYPE_ITEM_NULL' => Row(
                          children: [
                            if (element.linkCard?.card?.itemNull?.icon
                                    ?.isNullOrEmpty ==
                                true)
                              Icon(Icons.info, size: 20),
                            Text(' ${element.linkCard?.card?.itemNull?.text}'),
                          ],
                        ),
                      'LINK_CARD_TYPE_COMMON' => Row(
                          children: [
                            NetworkImgLayer(
                              radius: 6,
                              width: 65 * StyleString.aspectRatio,
                              height: 65,
                              src: element.linkCard!.card!.common!.cover,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(element.linkCard!.card!.common!.title!),
                                  if (element.linkCard!.card!.common!.desc1 !=
                                      null)
                                    Text(
                                      element.linkCard!.card!.common!.desc1!,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: colorScheme.outline,
                                      ),
                                    ),
                                  if (element.linkCard!.card!.common!.desc2 !=
                                      null)
                                    Text(
                                      element.linkCard!.card!.common!.desc2!,
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
                      'LINK_CARD_TYPE_LIVE' => Row(
                          children: [
                            NetworkImgLayer(
                              radius: 6,
                              width: 65 * StyleString.aspectRatio,
                              height: 65,
                              src: element.linkCard!.card!.live!.cover,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(element.linkCard!.card!.live!.title!),
                                  if (element.linkCard!.card!.live!.descFirst !=
                                      null)
                                    Text(
                                      element.linkCard!.card!.live!.descFirst!,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: colorScheme.outline,
                                      ),
                                    ),
                                  if (element
                                          .linkCard!.card!.live!.descSecond !=
                                      null)
                                    Text(
                                      element.linkCard!.card!.live!.descSecond!,
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
                      'LINK_CARD_TYPE_OPUS' => Row(
                          children: [
                            NetworkImgLayer(
                              radius: 6,
                              width: 65 * StyleString.aspectRatio,
                              height: 65,
                              src: element.linkCard!.card!.opus!.cover,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(element.linkCard!.card!.opus!.title!),
                                  Text(
                                    '${element.linkCard!.card!.opus!.authorName} · ${element.linkCard!.card!.opus!.statView ?? 0}阅读',
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
                      'LINK_CARD_TYPE_VOTE' => Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(6),
                                ),
                                color: colorScheme.secondaryContainer,
                              ),
                              width: 75,
                              height: 50,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.bar_chart_rounded,
                                color: colorScheme.onSecondaryContainer,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(element.linkCard!.card!.vote!.desc!),
                                  Text(
                                    '${element.linkCard!.card!.vote!.joinNum}人参与',
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
                      'LINK_CARD_TYPE_MUSIC' => Row(
                          children: [
                            NetworkImgLayer(
                              radius: 6,
                              width: 65 * StyleString.aspectRatio,
                              height: 65,
                              src: element.linkCard!.card!.music!.cover,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(element.linkCard!.card!.music!.title!),
                                  if (element.linkCard!.card!.music!.label !=
                                      null)
                                    Text(
                                      element.linkCard!.card!.music!.label!,
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
                      'LINK_CARD_TYPE_GOODS' => Row(
                          children: [
                            NetworkImgLayer(
                              radius: 6,
                              width: 65 * StyleString.aspectRatio,
                              height: 65,
                              src: element
                                  .linkCard!.card!.goods!.items!.first.cover,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(element.linkCard!.card!.goods!.items!
                                      .first.name!),
                                  if (element.linkCard!.card!.goods!.items!
                                          .first.brief !=
                                      null)
                                    Text(
                                      element.linkCard!.card!.goods!.items!
                                          .first.brief!,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: colorScheme.outline,
                                      ),
                                    ),
                                  if (element.linkCard!.card!.goods!.items!
                                          .first.price !=
                                      null)
                                    Text(
                                      '${element.linkCard!.card!.goods!.items!.first.price!}起',
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
                      _ => throw UnimplementedError(
                          '\nparaType: ${element.paraType},\ncard type: ${element.linkCard?.card?.type}',
                        ),
                    },
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

Widget moduleBlockedItem(
    ThemeData theme, ModuleBlocked moduleBlocked, double maxWidth) {
  BoxDecoration? bgImg() {
    return moduleBlocked.bgImg == null
        ? null
        : BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: CachedNetworkImageProvider(
                Utils.thumbnailImgUrl(
                  Get.isDarkMode
                      ? moduleBlocked.bgImg!.imgDark
                      : moduleBlocked.bgImg!.imgDay,
                ),
              ),
            ),
          );
  }

  Widget icon(double width) {
    return CachedNetworkImage(
      width: width,
      fit: BoxFit.contain,
      imageUrl: Utils.thumbnailImgUrl(
        Get.isDarkMode
            ? moduleBlocked.icon!.imgDark
            : moduleBlocked.icon!.imgDay,
      ),
    );
  }

  Widget btn({
    OutlinedBorder? shape,
    VisualDensity? visualDensity,
    EdgeInsetsGeometry? padding,
  }) {
    return FilledButton.tonal(
      style: FilledButton.styleFrom(
        padding: padding,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: visualDensity,
        backgroundColor:
            Get.isDarkMode ? const Color(0xFF8F0030) : const Color(0xFFFF6699),
        foregroundColor: Colors.white,
        shape: shape,
      ),
      onPressed: () {
        if (moduleBlocked.button!.jumpUrl != null) {
          PiliScheme.routePushFromUrl(moduleBlocked.button!.jumpUrl!);
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (moduleBlocked.button!.icon != null)
            CachedNetworkImage(
              height: 16,
              color: Colors.white,
              imageUrl: moduleBlocked.button!.icon!,
            ),
          Text(moduleBlocked.button!.text ?? ''),
        ],
      ),
    );
  }

  if (moduleBlocked.blockedType == 1) {
    maxWidth = maxWidth <= 255 ? maxWidth : min(400, maxWidth * 0.8);
    return UnconstrainedBox(
      alignment: Alignment.centerLeft,
      child: Container(
        width: maxWidth,
        height: maxWidth,
        decoration: bgImg(),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (moduleBlocked.icon != null) icon(max(40, maxWidth / 7)),
            if (moduleBlocked.hintMessage != null) ...[
              const SizedBox(height: 5),
              Text(
                moduleBlocked.hintMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.colorScheme.outline),
              ),
            ],
            if (moduleBlocked.button != null) ...[
              const SizedBox(height: 8),
              btn(
                visualDensity: const VisualDensity(vertical: -2.5),
              ),
            ],
          ],
        ),
      ),
    );
  }
  return Container(
    decoration: bgImg(),
    padding: const EdgeInsets.all(12),
    child: Row(
      children: [
        if (moduleBlocked.icon != null) ...[
          icon(42),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (moduleBlocked.title != null) Text(moduleBlocked.title!),
              if (moduleBlocked.hintMessage != null) ...[
                const SizedBox(height: 2),
                Text(
                  moduleBlocked.hintMessage!,
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (moduleBlocked.button != null) ...[
          const SizedBox(width: 8),
          btn(
            visualDensity: const VisualDensity(vertical: -3, horizontal: -4),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
          ),
        ],
      ],
    ),
  );
}
