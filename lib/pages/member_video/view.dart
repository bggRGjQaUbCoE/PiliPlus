import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:PiliPlus/common/widgets/sliver/sliver_floating_header.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/member/contribute_type.dart';
import 'package:PiliPlus/models_new/space/space_archive/item.dart';
import 'package:PiliPlus/pages/member/controller.dart';
import 'package:PiliPlus/pages/member_video/controller.dart';
import 'package:PiliPlus/pages/member_video/widgets/video_card_h_member_video.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
    with AutomaticKeepAliveClientMixin, GridMixin {
  @override
  bool get wantKeepAlive => true;

  late final MemberVideoCtr _controller;

  int? _index;
  late ExtendedNestedScrollController _scrollController;

  void _jumpToIndex(int index) {
    final scrollOffset = gridDelegate.layoutCache!
        .getGeometryForChildIndex(index)
        .scrollOffset;
    try {
      _scrollController.nestedPositions
          .elementAt(_index!)
          .localJumpTo(scrollOffset);
    } catch (e) {
      _scrollController.jumpTo(scrollOffset);
      if (kDebugMode) debugPrint('jump error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = Get.put(
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
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final padding = MediaQuery.viewPaddingOf(context);
    final child = refreshIndicator(
      onRefresh: () async {
        final count = _controller.loadingState.value.dataOrNull?.length;
        await _controller.onRefresh();
        if (_controller.isLocating.value && mounted) {
          final newCount = _controller.loadingState.value.dataOrNull?.length;
          if (count != null && newCount != null && newCount > count) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              _jumpToIndex(newCount - count);
            });
          }
        }
      },
      child: CustomScrollView(
        physics: ReloadScrollPhysics(controller: _controller),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(bottom: padding.bottom + 100),
            sliver: Obx(
              () => _buildBody(theme, _controller.loadingState.value),
            ),
          ),
        ],
      ),
    );
    if (_controller.isVideo && _controller.fromViewAid?.isNotEmpty == true) {
      if (_index == null) {
        _scrollController =
            PrimaryScrollController.of(this.context)
                as ExtendedNestedScrollController;
        _index = _scrollController.nestedPositions.length;
      }
      return Stack(
        clipBehavior: Clip.none,
        children: [
          child,
          Obx(
            () => !_controller.isLocating.value
                ? Positioned(
                    right: kFloatingActionButtonMargin,
                    bottom: kFloatingActionButtonMargin + padding.bottom,
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        final fromViewAid = _controller.fromViewAid;
                        _controller.isLocating.value = true;
                        final locatedIndex =
                            _controller.loadingState.value.dataOrNull
                                ?.indexWhere((i) => i.param == fromViewAid) ??
                            -1;
                        if (locatedIndex == -1) {
                          _controller
                            ..lastAid = fromViewAid
                            ..reload = true
                            ..page = 0
                            ..loadingState.value = LoadingState.loading()
                            ..queryData();
                        } else {
                          _jumpToIndex(locatedIndex);
                        }
                      },
                      label: const Text('定位至上次观看'),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      );
    }
    return child;
  }

  @override
  Widget get gridSkeleton => SliverPadding(
    padding: widget.isSingle ? const EdgeInsets.only(top: 7) : EdgeInsets.zero,
    sliver: super.gridSkeleton,
  );

  Widget _buildBody(
    ThemeData theme,
    LoadingState<List<SpaceArchiveItem>?> loadingState,
  ) {
    return switch (loadingState) {
      Loading() => gridSkeleton,
      Success(:final response) =>
        response != null && response.isNotEmpty
            ? SliverMainAxisGroup(
                slivers: [
                  _buildHeader(theme),
                  SliverGrid.builder(
                    gridDelegate: gridDelegate,
                    itemBuilder: (context, index) {
                      if (widget.type != .season &&
                          index == response.length - 1) {
                        _controller.onLoadMore();
                      }
                      return VideoCardHMemberVideo(
                        videoItem: response[index],
                        fromViewAid: _controller.fromViewAid,
                      );
                    },
                    itemCount: response.length,
                  ),
                ],
              )
            : HttpError(onReload: _controller.onReload),
      Error(:final errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _controller.onReload,
      ),
    };
  }

  Widget _buildHeader(ThemeData theme) {
    return SliverFloatingHeaderWidget(
      backgroundColor: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 2.5, 8, 2.5),
        child: Row(
          children: [
            ?_buildCount(),
            ?_buildEpisodeBtn(theme),
            const Spacer(),
            _buildSortBtn(theme),
          ],
        ),
      ),
    );
  }

  Widget? _buildCount() {
    final count = _controller.count;
    if (count != null) {
      return Text(
        '共$count视频',
        style: const TextStyle(fontSize: 13),
      );
    }
    return null;
  }

  Widget? _buildEpisodeBtn(ThemeData theme) {
    final episodicButton = _controller.episodicButton;
    if (episodicButton?.uri?.isNotEmpty ?? false) {
      return Padding(
        padding: EdgeInsets.only(
          left: _controller.count != null ? 6 : 0,
        ),
        child: TextButton.icon(
          style: Style.buttonStyle,
          onPressed: _controller.toViewPlayAll,
          icon: Icon(
            Icons.play_circle_outline_rounded,
            size: 16,
            color: theme.colorScheme.secondary,
          ),
          label: Text(
            episodicButton?.text ?? '播放全部',
            style: TextStyle(
              fontSize: 13,
              color: theme.colorScheme.secondary,
            ),
          ),
        ),
      );
    }
    return null;
  }

  Widget _buildSortBtn(ThemeData theme) {
    return TextButton.icon(
      style: Style.buttonStyle,
      onPressed: _controller.queryBySort,
      icon: Icon(
        Icons.sort,
        size: 16,
        color: theme.colorScheme.secondary,
      ),
      label: Text(
        _controller.isVideo ? _controller.order.label : _controller.sort.label,
        style: TextStyle(
          fontSize: 13,
          color: theme.colorScheme.secondary,
        ),
      ),
    );
  }
}
