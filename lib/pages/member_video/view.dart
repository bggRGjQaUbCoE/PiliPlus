import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart'
    show ReloadScrollPhysics;
import 'package:PiliPlus/common/widgets/sliver/sliver_floating_header.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/member/contribute_type.dart';
import 'package:PiliPlus/models_new/space/space_archive/item.dart';
import 'package:PiliPlus/pages/common/fab_mixin.dart';
import 'package:PiliPlus/pages/member/controller.dart';
import 'package:PiliPlus/pages/member_video/controller.dart';
import 'package:PiliPlus/pages/member_video/widgets/video_card_h_member_video.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

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
    with
        AutomaticKeepAliveClientMixin,
        GridMixin,
        SingleTickerProviderStateMixin,
        BaseFabMixin,
        LazyFabMixin {
  @override
  bool get wantKeepAlive => true;

  late final MemberVideoCtr _controller;

  void _jumpToIndex(int index) {
    final scrollOffset = gridDelegate.layoutCache!
        .getGeometryForChildIndex(index)
        .scrollOffset;
    try {
      final state = Get.find<MemberController>(
        tag: widget.heroTag,
      ).scrollKey.currentState;
      if (state != null && state.mounted) {
        state.innerNestedPositions.first.localJumpTo(scrollOffset);
      }
    } catch (e) {
      if (kDebugMode) debugPrint('jump error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = Get.put(
      MemberVideoCtr(
        heroTag: widget.heroTag,
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

  Future<void> _loadPrevAndKeepPos() async {
    assert(_controller.hasPrev! && _controller.isLoadPrevious);
    final lastCount = _controller.loadingState.value.dataOrNull?.length;
    await _controller.queryData();
    if (mounted) {
      final newCount = _controller.loadingState.value.dataOrNull?.length;
      if (lastCount != null && newCount != null && newCount > lastCount) {
        _jumpToIndex(newCount - lastCount);
      }
    }
  }

  Future<void> _onRefresh() {
    if (_controller.isLoadPrevious) {
      return _loadPrevAndKeepPos();
    }
    return _controller.onRefresh();
  }

  @override
  Widget fabAnimWrapper({required Widget child}) {
    return NotificationListener<ScrollNotification>(
      onNotification: onNotification,
      child: child,
    );
  }

  @override
  bool onNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification) {
      return super.onNotification(notification);
    }
    if (_controller.isLocating) {
      if (notification is ScrollEndNotification &&
          notification.metrics.pixels == 0) {
        if (_controller.hasPrev == true && !_controller.isLoading) {
          _controller
            ..isLoadPrevious = true
            ..refreshKey!.currentState?.show();
        }
      }
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final padding = MediaQuery.viewPaddingOf(context);
    Widget child = CustomScrollView(
      physics: ReloadScrollPhysics(controller: _controller),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.only(bottom: padding.bottom + 100),
          sliver: Obx(
            () => _buildBody(theme, _controller.loadingState.value),
          ),
        ),
      ],
    );
    if (_controller.isVideo && _controller.fromViewAid?.isNotEmpty == true) {
      child = ScaffoldLayout(
        body: fabAnimWrapper(child: child),
        fab: Obx(
          () => !_controller.isLocating
              ? SlideTransition(
                  position: fabAnimation,
                  child: Padding(
                    padding: .only(
                      right: kFloatingActionButtonMargin,
                      bottom: kFloatingActionButtonMargin + padding.bottom,
                    ),
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        final fromViewAid = _controller.fromViewAid;
                        final locatedIndex =
                            _controller.loadingState.value.dataOrNull
                                ?.indexWhere(
                                  (i) => i.param == fromViewAid,
                                ) ??
                            -1;
                        if (locatedIndex == -1) {
                          _controller
                            ..setIsLocating(true)
                            ..lastAid = fromViewAid
                            ..reload = true
                            ..page = 0
                            ..loadingState.value = LoadingState.loading()
                            ..queryData();
                        } else {
                          _controller.setIsLocating(
                            true,
                            isOnlyInnerScroll: false,
                          );
                          _jumpToIndex(locatedIndex);
                        }
                      },
                      label: const Text('定位至上次观看'),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      );
    }
    return refreshIndicator(
      key: _controller.refreshKey,
      isClampingScrollPhysics: true,
      onRefresh: _onRefresh,
      child: child,
    );
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
