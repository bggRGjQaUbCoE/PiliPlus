import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/skeleton/video_card_h.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/video_card/video_card_h.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/home_tab_type.dart';
import 'package:PiliPlus/models/model_hot_video_item.dart';
import 'package:PiliPlus/pages/common/common_page.dart';
import 'package:PiliPlus/pages/home/controller.dart';
import 'package:PiliPlus/pages/hot/controller.dart';
import 'package:PiliPlus/pages/rank/view.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HotPage extends CommonPage {
  const HotPage({super.key});

  @override
  State<HotPage> createState() => _HotPageState();
}

class _HotPageState extends CommonPageState<HotPage, HotController>
    with AutomaticKeepAliveClientMixin {
  @override
  HotController controller = Get.put(HotController());

  @override
  bool get wantKeepAlive => true;

  Widget _buildEntranceItem({
    required String iconUrl,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CachedNetworkImage(
              width: 35, height: 35, imageUrl: Utils.thumbnailImgUrl(iconUrl)),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return refreshIndicator(
      onRefresh: controller.onRefresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: controller.scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Obx(
              () => controller.showHotRcmd.value
                  ? Padding(
                      padding:
                          const EdgeInsets.only(left: 12, top: 12, right: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildEntranceItem(
                            iconUrl:
                                'http://i0.hdslb.com/bfs/archive/a3f11218aaf4521b4967db2ae164ecd3052586b9.png',
                            title: '排行榜',
                            onTap: () {
                              try {
                                HomeController homeController =
                                    Get.find<HomeController>();
                                int index = homeController.tabs
                                    .indexOf(HomeTabType.rank);
                                if (index != -1) {
                                  homeController.tabController.animateTo(index);
                                } else {
                                  Get.to(
                                    Scaffold(
                                      appBar: AppBar(title: const Text('排行榜')),
                                      body: const SafeArea(
                                        top: false,
                                        bottom: false,
                                        child: RankPage(),
                                      ),
                                    ),
                                  );
                                }
                              } catch (_) {}
                            },
                          ),
                          _buildEntranceItem(
                            iconUrl:
                                'http://i0.hdslb.com/bfs/archive/552ebe8c4794aeef30ebd1568b59ad35f15e21ad.png',
                            title: '每周必看',
                            onTap: () {
                              Get.toNamed(
                                '/webview',
                                parameters: {
                                  'url':
                                      'https://www.bilibili.com/h5/weekly-recommend'
                                },
                                arguments: {'off': false},
                              );
                            },
                          ),
                          _buildEntranceItem(
                            iconUrl:
                                'http://i0.hdslb.com/bfs/archive/3693ec9335b78ca57353ac0734f36a46f3d179a9.png',
                            title: '入站必刷',
                            onTap: () {
                              Get.toNamed(
                                '/webview',
                                parameters: {
                                  'url':
                                      'https://www.bilibili.com/h5/good-history'
                                },
                                arguments: {'off': false},
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(
              top: StyleString.safeSpace - 5,
              bottom: MediaQuery.of(context).padding.bottom + 80,
            ),
            sliver: Obx(
              () => _buildBody(controller.loadingState.value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return SliverGrid(
      gridDelegate: Grid.videoCardHDelegate(context),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return const VideoCardHSkeleton();
        },
        childCount: 10,
      ),
    );
  }

  Widget _buildBody(LoadingState<List<HotVideoItemModel>?> loadingState) {
    return switch (loadingState) {
      Loading() => _buildSkeleton(),
      Success(:var response) => response?.isNotEmpty == true
          ? SliverGrid(
              gridDelegate: Grid.videoCardHDelegate(context),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == response.length - 1) {
                    controller.onLoadMore();
                  }
                  return VideoCardH(
                    videoItem: response[index],
                    showPubdate: true,
                  );
                },
                childCount: response!.length,
              ),
            )
          : HttpError(
              onReload: controller.onReload,
            ),
      Error(:var errMsg) => HttpError(
          errMsg: errMsg,
          onReload: controller.onReload,
        ),
    };
  }
}
