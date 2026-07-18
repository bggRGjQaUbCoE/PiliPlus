import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/pgc.dart';
import 'package:PiliPlus/models/common/pgc_review_type.dart';
import 'package:PiliPlus/models_new/pgc/pgc_review/data.dart';
import 'package:PiliPlus/models_new/pgc/pgc_review/list.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/utils/async_operation_guard.dart';
import 'package:PiliPlus/utils/extension/iterable_ext.dart';
import 'package:collection/collection.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class PgcReviewController
    extends CommonListController<PgcReviewData, PgcReviewItemModel> {
  PgcReviewController({required this.type, required this.mediaId});

  final PgcReviewType type;
  final dynamic mediaId;

  final count = RxnInt();
  final _reactionGuard = AsyncKeyedOperationGuard<Object>();
  String? next;
  final sortType = PgcReviewSortType.def.obs;

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

  Future<void> onLike(
    bool isLike,
    Object? reviewId,
  ) {
    if (reviewId == null) return Future<void>.value();
    return _reactionGuard.run(reviewId, () async {
      final res = await PgcHttp.pgcReviewLike(
        mediaId: mediaId,
        reviewId: reviewId,
      );
      if (res.isSuccess) {
        final current = loadingState.value.dataOrNull?.firstWhereOrNull(
          (item) => item.reviewId == reviewId,
        );
        final stat = current?.stat;
        final desired = isLike ? 0 : 1;
        if (stat != null && stat.liked != desired) {
          final likes = stat.likes ?? 0;
          stat
            ..liked = desired
            ..likes = desired == 1 ? likes + 1 : (likes > 0 ? likes - 1 : 0);
          if (desired == 1) stat.disliked = 0;
          loadingState.refresh();
        }
      } else {
        res.toast();
      }
    });
  }

  Future<void> onDislike(
    bool isDislike,
    Object? reviewId,
  ) {
    if (reviewId == null) return Future<void>.value();
    return _reactionGuard.run(reviewId, () async {
      final res = await PgcHttp.pgcReviewDislike(
        mediaId: mediaId,
        reviewId: reviewId,
      );
      if (res.isSuccess) {
        final current = loadingState.value.dataOrNull?.firstWhereOrNull(
          (item) => item.reviewId == reviewId,
        );
        final stat = current?.stat;
        final desired = isDislike ? 0 : 1;
        if (stat != null && stat.disliked != desired) {
          stat.disliked = desired;
          if (desired == 1 && stat.liked == 1) {
            final likes = stat.likes ?? 0;
            stat
              ..likes = likes > 0 ? likes - 1 : 0
              ..liked = 0;
          }
          loadingState.refresh();
        }
      } else {
        res.toast();
      }
    });
  }

  Future<void> onDel(int index, int reviewId) async {
    final res = await PgcHttp.pgcReviewDel(
      mediaId: mediaId,
      reviewId: reviewId,
    );
    if (res.isSuccess) {
      final removed = loadingState.value.dataOrNull?.removeFirstWhere(
        (item) => item.reviewId == reviewId,
      );
      if (removed == true) {
        if (count.value case final current?) {
          count.value = current > 0 ? current - 1 : 0;
        }
        loadingState.refresh();
        if (!isEnd) onRefresh().ignore();
      }
      SmartDialog.showToast('删除成功');
    } else {
      res.toast();
    }
  }

  void queryBySort() {
    if (isLoading) return;
    sortType.value = sortType.value == PgcReviewSortType.def
        ? PgcReviewSortType.latest
        : PgcReviewSortType.def;
    onReload();
  }
}
