import 'package:flutter/material.dart';
import 'package:get/get.dart';

void addSiteSearchMenuItem(
  EditableTextState state,
  List<ContextMenuButtonItem> items,
) {
  if (!state.textEditingValue.selection.isCollapsed) {
    items.add(
      ContextMenuButtonItem(
        onPressed: () {
          final selectedText = state.textEditingValue.selection.textInside(
            state.textEditingValue.text,
          );
          Get.toNamed('/searchResult', parameters: {'keyword': selectedText});
        },
        label: '站内搜索',
      ),
    );
  }
}

Widget Function(BuildContext, EditableTextState) siteSearchMenuBuilder() {
  return (context, state) {
    final items = state.contextMenuButtonItems;
    addSiteSearchMenuItem(state, items);
    return AdaptiveTextSelectionToolbar.buttonItems(
      buttonItems: items,
      anchors: state.contextMenuAnchors,
    );
  };
}

Widget selectableText(
  String text, {
  TextStyle? style,
  Widget Function(BuildContext, EditableTextState)? contextMenuBuilder,
}) {
  return SelectableText(
    style: style,
    text,
    contextMenuBuilder: contextMenuBuilder,
    scrollPhysics: const NeverScrollableScrollPhysics(),
  );
}

Widget selectableRichText(
  TextSpan textSpan, {
  TextStyle? style,
  Widget Function(BuildContext, EditableTextState)? contextMenuBuilder,
}) {
  return SelectableText.rich(
    style: style,
    textSpan,
    contextMenuBuilder: contextMenuBuilder,
    scrollPhysics: const NeverScrollableScrollPhysics(),
  );
}
