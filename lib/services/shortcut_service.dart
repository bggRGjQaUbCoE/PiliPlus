import 'dart:io' show Platform;

import 'package:PiliPlus/plugin/pl_player/models/shortcut_action.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/services.dart'
    show HardwareKeyboard, KeyEvent, LogicalKeyboardKey;

/// 播放器快捷键：自定义绑定的存取、按键匹配与跨平台显示。
///
/// 自定义数据存于 setting box（`Pref.customKeyBindings`）：
/// `{ actionName: bindingJson }`，值为 `'none'` 表示该动作已清除绑定。
abstract final class ShortcutService {
  static final bool _isMac = Platform.isMacOS;

  static final Set<LogicalKeyboardKey> _modifierKeys = {
    LogicalKeyboardKey.shift,
    LogicalKeyboardKey.shiftLeft,
    LogicalKeyboardKey.shiftRight,
    LogicalKeyboardKey.control,
    LogicalKeyboardKey.controlLeft,
    LogicalKeyboardKey.controlRight,
    LogicalKeyboardKey.alt,
    LogicalKeyboardKey.altLeft,
    LogicalKeyboardKey.altRight,
    LogicalKeyboardKey.meta,
    LogicalKeyboardKey.metaLeft,
    LogicalKeyboardKey.metaRight,
  };

  static bool isModifier(LogicalKeyboardKey key) => _modifierKeys.contains(key);

  /// 当前生效的绑定：自定义优先，否则用默认值（已清除的动作为 null）
  static KeyBinding? bindingOf(ShortcutAction action) {
    final custom = Pref.customKeyBindings[action.name];
    if (custom == null) return action.defaultBinding;
    if (custom == 'none') return null;
    return KeyBinding.fromJson(custom) ?? action.defaultBinding;
  }

  static bool isCustomized(ShortcutAction action) =>
      Pref.customKeyBindings.containsKey(action.name);

  /// 按当前按下的键（含修饰键）匹配动作；未绑定或无匹配返回 null
  static ShortcutAction? matchAction(KeyEvent event, {required bool isLive}) {
    final binding = currentBinding(event.logicalKey);
    for (final action in ShortcutAction.values) {
      if (!action.context.applies(isLive)) continue;
      if (action.desktopOnly && !PlatformUtils.isDesktop) continue;
      if (bindingOf(action) == binding) return action;
    }
    return null;
  }

  static KeyBinding currentBinding(LogicalKeyboardKey key) {
    final hw = HardwareKeyboard.instance;
    return KeyBinding(
      key,
      shift: hw.isShiftPressed,
      ctrl: hw.isControlPressed,
      alt: hw.isAltPressed,
      meta: hw.isMetaPressed,
    );
  }

  /// 检测绑定冲突：同上下文（且同平台可见）的其他动作已占用该键位时返回对方
  static ShortcutAction? conflictOf(ShortcutAction action, KeyBinding binding) {
    for (final other in ShortcutAction.values) {
      if (other == action) continue;
      if (!action.context.overlaps(other.context)) continue;
      if (other.desktopOnly && !PlatformUtils.isDesktop) continue;
      if (bindingOf(other) == binding) return other;
    }
    return null;
  }

  /// 保存自定义绑定；与默认一致时直接移除自定义记录
  static void setBinding(ShortcutAction action, KeyBinding binding) {
    final map = Pref.customKeyBindings;
    if (binding == action.defaultBinding) {
      map.remove(action.name);
    } else {
      map[action.name] = binding.toJson();
    }
    Pref.customKeyBindings = map;
  }

  /// 清除绑定（该动作将不再响应任何按键）
  static void clearBinding(ShortcutAction action) {
    final map = Pref.customKeyBindings;
    map[action.name] = 'none';
    Pref.customKeyBindings = map;
  }

  /// 恢复单个动作的默认绑定
  static void resetBinding(ShortcutAction action) {
    final map = Pref.customKeyBindings..remove(action.name);
    Pref.customKeyBindings = map;
  }

  /// 恢复全部默认
  static void resetAll() {
    Pref.customKeyBindings = <String, dynamic>{};
  }

  // ── 显示 ────────────────────────────────────────────────────────────────

  /// 当前按住的修饰键（用于按键捕获的实时预览），无修饰键时返回空串
  static String currentModifiersLabel() {
    final hw = HardwareKeyboard.instance;
    final parts = <String>[];
    if (_isMac) {
      if (hw.isControlPressed) parts.add('⌃');
      if (hw.isAltPressed) parts.add('⌥');
      if (hw.isShiftPressed) parts.add('⇧');
      if (hw.isMetaPressed) parts.add('⌘');
      return parts.join();
    }
    if (hw.isControlPressed) parts.add('Ctrl');
    if (hw.isAltPressed) parts.add('Alt');
    if (hw.isShiftPressed) parts.add('Shift');
    if (hw.isMetaPressed) parts.add(Platform.isLinux ? 'Super' : 'Win');
    return parts.join(' + ');
  }

  static String formatBinding(KeyBinding? binding) {
    if (binding == null) return '未绑定';
    final parts = <String>[];
    if (_isMac) {
      if (binding.ctrl) parts.add('⌃');
      if (binding.alt) parts.add('⌥');
      if (binding.shift) parts.add('⇧');
      if (binding.meta) parts.add('⌘');
      parts.add(keyLabel(binding.key));
      return parts.join();
    }
    if (binding.ctrl) parts.add('Ctrl');
    if (binding.alt) parts.add('Alt');
    if (binding.shift) parts.add('Shift');
    if (binding.meta) parts.add(Platform.isLinux ? 'Super' : 'Win');
    parts.add(keyLabel(binding.key));
    return parts.join(' + ');
  }

  static final Map<LogicalKeyboardKey, String> _keyLabels = {
    LogicalKeyboardKey.space: '空格',
    LogicalKeyboardKey.enter: '回车',
    LogicalKeyboardKey.escape: 'Esc',
    LogicalKeyboardKey.tab: 'Tab',
    LogicalKeyboardKey.arrowUp: '↑',
    LogicalKeyboardKey.arrowDown: '↓',
    LogicalKeyboardKey.arrowLeft: '←',
    LogicalKeyboardKey.arrowRight: '→',
    LogicalKeyboardKey.bracketLeft: '[',
    LogicalKeyboardKey.bracketRight: ']',
    LogicalKeyboardKey.backspace: '退格',
    LogicalKeyboardKey.delete: 'Delete',
    LogicalKeyboardKey.insert: 'Insert',
    LogicalKeyboardKey.home: 'Home',
    LogicalKeyboardKey.end: 'End',
    LogicalKeyboardKey.pageUp: 'PgUp',
    LogicalKeyboardKey.pageDown: 'PgDn',
    LogicalKeyboardKey.mediaPlayPause: '播放/暂停',
    LogicalKeyboardKey.mediaTrackNext: '下一曲',
    LogicalKeyboardKey.mediaTrackPrevious: '上一曲',
  };

  static String keyLabel(LogicalKeyboardKey key) {
    final label = _keyLabels[key];
    if (label != null) return label;
    final l = key.keyLabel;
    return l.length == 1 ? l.toUpperCase() : l;
  }
}
