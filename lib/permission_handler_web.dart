import 'dart:async';
// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

const Map permissionMap = {
  3: "geolocation",
  4: "geolocation",
  5: "geolocation",
  17: "notifications",
  99: "push",
  98: "midi",
  1: "camera",
  7: "microphone",
  14: "microphone",
  97: "speaker",
  96: "device-info",
  21: "bluetooth",
  28: "bluetooth",
  29: "bluetooth",
  30: "bluetooth",
  15: "persistent-storage",
  12: ["accelerometer", "gyroscope", "magnetometer"],
  6: "storage-access",
  9: "storage-access",
  10: "storage-access",
  22: "storage-access",
};

const Map<String, PermissionStatus> permissionStatusMap = {
  "prompt": PermissionStatus.denied,
  "granted": PermissionStatus.granted,
  "denied": PermissionStatus.permanentlyDenied,
};

class PermissionHandlerWeb extends PermissionHandlerPlatform {
  static void registerWith(Registrar registrar) {
    PermissionHandlerPlatform.instance = PermissionHandlerWeb();
  }

  /// Checks the current status of the given [Permission].
  @override
  Future<PermissionStatus> checkPermissionStatus(Permission permission) async {
    // final perm = html.window.navigator.permissions!;
    // final permValue = permission.value;
    // if (permissionMap[permValue]) return PermissionStatus.granted;
    // final perms = permissionMap[permValue];
    // if (perms is String) {
    //   final result = (await perm.query({"name": perms})).state;

    //   return PermissionStatusMap[result] ?? PermissionStatus.denied;
    // } else if (perms is List) {
    //   var result = PermissionStatus.granted;
    //   for (final p in perms) {
    //     final e = (await perm.query({"name": p})).state;
    //     if (e == "prompt" && result == PermissionStatus.granted) {
    //       result = PermissionStatus.denied;
    //     }
    //     if (e == "denied") result = PermissionStatus.permanentlyDenied;
    //   }
    //   return result;
    // }
    return PermissionStatus.granted;
  }

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
  @override
  Future<ServiceStatus> checkServiceStatus(Permission permission) async {
    final result = await checkPermissionStatus(permission);
    switch (result) {
      case PermissionStatus.granted:
        return ServiceStatus.enabled;
      default:
        return ServiceStatus.disabled;
    }
  }

  /// Opens the app settings page.
  ///
  /// Returns [true] if the app settings page could be opened, otherwise
  /// [false].
  @override
  Future<bool> openAppSettings() {
    return SynchronousFuture(false);
  }

  /// Requests the user for access to the supplied list of [Permission]s, if
  /// they have not already been granted before.
  ///
  /// Returns a [Map] containing the status per requested [Permission].
  @override
  Future<Map<Permission, PermissionStatus>> requestPermissions(
      List<Permission> permissions) async {
    final permObj = html.window.navigator.permissions!;
    final Map<Permission, PermissionStatus> result = {};
    for (final perm in permissions) {
      result[perm] = PermissionStatus.granted;
    }
    return result;
  }

  /// Checks if you should show a rationale for requesting permission.
  ///
  /// This method is only implemented on Android, calling this on iOS always
  /// returns [false].
  Future<bool> shouldShowRequestPermissionRationale(Permission permission) {
    return SynchronousFuture(false);
  }
}
