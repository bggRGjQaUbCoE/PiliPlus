import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/pages/setting/models/model.dart';
import 'package:PiliPlus/plugin/pl_player/models/shortcut_action.dart';
import 'package:PiliPlus/services/shortcut_service.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:flutter/services.dart'
    show KeyDownEvent, KeyUpEvent, LogicalKeyboardKey;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

final List<SettingsModel> shortcutSettings = [
  const SwitchModel(
    title: '启用键盘控制',
    subtitle: '在播放页启用键盘快捷键',
    leading: Icon(Icons.keyboard_alt_outlined),
    setKey: SettingBoxKey.keyboardControl,
    defaultVal: true,
  ),
  for (final action in ShortcutAction.values)
    if (!action.desktopOnly || PlatformUtils.isDesktop)
      NormalModel(
        leading: const Icon(Icons.keyboard_outlined),
        title: action.title,
        getSubtitle: () => _bindingLabel(action),
        onTap: (context, setState) {
          _showCaptureDialog(context, action, setState);
        },
      ),
  const NormalModel(
    leading: Icon(Icons.restart_alt_outlined),
    title: '恢复全部默认',
    subtitle: '清除全部自定义按键绑定',
    onTap: _resetAll,
  ),
];

String _bindingLabel(ShortcutAction action) {
  final text = ShortcutService.formatBinding(
    ShortcutService.bindingOf(action),
  );
  return ShortcutService.isCustomized(action) ? text : '$text（默认）';
}

Future<void> _showCaptureDialog(
  BuildContext context,
  ShortcutAction action,
  VoidCallback setState,
) async {
  final changed = await showDialog<bool>(
    context: context,
    builder: (context) => _CaptureDialog(action: action),
  );
  if (changed == true) {
    setState();
  }
}

void _resetAll(BuildContext context, VoidCallback setState) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      constraints: Style.dialogFixedConstraints,
      title: const Text('恢复全部默认'),
      content: const Text('将清除全部自定义按键绑定，恢复默认键位，确定吗？'),
      actions: [
        TextButton(
          onPressed: Get.back,
          child: Text(
            '取消',
            style: TextStyle(color: ColorScheme.of(context).outline),
          ),
        ),
        TextButton(
          onPressed: () {
            ShortcutService.resetAll();
            Get.back();
            setState();
            SmartDialog.showToast('已恢复全部默认');
          },
          child: const Text('确定'),
        ),
      ],
    ),
  );
}

class _CaptureDialog extends StatelessWidget {
  const _CaptureDialog({required this.action});

  final ShortcutAction action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      constraints: Style.dialogFixedConstraints,
      title: Text(action.title),
      content: _CaptureContent(action: action),
      actions: [
        TextButton(
          onPressed: () {
            ShortcutService.resetBinding(action);
            Get.back(result: true);
          },
          child: Text(
            '恢复默认',
            style: TextStyle(color: theme.colorScheme.outline),
          ),
        ),
        TextButton(
          onPressed: () {
            ShortcutService.clearBinding(action);
            Get.back(result: true);
          },
          child: Text('清除绑定', style: TextStyle(color: theme.colorScheme.error)),
        ),
        TextButton(onPressed: Get.back, child: const Text('取消')),
      ],
    );
  }
}

class _CaptureContent extends StatefulWidget {
  const _CaptureContent({required this.action});

  final ShortcutAction action;

  @override
  State<_CaptureContent> createState() => _CaptureContentState();
}

class _CaptureContentState extends State<_CaptureContent> {
  String? _error;

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    final key = event.logicalKey;
    if (ShortcutService.isModifier(key)) {
      // 按住修饰键时实时刷新预览
      if (event is KeyDownEvent || event is KeyUpEvent) {
        setState(() {});
      }
      return KeyEventResult.handled;
    }
    if (event is! KeyDownEvent) {
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.escape) {
      Get.back();
      return KeyEventResult.handled;
    }
    final binding = ShortcutService.currentBinding(key);
    final conflict = ShortcutService.conflictOf(widget.action, binding);
    if (conflict != null) {
      setState(() => _error = '与「${conflict.title}」冲突，请换一个键');
      return KeyEventResult.handled;
    }
    ShortcutService.setBinding(widget.action, binding);
    SmartDialog.showToast('已保存');
    Get.back(result: true);
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final modifiers = ShortcutService.currentModifiersLabel();
    return Focus(
      autofocus: true,
      onKeyEvent: _onKeyEvent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '当前：${ShortcutService.formatBinding(ShortcutService.bindingOf(widget.action))}',
          ),
          const SizedBox(height: 12),
          Text(
            modifiers.isEmpty ? '请按下新的按键组合…' : '$modifiers + …',
            style: theme.textTheme.titleMedium,
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
          ],
          const SizedBox(height: 8),
          Text(
            '按 Esc 取消；直播与普通视频的快捷键相互独立，可共用同一键位',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}
