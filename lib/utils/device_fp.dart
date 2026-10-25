import 'dart:convert' show ascii;

import 'package:PiliPlus/utils/device_utils.dart';
import 'package:PiliPlus/utils/login_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:crypto/crypto.dart';

/// 设备指纹：登录与 App 请求里上报的持久设备标识
///
/// 值越接近真实设备越不容易触发风控，所以默认取自本机实际信息，
/// 并允许在「设置 - 隐私设置 - 设备指纹」里逐项改写或一键随机。
/// buvid 不在此列，它仍按账号独立维护。
abstract final class DeviceFp {
  /// 设备 ID，同一值分别作为 device_id 与 bili_local_id 上报
  static String get deviceId {
    final String? value = GStorage.setting.get(SettingBoxKey.deviceId);
    if (value != null) return value;
    final generated = LoginUtils.genDeviceId();
    GStorage.setting.put(SettingBoxKey.deviceId, generated);
    return generated;
  }

  static set deviceId(String value) {
    GStorage.setting.put(SettingBoxKey.deviceId, value);
  }

  static String randomDeviceId() => LoginUtils.genDeviceId();

  /// 登录会话 ID，首次生成后固定；每次冷启动都变会被当成换设备
  static String get loginSessionId {
    final String? value = GStorage.setting.get(SettingBoxKey.loginSessionId);
    if (value != null) return value;
    final generated = genLoginSessionId();
    GStorage.setting.put(SettingBoxKey.loginSessionId, generated);
    return generated;
  }

  static set loginSessionId(String value) {
    GStorage.setting.put(SettingBoxKey.loginSessionId, value);
  }

  static String genLoginSessionId() => md5
      .convert(
        ascii.encode(
          Pref.buvid + DateTime.now().millisecondsSinceEpoch.toString(),
        ),
      )
      .toString();

  /// 设备名与系统平台串，未自定义时取本机真实值
  static Future<(String, String)> get deviceNamePair async {
    final String? name = GStorage.setting.get(SettingBoxKey.deviceName);
    final String? platform = GStorage.setting.get(SettingBoxKey.devicePlatform);
    if (name != null && platform != null) return (name, platform);
    final (realName, realPlatform) = await DeviceUtils.deviceFingerprint;
    return (name ?? realName, platform ?? realPlatform);
  }

  static void setDeviceName(String name, String platform) {
    GStorage.setting.put(SettingBoxKey.deviceName, name);
    GStorage.setting.put(SettingBoxKey.devicePlatform, platform);
  }

  /// 一键随机用的机型池，格式与 App 端上报一致
  static const List<(String, String)> _devicePool = [
    ('PJZ110', '16'),
    ('PJD110', '15'),
    ('PHK110', '14'),
    ('PGBM10', '13'),
    ('PDEM10', '14'),
    ('SM-S9280', '14'),
    ('2211133C', '14'),
    ('V2309A', '14'),
  ];

  static (String, String) randomDeviceName() {
    final (model, version) =
        _devicePool[Utils.random.nextInt(_devicePool.length)];
    return (model, 'Android' + version + model);
  }
}
