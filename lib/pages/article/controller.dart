import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/dynamics/article_content_model.dart'
    show ArticleContentModel;
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/models/model_avatar.dart';
import 'package:PiliPlus/models_new/article/article_info/data.dart';
import 'package:PiliPlus/models_new/article/article_view/data.dart';
import 'package:PiliPlus/pages/common/dyn/common_dyn_controller.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/url_utils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class ArticleController extends CommonDynController {
  late String id;
  late String type;

  late String url;
  late int commentId;
  @override
  int get oid => commentId;
  late int commentType;
  @override
  int get replyType => commentType;
  final summary = Summary();

  late final RxInt topIndex = 0.obs;

  late final showDynActionBar = Pref.showDynActionBar;

  @override
  dynamic get sourceId => commentType == 12 ? 'cv$commentId' : id;

  final RxBool isLoaded = false.obs;
  DynamicItemModel? opusData; // 标题信息从summary获取, 动态没有favorite
  ArticleViewData? articleData;
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
      UrlUtils.parseRedirectUrl('https://www.bilibili.com/read/cv$id/').then((
        url,
      ) {
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

  Future<bool> queryOpus(String opusId) async {
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

  Future<bool> queryRead(int cvid) async {
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
      ArticleInfoData data = res['data'];
      summary
        ..cover ??= data.originImageUrls?.firstOrNull
        ..title ??= data.title;

      stats.value ??= ModuleStatModel(
        comment: DynamicStat(count: data.stats?.reply),
        forward: DynamicStat(count: data.stats?.share),
        like: DynamicStat(
          count: data.stats?.like,
          status: data.stats?.like == 1,
        ),
        favorite: DynamicStat(
          count: data.stats?.favorite,
          status: data.favorite,
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
  Future<void> _queryContent() async {
    if (type != 'read') {
      isLoaded.value = await queryOpus(id);
    } else {
      commentId = int.parse(id);
      commentType = 12;
      isLoaded.value = await queryRead(commentId);
    }
    if (isLoaded.value) {
      queryData();
      if (Accounts.heartbeat.isLogin && !Pref.historyPause) {
        VideoHttp.historyReport(aid: commentId, type: 5);
      }
    }
  }

  Future<void> onFav() async {
    final favorite = stats.value?.favorite;
    bool isFav = favorite?.status == true;
    final res = type == 'read'
        ? isFav
              ? await FavHttp.delFavArticle(id: commentId)
              : await FavHttp.addFavArticle(id: commentId)
        : await FavHttp.communityAction(opusId: id, action: isFav ? 4 : 3);
    if (res['status']) {
      favorite?.status = !isFav;
      if (isFav) {
        favorite?.count--;
      } else {
        favorite?.count++;
      }
      stats.refresh();
      SmartDialog.showToast('${isFav ? '取消' : ''}收藏成功');
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  Future<void> onLike() async {
    final like = stats.value?.like;
    bool isLike = like?.status == true;
    final res = await DynamicsHttp.thumbDynamic(
      dynamicId: opusData?.idStr ?? articleData?.dynIdStr,
      up: isLike ? 2 : 1,
    );
    if (res['status']) {
      like?.status = !isLike;
      if (isLike) {
        like?.count--;
      } else {
        like?.count++;
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
