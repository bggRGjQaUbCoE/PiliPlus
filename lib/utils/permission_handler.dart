import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

export 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart'
    show
        Permission,
        PermissionStatus,
        PermissionStatusGetters,
        PermissionWithService,
        FuturePermissionStatusGetters,
        ServiceStatus,
        ServiceStatusGetters,
        FutureServiceStatusGetters;

PermissionHandlerPlatform get _handler => PermissionHandlerPlatform.instance;

/// Opens the app settings page.
///
/// Returns [true] if the app settings page could be opened, otherwise [false].
Future<bool> openAppSettings() => _handler.openAppSettings();

/// Actions that can be executed on a permission.
extension PermissionActions on Permission {
  /// Callback for when permission is denied.
  static VoidCallback? _onDenied;

  /// Callback for when permission is granted.
  static VoidCallback? _onGranted;

  /// Callback for when permission is permanently denied.
  static VoidCallback? _onPermanentlyDenied;

  /// Callback for when permission is restricted.
  static VoidCallback? _onRestricted;

  /// Callback for when permission is limited.
  static VoidCallback? _onLimited;

  /// Callback for when permission is Provisional.
  static VoidCallback? _onProvisional;

  /// Method to set a callback for when permission is denied.
  void onDeniedCallback(VoidCallback? callback) {
    _onDenied = callback;
  }

  /// Method to set a callback for when permission is granted.
  void onGrantedCallback(VoidCallback? callback) {
    _onGranted = callback;
  }

  /// Method to set a callback for when permission is permanently denied.
  void onPermanentlyDeniedCallback(VoidCallback? callback) {
    _onPermanentlyDenied = callback;
  }

  /// Method to set a callback for when permission is restricted.
  void onRestrictedCallback(VoidCallback? callback) {
    _onRestricted = callback;
  }

  /// Method to set a callback for when permission is limited.
  void onLimitedCallback(VoidCallback? callback) {
    _onLimited = callback;
  }

  /// Method to set a callback for when permission is provisional.
  void onProvisionalCallback(VoidCallback? callback) {
    _onProvisional = callback;
  }

  /// Checks the current status of the given [Permission].
  ///
  /// Notes about specific permissions:
  /// - **[Permission.bluetooth]**
  ///   - iOS 13.0 only:
  ///     - The method will **always** return [PermissionStatus.denied],
  ///       regardless of the actual status. For the actual permission state,
  ///       use [Permission.bluetooth.request]. Note that this will show a
  ///       permission dialog if the permission was not yet requested.
  Future<PermissionStatus> get status => _handler.checkPermissionStatus(this);

  /// If you should show a rationale for requesting permission.
  ///
  /// This is only implemented on Android, calling this on iOS always returns
  /// [false].
  FutureOr<bool> get shouldShowRequestRationale {
    if (!Platform.isAndroid) {
      return false;
    }

    return _handler.shouldShowRequestPermissionRationale(this);
  }

  /// Request the user for access to this [Permission], if access hasn't already
  /// been grant access before.
  ///
  /// Returns the new [PermissionStatus].
  Future<PermissionStatus> request() async {
    final permissionStatus =
        (await [this].request())[this] ?? PermissionStatus.denied;

    (switch (permissionStatus) {
      .denied => _onDenied,
      .granted => _onGranted,
      .restricted => _onRestricted,
      .limited => _onLimited,
      .permanentlyDenied => _onPermanentlyDenied,
      .provisional => _onProvisional,
    })?.call();

    return permissionStatus;
  }
}

/// Shortcuts for checking the [status] of a [Permission].
extension PermissionCheckShortcuts on Permission {
  /// If the user granted this permission.
  Future<bool> get isGranted => status.isGranted;

  /// If the user denied this permission.
  Future<bool> get isDenied => status.isDenied;

  /// If the OS denied this permission. The user cannot change the status,
  /// possibly due to active restrictions such as parental controls being in
  /// place.
  /// *Only supported on iOS.*
  Future<bool> get isRestricted => status.isRestricted;

  /// User has authorized this application for limited access.
  /// *Only supported on iOS.(iOS14+ for photos, ios18+ for contacts)*
  Future<bool> get isLimited => status.isLimited;

  /// Returns `true` when permissions are denied permanently.
  ///
  /// When permissions are denied permanently, no new permission dialog will
  /// be showed to the user. Consuming Apps should redirect the user to the
  /// App settings to change permissions.
  Future<bool> get isPermanentlyDenied => status.isPermanentlyDenied;

  /// If the application is provisionally authorized to post noninterruptive user notifications.
  /// *Only supported on iOS.*
  Future<bool> get isProvisional => status.isProvisional;
}

/// Actions that apply only to permissions that have an associated service.
extension ServicePermissionActions on PermissionWithService {
  /// Checks the current status of the service associated with the given
  /// [Permission].
  ///
  /// Notes about specific permissions:
  /// - **[Permission.phone]**
  ///   - Android:
  ///     - The method will return [ServiceStatus.notApplicable] when:
  ///       - the device lacks the TELEPHONY feature
  ///       - TelephonyManager.getPhoneType() returns PHONE_TYPE_NONE
  ///       - when no Intents can be resolved to handle the `tel:` scheme
  ///     - The method will return [ServiceStatus.disabled] when:
  ///       - the SIM card is missing
  ///   - iOS:
  ///     - The method will return [ServiceStatus.notApplicable] when:
  ///       - the native code can not find a handler for the `tel:` scheme
  ///     - The method will return [ServiceStatus.disabled] when:
  ///       - the mobile network code (MNC) is either 0 or 65535. See
  ///          https://stackoverflow.com/a/11595365 for details
  ///   - **PLEASE NOTE that this is still not a perfect indication** of the
  ///     device's capability to place & connect phone calls as it also depends
  ///     on the network condition.
  /// - **[Permission.bluetooth]**
  ///   - iOS:
  ///     - The method will **always** return [ServiceStatus.disabled] when the
  ///       Bluetooth permission was denied by the user. It is impossible to
  ///       obtain the actual Bluetooth service status without having the
  ///       Bluetooth permission granted.
  ///     - The method will prompt the user for Bluetooth permission if the
  ///       permission was not yet requested.
  Future<ServiceStatus> get serviceStatus => _handler.checkServiceStatus(this);
}

/// Actions that can be taken on a [List] of [Permission]s.
extension PermissionListActions on List<Permission> {
  /// Requests the user for access to these permissions, if they haven't already
  /// been granted before.
  ///
  /// Returns a [Map] containing the status per requested [Permission].
  Future<Map<Permission, PermissionStatus>> request() =>
      _handler.requestPermissions(this);
}
