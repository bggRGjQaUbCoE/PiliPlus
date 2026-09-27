import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/member/contribute_type.dart';
import 'package:PiliPlus/models_new/space/space_archive/data.dart';
import 'package:PiliPlus/models_new/space/space_archive/item.dart';
import 'package:PiliPlus/pages/member_video/controller.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

/// 每页固定 2 条，方便用很小的页数覆盖「连续翻页上限」。
const _pageSize = 2;

SpaceArchiveItem _item({required String id, required int play}) {
  return SpaceArchiveItem.fromJson({
    'title': 'video $id',
    'param': id,
    'bvid': 'BV$id',
    'play': play,
  });
}

SpaceArchiveData _page({
  required int page,
  required int play,
  required bool hasNext,
}) {
  return SpaceArchiveData(
    count: 1000,
    hasNext: hasNext,
    hasPrev: page > 0,
    item: [
      for (var i = 0; i < _pageSize; i++)
        _item(id: '${page}_$i', play: play),
    ],
  );
}

/// 按请求序号返回页面。[plays] 决定每页播放量，长度同时决定总页数，
/// 最后一页标记为没有下一页。
class _FakeArchive {
  _FakeArchive(this.plays);

  final List<int> plays;
  int requests = 0;
  bool failNext = false;

  Future<LoadingState<SpaceArchiveData>> load({
    required ContributeType type,
    required int? mid,
    String? aid,
    int? pn,
    int? next,
    int? seasonId,
    int? seriesId,
    bool? includeCursor,
    Object? order,
    Object? sort,
  }) async {
    final index = requests++;
    if (failNext) {
      failNext = false;
      return const Error('network down');
    }
    if (plays.isEmpty) {
      return Success(_page(page: index, play: 0, hasNext: false));
    }
    final last = index >= plays.length - 1;
    return Success(
      _page(
        page: index,
        play: plays[last ? plays.length - 1 : index],
        hasNext: !last,
      ),
    );
  }
}

/// 视口宽 200：委托行高 = 200 / 1 + 110 = 310，行距 312。
/// 视口高 1200 扣掉头部 48 后可容纳 3 行，因此 3 条可见内容即铺满。
const _viewportHeight = 1200.0;
const _crossAxisExtent = 200.0;

MemberVideoCtr _controller(_FakeArchive archive) {
  final controller = MemberVideoCtr(
    heroTag: null,
    type: ContributeType.video,
    mid: 1,
    seasonId: null,
    seriesId: null,
    archiveLoader: archive.load,
    // 行高 = 列宽 / childAspectRatio + 110。200 宽下单列、行距 312。
    gridDelegate: SliverGridDelegateWithExtentAndRatio(
      maxCrossAxisExtent: 480,
      mainAxisSpacing: 2,
      mainAxisExtent: 110,
    ),
  );
  // 跳过 onInit 里的首屏请求，由测试显式 queryData。
  Get.put(controller, tag: 'autofill-${identityHashCode(archive)}');
  return controller;
}

