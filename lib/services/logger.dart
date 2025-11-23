import 'dart:io';

import 'package:PiliPlus/utils/json_file_handler.dart';
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
    final String filename = p.join(dir, ".pili_logs.json");
    final File file = File(filename);
    if (!file.existsSync()) {
      await file.create(recursive: true);
    }
    return _logFile = file;
  }

  static Future<bool> clearLogs() async {
    final file = await getLogsPath();
    try {
      final sink = JsonFileHandler.sink;
      if (sink != null) {
        JsonFileHandler.sink = null;
        await sink.close();
        JsonFileHandler.sink = file.openWrite(mode: FileMode.writeOnly)
          ..add(const [])
          ..flush();
      } else {
        await file.writeAsBytes(const [], flush: true);
      }
    } catch (e) {
      // if (kDebugMode) debugPrint('Error clearing file: $e');
      return false;
    }
    return true;
  }
}
