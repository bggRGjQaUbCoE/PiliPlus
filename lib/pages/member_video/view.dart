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
import 'package:PiliPlus/pages/member_video/widgets/member_video_filter_dialog.dart';
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
            ..refreshKey.currentState?.show();
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
                        _controller.setIsLocating(true);
                        final locatedIndex = _controller.indexOfFromViewAid();
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
      Success() => Obx(() {
        final list = _controller.filteredList;
        if (list.isEmpty) {
          if (_controller.isEnd) {
            return _buildFilteredOutEnd(theme);
          }
          if (_controller.hasActiveFilter) {
            return _buildFilteredOutAutoLoading(theme);
          }
          return HttpError(onReload: _controller.onReload);
        }
        final mediaQuery = MediaQuery.of(context);
        // 过滤开启且未到底时，可见内容填不满当前页面就自动补载。
        // 尾项回调只在最后一项被构建时触发，填不满一屏时最后一项不会被构建，
        // 所以这里在列表构建后按视口尺寸单独调度。
        if (_controller.hasActiveFilter &&
            !_controller.isEnd &&
            widget.type != .season) {
          _controller.scheduleAutoLoadMore(
            viewportHeight: mediaQuery.size.height,
            crossAxisExtent: mediaQuery.size.width,
          );
        }
        return SliverMainAxisGroup(
          slivers: [
            _buildHeader(theme),
            SliverGrid.builder(
              gridDelegate: gridDelegate,
              itemBuilder: (context, index) {
                if (index == list.length - 1) {
                  if (widget.type == .season) {
                    // 合集类型无分页，到底即结束
                  } else if (!_controller.hasActiveFilter) {
                    _controller.onLoadMore();
                  } else {
                    // 过滤开启时尾项触发手动加载（节流），加载后自动重新过滤
                    _controller.manualLoadMore();
                  }
                }
                return VideoCardHMemberVideo(
                  videoItem: list[index],
                  fromViewAid: _controller.fromViewAid,
                );
              },
              itemCount: list.length,
            ),
            if (_controller.autoLoadPaused.value)
              SliverToBoxAdapter(child: _buildAutoLoadPaused(theme)),
          ],
        );
      }),
      Error(:final errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _controller.onReload,
      ),
    };
  }

  // 弹窗关闭后按当前视口尺寸重新过滤，不足一屏时自动补载
  void _applyFilterFromDialog() {
    final size = MediaQuery.sizeOf(context);
    _controller.onFilterChanged(
      viewportHeight: size.height,
      crossAxisExtent: size.width,
    );
  }

  // 连续自动翻页达到上限后的暂停提示，手动上拉可继续
  Widget _buildAutoLoadPaused(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Text(
        '已连续加载较多内容，上拉可继续加载',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 13,
          color: theme.colorScheme.outline,
        ),
      ),
    );
  }

  Widget _buildFilteredOutAutoLoading(ThemeData theme) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(height: 12),
            Text(
              _controller.isAutoLoading.value
                  ? '当前内容已被过滤，正在加载更多…'
                  : '当前过滤条件下暂无内容，可调整过滤或上拉加载更多',
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.outline,
              ),
            ),
            if (!_controller.isAutoLoading.value) ...[
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => MemberVideoFilterDialog.show(
                  context,
                  _controller.filter,
                ).whenComplete(_applyFilterFromDialog),
                child: const Text('调整过滤条件'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // 已到列表末尾且无符合项
  Widget _buildFilteredOutEnd(ThemeData theme) {
    // 无过滤时 isEnd 且空 = 真空数据态，恢复原版「没有数据 + 重试」
    if (!_controller.hasActiveFilter) {
      return HttpError(onReload: _controller.onReload);
    }
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.filter_list_off,
              size: 48,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 12),
            const Text(
              '没有更多了',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            TextButton(
              onPressed: () =>
                  MemberVideoFilterDialog.show(context, _controller.filter)
                      .whenComplete(_applyFilterFromDialog),
              child: const Text('调整过滤条件'),
            ),
          ],
        ),
      ),
    );
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
            _buildFilterBtn(theme),
            const SizedBox(width: 4),
            _buildSortBtn(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBtn(ThemeData theme) {
    // 依赖父级 Obx（filterActive/filteredList）重建，弹窗关闭后 onFilterChanged 会刷新列表
    return IconButton(
      tooltip: '筛选',
      style: const ButtonStyle(
        padding: WidgetStatePropertyAll(EdgeInsets.zero),
      ),
      onPressed: () => MemberVideoFilterDialog.show(
        context,
        _controller.filter,
      ).whenComplete(_applyFilterFromDialog),
      icon: Obx(() {
        final hasFilter = _controller.filterActive.value;
        return Icon(
          hasFilter ? Icons.filter_list : Icons.filter_list_off,
          size: 18,
          color: hasFilter
              ? theme.colorScheme.primary
              : theme.colorScheme.secondary,
        );
      }),
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
