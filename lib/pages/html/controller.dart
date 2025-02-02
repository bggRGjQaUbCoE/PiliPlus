import 'package:PiliPlus/grpc/app/main/community/reply/v1/reply.pb.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/reply_controller.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/http/html.dart';
import 'package:PiliPlus/http/reply.dart';
import 'package:fixnum/fixnum.dart' as $fixnum;

class HtmlRenderController extends ReplyController {
  late String id;
  late String dynamicType;
  late int type;
  RxInt oid = (-1).obs;
  late Map response;
  int? floor;

  RxBool loaded = false.obs;

  late final horizontalPreview = GStorage.horizontalPreview;

  @override
  void onInit() {
    super.onInit();
    id = Get.parameters['id']!;
    dynamicType = Get.parameters['dynamicType']!;
    type = dynamicType == 'picture' ? 11 : 12;

    reqHtml();
  }

  // 请求动态内容
  Future reqHtml() async {
    late dynamic res;
    if (dynamicType == 'opus' || dynamicType == 'picture') {
      res = await HtmlHttp.reqHtml(id, dynamicType);
    } else {
      res = await HtmlHttp.reqReadHtml(id, dynamicType);
    }
    if (res != null) {
      response = res;
      oid.value = res['commentId'];
      queryData();
      if (res['status'] == true) {
        loaded.value = true;
      }
    }
  }

  @override
  Future<LoadingState> customGetData() => GlobalData().grpcReply
      ? ReplyHttp.replyListGrpc(
          type: type,
          oid: oid.value,
          cursor: CursorReq(
            next: cursor?.next ?? $fixnum.Int64(0),
            mode: mode.value,
          ),
          banWordForReply: banWordForReply,
        )
      : ReplyHttp.replyList(
          isLogin: isLogin,
          oid: oid.value,
          nextOffset: nextOffset,
          type: type,
          sort: sortType.value.index,
          page: currentPage,
          banWordForReply: banWordForReply,
        );
}
