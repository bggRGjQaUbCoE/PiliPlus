import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/skeleton/video_card_h.dart';
import 'package:PiliPlus/common/widgets/http_error.dart';
import 'package:PiliPlus/common/widgets/icon_button.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/video_card_h.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/model_hot_video_item.dart';
import 'package:PiliPlus/pages/later/controller.dart';
import 'package:PiliPlus/pages/later/view.dart'
    show LaterViewType, LaterViewTypeExt;
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
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
      onRefresh: () async {
        await _laterController.onRefresh();
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _laterController.scrollController,
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(
              top: 7,
              bottom: MediaQuery.of(context).padding.bottom + 85,
            ),
            sliver: Obx(
              () => _buildBody(_laterController.loadingState.value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(LoadingState<List<HotVideoItemModel>?> loadingState) {
    final theme = Theme.of(context);
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
      Success() => loadingState.response?.isNotEmpty == true
          ? SliverGrid(
              gridDelegate: Grid.videoCardHDelegate(context),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == loadingState.response!.length - 1) {
                    _laterController.onLoadMore();
                  }
                  var videoItem = loadingState.response![index];
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      VideoCardH(
                        videoItem: videoItem,
                        source: 'later',
                        onViewLater: (cid) {
                          PageUtils.toVideoPage(
                            'bvid=${videoItem.bvid}&cid=$cid',
                            arguments: {
                              'videoItem': videoItem,
                              'oid': videoItem.aid,
                              'heroTag': Utils.makeHeroTag(videoItem.bvid),
                              'sourceType': 'watchLater',
                              'count': _laterController
                                  .baseCtr.counts[LaterViewType.all],
                              'favTitle': '稍后再看',
                              'mediaId': _laterController.mid,
                              'desc': false,
                              'isContinuePlaying': index != 0,
                            },
                          );
                        },
                        onTap:
                            _laterController.baseCtr.enableMultiSelect.value.not
                                ? null
                                : () {
                                    _laterController.onSelect(index);
                                  },
                        onLongPress: () {
                          if (_laterController
                              .baseCtr.enableMultiSelect.value.not) {
                            _laterController.baseCtr.enableMultiSelect.value =
                                true;
                            _laterController.onSelect(index);
                          }
                        },
                      ),
                      Positioned(
                        top: 5,
                        left: 12,
                        bottom: 5,
                        child: IgnorePointer(
                          child: LayoutBuilder(
                            builder: (context, constraints) => AnimatedOpacity(
                              opacity: videoItem.checked == true ? 1 : 0,
                              duration: const Duration(milliseconds: 200),
                              child: Container(
                                alignment: Alignment.center,
                                height: constraints.maxHeight,
                                width: constraints.maxHeight *
                                    StyleString.aspectRatio,
                                decoration: BoxDecoration(
                                  borderRadius: StyleString.mdRadius,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                                child: SizedBox(
                                  width: 34,
                                  height: 34,
                                  child: AnimatedScale(
                                    scale: videoItem.checked == true ? 1 : 0,
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.easeInOut,
                                    child: IconButton(
                                      tooltip: '取消选择',
                                      style: ButtonStyle(
                                        padding: WidgetStateProperty.all(
                                            EdgeInsets.zero),
                                        backgroundColor:
                                            WidgetStateProperty.resolveWith(
                                          (states) {
                                            return theme.colorScheme.surface
                                                .withOpacity(0.8);
                                          },
                                        ),
                                      ),
                                      onPressed: null,
                                      icon: Icon(
                                        Icons.done_all_outlined,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 12,
                        bottom: 0,
                        child: iconButton(
                          tooltip: '移除',
                          context: context,
                          onPressed: () {
                            _laterController.toViewDel(
                              context,
                              index,
                              videoItem.aid,
                            );
                          },
                          icon: Icons.clear,
                          iconColor: theme.colorScheme.outline,
                          bgColor: Colors.transparent,
                        ),
                      ),
                    ],
                  );
                },
                childCount: loadingState.response!.length,
              ),
            )
          : HttpError(
              onReload: _laterController.onReload,
            ),
      Error() => HttpError(
          errMsg: loadingState.errMsg,
          onReload: _laterController.onReload,
        ),
    };
  }

  @override
  bool get wantKeepAlive => true;
}
