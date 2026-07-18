import 'dart:async';

import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/common_data_controller.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:flutter_test/flutter_test.dart';

typedef _PendingRequest = ({
  String key,
  int page,
  Completer<LoadingState<String>> completer,
});

class _TestListController extends CommonListController<String, String> {
  String key = 'initial';
  final requests = <_PendingRequest>[];
  bool reloadFromResponseHandler = false;
  bool _didReloadFromResponseHandler = false;

  @override
  Future<LoadingState<String>> customGetData() {
    final request = (
      key: key,
      page: page,
      completer: Completer<LoadingState<String>>(),
    );
    requests.add(request);
    return request.completer.future;
  }

  @override
  List<String> getDataList(String response) =>
      response == 'empty' ? const [] : [response];

  @override
  bool customHandleResponse(bool isRefresh, Success<String> response) {
    if (reloadFromResponseHandler && !_didReloadFromResponseHandler) {
      _didReloadFromResponseHandler = true;
      key = 'handler-latest';
      unawaited(onRefresh());
    }
    return false;
  }
}

class _TestDataController extends CommonDataController<String, String> {
  String account = 'account-a';
  final requests = <_PendingRequest>[];

  @override
  Future<LoadingState<String>> customGetData() {
    final request = (
      key: account,
      page: 0,
      completer: Completer<LoadingState<String>>(),
    );
    requests.add(request);
    return request.completer.future;
  }
}

void main() {
  test(
    'load-more followed by reload runs a fresh first-page request',
    () async {
      final controller = _TestListController()
        ..page = 2
        ..loadingState.value = const Success(['existing']);
      addTearDown(controller.onClose);

      final loadMore = controller.onLoadMore();
      expect(controller.requests, hasLength(1));
      expect(controller.requests.single.page, 2);

      controller.key = 'reloaded';
      final reload = controller.onReload();
      var reloadCompleted = false;
      reload.then((_) => reloadCompleted = true);
      expect(controller.requests, hasLength(1));
      expect(controller.loadingState.value, isA<Loading>());

      controller.requests.first.completer.complete(const Success('stale-page'));
      await Future<void>.delayed(Duration.zero);

      expect(controller.requests, hasLength(2));
      expect(controller.requests.last.key, 'reloaded');
      expect(controller.requests.last.page, 1);
      expect(controller.loadingState.value, isA<Loading>());
      expect(reloadCompleted, isFalse);

      controller.requests.last.completer.complete(const Success('fresh-page'));
      await Future.wait([loadMore, reload]);

      expect(controller.loadingState.value.data, ['fresh-page']);
      expect(controller.page, 2);
      expect(controller.isLoading, isFalse);
      expect(reloadCompleted, isTrue);
    },
  );

  test('the latest keyword wins while an older search is in flight', () async {
    final controller = _TestListController()..key = 'old-keyword';
    addTearDown(controller.onClose);

    final oldSearch = controller.onRefresh();
    controller.key = 'new-keyword';
    final newSearch = controller.onRefresh();

    controller.requests.first.completer.complete(const Success('empty'));
    await Future<void>.delayed(Duration.zero);

    expect(controller.requests.map((request) => request.key), [
      'old-keyword',
      'new-keyword',
    ]);
    expect(controller.loadingState.value.dataOrNull, isNull);
    expect(controller.isEnd, isFalse);

    controller.requests.last.completer.complete(const Success('new-result'));
    await Future.wait([oldSearch, newSearch]);

    expect(controller.loadingState.value.data, ['new-result']);
  });

  test('an account reload discards the previous account response', () async {
    final controller = _TestDataController();
    addTearDown(controller.onClose);

    final accountARequest = controller.queryData();
    controller.account = 'account-b';
    final accountBReload = controller.onReload();

    controller.requests.first.completer.complete(const Success('account-a'));
    await Future<void>.delayed(Duration.zero);

    expect(controller.requests.map((request) => request.key), [
      'account-a',
      'account-b',
    ]);
    expect(controller.loadingState.value, isA<Loading>());

    controller.requests.last.completer.complete(const Success('account-b'));
    await Future.wait([accountARequest, accountBReload]);

    expect(controller.loadingState.value.data, 'account-b');
  });

  test(
    'a response handler cannot mutate state after reentrant reload',
    () async {
      final controller = _TestListController()
        ..page = 4
        ..reloadFromResponseHandler = true;
      addTearDown(controller.onClose);

      final request = controller.queryData();
      controller.requests.first.completer.complete(const Success('stale'));
      await Future<void>.delayed(Duration.zero);

      expect(controller.requests, hasLength(2));
      expect(controller.requests.last.key, 'handler-latest');
      expect(controller.loadingState.value.dataOrNull, isNull);
      expect(controller.page, 1);

      controller.requests.last.completer.complete(const Success('latest'));
      await request;

      expect(controller.loadingState.value.data, ['latest']);
      expect(controller.page, 2);
    },
  );

  test('request errors clear loading state and allow retry', () async {
    final controller = _TestDataController();
    addTearDown(controller.onClose);

    final failedRequest = controller.queryData();
    controller.requests.first.completer.completeError(
      StateError('request failed'),
    );

    await expectLater(failedRequest, throwsStateError);
    expect(controller.isLoading, isFalse);

    final retry = controller.queryData();
    expect(controller.requests, hasLength(2));
    controller.requests.last.completer.complete(const Success('recovered'));
    await retry;

    expect(controller.loadingState.value.data, 'recovered');
    expect(controller.isLoading, isFalse);
  });

  test('completion after controller close cannot apply stale state', () async {
    final controller = _TestDataController()
      ..loadingState.value = const Success('existing');

    final request = controller.queryData();
    controller.onDelete();
    controller.requests.single.completer.complete(const Success('stale'));
    await request;

    expect(controller.isClosed, isTrue);
    expect(controller.loadingState.value.data, 'existing');
    expect(controller.isLoading, isFalse);

    await controller.queryData();
    expect(controller.requests, hasLength(1));
  });
}
