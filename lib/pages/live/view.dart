import 'package:PiliPlus/common/widgets/loading_widget.dart';
import 'package:PiliPlus/common/widgets/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/self_sized_horizontal_list.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/live/item.dart';
import 'package:PiliPlus/pages/common/common_page.dart';
import 'package:PiliPlus/pages/live/controller.dart';
import 'package:PiliPlus/pages/live/widgets/live_item.dart';
import 'package:PiliPlus/pages/live/widgets/live_item_follow.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/skeleton/video_card_v.dart';
import 'package:PiliPlus/common/widgets/http_error.dart';

import '../../utils/grid.dart';

class LivePage extends CommonPage {
  const LivePage({super.key});

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends CommonPageState<LivePage, LiveController>
    with AutomaticKeepAliveClientMixin {
  @override
  LiveController controller = Get.put(LiveController());

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
            Obx(
              () => controller.isLogin.value
                  ? SliverPadding(
                      padding: EdgeInsets.symmetric(
                        vertical: StyleString.cardSpace,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: _buildFollowList(),
                      ),
                    )
                  : const SliverToBoxAdapter(),
            ),
            SliverPadding(
              padding: EdgeInsets.only(
                top: StyleString.cardSpace,
                bottom: MediaQuery.paddingOf(context).bottom + 80,
              ),
              sliver: Obx(() => _buildBody(controller.loadingState.value)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(LoadingState<List<LiveItemModel>?> loadingState) {
    return switch (loadingState) {
      Loading() => SliverGrid(
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
        ),
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
                (context, index) {
                  if (index == loadingState.response!.length - 1) {
                    controller.onLoadMore();
                  }
                  return LiveCardV(liveItem: loadingState.response![index]);
                },
                childCount: loadingState.response!.length,
              ),
            )
          : scrollErrorWidget(onReload: controller.onReload),
      Error() => HttpError(
          errMsg: loadingState.errMsg,
          onReload: controller.onReload,
        ),
    };
  }

  Widget _buildFollowList() {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Obx(
              () => Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: '我的关注  '),
                    TextSpan(
                      text: '${controller.liveCount.value}',
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    TextSpan(
                      text: '人正在直播',
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Get.to(_buildFollowListPage);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '查看更多',
                    style: TextStyle(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  Icon(
                    size: 20,
                    Icons.keyboard_arrow_right_outlined,
                    color: theme.colorScheme.outline,
                  ),
                ],
              ),
            ),
          ],
        ),
        Obx(() => _buildFollowBody(theme, controller.followListState.value)),
      ],
    );
  }

  Widget _buildFollowBody(ThemeData theme, LoadingState loadingState) {
    return switch (loadingState) {
      Loading() => SizedBox(
          height: 80,
          child: loadingWidget,
        ),
      Success() => (loadingState.response as List?)?.isNotEmpty == true
          ? MediaQuery.removePadding(
              context: context,
              removeLeft: context.orientation == Orientation.landscape,
              child: SelfSizedHorizontalList(
                gapSize: 5,
                childBuilder: (index) {
                  if (index == loadingState.response.length - 1) {
                    controller.fetchLiveFollowing(false);
                  }
                  return SizedBox(
                    width: 65,
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          '/liveRoom?roomid=${loadingState.response[index].roomId}',
                        );
                      },
                      onLongPress: () {
                        Feedback.forLongPress(context);
                        Get.toNamed(
                          '/member?mid=${loadingState.response[index].uid}',
                          arguments: {
                            'face': loadingState.response[index].face,
                            'heroTag': Utils.makeHeroTag(
                                loadingState.response[index].uid)
                          },
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 8),
                          Container(
                            margin: const EdgeInsets.all(2),
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.5,
                                color: theme.colorScheme.primary,
                                strokeAlign: BorderSide.strokeAlignOutside,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: NetworkImgLayer(
                              type: 'avatar',
                              width: 45,
                              height: 45,
                              src: loadingState.response[index].face,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            loadingState.response[index].uname,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: loadingState.response.length,
              ),
            )
          : const SizedBox.shrink(),
      Error() => GestureDetector(
          onTap: () {
            controller.fetchLiveFollowing();
          },
          child: Container(
            height: 80,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              loadingState.errMsg,
              textAlign: TextAlign.center,
            ),
          ),
        ),
    };
  }

  Widget get _buildFollowListPage => Scaffold(
        appBar: AppBar(
          title: Obx(
            () => Text('${controller.liveCount.value}人正在直播'),
          ),
        ),
        body: SafeArea(
          top: false,
          bottom: false,
          child: CustomScrollView(
            slivers: [
              Obx(() => _buildFollowListBody(controller.followListState.value)),
            ],
          ),
        ),
      );

  Widget _buildFollowListBody(LoadingState loadingState) {
    return switch (loadingState) {
      Success() || Loading() => SliverPadding(
          padding: EdgeInsets.only(
            top: StyleString.safeSpace,
            left: StyleString.safeSpace,
            right: StyleString.safeSpace,
            bottom: MediaQuery.paddingOf(context).bottom + 80,
          ),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithExtentAndRatio(
              mainAxisSpacing: StyleString.cardSpace,
              crossAxisSpacing: StyleString.cardSpace,
              maxCrossAxisExtent: Grid.smallCardWidth,
              childAspectRatio: StyleString.aspectRatio,
              mainAxisExtent: MediaQuery.textScalerOf(context).scale(90),
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (loadingState is Success &&
                    index == loadingState.response.length - 1) {
                  controller.fetchLiveFollowing(false);
                }
                return loadingState is Success
                    ? LiveCardVFollow(
                        liveItem: loadingState.response[index],
                      )
                    : const VideoCardVSkeleton();
              },
              childCount:
                  loadingState is Success ? loadingState.response.length : 10,
            ),
          ),
        ),
      Error() => HttpError(
          errMsg: loadingState.errMsg,
          onReload: () {
            controller
              ..followListState.value = LoadingState.loading()
              ..fetchLiveFollowing();
          },
        ),
    };
  }
}
