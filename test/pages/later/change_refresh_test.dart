import 'dart:async';

import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/later_view_type.dart';
import 'package:PiliPlus/models_new/later/data.dart';
import 'package:PiliPlus/models_new/later/list.dart';
import 'package:PiliPlus/pages/later/base_controller.dart';
import 'package:PiliPlus/pages/later/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class _TestLaterController extends LaterController {
  _TestLaterController(super.laterViewType);

  final requests = <int>[];
  final sortOrders = <bool>[];
  bool _initialized = false;
  late Future<LoadingState<LaterData>> Function(int page) fetch;

  @override
  void onInit() {
    super.onInit();
    _initialized = true;
  }

  @override
  Future<void> queryData([bool isRefresh = true]) {
    // Seed an existing list without starting the app's network/storage setup.
    if (!_initialized) return Future.value();
    return super.queryData(isRefresh);
  }

  @override
  Future<LoadingState<LaterData>> fetchLaterPage(int page) {
    requests.add(page);
    sortOrders.add(asc.value);
    return fetch(page);
  }
}

List<LaterItemModel> _items(List<int> aids) =>
    aids.map((aid) => LaterItemModel(aid: aid)).toList();

Success<LaterData> _response(List<int> aids, {int? count}) =>
    Success(LaterData(count: count ?? aids.length, list: _items(aids)));

List<int?> _aids(LaterController controller) =>
    controller.loadingState.value.data!.map((item) => item.aid).toList();

