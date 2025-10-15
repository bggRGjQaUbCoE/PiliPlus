import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/later_view_type.dart';
import 'package:PiliPlus/models/common/video/source_type.dart';
import 'package:PiliPlus/models_new/later/list.dart';
import 'package:PiliPlus/pages/later/base_controller.dart';
import 'package:PiliPlus/pages/later/controller.dart';
import 'package:PiliPlus/pages/later/widgets/video_card_h_later.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LaterViewChildPage extends StatefulWidget {
  const LaterViewChildPage({
    super.key,
    required this.laterViewType,
  });

  final LaterViewType laterViewType;

  @override
  State<LaterViewChildPage> createState() => _LaterViewChildPageState();
}

class _LaterViewChildPageState extends State<LaterViewChildPage>
    with AutomaticKeepAliveClientMixin, GridMixin {
  late final LaterController _laterController = Get.put(
    LaterController(widget.laterViewType),
    tag: widget.laterViewType.type.toString(),
  );
  late final _baseCtr = Get.putOrFind(LaterBaseController.new);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return refreshIndicator(
      onRefresh: _laterController.onRefresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _laterController.scrollController,
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(
              top: 7,
              bottom: MediaQuery.viewPaddingOf(context).bottom + 85,
            ),
            sliver: Obx(
              () => _buildBody(_laterController.loadingState.value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(LoadingState<List<LaterItemModel>?> loadingState) {
    return switch (loadingState) {
      Loading() => gridSkeleton,
      Success(:var response) =>
        response?.isNotEmpty == true
            ? SliverGrid.builder(
                gridDelegate: gridDelegate,
                itemBuilder: (context, index) {
                  if (index == response.length - 1) {
                    _laterController.onLoadMore();
                  }
                  var videoItem = response[index];
                  return VideoCardHLater(
                    index: index,
                    videoItem: videoItem,
                    ctr: _laterController,
                    onViewLater: (cid) {
                      PageUtils.toVideoPage(
                        bvid: videoItem.bvid,
                        cid: cid,
                        cover: videoItem.pic,
                        title: videoItem.title,
                        extraArguments: _baseCtr.isPlayAll.value
                            ? {
                                'oid': videoItem.aid,
                                'sourceType': SourceType.watchLater,
                                'count': _laterController
                                    .baseCtr
                                    .counts[LaterViewType.all],
                                'favTitle': '稍后再看',
                                'mediaId': _laterController.accountService.mid,
                                'desc': _laterController.asc.value,
                                'isContinuePlaying': index != 0,
                              }
                            : null,
                      );
                    },
                  );
                },
                itemCount: response!.length,
              )
            : HttpError(onReload: _laterController.onReload),
      Error(:var errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _laterController.onReload,
      ),
    };
  }

  @override
  bool get wantKeepAlive => true;
}
