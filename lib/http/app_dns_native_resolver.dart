import 'dart:io';

import 'package:PiliPlus/http/app_dns.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/services.dart';

final class AppDnsNativeResolver {
  AppDnsNativeResolver._();

  static const _channel = MethodChannel('PiliPlus/AppDnsResolver');
  static final _registeredHosts = <String, String>{};
  static bool _clearedDisabled = true;

  static Future<void> prepareUrls(Iterable<String?> urls) async {
    if (!Platform.isIOS) {
      return;
    }
    if (!Pref.enableAppDns) {
      await _clearIfNeeded();
      return;
    }

    final hosts = urls.map(_hostFromUrl).nonNulls.toSet();
    for (final host in hosts) {
      final addresses = await AppDns.lookup(host);
      final addressValues = addresses.map((item) => item.address).toList();
      final cacheValue = addressValues.join('\n');
      if (_registeredHosts[host] == cacheValue) {
        continue;
      }
      await _channel.invokeMethod<void>('setHost', {
        'host': host,
        'addresses': addressValues,
      });
      _registeredHosts[host] = cacheValue;
      _clearedDisabled = false;
    }
  }

  static Future<void> clear() async {
    if (!Platform.isIOS) {
      return;
    }
    try {
      await _channel.invokeMethod<void>('clear');
    } on MissingPluginException {
      // The hook exists only in the iOS runner target.
    }
    _registeredHosts.clear();
    _clearedDisabled = true;
  }

  static Future<void> _clearIfNeeded() =>
      _clearedDisabled ? Future.value() : clear();

  static String? _hostFromUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final uri = Uri.tryParse(value);
    final host = uri?.host.toLowerCase();
    if (host == null ||
        host.isEmpty ||
        InternetAddress.tryParse(host) != null) {
      return null;
    }
    return host.endsWith('.') ? host.substring(0, host.length - 1) : host;
  }
}
