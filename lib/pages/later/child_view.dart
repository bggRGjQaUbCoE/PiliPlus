import 'package:PiliPlus/common/skeleton/video_card_h.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/later_view_type.dart';
import 'package:PiliPlus/models/common/video/source_type.dart';
import 'package:PiliPlus/models_new/later/list.dart';
import 'package:PiliPlus/pages/later/controller.dart';
import 'package:PiliPlus/pages/later/widgets/video_card_h_later.dart';
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
    with AutomaticKeepAliveClientMixin {
  late final LaterController _laterController = Get.put(
    LaterController(widget.laterViewType),
    tag: widget.laterViewType.type.toString(),
  );

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
              bottom: MediaQuery.paddingOf(context).bottom + 85,
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
      Loading() => SliverGrid(
        gridDelegate: Grid.videoCardHDelegate(context),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return const VideoCardHSkeleton();
          },
          childCount: 10,
        ),
      ),
      Success(:var response) =>
        response?.isNotEmpty == true
            ? SliverGrid(
                gridDelegate: Grid.videoCardHDelegate(context),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == response.length - 1) {
                      _laterController.onLoadMore();
                    }
                    var videoItem = response[index];
                    final enableMultiSelect =
                        _laterController.baseCtr.enableMultiSelect.value;
                    return VideoCardHLater(
                      videoItem: videoItem,
                      onViewLater: (cid) {
                        PageUtils.toVideoPage(
                          bvid: videoItem.bvid,
                          cid: cid,
                          cover: videoItem.pic,
                          title: videoItem.title,
                          extraArguments: {
                            'oid': videoItem.aid,
                            'sourceType': SourceType.watchLater,
                            'count': _laterController
                                .baseCtr
                                .counts[LaterViewType.all],
                            'favTitle': '稍后再看',
                            'mediaId': _laterController.accountService.mid,
                            'desc': false,
                            'isContinuePlaying': index != 0,
                          },
                        );
                      },
                      onTap: !enableMultiSelect
                          ? null
                          : () => _laterController.onSelect(videoItem),
                      onLongPress: enableMultiSelect
                          ? null
                          : () {
                              _laterController.baseCtr.enableMultiSelect.value =
                                  true;
                              _laterController.onSelect(videoItem);
                            },
                      onRemove: () => _laterController.toViewDel(
                        context,
                        index,
                        videoItem.aid,
                      ),
                    );
                  },
                  childCount: response!.length,
                ),
              )
            : HttpError(
                onReload: _laterController.onReload,
              ),
      Error(:var errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _laterController.onReload,
      ),
    };
  }

  @override
  bool get wantKeepAlive => true;
}
