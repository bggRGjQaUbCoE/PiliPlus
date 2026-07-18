import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/image_preview_type.dart';
import 'package:PiliPlus/models/dynamics/article_content_model.dart'
    show ArticleContentModel;
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/models/model_avatar.dart';
import 'package:PiliPlus/models_new/article/article_view/data.dart';
import 'package:PiliPlus/pages/common/dyn/common_dyn_controller.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/async_operation_guard.dart';
import 'package:PiliPlus/utils/extension/get_ext.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/url_utils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class ArticleController extends CommonDynController {
  final _favoriteGuard = AsyncOperationGuard();
  final _likeGuard = AsyncOperationGuard();

  Object get _actionResourceKey => (type, id, commentId);

  void _applyStatMutation(DynamicStat stat, bool enabled) {
    if (stat.status == enabled) return;
    final nextCount = (stat.count ?? 0) + (enabled ? 1 : -1);
    stat
      ..status = enabled
      ..count = nextCount > 0 ? nextCount : null;
  }

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

  @override
  dynamic get sourceId => commentType == 12 ? 'cv$commentId' : id;

  final RxBool isLoaded = false.obs;
  DynamicItemModel? opusData; // 标题信息从summary获取, 动态没有favorite
  ArticleViewData? articleData;
  final stats = Rxn<ModuleStatModel>();

  List<ArticleContentModel>? get opus =>
      opusData?.modules.moduleContent ?? articleData?.opus?.content;

  List<SourceModel>? _images;
  List<SourceModel> images() => _images ??= opus!
      .where((e) => e.paraType == 2 && e.pic != null)
      .map((e) => SourceModel(url: e.pic!.pics!.first.url!))
      .toList();

  @override
  void onInit() {
    super.onInit();
    final params = Get.parameters;
    id = params['id']!;
    type = params['type']!;

    // to opus
    if (type == 'read') {
      UrlUtils.parseRedirectUrl('https://www.bilibili.com/read/cv$id/').then((
        url,
      ) {
        if (url != null) {
          final opusId = PiliScheme.uriDigitRegExp.firstMatch(url)?.group(1);
          if (opusId != null) {
            id = opusId;
            type = 'opus';
          }
          Get.putOrFind(() => this, tag: type + id);
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
    if (res case Success(:final response)) {
      //fallback
      if (response.fallback?.id != null) {
        id = response.fallback!.id!;
        type = 'read';
        init();
        return false;
      }
      opusData = response;
      commentType = response.basic!.commentType!;
      commentId = int.parse(response.basic!.commentIdStr!);
      if (showDynActionBar) {
        if (response.modules.moduleStat != null) {
          stats.value = response.modules.moduleStat;
        } else {
          getArticleInfo();
        }
      }
      summary
        ..author ??= response.modules.moduleAuthor
        ..title ??= response.modules.moduleTag?.text;
      return true;
    } else {
      loadingState.value = res as Error;
      return false;
    }
  }

  Future<bool> queryRead(int cvid) async {
    final res = await DynamicsHttp.articleView(cvId: cvid);
    if (res case Success(:final response)) {
      articleData = response;
      summary
        ..author ??= response.author
        ..title ??= response.title
        ..cover ??= response.originImageUrls?.firstOrNull;

      if (showDynActionBar) {
        getArticleInfo();
      }
      return true;
    } else {
      loadingState.value = res as Error;
      return false;
    }
  }

  // stats
  Future<bool> getArticleInfo([bool isGetCover = false]) async {
    final res = await DynamicsHttp.articleInfo(cvId: commentId);
    if (res case Success(:final response)) {
      summary
        ..cover ??= response.originImageUrls?.firstOrNull
        ..title ??= response.title;

      stats.value ??= ModuleStatModel(
        comment: DynamicStat(count: response.stats?.reply),
        forward: DynamicStat(count: response.stats?.share),
        like: DynamicStat(
          count: response.stats?.like,
          status: response.stats?.like == 1,
        ),
        favorite: DynamicStat(
          count: response.stats?.favorite,
          status: response.favorite,
        ),
      );
      return true;
    }
    if (isGetCover) {
      res.toast();
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

  Future<void> onFav() => _favoriteGuard.run(() async {
    final resourceKey = _actionResourceKey;
    final targetType = type;
    final targetId = id;
    final targetCommentId = commentId;
    final isFav = stats.value?.favorite?.status == true;
    final res = targetType == 'read'
        ? isFav
              ? await FavHttp.delFavArticle(id: targetCommentId)
              : await FavHttp.addFavArticle(id: targetCommentId)
        : await FavHttp.communityAction(
            opusId: targetId,
            action: isFav ? 4 : 3,
          );
    if (res.isSuccess) {
      if (resourceKey == _actionResourceKey) {
        final currentStats = stats.value;
        if (currentStats != null) {
          _applyStatMutation(
            currentStats.favorite ??= DynamicStat(),
            !isFav,
          );
          stats.refresh();
        }
      }
      SmartDialog.showToast('${isFav ? '取消' : ''}收藏成功');
    } else {
      res.toast();
    }
  });

  Future<void> onLike() => _likeGuard.run(() async {
    final resourceKey = _actionResourceKey;
    final dynamicId = opusData?.idStr ?? articleData?.dynIdStr;
    final isLike = stats.value?.like?.status == true;
    final res = await DynamicsHttp.thumbDynamic(
      dynamicId: dynamicId,
      up: isLike ? 2 : 1,
    );
    if (res.isSuccess) {
      if (resourceKey == _actionResourceKey) {
        final currentStats = stats.value;
        if (currentStats != null) {
          _applyStatMutation(currentStats.like ??= DynamicStat(), !isLike);
          stats.refresh();
        }
      }
      SmartDialog.showToast(!isLike ? '点赞成功' : '取消赞');
    } else {
      res.toast();
    }
  });

  @override
  Future<void> onReload() {
    if (!isLoaded.value) {
      return Future.syncValue(null);
    }
    return super.onReload();
  }
}

class Summary {
  Avatar? author;
  String? title;
  String? cover;

  Summary({this.author, this.title, this.cover});
}
