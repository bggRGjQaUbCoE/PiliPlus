import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_forward/item.dart';
import 'package:PiliPlus/pages/dynamics_forward/controller.dart';
import 'package:PiliPlus/pages/dynamics_forward/widgets/item.dart';
import 'package:PiliPlus/utils/extension/get_ext.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class DynForwardPage extends StatefulWidget {
  const DynForwardPage({
    super.key,
    this.controller,
    this.embedded = false,
  });

  final DynForwardController? controller;
  final bool embedded;

  @override
  State<DynForwardPage> createState() => _DynForwardPageState();
}

class _DynForwardPageState extends State<DynForwardPage> {
  late final DynForwardController _controller;

  @override
  void initState() {
    super.initState();
    final controller = widget.controller;
    if (controller != null) {
      _controller = controller;
      return;
    }

    final arguments = Get.arguments;
    final argumentId = arguments is Map ? arguments['id'] : null;
    final id = Get.parameters['id'] ?? argumentId?.toString() ?? '';
    _controller = Get.putOrFind(
      () => DynForwardController(id),
      tag: 'dynamicForward-$id',
    );
  }

  Widget _buildContent(BuildContext context) {
    final padding = MediaQuery.viewPaddingOf(context);
    return Padding(
      padding: EdgeInsets.only(left: padding.left, right: padding.right),
      child: refreshIndicator(
        onRefresh: _controller.onRefresh,
        child: CustomScrollView(
          controller: _controller.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(bottom: padding.bottom + 100),
              sliver: Obx(
                () => _buildBody(_controller.loadingState.value),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final body = _buildContent(context);
    if (widget.embedded) {
      return body;
    }

    return SimpleScaffold(
      appBar: AppBar(
        title: Obx(() {
          final count = _controller.count.value;
          return Text(
            count < 0 ? '转发详情' : '转发详情 ${NumUtils.numFormat(count)}',
          );
        }),
      ),
      body: body,
    );
  }

  Widget _buildBody(LoadingState<List<DynForwardItem>?> state) {
    switch (state) {
      case Loading():
        return const SliverFillRemaining(child: m3eLoading);
      case Success(:final response):
        if (response != null && response.isNotEmpty) {
          return SliverList.separated(
            itemCount: response.length + 1,
            itemBuilder: (context, index) {
              if (index == response.length) {
                _controller.onLoadMore();
                return SizedBox(
                  height: 72,
                  child: Center(
                    child: Text(
                      _controller.isEnd ? '没有更多了' : '加载中...',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                );
              }
              return DynForwardItemWidget(item: response[index]);
            },
            separatorBuilder: (context, index) => Divider(
              height: 1,
              indent: 70,
              endIndent: 16,
              color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
            ),
          );
        }
        return HttpError(
          errMsg: '还没有人转发',
          onReload: _controller.onReload,
        );
      case Error(:final errMsg):
        return HttpError(
          errMsg: errMsg,
          onReload: _controller.onReload,
        );
    }
  }
}
