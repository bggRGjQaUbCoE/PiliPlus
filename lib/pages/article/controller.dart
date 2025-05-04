import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show MainListReply, ReplyInfo;
import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/reply.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/dynamics/article_content_model.dart'
    show ArticleContentModel;
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/models/model_avatar.dart';
import 'package:PiliPlus/models/space_article/item.dart';
import 'package:PiliPlus/pages/common/reply_controller.dart';
import 'package:PiliPlus/pages/mine/controller.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/url_utils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class ArticleController extends ReplyController<MainListReply> {
  late String id;
  late String type;

  late String url;
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
  SpaceArticleItem? articleData;
  final Rx<ModuleStatModel?> stats = Rx<ModuleStatModel?>(null);

  List<ArticleContentModel>? get opus =>
      opusData?.modules.moduleContent ?? articleData?.opus?.content;

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
          id = url.split('/').last;
          type = 'opus';
        }
        init();
      });
    } else {
      init();
    }
  }

  void init() {
    url = type == 'read'
        ? 'https://www.bilibili.com/read/cv$id'
        : 'https://www.bilibili.com/opus/$id';
    commentType = type == 'picture' ? 11 : 12;

    _queryContent();
  }

  Future<bool> queryOpus(opusId) async {
    final res = await DynamicsHttp.opusDetail(opusId: opusId);
    if (res.isSuccess) {
      final opusData = res.data;
      //fallback
      if (opusData.fallback?.id != null) {
        id = opusData.fallback!.id!;
        type = 'read';
        init();
        return false;
      }
      this.opusData = opusData;
      commentType = opusData.basic!.commentType!;
      commentId = int.parse(opusData.basic!.commentIdStr!);
      if (showDynActionBar) {
        if (opusData.modules.moduleStat != null) {
          stats.value = opusData.modules.moduleStat;
        } else {
          getArticleInfo();
        }
      }
      summary
        ..author ??= opusData.modules.moduleAuthor
        ..title ??= opusData.modules.moduleTag?.text;
      return true;
    }
    return false;
  }

  Future<bool> queryRead(cvid) async {
    final res = await DynamicsHttp.articleView(cvId: cvid);
    if (res.isSuccess) {
      articleData = res.data;
      summary
        ..author ??= articleData!.author
        ..title ??= articleData!.title
        ..cover ??= articleData!.originImageUrls?.firstOrNull;

      if (showDynActionBar) {
        getArticleInfo();
      }
      return true;
    }
    return false;
  }

  // stats
  Future<bool> getArticleInfo([bool isGetCover = false]) async {
    final res = await DynamicsHttp.articleInfo(cvId: commentId);
    if (res['status']) {
      summary
        ..cover ??= (res['data']?['origin_image_urls'] as List?)?.firstOrNull
        ..title ??= res['data']?['title'];

      stats.value ??= ModuleStatModel(
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
    if (isGetCover) {
      SmartDialog.showToast(res['msg']);
    }
    return false;
  }

  // 请求动态内容
  Future _queryContent() async {
    if (type != 'read') {
      isLoaded.value = await queryOpus(id);
    } else {
      commentId = int.parse(id);
      commentType = 12;
      isLoaded.value = await queryRead(commentId);
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
    return ReplyHttp.mainList(
      type: commentType,
      oid: commentId,
      mode: mode.value,
      offset: paginationReply?.nextOffset,
      sessionId: sessionId,
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

  Future onLike() async {
    bool isLike = stats.value?.like?.status == true;
    final res = await DynamicsHttp.thumbDynamic(
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
  Avatar? author;
  String? title;
  String? cover;

  Summary({this.author, this.title, this.cover});
}
