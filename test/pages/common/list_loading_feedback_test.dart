import 'dart:async';

import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:flutter_test/flutter_test.dart';

class _List extends CommonListController<List<int>, int> {
  final requests = <Completer<LoadingState<List<int>>>>[];
  final requestedPages = <int>[];
  @override
  Future<LoadingState<List<int>>> customGetData() {
    requestedPages.add(page);
    final request = Completer<LoadingState<List<int>>>();
    requests.add(request);
    return request.future;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('failed refresh retains visible content and successful pagination retains prior rows', () async {
    final controller = _List();
    var request = controller.queryData();
    controller.requests.last.complete(Success(List.of(const [1, 2])));
    await request;
    request = controller.onRefresh();
    expect(controller.loadingState.value.dataOrNull, [1, 2]);
    controller.requests.last.complete(const Error('连接错误，请检查网络设置'));
    await request;
    expect(controller.loadingState.value.dataOrNull, [1, 2]);
    controller.onClose();
  });
  test('a completed response cannot mutate a closed controller', () async {
    final controller = _List();
    final request = controller.queryData();
    controller.onClose();
    controller.requests.last.complete(Success(List.of(const [1, 2])));
    await request;
    expect(controller.loadingState.value, isA<Loading>());
  });
  test('pagination failures are visible, retain rows and cursor, and only explicit retry sends again', () async {
    final controller = _List();
    var request = controller.queryData();
    controller.requests.last.complete(Success(List.of(const [1, 2])));
    await request;
    request = controller.onLoadMore();
    await Future<void>.delayed(Duration.zero);
    expect(controller.loadingMore.value, isTrue);
    expect(controller.loadingState.value.dataOrNull, [1, 2]);
    controller.requests.last.complete(const Error('服务器异常，请稍后重试！'));
    await request;
    expect(controller.loadMoreError.value, isNotNull);
    await controller.onLoadMore();
    expect(controller.requests, hasLength(2));
    request = controller.retryLoadMore();
    final duplicate = controller.retryLoadMore();
    expect(controller.requests, hasLength(3));
    expect(controller.requestedPages, [1, 2, 2]);
    controller.requests.last.complete(Success(List.of(const [3, 4])));
    await Future.wait([request, duplicate]);
    expect(controller.loadingState.value.dataOrNull, [1, 2, 3, 4]);
    expect(controller.page, 3);
    controller.onClose();
  });
  test(
    'a new query can paginate while an obsolete page request is still pending',
    () async {
      final controller = _List();
      var request = controller.queryData();
      controller.requests.last.complete(Success(List.of(const [1])));
      await request;
      final obsolete = controller.onLoadMore();
      await Future<void>.delayed(Duration.zero);
      final oldPage = controller.requests.last;
      request = controller.onReload();
      controller.requests.last.complete(Success(List.of(const [20])));
      await request;
      request = controller.onLoadMore();
      await Future<void>.delayed(Duration.zero);
      expect(controller.requests, hasLength(4));
      oldPage.complete(Success(List.of(const [2])));
      await obsolete;
      expect(controller.loadingMore.value, isTrue);
      controller.requests.last.complete(Success(List.of(const [21])));
      await request;
      expect(controller.loadingState.value.dataOrNull, [20, 21]);
      controller.onClose();
    },
  );
}
