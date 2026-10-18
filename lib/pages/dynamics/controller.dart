import 'dart:async';

import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/models/common/dynamic/dynamic_up_list_mode.dart';
import 'package:PiliPlus/models/common/dynamic/dynamics_type.dart';
import 'package:PiliPlus/models/dynamics/up.dart';
import 'package:PiliPlus/models/dynamics/unread_state.dart';
import 'package:PiliPlus/models/dynamics/unread_task_queue.dart';
import 'package:PiliPlus/pages/common/common_data_controller.dart';
import 'package:PiliPlus/pages/dynamics_tab/controller.dart';
import 'package:PiliPlus/services/account_service.dart';
import 'package:PiliPlus/services/dynamic_unread_notifier.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/extension/scroll_controller_ext.dart';
import 'package:PiliPlus/utils/extension/string_ext.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart' show TabController;

class DynamicsController
    extends CommonDataController<FollowUpModel, FollowUpModel>
    with GetSingleTickerProviderStateMixin, AccountMixin {
  late final TabController tabController;

  final Set<int> tempBannedList = <int>{};

  String? _offset;
  late int _page = 1;
  late bool _isEnd = false;
  Set<UpItem>? _cacheUpList;
  late int hostMid = -1, currentMid = -1;
  late bool showLiveUp = Pref.expandDynLivePanel;

  /// 设置保存后立即切换模式，两种全部关注模式共享内容级未读状态。
  DynamicUpListMode _upListMode = Pref.dynamicUpListMode;
  bool get _showAllUp => _upListMode.showAllFollowed;

  /// 本地维护的未读作者同时保存头像与昵称，使“不常看”UP 无需等关注列表翻页即可展示。
  DynamicUnreadState _unreadState = DynamicUnreadState();

  /// 标记当前已载入缓存的账号，避免账号切换后串用未读状态。
  int? _badgeAccountMid;

  /// 账号或模式变化会使旧请求失效；包括 A→B→A 的切换也不能复用旧结果。
  int _badgeGeneration = 0;
  bool _reloadPending = false;
  bool _scanWorkerRunning = false;
  bool _responseOfficial = false;

  /// 批次失败后停止自动续扫，保留进度供下一次主动刷新重试，避免持续打接口。
  bool _badgeScanSucceeded = true;
  String? _officialOffset;

  /// 前台刷新与后台续扫共用同一批请求，防止并发扫描互相覆盖进度。
  final DynamicUnreadTaskQueue _badgeTaskQueue = DynamicUnreadTaskQueue();

  /// 缓存写入按触发顺序执行，较早的快照不能在稍后覆盖新的已读状态。
  Future<void> _badgeCacheWrite = Future.value();

  /// 首次启用某模式时回补的页数：基线刚建立时增量必然为空，回补可避免「红点全没了」的观感。
  static const _initialBackfillPages = 2;

  /// 本地红点缓存键版本。
  ///
  /// v1 按模式分桶，且基线是配合服务端 `update_num` 推进的，而该字段实测恒为 `'0'`，
  /// 那份基线已不能代表「已读到哪一条」；v3 起红点集合不再按模式分桶（两种模式共用
  /// 一份增量，只按视频与否筛选）；v4 起红点还会按「已看过」的证据主动剔除。
  /// v5 改为内容级已读、单快照缓存及可续扫进度，不能继续使用旧作者级状态。
  static const _badgeCacheVersion = 'v5';

  final upPanelPosition = Pref.upPanelPosition;

  @override
  final AccountService accountService = Get.find<AccountService>();

  DynamicsTabController? get controller {
    try {
      return Get.find<DynamicsTabController>(
        tag: DynamicsTabType.values[tabController.index].name,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(
      vsync: this,
      length: DynamicsTabType.values.length,
      initialIndex: Pref.defaultDynamicTypeIndex,
    );
    // 动态详情等页面在用户看过内容后会回调这里，用于清除对应 UP 的红点。
    DynamicUnreadNotifier.bind(_onContentRead);
    queryData();
  }

  void _jumpToTab(int mid) {
    tabController.index = mid == -1 ? 0 : 4;
  }

  void onSelectUp(int mid) {
    if (currentMid == mid) {
      _jumpToTab(mid);
      if (mid == -1) {
        singleRefresh();
      }
      controller?.onReload();
      return;
    }

    if (mid != -1) {
      hostMid = mid;
      try {
        Get.find<DynamicsTabController>(
          tag: DynamicsTabType.up.name,
        ).onReload();
      } catch (_) {}
    }

    currentMid = mid;
    _jumpToTab(mid);
  }

  Future<void> singleRefresh() {
    // 进行中的请求先失效，待其结束后执行最新刷新，避免列表游标在途中被修改。
    if (isLoading) {
      _badgeGeneration++;
      _reloadPending = true;
      return Future.value();
    }
    if (_showAllUp) {
      _page = 1;
      _cacheUpList = null;
    }
    _offset = null;
    _officialOffset = null;
    _isEnd = false;
    return super.onRefresh();
  }

  @override
  Future<void> onRefresh() {
    final controller = this.controller;
    if (controller != null) {
      singleRefresh();
      return controller.onRefresh();
    }
    return singleRefresh();
  }

  @override
  void animateToTop() {
    controller?.animateToTop();
    scrollController.animToTop();
  }

  @override
  void toTopOrRefresh() {
    final ctr = controller;
    if (ctr?.scrollController.hasClients == true) {
      if (ctr!.scrollController.position.pixels == 0) {
        if (scrollController.hasClients &&
            scrollController.position.pixels != 0) {
          scrollController.animToTop();
        }
        EasyThrottle.throttle(
          'topOrRefresh',
          const Duration(milliseconds: 500),
          onRefresh,
        );
      } else {
        animateToTop();
      }
    } else {
      super.toTopOrRefresh();
    }
  }

  @override
  void onClose() {
    // 使所有在途请求与后台续扫失效，销毁之后不再写缓存或刷新页面。
    _badgeGeneration++;
    DynamicUnreadNotifier.unbind(_onContentRead);
    tabController.dispose();
    super.onClose();
  }

  /// 判断结果是否仍属于当前账号和页面，所有网络等待后均先检查再应用。
  bool _isBadgeRequestCurrent(Account account, int generation) =>
      !isClosed &&
      _badgeGeneration == generation &&
      identical(Accounts.main, account);

  /// 已读通知按内容身份处理；清点与保存立即执行，位置保持到下一次刷新。
  void _onContentRead(DynamicReadEvent event) {
    // 常看模式也记录本地阅读水位，切回全部关注时不能恢复已读内容的旧红点。
    if (!Accounts.main.isLogin ||
        event.accountMid != Accounts.main.mid ||
        isClosed) {
      return;
    }
    _loadUnreadUps();
    if (event.dynamicId case final id? when id > 0) {
      _unreadState.markDynamicRead(
        id,
        event.mid,
        publishedAt: event.publishedAt,
      );
    }
    if (event.videoAid != null || event.videoBvid != null) {
      _unreadState.markVideoRead(
        aid: event.videoAid,
        bvid: event.videoBvid,
        viewedAt: event.viewedAt,
        mid: event.mid,
        publishedAt: event.publishedAt,
      );
    }
    unawaited(_saveUnreadUps());
    if (loadingState.value case Success(:final response)) {
      _applyUnreadUps(response, includeMissing: false);
      loadingState.refresh();
    }
  }

  /// 切换主账号时清空页面游标并废弃在途响应，等待旧请求结束后重新加载。
  @override
  void onChangeAccount(bool isLogin) {
    _badgeGeneration++;
    _badgeAccountMid = null;
    _unreadState = DynamicUnreadState();
    _officialOffset = null;
    // 新账号从全部动态开始，不能继续查询旧账号选择的 UP。
    currentMid = hostMid = -1;
    tabController.index = 0;
    onReload();
  }

  /// 外观设置保存后立即应用；页面不存在时由下一次初始化读取设置。
  void setUpListMode(DynamicUpListMode mode) {
    if (_upListMode == mode) return;
    _upListMode = mode;
    _badgeGeneration++;
    onReload();
  }

  /// 使用载入时固定的账号生成缓存键，写入排队时也不读取新的全局账号。
  String _badgeCacheKey(int mid) =>
      '${LocalCacheKey.dynamicUpUnread}.$_badgeCacheVersion:$mid';

  /// 按主账号恢复单一快照，包括内容级已读证据和未完成扫描游标。
  void _loadUnreadUps() {
    final mid = Accounts.main.mid;
    if (_badgeAccountMid == mid) return;
    _badgeAccountMid = mid;
    _unreadState = DynamicUnreadState.fromJson(
      GStorage.localCache.get(_badgeCacheKey(mid)),
    );
  }

  /// 串行保存不可变快照，基线和未读内容不会因分开写入而失去一致性。
  Future<void> _saveUnreadUps() {
    final mid = _badgeAccountMid;
    if (mid == null) return Future.value();
    final key = _badgeCacheKey(mid);
    final snapshot = _unreadState.toJson();
    _badgeCacheWrite = _badgeCacheWrite.then((_) async {
      try {
        await GStorage.localCache.put(key, snapshot);
      } catch (_) {
        // 磁盘缓存暂不可写时保留内存状态，后续写入仍可继续，不能终止写入队列。
      }
    });
    return _badgeCacheWrite;
  }

  /// 共用正在执行的扫描批次，前台刷新不会与后台续扫竞争同一账号状态。
  Future<Set<int>> _refreshUnreadUps(Account account, int generation) =>
      _badgeTaskQueue.run(
        account,
        generation,
        () => _scanUnreadBatch(account, generation),
      );

  /// 扫描一个有界批次，固定账号并用主账号观看历史精确清除对应视频。
  Future<Set<int>> _scanUnreadBatch(Account account, int generation) async {
    if (!account.isLogin || !_isBadgeRequestCurrent(account, generation)) {
      return {};
    }
    _loadUnreadUps();
    _badgeScanSucceeded = false;
    final state = _unreadState;
    try {
      final res = await DynamicsHttp.followDynamicUpdates(
        account: account,
        updateBaseline: '${state.baselineId}',
        backfillPages: state.baselineId == 0 ? _initialBackfillPages : 0,
        resume: state.progress,
      );
      if (!_isBadgeRequestCurrent(account, generation)) return {};
      if (res case Success(:final response)) {
        final fresh = state.mergeBatch(response);
        await _pruneSeenUps(account, generation, state);
        if (!_isBadgeRequestCurrent(account, generation)) return {};
        await _saveUnreadUps();
        _badgeScanSucceeded = true;
        return fresh;
      }
      // 续扫游标可能过期：保留完整旧基线，下次从首屏重扫该范围，不丢弃漏扫区间。
      state.progress = null;
      await _saveUnreadUps();
    } catch (_) {
      // 网络失败保留原进度和已读证据，主动态列表仍可正常使用。
    }
    return {};
  }

  /// 查询与动态流一致的主账号历史；只按视频号匹配，旧视频不能清除新视频或图文。
  Future<void> _pruneSeenUps(
    Account account,
    int generation,
    DynamicUnreadState state, {
    bool resume = false,
  }) async {
    final oldest = state.oldestVideoAt;
    if (oldest == null) {
      state
        ..historyMax = null
        ..historyViewAt = null;
      return;
    }
    try {
      int? max = resume ? state.historyMax : null;
      int? viewAt = resume ? state.historyViewAt : null;
      final previousNewest = state.historyNewestAt;
      for (var page = 0; page < 3; page++) {
        final res = await UserHttp.historyList(
          account: account,
          type: 'all',
          max: max,
          viewAt: viewAt,
        );
        if (!_isBadgeRequestCurrent(account, generation)) return;
        if (res case Success(:final response)) {
          final list = response.list;
          if (list == null || list.isEmpty) {
            state
              ..historyMax = null
              ..historyViewAt = null;
            return;
          }
          if (!resume && page == 0) {
            // 前一轮已经保存过的历史无需全量重查，只补最近新增的记录。
            state.historyNewestAt = list.first.viewAt ?? previousNewest;
          }
          for (final item in list) {
            // 直播、专栏等历史 oid 不属于视频 aid，不能跨业务误匹配同一个数字。
            if (item.history.business != 'archive' || item.viewAt == null) {
              continue;
            }
            state.markVideoRead(
              aid: item.history.oid,
              bvid: item.history.bvid,
              viewedAt: item.viewAt!,
            );
          }
          final last = list.last;
          final lastAt = last.viewAt ?? 0;
          if (lastAt > 0 &&
              (state.historyFloorAt == 0 || lastAt < state.historyFloorAt)) {
            state.historyFloorAt = lastAt;
          }
          if (lastAt < oldest ||
              last.history.oid == max ||
              !resume &&
                  lastAt <= previousNewest &&
                  state.historyFloorAt < oldest) {
            state
              ..historyMax = null
              ..historyViewAt = null;
            return;
          }
          max = last.history.oid;
          viewAt = last.viewAt;
          // 前台至多三页；待查历史保留最深游标，后台从那里继续，避免只查最近 60 条。
          if (page == 2 &&
              max != null &&
              viewAt != null &&
              (resume ||
                  state.historyViewAt == null ||
                  viewAt < state.historyViewAt!)) {
            state
              ..historyMax = max
              ..historyViewAt = viewAt;
          }
        } else {
          // 接口错误停止后台循环，下一次主动刷新再从首屏重新尝试。
          state
            ..historyMax = null
            ..historyViewAt = null;
          return;
        }
      }
    } catch (_) {
      if (_isBadgeRequestCurrent(account, generation)) {
        state
          ..historyMax = null
          ..historyViewAt = null;
      }
      // 历史不可用时不推断已读，保留未读；本地精确已读事件仍可立即消点。
    }
  }

  /// 使用官方首屏返回的真实游标获取更多状态，单轮上限之后仍保留续页入口。
  Future<LoadingState<FollowUpModel>> _loadOfficialUps(
    Account account,
    int generation,
  ) async {
    final portal = await DynamicsHttp.followUp(account: account);
    if (!_isBadgeRequestCurrent(account, generation)) {
      return const Error('账号已切换');
    }
    if (!_showAllUp || portal is! Success<FollowUpModel>) return portal;
    final data = portal.response;
    final seen = <String>{};
    for (var page = 1; page < 8 && data.hasMore == true; page++) {
      final offset = data.offset;
      if (offset == null || offset.isEmpty || !seen.add(offset)) break;
      final next = await DynamicsHttp.dynUpList(offset, account: account);
      if (!_isBadgeRequestCurrent(account, generation)) {
        return const Error('账号已切换');
      }
      if (next case Success(:final response)) {
        final mids = {for (final up in data.upList ?? <UpItem>[]) up.mid};
        data
          ..addAllUpList(
            (response.upList ?? []).where((up) => mids.add(up.mid)).toList(),
          )
          ..hasMore = response.hasMore
          ..offset = response.offset;
      } else {
        break;
      }
    }
    _officialOffset = data.hasMore == true ? data.offset : null;
    return portal;
  }

  /// 根据当前模式覆盖可变 UI 摘要，只有刷新或续扫才补齐作者并重新排序。
  void _applyUnreadUps(FollowUpModel data, {required bool includeMissing}) {
    if (!_showAllUp) return;
    _loadUnreadUps();
    final unread = _unreadState.summaries(onlyVideo: _upListMode == .video);
    final list = data.upList ??= [];
    final current = {for (final up in list) up.mid};
    for (final up in list) {
      final summary = unread[up.mid];
      up
        ..hasUpdate = summary != null
        ..latestUpdateAt = summary?.latestUpdateAt;
    }
    if (includeMissing) {
      list.addAll(unread.values.where((up) => current.add(up.mid)));
      DynamicUpUpdateResult.sortUnreadFirst(list);
    }
  }

  /// 点开作者列表清除其当前全部更新，保持头像位置并保护在途扫描的旧内容。
  void markUpRead(UpItem item) {
    item.hasUpdate = false;
    // 头像点击的已读语义与展示模式无关，所有模式共用同一份账号已读水位。
    if (!Accounts.main.isLogin) return;
    _loadUnreadUps();
    _unreadState.markUpRead(
      item.mid,
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
    );
    unawaited(_saveUnreadUps());
    if (loadingState.value case Success(:final response)) {
      _applyUnreadUps(response, includeMissing: false);
      loadingState.refresh();
    }
  }

  /// 每批最多取有限页，首屏先显示，后台按已保存游标持续补齐，不把漏扫区间丢弃。
  void _scheduleUnreadScan() {
    if (_scanWorkerRunning ||
        !_badgeScanSucceeded ||
        !Accounts.main.isLogin ||
        !_showAllUp ||
        (_unreadState.progress == null && _unreadState.historyMax == null) ||
        isClosed) {
      return;
    }
    _scanWorkerRunning = true;
    final account = Accounts.main;
    final generation = _badgeGeneration;
    bool completedFeed = false;
    unawaited(() async {
      try {
        while (_isBadgeRequestCurrent(account, generation) &&
            (_unreadState.progress != null ||
                _unreadState.historyMax != null)) {
          // 批次之间让出执行与网络资源，前台滚动和点击无需等待完整历史扫描。
          await Future<void>.delayed(const Duration(seconds: 1));
          if (!_isBadgeRequestCurrent(account, generation)) return;
          if (_unreadState.progress != null) {
            await _refreshUnreadUps(account, generation);
            if (!_badgeScanSucceeded) break;
            if (_isBadgeRequestCurrent(account, generation) &&
                _unreadState.progress == null) {
              completedFeed = true;
            }
          } else {
            await _pruneSeenUps(
              account,
              generation,
              _unreadState,
              resume: true,
            );
            if (_isBadgeRequestCurrent(account, generation)) {
              await _saveUnreadUps();
            }
          }
          if (!_isBadgeRequestCurrent(account, generation)) return;
          if (loadingState.value case Success(:final response)) {
            _applyUnreadUps(response, includeMissing: true);
            _cacheUpList = response.upList?.toSet();
            loadingState.refresh();
          }
        }
      } finally {
        _scanWorkerRunning = false;
        // 扫描期间切换账号时，旧工作结束后仍要启动新账号尚未完成的扫描。
        if (_badgeGeneration != generation) _scheduleUnreadScan();
        // 历史扫描期间发布的新动态属于下一段增量，补完旧段后再拉一次最新首屏。
        if (completedFeed && _isBadgeRequestCurrent(account, generation)) {
          unawaited(singleRefresh());
        }
      }
    }());
  }

  /// 首屏先扫描增量再取官方状态；每个接口固定账号，并保留正确的官方续页游标。
  @override
  Future<LoadingState<FollowUpModel>> customGetData() async {
    final account = Accounts.main;
    final generation = _badgeGeneration;
    _responseOfficial =
        _offset == null ||
        (_showAllUp && _officialOffset?.isNotEmpty == true) ||
        !_showAllUp;
    LoadingState<FollowUpModel> res;
    Set<int> fresh = {};
    if (_offset == null) {
      if (_showAllUp) fresh = await _refreshUnreadUps(account, generation);
      if (!_isBadgeRequestCurrent(account, generation)) {
        return const Error('账号已切换');
      }
      res = await _loadOfficialUps(account, generation);
    } else if (_showAllUp && _officialOffset?.isNotEmpty == true) {
      res = await DynamicsHttp.dynUpList(_officialOffset, account: account);
      if (_isBadgeRequestCurrent(account, generation)) {
        if (res case Success(:final response)) {
          _officialOffset = response.hasMore == true ? response.offset : null;
        }
      }
    } else if (_showAllUp) {
      res = await DynamicsHttp.followings(
        account: account,
        vmid: account.mid,
        pn: _page,
        orderType: 'attention',
        ps: 50,
      );
    } else {
      res = await DynamicsHttp.dynUpList(_offset, account: account);
    }
    if (!_isBadgeRequestCurrent(account, generation)) {
      return const Error('账号已切换');
    }
    if (_showAllUp && _responseOfficial) {
      if (res case Success(:final response)) {
        _loadUnreadUps();
        _unreadState.applyOfficial(response.upList ?? [], freshMids: fresh);
        await _saveUnreadUps();
      }
    }
    return res;
  }

  /// 拦截账号切换和重复刷新，旧响应不交给 UI，异常也必须释放加载标志。
  @override
  Future<void> queryData([bool isRefresh = true]) async {
    if (isClosed || !isRefresh && _isEnd) return;
    if (isLoading) {
      if (isRefresh) _reloadPending = true;
      return;
    }
    isLoading = true;
    final account = Accounts.main;
    final generation = _badgeGeneration;
    try {
      final res = await customGetData();
      if (!_isBadgeRequestCurrent(account, generation)) return;
      if (res case Success(:final response)) {
        customHandleResponse(isRefresh, Success(response));
      } else if (isRefresh) {
        loadingState.value = res;
      }
    } catch (_) {
      if (_isBadgeRequestCurrent(account, generation) && isRefresh) {
        loadingState.value = const Error('动态加载失败，请刷新重试');
      }
    } finally {
      isLoading = false;
      if (_reloadPending && !isClosed) {
        _reloadPending = false;
        unawaited(onReload());
      } else {
        _scheduleUnreadScan();
      }
    }
  }

  @override
  bool customHandleResponse(bool isRefresh, Success<FollowUpModel> response) {
    final res = response.response;

    _applyUnreadUps(
      res,
      includeMissing: isRefresh,
    );

    if (_showAllUp) {
      // 官方列表为空不表示没有关注；必须允许继续获取完整关注列表。
      if (!_responseOfficial && res.upList?.isNotEmpty != true) {
        _isEnd = true;
      }
    } else {
      _offset = res.offset;
      if (res.hasMore != true || _offset.isNullOrEmpty) {
        _isEnd = true;
      }
    }

    if (isRefresh) {
      if (_showAllUp) {
        _offset = '';
        _cacheUpList = res.upList?.toSet();
      }
      loadingState.value = response;
    } else {
      // 官方续页使用 offset，只有关注列表页成功后才推进关注列表页码。
      if (_showAllUp && !_responseOfficial) {
        _page++;
      }

      if (res.upList case final upList? when upList.isNotEmpty) {
        if (_showAllUp && _cacheUpList != null) {
          upList.removeWhere(_cacheUpList!.contains);
          // 每张续页都加入去重集合，不能只去重首屏那批作者。
          _cacheUpList!.addAll(upList);
        }
        loadingState
          ..value.data.addAllUpList(upList)
          ..refresh();
      }
    }

    return true;
  }
}
