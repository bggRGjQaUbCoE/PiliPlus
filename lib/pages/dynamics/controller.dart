import 'dart:async';

import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/dynamic/dynamic_up_list_mode.dart';
import 'package:PiliPlus/models/common/dynamic/dynamics_type.dart';
import 'package:PiliPlus/models/dynamics/up.dart';
import 'package:PiliPlus/pages/common/common_data_controller.dart';
import 'package:PiliPlus/pages/dynamics_tab/controller.dart';
import 'package:PiliPlus/services/account_service.dart';
import 'package:PiliPlus/utils/accounts.dart';
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
  late final DynamicUpListMode _upListMode = Pref.dynamicUpListMode;
  late final bool _showAllUp = _upListMode.showAllFollowed;

  /// 本地维护的未读作者同时保存头像与昵称，使“不常看”UP 无需等关注列表翻页即可展示。
  final Map<int, UpItem> _unreadUps = <int, UpItem>{};

  /// 标记当前已载入缓存的账号，避免账号切换后串用未读状态。
  int? _badgeAccountMid;

  /// 仅在首次建立更新基线时接收一次官方已有红点，避免切换到全量模式后红点先变少。
  bool _preserveOfficialBadges = false;

  /// 首次启用某模式时回补的页数：基线刚建立时增量必然为空，回补可避免「红点全没了」的观感。
  static const _initialBackfillPages = 2;

  /// 本地红点缓存键版本。
  ///
  /// v1 按模式分桶，且基线是配合服务端 `update_num` 推进的，而该字段实测恒为 `'0'`，
  /// 那份基线已不能代表「已读到哪一条」；v3 起红点集合不再按模式分桶（两种模式共用
  /// 一份增量，只按视频与否筛选），因此升级键名强制丢弃旧状态、重新建立基线。
  static const _badgeCacheVersion = 'v3';

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
    if (_showAllUp) {
      _page = 1;
      _cacheUpList = null;
    }
    _offset = null;
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
    tabController.dispose();
    super.onClose();
  }

  @override
  void onChangeAccount(bool isLogin) {
    _badgeAccountMid = null;
    _unreadUps.clear();
    _preserveOfficialBadges = false;
    onReload();
  }

  String _badgeCacheKey(String prefix) =>
      '$prefix.$_badgeCacheVersion:${Accounts.main.mid}';

  /// 从账号隔离的缓存恢复尚未点开的 UP 更新。
  void _loadUnreadUps() {
    final accountMid = Accounts.main.mid;
    if (_badgeAccountMid == accountMid) return;

    _badgeAccountMid = accountMid;
    _unreadUps.clear();
    final cached = GStorage.localCache.get(
      _badgeCacheKey(LocalCacheKey.dynamicUpUnread),
    );
    if (cached is! List) return;
    for (final item in cached) {
      if (item is Map) {
        try {
          final up = UpItem.fromJson(Map<String, dynamic>.from(item));
          if (up.mid > 0) _unreadUps[up.mid] = up;
        } catch (_) {
          // 单条旧缓存损坏时跳过，不能阻断整个动态页加载。
        }
      }
    }
  }

  /// 持久化未读作者，保证应用重启后红点仍保留到用户点开该 UP。
  Future<void> _saveUnreadUps() => GStorage.localCache.put(
    _badgeCacheKey(LocalCacheKey.dynamicUpUnread),
    _unreadUps.values
        .map(
          (up) => <String, dynamic>{
            'mid': up.mid,
            'face': up.face,
            'uname': up.uname,
            'has_update': true,
            'latest_update_at': up.latestUpdateAt,
            'is_video': up.isVideo,
          },
        )
        .toList(),
  );

  /// 使用动态流更新基线补齐官方常看列表之外的红点。
  Future<void> _refreshUnreadUps() async {
    try {
      _loadUnreadUps();
      final accountMid = Accounts.main.mid;
      final baselineKey = _badgeCacheKey(LocalCacheKey.dynamicUpBaseline);
      final baseline = GStorage.localCache.get(baselineKey);
      final isInitialBaseline = baseline is! String || baseline.isEmpty;
      final res = await DynamicsHttp.followDynamicUpdates(
        updateBaseline: baseline is String ? baseline : null,
        backfillPages: isInitialBaseline ? _initialBackfillPages : 0,
      );
      // 账号在请求期间发生切换时丢弃旧结果，避免污染新账号缓存。
      if (Accounts.main.mid != accountMid) return;
      if (res case Success(:final response)) {
        _preserveOfficialBadges = isInitialBaseline;
        for (final up in response.updatedUps) {
          final old = _unreadUps[up.mid];
          // 动态流条目带发布时间（pub_ts），官方常看带入的红点没有时间戳，
          // 于是任何一次真实更新都能覆盖掉「类型未知」的旧条目，补上视频标记。
          if (old == null ||
              (up.latestUpdateAt ?? 0) > (old.latestUpdateAt ?? 0)) {
            _unreadUps[up.mid] = up;
          }
        }
        await Future.wait([
          if (response.updateBaseline?.isNotEmpty == true)
            GStorage.localCache.put(baselineKey, response.updateBaseline),
          _saveUnreadUps(),
        ]);
      }
    } catch (_) {
      // 补充红点失败时沿用缓存，主动态列表和官方常看列表仍应正常加载。
    }
  }

  /// 「仅视频」模式下只有确知最新动态是视频投稿的 UP 才展示红点。
  ///
  /// 由官方常看列表带入的红点没有动态类型信息（[UpItem.isVideo] 为 null），
  /// 因此不会被该模式展示，避免把只发了图文的 UP 也标红。
  bool _matchesBadgeMode(UpItem up) => _upListMode.showsBadge(up.isVideo);

  /// 将本地未读状态覆盖到列表，并把新更新但不常看的 UP 提到列表前方。
  void _applyUnreadUps(FollowUpModel data, {required bool includeMissing}) {
    if (!_showAllUp) return;
    _loadUnreadUps();

    final upList = data.upList ??= <UpItem>[];
    bool shouldSave = false;
    if (_preserveOfficialBadges) {
      // 首次建立更新基线时先继承官方已经判定的常看 UP 红点，避免切换模式后红点先变少；
      // 这些条目没有动态类型，只会出现在「所有动态」模式里。
      for (final up in upList.where((up) => up.hasUpdate == true)) {
        if (!_unreadUps.containsKey(up.mid)) {
          _unreadUps[up.mid] = up;
          shouldSave = true;
        }
      }
      _preserveOfficialBadges = false;
    }
    final currentUps = <int, UpItem>{for (final up in upList) up.mid: up};
    for (final up in upList) {
      final unread = _unreadUps[up.mid];
      final visible = unread != null && _matchesBadgeMode(unread);
      up.hasUpdate = visible;
      if (visible) up.latestUpdateAt = unread.latestUpdateAt;
    }
    if (includeMissing) {
      final missing = _unreadUps.values
          .where((up) => !currentUps.containsKey(up.mid))
          .where(_matchesBadgeMode)
          .toList();
      upList.insertAll(0, missing);
      DynamicUpUpdateResult.sortUnreadFirst(upList);
    }
    if (shouldSave) unawaited(_saveUnreadUps());
  }

  /// 点开 UP 后仅清除此人的本地红点，其他未读更新保持不变。
  ///
  /// 这里刻意不立刻重排列表：点了哪个 UP 就让哪个 UP 原地消掉红点，位置统一留到下一次
  /// 刷新时由 [applyUnreadUps] 调整。否则刚点过的 UP 会从指下跳到「有更新」与
  /// 「无更新」的分界线上，和「常看」模式的表现也不一致。
  void markUpRead(UpItem item) {
    item.hasUpdate = false;
    if (_showAllUp && _unreadUps.remove(item.mid) != null) {
      unawaited(_saveUnreadUps());
    }
  }

  @override
  Future<LoadingState<FollowUpModel>> customGetData() async {
    if (_offset == null) {
      final portal = DynamicsHttp.followUp();
      if (_showAllUp) await _refreshUnreadUps();
      return portal;
    }
    if (_showAllUp) {
      return DynamicsHttp.followings(
        vmid: Accounts.main.mid,
        pn: _page,
        orderType: 'attention',
        ps: 50,
      );
    } else {
      return DynamicsHttp.dynUpList(_offset);
    }
  }

  @override
  Future<void> queryData([bool isRefresh = true]) {
    if (!isRefresh && _isEnd) return Future.value();
    return super.queryData(isRefresh);
  }

  @override
  bool customHandleResponse(bool isRefresh, Success<FollowUpModel> response) {
    final res = response.response;

    _applyUnreadUps(res, includeMissing: isRefresh);

    if (_showAllUp) {
      if (res.upList?.isNotEmpty != true) {
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
      if (_showAllUp) {
        _page++;
      }

      if (res.upList case final upList? when upList.isNotEmpty) {
        if (_showAllUp && _cacheUpList != null) {
          upList.removeWhere(_cacheUpList!.contains);
        }
        loadingState
          ..value.data.addAllUpList(upList)
          ..refresh();
      }
    }

    return true;
  }
}
