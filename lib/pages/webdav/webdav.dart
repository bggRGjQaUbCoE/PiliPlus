import 'dart:convert';
import 'dart:typed_data';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/pair.dart';
import 'package:PiliPlus/utils/device_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:uuid/v4.dart';
import 'package:webdav_client/webdav_client.dart' as webdav;

typedef WebDavWrite = Future<void> Function(String path, Uint8List data);
typedef WebDavRename =
    Future<void> Function(String oldPath, String newPath, bool overwrite);
typedef WebDavRemove = Future<void> Function(String path);

@visibleForTesting
Future<void> replaceWebDavFile({
  required String path,
  required Uint8List data,
  required WebDavWrite write,
  required WebDavRename rename,
  required WebDavRemove remove,
}) async {
  final tempPath = '$path.${const UuidV4().generate()}.tmp';
  try {
    await write(tempPath, data);
    await rename(tempPath, path, true);
  } finally {
    try {
      await remove(tempPath);
    } catch (_) {}
  }
}

class WebDav {
  late String _webdavDirectory;
  String? _fileName;

  webdav.Client? _client;

  WebDav._internal();
  static final WebDav _instance = WebDav._internal();
  factory WebDav() => _instance;

  Future<Pair<bool, String?>> init() async {
    final webDavUri = Pref.webdavUri;
    final webDavUsername = Pref.webdavUsername;
    final webDavPassword = Pref.webdavPassword;
    _webdavDirectory = Pref.webdavDirectory;
    if (!_webdavDirectory.endsWith('/')) {
      _webdavDirectory += '/';
    }
    _webdavDirectory += Constants.appName;

    try {
      _client = null;
      final client =
          webdav.newClient(
              webDavUri,
              user: webDavUsername,
              password: webDavPassword,
            )
            ..setHeaders({'accept-charset': 'utf-8'})
            ..setConnectTimeout(12000)
            ..setReceiveTimeout(12000)
            ..setSendTimeout(12000);

      await client.mkdirAll(_webdavDirectory);

      _client = client;
      return Pair(first: true, second: null);
    } catch (e) {
      return Pair(first: false, second: e.toString());
    }
  }

  String _getFileName() {
    return 'piliplus_settings_${DeviceUtils.platformName}.json';
  }

  Future<void> backup() async {
    if (_client == null) {
      final res = await init();
      if (!res.first) {
        SmartDialog.showToast('备份失败，请检查配置: ${res.second}');
        return;
      }
    }
    try {
      String data = GStorage.exportAllSettings();
      _fileName ??= _getFileName();
      final path = '$_webdavDirectory/$_fileName';
      await replaceWebDavFile(
        path: path,
        data: utf8.encode(data),
        write: _client!.write,
        rename: _client!.rename,
        remove: _client!.remove,
      );
      SmartDialog.showToast('备份成功');
    } catch (e) {
      SmartDialog.showToast('备份失败: $e');
    }
  }

  Future<void> restore() async {
    if (_client == null) {
      final res = await init();
      if (!res.first) {
        SmartDialog.showToast('恢复失败，请检查配置: ${res.second}');
        return;
      }
    }
    try {
      _fileName ??= _getFileName();
      final path = '$_webdavDirectory/$_fileName';
      final data = await _client!.read(path);
      await GStorage.importAllSettings(utf8.decode(data));
      SmartDialog.showToast('恢复成功');
    } catch (e) {
      SmartDialog.showToast('恢复失败: $e');
    }
  }
}
