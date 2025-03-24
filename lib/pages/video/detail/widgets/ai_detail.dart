import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/pages/common/common_collapse_slide_page.dart';
import 'package:PiliPlus/pages/video/detail/controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/models/video/ai.dart';
import 'package:PiliPlus/utils/utils.dart';

class AiDetail extends CommonCollapseSlidePage {
  final ModelResult modelResult;

  const AiDetail({
    super.key,
    required this.modelResult,
  });

  @override
  State<AiDetail> createState() => _AiDetailState();
}

class _AiDetailState extends CommonCollapseSlidePageState<AiDetail> {
  InlineSpan buildContent(BuildContext context, content) {
    List descV2 = content.descV2;
    // type
    // 1 普通文本
    // 2 @用户
    List<TextSpan> spanChildren = List.generate(descV2.length, (index) {
      final currentDesc = descV2[index];
      switch (currentDesc.type) {
        case 1:
          List<InlineSpan> spanChildren = [];
          RegExp urlRegExp = RegExp(Constants.urlPattern);
          Iterable<Match> matches = urlRegExp.allMatches(currentDesc.rawText);

          int previousEndIndex = 0;
          for (Match match in matches) {
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

          TextSpan result = TextSpan(children: spanChildren);
          return result;
        case 2:
          final colorSchemePrimary = Theme.of(context).colorScheme.primary;
          final heroTag = Utils.makeHeroTag(currentDesc.bizId);
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

  @override
  Widget get buildPage => Material(
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            GestureDetector(
              onTap: Get.back,
              child: Container(
                height: 35,
                padding: const EdgeInsets.only(bottom: 2),
                child: Center(
                  child: Container(
                    width: 32,
                    height: 3,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: const BorderRadius.all(Radius.circular(3)),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: enableSlide ? slideList() : buildList,
            ),
          ],
        ),
      );

  @override
  Widget get buildList => CustomScrollView(
        controller: ScrollController(),
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          if (widget.modelResult.summary?.isNotEmpty == true) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: SelectableText(
                  '总结: ${widget.modelResult.summary}',
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
              ),
            ),
            if (widget.modelResult.outline?.isNotEmpty == true)
              SliverToBoxAdapter(
                child: Divider(
                  height: 20,
                  color: Theme.of(context).dividerColor.withOpacity(0.1),
                  thickness: 6,
                ),
              ),
          ],
          if (widget.modelResult.outline?.isNotEmpty == true)
            SliverPadding(
              padding: EdgeInsets.only(
                left: 14,
                right: 14,
                bottom: MediaQuery.paddingOf(context).bottom + 80,
              ),
              sliver: SliverList.builder(
                itemCount: widget.modelResult.outline!.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (index != 0) const SizedBox(height: 10),
                      SelectableText(
                        widget.modelResult.outline![index].title!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      if (widget.modelResult.outline![index].partOutline
                              ?.isNotEmpty ==
                          true)
                        ...widget.modelResult.outline![index].partOutline!.map(
                          (item) => Wrap(
                            children: [
                              SelectableText.rich(
                                TextSpan(
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    height: 1.5,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          Utils.formatDuration(item.timestamp!),
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          // 跳转到指定位置
                                          try {
                                            Get.find<VideoDetailController>(
                                                    tag: Get
                                                        .arguments['heroTag'])
                                                .plPlayerController
                                                .seekTo(Duration(
                                                    seconds: item.timestamp!));
                                          } catch (_) {}
                                        },
                                    ),
                                    const TextSpan(text: ' '),
                                    TextSpan(text: item.content!),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
        ],
      );
}
