part of 'package:PiliPlus/pages/video/reply/widgets/reply_item_grpc.dart';

void showEmoteDownloadSheet(
  BuildContext context,
  List<(String, String)> emotes,
) {
  showModalBottomSheet(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    constraints: BoxConstraints(
      maxWidth: min(640, context.mediaQueryShortestSide),
    ),
    builder: (context) {
      final theme = Theme.of(context);
      return Padding(
        padding: .only(
          bottom: MediaQuery.viewPaddingOf(context).bottom + 12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const .fromLTRB(16, 16, 8, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '选择要保存的表情',
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back();
                      ImageUtils.downloadEmotes(emotes);
                    },
                    child: const Text('全部保存'),
                  ),
                ],
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 360),
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final (name, url) in emotes)
                    ListTile(
                      leading: NetworkImgLayer(
                        src: url,
                        type: .emote,
                        width: 36,
                        height: 36,
                      ),
                      title: Text(name),
                      onTap: () {
                        Get.back();
                        ImageUtils.downloadEmotes([(name, url)]);
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

void showReplyCopyDialog(
  BuildContext context,
  String message,
  Map<String, Emote> emotes,
) {
  bool showEmote = false;
  showDialog(
    context: context,
    builder: (context) => Dialog(
      constraints: const BoxConstraints.tightFor(width: 380),
      child: Padding(
        padding: const .symmetric(horizontal: 20, vertical: 16),
        child: SelectionArea(
          contextMenuBuilder: (_, state) {
            final buttonItems = state.contextMenuButtonItems;
            if (emotes.isNotEmpty) {
              buttonItems.insertOrAdd(
                3,
                ContextMenuButtonItem(
                  label: showEmote ? '文本' : '表情',
                  onPressed: () {
                    state.hideAndClear();
                    showEmote = !showEmote;
                    (context as Element).markNeedsBuild();
                  },
                ),
              );
            }
            state.addLaunchMenuIfNeeded(buttonItems, index: 4);
            if (state.isUncollapsed) {
              buttonItems.add(
                ContextMenuButtonItem(
                  onPressed: () {
                    String text = RegExp.escape(state.selectedText!);
                    if (ReplyGrpc.enableFilter) text = '|$text';

                    showConfirmDialog(
                      context: context,
                      title: const Text('是否确认评论过滤的变更：'),
                      content: Text.rich(
                        TextSpan(
                          text: ReplyGrpc.replyRegExp.pattern,
                          children: [
                            TextSpan(
                              text: text,
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: .bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onConfirm: () {
                        final filter = ReplyGrpc.replyRegExp.pattern + text;
                        ReplyGrpc.replyRegExp = RegExp(
                          filter,
                          caseSensitive: true,
                        );
                        ReplyGrpc.enableFilter = true;
                        GStorage.setting.put(
                          SettingBoxKey.banWordForReply,
                          filter,
                        );
                        SmartDialog.showToast('已保存');
                      },
                    );
                  },
                  label: '加入过滤',
                ),
              );
            }
            return AdaptiveTextSelectionToolbar.buttonItems(
              buttonItems: buttonItems,
              anchors: state.contextMenuAnchors,
            );
          },
          child: SingleChildScrollView(
            child: Text.rich(
              showEmote
                  ? TextSpan(
                      children: emotes.entries.mapIndexed(
                        (i, e) {
                          final emote = e.value;
                          final size = emote.size.toInt() * 25.0;
                          return TextSpan(
                            children: [
                              if (i != 0) const TextSpan(text: '\n\n'),
                              WidgetSpan(
                                child: NetworkImgLayer(
                                  src: emote.url,
                                  type: .emote,
                                  width: size,
                                  height: size,
                                ),
                              ),
                              TextSpan(text: '\n${e.key}\n${emote.url}'),
                            ],
                          );
                        },
                      ).toList(),
                    )
                  : TextSpan(text: message),
              style: const TextStyle(fontSize: 15, height: 1.7),
            ),
          ),
        ),
      ),
    ),
  );
}
