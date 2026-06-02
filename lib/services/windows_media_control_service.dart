import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:flutter/services.dart';

class WindowsMediaControlService {
  WindowsMediaControlService._();

  static const MethodChannel _channel = MethodChannel('PiliPlus');
  static bool _initialized = false;

  static void init() {
    if (_initialized) return;
    _initialized = true;
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  static Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'SystemMediaControl.playPause':
        await PlPlayerController.playOrPauseIfExists();
        return;
      case 'SystemMediaControl.play':
        await PlPlayerController.playCurrentIfExists();
        return;
      case 'SystemMediaControl.pause':
        await PlPlayerController.pauseIfExists();
        return;
      default:
        throw MissingPluginException(
          'No implementation found for method ${call.method} on channel PiliPlus',
        );
    }
  }
}