Future<void> _flush() => Future<void>.delayed(Duration.zero);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late LaterBaseController base;

  _TestLaterController createController(
    LaterViewType type, {
    List<int> aids = const [1, 2],
    int? count,
    int nextPage = 2,
  }) {
    final controller = Get.put(
      _TestLaterController(type),
      tag: type.type.toString(),
    );
    controller.loadingState.value = Success(_items(aids));
    controller.page = nextPage;
    base.counts[type.index] = count ?? aids.length;
    return controller;
  }

  setUp(() {
    Get.testMode = true;
    base = Get.put(LaterBaseController());
  });

  tearDown(Get.reset);

  test('notification does not create a later page controller', () {
    Get.delete<LaterBaseController>();
    LaterBaseController.notifyChanged();
    expect(Get.isRegistered<LaterBaseController>(), isFalse);
  });

  test('returning without changes makes no list requests', () async {
    final controller = createController(LaterViewType.all);
    base.setVisible(true);
    await _flush();
    base
      ..setVisible(false)
      ..setVisible(true);
    await _flush();
    expect(base.changeVersion, 0);
    expect(controller.requests, isEmpty);
  });

  test('hidden changes refresh both existing tabs on return', () async {
    final all = createController(LaterViewType.all)
      ..fetch = (_) async => _response([2]);
    final unfinished = createController(LaterViewType.unfinished)
      ..fetch = (_) async => _response([2]);
    LaterBaseController.notifyChanged();
    await _flush();
    expect(all.requests, isEmpty);
    expect(unfinished.requests, isEmpty);

    base.setVisible(true);
    await _flush();
    expect(_aids(all), [2]);
    expect(_aids(unfinished), [2]);
    expect(base.counts.toList(), [1, 1]);
    base
      ..setVisible(false)
      ..setVisible(true);
    await _flush();
    expect(all.requests, [1]);
    expect(unfinished.requests, [1]);
  });

  test(
    'a successful mutation after return refreshes the visible list',
    () async {
      final controller = createController(LaterViewType.all)
        ..fetch = (_) async => _response([2]);
      base.setVisible(true);
      await _flush();
      expect(controller.requests, isEmpty);
      LaterBaseController.notifyChanged();
      await _flush();
      expect(_aids(controller), [2]);
      expect(controller.requests, [1]);
      expect(
        Get.isRegistered<LaterController>(
          tag: LaterViewType.unfinished.type.toString(),
        ),
        isFalse,
      );
    },
  );

  test(
    'cancel and re-add notifications merge into one final refresh',
    () async {
      final controller = createController(LaterViewType.all)
        ..fetch = (_) async => _response([1, 2]);
      base.setVisible(true);
      LaterBaseController.notifyChanged();
      LaterBaseController.notifyChanged();
      await _flush();
      expect(base.changeVersion, 2);
      expect(controller.requests, [1]);
      expect(_aids(controller), [1, 2]);
    },
  );

  test(
    'synchronization waits for pagination without resetting its page',
    () async {
      final pagination = Completer<LoadingState<LaterData>>();
      final controller =
          createController(LaterViewType.all, aids: [1], count: 3)
            ..fetch = (page) =>
                page == 2 ? pagination.future : Future.value(_response([3]));
      final loadingMore = controller.onLoadMore();
      base.markChanged();
      final synchronization = controller.refreshAfterChange();
      expect(
        identical(synchronization, controller.refreshAfterChange()),
        isTrue,
      );
      await _flush();
      expect(controller.requests, [2]);
      expect(controller.page, 2);
      expect(_aids(controller), [1]);
      pagination.complete(_response([2], count: 3));
      await loadingMore;
      await synchronization;
      expect(controller.requests, [2, 1]);
      expect(_aids(controller), [3]);
      expect(controller.page, 2);
      expect(controller.isEnd, isTrue);
      expect(controller.isLoading, isFalse);
    },
  );

  test('loaded pages refresh atomically and pagination can continue', () async {
    final secondPage = Completer<LoadingState<LaterData>>();
    final controller =
        createController(
            LaterViewType.all,
            aids: [1, 2, 3, 4],
            count: 5,
            nextPage: 3,
          )
          ..asc.value = true
          ..fetch = (page) => switch (page) {
            1 => Future.value(_response([2, 3], count: 5)),
            2 => secondPage.future,
            _ => Future.value(_response([6], count: 5)),
          };
    base.markChanged();
    final refresh = controller.refreshAfterChange();
    await _flush();
    expect(controller.requests, [1, 2]);
    expect(_aids(controller), [1, 2, 3, 4]);
    expect(controller.loadingState.value.isSuccess, isTrue);
    secondPage.complete(_response([4, 5], count: 5));
    await refresh;
    expect(_aids(controller), [2, 3, 4, 5]);
    expect(controller.page, 3);
    expect(controller.isEnd, isFalse);
    await controller.onLoadMore();
    expect(controller.requests, [1, 2, 3]);
    expect(controller.sortOrders, [true, true, true]);
    expect(_aids(controller), [2, 3, 4, 5, 6]);
    expect(controller.isEnd, isTrue);
  });

  test(
    'deleting the last video produces an empty list and zero count',
    () async {
      final controller = createController(LaterViewType.all, aids: [1])
        ..fetch = (_) async => _response([]);
      base.markChanged();
      await controller.refreshAfterChange();
      expect(_aids(controller), isEmpty);
      expect(base.counts[LaterViewType.all.index], 0);
      expect(controller.isEnd, isTrue);
      await controller.onLoadMore();
      expect(controller.requests, [1]);
    },
  );

  test('failed refresh preserves the snapshot and retries on return', () async {
    final controller =
        createController(
            LaterViewType.all,
            aids: [1, 2, 3, 4],
            count: 6,
            nextPage: 3,
          )
          ..fetch = (page) async =>
              page == 1 ? _response([2, 3], count: 5) : const Error('offline');
    base.markChanged();
    await controller.refreshAfterChange();
    expect(_aids(controller), [1, 2, 3, 4]);
    expect(base.counts[LaterViewType.all.index], 6);
    expect(controller.page, 3);
    expect(controller.isLoading, isFalse);
    controller.fetch = (page) async =>
        _response(page == 1 ? [2, 3] : [4, 5], count: 5);
    base.setVisible(true);
    await _flush();
    expect(controller.requests, [1, 2, 1, 2]);
    expect(_aids(controller), [2, 3, 4, 5]);
    expect(base.counts[LaterViewType.all.index], 5);
  });

  test(
    'a newer change during refresh discards the outdated response',
    () async {
      final first = Completer<LoadingState<LaterData>>();
      final controller = createController(LaterViewType.all);
      controller.fetch = (_) => controller.requests.length == 1
          ? first.future
          : Future.value(_response([2]));
      base.markChanged();
      final refresh = controller.refreshAfterChange();
      await _flush();
      base.markChanged();
      first.complete(_response([1, 2]));
      await refresh;
      expect(controller.requests, [1, 1]);
      expect(_aids(controller), [2]);
      await controller.refreshAfterChange();
      expect(controller.requests, [1, 1]);
    },
  );

  test('manual refresh acknowledges a pending change', () async {
    final controller = createController(LaterViewType.all)
      ..fetch = (_) async => _response([2]);
    base.markChanged();
    await controller.onRefresh();
    base.setVisible(true);
    await _flush();
    expect(controller.requests, [1]);
    expect(_aids(controller), [2]);
  });

  test('a newer change is handled even if the older refresh fails', () async {
    final first = Completer<LoadingState<LaterData>>();
    final controller = createController(LaterViewType.all);
    controller.fetch = (_) => controller.requests.length == 1
        ? first.future
        : Future.value(_response([2]));
    base.markChanged();
    final refresh = controller.refreshAfterChange();
    await _flush();
    base.markChanged();
    first.complete(const Error('offline'));
    await refresh;
    expect(controller.requests, [1, 1]);
    expect(_aids(controller), [2]);
  });

  test('a thrown fetch error leaves the change pending for retry', () async {
    final controller = createController(LaterViewType.all)
      ..fetch = (_) => Future.error(StateError('offline'));
    base.markChanged();
    await controller.refreshAfterChange();
    expect(_aids(controller), [1, 2]);
    expect(controller.isLoading, isFalse);
    controller.fetch = (_) async => _response([2]);
    await controller.refreshAfterChange();
    expect(controller.requests, [1, 1]);
    expect(_aids(controller), [2]);
  });

  test(
    'a change during the first load is synchronized after it finishes',
    () async {
      final initial = Completer<LoadingState<LaterData>>();
      final controller = createController(LaterViewType.all, nextPage: 1);
      controller.loadingState.value = LoadingState.loading();
      controller.fetch = (_) => controller.requests.length == 1
          ? initial.future
          : Future.value(_response([2]));
      final loading = controller.queryData();
      base.markChanged();
      final refresh = controller.refreshAfterChange();
      await _flush();
      expect(controller.requests, [1]);
      initial.complete(_response([1, 2]));
      await loading;
      await refresh;
      expect(controller.requests, [1, 1]);
      expect(_aids(controller), [2]);
    },
  );

  testWidgets('automatic refresh preserves the scroll offset', (tester) async {
    final controller =
        createController(
            LaterViewType.all,
            aids: List.generate(60, (index) => index + 1),
            nextPage: 4,
          )
          ..fetch = (page) async {
            final remaining = List.generate(59, (index) => index + 2);
            return _response(
              remaining.skip((page - 1) * 20).take(20).toList(),
              count: remaining.length,
            );
          };
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Obx(
            () => ListView.builder(
              controller: controller.scrollController,
              itemExtent: 50,
              itemCount: controller.loadingState.value.data!.length,
              itemBuilder: (_, index) =>
                  Text('${controller.loadingState.value.data![index].aid}'),
            ),
          ),
        ),
      ),
    );
    controller.scrollController.jumpTo(700);
    await tester.pump();
    base.markChanged();
    await controller.refreshAfterChange();
    await tester.pump();
    expect(controller.requests, [1, 2, 3]);
    expect(controller.scrollController.offset, 700);
    expect(controller.loadingState.value.data!.length, 59);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  test('closing during synchronization does not publish its result', () async {
    final request = Completer<LoadingState<LaterData>>();
    final controller = createController(LaterViewType.all)
      ..fetch = (_) => request.future;
    base.markChanged();
    final refresh = controller.refreshAfterChange();
    await _flush();
    Get.delete<_TestLaterController>(
      tag: LaterViewType.all.type.toString(),
    );
    request.complete(_response([2]));
    await refresh;
    expect(_aids(controller), [1, 2]);
    expect(base.counts[LaterViewType.all.index], 2);
  });
}
