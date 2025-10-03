import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/msg.dart';
import 'package:PiliPlus/models_new/msg/msg_like_detail/card.dart';
import 'package:PiliPlus/models_new/msg/msg_like_detail/data.dart';
import 'package:PiliPlus/models_new/msg/msg_like_detail/item.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:get/get.dart';

class LikeDetailController
    extends CommonListController<MsgLikeDetailData, MsgLikeDetailItem> {
  late final String cardId;
  late final String? uri;
  late final int counts;

  int lastMid = 0;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    cardId = args['id'];
    uri = args['uri'];
    counts = args['counts'];
    queryData();
  }

  MsgLikeDetailCard? card;

  @override
  List<MsgLikeDetailItem>? getDataList(MsgLikeDetailData response) {
    card = response.card;
    final items = response.items;
    if (items?.lastOrNull?.user?.mid case final mid?) {
      lastMid = mid;
    }
    return items;
  }

  @override
  void checkIsEnd(int length) {
    if (length >= counts) {
      isEnd = true;
    }
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
