import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';

/// Uses the real Share Kit panel, including files created with XFile.fromData.
class SharePlusOhos extends SharePlatform {
  static const _channel = MethodChannel('org.tsinbeilabs.share_plus_ohos/share');
  static void registerWith() => SharePlatform.instance = SharePlusOhos();

  @override
  Future<ShareResult> share(ShareParams params) async {
    final files = params.files;
    if (files != null && files.isNotEmpty) {
      final overrides = params.fileNameOverrides;
      if (overrides != null && overrides.length != files.length) {
        throw ArgumentError('fileNameOverrides must match files');
      }
      final paths = <String>[];
      final names = <String>[];
      Directory? temporary;
      for (var i = 0; i < files.length; i++) {
        final file = files[i];
        var name = overrides?[i] ?? file.name;
        if (name.isEmpty) name = 'shared_file_$i';
        name = name.replaceAll(RegExp(r'[/\\]'), '_');
        names.add(name);
        if (file.path.isNotEmpty && await File(file.path).exists()) {
          paths.add(file.path);
        } else {
          temporary ??= await (await getTemporaryDirectory()).createTemp('piliplus_share_');
          final directory = await Directory('${temporary.path}/$i').create();
          final path = '${directory.path}/$name';
          await file.saveTo(path);
          paths.add(path);
        }
      }
      // Share Kit may read these after the channel reply; keep cache files until
      // the OS/app cache is cleared, as the upstream mobile implementations do.
      await _channel.invokeMethod<void>('shareFiles', {
        'paths': paths, 'names': names, 'subject': params.subject,
        'text': params.text, 'title': params.title,
      });
    } else if (params.uri != null) {
      await _channel.invokeMethod<void>('shareUri', {
        'uri': params.uri.toString(), 'subject': params.subject, 'title': params.title,
      });
    } else {
      await _channel.invokeMethod<void>('shareText', {
        'text': params.text ?? '', 'subject': params.subject, 'title': params.title,
      });
    }
    // Opening the panel is observed; its final user action is not provided by
    // this native plugin. Platform failures propagate instead of becoming success.
    return const ShareResult('dev.fluttercommunity.plus/share/unavailable', ShareResultStatus.unavailable);
  }
}
