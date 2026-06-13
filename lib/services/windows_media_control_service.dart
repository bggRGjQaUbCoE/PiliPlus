import 'package:flutter/services.dart';

typedef MediaControlHandler = Future<void> Function();

class WindowsMediaControlService {
  WindowsMediaControlService._();

  static const MethodChannel _channel = MethodChannel('PiliPlus');
  static bool _initialized = false;
  static bool _playPauseHotKeyEnabled = false;
  static MediaControlHandler? _onPlay;
  static MediaControlHandler? _onPause;
  static MediaControlHandler? _onPlayPause;

  static void init() {
    if (_initialized) return;
    _initialized = true;
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  static void setHandlers({
    MediaControlHandler? onPlay,
    MediaControlHandler? onPause,
    MediaControlHandler? onPlayPause,
  }) {
    _onPlay = onPlay;
    _onPause = onPause;
    _onPlayPause = onPlayPause;
  }

  static void clearHandlers() {
    _onPlay = null;
    _onPause = null;
    _onPlayPause = null;
  }

  static Future<void> enablePlayPauseHotKey() async {
    if (_playPauseHotKeyEnabled) {
      return;
    }
    await _channel.invokeMethod('SystemMediaControl.enablePlayPauseHotKey');
    _playPauseHotKeyEnabled = true;
  }

  static Future<void> disablePlayPauseHotKey() async {
    if (!_playPauseHotKeyEnabled) {
      return;
    }
    await _channel.invokeMethod('SystemMediaControl.disablePlayPauseHotKey');
    _playPauseHotKeyEnabled = false;
  }

  static Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'SystemMediaControl.playPause':
        await _onPlayPause?.call();
        return;
      case 'SystemMediaControl.play':
        await _onPlay?.call();
        return;
      case 'SystemMediaControl.pause':
        await _onPause?.call();
        return;
      default:
        throw MissingPluginException(
          'No implementation found for method ${call.method} on channel PiliPlus',
        );
    }
  }
}
