import 'dart:io' show Platform;

import 'package:collection/collection.dart';
import 'package:PiliPlus/build_config.dart';
import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/browser_ua.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:material_ui/material_ui.dart';

class UpdateVersionInfo {
  const UpdateVersionInfo({
    required this.versionCode,
    required this.releaseTag,
  });

  final int versionCode;
  final String releaseTag;
}

abstract final class Update {
  static const String _releaseManifestName = 'release-manifest.json';
  static final RegExp _legacyAssetVersionCodeRegExp = RegExp(
    r'\+(\d+)(?:[^0-9]|$)',
  );

  static UpdateVersionInfo? parseReleaseManifest(Map<String, dynamic>? json) {
    if (json == null) return null;

    final versionCode = json['version_code'];
    final releaseTag = json['release_tag'];
    if (versionCode is! int || releaseTag is! String || releaseTag.isEmpty) {
      return null;
    }

    return UpdateVersionInfo(
      versionCode: versionCode,
      releaseTag: releaseTag,
    );
  }

  static int? extractVersionCodeFromAssets(List assets) {
    for (final item in assets) {
      final name = item is Map ? item['name']?.toString() : null;
      if (name == null || name.isEmpty) continue;

      final match = _legacyAssetVersionCodeRegExp.firstMatch(name);
      final value = match?.group(1);
      if (value != null) {
        final versionCode = int.tryParse(value);
        if (versionCode != null) return versionCode;
      }
    }
    return null;
  }

  static bool shouldNotifyUpdate({
    required int localVersionCode,
    required int remoteVersionCode,
  }) => remoteVersionCode > localVersionCode;

  static UpdateVersionInfo? resolveRemoteVersionInfo(
    Map release, {
    Map<String, dynamic>? manifest,
  }) {
    final manifestInfo = parseReleaseManifest(manifest);
    if (manifestInfo != null) return manifestInfo;

    final versionCode = extractVersionCodeFromAssets(release['assets'] ?? []);
    final releaseTag = release['tag_name']?.toString();
    if (versionCode == null || releaseTag == null || releaseTag.isEmpty) {
      return null;
    }

    return UpdateVersionInfo(
      versionCode: versionCode,
      releaseTag: releaseTag,
    );
  }

  static Future<Map<String, dynamic>?> _fetchReleaseManifest(Map release) async {
    final List assets = release['assets'] ?? [];
    final manifestAsset = assets.firstWhereOrNull(
      (item) => item is Map && item['name'] == _releaseManifestName,
    );
    if (manifestAsset is! Map) return null;

    final String? url = manifestAsset['browser_download_url']?.toString();
    if (url == null || url.isEmpty) return null;

    final manifestRes = await Request().get(
      url,
      options: Options(
        headers: {'user-agent': BrowserUa.mob},
        extra: {'account': const NoAccount()},
      ),
    );

    return manifestRes.data is Map<String, dynamic>
        ? manifestRes.data as Map<String, dynamic>
        : manifestRes.data is Map
        ? Map<String, dynamic>.from(manifestRes.data)
        : null;
  }

