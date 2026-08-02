import 'package:PiliPlus/utils/extension/iterable_ext.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:flutter/material.dart';

extension SelectableRegionStateExt on SelectableRegionState {
  void addLaunchMenuIfNeeded(
    List<ContextMenuButtonItem> buttonItems, {
    required int index,
  }) {
    if (isUncollapsed) {
      buttonItems.insertOrAdd(
        index,
        ContextMenuButtonItem(
          label: '打开',
          onPressed: () {
            onMenuPressed(
              PageUtils.launchURL,
              content: () => selectedText?.trim(),
            );
          },
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
