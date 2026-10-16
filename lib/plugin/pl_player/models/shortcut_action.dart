import 'package:flutter/services.dart' show LogicalKeyboardKey;

/// 快捷键适用场景：直播与普通视频上下文互斥（直播页没有 introController）
enum ShortcutContext {
  both,
  vod,
  live;

  bool applies(bool isLive) => switch (this) {
    .both => true,
    .vod => !isLive,
    .live => isLive,
  };

  /// 两个场景是否存在重叠（用于冲突检测：live 与 vod 互斥，可共用同一键位）
  bool overlaps(ShortcutContext other) =>
      this == .both || other == .both || this == other;
}

enum ShortcutCategory {
  playback('播放控制'),
  volumeSeek('音量与进度'),
  display('画面显示'),
  danmaku('弹幕'),
  interact('互动'),
  speedEpisode('倍速与选集');

  final String title;
  const ShortcutCategory(this.title);
}

/// 一组按键绑定：主键 + 修饰键。修饰键取自 HardwareKeyboard 的实时按压状态，
/// 因此同一组合在 Windows/Linux 上是 Ctrl，在 macOS 上录到的会是 ⌘。
class KeyBinding {
  final LogicalKeyboardKey key;
  final bool shift;
  final bool ctrl;
  final bool alt;
  final bool meta;

  const KeyBinding(
    this.key, {
    this.shift = false,
    this.ctrl = false,
    this.alt = false,
    this.meta = false,
  });

  Map<String, dynamic> toJson() => {
    'key': key.keyId,
    'shift': shift,
    'ctrl': ctrl,
    'alt': alt,
    'meta': meta,
  };

  static KeyBinding? fromJson(dynamic json) {
    if (json is Map) {
      final keyId = json['key'];
      if (keyId is int) {
        return KeyBinding(
          LogicalKeyboardKey(keyId),
          shift: json['shift'] == true,
          ctrl: json['ctrl'] == true,
          alt: json['alt'] == true,
          meta: json['meta'] == true,
        );
      }
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      other is KeyBinding &&
      other.key == key &&
      other.shift == shift &&
      other.ctrl == ctrl &&
      other.alt == alt &&
      other.meta == meta;

  @override
  int get hashCode => Object.hash(key, shift, ctrl, alt, meta);
}

/// 可自定义的播放器快捷键动作。默认键位 = 历史硬编码行为。
enum ShortcutAction {
  playPause('播放 / 暂停', .playback, KeyBinding(LogicalKeyboardKey.space)),
  mute('静音', .playback, KeyBinding(LogicalKeyboardKey.keyM)),
  volumeUp(
    '音量 +',
    .volumeSeek,
    KeyBinding(LogicalKeyboardKey.arrowUp),
    isHold: true,
  ),
  volumeDown(
    '音量 -',
    .volumeSeek,
    KeyBinding(LogicalKeyboardKey.arrowDown),
    isHold: true,
  ),
  seekForward(
    '快进（长按倍速播放）',
    .volumeSeek,
    KeyBinding(LogicalKeyboardKey.arrowRight),
    isHold: true,
    context: .vod,
  ),
  seekBackward(
    '快退',
    .volumeSeek,
    KeyBinding(LogicalKeyboardKey.arrowLeft),
    context: .vod,
  ),
  refreshStream(
    '刷新直播流',
    .playback,
    KeyBinding(LogicalKeyboardKey.keyQ),
    context: .live,
  ),
  fullscreen('全屏', .display, KeyBinding(LogicalKeyboardKey.keyF)),
  inAppFullscreen(
    '应用内全屏',
    .display,
    KeyBinding(LogicalKeyboardKey.keyF, shift: true),
  ),
  desktopPip(
    '桌面小窗',
    .display,
    KeyBinding(LogicalKeyboardKey.keyP),
    desktopOnly: true,
  ),
  screenshot('截图（全屏时）', .display, KeyBinding(LogicalKeyboardKey.keyS)),
  lockControls('锁定屏幕控制', .display, KeyBinding(LogicalKeyboardKey.keyL)),
  toggleDanmaku('弹幕开关', .danmaku, KeyBinding(LogicalKeyboardKey.keyD)),
  sendDanmaku('发送弹幕 / 跳过片段', .danmaku, KeyBinding(LogicalKeyboardKey.enter)),
  likeTriple(
    '三连（快按点赞，长按三连）',
    .interact,
    KeyBinding(LogicalKeyboardKey.keyQ),
    isHold: true,
    context: .vod,
  ),
  coin('投币', .interact, KeyBinding(LogicalKeyboardKey.keyW), context: .vod),
  fav('收藏', .interact, KeyBinding(LogicalKeyboardKey.keyE), context: .vod),
  watchLater(
    '稍后再看',
    .interact,
    KeyBinding(LogicalKeyboardKey.keyT),
    context: .vod,
  ),
  relationMod(
    '修改关注关系',
    .interact,
    KeyBinding(LogicalKeyboardKey.keyG),
    context: .vod,
  ),
  speedDown(
    '速度 -（按倍速列表降档）',
    .speedEpisode,
    KeyBinding(LogicalKeyboardKey.digit1, shift: true),
    context: .vod,
  ),
  speedUp(
    '速度 +（按倍速列表升档）',
    .speedEpisode,
    KeyBinding(LogicalKeyboardKey.digit2, shift: true),
    context: .vod,
  ),
  speedReset(
    '恢复正常倍速（设置里的默认倍速）',
    .speedEpisode,
    KeyBinding(LogicalKeyboardKey.digit3, shift: true),
    context: .vod,
  ),
  prevEpisode(
    '上一集',
    .speedEpisode,
    KeyBinding(LogicalKeyboardKey.bracketLeft),
    context: .vod,
  ),
  nextEpisode(
    '下一集',
    .speedEpisode,
    KeyBinding(LogicalKeyboardKey.bracketRight),
    context: .vod,
  );

  final String title;
  final ShortcutCategory category;
  final KeyBinding defaultBinding;

  /// 按住型动作：行为依赖 KeyDown / KeyUp 配对（音量重复、长按倍速、三连）
  final bool isHold;
  final ShortcutContext context;
  final bool desktopOnly;

  const ShortcutAction(
    this.title,
    this.category,
    this.defaultBinding, {
    this.isHold = false,
    this.context = ShortcutContext.both,
    this.desktopOnly = false,
  });
}
