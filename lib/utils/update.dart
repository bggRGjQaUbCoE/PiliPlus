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
import 'package:flutter/material.dart';
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
      if (res.data is Map || res.data.isEmpty) {
        if (!isAuto) {
          SmartDialog.showToast('检查更新失败，GitHub接口未返回数据，请检查网络');
        }
        return;
      }
      final data = res.data[0];
      final localVer = _parseVersion(BuildConfig.versionName);
      final remoteVer = _parseVersion(data['tag_name'] ?? '');

      bool hasUpdate = false;
      if (localVer.isNotEmpty && remoteVer.isNotEmpty) {
        // 主路径：点分数字版本比较
        hasUpdate = _isNewer(localVer, remoteVer);
      } else if (!BuildConfig.isCI) {
        // 降级：版本不可解析 + 非 CI → buildTime 比较（date +%s 有实际意义）
        final latest =
            DateTime.parse(data['created_at']).millisecondsSinceEpoch ~/ 1000;
        hasUpdate = BuildConfig.buildTime < latest;
      }
      // CI + 版本不可解析 → 无法判断，跳过

      if (!hasUpdate) {
        if (!isAuto) {
          SmartDialog.showToast('已是最新版本');
        }
        return;
      }
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
    } catch (e) {
      if (kDebugMode) debugPrint('failed to check update: $e');
    }
  }

  /// 将版本号字符串解析为数字段列表（忽略非数字后缀）。
  /// 例如 "2.0.7.2-abc123" → [2, 0, 7, 2]
  static List<int> _parseVersion(String v) {
    final base = v.split('-').first;
    return base
        .split('.')
        .map(int.tryParse)
        .where((e) => e != null)
        .cast<int>()
        .toList();
  }

  /// 比较两个版本：[local] < [remote] 时返回 true（有更新）。
  static bool _isNewer(List<int> local, List<int> remote) {
    final len = local.length > remote.length ? local.length : remote.length;
    for (var i = 0; i < len; i++) {
      final l = i < local.length ? local[i] : 0;
      final r = i < remote.length ? remote[i] : 0;
      if (r > l) return true;
      if (l > r) return false;
    }
    return false;
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
