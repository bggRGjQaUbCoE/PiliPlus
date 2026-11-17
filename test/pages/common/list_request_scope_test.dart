import 'dart:async';

import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/pages/common/search/common_search_controller.dart';
import 'package:PiliPlus/services/account_service.dart';
import 'package:get/get.dart';
import 'package:flutter_test/flutter_test.dart';

class _List extends CommonListController<List<int>, int> {
  final requests = <Completer<LoadingState<List<int>>>>[];
  @override
  Future<LoadingState<List<int>>> customGetData() {
    final request = Completer<LoadingState<List<int>>>();
    requests.add(request);
    return request.future;
  }
}

class _Search extends CommonSearchController<List<int>, int> {
  final requests = <Completer<LoadingState<List<int>>>>[];
  final queries = <String>[];
  @override
  Future<LoadingState<List<int>>> customGetData() {
    queries.add(editController.text);
    final request = Completer<LoadingState<List<int>>>();
    requests.add(request);
    return request.future;
  }
}

class _ScopedList extends _List {
  Object owner = Object();
  @override
  Object get dataScope => owner;
}

class _Account extends AccountService {
  @override
  // ignore: must_call_super
  void onInit() {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  tearDown(Get.reset);
  test('clearing a pending search invalidates its response and returns to idle without another request', () async {
    final controller = _Search()..onInit();
    expect(controller.loadingState.value, isA<Success>());
    final request = (controller..editController.text = '旧查询').onRefresh();
    expect(controller.onClear(), isTrue);
    expect(controller.loadingState.value.dataOrNull, isNull);
    expect(controller.isLoading, isFalse);
    controller.requests.single.complete(const Success([10]));
    await request;
    expect(controller.loadingState.value.dataOrNull, isNull);
    expect(controller.requests, hasLength(1));
    controller.onClose();
  });
  test(
    'submitting another query does not inherit the previous response',
    () async {
      final controller = _Search()..editController.text = '旧查询';
      final first = controller.onRefresh();
      controller.editController.text = '新查询';
      final second = controller.onRefresh();
      expect(controller.queries, ['旧查询', '新查询']);
      controller.requests[1].complete(const Success([20]));
      await second;
      controller.requests[0].complete(const Success([10]));
      await first;
      expect(controller.loadingState.value.dataOrNull, [20]);
      controller.onClose();
    },
  );
  test('account changes discard cached and pending data; same-account events preserve it', () async {
    final account = Get.put<AccountService>(_Account());
    final controller = _ScopedList()..onInit();
    final first = controller.queryData();
    controller.owner = Object();
    account.isLogin.value = true;
    await Future<void>.delayed(Duration.zero);
    expect(controller.requests, hasLength(2));
    controller.requests[1].complete(const Success([20]));
    await Future<void>.delayed(Duration.zero);
    controller.requests[0].complete(const Success([10]));
    await first;
    expect(controller.loadingState.value.dataOrNull, [20]);
    final data = controller.loadingState.value.dataOrNull;
    account.isLogin.refresh();
    await Future<void>.delayed(Duration.zero);
    expect(controller.requests, hasLength(2));
    expect(identical(controller.loadingState.value.dataOrNull, data), isTrue);
    controller.owner = Object();
    account.accountRevision.value++;
    await Future<void>.delayed(Duration.zero);
    expect(controller.requests, hasLength(3));
    controller.requests[2].complete(const Success([30]));
    await Future<void>.delayed(Duration.zero);
    expect(controller.loadingState.value.dataOrNull, [30]);
    controller.onClose();
  });
  test(
    'new query supersedes an unfinished request; old data cannot replace it',
    () async {
      final controller = _List();
      final first = controller.queryData();
      final second = controller.onReload();
      expect(controller.requests, hasLength(2));
      controller.requests[1].complete(const Success([20, 21]));
      await second;
      controller.requests[0].complete(const Success([10, 11]));
      await first;
      expect(controller.loadingState.value.dataOrNull, [20, 21]);
      expect(controller.page, 2);
      expect(controller.isLoading, isFalse);
      controller.onClose();
    },
  );
}
