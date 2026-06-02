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
    ShieldMatchMode matchMode = ShieldMatchMode.exact,
    bool showToast = true,
    String? successLabel,
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
      matchMode: matchMode,
    );
    if (rule == null) {
      if (showToast) {
        SmartDialog.showToast(
          '规则已存在：${successLabel ?? _ruleLabel(type, trimmed)}',
        );
      }
      return;
    }
    if (showToast) {
      SmartDialog.showToast(
        '已添加：${successLabel ?? _ruleLabel(type, trimmed)}',
      );
    }
  }

  static List<UpShieldRuleOption> upRuleOptions({
    required String upName,
    Object? upUid,
  }) {
    final trimmedName = upName.trim();
    final uid = upUid?.toString().trim();
    return [
      if (uid?.isNotEmpty == true)
        UpShieldRuleOption(
          label: '屏蔽用户 UID: $uid',
          type: ShieldRuleType.uid,
          pattern: uid!,
        ),
      if (trimmedName.isNotEmpty)
        UpShieldRuleOption(
          label: '屏蔽用户名关键词: $trimmedName',
          type: ShieldRuleType.userKeyword,
          matchMode: ShieldMatchMode.token,
          pattern: trimmedName,
        ),
    ];
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
    ShieldSettingsStore? store,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        final hasCover = cover?.trim().isNotEmpty == true;
        return AlertDialog(
          title: const Text('推荐屏蔽'),
          content: SingleChildScrollView(
            child: SelectionArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasCover)
                    _RecommendationCoverPreview(
                      title: title,
                      cover: cover!.trim(),
                      bvid: bvid,
                    ),
                  _TextActionRow(
                    label: '标题',
                    text: title,
                    type: ShieldRuleType.keyword,
                    onRuleAdded: onRuleAdded,
                    store: store,
                  ),
                  if (upName?.trim().isNotEmpty == true)
                    _UpActionRow(
                      upName: upName!.trim(),
                      upUid: upUid,
                      onRuleAdded: onRuleAdded,
                      store: store,
                    ),
                  if (reason?.trim().isNotEmpty == true)
                    _TextActionRow(
                      label: '推荐理由',
                      text: reason!.trim(),
                      type: ShieldRuleType.keyword,
                      onRuleAdded: onRuleAdded,
                      store: store,
                    ),
                ],
              ),
            ),
          ),
          actions: hasCover
              ? null
              : [
                  TextButton(
                    onPressed: Get.back,
                    child: const Text('关闭'),
                  ),
                ],
        );
      },
    );
  }

  static Future<void> showUpDialog({
    required BuildContext context,
    required String upName,
    Object? upUid,
    VoidCallback? onRuleAdded,
    ShieldSettingsStore? store,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('UP屏蔽'),
        content: SingleChildScrollView(
          child: SelectionArea(
            child: _UpActionRow(
              upName: upName.trim(),
              upUid: upUid,
              onRuleAdded: onRuleAdded,
              store: store,
            ),
          ),
        ),
        actions: [
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
    ShieldSettingsStore? store,
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
                store: store,
                type: type,
                pattern: resolvedPattern,
                successLabel: _contextualRuleLabel(
                  title,
                  type,
                  resolvedPattern,
                ),
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
    ShieldSettingsStore? store,
  }) async {
    await addRule(store: store, type: type, pattern: pattern);
    onRuleAdded?.call();
  }

  static String _ruleLabel(ShieldRuleType type, String pattern) =>
      switch (type) {
        ShieldRuleType.uid => '屏蔽推荐用户 UID $pattern',
        ShieldRuleType.keyword => '屏蔽推荐标题/正文关键词「$pattern」',
        ShieldRuleType.userKeyword => '屏蔽推荐用户/UP关键词「$pattern」',
        ShieldRuleType.category => '屏蔽推荐分区「$pattern」',
        ShieldRuleType.tag => '屏蔽推荐标签「$pattern」',
      };

  static String _contextualRuleLabel(
    String label,
    ShieldRuleType type,
    String pattern,
  ) {
    if (type == ShieldRuleType.tag) {
      return '屏蔽推荐标签「$pattern」';
    }
    if (label.contains('标题')) {
      return '屏蔽推荐标题关键词「$pattern」';
    }
    if (label.contains('推荐理由')) {
      return '屏蔽推荐理由关键词「$pattern」';
    }
    return _ruleLabel(type, pattern);
  }
}

