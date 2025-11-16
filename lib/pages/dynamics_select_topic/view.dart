import 'dart:async';
import 'dart:math';

import 'package:PiliPlus/common/widgets/flutter/draggable_sheet/draggable_scrollable_sheet_topic.dart'
    as topic_sheet;
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_topic_top/topic_item.dart';
import 'package:PiliPlus/pages/dynamics_select_topic/controller.dart';
import 'package:PiliPlus/pages/dynamics_select_topic/widgets/item.dart';
import 'package:PiliPlus/pages/search/controller.dart' show DebounceStreamState;
import 'package:PiliPlus/utils/context_ext.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;

class SelectTopicPanel extends StatefulWidget {
  const SelectTopicPanel({
    super.key,
    this.scrollController,
    this.callback,
  });

  final ScrollController? scrollController;
  final ValueChanged<double>? callback;

  static Future<TopicItem?> onSelectTopic(
    BuildContext context, {
    double offset = 0,
    ValueChanged<double>? callback,
  }) {
    return showModalBottomSheet<TopicItem?>(
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
        builder: (context, scrollController) => SelectTopicPanel(
          scrollController: scrollController,
          callback: callback,
        ),
      ),
    );
  }

  @override
  State<SelectTopicPanel> createState() => _SelectTopicPanelState();
}

class _SelectTopicPanelState
    extends DebounceStreamState<SelectTopicPanel, String> {
  final _controller = Get.put(SelectTopicController());
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
  void onValueChanged(String value) => _controller
    ..enableClear.value = value.isNotEmpty
    ..onRefresh().whenComplete(
      () => WidgetsBinding.instance.addPostFrameCallback(
        (_) => widget.scrollController?.jumpToTop(),
      ),
    );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
              hintText: '搜索话题',
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
          child: NotificationListener<ScrollNotification>(
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
            child: Obx(() => _buildBody(theme, _controller.loadingState.value)),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(
    ThemeData theme,
    LoadingState<List<TopicItem>?> loadingState,
  ) {
    return switch (loadingState) {
      Loading() => loadingWidget,
      Success<List<TopicItem>?>(:var response) =>
        response?.isNotEmpty == true
            ? ListView.builder(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.viewPaddingOf(context).bottom + 100,
                ),
                controller: widget.scrollController,
                itemBuilder: (context, index) {
                  if (index == response.length - 1) {
                    _controller.onLoadMore();
                  }
                  return DynTopicItem(
                    item: response[index],
                    onTap: (item) => Get.back(result: item),
                  );
                },
                itemCount: response!.length,
              )
            : _errWidget(),
      Error(:var errMsg) => _errWidget(errMsg),
    };
  }

  Widget _errWidget([String? errMsg]) => scrollErrorWidget(
    errMsg: errMsg,
    controller: widget.scrollController,
    onReload: _controller.onReload,
  );
}
