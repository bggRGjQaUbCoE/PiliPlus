import 'dart:async';

import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/pages/common/multi_select/base.dart';
import 'package:flutter_test/flutter_test.dart';

final class _Item with MultiSelectData {
  _Item(this.id);

  final int id;
}

final class _Controller extends CommonListController<List<_Item>, _Item>
    with CommonMultiSelectMixin<_Item>, DeleteItemMixin<List<_Item>, _Item> {
  int refreshCount = 0;
  final pendingRefresh = Completer<void>();

  @override
  Future<LoadingState<List<_Item>>> customGetData() async =>
      const Success(<_Item>[]);

  @override
  Future<void> onRefresh() {
    refreshCount += 1;
    page = 1;
    return pendingRefresh.future;
  }

  @override
  void onRemove() {}
}

void main() {
  test(
    'deletion exits selection and reconciles unfinished pagination',
    () async {
      final first = _Item(1)..checked = true;
      final second = _Item(2);
      final controller = _Controller()
        ..page = 4
        ..isEnd = false
        ..loadingState.value = Success([first, second])
        ..enableMultiSelect.value = true
        ..rxCount.value = 1;

      final removed = await controller.afterDeleteWhere((item) => item.id == 1);

      expect(removed, 1);
      expect(controller.loadingState.value.dataOrNull, [second]);
      expect(controller.enableMultiSelect.value, isFalse);
      expect(controller.rxCount.value, 0);
      expect(controller.refreshCount, 1);
      expect(controller.page, 1);
      expect(controller.pendingRefresh.isCompleted, isFalse);
    },
  );

  test('final-page deletion stays local', () async {
    final item = _Item(1);
    final controller = _Controller()
      ..isEnd = true
      ..loadingState.value = Success([item]);

    expect(await controller.afterDeleteWhere((item) => item.id == 1), 1);
    expect(controller.loadingState.value.dataOrNull, isEmpty);
    expect(controller.refreshCount, 0);
  });
}