class UpShieldRuleOption {
  const UpShieldRuleOption({
    required this.label,
    required this.type,
    required this.pattern,
    this.matchMode = ShieldMatchMode.exact,
  });

  final String label;
  final ShieldRuleType type;
  final String pattern;
  final ShieldMatchMode matchMode;
}

class _RecommendationCoverPreview extends StatelessWidget {
  const _RecommendationCoverPreview({
    required this.title,
    required this.cover,
    required this.bvid,
  });

  final String title;
  final String cover;
  final String? bvid;

  @override
  Widget build(BuildContext context) {
    final shortestSide = MediaQuery.sizeOf(context).shortestSide;
    final previewWidth = shortestSide < 456 ? shortestSide - 96 : 360.0;
    final width = previewWidth < 240 ? 240.0 : previewWidth;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ConstrainedBox(
        key: const Key('recommendation-cover-preview'),
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CoverImage(
              src: cover.http2https,
              width: width,
              height: width * 9 / 16,
            ),
            const SizedBox(height: 3),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
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
                  child: const Text('取消'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CoverImage extends StatelessWidget {
  const _CoverImage({
    required this.src,
    required this.width,
    required this.height,
  });

  final String src;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final placeholder = Container(
      width: width,
      height: height,
      color: colorScheme.onInverseSurface.withValues(alpha: 0.4),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        src,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => placeholder,
      ),
    );
  }
}

class _UpActionRow extends StatefulWidget {
  const _UpActionRow({
    required this.upName,
    required this.upUid,
    this.onRuleAdded,
    this.store,
  });

  final String upName;
  final Object? upUid;
  final VoidCallback? onRuleAdded;
  final ShieldSettingsStore? store;

  @override
  State<_UpActionRow> createState() => _UpActionRowState();
}

class _UpActionRowState extends State<_UpActionRow> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.upName);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final options = VideoCardShieldQuickAction.upRuleOptions(
      upName: widget.upName,
      upUid: widget.upUid,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'UP',
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
            runSpacing: 4,
            children: [
              TextButton(
                onPressed: () => Utils.copyText(_selectedOrFullText()),
                child: const Text('复制'),
              ),
              for (final option in options)
                TextButton(
                  onPressed: () async {
                    final selectedText = _selectedOrFullText();
                    final pattern = option.type == ShieldRuleType.userKeyword
                        ? selectedText
                        : option.pattern;
                    final successLabel =
                        option.type == ShieldRuleType.userKeyword
                        ? '屏蔽用户名关键词: $pattern'
                        : option.label;
                    await VideoCardShieldQuickAction.addRule(
                      store: widget.store,
                      type: option.type,
                      pattern: pattern,
                      matchMode: option.matchMode,
                      successLabel: successLabel,
                    );
                    widget.onRuleAdded?.call();
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(option.label),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _selectedOrFullText() {
    final selection = controller.selection;
    if (!selection.isCollapsed && selection.isValid) {
      return selection.textInside(controller.text);
    }
    return controller.text;
  }
}

class _TextActionRow extends StatefulWidget {
  const _TextActionRow({
    required this.label,
    required this.text,
    required this.type,
    this.onRuleAdded,
    this.store,
  });

  final String label;
  final String text;
  final ShieldRuleType type;
  final VoidCallback? onRuleAdded;
  final ShieldSettingsStore? store;

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
                  final selectedText = _selectedOrFullText();
                  await VideoCardShieldQuickAction.addRule(
                    store: widget.store,
                    type: widget.type,
                    pattern: selectedText,
                    successLabel:
                        VideoCardShieldQuickAction._contextualRuleLabel(
                          widget.label,
                          widget.type,
                          selectedText,
                        ),
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
    final selection = controller.selection;
    if (!selection.isCollapsed && selection.isValid) {
      return selection.textInside(controller.text);
    }
    return controller.text;
  }
}
