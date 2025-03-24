import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/pages/search/widgets/search_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/utils/utils.dart';

@Deprecated('deprecated')
class IntroDetail extends StatelessWidget {
  const IntroDetail({
    super.key,
    this.videoDetail,
    this.videoTags,
  });
  final dynamic videoDetail;
  final dynamic videoTags;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: [
            InkWell(
              onTap: () => Get.back(),
              child: Container(
                height: 35,
                padding: const EdgeInsets.only(bottom: 2),
                child: Center(
                  child: Container(
                    width: 32,
                    height: 3,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(3))),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      videoDetail!.title,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        StatView(
                          context: context,
                          theme: 'gray',
                          value: videoDetail!.stat!.view,
                          size: 'medium',
                        ),
                        const SizedBox(width: 10),
                        StatDanMu(
                          context: context,
                          theme: 'gray',
                          value: videoDetail!.stat!.danmu,
                          size: 'medium',
                        ),
                        const SizedBox(width: 10),
                        Text(
                          Utils.dateFormat(videoDetail!.pubdate,
                              formatType: 'detail'),
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                    if (videoTags is List && videoTags.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: (videoTags as List)
                            .map(
                              (item) => SearchText(
                                fontSize: 13,
                                text: item['tag_name'],
                                onTap: (_) => Get.toNamed('/searchResult',
                                    parameters: {'keyword': item['tag_name']}),
                                onLongPress: (_) =>
                                    Utils.copyText(item['tag_name']),
                              ),
                            )
                            .toList(),
                      )
                    ],
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: SelectableRegion(
                        focusNode: FocusNode(),
                        selectionControls: MaterialTextSelectionControls(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              videoDetail!.bvid!,
                              style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text.rich(
                              style: const TextStyle(
                                height: 1.4,
                                // fontSize: 13,
                              ),
                              TextSpan(
                                children: [
                                  buildContent(context, videoDetail!),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  InlineSpan buildContent(BuildContext context, content) {
    final List descV2 = content.descV2;
    // type
    // 1 普通文本
    // 2 @用户
    final List<TextSpan> spanChildren = List.generate(descV2.length, (index) {
      final currentDesc = descV2[index];
      switch (currentDesc.type) {
        case 1:
          final List<InlineSpan> spanChildren = <InlineSpan>[];
          final RegExp urlRegExp = RegExp(Constants.urlPattern);
          final Iterable<Match> matches =
              urlRegExp.allMatches(currentDesc.rawText);

          int previousEndIndex = 0;
          for (final Match match in matches) {
            if (match.start > previousEndIndex) {
              spanChildren.add(TextSpan(
                  text: currentDesc.rawText
                      .substring(previousEndIndex, match.start)));
            }
            spanChildren.add(
              TextSpan(
                text: match.group(0),
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary), // 设置颜色为蓝色
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // 处理点击事件
                    try {
                      Utils.handleWebview(match.group(0)!);
                    } catch (err) {
                      SmartDialog.showToast(err.toString());
                    }
                  },
              ),
            );
            previousEndIndex = match.end;
          }

          if (previousEndIndex < currentDesc.rawText.length) {
            spanChildren.add(TextSpan(
                text: currentDesc.rawText.substring(previousEndIndex)));
          }

          final TextSpan result = TextSpan(children: spanChildren);
          return result;
        case 2:
          final Color colorSchemePrimary =
              Theme.of(context).colorScheme.primary;
          final String heroTag = Utils.makeHeroTag(currentDesc.bizId);
          return TextSpan(
            text: '@${currentDesc.rawText}',
            style: TextStyle(color: colorSchemePrimary),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.toNamed(
                  '/member?mid=${currentDesc.bizId}',
                  arguments: {'face': '', 'heroTag': heroTag},
                );
              },
          );
        default:
          return const TextSpan();
      }
    });
    return TextSpan(children: spanChildren);
  }
}
