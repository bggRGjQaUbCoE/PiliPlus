import 'dart:math' show max;

import 'package:PiliPlus/common/widgets/scroll_physics.dart' show ReloadMixin;
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/member.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/models/common/member/archive_order_type_app.dart';
import 'package:PiliPlus/models/common/member/archive_sort_type_app.dart';
import 'package:PiliPlus/models/common/member/contribute_type.dart';
import 'package:PiliPlus/models/common/video/source_type.dart';
import 'package:PiliPlus/models_new/space/space_archive/data.dart';
import 'package:PiliPlus/models_new/space/space_archive/episodic_button.dart';
import 'package:PiliPlus/models_new/space/space_archive/item.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/pages/member/controller.dart';
import 'package:PiliPlus/pages/member_video/video_filter.dart';
import 'package:PiliPlus/utils/extension/dimension_ext.dart';
import 'package:PiliPlus/utils/extension/iterable_ext.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:get/get.dart';
import 'package:flutter/rendering.dart'
    show
        AxisDirection,
        GrowthDirection,
        ScrollDirection,
        SliverConstraints,
        SliverGridDelegate,
        SliverGridRegularTileLayout;
import 'package:flutter/scheduler.dart' show SchedulerBinding;

class MemberVideoCtr
    extends CommonListController<SpaceArchiveData, SpaceArchiveItem>
    with ReloadMixin {
  MemberVideoCtr({
    required this.heroTag,
    required this.type,
    required this.mid,
    required this.seasonId,
    required this.seriesId,
    this.username,
    this.title,
    Future<LoadingState<SpaceArchiveData>> Function({
      required ContributeType type,
      required int? mid,
      String? aid,
      ArchiveOrderTypeApp? order,
      ArchiveSortTypeApp? sort,
      int? pn,
      int? next,
      int? seasonId,
      int? seriesId,
      bool? includeCursor,
    })?
    archiveLoader,
    SliverGridDelegate? gridDelegate,
  }) : isVideo = type == .video,
       _archiveLoader = archiveLoader ?? MemberHttp.spaceArchive,
       gridDelegate = gridDelegate ?? Grid.videoCardHDelegate();

  final String? heroTag;
  final ContributeType type;
  final bool isVideo;
  int? seasonId;
  int? seriesId;
  final int mid;

  /// 视频列表的数据源。默认走 [MemberHttp.spaceArchive]，测试可注入替身。
  final Future<LoadingState<SpaceArchiveData>> Function({
    required ContributeType type,
    required int? mid,
    String? aid,
    ArchiveOrderTypeApp? order,
    ArchiveSortTypeApp? sort,
    int? pn,
    int? next,
    int? seasonId,
    int? seriesId,
    bool? includeCursor,
  })
  _archiveLoader;
  late ArchiveOrderTypeApp order = .pubdate;
  late ArchiveSortTypeApp sort = .desc;
  int? count;
  int? next;
  EpisodicButton? episodicButton;
  final String? username;
  final String? title;

  /// 与列表页 [GridMixin] 使用同一委托，供「是否铺满一屏」按行高估算。
  /// 测试可注入固定委托，避免依赖本地存储里的卡片宽度。
  final SliverGridDelegate gridDelegate;

  String? firstAid;
  String? lastAid;
  String? fromViewAid;
  final RxBool _isLocating = false.obs;
  bool get isLocating => _isLocating.value;
  void setIsLocating(bool value, {bool isOnlyInnerScroll = true}) {
    _isLocating.value = value;
    if (isOnlyInnerScroll) {
      onlyInnerScroll = value;
    }
  }

  set onlyInnerScroll(bool value) {
    final state = Get.find<MemberController>(tag: heroTag)
        .scrollKey
        .currentState;
    if (state != null && state.mounted) {
      state.onlyInnerScroll = value;
    }
  }

  bool isLoadPrevious = false;
  bool? hasPrev;

  // 客户端本地过滤：播放量区间 + 已观看状态，页面生命周期内有效
  final MemberVideoFilter filter = MemberVideoFilter();
  final RxList<SpaceArchiveItem> filteredList = <SpaceArchiveItem>[].obs;
  final RxBool isAutoLoading = false.obs;
  // 自动补载因达到连续翻页上限而暂停：区别于「请求失败 / 无进展」的普通停止，
  // 供列表给出可理解的提示；用户手动上拉后续页后清除
  final RxBool autoLoadPaused = false.obs;
  // 一次自动补载允许连续请求的页数上限，防止接口异常或超长列表时无限请求
  static const int autoLoadMaxPages = 50;
  // 过滤是否激活的响应式标记，供 FAB 等 Obx 依赖；与 filter.hasActiveFilter 保持同步
  final RxBool filterActive = false.obs;
  bool get hasActiveFilter => filter.hasActiveFilter;

  List<SpaceArchiveItem> applyFilter() {
    filterActive.value = filter.hasActiveFilter;
    final list = loadingState.value.dataOrNull;
    if (list == null) {
      return filteredList.value = const [];
    }
    if (!hasActiveFilter) {
      return filteredList.value = list;
    }
    return filteredList.value = list
        .where((item) => !filter.shouldHide(item))
        .toList();
  }

  // 过滤开启时尾项触发的手动加载：节流防请求风暴，复用 onLoadMore 的 isEnd/isLoading 守卫。
  // 手动上拉是用户主动继续，清除「已达上限」暂停态，允许后续再次触发自动补载
  int _lastManualLoadTime = 0;
  void manualLoadMore() {
    if (isAutoLoading.value || isLocating) return;
    if (isLoading || isEnd) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastManualLoadTime < 1200) return;
    _lastManualLoadTime = now;
    autoLoadPaused.value = false;
    onLoadMore();
  }

  // 过滤后可见内容是否不足以铺满当前页面。
  // 作者页列表嵌在 ExtendedNestedScrollView 的 body 内，内层滚动位置不可直接读取，
  // 因此按视口高度与网格行高估算：可见行数少于一屏能容纳的行数即视为未铺满。
  // 视口高度未知（如未挂载）时按未铺满处理，使自动补载仍能推进。
  bool filteredContentFillsViewport({
    required int visibleCount,
    required double? viewportHeight,
    required double crossAxisExtent,
  }) {
    if (visibleCount <= 0) return false;
    if (viewportHeight == null || viewportHeight <= 0) return false;
    final grid = gridDelegate;
    final layout = grid.getLayout(
      SliverConstraints(
        axisDirection: AxisDirection.down,
        growthDirection: GrowthDirection.forward,
        userScrollDirection: ScrollDirection.idle,
        scrollOffset: 0,
        precedingScrollExtent: 0,
        overlap: 0,
        remainingPaintExtent: viewportHeight,
        crossAxisExtent: crossAxisExtent > 0 ? crossAxisExtent : 1,
        crossAxisDirection: AxisDirection.right,
        viewportMainAxisExtent: viewportHeight,
        remainingCacheExtent: viewportHeight,
        cacheOrigin: 0,
      ),
    );
    final tile = layout as SliverGridRegularTileLayout;
    final crossAxisCount = max(1, tile.crossAxisCount);
    final mainAxisSpacing = switch (grid) {
      SliverGridDelegateWithExtentAndRatio(:final mainAxisSpacing) =>
        mainAxisSpacing,
      SliverGridDelegateWithMaxCrossAxisExtent(:final mainAxisSpacing) =>
        mainAxisSpacing,
      _ => 0.0,
    };
    final rowStride = tile.childMainAxisExtent + mainAxisSpacing;
    if (rowStride <= 0) return true;
    // 头部（计数 / 播放全部 / 筛选 / 排序）占去约一行的高度
    const headerExtent = 48.0;
    final rowsPerViewport = max(
      1,
      ((viewportHeight - headerExtent) / rowStride).floor(),
    );
    return (visibleCount / crossAxisCount).ceil() >= rowsPerViewport;
  }

  Future<void>? _autoLoadTask;

  // 开启过滤后，只要过滤结果不足以铺满当前页面且未到底，就自动补载下一页，
  // 直到铺满、到底、请求失败、无进展或达到连续翻页上限；避免请求风暴。
  // 返回本次补载的 Future，重复触发时返回正在进行的那次。
  Future<void> _autoLoadMoreLoop({
    double? viewportHeight,
    double crossAxisExtent = 0,
    int? maxPages,
  }) {
    final running = _autoLoadTask;
    if (running != null) return running;
    final task = _runAutoLoadMore(
      viewportHeight: viewportHeight,
      crossAxisExtent: crossAxisExtent,
      maxPages: maxPages,
    );
    _autoLoadTask = task;
    return task.whenComplete(() {
      if (identical(_autoLoadTask, task)) _autoLoadTask = null;
    });
  }

  Future<void> _runAutoLoadMore({
    double? viewportHeight,
    double crossAxisExtent = 0,
    int? maxPages,
  }) async {
    if (isAutoLoading.value) return;
    isAutoLoading.value = true;
    autoLoadPaused.value = false;
    var pagesLoaded = 0;
    final pageLimit = maxPages ?? autoLoadMaxPages;
    try {
      while (hasActiveFilter &&
          !isEnd &&
          !isLocating &&
          pagesLoaded < pageLimit &&
          !filteredContentFillsViewport(
            visibleCount: filteredList.length,
            viewportHeight: viewportHeight,
            crossAxisExtent: crossAxisExtent,
          )) {
        if (isLoading) {
          await Future<void>.delayed(const Duration(milliseconds: 600));
          continue;
        }
        final prevLength = loadingState.value.dataOrNull?.length ?? 0;
        await onLoadMore();
        final newLength = loadingState.value.dataOrNull?.length ?? 0;
        if (newLength <= prevLength) {
          // 请求失败或并发加载未推进，停止循环
          break;
        }
        pagesLoaded++;
        await Future<void>.delayed(const Duration(milliseconds: 600));
      }
    } finally {
      isAutoLoading.value = false;
      // 仍未铺满、未到底且未在定位，说明是撞到连续翻页上限而暂停
      autoLoadPaused.value =
          hasActiveFilter &&
          !isEnd &&
          !isLocating &&
          pagesLoaded >= pageLimit &&
          !filteredContentFillsViewport(
            visibleCount: filteredList.length,
            viewportHeight: viewportHeight,
            crossAxisExtent: crossAxisExtent,
          );
    }
  }

  // 弹窗修改过滤设置后由 view 调用：重新过滤并按需触发自动补载。
  // 返回本次补载的 Future，调用方不需要等待时可以忽略。
  Future<void> onFilterChanged({
    double? viewportHeight,
    double crossAxisExtent = 0,
    int? maxPages,
  }) {
    applyFilter();
    if (hasActiveFilter && !isEnd) {
      return _autoLoadMoreLoop(
        viewportHeight: viewportHeight,
        crossAxisExtent: crossAxisExtent,
        maxPages: maxPages,
      );
    }
    return Future<void>.value();
  }

  // 列表构建后调度自动补载。构建期不能直接发请求，推迟到当前帧结束后执行，
  // 并以最近一次视口尺寸为准（屏幕旋转或分栏变化时尺寸随之更新）
  double? _pendingViewportHeight;
  double _pendingCrossAxisExtent = 0;
  bool _autoLoadScheduled = false;
  void scheduleAutoLoadMore({
    required double viewportHeight,
    required double crossAxisExtent,
  }) {
    if (isAutoLoading.value || autoLoadPaused.value || isLocating) {
      return;
    }
    _pendingViewportHeight = viewportHeight;
    _pendingCrossAxisExtent = crossAxisExtent;
    if (_autoLoadScheduled) return;
    _autoLoadScheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _autoLoadScheduled = false;
      if (isClosed) return;
      _autoLoadMoreLoop(
        viewportHeight: _pendingViewportHeight,
        crossAxisExtent: _pendingCrossAxisExtent,
      );
    });
  }

  // 过滤开启时，定位「上次观看」需要基于 filteredList 而非原始列表
  int indexOfFromViewAid() {
    if (!hasActiveFilter) {
      return loadingState.value.dataOrNull?.indexWhere(
            (i) => i.param == fromViewAid,
          ) ??
          -1;
    }
    return filteredList.indexWhere((i) => i.param == fromViewAid);
  }

  @override
  Future<void> onRefresh() async {
    if (isLocating) {
      if (hasPrev == true) {
        isLoadPrevious = true;
        await queryData();
      }
    } else {
      isLoadPrevious = false;
      firstAid = null;
      lastAid = null;
      next = null;
      isEnd = false;
      page = 0;
      await queryData();
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (isVideo) {
      fromViewAid = Get.parameters['from_view_aid'];
    }
    page = 0;
    queryData();
  }

  @override
  bool customHandleResponse(
    bool isRefresh,
    Success<SpaceArchiveData> response,
  ) {
    final data = response.response;
    episodicButton = data.episodicButton;
    next = data.next;
    if (page == 0 || isLoadPrevious) {
      hasPrev = data.hasPrev;
      if (isLoadPrevious && hasPrev != true) {
        onlyInnerScroll = false;
      }
    }
    if (page == 0 || !isLoadPrevious) {
      if ((isVideo ? data.hasNext == false : data.next == 0) ||
          data.item.isNullOrEmpty) {
        isEnd = true;
      }
    }
    count = type == .season ? data.item?.length : data.count;
    if (page != 0) {
      if (loadingState.value case Success(:final response)) {
        data.item ??= <SpaceArchiveItem>[];
        if (isLoadPrevious) {
          data.item!.addAll(response!);
        } else {
          data.item!.insertAll(0, response!);
        }
      }
    }
    firstAid = data.item?.firstOrNull?.param;
    lastAid = data.item?.lastOrNull?.param;
    isLoadPrevious = false;
    loadingState.value = Success(data.item);
    applyFilter();
    return true;
  }

  @override
  Future<LoadingState<SpaceArchiveData>> customGetData() => _archiveLoader(
        type: type,
        mid: mid,
        aid: isVideo
            ? isLoadPrevious
                  ? firstAid
                  : lastAid
            : null,
        order: isVideo ? order : null,
        sort: isVideo
            ? isLoadPrevious
                  ? .asc
                  : null
            : sort,
        pn: type == .charging ? page : null,
        next: next,
        seasonId: seasonId,
        seriesId: seriesId,
        includeCursor: isLocating && page == 0,
      );

  void queryBySort() {
    if (isLoading) return;
    if (isVideo) {
      setIsLocating(false);
      order = order == .pubdate ? .click : .pubdate;
    } else {
      sort = sort == .desc ? .asc : .desc;
    }
    onReload();
  }

  Future<void> toViewPlayAll() async {
    final episodicButton = this.episodicButton!;
    if (episodicButton.text == '继续播放' &&
        episodicButton.uri?.isNotEmpty == true) {
      final params = Uri.parse(episodicButton.uri!).queryParameters;
      String? oid = params['oid'];
      if (oid != null) {
        final bvid = IdUtils.av2bv(int.parse(oid));
        final res = await SearchHttp.ab2cWithDimension(aid: oid, bvid: bvid);
        final cid = res?.cid;
        if (cid != null) {
          PageUtils.toVideoPage(
            aid: int.parse(oid),
            bvid: bvid,
            cid: cid,
            dimension: res!.dimension,
            // title: res.title,
            extraArguments: {
              'sourceType': SourceType.archive,
              'mediaId': seasonId ?? seriesId ?? mid,
              'oid': oid,
              'favTitle':
                  '$username: ${title ?? episodicButton.text ?? '播放全部'}',
              if (seriesId == null) 'count': ?count,
              if (seasonId != null || seriesId != null)
                'mediaType': params['page_type'],
              'desc': params['desc'] == '1',
              'sortField': params['sort_field'],
              'isContinuePlaying': true,
            },
          );
        }
      }
      return;
    }

    if (loadingState.value case Success(:final response)) {
      if (response == null || response.isEmpty) return;

      for (SpaceArchiveItem element in response) {
        if (element.cid == null) {
          continue;
        } else {
          bool desc = seasonId != null ? false : true;
          desc =
              (seasonId != null || seriesId != null) &&
                  (isVideo ? order == .click : sort == .asc)
              ? !desc
              : desc;
          bool isVertical = false;
          if (element.uri case final uri?) {
            isVertical = uri.isVerticalFromUri;
          }
          PageUtils.toVideoPage(
            bvid: element.bvid,
            cid: element.cid!,
            cover: element.cover,
            title: element.title,
            isVertical: isVertical,
            extraArguments: {
              'sourceType': SourceType.archive,
              'mediaId': seasonId ?? seriesId ?? mid,
              'oid': IdUtils.bv2av(element.bvid!),
              'favTitle':
                  '$username: ${title ?? episodicButton.text ?? '播放全部'}',
              if (seriesId == null) 'count': ?count,
              if (seasonId != null || seriesId != null)
                'mediaType': Uri.parse(
                  episodicButton.uri!,
                ).queryParameters['page_type'],
              'desc': desc,
              if (isVideo) 'sortField': order == .click ? 2 : 1,
            },
          );
          break;
        }
      }
    }
  }

  @override
  Future<void> onReload() {
    reload = true;
    setIsLocating(false);
    return super.onReload();
  }
}
