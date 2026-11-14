import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/dynamics/widgets/dynamic_panel.dart';
import 'package:PiliPlus/pages/dynamics_up/feed_controller.dart';
import 'package:PiliPlus/utils/extension/get_ext.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/waterfall.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

/// 「逐个浏览 UP」模式下的单页：一位 UP 的动态流
class DynUpFeedPage extends StatefulWidget {
  const DynUpFeedPage({super.key, required this.mid});

  /// -1 表示「全部动态」
  final int mid;

  @override
  State<DynUpFeedPage> createState() => _DynUpFeedPageState();
}

class _DynUpFeedPageState extends State<DynUpFeedPage>
    with AutomaticKeepAliveClientMixin, DynMixin {
  late final _tag = 'dynUpFeed${widget.mid}';
  late final controller = Get.putOrFind(
    () => DynUpFeedController(mid: widget.mid),
    tag: _tag,
  );

  @override
  void dispose() {
    Get.delete<DynUpFeedController>(tag: _tag, force: true);
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> onRefresh() => controller.onRefresh();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final refreshStyle = Pref.dynRefreshStyle;
    return refreshIndicator(
      key: controller.refreshKey,
      onRefresh: onRefresh,
      // 官方风格：指示器更贴近顶部，下拉一点点就会触发刷新
      displacement: refreshStyle == .official ? 12.0 : null,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: controller.scrollController,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 100),
            sliver: buildPage(
              Obx(() => _buildBody(controller.loadingState.value)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(LoadingState<List<DynamicItemModel>?> loadingState) {
    return switch (loadingState) {
      Loading() => dynSkeleton,
      Success(:final response) =>
        response != null && response.isNotEmpty
            ? GlobalData().dynamicsWaterfallFlow
                  ? SliverMasonryGrid(
                      crossAxisSpacing: 4,
                      gridDelegate: dynGridDelegate,
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _itemBuilder(response, index),
                        childCount: response.length,
                      ),
                    )
                  : SliverList.builder(
                      itemBuilder: (context, index) =>
                          _itemBuilder(response, index),
                      itemCount: response.length,
                    )
            : HttpError(onReload: controller.onReload),
      Error(:final errMsg) => HttpError(
        errMsg: errMsg,
        onReload: controller.onReload,
      ),
    };
  }

  Widget _itemBuilder(List<DynamicItemModel> list, int index) {
    if (index == list.length - 1) {
      controller.onLoadMore();
    }
    final item = list[index];
    return DynamicPanel(
      item: item,
      onRemove: (idStr) => controller.onRemove(index, idStr),
      onBlock: () => controller.onBlock(index),
      onUnfold: () => controller.onUnfold(item, index),
    );
  }
}
