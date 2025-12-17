import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/member.dart';
import 'package:PiliPlus/models/common/member/contribute_type.dart';
import 'package:PiliPlus/models/member/info.dart';
import 'package:PiliPlus/models_new/space/space_archive/data.dart';
import 'package:PiliPlus/models_new/space/space_archive/item.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/extension/scroll_controller_ext.dart';
import 'package:get/get.dart';

class HorizontalMemberPageController
    extends CommonListController<SpaceArchiveData, SpaceArchiveItem> {
  HorizontalMemberPageController({this.mid, required this.currAid});

  dynamic mid;

  final Rx<LoadingState<MemberInfoModel>> userState =
      LoadingState<MemberInfoModel>.loading().obs;
  final RxMap userStat = {}.obs;

  @override
  void onInit() {
    super.onInit();
    getUserInfo();
    queryData();
  }

  Future<void> getUserInfo() async {
    final res = await MemberHttp.memberInfo(mid: mid);
    userState.value = res;
    if (res.isSuccess) {
      getMemberStat();
      getMemberView();
    }
  }

  Future<void> getMemberStat() async {
    var res = await MemberHttp.memberStat(mid: mid);
    if (res['status']) {
      userStat.addAll(res['data']);
    }
  }

  Future<void> getMemberView() async {
    if (!Accounts.main.isLogin) {
      return;
    }
    var res = await MemberHttp.memberView(mid: mid);
    if (res['status']) {
      userStat.addAll(res['data']);
    }
  }

  @override
  bool customHandleResponse(bool isRefresh, Success response) {
    SpaceArchiveData data = response.response;
    count.value = data.count ?? -1;
    if (isRefresh) {
      if (isLoadPrevious) {
        hasPrev = data.hasPrev ?? false;
      } else {
        hasNext = data.hasNext ?? false;
      }
    }
    if (isLoadPrevious && loadingState.value.isSuccess) {
      data.item ??= <SpaceArchiveItem>[];
      data.item!.addAll(loadingState.value.data!);
    } else if (!isRefresh && loadingState.value.isSuccess) {
      data.item ??= <SpaceArchiveItem>[];
      data.item!.insertAll(0, loadingState.value.data!);
    }
    firstAid = data.item?.firstOrNull?.param;
    lastAid = data.item?.lastOrNull?.param;
    loadingState.value = Success(data.item);
    isLoadPrevious = false;
    page++;
    return true;
  }

  String? currAid;
  String? firstAid;
  String? lastAid;
  RxString order = 'pubdate'.obs;
  RxInt count = (-1).obs;
  bool isLoadPrevious = false;
  bool hasPrev = true;
  bool hasNext = true;

  @override
  Future<LoadingState<SpaceArchiveData>> customGetData() =>
      MemberHttp.spaceArchive(
        type: ContributeType.video,
        mid: mid,
        aid: page == 1
            ? currAid
            : isLoadPrevious
            ? firstAid
            : lastAid,
        order: order.value,
        sort: page != 1 && isLoadPrevious ? 'asc' : null,
        pn: null,
        next: null,
        seasonId: null,
        seriesId: null,
        includeCursor: page == 1 ? true : null,
      );

  @override
  Future<void> onRefresh() {
    if (!hasPrev) {
      return Future.syncValue(null);
    }
    isLoadPrevious = true;
    return queryData();
  }

  @override
  Future<void> onReload() {
    firstAid = null;
    lastAid = null;
    hasNext = true;
    hasPrev = true;
    isEnd = false;
    page = 1;
    scrollController.jumpToTop();
    return super.onReload();
  }

  void queryBySort() {
    if (isLoading) return;
    order.value = order.value == 'pubdate' ? 'click' : 'pubdate';
    onReload();
  }
}
