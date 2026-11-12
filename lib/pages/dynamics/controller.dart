import 'dart:async';

import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/dynamic/dynamics_type.dart';
import 'package:PiliPlus/models/dynamics/up.dart';
import 'package:PiliPlus/pages/common/common_data_controller.dart';
import 'package:PiliPlus/pages/dynamics_tab/controller.dart';
import 'package:PiliPlus/services/account_service.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/extension/scroll_controller_ext.dart';
import 'package:PiliPlus/utils/extension/string_ext.dart';
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
  late final _showAllUp = Pref.dynamicsShowAllFollowedUp;

  /// 官方动态 UP 列表中标记为有更新的 UP mid
  final Set<int> _updatedMids = <int>{};

  /// 刷新时根据设置决定是否补齐全部关注 UP 的更新状态
  bool _unreadForAllFollowedUp = false;

  /// 刷新时递增，用于取消仍在进行的官方列表续页请求
  int _unreadSyncEpoch = 0;

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
    _unreadSyncEpoch++;
    _updatedMids.clear();
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
  Future<void> showRefresh() {
    final controller = this.controller;
    if (controller != null) {
      singleRefresh();
      return controller.showRefresh();
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
          showRefresh,
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
    _unreadSyncEpoch++;
    tabController.dispose();
    super.onClose();
  }

  @override
  void onChangeAccount(bool isLogin) => onReload();

  @override
  Future<LoadingState<FollowUpModel>> customGetData() {
    if (_offset == null) {
      return DynamicsHttp.followUp();
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
        _unreadForAllFollowedUp =
            _showAllUp && Pref.dynamicsShowAllFollowedUpUnread;
        _updatedMids.clear();
        if (_unreadForAllFollowedUp) {
          for (final up in res.upList ?? const <UpItem>[]) {
            if (up.hasUpdate ?? false) {
              _updatedMids.add(up.mid);
            }
          }
          // portal 首屏只包含官方展示的部分 UP，后台继续翻页补齐
          unawaited(_syncAllFollowedUpUnread(res));
        }
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
        if (_unreadForAllFollowedUp && _updatedMids.isNotEmpty) {
          FollowUpModel.markUpdatedUps(upList, _updatedMids);
        }
        loadingState
          ..value.data.addAllUpList(upList)
          ..refresh();
      }
    }

    return true;
  }

  /// 补齐官方动态 UP 列表其余页面的更新状态。
  ///
  /// 动态 UP 列表首屏（portal）只展示部分 UP，后续 UP（包括部分已更新 UP）
  /// 需要继续翻页才能拿到 `has_update`。请求失败时保留已经拿到的状态。
  Future<void> _syncAllFollowedUpUnread(FollowUpModel first) async {
    final epoch = ++_unreadSyncEpoch;
    var offset = first.offset;
    var hasMore = first.hasMore;
    var page = 0;
    while (hasMore == true &&
        offset != null &&
        offset.isNotEmpty &&
        page < 10 &&
        epoch == _unreadSyncEpoch) {
      final res = await DynamicsHttp.dynUpList(offset);
      if (epoch != _unreadSyncEpoch) {
        return;
      }
      if (res case Success(:final response)) {
        if (response.upList case final upList?) {
          for (final up in upList) {
            if (up.hasUpdate ?? false) {
              _updatedMids.add(up.mid);
            }
          }
        }
        offset = response.offset;
        hasMore = response.hasMore;
        page++;
      } else {
        return;
      }
    }

    if (epoch != _unreadSyncEpoch) {
      return;
    }
    final upList = loadingState.value.dataOrNull?.upList;
    if (upList != null && FollowUpModel.markUpdatedUps(upList, _updatedMids)) {
      loadingState.refresh();
    }
  }
}
