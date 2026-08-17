import 'dart:io' show Platform;

import 'package:PiliPlus/build_config.dart';
import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/browser_ua.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:material_ui/material_ui.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

abstract final class Update {
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
      final responseData = res.data;
      if (responseData is! List ||
          responseData.isEmpty ||
          responseData.first is! Map) {
        if (!isAuto) {
          SmartDialog.showToast('当前更新源尚未发布可用版本');
        }
        return;
      }
      final data = Map<String, dynamic>.from(responseData.first as Map);
      if (!_hasUpdate(data)) {
        if (!isAuto) {
          SmartDialog.showToast('已是最新版本');
        }
      } else {
        SmartDialog.show(
          animationType: SmartAnimationType.centerFade_otherSlide,
          builder: (context) {
            final colorScheme = ColorScheme.of(context);
            Widget downloadBtn(String text, {String? ext}) => TextButton(
              onPressed: () => onDownload(data, ext: ext),
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
                      GStorage.setting.put(SettingBoxKey.autoUpdate, false);
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
                ] else
                  downloadBtn('Github'),
              ],
            );
          },
        );
      }
    } catch (e) {
      if (kDebugMode) debugPrint('failed to check update: $e');
      if (!isAuto) {
        SmartDialog.showToast('检查更新失败，请检查网络或更新源');
      }
    }
  }

  static bool _hasUpdate(Map<String, dynamic> release) {
    final releaseVersionCode = _releaseVersionCode(release);
    if (releaseVersionCode != null) {
      return releaseVersionCode > BuildConfig.versionCode;
    }

    final versionComparison = _compareSemanticVersions(
      '${release['tag_name'] ?? ''}',
      BuildConfig.versionName,
    );
    if (versionComparison != null) {
      return versionComparison > 0;
    }

    final releaseTime = DateTime.tryParse(
      '${release['created_at'] ?? ''}',
    )?.millisecondsSinceEpoch;
    return releaseTime != null && releaseTime ~/ 1000 > BuildConfig.buildTime;
  }

  static int? _releaseVersionCode(Map<String, dynamic> release) {
    final assets = release['assets'];
    if (assets is! List) return null;
    final pattern = RegExp(r'\+(\d+)(?:_|-|\.)');
    for (final asset in assets) {
      if (asset is! Map) continue;
      final match = pattern.firstMatch('${asset['name'] ?? ''}');
      final versionCode = int.tryParse(match?.group(1) ?? '');
      if (versionCode != null) return versionCode;
    }
    return null;
  }

  static int? _compareSemanticVersions(String remote, String local) {
    final pattern = RegExp(r'(\d+)\.(\d+)\.(\d+)');
    final remoteMatch = pattern.firstMatch(remote);
    final localMatch = pattern.firstMatch(local);
    if (remoteMatch == null || localMatch == null) return null;

    for (var index = 1; index <= 3; index++) {
      final remotePart = int.parse(remoteMatch.group(index)!);
      final localPart = int.parse(localMatch.group(index)!);
      final comparison = remotePart.compareTo(localPart);
      if (comparison != 0) return comparison;
    }
    return 0;
  }

  // 下载适用于当前系统的安装包
  static Future<void> onDownload(Map data, {String? ext}) async {
    SmartDialog.dismiss();
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
}
