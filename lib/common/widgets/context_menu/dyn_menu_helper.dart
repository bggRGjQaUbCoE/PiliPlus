part of 'package:PiliPlus/pages/dynamics/widgets/content_panel.dart';

Widget dynTextMenuBuilder(
  SelectableRegionState state,
  String text,
  ModuleDynamicModel? moduleDynamic,
) {
  final buttonItems = state.contextMenuButtonItems
    ..insertOrAdd(
      3,
      ContextMenuButtonItem(
        label: '文本',
        onPressed: () {
          state.hideAndClear();
          _showTextDialog(text);
        },
      ),
    )
    ..insertOrAdd(
      4,
      ContextMenuButtonItem(
        label: '表情',
        onPressed: () {
          state.hideAndClear();
          _showEmoteDialog(moduleDynamic);
        },
      ),
    );
  return AdaptiveTextSelectionToolbar.buttonItems(
    buttonItems: buttonItems,
    anchors: state.contextMenuAnchors,
  );
}

void _showEmoteDialog(ModuleDynamicModel? moduleDynamic) {
  if (moduleDynamic == null) return;
  final richTextNodes =
      moduleDynamic.desc?.richTextNodes ??
      moduleDynamic.major?.opus?.summary?.richTextNodes;
  if (richTextNodes == null || richTextNodes.isEmpty) return;
  Map<String, Emoji>? emotes;
  for (final e in richTextNodes) {
    if (e.type == 'RICH_TEXT_NODE_TYPE_EMOJI') {
      emotes ??= <String, Emoji>{};
      if (!emotes.containsKey(e.origText)) {
        emotes[e.origText!] = e.emoji!;
      }
    }
  }
  if (emotes == null || emotes.isEmpty) return;
  showDialog(
    context: Get.context!,
    builder: (context) => Dialog(
      child: Padding(
        padding: const .symmetric(horizontal: 20, vertical: 16),
        child: SingleChildScrollView(
          child: SelectionText.rich(
            TextSpan(
              children: emotes!.entries.mapIndexed(
                (i, e) {
                  final emoji = e.value;
                  final size = emoji.size * 25.0;
                  return TextSpan(
                    children: [
                      if (i != 0) const TextSpan(text: '\n\n'),
                      EmoteSpan(
                        rawText: Style.placeHolder,
                        child: NetworkImgLayer(
                          src: emoji.url,
                          type: .emote,
                          width: size,
                          height: size,
                        ),
                      ),
                      TextSpan(text: '\n${e.key}\n${emoji.url}'),
                    ],
                  );
                },
              ).toList(),
            ),
            contextMenuBuilder: openUrlMenuBuilder,
            style: const TextStyle(fontSize: 15, height: 1.7),
          ),
        ),
      ),
    ),
  );
}

void _showTextDialog(String text) {
  showDialog(
    context: Get.context!,
    builder: (context) => Dialog(
      child: Padding(
        padding: const .symmetric(horizontal: 20, vertical: 16),
        child: SingleChildScrollView(
          child: SelectionText(
            text,
            contextMenuBuilder: openUrlMenuBuilder,
            style: const TextStyle(fontSize: 15, height: 1.7),
          ),
        ),
      ),
    ),
  );
}

Widget openUrlMenuBuilder(_, SelectableRegionState state) {
  final buttonItems = state.contextMenuButtonItems;
  state.addLaunchMenuIfNeeded(buttonItems, index: 3);
  return AdaptiveTextSelectionToolbar.buttonItems(
    buttonItems: buttonItems,
    anchors: state.contextMenuAnchors,
  );
}
