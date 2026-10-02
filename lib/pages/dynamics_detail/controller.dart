import 'dart:async';

import 'package:flutter/foundation.dart' show ValueChanged;
import 'package:PiliPlus/common/widgets/scroll_physics.dart' show ReloadMixin;
import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/reply.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/common/dyn/common_dyn_controller.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class DynamicDetailController extends CommonDynController with ReloadMixin {
  static const String _kWebLinkPlaceholder = '网页链接';

  DynamicDetailController({super.count});

  @override
  late int oid;
  @override
  late int replyType;
  late DynamicItemModel dynItem;
  final RxInt detailVersion = 0.obs;
  ValueChanged<DynamicItemModel>? _onUpdate;

  @override
  dynamic get sourceId => replyType == 1 ? IdUtils.av2bv(oid) : oid;

  @override
  void onInit() {
    super.onInit();
    dynItem = Get.arguments['item'];
    _onUpdate = Get.arguments['onUpdate'];
    final commentType = dynItem.basic?.commentType;
    final commentIdStr = dynItem.basic?.commentIdStr;
    if (commentType != null &&
        commentType != 0 &&
        commentIdStr != null &&
        commentIdStr.isNotEmpty) {
      _init(commentIdStr, commentType);
      _tryFetchFullDynamicDetail();
    } else {
      DynamicsHttp.dynamicDetail(id: dynItem.idStr).then((res) {
        if (res case Success(:final response)) {
          _replaceDynItem(response);
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

  void _replaceDynItem(DynamicItemModel item) {
    dynItem = item;
    detailVersion.value++;
    _onUpdate?.call(item);
  }

  bool _shouldFetchFullDetail() {
    final moduleDynamic = dynItem.modules.moduleDynamic;
    // TODO: B站API修复后移除 — 列表API中首行为换行的文本会返回"undefined"
    if (moduleDynamic?.desc?.text == 'undefined') {
      return true;
    }
    final nodes =
        moduleDynamic?.desc?.richTextNodes ??
        moduleDynamic?.major?.opus?.summary?.richTextNodes;
    if (nodes == null || nodes.isEmpty) {
      return false;
    }
    for (final node in nodes) {
      if (node.type == 'RICH_TEXT_NODE_TYPE_WEB' &&
          (node.jumpUrl == null || node.jumpUrl!.isEmpty)) {
        return true;
      }
      if (node.text == _kWebLinkPlaceholder ||
          node.origText == _kWebLinkPlaceholder) {
        return true;
      }
    }
    return false;
  }

  void _tryFetchFullDynamicDetail() {
    if (!_shouldFetchFullDetail()) {
      return;
    }
    DynamicsHttp.dynamicDetail(id: dynItem.idStr).then((res) {
      if (isClosed) {
        return;
      }
      if (res case Success(:final response)) {
        _replaceDynItem(response);
        final nextCommentType = response.basic?.commentType;
        final nextCommentIdStr = response.basic?.commentIdStr;
        if (nextCommentType != null &&
            nextCommentType != 0 &&
            nextCommentIdStr != null &&
            nextCommentIdStr.isNotEmpty) {
          final nextOid = int.tryParse(nextCommentIdStr);
          if (nextOid != null &&
              (nextOid != oid || nextCommentType != replyType)) {
            _init(nextCommentIdStr, nextCommentType);
          }
        }
      }
    });
  }

  Future<LoadingState> onSetPubSetting(bool isPrivate, Object dynId) async {
    final res = await DynamicsHttp.dynPrivatePubSetting(
      dynId: dynId,
      action: isPrivate ? 'public_pub' : 'private_pub',
    );
    if (res.isSuccess) {
      dynItem.modules.moduleAuthor?.badgeText = isPrivate ? null : '仅自己可见';
      detailVersion.value++;
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
      Timer(const Duration(milliseconds: 500), () {
        if (!isClosed) {
          onReload();
        }
      });
    }
  }

  @override
  Future<void> onReload() {
    reload = true;
    return super.onReload();
  }
}
