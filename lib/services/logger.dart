import 'dart:io';

import 'package:PiliPlus/utils/json_file_handler.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:catcher_2/catcher_2.dart';
import 'package:catcher_2/utils/log_printer.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

final logger = PiliLogger();

class PiliLogger extends Logger {
  PiliLogger()
      : super(
          filter: ProductionFilter(),
          printer: PrettyLogPrinter(
            dateTimeFormat: PrettyLogPrinter.toEncodableFallback,
          ),
          level: .trace,
        );

  @override
  void log(
    Level level,
    dynamic message, {
    Object? error,
    StackTrace? stackTrace,
    DateTime? time,
  }) {
    // 如果日志开关关闭，且不是调试模式，则直接返回，不处理任何逻辑（节省性能）
    if (!Pref.enableLog && !kDebugMode) {
      return;
    }

    if (Pref.enableLog && (level == Level.error || level == Level.fatal)) {
      try {
        Catcher2.reportCheckedError(error ?? message ?? 'Unknown error', stackTrace);
      } catch (e) {
        // Fallback if Catcher2 is not initialized or fails
      }
    }

    // 只有在调试模式或者开启了日志时，才交给父类处理（打印到控制台等）
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
