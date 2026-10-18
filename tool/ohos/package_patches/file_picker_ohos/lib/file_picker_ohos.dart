import 'dart:io';
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:file_picker_platform_interface/file_picker_platform_interface.dart';
import 'package:flutter/services.dart';

/// Keeps file_picker 13's public API while using the pinned OHOS system picker.
class FilePickerOhos extends FilePickerPlatform {
  static const _channel = MethodChannel('miguelruivo.flutter.plugins.filepicker');

  static void registerWith() => FilePickerPlatform.instance = FilePickerOhos();

  Future<List<PlatformFile>> _pick({
    required bool multiple,
    required FileType type,
    List<String>? allowedExtensions,
    int compressionQuality = 0,
    Function(FilePickerStatus)? onFileLoading,
  }) async {
    if (type == FileType.custom && (allowedExtensions == null || allowedExtensions.isEmpty)) {
      throw ArgumentError('FileType.custom requires allowedExtensions');
    }
    onFileLoading?.call(FilePickerStatus.picking);
    try {
      final result = await _channel.invokeListMethod<Object?>(type.name, {
        'allowMultipleSelection': multiple,
        'allowedExtensions': allowedExtensions,
        'withData': false,
        'allowCompression': compressionQuality > 0,
        'compressionQuality': compressionQuality,
      });
      return [
        for (final item in result ?? const <Object?>[])
          OhosPlatformFile.fromMap(Map<String, Object?>.from(item! as Map)),
      ];
    } finally {
      onFileLoading?.call(FilePickerStatus.done);
    }
  }

  @override
  Future<PlatformFile?> pickFile({
    String? dialogTitle, String? initialDirectory,
    FileType type = FileType.any, List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading, int compressionQuality = 0,
    AndroidOptions androidOptions = const AndroidOptions(),
    DarwinOptions darwinOptions = const DarwinOptions(),
    WindowsOptions windowsOptions = const WindowsOptions(),
    LinuxOptions linuxOptions = const LinuxOptions(),
    WebOptions webOptions = const WebOptions(),
  }) async {
    final files = await _pick(multiple: false, type: type,
      allowedExtensions: allowedExtensions, compressionQuality: compressionQuality,
      onFileLoading: onFileLoading);
    return files.isEmpty ? null : files.single;
  }

  @override
  Future<List<PlatformFile>> pickFiles({
    String? dialogTitle, String? initialDirectory,
    FileType type = FileType.any, List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading, int compressionQuality = 0,
    AndroidOptions androidOptions = const AndroidOptions(),
    DarwinOptions darwinOptions = const DarwinOptions(),
    WindowsOptions windowsOptions = const WindowsOptions(),
    LinuxOptions linuxOptions = const LinuxOptions(),
    WebOptions webOptions = const WebOptions(),
  }) => _pick(multiple: true, type: type,
      allowedExtensions: allowedExtensions, compressionQuality: compressionQuality,
      onFileLoading: onFileLoading);

  @override
  Future<String?> getDirectoryPath({
    String? dialogTitle, String? initialDirectory,
    AndroidOptions androidOptions = const AndroidOptions(),
    WindowsOptions windowsOptions = const WindowsOptions(),
    LinuxOptions linuxOptions = const LinuxOptions(),
    WebOptions webOptions = const WebOptions(),
  }) async {
    final result = await _channel.invokeMethod<String>('dir', {
      'allowMultipleSelection': false, 'initialDirectory': initialDirectory,
    });
    if (result == null) return null;
    final uri = Uri.parse(result);
    final path = uri.scheme == 'file' ? uri.toFilePath() : result;
    if (!await Directory(path).exists()) {
      throw PlatformException(code: 'directory_access',
        message: 'The selected OHOS directory is not accessible to Dart file I/O: $result');
    }
    return path;
  }

  @override
  Future<Uri?> saveFile({
    required String fileName, required Uint8List bytes, required String mimeType,
    String? dialogTitle, String? initialDirectory,
    Function(FilePickerStatus)? onFileSaving,
    WindowsOptions windowsOptions = const WindowsOptions(),
    LinuxOptions linuxOptions = const LinuxOptions(),
    WebOptions webOptions = const WebOptions(),
  }) async {
    if (fileName.isEmpty || fileName.contains('/') || fileName.contains('\\')) {
      throw ArgumentError.value(fileName, 'fileName', 'Must be a file name');
    }
    onFileSaving?.call(FilePickerStatus.picking);
    try {
      final result = await _channel.invokeMethod<String>('save', {
        'fileName': fileName, 'bytes': bytes, 'mimeType': mimeType,
        'initialDirectory': initialDirectory,
      });
      if (result == null) return null;
      final uri = Uri.parse(result);
      return uri.hasScheme ? uri : Uri.file(result);
    } finally {
      onFileSaving?.call(FilePickerStatus.done);
    }
  }

  @override
  Future<void> clearTemporaryFiles() async {
    final result = await _channel.invokeMethod<bool>('clear');
    if (result != true) {
      throw PlatformException(code: 'clear_failed', message: 'OHOS picker cache could not be cleared');
    }
  }
}

/// Picked document bytes are copied by the native plugin into the app cache.
final class OhosPlatformFile extends PlatformFile {
  OhosPlatformFile._(this.name, this.uri, this._size);

  factory OhosPlatformFile.fromMap(Map<String, Object?> map) {
    final path = map['path'] as String?;
    if (path == null || path.isEmpty) {
      throw PlatformException(code: 'missing_path', message: 'OHOS picker did not return a cached file');
    }
    final parsed = Uri.parse(path);
    return OhosPlatformFile._(map['name']! as String,
      parsed.hasScheme ? parsed : Uri.file(path), (map['size'] as num?)?.toInt());
  }

  @override
  final String name;
  @override
  final Uri uri;
  final int? _size;
  File get _file => File.fromUri(uri);
  @override
  XFile get xFile => XFile(_file.path, name: name);
  @override
  int? lengthSync() => _size;
  @override
  Future<int?> length() async => _size ?? await _file.length();
  @override
  Future<Uint8List> readAsBytes() => _file.readAsBytes();
  @override
  Stream<Uint8List> readAsByteStream() => _file.openRead().map(Uint8List.fromList);
}
