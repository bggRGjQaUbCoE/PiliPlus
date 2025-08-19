import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/pgc.dart';
import 'package:PiliPlus/models/common/pgc_review_type.dart';
import 'package:PiliPlus/models_new/pgc/pgc_review/data.dart';
import 'package:PiliPlus/models_new/pgc/pgc_review/list.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class PgcReviewController
    extends CommonListController<PgcReviewData, PgcReviewItemModel> {
  PgcReviewController({required this.type, required this.mediaId});

  final PgcReviewType type;
  final dynamic mediaId;

  Rx<int?> count = Rx<int?>(null);
  String? next;
  Rx<PgcReviewSortType> sortType = PgcReviewSortType.def.obs;

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  Future<void> onRefresh() {
    next = null;
    return super.onRefresh();
  }

  @override
  void checkIsEnd(int length) {
    final count = this.count.value;
    if (count != null && length >= count) {
      isEnd = true;
    }
  }

  @override
  List<PgcReviewItemModel>? getDataList(PgcReviewData response) {
    if (type == PgcReviewType.long &&
        sortType.value == PgcReviewSortType.latest) {
      count.value = null;
    } else {
      count.value = response.count;
    }
    next = response.next;

    return response.list;
  }

  @override
  Future<LoadingState<PgcReviewData>> customGetData() => PgcHttp.pgcReview(
    type: type,
    mediaId: mediaId,
    next: next,
    sort: sortType.value.sort,
  );

  Future<void> onLike(PgcReviewItemModel item, bool isLike, reviewId) async {
    var res = await PgcHttp.pgcReviewLike(
      mediaId: mediaId,
      reviewId: reviewId,
    );
    if (res['status']) {
      int likes = item.stat?.likes ?? 0;
      item.stat
        ?..liked = isLike ? 0 : 1
        ..likes = isLike ? likes - 1 : likes + 1;
      if (!isLike) {
        item.stat?.disliked = 0;
      }
      loadingState.refresh();
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  Future<void> onDislike(
    PgcReviewItemModel item,
    bool isDislike,
    reviewId,
  ) async {
    var res = await PgcHttp.pgcReviewDislike(
      mediaId: mediaId,
      reviewId: reviewId,
    );
    if (res['status']) {
      item.stat?.disliked = isDislike ? 0 : 1;
      if (!isDislike) {
        if (item.stat?.liked == 1) {
          item.stat!.likes = item.stat!.likes! - 1;
        }
        item.stat?.liked = 0;
      }
      loadingState.refresh();
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  Future<void> onDel(int index, int reviewId) async {
    var res = await PgcHttp.pgcReviewDel(
      mediaId: mediaId,
      reviewId: reviewId,
    );
    if (res['status']) {
      loadingState
        ..value.data!.removeAt(index)
        ..refresh();
      SmartDialog.showToast('删除成功');
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  void queryBySort() {
    sortType.value = sortType.value == PgcReviewSortType.def
        ? PgcReviewSortType.latest
        : PgcReviewSortType.def;
    onReload();
  }
}
