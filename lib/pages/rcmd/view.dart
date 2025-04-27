import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/common_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/skeleton/video_card_v.dart';
import 'package:PiliPlus/common/widgets/http_error.dart';
import 'package:PiliPlus/common/widgets/video_card_v.dart';

import '../../utils/grid.dart';
import 'controller.dart';

class RcmdPage extends CommonPage {
  const RcmdPage({super.key});

  @override
  State<RcmdPage> createState() => _RcmdPageState();
}

class _RcmdPageState extends CommonPageState<RcmdPage, RcmdController>
    with AutomaticKeepAliveClientMixin {
  @override
  late RcmdController controller = Get.put(RcmdController());

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.only(
          left: StyleString.safeSpace, right: StyleString.safeSpace),
      decoration: BoxDecoration(
        borderRadius: StyleString.mdRadius,
      ),
      child: refreshIndicator(
        onRefresh: () async {
          await controller.onRefresh();
        },
        child: CustomScrollView(
          controller: controller.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(
                top: StyleString.cardSpace,
                bottom: MediaQuery.paddingOf(context).bottom,
              ),
              sliver: Obx(() => _buildBody(controller.loadingState.value)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(LoadingState<List<dynamic>?> loadingState) {
    return switch (loadingState) {
      Loading() => _buildSkeleton(),
      Success() => loadingState.response?.isNotEmpty == true
          ? SliverGrid(
              gridDelegate: SliverGridDelegateWithExtentAndRatio(
                mainAxisSpacing: StyleString.cardSpace,
                crossAxisSpacing: StyleString.cardSpace,
                maxCrossAxisExtent: Grid.smallCardWidth,
                childAspectRatio: StyleString.aspectRatio,
                mainAxisExtent: MediaQuery.textScalerOf(context).scale(90),
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (index == loadingState.response!.length - 1) {
                    controller.onLoadMore();
                  }
                  if (controller.lastRefreshAt != null) {
                    if (controller.lastRefreshAt == index) {
                      return GestureDetector(
                        onTap: () {
                          controller.animateToTop();
                          controller.onRefresh();
                        },
                        child: Card(
                          margin: EdgeInsets.zero,
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              '上次看到这里\n点击刷新',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    int actualIndex = controller.lastRefreshAt == null
                        ? index
                        : index > controller.lastRefreshAt!
                            ? index - 1
                            : index;
                    return VideoCardV(
                      videoItem: loadingState.response![actualIndex],
                      onRemove: () {
                        if (controller.lastRefreshAt != null &&
                            actualIndex < controller.lastRefreshAt!) {
                          controller.lastRefreshAt =
                              controller.lastRefreshAt! - 1;
                        }
                        ((controller.loadingState.value as Success).response
                                as List)
                            .removeAt(actualIndex);
                        controller.loadingState.refresh();
                      },
                    );
                  } else {
                    return VideoCardV(
                      videoItem: loadingState.response![index],
                      onRemove: () {
                        ((controller.loadingState.value as Success).response
                                as List)
                            .removeAt(index);
                        controller.loadingState.refresh();
                      },
                    );
                  }
                },
                childCount: controller.lastRefreshAt != null
                    ? loadingState.response!.length + 1
                    : loadingState.response!.length,
              ),
            )
          : HttpError(onReload: controller.onReload),
      Error() => HttpError(
          errMsg: loadingState.errMsg,
          onReload: controller.onReload,
        ),
    };
  }

  Widget _buildSkeleton() {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithExtentAndRatio(
        mainAxisSpacing: StyleString.cardSpace,
        crossAxisSpacing: StyleString.cardSpace,
        maxCrossAxisExtent: Grid.smallCardWidth,
        childAspectRatio: StyleString.aspectRatio,
        mainAxisExtent: MediaQuery.textScalerOf(context).scale(90),
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return const VideoCardVSkeleton();
        },
        childCount: 10,
      ),
    );
  }
}
