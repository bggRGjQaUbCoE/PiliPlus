import 'package:PiliPlus/models_new/video/video_ai_conclusion/model_result.dart';
import 'package:PiliPlus/pages/common/slide/common_slide_page.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/widgets/selectable_text.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AiConclusionPanel extends CommonSlidePage {
  final AiConclusionResult item;

  const AiConclusionPanel({
    super.key,
    required this.item,
  });

  @override
  State<AiConclusionPanel> createState() => _AiDetailState();

  static Widget buildContent(
    BuildContext context,
    ThemeData theme,
    AiConclusionResult res, {
    Key? key,
    bool tap = true,
  }) {
    return CustomScrollView(
      key: key,
      shrinkWrap: !tap,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        if (res.summary?.isNotEmpty == true) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: selectableText(
                res.summary!,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ),
          ),
          if (res.outline?.isNotEmpty == true)
            SliverToBoxAdapter(
              child: Divider(
                height: 20,
                color: theme.dividerColor.withValues(alpha: 0.1),
                thickness: 6,
              ),
            ),
        ],
        if (res.outline?.isNotEmpty == true)
          SliverPadding(
            padding: EdgeInsets.only(
              left: 14,
              right: 14,
              bottom: !tap ? 0 : MediaQuery.viewPaddingOf(context).bottom + 100,
            ),
            sliver: SliverList.builder(
              itemCount: res.outline!.length,
              itemBuilder: (context, index) {
                final item = res.outline![index];
                return SelectionArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (index != 0) const SizedBox(height: 10),
                      Text(
                        item.title!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      ...?item.partOutline?.map(
                        (item) => Wrap(
                          children: [
                            Text.rich(
                              TextSpan(
                                style: TextStyle(
                                  fontSize: 14,
                                  color: theme.colorScheme.onSurface,
                                  height: 1.5,
                                ),
                                children: [
                                  TextSpan(
                                    text: DurationUtils.formatDuration(
                                      item.timestamp,
                                    ),
                                    style: tap
                                        ? TextStyle(
                                            color: theme.colorScheme.primary,
                                          )
                                        : null,
                                    recognizer: tap
                                        ? (TapGestureRecognizer()
                                            ..onTap = () {
                                              try {
                                                Get.find<VideoDetailController>(
                                                  tag: Get.arguments['heroTag'],
                                                ).plPlayerController.seekTo(
                                                  Duration(
                                                    seconds: item.timestamp!,
                                                  ),
                                                  isSeek: false,
                                                );
                                              } catch (_) {}
                                            })
                                        : null,
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
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _AiDetailState extends State<AiConclusionPanel>
    with SingleTickerProviderStateMixin, CommonSlideMixin {
  @override
  Widget buildPage(ThemeData theme) {
    return Material(
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          GestureDetector(
            onTap: Get.back,
            child: SizedBox(
              height: 35,
              child: Center(
                child: Container(
                  width: 32,
                  height: 3,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: const BorderRadius.all(Radius.circular(3)),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: enableSlide ? slideList(theme) : buildList(theme),
          ),
        ],
      ),
    );
  }

  late Key _key;
  late bool _isNested;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = PrimaryScrollController.of(context);
    _isNested = controller is ExtendedNestedScrollController;
    _key = ValueKey(controller.hashCode);
  }

  @override
  Widget buildList(ThemeData theme) {
    final child = AiConclusionPanel.buildContent(
      context,
      theme,
      widget.item,
      key: _key,
    );
    if (_isNested) {
      return ExtendedVisibilityDetector(
        uniqueKey: const Key('ai-conclusion'),
        child: child,
      );
    }
    return child;
  }
}
