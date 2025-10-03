import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/msg.dart';
import 'package:PiliPlus/models_new/msg/msg_like_detail/card.dart';
import 'package:PiliPlus/models_new/msg/msg_like_detail/data.dart';
import 'package:PiliPlus/models_new/msg/msg_like_detail/item.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:get/get.dart';

class LikeDetailController
    extends CommonListController<MsgLikeDetailData, MsgLikeDetailItem> {
  final cardId = Get.parameters['id']!;
  final uri = Get.parameters['uri'];

  int lastMid = 0;

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  MsgLikeDetailCard? card;

  @override
  List<MsgLikeDetailItem>? getDataList(MsgLikeDetailData response) {
    if (response.items?.lastOrNull?.user?.mid case final mid?) {
      lastMid = mid;
    }
    card = response.card;
    return response.items;
  }

  @override
  Future<void> onRefresh() {
    lastMid = 0;
    return super.onRefresh();
  }

  @override
  Future<LoadingState<MsgLikeDetailData>> customGetData() =>
      MsgHttp.msgLikeDetail(cardId: cardId, pn: page, lastMid: lastMid);
}
