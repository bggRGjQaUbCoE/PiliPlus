import 'dart:math';

import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/member.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/member/tab_type.dart';
import 'package:PiliPlus/models_new/space/space/data.dart';
import 'package:PiliPlus/models_new/space/space/live.dart';
import 'package:PiliPlus/models_new/space/space/setting.dart';
import 'package:PiliPlus/models_new/space/space/tab2.dart';
import 'package:PiliPlus/pages/common/common_data_controller.dart';
import 'package:PiliPlus/services/account_service.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    show ExtendedNestedScrollViewState;
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class MemberController extends CommonDataController<SpaceData, SpaceData?>
    with GetTickerProviderStateMixin {
  MemberController({required this.mid});
  int mid;
  String? username;

  AccountService accountService = Get.find<AccountService>();

  Live? live;
  int? silence;

  int? isFollowed; // 被关注
  RxInt relation = 0.obs;
  bool get isFollow => relation.value != 0 && relation.value != 128;

  SpaceSetting? spaceSetting;
  List<SpaceTab2>? tab2;
  late List<Tab> tabs;
  TabController? tabController;
  RxInt contributeInitialIndex = 0.obs;

  bool? hasSeasonOrSeries;

  final fromViewAid = Get.parameters['from_view_aid'];

  final key = GlobalKey<ExtendedNestedScrollViewState>();

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  bool customHandleResponse(bool isRefresh, Success<SpaceData> response) {
    final data = response.response;
    username = data.card?.name ?? '';
    isFollowed = data.card?.relation?.isFollowed;
    if (data.relation == -1) {
      relation.value = 128;
    } else {
      relation.value = data.card?.relation?.isFollow == 1
          ? data.relSpecial == 1
                ? -10
                : data.card?.relation?.status ?? 2
          : 0;
    }
    tab2 = data.tab2;
    live = data.live;
    silence = data.card?.silence;
    if ((data.ugcSeason?.count != null && data.ugcSeason?.count != 0) ||
        data.series?.item?.isNotEmpty == true) {
      hasSeasonOrSeries = true;
    }
    tab2?.retainWhere((item) => MemberTabType.contains(item.param!));
    if (tab2?.isNotEmpty == true) {
      if (data.hasItem != true && tab2!.first.param == 'home') {
        // remove empty home tab
        tab2!.removeAt(0);
      }
      if (tab2!.isNotEmpty) {
        int initialIndex = -1;
        MemberTabType memberTab = Pref.memberTab;
        if (memberTab != MemberTabType.def) {
          initialIndex = tab2!.indexWhere((item) {
            return item.param == memberTab.name;
          });
        }
        if (initialIndex == -1) {
          if (data.defaultTab == 'video') {
            data.defaultTab = 'contribute';
          }
          initialIndex = tab2!.indexWhere((item) {
            return item.param == data.defaultTab;
          });
        }
        tabs = tab2!.map((item) => Tab(text: item.title ?? '')).toList();
        tabController?.dispose();
        tabController = TabController(
          vsync: this,
          length: tabs.length,
          initialIndex: max(0, initialIndex),
        );
      }
    }
    if (mid == accountService.mid) {
      spaceSetting = data.setting;
    }
    loadingState.value = response;
    return true;
  }

  @override
  bool handleError(String? errMsg) {
    tab2 = const [
      SpaceTab2(title: '动态', param: 'dynamic'),
      SpaceTab2(
        title: '投稿',
        param: 'contribute',
        items: [SpaceTab2Item(title: '视频', param: 'video')],
      ),
      SpaceTab2(title: '收藏', param: 'favorite'),
      SpaceTab2(title: '追番', param: 'bangumi'),
    ];
    tabs = tab2!.map((item) => Tab(text: item.title)).toList();
    tabController?.dispose();
    tabController = TabController(
      vsync: this,
      length: tabs.length,
    );
    username = errMsg;
    loadingState.value = const Success(null);
    return true;
  }

  @override
  Future<LoadingState<SpaceData>> customGetData() => MemberHttp.space(
    mid: mid,
    fromViewAid: fromViewAid,
  );

  void blockUser(BuildContext context) {
    if (!accountService.isLogin.value) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('提示'),
          content: Text(relation.value != 128 ? '确定拉黑UP主?' : '从黑名单移除UP主'),
          actions: [
            TextButton(
              onPressed: Get.back,
              child: Text(
                '点错了',
                style: TextStyle(color: Theme.of(context).colorScheme.outline),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                _onBlock();
              },
              child: const Text('确认'),
            ),
          ],
        );
      },
    );
  }

  void shareUser() {
    Utils.shareText('https://space.bilibili.com/$mid');
  }

  Future<void> _onBlock() async {
    final isBlocked = relation.value == 128;
    var res = await VideoHttp.relationMod(
      mid: mid,
      act: isBlocked ? 6 : 5,
      reSrc: 11,
    );
    if (res['status']) {
      relation.value = isBlocked ? 0 : 128;
    }
  }

  void onFollow(BuildContext context) {
    if (mid == accountService.mid) {
      Get.toNamed('/editProfile');
    } else if (relation.value == 128) {
      _onBlock();
    } else {
      if (!accountService.isLogin.value) {
        SmartDialog.showToast('账号未登录');
        return;
      }
      RequestUtils.actionRelationMod(
        context: context,
        mid: mid,
        isFollow: isFollow,
        callback: (attribute) => relation.value = attribute,
      );
    }
  }

  @override
  void onClose() {
    tabController?.dispose();
    super.onClose();
  }

  Future<void> onRemoveFan() async {
    final res = await VideoHttp.relationMod(mid: mid, act: 7, reSrc: 11);
    if (res['status']) {
      isFollowed = null;
      if (relation.value == 4) {
        relation.value = 2;
      }
      SmartDialog.showToast('移除成功');
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  void onTapTab(int value) {
    if (tabController?.indexIsChanging == false &&
        key.currentState?.outerController.hasClients == true) {
      key.currentState!.outerController.animateTo(
        key.currentState!.outerController.offset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> vipExpAdd() async {
    var res = await UserHttp.vipExpAdd();
    if (res['status']) {
      SmartDialog.showToast('领取成功');
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }
}
