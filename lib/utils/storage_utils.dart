import 'dart:io' show File;
import 'dart:typed_data' show Uint8List;

import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

abstract final class StorageUtils {
  static Future<void> saveBytes2File({
    required String name,
    required Uint8List bytes,
    required List<String> allowedExtensions,
    FileType type = FileType.custom,
  }) async {
    try {
      final path = await FilePicker.saveFile(
        allowedExtensions: allowedExtensions,
        type: type,
        fileName: name,
        bytes: PlatformUtils.isDesktop ? Uint8List(0) : bytes,
      );
      if (path == null) {
        SmartDialog.showToast(L10n.current.imageUtilsDownloadImgText);
        return;
      }
      if (PlatformUtils.isDesktop) {
        await File(path.toFilePath()).writeAsBytes(bytes);
      }
      SmartDialog.showToast(L10n.current.saved);
    } catch (e) {
      SmartDialog.showToast("保存失败: $e");
    }
  }
}
