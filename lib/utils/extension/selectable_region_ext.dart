import 'package:PiliPlus/utils/extension/get_ext.dart';
import 'package:PiliPlus/utils/extension/iterable_ext.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

extension SelectableRegionStateExt on SelectableRegionState {
  static final _schemeRegex = RegExp(r'[\w\-]+://\S');

  void addLaunchMenuIfNeeded(
    List<ContextMenuButtonItem> buttonItems, {
    required int index,
  }) {
    if (isUncollapsed) {
      final isScheme = selectedText?.startsWith(_schemeRegex) == true;
      buttonItems.insertOrAdd(
        index,
        ContextMenuButtonItem(
          label: isScheme ? '打开' : '站内搜索',
          onPressed: () => onMenuPressed(
            isScheme
                ? PageUtils.handleWebview
                : (text) => Get.offOrToNamed(
                    '/searchResult',
                    parameters: {'keyword': text},
                    off: Get.routing.route is! PageRoute,
                  ),
          ),
        ),
      );
    }
  }

  /// apply `lib/scripts/selectable_region.patch`
  String? get selectedText => selectable?.getSelectedContent()?.plainText;

  /// apply `lib/scripts/selectable_region.patch`
  bool get isUncollapsed => selectionDelegate.value.status == .uncollapsed;

  void onMenuPressed(
    ValueChanged<String> callback, {
    ValueGetter<String?>? content,
  }) {
    final text = content?.call() ?? selectedText;
    hideAndClear();
    if (text != null && text.isNotEmpty) {
      callback(text);
    }
  }

  void hideAndClear() {
    hideToolbar();
    clearSelection();
  }
}
