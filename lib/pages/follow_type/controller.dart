import 'package:PiliPlus/http/member.dart';
import 'package:PiliPlus/models_new/follow/data.dart';
import 'package:PiliPlus/models_new/follow/list.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:get/get.dart';

abstract class FollowTypeController
    extends CommonListController<FollowData, FollowItemModel> {
  late final int mid;
  late final RxnString name;

  RxInt total = 0.obs;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  void init() {
    final ownerMid = Accounts.main.mid;
    final mid = Get.parameters['mid'];
    this.mid = mid != null ? int.parse(mid) : ownerMid;
    final name = Get.parameters['name'];
    this.name = RxnString(name);
    if (name == null) {
      queryUserName();
    }
    queryData();
  }

  Future<void> queryUserName() async {
    final res = await MemberHttp.memberCardInfo(mid: mid);
    name.value = res.dataOrNull?.card?.name;
  }

  @override
  List<FollowItemModel>? getDataList(FollowData response) {
    total.value = response.total ?? 0;
    return response.list;
  }

  @override
  void checkIsEnd(int length) {
    if (length >= total.value) {
      isEnd = true;
    }
  }
}
