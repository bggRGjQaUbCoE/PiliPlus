import 'package:PiliPlus/grpc/app/main/community/reply/v1/reply.pb.dart';
import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/models/model_owner.dart';
import 'package:PiliPlus/models/space_article/item.dart';
import 'package:PiliPlus/models/space_article/stats.dart';
import 'package:PiliPlus/pages/common/reply_controller.dart';
import 'package:PiliPlus/pages/mine/controller.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/url_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/http/reply.dart';
import 'package:fixnum/fixnum.dart' as $fixnum;

class ArticleController extends ReplyController<MainListReply> {
  late String id;
  late String type;

  late final String url;
  late int commentType;
  dynamic commentId;
  final summary = Summary();

  RxBool showTitle = false.obs;

  late final horizontalPreview = GStorage.horizontalPreview;
  late final showDynActionBar = GStorage.showDynActionBar;

  @override
  dynamic get sourceId => id;

  final RxBool isLoaded = false.obs;
  DynamicItemModel? opusData;
  Item? articleData;
  final Rx<ModuleStatModel?> stats = Rx<ModuleStatModel?>(null);

  @override
  void onInit() {
    super.onInit();
    id = Get.parameters['id']!;
    type = Get.parameters['type']!;

    // to opus
    if (type == 'read') {
      UrlUtils.parseRedirectUrl('https://www.bilibili.com/read/cv$id/')
          .then((url) {
        if (url != null) {
          id = Utils.getFileName(url, fileExt: false);
          type = 'opus';
        }
        init();
      });
    } else {
      init();
    }
  }

  init() {
    url = type == 'read'
        ? 'https://www.bilibili.com/read/cv$id'
        : 'https://www.bilibili.com/opus/$id';
    commentType = type == 'picture' ? 11 : 12;

    if (Get.arguments?['item'] is DynamicItemModel) {
      opusData = Get.arguments['item'];
    }

    _queryContent();
  }

  Future<bool> _queryOpus(id) async {
    final res = await DynamicsHttp.opusDetail(opusId: id);
    if (res is Success) {
      opusData = (res as Success<DynamicItemModel>).response;
      commentType = opusData!.basic!.commentType!;
      commentId = int.parse(opusData!.basic!.commentIdStr!);
      if (showDynActionBar && opusData!.modules.moduleStat != null) {
        stats.value = opusData!.modules.moduleStat!;
      }
      summary
        ..author ??= opusData!.modules.moduleAuthor
        ..title ??= opusData!.modules.moduleTag?.text;
      return true;
    }
    return false;
  }

  Future<bool> _queryRead(cvid) async {
    final res = await DynamicsHttp.articleView(cvid: cvid);
    if (res is Success) {
      articleData = (res as Success<Item>).response;
      summary
        ..author ??= articleData!.author
        ..title ??= articleData!.title
        ..cover ??= articleData!.originImageUrls?.firstOrNull;

      if (showDynActionBar && opusData == null) {
        final dynId = articleData!.dynIdStr;
        if (dynId != null) {
          _queryReadAsDyn(dynId);
          return true;
        } else {
          debugPrint('cvid2opus failed: $id');
          stats.value = _statesToModuleStat(articleData!.stats!); // TODO remove
        }
      }
    }
    return res is Success;
  }

  _queryReadAsDyn(id) async {
    final res = await DynamicsHttp.dynamicDetail(id: id);
    if (res['status']) {
      opusData = res['data'] as DynamicItemModel;
    }
  }

  // 请求动态内容
  Future _queryContent() async {
    if (type != 'read') {
      isLoaded.value = await _queryOpus(id);
      if (isLoaded.value) queryData();
    } else {
      commentId = int.parse(id.replaceFirst('cv', ''));
      commentType = 12;
      queryData();
      isLoaded.value = await _queryRead(commentId);
    }
    if (isLoaded.value) {
      if (isLogin && !MineController.anonymity.value) {
        VideoHttp.historyReport(aid: commentId, type: 5);
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
      type: commentType,
      oid: commentId,
      cursor: CursorReq(
        next: cursor?.next ?? $fixnum.Int64(0),
        mode: mode.value,
      ),
      antiGoodsReply: antiGoodsReply,
    );
  }

  Future onFav() async {
    bool isFav = stats.value?.favorite?.status == true;
    final res = type == 'read'
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
