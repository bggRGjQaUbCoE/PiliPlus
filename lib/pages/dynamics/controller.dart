import 'dart:async';

import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/dynamic/dyn_swipe_target.dart';
import 'package:PiliPlus/models/common/dynamic/dynamics_type.dart';
import 'package:PiliPlus/models/common/dynamic/up_panel_position.dart';
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
import 'package:material_ui/material_ui.dart' show TabController, VoidCallback;

class DynamicsController
    extends CommonDataController<FollowUpModel, FollowUpModel>
    with GetSingleTickerProviderStateMixin, AccountMixin {
  late final TabController tabController;

  final Set<int> tempBannedList = <int>{};

  String? _offset;
  late int _page = 1;
  late bool _isEnd = false;
  Set<UpItem>? _cacheUpList;
  late int hostMid = -1;

  /// 当前选中的 UP（-1 表示「全部动态」），响应式以便 UP 面板高亮跟随横滑
  final _currentMid = (-1).obs;
  int get currentMid => _currentMid.value;
  set currentMid(int value) => _currentMid.value = value;
  late bool showLiveUp = Pref.expandDynLivePanel;
  late final _showAllUp = Pref.dynamicsShowAllFollowedUp;

  final upOnlyMode = Pref.dynUpOnlyMode;
  final _upPanelPosition = Pref.upPanelPosition;
  final swipeTarget = Pref.dynSwipeTarget;

  /// 「仅 UP 主栏」模式下头像栏只能横排吸顶
  UpPanelPosition get upPanelPosition =>
      upOnlyMode ? UpPanelPosition.top : _upPanelPosition;

  /// 「逐个浏览 UP」分页在重建 UP 列表时的回调
  VoidCallback? upPageSync;

  /// 点击 UP 面板头像时，让横向分页跳到对应 UP
  void Function(int mid)? upPageJump;

  /// 下拉/点击刷新时刷新当前 UP 页
  Future<void> Function()? upPageRefresh;

  /// 回到顶部 / 回顶并刷新
  VoidCallback? upPageScrollToTop;
  VoidCallback? upPageToTopOrRefresh;

  /// 是否使用逐 UP 横向分页（此时 UP 页签内容由分页容器接管）
  bool get useUpPageView =>
      upOnlyMode || (swipeTarget == DynSwipeTarget.up && upPanelPosition == .top);

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

  /// 横向分页滑到某位 UP 时同步选中状态
  ///
  /// 列表由分页自己管理，这里只更新高亮，避免重复请求。
  void onSwipeToUp(int mid) {
    if (currentMid == mid) return;
    currentMid = mid;
    hostMid = mid;
  }

  void onSelectUp(int mid) {
    if (useUpPageView) {
      _jumpToTab(mid);
      if (currentMid != mid) {
        currentMid = mid;
        hostMid = mid;
        upPageJump?.call(mid);
      } else if (mid == -1) {
        singleRefresh();
        upPageJump?.call(mid);
      }
      return;
    }

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
    if (upPageRefresh case final refresh?) return refresh();
    final controller = this.controller;
    if (controller != null) {
      singleRefresh();
      return controller.onRefresh();
    }
    return singleRefresh();
  }

  @override
  Future<void> showRefresh() {
    if (upPageRefresh case final refresh?) return refresh();
    final controller = this.controller;
    if (controller != null) {
      singleRefresh();
      return controller.showRefresh();
    }
    return singleRefresh();
  }

  @override
  void animateToTop() {
    if (upPageScrollToTop case final toTop?) return toTop();
    controller?.animateToTop();
    scrollController.animToTop();
  }

  @override
  void toTopOrRefresh() {
    if (upPageToTopOrRefresh case final fn?) return fn();
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
