import 'package:PiliPlus/http/follow.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/member.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/models/common/follow_order_type.dart';
import 'package:PiliPlus/models_new/follow/data.dart';
import 'package:PiliPlus/models_new/follow/list.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/pages/follow/controller.dart';
import 'package:get/get.dart';

class FollowChildController
    extends CommonListController<FollowData, FollowItemModel> {
  FollowChildController(this.controller, this.mid, this.tagid);
  final FollowController? controller;
  final int? tagid;
  final int mid;
  int? total;

  late final loadSameFollow = controller?.isOwner == false;
  late final Rx<LoadingState<List<FollowItemModel>?>> sameState =
      LoadingState<List<FollowItemModel>?>.loading().obs;

  late final Rx<FollowOrderType> orderType = FollowOrderType.def.obs;

  @override
  void onInit() {
    super.onInit();
    queryData();
    if (loadSameFollow) {
      _loadSameFollow();
    }
  }

  @override
  List<FollowItemModel>? getDataList(FollowData response) {
    total = response.total;
    return response.list;
  }

  @override
  void checkIsEnd(int length) {
    if (total != null && length >= total!) {
      isEnd = true;
    }
  }

  @override
  bool customHandleResponse(bool isRefresh, Success<FollowData> response) {
    if (controller != null) {
      try {
        if (controller!.isOwner &&
            tagid == null &&
            isRefresh &&
            controller!.followState.value.isSuccess) {
          controller!.tabs
            ..[0].count = response.response.total
            ..refresh();
        }
      } catch (_) {}
    }
    return false;
  }

  @override
  Future<LoadingState<FollowData>> customGetData() {
    if (tagid != null) {
      return MemberHttp.followUpGroup(mid: mid, tagid: tagid, pn: page);
    }

    return FollowHttp.followings(
      vmid: mid,
      pn: page,
      orderType: orderType.value.type,
    );
  }

  Future<void> _loadSameFollow() async {
    final res = await UserHttp.sameFollowing(mid: mid);
    if (res.isSuccess) {
      sameState.value = Success(res.data.list);
    }
  }
}
