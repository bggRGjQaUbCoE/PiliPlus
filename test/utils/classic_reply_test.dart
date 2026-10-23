import 'dart:io';

import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/reply/reply_sort_type.dart';
import 'package:PiliPlus/pages/common/reply/reply_controller.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:fixnum/fixnum.dart';
import 'package:PiliPlus/grpc/bilibili/pagination.pb.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';

/// Hot replies (100+) are liked, except 104 which nobody liked.
ReplyInfo _reply(int id) =>
    ReplyInfo(id: Int64(id), like: Int64(id > 100 && id != 104 ? 50 : 0));

MainListReply _page(
  List<int> ids, {
  required int next,
  bool end = false,
  int? upTop,
  int total = 100,
}) => MainListReply(
  replies: ids.map(_reply),
  cursor: CursorReply(next: Int64(next), isEnd: end),
  paginationReply: FeedPaginationReply(nextOffset: end ? '' : '$next'),
  upTop: upTop == null ? null : _reply(upTop),
  subjectControl: SubjectControl(count: Int64(total)),
);

/// Serves fake pages: hot ids are 100+, time ids are 1..; cursor = page index.
class _Controller extends ReplyController<MainListReply> {
  _Controller({this.total = 100, this.firstTimePage});

  final requests = <String>[];

  /// Total comments of the area (subject count).
  final int total;

  /// Replaces the first page sorted by time.
  final List<int>? firstTimePage;

  @override
  dynamic get sourceId => 1;

  @override
  int get oid => 1;

  @override
  int get replyType => 1;

  @override
  List<ReplyInfo>? getDataList(MainListReply response) => response.replies;

  @override
  Future<LoadingState<MainListReply>> customGetData() async {
    final page = int.tryParse(nextOffset ?? '') ?? 0;
    final hot = mode == Mode.MAIN_LIST_HOT;
    requests.add('${hot ? 'hot' : 'time'}:$page');
    final base = (hot ? 100 : 0) + page * 10;
    return Success(
      _page(
        !hot && page == 0 && firstTimePage != null
            ? firstTimePage!
            : [for (var i = 1; i <= 10; i++) base + i],
        next: page + 1,
        end: hot && page == 1,
        upTop: 999,
        total: total,
      ),
    );
  }
}

List<int> _ids(Iterable<ReplyInfo> list) =>
    list.map((e) => e.id.toInt()).toList();

void main() {
  late Directory dir;

  setUpAll(() async {
    dir = await Directory.systemTemp.createTemp('piliplus-classic-');
    Hive.init(dir.path);
    GStorage.setting = await Hive.openBox('setting');
    GStorage.localCache = await Hive.openBox('localCache');
  });

  tearDownAll(() async {
    await Hive.close();
    await dir.delete(recursive: true);
  });

  _Controller create(
    ReplySortType sort, {
    int total = 100,
    List<int>? firstTimePage,
  }) {
    GStorage.setting.put(SettingBoxKey.replySortType, sort.index);
    return _Controller(total: total, firstTimePage: firstTimePage)..onInit();
  }

  test('经典：热评来自最热接口，列表按时间，置顶在头部', () async {
    final c = create(ReplySortType.classic);
    expect(c.isClassic, isTrue);
    await c.queryData();

    expect(c.requests, ['hot:0', 'time:0']);
    expect(_ids(c.classicHot), [for (var i = 101; i <= 110; i++) i]);
    expect(c.classicUpTop.value?.id.toInt(), 999);
    // pinned reply is not duplicated into the by-time list
    expect(_ids(c.loadingState.value.data!), [for (var i = 1; i <= 10; i++) i]);
    expect(c.classicHotCount, 3);
  });

  test('更多热门评论：先展开，再分页加载，不影响按时间的分页', () async {
    final c = create(ReplySortType.classic);
    await c.queryData();

    await c.onClassicHotMore(); // expand only: 10 loaded > 3 shown
    expect(c.classicHotExpanded.value, isTrue);
    expect(c.requests, ['hot:0', 'time:0']);

    await c.onClassicHotMore(); // next hot page
    expect(c.requests.last, 'hot:1');
    expect(c.classicHot.length, 20);
    expect(c.classicHotEnd, isTrue);

    await c.onLoadMore(); // by-time paging continues from its own cursor
    expect(c.requests.last, 'time:1');
    expect(_ids(c.loadingState.value.data!).last, 20);

    c.onClassicHotCollapse();
    expect(c.classicHotExpanded.value, isFalse);
  });

  test('排序切换：最新 → 最热 → 经典 → 最新，离开经典时清空头部', () async {
    final c = create(ReplySortType.time);
    await c.queryData();
    expect(c.requests, ['time:0']);
    expect(
      c.loadingState.value.data!.first.id.toInt(),
      999,
      reason: 'pinned first',
    );

    c.queryBySort();
    expect(c.sortType.value, ReplySortType.hot);
    await Future<void>.delayed(Duration.zero);
    c.queryBySort();
    expect(c.sortType.value, ReplySortType.classic);
    await Future<void>.delayed(Duration.zero);
    await c.queryData();
    expect(c.classicHot, isNotEmpty);

    c.queryBySort();
    expect(c.sortType.value, ReplySortType.time);
    await c.queryData();
    expect(c.classicHot, isEmpty);
    expect(c.classicUpTop.value, isNull);
  });

  test('删除头部评论', () async {
    final c = create(ReplySortType.classic);
    await c.queryData();
    final hot = c.classicHot.first;
    c.onRemoveClassic(hot, null);
    expect(c.classicHot.contains(hot), isFalse);
    c.onRemoveClassic(c.classicUpTop.value!, null);
    expect(c.classicUpTop.value, isNull);
  });

  test('热评条数随评论数增长，设置值为上限，评论太少不显示', () {
    const f = ReplyController.classicHotCountFor;
    expect(f(10, 3), 0);
    expect(f(19, 3), 0, reason: 'fits on one page');
    expect(f(20, 3), 1);
    expect(f(39, 3), 1);
    expect(f(40, 3), 2);
    expect(f(80, 3), 3);
    expect(f(5000, 3), 3, reason: 'capped by the setting');
    expect(f(160, 10), 4);
    expect(f(10240, 10), 10);
    expect(f(10240, 20), 10);
  });

  test('评论太少：经典模式直接按时间倒序，没有热评', () async {
    final c = create(ReplySortType.classic, total: 15);
    await c.queryData();
    expect(c.classicHotLimit, 0);
    expect(c.classicHotShown, isEmpty);
    expect(c.classicListIndices(c.loadingState.value.data!)?.length, 10);
  });

  test('没人点赞的不算热评', () async {
    final c = create(ReplySortType.classic);
    await c.queryData();
    expect(_ids(c.classicHotShown), [101, 102, 103]);
    c.classicHotExpanded.value = true;
    expect(_ids(c.classicHotShown).contains(104), isFalse);
  });

  test('去重：热评区显示的评论不再出现在下面按时间的列表里', () async {
    final c = create(
      ReplySortType.classic,
      firstTimePage: [1, 101, 2, 105, 3],
    );
    await c.queryData();
    final list = c.loadingState.value.data!;
    List<int> visible() => [
      for (final i in c.classicListIndices(list)!) list[i].id.toInt(),
    ];

    expect(visible(), [1, 2, 105, 3], reason: '101 is shown above');
    c.classicHotExpanded.value = true;
    expect(visible(), [1, 2, 3], reason: '105 is shown above once expanded');
    c.onClassicHotCollapse();
    expect(visible(), [1, 2, 105, 3]);
  });
}
