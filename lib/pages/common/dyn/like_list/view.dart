import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart'
    show platformAlwaysClampingPhysics;
import 'package:PiliPlus/grpc/bilibili/app/dynamic/v2.pb.dart'
    show ModuleAuthor;
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/dyn/common_dyn_page.dart';
import 'package:PiliPlus/pages/common/dyn/like_list/controller.dart';
import 'package:PiliPlus/pages/common/dyn/like_list/widgets/item.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart' hide ListTile;

class DynLikePage extends StatelessWidget {
  const DynLikePage({
    super.key,
    required this.id,
    this.isPortrait = true,
    required this.controller,
  });

  final Object id;
  final bool isPortrait;
  final DynLikeController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.loadingState.value == .loading()) {
      controller.queryData();
    }
    Widget buildBody(LoadingState<List<ModuleAuthor>?> state) {
      return switch (state) {
        Loading() => const SliverFillRemaining(child: m3eLoading),
        Success(:final response) =>
          response != null && response.isNotEmpty
              ? SliverList.builder(
                  itemCount: response.length,
                  itemBuilder: (context, index) {
                    if (index == response.length - 1) {
                      controller.onLoadMore();
                    }

                    return DynLikeItem(item: response[index]);
                  },
                )
              : HttpError(onReload: controller.onReload),
        Error(:final errMsg) => HttpError(
          errMsg: errMsg,
          onReload: controller.onReload,
        ),
      };
    }

    final child = CustomScrollView(
      key: const PageStorageKey(DynType.like),
      physics: isPortrait
          ? platformAlwaysClampingPhysics
          : const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: .only(
            bottom: MediaQuery.viewPaddingOf(context).bottom + 100,
          ),
          sliver: Obx(() => buildBody(controller.loadingState.value)),
        ),
      ],
    );
    if (isPortrait) return child;
    return refreshIndicator(onRefresh: controller.onRefresh, child: child);
  }
}
