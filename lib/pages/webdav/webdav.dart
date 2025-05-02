import 'dart:io';
import 'dart:convert';
import 'package:PiliPlus/common/widgets/pair.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:webdav_client/webdav_client.dart' as webdav;

class WebDav {
  late String _webdavDirectory;

  webdav.Client? _client;

  WebDav._internal();
  static final WebDav _instance = WebDav._internal();
  factory WebDav() => _instance;

  Future<Pair<bool, String?>> init() async {
    final webDavUri = GStorage.webdavUri;
    final webDavUsername = GStorage.webdavUsername;
    final webDavPassword = GStorage.webdavPassword;
    _webdavDirectory = GStorage.webdavDirectory;
    if (_webdavDirectory.endsWith('/').not) {
      _webdavDirectory += '/';
    }
    _webdavDirectory += 'PiliPlus';

    try {
      _client = null;
      final client = webdav.newClient(
        webDavUri,
        user: webDavUsername,
        password: webDavPassword,
      )
        ..setHeaders({'accept-charset': 'utf-8'})
        ..setConnectTimeout(4000)
        ..setReceiveTimeout(4000)
        ..setSendTimeout(4000);

      await client.mkdirAll(_webdavDirectory);

      _client = client;
      return Pair(first: true, second: null);
    } catch (e) {
      return Pair(first: false, second: e.toString());
    }
  }
  
  Future<bool> _isPhone() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      return androidInfo.systemFeatures.contains("android.hardware.telephony");
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      return _isIosPhone(iosInfo.utsname.machine);
    } else {
      return true;
    }
  }
  bool _isIosPhone(String machine) {
    if (machine.startsWith("iPhone")) {
      return true;
    } else if (machine.startsWith("iPad")) {
      return false;
    }
    return true;
  }

  Future<String> _getFileName() async {
    final isPhoneDevice = await _isPhone();
    return isPhoneDevice
        ? 'piliplus_settings_phone.json'
        : 'piliplus_settings_pad.json';
  }

  Future backup() async {
    if (_client == null) {
      final res = await init();
      if (res.first == false) {
        SmartDialog.showToast('备份失败，请检查配置: ${res.second}');
        return;
      }
    }
    try {
      String data = await GStorage.exportAllSettings();
      final isPhoneDevice = await _isPhone();
      final fileName = await _getFileName();
      final path = '$_webdavDirectory/$fileName';
      try {
        await _client!.remove(path);
      } catch (_) {}
      await _client!.write(path, utf8.encode(data));
      SmartDialog.showToast('备份成功');
    } catch (e) {
      SmartDialog.showToast('备份失败: $e');
    }
  }

  Future restore() async {
    if (_client == null) {
      final res = await init();
      if (res.first == false) {
        SmartDialog.showToast('恢复失败，请检查配置: ${res.second}');
        return;
      }
    }
    try {
      final isPhoneDevice = await _isPhone();
      final fileName = await _getFileName();
      final path = '$_webdavDirectory/$fileName';
      final data = await _client!.read(path);
      await GStorage.importAllSettings(utf8.decode(data));
      SmartDialog.showToast('恢复成功');
    } catch (e) {
      SmartDialog.showToast('恢复失败: $e');
    }
  }
}
