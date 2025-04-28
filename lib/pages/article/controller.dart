import 'package:PiliPlus/grpc/app/main/community/reply/v1/reply.pb.dart';
import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/dynamics/article_content_model.dart'
    show ArticleContentModel;
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/models/model_owner.dart';
import 'package:PiliPlus/models/space_article/item.dart';
import 'package:PiliPlus/pages/common/reply_controller.dart';
import 'package:PiliPlus/pages/mine/controller.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/http/reply.dart';
import 'package:fixnum/fixnum.dart' as $fixnum;

class ArticleController extends ReplyController<MainListReply> {
  late String id;
  late String type;

  late String url = type == 'read'
      ? 'https://www.bilibili.com/read/cv$id'
      : 'https://www.bilibili.com/opus/$id';
  late int commentType;
  late int commentId;
  final summary = Summary();

  RxBool showTitle = false.obs;

  late final horizontalPreview = GStorage.horizontalPreview;
  late final showDynActionBar = GStorage.showDynActionBar;

  @override
  dynamic get sourceId => commentType == 12 ? 'cv$commentId' : id;

  final RxBool isLoaded = false.obs;
  DynamicItemModel? opusData; // 标题信息从summary获取, 动态没有favorite
  Item? articleData;
  final Rx<ModuleStatModel?> stats = Rx<ModuleStatModel?>(null);

  List<ArticleContentModel>? get opus =>
      opusData?.modules.moduleContent ?? articleData?.opus?.content;

  @override
  void onInit() {
    super.onInit();
    id = Get.parameters['id']!;
    type = Get.parameters['type']!;

    commentType = type == 'picture' ? 11 : 12;

    _queryContent(); // lazy to opus
  }

  Future<void> _queryOpus(opusId) async {
    final res = await DynamicsHttp.opusDetail(opusId: opusId);
    if (res.isSuccess) {
      final opusData = res.data;
      //fallback
      if (opusData.fallback?.id != null) {
        id = opusData.fallback!.id!;
        type = 'read';
        if (articleData?.content == null) {
          await _queryRead(id, false);
        }
        return;
      }
      this.opusData = opusData;
      commentType = opusData.basic!.commentType!;
      commentId = int.parse(opusData.basic!.commentIdStr!);
      if (showDynActionBar && opusData.modules.moduleStat != null) {
        stats.value = opusData.modules.moduleStat;
      }
      summary
        ..author ??= opusData.modules.moduleAuthor
        ..title ??= opusData.modules.moduleTag?.text;
      isLoaded.value = true;
    }
  }

  Future<void> _queryRead(cvId, [bool toOpus = false]) async {
    final res = await DynamicsHttp.articleView(cvId: cvId);
    if (res.isSuccess) {
      articleData = res.data;
      summary
        ..author ??= articleData!.author
        ..title ??= articleData!.title
        ..cover ??= articleData!.originImageUrls?.firstOrNull;
      isLoaded.value = true;

      if (toOpus &&
          articleData!.dynIdStr != null &&
          articleData?.opus?.content?.isNotEmpty != true) {
        await _queryOpus(articleData!.dynIdStr);
        if (opusData != null) {
          id = articleData!.dynIdStr!;
          type = 'opus';
          isLoaded.refresh();
        }
      }
      if (showDynActionBar && stats.value == null) {
        // _queryReadAsDyn(articleData!.dynIdStr);
        getArticleInfo();
      }
    }
  }

  // stats
  Future<bool> getArticleInfo() async {
    final res = await DynamicsHttp.articleInfo(cvId: commentId);
    if (res['status']) {
      summary
        ..cover ??= (res['data']?['origin_image_urls'] as List?)?.firstOrNull
        ..title ??= res['data']?['title'];

      stats.value = ModuleStatModel(
        comment: DynamicStat(count: res['data']?['stats']?['reply']),
        forward: DynamicStat(count: res['data']?['stats']?['share']),
        like: DynamicStat(
          count: res['data']?['stats']?['like'],
          status: res['data']?['like'] == 1,
        ),
        favorite: DynamicStat(
          count: res['data']?['stats']?['reply'],
          status: res['data']?['favorite'],
        ),
      );
      return true;
    }
    SmartDialog.showToast(res['msg']);
    return false;
  }

  // 请求动态内容
  Future _queryContent() async {
    if (type != 'read') {
      await _queryOpus(id);
    } else {
      commentId = int.parse(id);
      commentType = 12;
      await _queryRead(commentId, true);
    }
    if (isLoaded.value) {
      queryData();
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
            ? await UserHttp.delFavArticle(id: commentId)
            : await UserHttp.addFavArticle(id: commentId)
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

  Future onLike(VoidCallback callback) async {
    bool isLike = stats.value?.like?.status == true;
    final res = await DynamicsHttp.likeDynamic(
        dynamicId: opusData?.idStr ?? articleData?.dynIdStr,
        up: isLike ? 2 : 1);
    if (res['status']) {
      stats.value?.like?.status = !isLike;
      int count = stats.value?.like?.count ?? 0;
      if (isLike) {
        stats.value?.like?.count = count - 1;
      } else {
        stats.value?.like?.count = count + 1;
      }
      stats.refresh();
      SmartDialog.showToast(!isLike ? '点赞成功' : '取消赞');
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }
}

class Summary {
  Owner? author;
  String? title;
  String? cover;

  Summary({this.author, this.title, this.cover});
}
