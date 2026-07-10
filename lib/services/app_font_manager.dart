import 'dart:io';

import 'package:PiliPlus/models/common/app_font_family.dart';
import 'package:PiliPlus/utils/path_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;

typedef AppFontDownloadProgress = ({int received, int total});

final class AppFontDownloadException implements Exception {
  const AppFontDownloadException(this.message);

  final String message;

  @override
  String toString() => message;
}

abstract final class AppFontManager {
  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(minutes: 2),
      followRedirects: true,
      maxRedirects: 8,
      headers: const {
        HttpHeaders.acceptHeader: 'application/octet-stream',
        HttpHeaders.userAgentHeader: 'PiliPlus font downloader',
      },
      validateStatus: (status) =>
          status != null && status >= 200 && status < 300,
    ),
  );

  static final Map<AppFontFamily, ValueNotifier<AppFontDownloadProgress?>>
  _progress = {
    for (final font in AppFontFamily.values)
      if (!font.isSystem) font: ValueNotifier<AppFontDownloadProgress?>(null),
  };
  static final Map<AppFontFamily, Future<void>> _downloads = {};
  static final Set<AppFontFamily> _loadedFonts = {};
  static bool _initialized = false;

  static Directory get _fontDirectory =>
      Directory(path.join(appSupportDirPath, PathUtils.appFontDir));

  static File _fontFile(AppFontFamily font) =>
      File(path.join(_fontDirectory.path, font.fileName!));

  static ValueListenable<AppFontDownloadProgress?> downloadProgressOf(
    AppFontFamily font,
  ) => _progress[font]!;

  static bool isDownloaded(AppFontFamily font) {
    if (font.isSystem) return true;
    try {
      final file = _fontFile(font);
      return file.existsSync() && file.lengthSync() == font.downloadSize;
    } catch (_) {
      return false;
    }
  }

  static String? fontFamilyFor(AppFontFamily font) =>
      _loadedFonts.contains(font) ? font.fontFamily : null;

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    final selected = Pref.appFontFamily;
    try {
      await _fontDirectory.create(recursive: true);
      for (final font in AppFontFamily.values) {
        if (!font.isSystem) {
          _deleteFile(File('${_fontFile(font).path}.part'));
        }
      }

      if (selected.isSystem) return;
      if (!isDownloaded(selected)) {
        await GStorage.setting.delete(SettingBoxKey.appFontFamily);
        return;
      }
      await load(selected);
    } catch (error) {
      if (!selected.isSystem) {
        try {
          await GStorage.setting.delete(SettingBoxKey.appFontFamily);
        } catch (_) {}
      }
      if (kDebugMode) {
        debugPrint('App font restore failed: $error');
      }
    }
  }

  static Future<void> load(AppFontFamily font) async {
    if (font.isSystem || _loadedFonts.contains(font)) return;
    if (!isDownloaded(font)) {
      throw const AppFontDownloadException('字体文件不完整，请重新下载');
    }

    try {
      final bytes = await _fontFile(font).readAsBytes();
      final loader = FontLoader(font.fontFamily!)
        ..addFont(Future.value(ByteData.sublistView(bytes)));
      await loader.load();
      _loadedFonts.add(font);
    } catch (error, stackTrace) {
      _deleteFile(_fontFile(font));
      Error.throwWithStackTrace(
        const AppFontDownloadException('字体加载失败，请重新下载'),
        stackTrace,
      );
    }
  }

  static Future<void> download(AppFontFamily font) {
    if (font.isSystem) return Future.value();
    if (isDownloaded(font)) return Future.value();

    final existing = _downloads[font];
    if (existing != null) return existing;

    late final Future<void> task;
    task = _download(font).whenComplete(() {
      if (identical(_downloads[font], task)) {
        _downloads.remove(font);
      }
    });
    _downloads[font] = task;
    return task;
  }

  static Future<void> _download(AppFontFamily font) async {
    final target = _fontFile(font);
    final temporary = File('${target.path}.part');
    final progress = _progress[font]!..value = (received: 0, total: -1);
    int lastPercent = -1;

    try {
      await _fontDirectory.create(recursive: true);
      _deleteFile(temporary);
      final response = await _dio.download(
        font.downloadUrl!,
        temporary.path,
        deleteOnError: true,
        onReceiveProgress: (received, total) {
          final percent = total > 0 ? received * 100 ~/ total : -1;
          if (percent != lastPercent) {
            lastPercent = percent;
            progress.value = (received: received, total: total);
          }
        },
      );
      final statusCode = response.statusCode;
      if (statusCode == null || statusCode < 200 || statusCode >= 300) {
        throw AppFontDownloadException(
          'GitHub 下载失败（HTTP ${statusCode ?? '-'}）',
        );
      }

      if (await temporary.length() != font.downloadSize) {
        throw const AppFontDownloadException('字体文件大小校验失败，请重试');
      }
      final digest = await sha256.bind(temporary.openRead()).first;
      if (digest.toString() != font.sha256) {
        throw const AppFontDownloadException('SHA-256 校验失败，请重试');
      }

      _deleteFile(target);
      await temporary.rename(target.path);
    } catch (error, stackTrace) {
      _deleteFile(temporary);
      final exception = error is AppFontDownloadException
          ? error
          : _downloadException(error);
      Error.throwWithStackTrace(exception, stackTrace);
    } finally {
      progress.value = null;
    }
  }

  static AppFontDownloadException _downloadException(Object error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      if (statusCode != null) {
        return AppFontDownloadException(
          'GitHub 下载失败（HTTP $statusCode）',
        );
      }
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        return const AppFontDownloadException('GitHub 连接超时，请检查网络后重试');
      }
      return const AppFontDownloadException('无法从 GitHub 下载字体，请检查网络');
    }
    if (error is FileSystemException) {
      return const AppFontDownloadException('字体文件保存失败，请检查存储空间');
    }
    return const AppFontDownloadException('字体下载失败，请稍后重试');
  }

  static void _deleteFile(File file) {
    try {
      if (file.existsSync()) file.deleteSync();
    } catch (_) {}
  }
}
