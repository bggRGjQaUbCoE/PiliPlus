import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/reply.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/common/dyn/common_dyn_controller.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class DynamicDetailController extends CommonDynController {
  @override
  late int oid;
  @override
  late int replyType;
  late DynamicItemModel dynItem;

  @override
  dynamic get sourceId => replyType == 1 ? IdUtils.av2bv(oid) : oid;

  @override
  void onInit() {
    super.onInit();
    dynItem = Get.arguments['item'];
    final commentType = dynItem.basic?.commentType;
    final commentIdStr = dynItem.basic?.commentIdStr;
    if (commentType != null &&
        commentType != 0 &&
        commentIdStr != null &&
        commentIdStr.isNotEmpty) {
      _init(commentIdStr, commentType);
    } else {
      DynamicsHttp.dynamicDetail(id: dynItem.idStr).then((res) {
        if (res case Success(:final response)) {
          _init(response.basic!.commentIdStr!, response.basic!.commentType!);
        } else {
          res.toast();
        }
      });
    }
  }

  void _init(String commentIdStr, int commentType) {
    oid = int.parse(commentIdStr);
    replyType = commentType;
    queryData();
  }

  Future<LoadingState> onSetPubSetting(bool isPrivate, Object dynId) async {
    final res = await DynamicsHttp.dynPrivatePubSetting(
      dynId: dynId,
      action: isPrivate ? 'public_pub' : 'private_pub',
    );
    if (res.isSuccess) {
      dynItem.modules.moduleAuthor?.badgeText = isPrivate ? null : '仅自己可见';
      SmartDialog.showToast('设置成功');
    } else {
      res.toast();
    }
    return res;
  }

  Future<void> onSetReplySubject(int action) async {
    final res = await ReplyHttp.replySubjectModify(
      oid: oid,
      type: replyType,
      action: action,
    );
    if (res.isSuccess) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!isClosed) {
          onReload();
        }
      });
    }
  }
}
