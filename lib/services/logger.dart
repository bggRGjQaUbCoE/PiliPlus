import 'dart:io';

import 'package:PiliPlus/utils/extension/file_ext.dart';
import 'package:PiliPlus/utils/json_file_handler.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:catcher_2/catcher_2.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

final logger = PiliLogger();

class PiliLogger extends Logger {
  PiliLogger() : super();

  @override
  void log(
    Level level,
    dynamic message, {
    Object? error,
    StackTrace? stackTrace,
    DateTime? time,
  }) {
    if (level == Level.error || level == Level.fatal) {
      Catcher2.reportCheckedError(error, stackTrace);
    }
    super.log(level, message, error: error, stackTrace: stackTrace, time: time);
  }
}

abstract final class LoggerUtils {
  static File? _logFile;

  static Future<File> getLogsPath() async {
    if (_logFile != null) return _logFile!;

    String dir = (await getApplicationDocumentsDirectory()).path;
    final String filename = p.join(dir, '.pili_logs.json');
    final File file = File(filename);
    if (!file.existsSync()) {
      await file.create(recursive: true);
      // TODO: remove after next two versions
      final oldFile = File(p.join(dir, '.pili_logs'));
      if (oldFile.existsSync()) oldFile.tryDel();
    }
    return _logFile = file;
  }

  static Future<bool> clearLogs() async {
    try {
      if (Pref.enableLog) {
        await JsonFileHandler.add(
          (raf) => raf.setPosition(0).then((raf) => raf.truncate(0)),
        );
      } else {
        final file = await getLogsPath();
        await file.writeAsBytes(const [], flush: true);
      }
    } catch (e) {
      // if (kDebugMode) debugPrint('Error clearing file: $e');
      return false;
    }
    return true;
  }
}
