import 'package:flutter/services.dart';

/// Play/pause button in the taskbar thumbnail toolbar on Windows, implemented
/// in `windows/runner/taskbar_plugin.cpp`.
abstract final class WindowsTaskbarHelper {
  static const _channel = MethodChannel('com.example.piliplus/taskbar');

  static Object? _owner;
  static VoidCallback? _onToggle;

  /// Playing state shown on the button, `null` if hidden.
  static bool? _playing;

  static void init() {
    _channel.setMethodCallHandler(_onMethodCall);
  }

  static Future<void> _onMethodCall(MethodCall call) async {
    if (call.method == 'onPlayPause') _onToggle?.call();
  }

  /// Shows the button for the playback state of [owner], whose [onToggle] is
  /// called when the button is clicked.
  static void update(
    Object owner, {
    required bool playing,
    required VoidCallback onToggle,
  }) {
    _owner = owner;
    _onToggle = onToggle;
    if (_playing == playing) return;
    _playing = playing;
    _channel.invokeMethod('update', playing);
  }

  /// Hides the button if it still belongs to [owner].
  static void hide(Object owner) {
    if (!identical(_owner, owner)) return;
    _owner = null;
    _onToggle = null;
    _playing = null;
    _channel.invokeMethod('hide');
  }
}
