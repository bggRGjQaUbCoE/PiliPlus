import 'dart:io';
import 'dart:typed_data';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/permission_handler.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:live_photo_maker/live_photo_maker.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:share_plus/share_plus.dart';

abstract class ImageUtils {
  static String get time =>
      DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
  static bool silentDownImg = Pref.silentDownImg;

  // 图片分享
  static Future<void> onShareImg(String url) async {
    try {
      SmartDialog.showLoading();
      final path =
          '${await Utils.temporaryDirectory}/${Utils.getFileName(url)}';
      final res = await Request().downloadFile(url.http2https, path);
      SmartDialog.dismiss();
      if (res.statusCode == 200) {
        await SharePlus.instance
            .share(
              ShareParams(
                files: [XFile(path)],
                sharePositionOrigin: await Utils.sharePositionOrigin,
              ),
            )
            .whenComplete(File(path).tryDel);
      }
    } catch (e) {
      SmartDialog.showToast(e.toString());
    }
  }

  // 获取存储权限
  static Future<bool> requestStoragePer(BuildContext context) async {
    await Permission.storage.request();
    PermissionStatus status = await Permission.storage.status;
    if (status == PermissionStatus.denied ||
        status == PermissionStatus.permanentlyDenied) {
      if (!context.mounted) return false;
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('提示'),
            content: Text('存储权限未授权'),
            actions: [
              TextButton(
                onPressed: openAppSettings,
                child: Text('去授权'),
              ),
            ],
          );
        },
      );
      return false;
    } else {
      return true;
    }
  }

  // 获取相册权限
  static Future<bool> requestPhotoPer() async {
    await Permission.photos.request();
    PermissionStatus status = await Permission.photos.status;
    if (status == PermissionStatus.denied ||
        status == PermissionStatus.permanentlyDenied) {
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> checkPermissionDependOnSdkInt(
    BuildContext context,
  ) async {
    if (Platform.isAndroid) {
      if (await Utils.sdkInt <= 32) {
        if (!context.mounted) return false;
        return requestStoragePer(context);
      } else {
        return requestPhotoPer();
      }
    }
    return requestStoragePer(context);
  }

  static Future<bool> downloadLivePhoto({
    required BuildContext context,
    required String url,
    required String liveUrl,
    required int width,
    required int height,
  }) async {
    try {
      if (Utils.isMobile && !await checkPermissionDependOnSdkInt(context)) {
        return false;
      }
      if (!silentDownImg) SmartDialog.showLoading(msg: '正在下载');

      String tmpPath = await Utils.temporaryDirectory;
      late String imageName = "cover_${Utils.getFileName(url)}";
      late String imagePath = '$tmpPath/$imageName';
      String videoName = "video_${Utils.getFileName(liveUrl)}";
      String videoPath = '$tmpPath/$videoName';

      final res = await Request().downloadFile(liveUrl.http2https, videoPath);
      if (res.statusCode != 200) throw '${res.statusCode}';

      if (Platform.isIOS) {
        final res1 = await Request().downloadFile(url.http2https, imagePath);
        if (res1.statusCode != 200) throw '${res1.statusCode}';
        if (!silentDownImg) SmartDialog.showLoading(msg: '正在保存');
        bool success =
            await LivePhotoMaker.create(
              coverImage: imagePath,
              imagePath: null,
              voicePath: videoPath,
              width: width,
              height: height,
            ).whenComplete(
              () {
                File(videoPath).tryDel();
                File(imagePath).tryDel();
              },
            );
        if (success) {
          SmartDialog.showToast(' Live Photo 已保存 ');
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

  static Future<bool> downloadImg(
    BuildContext context,
    List<String> imgList, [
    CacheManager? manager,
  ]) async {
    if (Utils.isMobile && !await checkPermissionDependOnSdkInt(context)) {
      return false;
    }
    CancelToken? cancelToken;
    if (!silentDownImg) {
      cancelToken = CancelToken();
      SmartDialog.showLoading(
        msg: '正在下载原图',
        clickMaskDismiss: true,
        onDismiss: cancelToken.cancel,
      );
    }
    try {
      final futures = imgList.map((url) async {
        final name = Utils.getFileName(url);

        final file = (await (manager ?? DefaultCacheManager()).getFileFromCache(
          url.http2https,
        ))?.file;

        if (file == null) {
          final String filePath = '${await Utils.temporaryDirectory}/$name';

          final response = await Request().downloadFile(
            url.http2https,
            filePath,
            cancelToken: cancelToken,
          );

          if (Utils.isMobile) {
            if (response.statusCode == 200) {
              await SaverGallery.saveFile(
                filePath: filePath,
                fileName: name,
                androidRelativePath: "Pictures/${Constants.appName}",
                skipIfExists: false,
              ).whenComplete(File(filePath).tryDel);
            }
          }
          return (
            filePath: filePath,
            name: name,
            statusCode: response.statusCode,
            del: true,
          );
        } else {
          if (Utils.isMobile) {
            await SaverGallery.saveFile(
              filePath: file.path,
              fileName: name,
              androidRelativePath: "Pictures/${Constants.appName}",
              skipIfExists: false,
            );
          }

          return (filePath: file.path, name: name, statusCode: 200, del: false);
        }
      });
      final result = await Future.wait(futures, eagerError: true);
      if (!Utils.isMobile) {
        for (var res in result) {
          if (res.statusCode == 200) {
            await saveFileImg(
              filePath: res.filePath,
              fileName: res.name,
              del: res.del,
            );
          }
        }
      }
      if (cancelToken?.isCancelled == true) {
        SmartDialog.showToast('已取消下载');
        return false;
      } else {
        SmartDialog.showToast('图片已保存');
      }
      return true;
    } catch (e) {
      if (cancelToken?.isCancelled == true) {
        SmartDialog.showToast('已取消下载');
      } else {
        SmartDialog.showToast(e.toString());
      }
      return false;
    } finally {
      if (!silentDownImg) SmartDialog.dismiss(status: SmartStatus.loading);
    }
  }

  static final _thumbRegex = RegExp(
    r'(@(\d+[a-z]_?)*)(\..*)?$',
    caseSensitive: false,
  );
  static String thumbnailUrl(String? src, [int? quality]) {
    if (src != null && quality != 100) {
      bool hasMatch = false;
      src = src.splitMapJoin(
        _thumbRegex,
        onMatch: (Match match) {
          hasMatch = true;
          String suffix = match.group(3) ?? '.webp';
          return '${match.group(1)}_${quality ?? GlobalData().imgQuality}q$suffix';
        },
        onNonMatch: (String str) {
          return str;
        },
      );
      if (!hasMatch) {
        src += '@${quality ?? GlobalData().imgQuality}q.webp';
      }
    }
    return src.http2https;
  }

  static Future<SaveResult?> saveByteImg({
    required Uint8List bytes,
    required String fileName,
    String ext = 'png',
  }) async {
    SaveResult? result;
    fileName += '.$ext';
    if (Utils.isMobile) {
      SmartDialog.showLoading(msg: '正在保存');
      result = await SaverGallery.saveImage(
        bytes,
        fileName: fileName,
        androidRelativePath: "Pictures/${Constants.appName}",
        skipIfExists: false,
      );
      SmartDialog.dismiss();
      if (result.isSuccess) {
        SmartDialog.showToast(' 已保存 ');
      } else {
        SmartDialog.showToast('保存失败，${result.errorMessage}');
      }
    } else {
      SmartDialog.dismiss();
      final savePath = await FilePicker.platform.saveFile(
        type: FileType.image,
        fileName: fileName,
      );
      if (savePath == null) {
        SmartDialog.showToast("取消保存");
        return null;
      }
      await File(savePath).writeAsBytes(bytes);
      SmartDialog.showToast(' 已保存 ');
      result = SaveResult(true, null);
    }
    return result;
  }

  static Future<void> saveFileImg({
    required String filePath,
    required String fileName,
    FileType type = FileType.image,
    bool needToast = false,
    bool del = true,
  }) async {
    final file = File(filePath);
    if (!file.existsSync()) {
      SmartDialog.showToast("文件不存在");
      return;
    }
    SaveResult? result;
    if (Utils.isMobile) {
      result = await SaverGallery.saveFile(
        filePath: filePath,
        fileName: fileName,
        androidRelativePath: "Pictures/${Constants.appName}",
        skipIfExists: false,
      );
      if (del) file.tryDel();
    } else {
      final savePath = await FilePicker.platform.saveFile(
        type: type,
        fileName: fileName,
      );
      if (savePath == null) {
        SmartDialog.showToast("取消保存");
        return;
      }
      await file.copy(savePath);
      if (del) file.tryDel();
      result = SaveResult(true, null);
    }
    if (needToast) {
      if (result.isSuccess) {
        SmartDialog.showToast(' 已保存 ');
      } else {
        SmartDialog.showToast('保存失败，${result.errorMessage}');
      }
    }
  }
}
