import 'package:PiliPlus/grpc/app/main/community/reply/v1/reply.pb.dart';
import 'package:PiliPlus/http/article.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/models/model_owner.dart';
import 'package:PiliPlus/models/space_article/item.dart';
import 'package:PiliPlus/models/space_article/stats.dart';
import 'package:PiliPlus/pages/common/reply_controller.dart';
import 'package:PiliPlus/pages/mine/controller.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/http/reply.dart';
import 'package:fixnum/fixnum.dart' as $fixnum;

class HtmlRenderController extends ReplyController<MainListReply> {
  late String id;
  late String dynamicType;
  late int type;
  late int oid;
  Item? readContent;
  dynamic mid;

  final summary = Summary();

  DynamicItemModel? item;

  final Rx<ModuleStatModel?> stats = Rx<ModuleStatModel?>(null);
  final RxBool loaded = false.obs;

  late final horizontalPreview = GStorage.horizontalPreview;
  late final showDynActionBar = GStorage.showDynActionBar;

  @override
  dynamic get sourceId => id;

  @override
  void onInit() {
    super.onInit();
    id = Get.parameters['id']!;
    dynamicType = Get.parameters['dynamicType']!;
    type = dynamicType == 'picture' ? 11 : 12;

    reqHtml();
  }

  Future<bool> _queryOpus(id) async {
    final res = await ArticleHttp.opusDetail(id: id);
    if (res is Success) {
      item = (res as Success<DynamicItemModel>).response;
      type = item!.basic!.commentType!;
      mid = item!.modules.moduleAuthor?.mid;
      oid = int.parse(item!.basic!.commentIdStr!);
      if (showDynActionBar && item!.modules.moduleStat != null) {
        stats.value = item!.modules.moduleStat!;
      }
      summary
        ..author ??= item!.modules.moduleAuthor
        ..title ??= item!.modules.moduleTag?.text;
      return true;
    }
    return false;
  }

  Future<bool> _queryRead(cvid) async {
    final res = await ArticleHttp.articleView(cvid: cvid);
    if (res is Success) {
      readContent = (res as Success<Item>).response;
      if (showDynActionBar) {
        final dynId = readContent!.dynIdStr;
        if (!dynId.isNullOrEmpty && await _queryOpus(dynId)) {
          return true;
        } else {
          debugPrint('cvid2opus failed: $id');
        }
      }
      mid = readContent!.author?.mid;
      if (showDynActionBar && readContent!.stats != null) {
        stats.value = _statesToModuleStat(readContent!.stats!);
      }
      summary
        ..author ??= readContent!.author
        ..title ??= readContent!.title
        ..cover ??= readContent!.originImageUrls?.firstOrNull;
    }
    return res is Success;
  }

  // 请求动态内容
  Future reqHtml() async {
    if (dynamicType == 'opus' || dynamicType == 'picture') {
      loaded.value = await _queryOpus(id);
      if (loaded.value) queryData();
    } else {
      type = 12;
      oid = int.parse(id.replaceFirst('cv', ''));
      queryData();
      loaded.value = await _queryRead(oid);
    }
    if (loaded.value) {
      if (isLogin && !MineController.anonymity.value) {
        VideoHttp.historyReport(aid: oid, type: 5);
      }
    }
  }

  @override
  List<ReplyInfo>? getDataList(MainListReply response) {
    return response.replies;
  }

  @override
  Future<LoadingState<MainListReply>> customGetData() {
    return ReplyHttp.replyListGrpc(
      type: type,
      oid: oid,
      cursor: CursorReq(
        next: cursor?.next ?? $fixnum.Int64(0),
        mode: mode.value,
      ),
      antiGoodsReply: antiGoodsReply,
    );
  }

  Future onFav() async {
    bool isFav = stats.value?.favorite?.status == true;
    final res = dynamicType == 'read'
        ? isFav
            ? await UserHttp.delFavArticle(id: id.substring(2))
            : await UserHttp.addFavArticle(id: id.substring(2))
        : await UserHttp.communityAction(opusId: id, action: isFav ? 4 : 3);
    if (res['status']) {
      stats.value?.favorite?.status = !isFav;
      var count = stats.value?.favorite?.count ?? 0;
      if (isFav) {
        stats.value?.favorite?.count = count - 1;
      } else {
        stats.value?.favorite?.count = count + 1;
      }
      stats.refresh();
      SmartDialog.showToast('${isFav ? '取消' : ''}收藏成功');
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  static ModuleStatModel _statesToModuleStat(Stats stats) {
    return ModuleStatModel(
      comment: _setCount(stats.reply),
      forward: _setCount(stats.dyn),
      like: _setCount(stats.like),
      favorite: _setCount(stats.favorite),
    );
  }

  static DynamicStat _setCount(int? count) => DynamicStat(count: count);
}

class Summary {
  Owner? author;
  String? title;
  String? cover;

  Summary({this.author, this.title, this.cover});
}