  // 检查更新
  static Future<void> checkUpdate([bool isAuto = true]) async {
    if (kDebugMode) return;
    SmartDialog.dismiss();
    try {
      final res = await Request().get(
        Api.latestApp,
        options: Options(
          headers: {'user-agent': BrowserUa.mob},
          extra: {'account': const NoAccount()},
        ),
      );
      if (res.data is Map || res.data.isEmpty) {
        if (!isAuto) {
          SmartDialog.showToast('检查更新失败，GitHub接口未返回数据，请检查网络');
        }
        return;
      }
      final bool includePreRelease = Pref.preReleaseUpdate;
      final data = (res.data as List).firstWhere(
        (e) => includePreRelease || e['prerelease'] != true,
        orElse: () => null,
      );
      if (data == null) {
        if (!isAuto) {
          SmartDialog.showToast('已是最新版本');
        }
        return;
      }

      final manifest = await _fetchReleaseManifest(data);
      final remoteVersionInfo = resolveRemoteVersionInfo(
        data,
        manifest: manifest,
      );
      if (remoteVersionInfo == null) {
        if (!isAuto) {
          SmartDialog.showToast('无法解析远端版本信息');
        }
        return;
      }

      if (!shouldNotifyUpdate(
        localVersionCode: BuildConfig.versionCode,
        remoteVersionCode: remoteVersionInfo.versionCode,
      )) {
        if (!isAuto) {
          SmartDialog.showToast('已是最新版本');
        }
      } else if (isAuto && Pref.skipVersion == remoteVersionInfo.releaseTag) {
        // 用户已选择跳过此版本，静默忽略
      } else {
        Map<String, dynamic>? bestAsset;
        if (Platform.isAndroid) {
          bestAsset = await _findBestAsset(data);
        }
        SmartDialog.show(
          animationType: SmartAnimationType.centerFade_otherSlide,
          builder: (context) {
            final colorScheme = ColorScheme.of(context);
            Widget downloadBtn(String text, {String? ext, String? url}) =>
                TextButton(
                  onPressed: () => onDownload(data, ext: ext, url: url),
                  child: Text(text),
                );
            return AlertDialog(
              title: const Text('🎉 发现新版本 '),
              content: SizedBox(
                height: 280,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${data['tag_name']}',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 8),
                      Text('${data['body']}'),
                      TextButton(
                        onPressed: () => PageUtils.launchURL(
                          '${Constants.sourceCodeUrl}/commits/main',
                        ),
                        child: Text(
                          "点此查看完整更新(即commit)内容",
                          style: TextStyle(color: colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                if (isAuto)
                  TextButton(
                    onPressed: () {
                      SmartDialog.dismiss();
                      GStorage.setting.put(
                        SettingBoxKey.skipVersion,
                        remoteVersionInfo.releaseTag,
                      );
                    },
                    child: Text(
                      '不再提醒',
                      style: TextStyle(color: colorScheme.outline),
                    ),
                  ),
                TextButton(
                  onPressed: SmartDialog.dismiss,
                  child: Text(
                    '取消',
                    style: TextStyle(color: colorScheme.outline), 
                  ),
                ),
                if (Platform.isWindows) ...[
                  downloadBtn('zip', ext: 'zip'),
                  downloadBtn('exe', ext: 'exe'),
                ] else if (Platform.isLinux) ...[
                  downloadBtn('rpm', ext: 'rpm'),
                  downloadBtn('deb', ext: 'deb'),
                  downloadBtn('targz', ext: 'tar.gz'),
                ] else if (Platform.isAndroid) ...[
                  if (bestAsset != null)
                    downloadBtn(
                      '下载 APK (${bestAsset['name']})',
                      url: bestAsset['browser_download_url'],
                    )
                  else
                    downloadBtn('Github'),
                ] else
                  downloadBtn('Github'),
              ],
            );
          },
        );
      }
    } catch (e) {
      if (kDebugMode) debugPrint('failed to check update: $e');
    }
  }

  // 下载适用于当前系统的安装包
  static Future<void> onDownload(Map data, {String? ext, String? url}) async {
    SmartDialog.dismiss();
    if (url != null) {
      PageUtils.launchURL(url);
      return;
    }
    try {
      void download(String plat) {
        if (data['assets'].isNotEmpty) {
          for (Map<String, dynamic> i in data['assets']) {
            final String name = i['name'];
            if (name.contains(plat) &&
                (ext == null || ext.isEmpty ? true : name.endsWith(ext))) {
              PageUtils.launchURL(i['browser_download_url']);
              return;
            }
          }
          throw UnsupportedError('platform not found: $plat');
        }
      }

      if (Platform.isAndroid) {
        // 获取设备信息
        AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
        // [arm64-v8a]
        download(androidInfo.supportedAbis.first);
      } else {
        download(Platform.operatingSystem);
      }
    } catch (e) {
      if (kDebugMode) debugPrint('download error: $e');
      PageUtils.launchURL('${Constants.sourceCodeUrl}/releases/latest');
    }
  }

  static Future<Map<String, dynamic>?> _findBestAsset(Map data) async {
    final List assets = data['assets'] ?? [];
    if (assets.isEmpty) return null;

    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo =
          await DeviceInfoPlugin().androidInfo;
      final List<String> abis = androidInfo.supportedAbis;
      for (final String abi in abis) {
        final asset = assets.firstWhereOrNull(
          (e) => e['name'].toString().toLowerCase().contains(abi.toLowerCase()),
        );
        if (asset != null) return asset;
      }
      // fallback to universal if available
      return assets.firstWhereOrNull(
        (e) => e['name'].toString().toLowerCase().contains('universal'),
      );
    }
    return null;
  }
}
