import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/msg.dart';
import 'package:PiliPlus/models_new/msg/msg_like_detail/card.dart';
import 'package:PiliPlus/models_new/msg/msg_like_detail/data.dart';
import 'package:PiliPlus/models_new/msg/msg_like_detail/item.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:get/get.dart';

class LikeDetailController
    extends CommonListController<MsgLikeDetailData, MsgLikeDetailItem> {
  final cardId = Get.parameters['id'];
  final uri = Get.parameters['uri'];

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  MsgLikeDetailCard? card;

  @override
  List<MsgLikeDetailItem>? getDataList(MsgLikeDetailData response) {
    if (response.page?.isEnd == true) {
      isEnd = true;
    }
    card = response.card;
    return response.items;
  }

  @override
  Future<LoadingState<MsgLikeDetailData>> customGetData() =>
      MsgHttp.msgLikeDetail(
        cardId: cardId!,
        pn: page,
      );
}
