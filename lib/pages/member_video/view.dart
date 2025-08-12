import 'package:PiliPlus/common/skeleton/video_card_h.dart';
import 'package:PiliPlus/common/widgets/custom_sliver_persistent_header_delegate.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/member/contribute_type.dart';
import 'package:PiliPlus/models_new/space/space_archive/item.dart';
import 'package:PiliPlus/pages/member/controller.dart';
import 'package:PiliPlus/pages/member_video/controller.dart';
import 'package:PiliPlus/pages/member_video/widgets/video_card_h_member_video.dart';
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
    this.isSingle = false,
  });

  final ContributeType type;
  final String? heroTag;
  final int mid;
  final int? seasonId;
  final int? seriesId;
  final String? title;
  final bool isSingle;

  @override
  State<MemberVideo> createState() => _MemberVideoState();
}

class _MemberVideoState extends State<MemberVideo>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final gridDelegate = Grid.videoCardHDelegate(context);

  late final _controller = Get.put(
    MemberVideoCtr(
      type: widget.type,
      mid: widget.mid,
      seasonId: widget.seasonId,
      seriesId: widget.seriesId,
      username: Get.find<MemberController>(tag: widget.heroTag).username,
      title: widget.title,
    ),
    tag:
        '${widget.heroTag}${widget.type.name}${widget.seasonId}${widget.seriesId}',
  );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        refreshIndicator(
          onRefresh: _controller.onRefresh,
          child: CustomScrollView(
            physics: ReloadScrollPhysics(controller: _controller),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.paddingOf(context).bottom + 80,
                ),
                sliver: Obx(
                  () => _buildBody(theme, _controller.loadingState.value),
                ),
              ),
            ],
          ),
        ),
        if (widget.type == ContributeType.video &&
            _controller.fromViewAid?.isNotEmpty == true)
          Obx(
            () => _controller.isLocating.value != true
                ? Positioned(
                    right: 15,
                    bottom: 15,
                    child: SafeArea(
                      top: false,
                      left: false,
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          final fromViewAid = _controller.fromViewAid;
                          _controller
                            ..isLocating.value = true
                            ..lastAid = fromViewAid;
                          final locatedIndex = _controller
                              .loadingState
                              .value
                              .dataOrNull
                              ?.indexWhere((i) => i.param == fromViewAid);
                          if (locatedIndex == null || locatedIndex == -1) {
                            _controller
                              ..page = 0
                              ..loadingState.value = LoadingState.loading()
                              ..queryData();
                          } else {
                            PrimaryScrollController.of(context).jumpTo(
                              gridDelegate.layoutCache!
                                  .getGeometryForChildIndex(locatedIndex)
                                  .scrollOffset,
                            );
                          }
                        },
                        label: const Text('定位至上次观看'),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
      ],
    );
  }

  Widget _buildBody(
    ThemeData theme,
    LoadingState<List<SpaceArchiveItem>?> loadingState,
  ) {
    return switch (loadingState) {
      Loading() => SliverPadding(
        padding: widget.isSingle
            ? const EdgeInsets.only(top: 7)
            : EdgeInsets.zero,
        sliver: SliverGrid(
          gridDelegate: Grid.videoCardHDelegate(context),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return const VideoCardHSkeleton();
            },
            childCount: 10,
          ),
        ),
      ),
      Success(:var response) =>
        response?.isNotEmpty == true
            ? SliverMainAxisGroup(
                slivers: [
                  SliverPersistentHeader(
                    pinned: false,
                    floating: true,
                    delegate: CustomSliverPersistentHeaderDelegate(
                      extent: 40,
                      bgColor: theme.colorScheme.surface,
                      child: SizedBox(
                        height: 40,
                        child: Row(
                          children: [
                            const SizedBox(width: 8),
                            Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: Obx(
                                () {
                                  final count = _controller.count.value;
                                  return Text(
                                    count != -1 ? '共$count视频' : '',
                                    style: const TextStyle(fontSize: 13),
                                  );
                                },
                              ),
                            ),
                            Obx(
                              () {
                                final episodicButton =
                                    _controller.episodicButton.value;
                                return episodicButton.uri?.isNotEmpty == true
                                    ? Container(
                                        height: 35,
                                        padding: EdgeInsets.only(
                                          left: _controller.count.value != -1
                                              ? 6
                                              : 0,
                                        ),
                                        child: TextButton.icon(
                                          onPressed: _controller.toViewPlayAll,
                                          icon: Icon(
                                            Icons.play_circle_outline_rounded,
                                            size: 16,
                                            color: theme.colorScheme.secondary,
                                          ),
                                          label: Text(
                                            episodicButton.text ?? '播放全部',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color:
                                                  theme.colorScheme.secondary,
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink();
                              },
                            ),
                            const Spacer(),
                            SizedBox(
                              height: 35,
                              child: TextButton.icon(
                                onPressed: _controller.queryBySort,
                                icon: Icon(
                                  Icons.sort,
                                  size: 16,
                                  color: theme.colorScheme.secondary,
                                ),
                                label: Obx(
                                  () => Text(
                                    widget.type == ContributeType.video
                                        ? _controller.order.value == 'pubdate'
                                              ? '最新发布'
                                              : '最多播放'
                                        : _controller.sort.value == 'desc'
                                        ? '默认'
                                        : '倒序',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: theme.colorScheme.secondary,
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
                  SliverGrid(
                    gridDelegate: gridDelegate,
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (widget.type != ContributeType.season &&
                            index == response.length - 1) {
                          _controller.onLoadMore();
                        }
                        return VideoCardHMemberVideo(
                          videoItem: response[index],
                          fromViewAid: _controller.fromViewAid,
                        );
                      },
                      childCount: response!.length,
                    ),
                  ),
                ],
              )
            : HttpError(
                onReload: _controller.onReload,
              ),
      Error(:var errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _controller.onReload,
      ),
    };
  }
}
