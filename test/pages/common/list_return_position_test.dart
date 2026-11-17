import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/search/common_search_controller.dart';
import 'package:PiliPlus/pages/common/search/common_search_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

class _Search extends CommonSearchController<List<int>, int> {
  int requests = 0;
  @override
  Future<LoadingState<List<int>>> customGetData() async {
    requests++;
    return Success(List.generate(100, (i) => i));
  }
}

class _Page extends StatefulWidget {
  const _Page(this.controller);
  final _Search controller;
  @override
  State<_Page> createState() => _PageState();
}

class _PageState extends CommonSearchPageState<_Page, List<int>, int> {
  @override
  _Search get controller => widget.controller;
  @override
  List<Widget> get extraActions => [
    IconButton(
      tooltip: '筛选',
      icon: const Icon(Icons.filter_list),
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        builder: (_) => TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('关闭筛选'),
        ),
      ),
    ),
  ];
  @override
  Widget buildList(List<int> list) => SliverList.builder(
    itemCount: list.length,
    itemBuilder: (context, index) => SizedBox(
      key: ValueKey(list[index]),
      height: 60,
      child: TextButton(
        child: Text('条目 ${list[index]}'),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('返回列表'),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets(
    'the shared list preserves data, scroll and query through repeated details and sheets',
    (tester) async {
      final controller = _Search()..editController.text = '原查询';
      await controller.onRefresh();
      await tester.pumpWidget(MaterialApp(home: _Page(controller)));
      await tester.pumpAndSettle();
      controller.focusNode.unfocus();
      controller.scrollController.jumpTo(400);
      await tester.pumpAndSettle();
      final data = controller.loadingState.value.dataOrNull;
      for (var i = 0; i < 3; i++) {
        await tester.tap(find.text('条目 8'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('返回列表'));
        await tester.pumpAndSettle();
        expect(controller.scrollController.offset, 400);
        expect(
          identical(controller.loadingState.value.dataOrNull, data),
          isTrue,
        );
        expect(controller.editController.text, '原查询');
        expect(controller.requests, 1);
      }
      await tester.tap(find.byTooltip('筛选'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('关闭筛选'));
      await tester.pumpAndSettle();
      expect(controller.scrollController.offset, 400);
      expect(controller.requests, 1);
    controller.editController.text = '新查询';
    await controller.onRefresh();
    await tester.pumpAndSettle();
    expect(controller.scrollController.offset, 0);
    expect(controller.requests, 2);
      await tester.pumpWidget(const SizedBox());
      controller.onClose();
    },
  );
}
