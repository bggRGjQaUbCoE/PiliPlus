import 'dart:collection';

import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart';
import 'package:PiliPlus/grpc/bilibili/pagination.pb.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/reply/reply_sort_type.dart';
import 'package:PiliPlus/pages/common/reply/reply_controller.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';

class _ReplyController extends ReplyController<MainListReply> {
  _ReplyController(List<MainListReply> pages) : pages = Queue.of(pages);

  final Queue<MainListReply> pages;

  @override
  int get oid => 1;

  @override
  int get replyType => 1;

  @override
  dynamic get sourceId => 'reply-test';

  @override
  ReplySortType get prefSortType => ReplySortType.hot;

  @override
  Future<LoadingState<MainListReply>> customGetData() async =>
      Success(pages.removeFirst());

  @override
  List<ReplyInfo> getDataList(MainListReply response) => response.replies;
}

ReplyInfo _reply(int id) => ReplyInfo(id: Int64(id));

MainListReply _page(List<int> ids, String offset, {bool end = false}) =>
    MainListReply(
      replies: ids.map(_reply),
      subjectControl: SubjectControl(count: Int64(100)),
      cursor: CursorReply(isEnd: end),
      paginationReply: FeedPaginationReply(nextOffset: offset),
    );

void main() {
  _ReplyController controller(List<MainListReply> pages) {
    final result = _ReplyController(pages)..onInit();
    addTearDown(result.onClose);
    return result;
  }

  List<int> ids(_ReplyController controller) => controller
      .loadingState
      .value
      .data!
      .map((reply) => reply.id.toInt())
      .toList();

  test(
    'deduplicates pinned and paginated replies, then replaces on refresh',
    () async {
      final pinned = _reply(2);
      final ctr = controller([
        _page([1, 2, 1], 'page-2')..upTop = pinned,
        _page([2, 3, 3, 1, 4], '', end: true),
        _page([3, 3, 1], 'page-2'),
      ]);

      await ctr.queryData();
      expect(ids(ctr), [2, 1]);
      expect(ctr.loadingState.value.data!.first, same(pinned));

      await ctr.onLoadMore();
      expect(ids(ctr), [2, 1, 3, 4]);

      await ctr.onRefresh();
      expect(ids(ctr), [3, 1]);
      expect(ctr.isEnd, isFalse);
    },
  );

  test('duplicate-only page advances cursor and allows more replies', () async {
    final ctr = controller([
      _page([1, 2], 'page-2'),
      _page([2, 1, 2], 'page-3'),
      _page([2, 3], '', end: true),
    ]);

    await ctr.queryData();
    await ctr.onLoadMore();

    expect(ids(ctr), [1, 2]);
    expect(ctr.nextOffset, 'page-3');
    expect(ctr.isEnd, isFalse);

    await ctr.onLoadMore();

    expect(ids(ctr), [1, 2, 3]);
    expect(ctr.isEnd, isTrue);
  });
}
