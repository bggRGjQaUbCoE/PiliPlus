import 'dart:async';

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
  static FutureOr<void>? Function()? _onDenied;

  /// Callback for when permission is granted.
  static FutureOr<void>? Function()? _onGranted;

  /// Callback for when permission is permanently denied.
  static FutureOr<void>? Function()? _onPermanentlyDenied;

  /// Callback for when permission is restricted.
  static FutureOr<void>? Function()? _onRestricted;

  /// Callback for when permission is limited.
  static FutureOr<void>? Function()? _onLimited;

  /// Callback for when permission is Provisional.
  static FutureOr<void>? Function()? _onProvisional;

  /// Method to set a callback for when permission is denied.
  Permission onDeniedCallback(FutureOr<void>? Function()? callback) {
    _onDenied = callback;
    return this;
  }

  /// Method to set a callback for when permission is granted.
  Permission onGrantedCallback(FutureOr<void>? Function()? callback) {
    _onGranted = callback;
    return this;
  }

  /// Method to set a callback for when permission is permanently denied.
  Permission onPermanentlyDeniedCallback(FutureOr<void>? Function()? callback) {
    _onPermanentlyDenied = callback;
    return this;
  }

  /// Method to set a callback for when permission is restricted.
  Permission onRestrictedCallback(FutureOr<void>? Function()? callback) {
    _onRestricted = callback;
    return this;
  }

  /// Method to set a callback for when permission is limited.
  Permission onLimitedCallback(FutureOr<void>? Function()? callback) {
    _onLimited = callback;
    return this;
  }

  /// Method to set a callback for when permission is provisional.
  Permission onProvisionalCallback(FutureOr<void>? Function()? callback) {
    _onProvisional = callback;
    return this;
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
  Future<bool> get shouldShowRequestRationale async {
    if (defaultTargetPlatform != TargetPlatform.android) {
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

    if (permissionStatus.isDenied) {
      _onDenied?.call();
    } else if (permissionStatus.isGranted) {
      _onGranted?.call();
    } else if (permissionStatus.isPermanentlyDenied) {
      _onPermanentlyDenied?.call();
    } else if (permissionStatus.isRestricted) {
      _onRestricted?.call();
    } else if (permissionStatus.isLimited) {
      _onLimited?.call();
    } else if (permissionStatus.isProvisional) {
      _onProvisional?.call();
    }

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
