import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/member.dart';
import 'package:PiliPlus/models/member/tags.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class FollowController extends GetxController with GetTickerProviderStateMixin {
  late final int mid;
  late final RxnString name;
  late final bool isOwner;

  late final Rx<LoadingState> followState = LoadingState.loading().obs;
  late final RxList<MemberTagItemModel> tabs = <MemberTagItemModel>[].obs;
  TabController? tabController;

  @override
  void onInit() {
    super.onInit();
    final Map? args = Get.arguments;
    final ownerMid = Accounts.main.mid;
    final int? mid = args?['mid'];
    this.mid = mid ?? ownerMid;
    isOwner = ownerMid == this.mid;
    if (isOwner) {
      queryFollowUpTags();
    } else {
      final String? name = args?['name'];
      this.name = RxnString(name);
      if (name == null) {
        _queryUserName();
      }
    }
  }

  Future<void> _queryUserName() async {
    final res = await MemberHttp.memberCardInfo(mid: mid);
    name.value = res.dataOrNull?.card?.name;
  }

  Future<void> queryFollowUpTags() async {
    var res = await MemberHttp.followUpTags();
    if (res.isSuccess) {
      tabs
        ..assign(MemberTagItemModel(name: '全部关注'))
        ..addAll(res.data);
      int initialIndex = 0;
      if (tabController != null) {
        initialIndex = tabController!.index.clamp(0, tabs.length - 1);
        tabController!.dispose();
      }
      tabController = TabController(
        initialIndex: initialIndex,
        length: tabs.length,
        vsync: this,
      );
      followState.value = Success(tabs.hashCode);
    } else {
      followState.value = res;
    }
  }

  @override
  void onClose() {
    tabController?.dispose();
    super.onClose();
  }

  Future<void> onCreateTag(String tagName) async {
    final res = await MemberHttp.createFollowTag(tagName);
    if (res.isSuccess) {
      followState.value = LoadingState.loading();
      queryFollowUpTags();
      SmartDialog.showToast('创建成功');
    } else {
      res.toast();
    }
  }

  Future<void> onUpdateTag(MemberTagItemModel item, String tagName) async {
    final res = await MemberHttp.updateFollowTag(item.tagid!, tagName);
    if (res.isSuccess) {
      item.name = tagName;
      tabs.refresh();
      SmartDialog.showToast('修改成功');
    } else {
      res.toast();
    }
  }

  Future<void> onDelTag(int tagid) async {
    final res = await MemberHttp.delFollowTag(tagid);
    if (res.isSuccess) {
      followState.value = LoadingState.loading();
      queryFollowUpTags();
      SmartDialog.showToast('删除成功');
    } else {
      res.toast();
    }
  }
}
