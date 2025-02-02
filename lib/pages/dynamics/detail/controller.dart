import 'package:PiliPlus/grpc/app/main/community/reply/v1/reply.pb.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/reply_controller.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/http/html.dart';
import 'package:PiliPlus/http/reply.dart';
import 'package:fixnum/fixnum.dart' as $fixnum;

class DynamicDetailController extends ReplyController {
  DynamicDetailController(this.oid, this.type);
  int? oid;
  int? type;
  dynamic item;
  int? floor;

  late final horizontalPreview = GStorage.horizontalPreview;

  @override
  void onInit() {
    super.onInit();
    item = Get.arguments['item'];
    floor = Get.arguments['floor'];
    if (floor == 1) {
      count.value = int.parse(item!.modules!.moduleStat!.comment!.count ?? '0');
    }

    if (oid != 0) {
      queryData();
    }
  }

  // 根据jumpUrl获取动态html
  reqHtmlByOpusId(int id) async {
    var res = await HtmlHttp.reqHtml(id, 'opus');
    oid = res['commentId'];
    queryData();
  }

  @override
  Future<LoadingState> customGetData() => GlobalData().grpcReply
      ? ReplyHttp.replyListGrpc(
          type: type ?? 1,
          oid: oid!,
          cursor: CursorReq(
            next: cursor?.next ?? $fixnum.Int64(0),
            mode: mode.value,
          ),
          banWordForReply: banWordForReply,
        )
      : ReplyHttp.replyList(
          isLogin: isLogin,
          oid: oid!,
          nextOffset: nextOffset,
          type: type!,
          sort: sortType.value.index,
          page: currentPage,
          banWordForReply: banWordForReply,
        );
}
