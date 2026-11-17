import 'dart:async';

import 'package:PiliPlus/common/widgets/loading_widget/list_body.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class _List extends CommonListController<List<int>, int> {
  final requests = <Completer<LoadingState<List<int>>>>[];
  @override
  Future<LoadingState<List<int>>> customGetData() {
    final request = Completer<LoadingState<List<int>>>();
    requests.add(request);
    return request.future;
  }
}

Widget _page(_List controller, {bool reduced = false}) => MaterialApp(
  home: MediaQuery(
    data: MediaQueryData(disableAnimations: reduced),
    child: CustomScrollView(
      slivers: [
        Obx(
          () => SliverListBody(
            controller: controller,
            state: controller.loadingState.value,
            builder: (rows) => SliverList.list(
              children: rows.map((i) => Text('条目 $i')).toList(),
            ),
          ),
        ),
      ],
    ),
  ),
);

void main() {
  testWidgets(
    'empty results and request failure use different messages and actions',
    (tester) async {
      final controller = _List();
      await tester.pumpWidget(_page(controller));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      var request = controller.queryData();
      controller.requests.last.complete(const Success([]));
      await request;
      await tester.pumpAndSettle();
      expect(find.text('暂无内容'), findsOneWidget);
      expect(find.text('刷新'), findsOneWidget);
      request = controller.onRefresh();
      controller.requests.last.complete(const Error('连接错误，请检查网络设置'));
      await request;
      await tester.pumpAndSettle();
      expect(find.text('暂无内容'), findsNothing);
      expect(find.text('连接错误，请检查网络设置'), findsOneWidget);
      expect(find.text('点击重试'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      controller.onClose();
    },
  );
  testWidgets(
    'first content fades once; cached content, refresh and rebuilds do not restart it',
    (tester) async {
      final controller = _List();
      await tester.pumpWidget(_page(controller));
      expect(find.text('没有数据'), findsNothing);
      final request = controller.queryData();
      controller.requests.last.complete(const Success([1, 2]));
      await request;
      await tester.pump();
      final animation = tester
          .widget<SliverFadeTransition>(find.byType(SliverFadeTransition))
          .opacity;
      expect(animation.value, 0);
      await tester.pump(const Duration(milliseconds: 90));
      expect(animation.value, inExclusiveRange(0, 1));
      await tester.pump(const Duration(milliseconds: 100));
      expect(animation.value, 1);
      final refresh = controller.onRefresh();
      await tester.pump();
      expect(find.text('条目 1'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      controller.requests.last.complete(const Success([3, 4]));
      await refresh;
      await tester.pump();
      expect(animation.value, 1);
      controller.loadingState.refresh();
      await tester.pump();
      expect(animation.value, 1);
      await tester.pumpWidget(const SizedBox());
      controller.onClose();
    },
  );
  for (final reduced in [false, true]) {
    testWidgets(
      'refresh failures keep visible rows with retry, reduced motion=$reduced',
      (tester) async {
        final controller = _List();
        await tester.pumpWidget(_page(controller, reduced: reduced));
        var request = controller.queryData();
        controller.requests.last.complete(const Success([1, 2]));
        await request;
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<SliverFadeTransition>(find.byType(SliverFadeTransition))
              .opacity
              .value,
          1,
        );
        request = controller.onRefresh();
        controller.requests.last.complete(const Error('连接错误，请检查网络设置'));
        await request;
        await tester.pumpAndSettle();
        expect(find.text('条目 1'), findsOneWidget);
        expect(find.textContaining('刷新失败：'), findsOneWidget);
        final retry = tester.widget<TextButton>(
          find.widgetWithText(TextButton, '重试'),
        );
        retry.onPressed!();
        retry.onPressed!();
        expect(controller.requests, hasLength(3));
        controller.requests.last.complete(const Success([3]));
        await tester.pumpAndSettle();
        await tester.pumpWidget(const SizedBox());
        controller.onClose();
      },
    );
  }
}
