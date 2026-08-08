import 'dart:io' show Platform;

import 'package:PiliPlus/utils/storage_volume.dart';
import 'package:flutter/services.dart';
import 'package:PiliPlus/utils/permission_handler.dart';

abstract final class StorageLocation {
  static const _channel = MethodChannel('piliplus/storage');

  static bool get isAndroid => Platform.isAndroid;

  static Future<bool> get isManageExternalStorageGranted async {
    if (!isAndroid) return false;
    return Permission.manageExternalStorage.isGranted;
  }

  static Future<bool> requestManageExternalStorage() async {
    if (!isAndroid) return false;
    final res = await Permission.manageExternalStorage.request();
    return res.isGranted;
  }

  static Future<List<StorageVolume>> listVolumes() async {
    if (!isAndroid) return [];
    final raw = await _channel.invokeMethod<List<dynamic>>('getStorageVolumes');
    if (raw == null) return [];
    return raw
        .cast<Map<dynamic, dynamic>>()
        .map(StorageVolume.fromMap)
        .toList();
  }
}
