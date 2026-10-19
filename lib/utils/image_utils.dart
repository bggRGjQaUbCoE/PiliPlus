import 'dart:async' show FutureOr;
import 'dart:io' show Directory, File, Platform;
import 'dart:math' as math;
import 'dart:typed_data' show Uint8List;

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/utils/cache_manager.dart';
import 'package:PiliPlus/utils/device_utils.dart';
import 'package:PiliPlus/utils/extension/file_ext.dart';
import 'package:PiliPlus/utils/extension/string_ext.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/path_utils.dart';
import 'package:PiliPlus/utils/permission_handler.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/share_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:crypto/crypto.dart' show md5;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:live_photo_maker/live_photo_maker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path/path.dart' as path;
import 'package:saver_gallery/saver_gallery.dart';
import 'package:share_plus/share_plus.dart';

abstract final class ImageUtils {
  static bool silentDownImg = Pref.silentDownImg;
  static final _albumPath = Platform.isAndroid
      ? 'Pictures/${Constants.appName}'
      : Constants.appName;

  // 图片分享
  static Future<void> onShareImg(String url) async {
    try {
      SmartDialog.showLoading();
      final res = await CacheManager.manager.getSingleFile(
        url.http2https,
      );
      SmartDialog.dismiss();
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(res.path)],
          sharePositionOrigin: await ShareUtils.sharePositionOrigin,
        ),
      );
    } catch (e) {
      SmartDialog.showToast(e.toString());
    }
  }

  // 获取存储权限
  static Future<bool> requestPer() async {
    final status = Platform.isAndroid
        ? await Permission.storage.request()
        : await Permission.photos.request();
    if (status == PermissionStatus.denied ||
        status == PermissionStatus.permanentlyDenied) {
      SmartDialog.show(
        builder: (context) => AlertDialog(
          title: const Text('提示'),
          content: const Text('存储权限未授权'),
          actions: [
            TextButton(
              onPressed: () {
                SmartDialog.dismiss();
                openAppSettings();
              },
              child: const Text('去授权'),
            ),
          ],
        ),
      );
      return false;
    } else {
      return true;
    }
  }

  static FutureOr<bool> checkPermissionDependOnSdkInt() {
    if (Platform.isAndroid) {
      if (DeviceUtils.sdkInt < 29) {
        return requestPer();
      } else {
        return true;
      }
    }
    return requestPer();
  }

  static Future<bool> downloadLivePhoto({
    required String url,
    required String liveUrl,
    required int width,
    required int height,
  }) async {
    try {
      if (PlatformUtils.isMobile && !await checkPermissionDependOnSdkInt()) {
        return false;
      }
      if (!silentDownImg) SmartDialog.showLoading(msg: '正在下载');

      String videoName = "video_${Utils.getFileName(liveUrl)}";
      String videoPath = '$tmpDirPath/$videoName';

      final res = await Request().downloadFile(liveUrl.http2https, videoPath);
      if (res.statusCode != 200) throw '${res.statusCode}';

      if (Platform.isIOS) {
        final imageFile = await CacheManager.manager.getSingleFile(
          url.http2https,
        );
        if (!silentDownImg) SmartDialog.showLoading(msg: '正在保存');
        bool success = await LivePhotoMaker.create(
          coverImage: imageFile.path,
          imagePath: null,
          voicePath: videoPath,
          width: width,
          height: height,
        ).whenComplete(File(videoPath).tryDel);
        if (success) {
          SmartDialog.showToast(' 已保存 ');
        } else {
          SmartDialog.showToast('保存失败');
          return false;
        }
      } else {
        if (!silentDownImg) SmartDialog.showLoading(msg: '正在保存');
        await saveFileImg(
          filePath: videoPath,
          fileName: videoName,
          type: FileType.video,
          needToast: true,
        );
      }
      return true;
    } catch (err) {
      SmartDialog.showToast(err.toString());
      return false;
    } finally {
      if (!silentDownImg) SmartDialog.dismiss(status: SmartStatus.loading);
    }
  }

  static Future<bool> downloadImg(List<String> imgList) async {
    if (PlatformUtils.isMobile && !await checkPermissionDependOnSdkInt()) {
      return false;
    }
    if (!silentDownImg) {
      SmartDialog.showLoading(msg: '正在下载原图');
    }
    final futures = imgList.map((url) async {
      final name = Utils.getFileName(url);
      final file = await CacheManager.manager.getSingleFile(url.http2https);
      return (file, name);
    });
    final List<(File, String)> result;
    try {
      try {
        result = await Future.wait(
          futures,
          eagerError: true,
          cleanUp: (successValue) => successValue.$1.tryDel(),
        );
      } catch (e) {
        SmartDialog.showToast('保存失败');
        return false;
      }
      if (PlatformUtils.isMobile) {
        final saveList = <SaveFileData>[];
        for (final i in result) {
          saveList.add(
            SaveFileData(
              filePath: i.$1.path,
              fileName: i.$2,
              albumPath: _albumPath,
            ),
          );
        }
        await SaverGallery.saveFiles(saveList, skipIfExists: false);
      } else {
        final dst = await FilePicker.getDirectoryPath();
        if (dst == null) {
          SmartDialog.showToast('取消保存');
          return false;
        }
        await Future.wait([
          for (final (src, name) in result)
            src.moveOrCopy(path.join(dst, name)),
        ]);
      }
      SmartDialog.showToast(' 已保存 ');
      return true;
    } finally {
      if (!silentDownImg) SmartDialog.dismiss(status: .loading);
    }
  }

  static const _emoteDirName = 'emote';
  static const _maxEmoteNameConflict = 1000;
  static final _emoteExtRegex = RegExp(
    r'^\.(?:png|jpe?g|gif|webp|avif|bmp)$',
    caseSensitive: false,
  );

  /// 下载评论表情（`[x_x]` 形式的图片表情）。
  ///
  /// [emotes] 每项为 `(表情名, 图片地址)`，表情名形如 `[x_x]`。
  /// 同名文件已存在时按内容 md5 判重：内容一致视为已保存，不重复写入；
  /// 内容不同则依次追加 `_1`、`_2` 后缀。
  /// 桌面端扫描下载目录下的 `emote` 子目录并读取文件哈希；
  /// 移动端没有相册查询 API，改用 [LocalCacheKey.emoteSaved] 中
  /// 「文件名 -> md5」的本地记录判重。
  static Future<bool> downloadEmotes(List<(String, String)> emotes) async {
    final items = <String, String>{};
    for (final (name, url) in emotes) {
      if (url.isEmpty) continue;
      // 同一张表情出现多次时只下载一次
      items.putIfAbsent(url.http2https, () => name);
    }
    if (items.isEmpty) {
      SmartDialog.showToast('未找到表情');
      return false;
    }
    if (PlatformUtils.isMobile && !await checkPermissionDependOnSdkInt()) {
      return false;
    }
    if (!silentDownImg) {
      SmartDialog.showLoading(msg: '正在下载表情');
    }

    var saved = 0;
    var skipped = 0;
    var failed = 0;
    try {
      final Directory? dir = PlatformUtils.isMobile ? null : await _emoteDir();
      final Map<String, String>? records = PlatformUtils.isMobile
          ? _loadEmoteRecords()
          : null;
      for (final MapEntry(key: url, value: name) in items.entries) {
        try {
          final file = await CacheManager.manager.getSingleFile(url);
          final bytes = await file.readAsBytes();
          if (bytes.isEmpty) {
            throw StateError('emote is empty');
          }
          final hash = md5.convert(bytes).toString();
          final fileName = _emoteFileName(name, url);
          final isSaved = dir != null
              ? await _saveEmoteToDir(bytes, fileName, hash, dir)
              : await _saveEmoteToGallery(records!, file.path, fileName, hash);
          if (isSaved) {
            saved++;
          } else {
            skipped++;
          }
        } catch (_) {
          failed++;
        }
      }
    } catch (_) {
      // 目标目录不可用等异常：剩余表情记为失败
      failed = items.length - saved - skipped;
    } finally {
      if (!silentDownImg) {
        SmartDialog.dismiss(status: SmartStatus.loading);
      }
    }

    if (failed > 0) {
      SmartDialog.showToast(
        saved > 0 ? '已保存 $saved 个，$failed 个失败' : '保存失败',
      );
    } else if (saved == 0) {
      SmartDialog.showToast('已保存过');
    } else if (skipped > 0) {
      SmartDialog.showToast('已保存 $saved 个，$skipped 个已保存过');
    } else {
      SmartDialog.showToast('已保存 $saved 个表情');
    }
    return saved > 0;
  }

  static Future<Directory> _emoteDir() async {
    final dir = Directory(path.join(downloadPath, _emoteDirName));
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  static String _emoteFileName(String name, String url) {
    var ext = path.extension(Uri.tryParse(url)?.path ?? '');
    if (!_emoteExtRegex.hasMatch(ext)) {
      ext = '.png';
    }
    return '${Utils.safeFileName(name)}$ext';
  }

  static String _emoteSuffixedFileName(String fileName, int index) {
    final ext = path.extension(fileName);
    final base = ext.isEmpty
        ? fileName
        : fileName.substring(0, fileName.length - ext.length);
    return '${base}_$index$ext';
  }

  /// 保存到桌面端目录，返回 true 表示写入，false 表示内容已存在。
  static Future<bool> _saveEmoteToDir(
    Uint8List bytes,
    String fileName,
    String hash,
    Directory dir,
  ) async {
    for (var index = 0; index < _maxEmoteNameConflict; index++) {
      final name = index == 0
          ? fileName
          : _emoteSuffixedFileName(fileName, index);
      final file = File(path.join(dir.path, name));
      if (file.existsSync()) {
        final existingHash = md5.convert(await file.readAsBytes()).toString();
        if (existingHash == hash) {
          return false;
        }
        continue;
      }
      await file.writeAsBytes(bytes, flush: true);
      return true;
    }
    throw StateError('too many emote name conflicts');
  }

  /// 保存到系统相册，返回 true 表示写入，false 表示内容已存在。
  ///
  /// 移动端无法查询相册，故用 [records] 中「文件名 -> md5」记录判重。
  static Future<bool> _saveEmoteToGallery(
    Map<String, String> records,
    String filePath,
    String fileName,
    String hash,
  ) async {
    for (var index = 0; index < _maxEmoteNameConflict; index++) {
      final name = index == 0
          ? fileName
          : _emoteSuffixedFileName(fileName, index);
      final savedHash = records[name];
      if (savedHash != null) {
        if (savedHash == hash) {
          return false;
        }
        continue;
      }
      final res = await SaverGallery.saveFile(
        filePath: filePath,
        fileName: name,
        albumPath: _albumPath,
        skipIfExists: false,
      );
      if (!res.isSuccess) {
        throw StateError(res.errorMessage ?? '保存失败');
      }
      records[name] = hash;
      await GStorage.localCache.put(
        LocalCacheKey.emoteSaved,
        Map<String, String>.from(records),
      );
      return true;
    }
    throw StateError('too many emote name conflicts');
  }

  static Map<String, String> _loadEmoteRecords() {
    final saved = GStorage.localCache.get(LocalCacheKey.emoteSaved);
    if (saved is Map) {
      return {
        for (final entry in saved.entries)
          entry.key.toString(): entry.value.toString(),
      };
    }
    return <String, String>{};
  }

  static final _suffixRegex = RegExp(
    r'\.(jpg|jpeg|png|webp|gif|avif)$',
    caseSensitive: false,
  );
  static String safeThumbnailUrl(String? src) {
    if (src != null && _suffixRegex.hasMatch(src)) {
      return thumbnailUrl(src);
    }
    return src.http2https;
  }

  static final _thumbRegex = RegExp(
    r'(@(\d+[a-z]_?)*)(\..*)?$',
    caseSensitive: false,
  );
  static String thumbnailUrl(String? src, [int maxQuality = 1]) {
    if (src != null && maxQuality != 100) {
      maxQuality = math.max(maxQuality, GlobalData().imgQuality);
      bool hasMatch = false;
      src = src.splitMapJoin(
        _thumbRegex,
        onMatch: (match) {
          hasMatch = true;
          String suffix = match.group(3) ?? '.webp';
          return '${match.group(1)}_${maxQuality}q$suffix';
        },
        onNonMatch: (String str) {
          return str;
        },
      );
      if (!hasMatch) {
        src += '@${maxQuality}q.webp';
      }
    }
    return src.http2https;
  }

  static Future<SaveResult?> saveByteImg({
    required Uint8List bytes,
    required String fileName,
    String ext = 'png',
    bool showLoading = true,
  }) async {
    SaveResult? res;
    fileName += '.$ext';
    if (PlatformUtils.isMobile) {
      if (showLoading) SmartDialog.showLoading(msg: '正在保存');
      res = await SaverGallery.saveImage(
        bytes,
        fileName: fileName,
        albumPath: _albumPath,
        skipIfExists: false,
      );
      SmartDialog.dismiss();
      if (res.isSuccess) {
        SmartDialog.showToast(' 已保存 ');
      } else {
        SmartDialog.showToast('保存失败，${res.errorMessage}');
      }
    } else {
      SmartDialog.dismiss();
      final savePath = await FilePicker.saveFile(
        type: FileType.image,
        fileName: fileName,
        bytes: Uint8List(0),
      );
      if (savePath == null) {
        SmartDialog.showToast("取消保存");
        return null;
      }
      await File(savePath.toFilePath()).writeAsBytes(bytes);
      SmartDialog.showToast(' 已保存 ');
      res = SaveResult(true, null);
    }
    return res;
  }

  static Future<void> saveFileImg({
    required String filePath,
    required String fileName,
    FileType type = FileType.image,
    bool needToast = false,
  }) async {
    final file = File(filePath);
    if (!file.existsSync()) {
      SmartDialog.showToast("文件不存在");
      return;
    }
    SaveResult? res;
    if (PlatformUtils.isMobile) {
      res = await SaverGallery.saveFile(
        filePath: filePath,
        fileName: fileName,
        albumPath: _albumPath,
        skipIfExists: false,
      );
    } else {
      final savePath = await FilePicker.saveFile(
        type: type,
        fileName: fileName,
        bytes: Uint8List(0),
      );
      if (savePath == null) {
        SmartDialog.showToast("取消保存");
        return;
      }
      await file.moveOrCopy(savePath.toFilePath());
      res = SaveResult(true, null);
    }
    if (needToast) {
      if (res.isSuccess) {
        SmartDialog.showToast(' 已保存 ');
      } else {
        SmartDialog.showToast('保存失败，${res.errorMessage}');
      }
    }
  }
}
