import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/log_table/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogPage<T> extends StatefulWidget {
  const LogPage({super.key});

  @override
  State<LogPage<T>> createState() => _LogPageState<T>();
}

class _LogPageState<T> extends State<LogPage<T>> {
  final _controller = Get.put<LogController<dynamic, T>>(Get.arguments);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_controller.title)),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: MediaQuery.paddingOf(context).bottom + 80,
                  ),
                  sliver: Obx(() => _buildBody(_controller.loadingState.value)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(LoadingState<List<T>?> loadingState) {
    return switch (loadingState) {
      Loading() => linearLoading,
      Success(:var response) =>
        response?.isNotEmpty == true
            ? Builder(
                builder: (context) {
                  final them = Theme.of(context);
                  final outline = them.colorScheme.outline.withValues(
                    alpha: 0.1,
                  );
                  final divider = Divider(
                    height: 1,
                    color: outline,
                  );
                  final sliverDivider = SliverToBoxAdapter(
                    child: divider,
                  );
                  final dividerV = VerticalDivider(
                    width: 1,
                    color: outline,
                  );
                  return SliverMainAxisGroup(
                    slivers: [
                      sliverDivider,
                      SliverToBoxAdapter(
                        child: ColoredBox(
                          color: them.colorScheme.onInverseSurface,
                          child: _item(
                            _controller.header,
                            dividerV,
                            isHeader: true,
                          ),
                        ),
                      ),
                      sliverDivider,
                      SliverList.separated(
                        itemCount: response!.length,
                        itemBuilder: (context, index) {
                          return _item(response[index], dividerV);
                        },
                        separatorBuilder: (context, index) => divider,
                      ),
                      sliverDivider,
                    ],
                  );
                },
              )
            : HttpError(onReload: _controller.onReload),
      Error(:var errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _controller.onReload,
      ),
    };
  }

  Widget _item(T item, Widget divider, {bool isHeader = false}) {
    Widget text(int flex, String text) => Expanded(
      flex: flex,
      child: Padding(
        padding: isHeader
            ? const EdgeInsets.symmetric(vertical: 6)
            : const EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: isHeader
                ? const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)
                : const TextStyle(fontSize: 13),
          ),
        ),
      ),
    );

    Widget content = Row(
      children: [
        divider,
        for (var (i, j) in _controller.getFlexAndText(item)) ...[
          text(i, j),
          divider,
        ],
      ],
    );
    return IntrinsicHeight(
      child: isHeader ? content : SelectionArea(child: content),
    );
  }
}
