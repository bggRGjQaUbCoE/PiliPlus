import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart';
import 'package:flutter/services.dart';

/// Adapts the native OHOS connectivity events to connectivity_plus 7's list API.
class ConnectivityPlusOhos extends ConnectivityPlatform {
  static const _channel = MethodChannel('dev.fluttercommunity.plus/connectivity');
  static const _events = EventChannel('dev.fluttercommunity.plus/connectivity_status');

  static void registerWith() => ConnectivityPlatform.instance = ConnectivityPlusOhos();

  static List<ConnectivityResult> _decode(Object? result) {
    final values = result is List ? result : <Object?>[result];
    return values.map((value) => switch (value) {
      'wifi' => ConnectivityResult.wifi,
      'mobile' => ConnectivityResult.mobile,
      'ethernet' => ConnectivityResult.ethernet,
      'vpn' => ConnectivityResult.vpn,
      'bluetooth' => ConnectivityResult.bluetooth,
      'none' => ConnectivityResult.none,
      _ => ConnectivityResult.other,
    }).toSet().toList();
  }

  @override
  Future<List<ConnectivityResult>> checkConnectivity() async =>
      _decode(await _channel.invokeMethod<Object?>('check'));

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _events.receiveBroadcastStream().map(_decode);
}
