import 'package:PiliPlus/grpc/bilibili/app/dynamic/v2.pb.dart'
    show OpusSpaceFlowResp, OpusFlowItem, SectionOpusCollection;
import 'package:PiliPlus/grpc/space.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/space/space/tab2.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/pages/member/controller.dart';
import 'package:collection/collection.dart';
import 'package:get/get.dart';

class MemberOpusController
    extends CommonListController<OpusSpaceFlowResp, OpusFlowItem> {
  MemberOpusController({
    required this.heroTag,
    required this.mid,
  });

  final String? heroTag;
  final int mid;

  String? next;
  Rx<SpaceTabFilter> type = const SpaceTabFilter(
    text: "全部图文",
    meta: "all",
    tabName: "图文",
  ).obs;
  List<SpaceTabFilter>? filter;
  SectionOpusCollection? collection;

  @override
  void onInit() {
    super.onInit();
    filter = Get.find<MemberController>(tag: heroTag).tab2
        ?.firstWhereOrNull((e) => e.param == 'contribute')
        ?.items
        ?.firstWhereOrNull((e) => e.param == 'opus')
        ?.filter;
    queryData();
  }

  @override
  Future<void> onRefresh() {
    next = null;
    collection = null;
    return super.onRefresh();
  }

  @override
  List<OpusFlowItem>? getDataList(OpusSpaceFlowResp response) {
    final next = response.nextPage.next;
    if (next.isNotEmpty) {
      this.next = next;
    } else {
      isEnd = true;
    }
    return response.itemList;
  }

  @override
  bool customHandleResponse(
    bool isRefresh,
    Success<OpusSpaceFlowResp> response,
  ) {
    if (isRefresh && response.response.hasHostUpOpusCollection()) {
      collection = response.response.hostUpOpusCollection;
    }
    return super.customHandleResponse(isRefresh, response);
  }

  @override
  Future<LoadingState<OpusSpaceFlowResp>> customGetData() =>
      SpaceGrpc.opusSpaceFlow(
        hostMid: mid,
        next: next,
        filterType: type.value.meta,
      );
}
