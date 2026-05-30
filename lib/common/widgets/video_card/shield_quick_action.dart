import 'package:PiliPlus/features/shielding/shielding.dart';
import 'package:PiliPlus/common/widgets/image/image_save.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

abstract final class VideoCardShieldQuickAction {
  static Future<void> addRule({
    ShieldSettingsStore? store,
    required ShieldRuleType type,
    required String pattern,
    bool showToast = true,
  }) async {
    final trimmed = pattern.trim();
    if (trimmed.isEmpty) {
      return;
    }
    final resolvedStore = store ?? ShieldSettingsStore();
    final rule = await resolvedStore.addQuickActionRule(
      type: type,
      scope: ShieldScope.recommendation,
      pattern: trimmed,
    );
    if (rule == null) {
      if (showToast) {
        SmartDialog.showToast('已存在屏蔽规则');
      }
      return;
    }
    if (showToast) {
      SmartDialog.showToast('已添加屏蔽规则');
    }
  }

  static Future<void> showRecommendationDialog({
    required BuildContext context,
    required String title,
    String? upName,
    String? reason,
    String? cover,
    String? bvid,
    int? upUid,
    VoidCallback? onRuleAdded,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('推荐屏蔽'),
        content: SingleChildScrollView(
          child: SelectionArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TextActionRow(
                  label: '标题',
                  text: title,
                  type: ShieldRuleType.keyword,
                  onRuleAdded: onRuleAdded,
                ),
                if (upName?.trim().isNotEmpty == true)
                  _TextActionRow(
                    label: 'UP',
                    text: upName!.trim(),
                    type: upUid == null
                        ? ShieldRuleType.keyword
                        : ShieldRuleType.uid,
                    pattern: upUid?.toString(),
                    onRuleAdded: onRuleAdded,
                  ),
                if (reason?.trim().isNotEmpty == true)
                  _TextActionRow(
                    label: '推荐理由',
                    text: reason!.trim(),
                    type: ShieldRuleType.keyword,
                    onRuleAdded: onRuleAdded,
                  ),
              ],
            ),
          ),
        ),
        actions: [
          if (cover?.isNotEmpty == true)
            TextButton(
              onPressed: () => imageSaveDialog(
                title: title,
                cover: cover,
                bvid: bvid,
              ),
              child: const Text('保存封面'),
            ),
          TextButton(
            onPressed: Get.back,
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  static Future<void> showTextDialog({
    required BuildContext context,
    required String title,
    required String text,
    required ShieldRuleType type,
    String? pattern,
    VoidCallback? onRuleAdded,
    String? note,
  }) async {
    final resolvedPattern = pattern ?? text;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: SelectionArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text),
                if (note != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    note,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Utils.copyText(text),
            child: const Text('复制'),
          ),
          TextButton(
            onPressed: () async {
              await addRule(
                type: type,
                pattern: resolvedPattern,
              );
              onRuleAdded?.call();
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: const Text('屏蔽'),
          ),
        ],
      ),
    );
  }

  static Future<void> quickRule({
    required ShieldRuleType type,
    required String pattern,
    VoidCallback? onRuleAdded,
  }) async {
    await addRule(type: type, pattern: pattern);
    onRuleAdded?.call();
  }
}

class _TextActionRow extends StatefulWidget {
  const _TextActionRow({
    required this.label,
    required this.text,
    required this.type,
    this.pattern,
    this.onRuleAdded,
  });

  final String label;
  final String text;
  final ShieldRuleType type;
  final String? pattern;
  final VoidCallback? onRuleAdded;

  @override
  State<_TextActionRow> createState() => _TextActionRowState();
}

class _TextActionRowState extends State<_TextActionRow> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(height: 3),
          TextField(
            controller: controller,
            minLines: 1,
            maxLines: 3,
            decoration: const InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 3),
          Wrap(
            spacing: 8,
            children: [
              TextButton(
                onPressed: () => Utils.copyText(_selectedOrFullText()),
                child: const Text('复制'),
              ),
              TextButton(
                onPressed: () async {
                  await VideoCardShieldQuickAction.addRule(
                    type: widget.type,
                    pattern: widget.pattern ?? _selectedOrFullText(),
                  );
                  widget.onRuleAdded?.call();
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('屏蔽'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _selectedOrFullText() {
    if (widget.pattern != null) return widget.pattern!;
    final selection = controller.selection;
    if (!selection.isCollapsed && selection.isValid) {
      return selection.textInside(controller.text);
    }
    return controller.text;
  }
}