void main() {
  setUp(() => Get.testMode = true);

  tearDown(Get.reset);

  test('过滤后不足一屏时自动翻页，铺满后停止', () async {
    // 前两页全部低于阈值，其后每页命中：3 行铺满一屏后即停，
    // 且不会把剩余页全部请求完。
    final archive = _FakeArchive([0, 0, 2000000, 2000000, 2000000]);
    final controller = _controller(archive);
    controller.filter
      ..enableMinPlay = true
      ..minPlay = 1000000;

    await controller.queryData();
    expect(controller.filteredList, isEmpty);

    await controller.onFilterChanged(
      viewportHeight: _viewportHeight,
      crossAxisExtent: _crossAxisExtent,
    );
    // 补载循环内部有 600ms 间隔，留足余量。
    await Future<void>.delayed(const Duration(seconds: 4));

    expect(controller.isAutoLoading.value, isFalse);
    expect(controller.filteredList.length, greaterThanOrEqualTo(3));
    expect(controller.isEnd, isFalse, reason: '铺满即停，不应翻到作者列表尽头');
    expect(archive.requests, lessThan(archive.plays.length));
    expect(controller.autoLoadPaused.value, isFalse);
  });

  test('作者视频全部加载完毕时停止，无可见项时列表为空', () async {
    final archive = _FakeArchive([0, 0, 0]);
    final controller = _controller(archive);
    controller.filter
      ..enableMinPlay = true
      ..minPlay = 1000000;

    await controller.queryData();
    await controller.onFilterChanged(
      viewportHeight: _viewportHeight,
      crossAxisExtent: _crossAxisExtent,
    );
    await Future<void>.delayed(const Duration(seconds: 3));

    expect(controller.isEnd, isTrue);
    expect(controller.filteredList, isEmpty);
    expect(controller.isAutoLoading.value, isFalse);
    expect(archive.requests, archive.plays.length);
  });

  test('连续翻页达到上限后暂停且不再请求', () async {
    final archive = _FakeArchive(List.filled(5, 0));
    final controller = _controller(archive);
    controller.filter
      ..enableMinPlay = true
      ..minPlay = 1000000;

    await controller.queryData();
    await controller.onFilterChanged(
      viewportHeight: _viewportHeight,
      crossAxisExtent: _crossAxisExtent,
      maxPages: 2,
    );
    await Future<void>.delayed(const Duration(seconds: 3));

    expect(controller.autoLoadPaused.value, isTrue);
    expect(controller.isEnd, isFalse);
    expect(controller.filteredList, isEmpty);
    final requestsAtPause = archive.requests;

    // 暂停后再次调度不应继续请求。
    controller.scheduleAutoLoadMore(
      viewportHeight: _viewportHeight,
      crossAxisExtent: _crossAxisExtent,
    );
    await Future<void>.delayed(const Duration(milliseconds: 300));
    expect(archive.requests, requestsAtPause);

    // 用户手动上拉清除暂停态，之后可继续自动补载。
    controller.manualLoadMore();
    await Future<void>.delayed(const Duration(milliseconds: 100));
    expect(controller.autoLoadPaused.value, isFalse);
    expect(archive.requests, greaterThan(requestsAtPause));
  });

  test('请求失败时停止且不反复请求', () async {
    // 首屏低于阈值被滤空，下一页请求失败：应停在空列表且不反复请求。
    final archive = _FakeArchive([0, 2000000, 2000000]);
    final controller = _controller(archive);
    controller.filter
      ..enableMinPlay = true
      ..minPlay = 1000000;

    await controller.queryData();
    archive.failNext = true;
    await controller.onFilterChanged(
      viewportHeight: _viewportHeight,
      crossAxisExtent: _crossAxisExtent,
    );
    await Future<void>.delayed(const Duration(seconds: 2));

    expect(controller.isAutoLoading.value, isFalse);
    expect(controller.filteredList, isEmpty);
    expect(archive.requests, 2, reason: '首屏 1 次 + 失败 1 次，失败后不再重试');
  });

  test('过滤未开启时不会自动连翻', () async {
    final archive = _FakeArchive([0, 0, 0, 0]);
    final controller = _controller(archive);

    await controller.queryData();
    final requestsAfterFirstPage = archive.requests;
    await controller.onFilterChanged(
      viewportHeight: _viewportHeight,
      crossAxisExtent: _crossAxisExtent,
    );
    controller.scheduleAutoLoadMore(
      viewportHeight: _viewportHeight,
      crossAxisExtent: _crossAxisExtent,
    );
    await Future<void>.delayed(const Duration(milliseconds: 500));

    expect(archive.requests, requestsAfterFirstPage);
    expect(controller.filteredList.length, _pageSize);
    expect(controller.isAutoLoading.value, isFalse);
  });

  test('可见内容估算：不足一屏为 false，铺满一屏为 true', () {
    final controller = _controller(_FakeArchive(const []));
    bool fills(int count) => controller.filteredContentFillsViewport(
      visibleCount: count,
      viewportHeight: _viewportHeight,
      crossAxisExtent: _crossAxisExtent,
    );

    expect(fills(0), isFalse);
    expect(fills(1), isFalse);
    expect(fills(3), isTrue);
    expect(
      controller.filteredContentFillsViewport(
        visibleCount: 100,
        viewportHeight: null,
        crossAxisExtent: _crossAxisExtent,
      ),
      isFalse,
      reason: '视口高度未知时按未铺满处理，让自动补载继续推进',
    );
  });
}
