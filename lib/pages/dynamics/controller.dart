import 'dart:async';

import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/dynamic/dynamics_type.dart';
import 'package:PiliPlus/models/dynamics/up.dart';
import 'package:PiliPlus/models/dynamics/up_updates.dart';
import 'package:PiliPlus/pages/common/common_data_controller.dart';
import 'package:PiliPlus/pages/dynamics_tab/controller.dart';
import 'package:PiliPlus/services/account_service.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/extension/scroll_controller_ext.dart';
import 'package:PiliPlus/utils/extension/string_ext.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
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
  late int hostMid = -1, currentMid = -1;
  late bool showLiveUp = Pref.expandDynLivePanel;
  late final _showAllUp = Pref.dynamicsShowAllFollowedUp;
  DynamicUpUpdates _updates = DynamicUpUpdates();
  int? _updatesAccount;
  int _generation = 0;
  bool _refreshPending = false;
  bool _workerRunning = false;
  bool _responseOfficial = true;
  bool _scanSucceeded = false;
  Future<LoadingState<bool>>? _scanInFlight;
  Future<void> _cacheWrite = Future.value();

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
        Get.find<DynamicsTabController>(tag: DynamicsTabType.up.name)
            .onReload();
      } catch (_) {}
    }

    currentMid = mid;
    _jumpToTab(mid);
  }

  Future<void> singleRefresh() {
    if (isLoading) {
      _refreshPending = true;
      return Future.value();
    }
    if (_showAllUp) {
      _page = 1;
    }
    _offset = null;
    _isEnd = false;
    return super.onRefresh();
  }

  @override
  Future<void> onRefresh() async {
    final controller = this.controller;
    await Future.wait([
      singleRefresh(),
      if (controller != null) controller.onRefresh(),
    ]);
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
    _generation++;
    tabController.dispose();
    super.onClose();
  }

  @override
  void onChangeAccount(bool isLogin) {
    _generation++;
    _updatesAccount = null;
    _scanInFlight = null;
    _scanSucceeded = false;
    currentMid = hostMid = -1;
    onReload();
  }

  bool _isCurrent(Account account, int generation) =>
      !isClosed &&
      _generation == generation &&
      identical(Accounts.main, account);

  void _loadUpdates(Account account) {
    if (_updatesAccount == account.mid) return;
    _updatesAccount = account.mid;
    _updates = DynamicUpUpdates.fromJson(
      GStorage.localCache.get('dynamicUpUpdates.v1:${account.mid}'),
    );
  }

  Future<void> _saveUpdates() {
    final key = 'dynamicUpUpdates.v1:$_updatesAccount';
    final snapshot = _updates.toJson();
    return _cacheWrite = _cacheWrite.then((_) async {
      try {
        await GStorage.localCache.put(key, snapshot);
      } catch (_) {
        // Keep the in-memory unread state if storage is temporarily unavailable.
      }
    });
  }

  Future<LoadingState<bool>> _scanUpdates(
    Account account,
    int generation,
  ) async {
    if (_scanInFlight case final pending?) return pending;
    final state = _updates;
    final task = () async {
      try {
        final result = await state.scan((offset) async {
          if (!_isCurrent(account, generation)) return const Error('账号已切换');
          final page = await DynamicsHttp.dynamicUpUpdates(
            account: account,
            offset: offset,
          );
          return _isCurrent(account, generation) ? page : const Error('账号已切换');
        }, now: DateTime.now().millisecondsSinceEpoch ~/ 1000);
        if (_isCurrent(account, generation)) {
          _scanSucceeded = result is Success<bool>;
          await _saveUpdates();
        }
        return result;
      } catch (_) {
        if (_isCurrent(account, generation)) _scanSucceeded = false;
        return const Error('动态更新检查失败，请刷新重试');
      }
    }();
    _scanInFlight = task;
    try {
      return await task;
    } finally {
      if (identical(_scanInFlight, task)) _scanInFlight = null;
    }
  }

  void markUpRead(UpItem item) {
    item.hasUpdate = false;
    if (!_showAllUp) return;
    final account = Accounts.main;
    if (!account.isLogin) return;
    _loadUpdates(account);
    _updates.markRead(item.mid, DateTime.now().millisecondsSinceEpoch ~/ 1000);
    unawaited(_saveUpdates());
    if (loadingState.value case Success(:final response)) {
      // Clear the dot immediately without moving the avatar under the finger.
      _updates.apply(response, sort: false);
      loadingState.refresh();
    }
  }

  void _continueUpdates() {
    if (!_showAllUp ||
        _workerRunning ||
        !_scanSucceeded ||
        !_updates.hasPending ||
        isClosed) {
      return;
    }
    final account = Accounts.main;
    if (!account.isLogin) return;
    final generation = _generation;
    _workerRunning = true;
    unawaited(() async {
      try {
        while (_isCurrent(account, generation) && _updates.hasPending) {
          await Future<void>.delayed(const Duration(seconds: 1));
          if (!_isCurrent(account, generation) || isLoading) return;
          final result = await _scanUpdates(account, generation);
          if (!_isCurrent(account, generation)) return;
          if (result is! Success<bool>) {
            SmartDialog.showToast('部分 UP 更新检查失败，下拉刷新可重试');
            return;
          }
          if (loadingState.value case Success(:final response)) {
            _updates.apply(response);
            loadingState.refresh();
          }
        }
        // Catch updates published while a long backfill was being scanned.
        if (_isCurrent(account, generation) && !isLoading) {
          await _scanUpdates(account, generation);
          if (_isCurrent(account, generation)) {
            if (loadingState.value case Success(:final response)) {
              _updates.apply(response);
              loadingState.refresh();
            }
          }
        }
      } finally {
        _workerRunning = false;
        if (_generation != generation || _updates.hasPending) {
          _continueUpdates();
        }
      }
    }());
  }

  @override
  Future<LoadingState<FollowUpModel>> customGetData() async {
    final account = Accounts.main;
    final generation = _generation;
    _loadUpdates(account);
    _responseOfficial = _offset == null || !_showAllUp;
    if (_offset == null) {
      if (_showAllUp && account.isLogin) {
        final result = await _scanUpdates(account, generation);
        if (!_isCurrent(account, generation)) return const Error('账号已切换');
        if (result is Error) {
          SmartDialog.showToast('部分 UP 更新检查失败，下拉刷新可重试');
        }
      }
      return DynamicsHttp.followUp(loadAll: _showAllUp, account: account);
    }
    if (_showAllUp) {
      return DynamicsHttp.followings(
        vmid: account.mid,
        account: account,
        pn: _page,
        orderType: 'attention',
        ps: 50,
      );
    } else {
      return DynamicsHttp.dynUpList(_offset, account: account);
    }
  }

  @override
  Future<void> queryData([bool isRefresh = true]) async {
    if (isClosed || !isRefresh && _isEnd || isLoading) return;
    final account = Accounts.main;
    final generation = _generation;
    isLoading = true;
    try {
      final result = await customGetData();
      if (!_isCurrent(account, generation)) return;
      if (result case Success<FollowUpModel>()) {
        customHandleResponse(isRefresh, result);
      } else if (isRefresh) {
        loadingState.value = result;
      }
    } catch (_) {
      if (_isCurrent(account, generation) && isRefresh) {
        loadingState.value = const Error('动态 UP 列表加载失败，请刷新重试');
      }
    } finally {
      isLoading = false;
      if (_refreshPending && !isClosed) {
        _refreshPending = false;
        unawaited(singleRefresh());
      } else {
        _continueUpdates();
      }
    }
  }

  @override
  bool customHandleResponse(bool isRefresh, Success<FollowUpModel> response) {
    final res = response.response;
    if (_showAllUp && _responseOfficial) {
      _updates.applyOfficial(res.upList ?? [], replace: isRefresh);
    }

    if (_showAllUp) {
      if (!isRefresh && res.upList?.isNotEmpty != true) {
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
        // Dynamic pages are complete; subsequent loads only fill in followings.
        _offset = '';
      }
      loadingState.value = response;
    } else {
      if (_showAllUp) {
        _page++;
      }

      if (res.upList case final upList? when upList.isNotEmpty) {
        loadingState
          ..value.data.addAllUpList(upList)
          ..refresh();
      }
    }

    if (_showAllUp) {
      _updates.apply(loadingState.value.data);
      loadingState.refresh();
    }

    return true;
  }
}
