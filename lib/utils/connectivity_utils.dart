import 'dart:io' show Platform;

import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:nm/nm.dart';

abstract final class ConnectivityUtils {
  static Future<bool> get isWiFi async {
    try {
      if (Platform.isLinux) {
        final client = NetworkManagerClient();
        try {
          await client.connect();
          return switch (client.metered) {
            NetworkManagerMetered.yes ||
            NetworkManagerMetered.guessYes => false,
            _ => true,
          };
        } finally {
          await client.close();
        }
      }
      return PlatformUtils.isMobile &&
          (await Connectivity().checkConnectivity()).contains(
            ConnectivityResult.wifi,
          );
    } catch (_) {
      return true;
    }
  }
}
