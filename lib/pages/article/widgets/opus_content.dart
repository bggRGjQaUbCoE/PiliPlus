import 'dart:math';

import 'package:PiliPlus/common/widgets/image/custom_grid_view.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/models/common/image_preview_type.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models/dynamics/article_content_model.dart'
    show ArticleContentModel, Rich, Style, Word;
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/dynamics/widgets/vote.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/context_ext.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_svg_image/cached_network_svg_image.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:re_highlight/languages/all.dart';
import 'package:re_highlight/re_highlight.dart';
import 'package:re_highlight/styles/github-dark.dart';
import 'package:re_highlight/styles/github.dart';

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
        decoration: style?.strikethrough == true
            ? TextDecoration.lineThrough
            : null,
        decorationColor: color,
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
    ),
  );

  @override
  Widget build(BuildContext context) {
    // if (kDebugMode) debugPrint('opusContent');
    if (opus.isEmpty) {
      return const SliverToBoxAdapter();
    }

    late final highlight = Highlight()..registerLanguages(builtinAllLanguages);
    late final isDarkMode = context.isDarkMode;

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
                  children: element.text?.nodes?.map((item) {
                    switch (item.type) {
                      case 'TEXT_NODE_TYPE_RICH' when (item.rich != null):
                        Rich rich = item.rich!;
                        switch (rich.type) {
                          case 'RICH_TEXT_NODE_TYPE_EMOJI':
                            Emoji emoji = rich.emoji!;
                            final size = 20.0 * emoji.size;
                            return WidgetSpan(
                              child: NetworkImgLayer(
                                width: size,
                                height: size,
                                src: emoji.url,
                                type: ImageType.emote,
                              ),
                            );
                          default:
                            return TextSpan(
                              text:
                                  '${rich.type == 'RICH_TEXT_NODE_TYPE_WEB' ? '\u{1F517}' : ''}${item.rich!.text}',
                              style: _getStyle(
                                rich.style,
                                rich.type == 'RICH_TEXT_NODE_TYPE_TEXT'
                                    ? null
                                    : colorScheme.primary,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  switch (rich.type) {
                                    case 'RICH_TEXT_NODE_TYPE_AT':
                                      Get.toNamed('/member?mid=${rich.rid}');
                                    // case 'RICH_TEXT_NODE_TYPE_TOPIC':
                                    default:
                                      if (rich.jumpUrl != null) {
                                        PiliScheme.routePushFromUrl(
                                          rich.jumpUrl!,
                                        );
                                      }
                                  }
                                },
                            );
                        }
                      case 'TEXT_NODE_TYPE_FORMULA' when (item.formula != null):
                        final latex = item.formula!.latexContent!;
                        return WidgetSpan(
                          child: CachedNetworkSVGImage(
                            cacheKey: latex,
                            semanticsLabel: latex,
                            height: 65,
                            '${HttpString.apiBaseUrl}/x/web-frontend/mathjax/tex?formula=${Uri.encodeComponent(latex)}',
                            colorFilter: ColorFilter.mode(
                              colorScheme.onSurfaceVariant,
                              BlendMode.srcIn,
                            ),
                            alignment: Alignment.centerLeft,
                            placeholderBuilder: (_) => Text(latex),
                          ),
                        );
                      default:
                        return _getSpan(
                          item.word,
                          isQuote ? colorScheme.onSurfaceVariant : null,
                        );
                    }
                  }).toList(),
                ),
              );
              if (isQuote) {
                widget = Container(
                  padding: const EdgeInsets.only(
                    left: 8,
                    top: 4,
                    right: 4,
                    bottom: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: colorScheme.outlineVariant,
                        width: 4,
                      ),
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    color: colorScheme.onInverseSurface,
                  ),
                  child: widget,
                );
              }
              return widget;
            case 2 when (element.pic != null):
              if (element.pic!.pics!.length == 1) {
                final pic = element.pic!.pics!.first;
                final width = pic.width == null
                    ? null
                    : min(maxWidth.toDouble(), pic.width!);
                final height = width == null || pic.height == null
                    ? null
                    : width * pic.height! / pic.width!;
                return Hero(
                  tag: pic.url!,
                  child: GestureDetector(
                    onTap: () {
                      if (callback != null) {
                        callback!([pic.url!], 0);
                      } else {
                        PageUtils.imageView(
                          imgList: [SourceModel(url: pic.url!)],
                          quality: 60,
                        );
                      }
                    },
                    child: Center(
                      child: CachedNetworkImage(
                        width: width,
                        height: height,
                        imageUrl: ImageUtils.thumbnailUrl(pic.url!, 60),
                        fadeInDuration: const Duration(milliseconds: 120),
                        fadeOutDuration: const Duration(milliseconds: 120),
                        placeholder: (context, url) =>
                            Image.asset('assets/images/loading.png'),
                      ),
                    ),
                  ),
                );
              } else {
                return CustomGridView(
                  maxWidth: maxWidth,
                  picArr: element.pic!.pics!
                      .map(
                        (e) => ImageModel(
                          width: e.width,
                          height: e.height,
                          url: e.url!,
                        ),
                      )
                      .toList(),
                );
              }
            case 3 when (element.line != null):
              return CachedNetworkImage(
                width: maxWidth,
                fit: BoxFit.contain,
                height: element.line!.pic!.height?.toDouble(),
                imageUrl: ImageUtils.thumbnailUrl(element.line!.pic!.url!),
              );
            case 5 when (element.list != null):
              return SelectableText.rich(
                TextSpan(
                  children: element.list!.items?.indexed.map((entry) {
                    return TextSpan(
                      children: [
                        const WidgetSpan(
                          child: Icon(MdiIcons.circleMedium),
                          alignment: PlaceholderAlignment.middle,
                        ),
                        ...entry.$2.nodes!.map((item) {
                          if (item.word != null) {
                            return _getSpan(item.word);
                          }
                          if (item.rich case final rich?) {
                            final hasUrl = rich.jumpUrl?.isNotEmpty == true;
                            return TextSpan(
                              text: '${hasUrl ? '\u{1F517}' : ''}${rich.text}',
                              recognizer: hasUrl
                                  ? (TapGestureRecognizer()
                                      ..onTap = () =>
                                          PiliScheme.routePushFromUrl(
                                            rich.jumpUrl!,
                                          ))
                                  : null,
                              style: hasUrl
                                  ? TextStyle(color: colorScheme.primary)
                                  : null,
                            );
                          }
                          return const TextSpan();
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
                  onTap: element.linkCard!.card!.type == 'LINK_CARD_TYPE_GOODS'
                      ? null
                      : () {
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
                            String? url =
                                switch (element.linkCard!.card!.type) {
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
                                  _ => null,
                                };
                            if (url?.isNotEmpty == true) {
                              PiliScheme.routePushFromUrl(url!);
                            }
                          } catch (_) {}
                        },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: switch (element.linkCard?.card?.type) {
                      'LINK_CARD_TYPE_UGC' => Row(
                        spacing: 10,
                        children: [
                          NetworkImgLayer(
                            radius: 6,
                            width: 104,
                            height: 65,
                            src: element.linkCard!.card!.ugc!.cover,
                          ),
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
                          if (element
                                  .linkCard
                                  ?.card
                                  ?.itemNull
                                  ?.icon
                                  ?.isNullOrEmpty ==
                              true)
                            const Icon(Icons.info, size: 20),
                          Text(' ${element.linkCard?.card?.itemNull?.text}'),
                        ],
                      ),
                      'LINK_CARD_TYPE_COMMON' => Row(
                        spacing: 10,
                        children: [
                          NetworkImgLayer(
                            radius: 6,
                            width: 104,
                            height: 65,
                            src: element.linkCard!.card!.common!.cover,
                          ),
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
                        spacing: 10,
                        children: [
                          NetworkImgLayer(
                            radius: 6,
                            width: 104,
                            height: 65,
                            src: element.linkCard!.card!.live!.cover,
                          ),
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
                                if (element.linkCard!.card!.live!.descSecond !=
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
                        spacing: 10,
                        children: [
                          NetworkImgLayer(
                            radius: 6,
                            width: 104,
                            height: 65,
                            src: element.linkCard!.card!.opus!.cover,
                          ),
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
                        spacing: 10,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(6),
                              ),
                              color: colorScheme.secondaryContainer,
                            ),
                            width: 70,
                            height: 50,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.bar_chart_rounded,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
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
                        spacing: 10,
                        children: [
                          NetworkImgLayer(
                            radius: 6,
                            width: 104,
                            height: 65,
                            src: element.linkCard!.card!.music!.cover,
                          ),
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
                      'LINK_CARD_TYPE_GOODS' => Column(
                        children: element.linkCard!.card!.goods!.items!.map((
                          e,
                        ) {
                          return GestureDetector(
                            onTap: () {
                              if (e.jumpUrl?.isNotEmpty == true) {
                                PiliScheme.routePushFromUrl(e.jumpUrl!);
                              }
                            },
                            child: Row(
                              spacing: 10,
                              children: [
                                NetworkImgLayer(
                                  radius: 6,
                                  width: 104,
                                  height: 65,
                                  src: e.cover,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(e.name!),
                                      if (e.brief?.isNotEmpty == true)
                                        Text(
                                          e.brief!,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: colorScheme.outline,
                                          ),
                                        ),
                                      if (e.price?.isNotEmpty == true)
                                        Text(
                                          '${e.price!}起',
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
                          );
                        }).toList(),
                      ),
                      _ => throw UnimplementedError(
                        '\nparaType: ${element.paraType},\ncard type: ${element.linkCard?.card?.type}',
                      ),
                    },
                  ),
                ),
              );
            case 7 when (element.code != null):
              final renderer = TextSpanRenderer(
                const TextStyle(),
                isDarkMode ? githubDarkTheme : githubTheme,
              );
              highlight
                  .highlightAuto(
                    element.code!.content!,
                    element.code!.lang == 'language-clike'
                        ? const ['c', 'java']
                        : [
                            element.code!.lang!
                                .replaceAll('language-', '')
                                .replaceAll('like', ''),
                          ],
                  )
                  .render(renderer);
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
              if (kDebugMode) debugPrint('unknown type ${element.paraType}');
              if (element.text?.nodes?.isNotEmpty == true) {
                return SelectableText.rich(
                  textAlign: element.align == 1 ? TextAlign.center : null,
                  TextSpan(
                    children: element.text!.nodes!
                        .map<TextSpan>((item) => _getSpan(item.word))
                        .toList(),
                  ),
                );
              }

              return SelectableText(
                '不支持的类型 (${element.paraType})',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              );
          }
        } catch (e) {
          return SelectableText(
            '错误的类型 $e',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          );
        }
      },
      separatorBuilder: (context, index) => const SizedBox(height: 10),
    );
  }
}

Widget moduleBlockedItem(
  ThemeData theme,
  ModuleBlocked moduleBlocked,
  double maxWidth,
) {
  late final isDarkMode = Get.isDarkMode;

  BoxDecoration? bgImg() {
    return moduleBlocked.bgImg == null
        ? null
        : BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: CachedNetworkImageProvider(
                ImageUtils.thumbnailUrl(
                  isDarkMode
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
      imageUrl: ImageUtils.thumbnailUrl(
        isDarkMode ? moduleBlocked.icon!.imgDark : moduleBlocked.icon!.imgDay,
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
        backgroundColor: isDarkMode
            ? const Color(0xFF8F0030)
            : const Color(0xFFFF6699),
        foregroundColor: Colors.white,
        shape: shape,
      ),
      onPressed: () {
        if (moduleBlocked.button!.jumpUrl?.isNotEmpty == true) {
          PiliScheme.routePushFromUrl(moduleBlocked.button!.jumpUrl!);
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (moduleBlocked.button!.icon?.isNotEmpty == true)
            CachedNetworkImage(
              height: 16,
              color: Colors.white,
              imageUrl: moduleBlocked.button!.icon!.http2https,
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
            if (moduleBlocked.hintMessage?.isNotEmpty == true) ...[
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
      spacing: 8,
      children: [
        if (moduleBlocked.icon != null) icon(42),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 2,
            children: [
              if (moduleBlocked.title?.isNotEmpty == true)
                Text(moduleBlocked.title!),
              if (moduleBlocked.hintMessage?.isNotEmpty == true)
                Text(
                  moduleBlocked.hintMessage!,
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.outline,
                  ),
                ),
            ],
          ),
        ),
        if (moduleBlocked.button != null)
          btn(
            visualDensity: const VisualDensity(vertical: -3, horizontal: -4),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
          ),
      ],
    ),
  );
}

Widget opusCollection(ThemeData theme, ModuleCollection item) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Material(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      color: theme.colorScheme.onInverseSurface,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        onTap: () => Get.toNamed(
          '/articleList',
          parameters: {'id': '${item.id}'},
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title!),
                    Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(
                              size: 18,
                              Icons.article_outlined,
                              color: theme.colorScheme.outline,
                            ),
                          ),
                          TextSpan(
                            text: '${item.name} · ${item.count}',
                            style: TextStyle(
                              fontSize: 13,
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.keyboard_arrow_right,
                color: theme.colorScheme.outline,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
