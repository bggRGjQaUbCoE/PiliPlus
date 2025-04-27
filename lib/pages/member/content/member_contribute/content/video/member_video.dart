import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/custom_sliver_persistent_header_delegate.dart';
import 'package:PiliPlus/common/widgets/loading_widget.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:PiliPlus/common/widgets/video_card_h_member_video.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/space_archive/item.dart';
import 'package:PiliPlus/pages/member/content/member_contribute/content/video/member_video_ctr.dart';
import 'package:PiliPlus/pages/member/content/member_contribute/member_contribute.dart'
    show ContributeType;
import 'package:PiliPlus/pages/member/controller.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemberVideo extends StatefulWidget {
  const MemberVideo({
    super.key,
    required this.type,
    required this.heroTag,
    required this.mid,
    this.seasonId,
    this.seriesId,
    this.title,
  });

  final ContributeType type;
  final String? heroTag;
  final int mid;
  final int? seasonId;
  final int? seriesId;
  final String? title;

  @override
  State<MemberVideo> createState() => _MemberVideoState();
}

class _MemberVideoState extends State<MemberVideo>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final _controller = Get.put(
    MemberVideoCtr(
      type: widget.type,
      mid: widget.mid,
      seasonId: widget.seasonId,
      seriesId: widget.seriesId,
      username: Get.find<MemberControllerNew>(tag: widget.heroTag).username,
      title: widget.title,
    ),
    tag:
        '${widget.heroTag}${widget.type.name}${widget.seasonId}${widget.seriesId}',
  );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() => _buildBody(_controller.loadingState.value));
  }

  _buildBody(LoadingState<List<Item>?> loadingState) {
    return switch (loadingState) {
      Loading() => loadingWidget,
      Success() => loadingState.response?.isNotEmpty == true
          ? Stack(
              clipBehavior: Clip.none,
              children: [
                refreshIndicator(
                  onRefresh: () async {
                    await _controller.onRefresh();
                  },
                  child: CustomScrollView(
                    physics: PositionRetainedScrollPhysics(
                      shouldRetain: _controller.isLocating == true,
                      parent: ClampingScrollPhysics(),
                    ),
                    slivers: [
                      SliverPersistentHeader(
                        pinned: false,
                        floating: true,
                        delegate: CustomSliverPersistentHeaderDelegate(
                          extent: 40,
                          bgColor: Theme.of(context).colorScheme.surface,
                          child: SizedBox(
                            height: 40,
                            child: Row(
                              children: [
                                const SizedBox(width: 8),
                                Obx(
                                  () => Padding(
                                    padding: const EdgeInsets.only(left: 6),
                                    child: Text(
                                      _controller.count.value != -1
                                          ? '共${_controller.count.value}视频'
                                          : '',
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                ),
                                Obx(
                                  () => _controller.episodicButton.value.uri !=
                                          null
                                      ? Container(
                                          height: 35,
                                          padding: EdgeInsets.only(
                                              left:
                                                  _controller.count.value != -1
                                                      ? 6
                                                      : 0),
                                          child: TextButton.icon(
                                            onPressed:
                                                _controller.toViewPlayAll,
                                            icon: Icon(
                                              Icons.play_circle_outline_rounded,
                                              size: 16,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                            label: Text(
                                              _controller.episodicButton.value
                                                      .text ??
                                                  '播放全部',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ),
                                const Spacer(),
                                SizedBox(
                                  height: 35,
                                  child: TextButton.icon(
                                    onPressed: _controller.queryBySort,
                                    icon: Icon(
                                      Icons.sort,
                                      size: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                    label: Obx(
                                      () => Text(
                                        widget.type == ContributeType.video
                                            ? _controller.order.value ==
                                                    'pubdate'
                                                ? '最新发布'
                                                : '最多播放'
                                            : _controller.sort.value == 'desc'
                                                ? '默认'
                                                : '倒序',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.only(
                          top: StyleString.safeSpace - 5,
                          bottom: MediaQuery.of(context).padding.bottom + 80,
                        ),
                        sliver: SliverGrid(
                          gridDelegate: Grid.videoCardHDelegate(context),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (widget.type != ContributeType.season &&
                                  index == loadingState.response!.length - 1) {
                                _controller.onLoadMore();
                              }
                              final Item item = loadingState.response![index];
                              return VideoCardHMemberVideo(
                                key: ValueKey('${item.param}'),
                                videoItem: item,
                                fromViewAid: _controller.fromViewAid,
                              );
                            },
                            childCount: loadingState.response!.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.type == ContributeType.video &&
                    _controller.fromViewAid?.isNotEmpty == true &&
                    _controller.isLocating != true)
                  Positioned(
                    right: 15,
                    bottom: 15,
                    child: SafeArea(
                      top: false,
                      left: false,
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          _controller
                            ..isLocating = true
                            ..lastAid = _controller.fromViewAid
                            ..currentPage = 0
                            ..loadingState.value = LoadingState.loading()
                            ..queryData();
                        },
                        label: const Text('定位至上次观看'),
                      ),
                    ),
                  ),
              ],
            )
          : scrollErrorWidget(
              onReload: _controller.onReload,
            ),
      Error() => scrollErrorWidget(
          errMsg: loadingState.errMsg,
          onReload: _controller.onReload,
        ),
    };
  }
}
