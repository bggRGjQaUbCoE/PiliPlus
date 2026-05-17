import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/scaffold.dart';
import 'package:PiliPlus/common/widgets/video_card/video_card_h.dart';
import 'package:PiliPlus/common/widgets/view_sliver_safe_area.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/video/source_type.dart';
import 'package:PiliPlus/models/model_hot_video_item.dart';
import 'package:PiliPlus/pages/common/play_all_btn_mixin.dart';
import 'package:PiliPlus/pages/popular_precious/controller.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopularPreciousPage extends StatefulWidget {
  const PopularPreciousPage({super.key});

  @override
  State<PopularPreciousPage> createState() => _PopularPreciousPageState();
}

class _PopularPreciousPageState extends State<PopularPreciousPage>
    with GridMixin, PlayAllBtnMixin {
  final _controller = Get.put(PopularPreciousController());

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.viewPaddingOf(context);
    return scaffold(
      appBar: AppBar(title: const Text('入站必刷')),
      body: Stack(
        clipBehavior: .none,
        children: [
          refreshIndicator(
            onRefresh: _controller.onRefresh,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                ViewSliverSafeArea(
                  sliver: Obx(() => _buildBody(_controller.loadingState.value)),
                ),
              ],
            ),
          ),
          Positioned(
            right: padding.right,
            bottom: padding.bottom + kFloatingActionButtonMargin,
            child: Padding(
              padding: const .only(right: kFloatingActionButtonMargin),
              child: Obx(() {
                if (_controller.loadingState.value case Success(
                  :final response,
                )) {
                  return playAllBtn(() => toVideoPage(response!.first));
                }
                return const SizedBox.shrink();
              }),
            ),
          ),
        ],
      ),
    );
  }

  void toVideoPage(
    HotVideoItemModel item, {
    int index = 0,
    bool isPlayAll = true,
  }) {
    PageUtils.toVideoPage(
      bvid: item.bvid,
      cid: item.cid!,
      dimension: item.dimension,
      extraArguments: isPlayAll
          ? {
              'sourceType': SourceType.playlist,
              'favTitle': '入站必刷',
              'mediaId': _controller.mediaId,
              'desc': true,
              'oid': item.aid,
              'isContinuePlaying': index != 0,
            }
          : null,
    );
  }

  Widget _buildBody(LoadingState<List<HotVideoItemModel>?> value) {
    switch (value) {
      case Loading():
        return gridSkeleton;
      case Success<List<HotVideoItemModel>?>(:final response):
        return SliverGrid.builder(
          gridDelegate: gridDelegate,
          itemCount: response!.length,
          itemBuilder: (context, index) {
            final item = response[index];
            return VideoCardH(
              videoItem: item,
              onTap: () => toVideoPage(
                item,
                index: index,
                isPlayAll: isPlayAll.value,
              ),
            );
          },
        );
      case Error(:final errMsg):
        return HttpError(
          errMsg: errMsg,
          onReload: _controller.onReload,
        );
    }
  }
}
