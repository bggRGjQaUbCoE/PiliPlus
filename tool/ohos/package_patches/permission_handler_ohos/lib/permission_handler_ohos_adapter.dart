import 'package:flutter/services.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

import 'permission_handler_ohos.dart';

/// Permission state comes from OHOS access tokens, never a successful stub.
class PermissionHandlerOhosAdapter extends PermissionHandlerPlatform {
  static void registerWith() => PermissionHandlerPlatform.instance = PermissionHandlerOhosAdapter();

  static String _nativeName(Permission permission) {
    if (permission == Permission.camera) return 'ohos.permission.CAMERA';
    if (permission == Permission.microphone) return 'ohos.permission.MICROPHONE';
    if (permission == Permission.photos || permission == Permission.videos) {
      return 'ohos.permission.READ_IMAGEVIDEO';
    }
    if (permission == Permission.photosAddOnly) return 'ohos.permission.WRITE_IMAGEVIDEO';
    if (permission == Permission.locationWhenInUse || permission == Permission.location) {
      return 'ohos.permission.LOCATION';
    }
    throw UnsupportedError('Permission $permission has no reviewed OHOS mapping');
  }

  static PermissionStatus _status(PermissionStatusOhos status) => switch (status) {
    PermissionStatusOhos.granted => PermissionStatus.granted,
    PermissionStatusOhos.denied => PermissionStatus.denied,
    PermissionStatusOhos.invalid => throw PlatformException(
      code: 'invalid_permission', message: 'OHOS rejected this permission request or it is not declared'),
  };

  @override
  Future<PermissionStatus> checkPermissionStatus(Permission permission) async =>
      _status(await PermissionHandlerOhos.checkPermissionStatus(_nativeName(permission)));

  @override
  Future<Map<Permission, PermissionStatus>> requestPermissions(List<Permission> permissions) async {
    if (permissions.isEmpty) return {};
    final names = {for (final permission in permissions) permission: _nativeName(permission)};
    final statuses = await PermissionHandlerOhos.requestPermissions(names.values.toSet().toList());
    return {for (final entry in names.entries)
      entry.key: _status(statuses[entry.value] ?? PermissionStatusOhos.invalid)};
  }

  @override
  Future<bool> openAppSettings() => PermissionHandlerOhos.openAppSettings();
}
