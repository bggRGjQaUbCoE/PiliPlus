import 'dart:convert';
import 'dart:io';

import 'package:PiliPlus/services/logger.dart' show LoggerUtils;
import 'package:catcher_2/model/platform_type.dart';
import 'package:catcher_2/model/report.dart';
import 'package:catcher_2/model/report_handler.dart';
import 'package:flutter/material.dart';

class JsonFileHandler extends ReportHandler {
  final bool enableDeviceParameters;
  final bool enableApplicationParameters;
  final bool enableStackTrace;
  final bool enableCustomParameters;
  final bool printLogs;
  final bool handleWhenRejected;

  static Future<RandomAccessFile> _future = LoggerUtils.getLogsPath()
      .then((file) => file.open(mode: FileMode.writeOnlyAppend))
      .then((raf) => raf.writeFrom(const []))
      .then(_flush);

  JsonFileHandler._({
    this.enableDeviceParameters = true,
    this.enableApplicationParameters = true,
    this.enableStackTrace = true,
    this.enableCustomParameters = true,
    this.printLogs = false,
    this.handleWhenRejected = false,
  });

  static Future<JsonFileHandler?> init({
    bool enableDeviceParameters = true,
    bool enableApplicationParameters = true,
    bool enableStackTrace = true,
    bool enableCustomParameters = true,
    bool printLogs = false,
    bool handleWhenRejected = false,
  }) async {
    try {
      await _future;
      return JsonFileHandler._(
        enableDeviceParameters: enableDeviceParameters,
        enableApplicationParameters: enableApplicationParameters,
        enableStackTrace: enableStackTrace,
        enableCustomParameters: enableCustomParameters,
        printLogs: printLogs,
        handleWhenRejected: handleWhenRejected,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s, label: e.toString());
      return null;
    }
  }

  static Future<RandomAccessFile> _flush(RandomAccessFile raf) => raf.flush();

  static Future<RandomAccessFile> add(
    Future<RandomAccessFile> Function(RandomAccessFile) onValue,
  ) {
    return _future = _future.then(onValue).then(_flush);
  }

  @override
  Future<bool> handle(Report report, BuildContext? context) async {
    try {
      await _processReport(report);
      return true;
    } catch (exc, stackTrace) {
      _printLog('Exception occurred: $exc stack: $stackTrace');
      return false;
    }
  }

  Future<void> _processReport(Report report) {
    _printLog('Writing report to file');
    final json = report.toJson(
      enableDeviceParameters: enableDeviceParameters,
      enableApplicationParameters: enableApplicationParameters,
      enableStackTrace: enableStackTrace,
      enableCustomParameters: enableCustomParameters,
    );
    return add((raf) => raf.writeString('${jsonEncode(json)}\n'));
  }

  void _printLog(String log) {
    if (printLogs) {
      logger.info(log);
    }
  }

  @override
  List<PlatformType> getSupportedPlatforms() => const [
    PlatformType.android,
    PlatformType.iOS,
    PlatformType.linux,
    PlatformType.macOS,
    PlatformType.windows,
  ];

  @override
  bool shouldHandleWhenRejected() => handleWhenRejected;
}
