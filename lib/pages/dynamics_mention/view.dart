import 'dart:async';
import 'dart:math';

import 'package:PiliPlus/common/widgets/custom_sliver_persistent_header_delegate.dart';
import 'package:PiliPlus/common/widgets/draggable_sheet/draggable_scrollable_sheet_topic.dart'
    as topic_sheet;
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_mention/group.dart';
import 'package:PiliPlus/pages/dynamics_mention/controller.dart';
import 'package:PiliPlus/pages/dynamics_mention/widgets/item.dart';
import 'package:PiliPlus/pages/search/controller.dart' show SearchState;
import 'package:PiliPlus/utils/context_ext.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;

class DynMentionPanel extends StatefulWidget {
  const DynMentionPanel({
    super.key,
    this.scrollController,
    this.callback,
  });

  final ScrollController? scrollController;
  final ValueChanged<double>? callback;

  static Future onDynMention(
    BuildContext context, {
    double offset = 0,
    ValueChanged<double>? callback,
  }) {
    return showModalBottomSheet(
      context: Get.context!,
      useSafeArea: true,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxWidth: min(600, context.mediaQueryShortestSide),
      ),
      builder: (context) => topic_sheet.DraggableScrollableSheet(
        expand: false,
        snap: true,
        minChildSize: 0,
        maxChildSize: 1,
        initialChildSize: offset == 0 ? 0.65 : 1,
        initialScrollOffset: offset,
        snapSizes: const [0.65],
        builder: (context, scrollController) => DynMentionPanel(
          scrollController: scrollController,
          callback: callback,
        ),
      ),
    );
  }

  @override
  State<DynMentionPanel> createState() => _DynMentionPanelState();
}

class _DynMentionPanelState extends SearchState<DynMentionPanel> {
  final _controller = Get.put(DynMentionController());
  @override
  Duration get duration => const Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    if (_controller.loadingState.value is Error) {
      _controller.onReload();
    }
  }

  @override
  void onKeywordChanged(String value) => _controller
    ..enableClear.value = value.isNotEmpty
    ..onRefresh().whenComplete(
      () => WidgetsBinding.instance.addPostFrameCallback(
        (_) => widget.scrollController?.jumpToTop(),
      ),
    );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = MediaQuery.paddingOf(context).bottom;
    final viewInset = MediaQuery.viewInsetsOf(context).bottom;
    return Column(
      children: [
        SizedBox(
          height: 35,
          child: Center(
            child: Container(
              width: 32,
              height: 3,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline,
                borderRadius: const BorderRadius.all(Radius.circular(3)),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 5),
          child: TextField(
            focusNode: _controller.focusNode,
            controller: _controller.controller,
            onChanged: ctr!.add,
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                gapPadding: 0,
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              isDense: true,
              filled: true,
              fillColor: theme.colorScheme.onInverseSurface,
              hintText: '输入你想@的人',
              hintStyle: const TextStyle(fontSize: 14),
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 12, right: 4),
                child: Icon(Icons.search, size: 20),
              ),
              prefixIconConstraints: const BoxConstraints(
                minHeight: 0,
                minWidth: 0,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 6,
              ),
              suffixIcon: Obx(
                () => _controller.enableClear.value
                    ? Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          child: Container(
                            padding: const EdgeInsetsDirectional.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.colorScheme.secondaryContainer,
                            ),
                            child: Icon(
                              Icons.clear,
                              size: 16,
                              color: theme.colorScheme.onSecondaryContainer,
                            ),
                          ),
                          onTap: () => _controller
                            ..enableClear.value = false
                            ..controller.clear()
                            ..onRefresh().whenComplete(
                              () =>
                                  WidgetsBinding.instance.addPostFrameCallback(
                                    (_) => widget.scrollController?.jumpToTop(),
                                  ),
                            ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              suffixIconConstraints: const BoxConstraints(
                minHeight: 0,
                minWidth: 0,
              ),
            ),
          ),
        ),
        Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is UserScrollNotification) {
                    if (_controller.focusNode.hasFocus) {
                      _controller.focusNode.unfocus();
                    }
                  } else if (notification is ScrollEndNotification) {
                    widget.callback?.call(notification.metrics.pixels);
                  }
                  return false;
                },
                child: CustomScrollView(
                  controller: widget.scrollController,
                  slivers: [
                    Obx(
                      () => _buildBody(theme, _controller.loadingState.value),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: padding + viewInset + 80,
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() {
                return Positioned(
                  right: 16,
                  bottom:
                      padding +
                      16 +
                      (_controller.showBtn.value ? viewInset : 0),
                  child: AnimatedSlide(
                    offset: _controller.showBtn.value
                        ? Offset.zero
                        : const Offset(0, 3),
                    duration: const Duration(milliseconds: 120),
                    child: FloatingActionButton(
                      onPressed: () {
                        if (_controller.mentionList.isNullOrEmpty) {
                          _controller.showBtn.value = false;
                          return;
                        }
                        Get.back(result: _controller.mentionList);
                        _controller.showBtn.value = false;
                      },
                      child: const Icon(Icons.check),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBody(
    ThemeData theme,
    LoadingState<List<MentionGroup>?> loadingState,
  ) {
    return switch (loadingState) {
      Loading() => SliverPadding(
        padding: const EdgeInsets.only(top: 8),
        sliver: linearLoading,
      ),
      Success<List<MentionGroup>?>(:var response) =>
        response?.isNotEmpty == true
            ? SliverMainAxisGroup(
                slivers: response!.map((group) {
                  if (group.items.isNullOrEmpty) {
                    return const SliverToBoxAdapter();
                  }
                  return SliverMainAxisGroup(
                    slivers: [
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: CustomSliverPersistentHeaderDelegate(
                          extent: 40,
                          needRebuild: true,
                          bgColor: theme.colorScheme.surface,
                          child: Container(
                            height: 40,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(group.groupName!),
                          ),
                        ),
                      ),
                      SliverList.builder(
                        itemCount: group.items!.length,
                        itemBuilder: (context, index) {
                          final item = group.items![index];
                          return DynMentionItem(
                            item: item,
                            onTap: () => Get.back(result: item),
                            onCheck: (value) =>
                                _controller.onCheck(value, item),
                          );
                        },
                      ),
                    ],
                  );
                }).toList(),
              )
            : HttpError(onReload: _controller.onReload),
      Error(:var errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _controller.onReload,
      ),
    };
  }
}
