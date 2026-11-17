import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

/// Only native list content enters here; player and WebView surfaces do not.
class SliverListBody<R, T> extends StatefulWidget {
  const SliverListBody({
    super.key,
    required this.controller,
    required this.state,
    required this.builder,
    this.loading,
    this.emptyMessage = '暂无内容',
    this.emptyIcon = Icons.inbox_outlined,
    this.showEmptyRefresh = true,
  });
  final CommonListController<R, T> controller;
  final LoadingState<List<T>?> state;
  final Widget Function(List<T>) builder;
  final Widget? loading;
  final String emptyMessage;
  final IconData emptyIcon;
  final bool showEmptyRefresh;
  @override
  State<SliverListBody<R, T>> createState() => _SliverListBodyState<R, T>();
}

class _SliverListBodyState<R, T> extends State<SliverListBody<R, T>>
    with SingleTickerProviderStateMixin {
  late final _fade = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 180),
    value: 1,
  );
  bool _reduced = false;
  bool _hasItems(LoadingState<List<T>?> state) =>
      state.dataOrNull?.isNotEmpty == true;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduced = MediaQuery.disableAnimationsOf(context);
    if (_reduced) _fade.value = 1;
  }

  @override
  void didUpdateWidget(covariant SliverListBody<R, T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_hasItems(widget.state)) {
      _fade.value = 1;
      return;
    }
    if (!_hasItems(oldWidget.state) && _hasItems(widget.state)) {
      if (_reduced) {
        _fade.value = 1;
      } else {
        _fade.forward(from: 0);
      }
    }
  }

  @override
  void dispose() {
    _fade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = switch (widget.state) {
      Loading() =>
        widget.loading ??
            SliverToBoxAdapter(
              child: SizedBox(
                height: 160,
                child: Center(
                  child: _reduced
                      ? const Text('加载中…')
                      : const CircularProgressIndicator(),
                ),
              ),
            ),
      Success(:final response) =>
        response?.isNotEmpty == true
            ? widget.builder(response!)
            : HttpError.empty(
                message: widget.emptyMessage,
                icon: widget.emptyIcon,
                onRefresh: widget.showEmptyRefresh
                    ? widget.controller.retry
                    : null,
              ),
      Error(:final errMsg) => HttpError.failure(
        errMsg: errMsg,
        onRetry: widget.controller.retry,
      ),
    };
    return SliverMainAxisGroup(
      slivers: [
        if (_hasItems(widget.state))
          SliverToBoxAdapter(
            child: _RefreshFeedback(controller: widget.controller),
          ),
        SliverFadeTransition(opacity: _fade, sliver: child),
        if (_hasItems(widget.state))
          SliverToBoxAdapter(
            child: ListRequestFooter(controller: widget.controller),
          ),
      ],
    );
  }
}

class _RefreshFeedback extends StatelessWidget {
  const _RefreshFeedback({required this.controller});
  final CommonListController controller;
  @override
  Widget build(BuildContext context) => Obx(() {
    final error = controller.refreshError.value;
    final reduced = MediaQuery.disableAnimationsOf(context);
    final banner = error == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Icon(Icons.error_outline, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '刷新失败：${error.errMsg ?? '请求失败'}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                TextButton(
                  onPressed: controller.refreshing.value
                      ? null
                      : controller.retry,
                  child: const Text('重试'),
                ),
              ],
            ),
          );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 2,
          child: controller.refreshing.value
              ? (reduced
                    ? ColoredBox(color: ColorScheme.of(context).primary)
                    : const LinearProgressIndicator())
              : null,
        ),
        reduced
            ? banner
            : AnimatedSize(
                duration: const Duration(milliseconds: 180),
                child: banner,
              ),
      ],
    );
  });
}

class ListRequestFooter extends StatelessWidget {
  const ListRequestFooter({
    super.key,
    required this.controller,
    this.height = 60,
  });
  final CommonListController controller;
  final double height;
  @override
  Widget build(BuildContext context) => Obx(() {
    final error = controller.loadMoreError.value;
    final refreshError = controller.refreshError.value;
    final loading = controller.loadingMore.value;
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: height),
      child: Center(
        child: refreshError != null
            ? TextButton(
                onPressed: controller.refreshing.value
                    ? null
                    : controller.retry,
                child: const Text('刷新失败，点击重试刷新'),
              )
            : error != null
            ? TextButton(
                onPressed: loading ? null : controller.retryLoadMore,
                child: Text(
                  '加载更多失败：${error.errMsg ?? '请求失败'} · 重试',
                  textAlign: TextAlign.center,
                ),
              )
            : loading
            ? (MediaQuery.disableAnimationsOf(context)
                  ? const Text('加载中…')
                  : const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ))
            : controller.isEnd
            ? Text('没有更多了', style: Theme.of(context).textTheme.bodySmall)
            : const SizedBox.shrink(),
      ),
    );
  });
}
