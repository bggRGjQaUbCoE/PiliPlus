import 'dart:convert';
import 'dart:io';

import 'package:catcher_2/model/platform_type.dart';
import 'package:catcher_2/model/report.dart';
import 'package:catcher_2/model/report_handler.dart';
import 'package:flutter/material.dart';

class JsonFileHandler extends ReportHandler {
  JsonFileHandler({
    this.enableDeviceParameters = true,
    this.enableApplicationParameters = true,
    this.enableStackTrace = true,
    this.enableCustomParameters = true,
    this.printLogs = false,
    this.handleWhenRejected = false,
  });

  /// A file that should be written to.
  static late final File file;

  final bool enableDeviceParameters;
  final bool enableApplicationParameters;
  final bool enableStackTrace;
  final bool enableCustomParameters;
  final bool printLogs;
  final bool handleWhenRejected;

  static IOSink? sink;
  bool? _fileValidated;

  @override
  Future<bool> handle(Report report, BuildContext? context) async {
    if (_fileValidated == false) return false;
    try {
      _fileValidated ??= await _checkFile();
      if (_fileValidated == false) return false;
      await _processReport(report);
      return true;
    } catch (exc, stackTrace) {
      _printLog('Exception occurred: $exc stack: $stackTrace');
      return false;
    }
  }

  Future<void> _processReport(Report report) async {
    _writeReportToFile(report);
    await _flushFile();
  }

  Future<bool> _checkFile() async {
    try {
      final exists = file.existsSync();
      if (!exists) {
        file.createSync();
      }
      sink = file.openWrite(mode: FileMode.writeOnlyAppend)..add(const []);
      await sink!.flush();
      return true;
    } catch (exc, stackTrace) {
      _printLog('Exception occurred: $exc stack: $stackTrace');
      return false;
    }
  }

  Future<void> _flushFile() async {
    await sink?.flush();
    _printLog('Flushed file');
  }

  void _writeReportToFile(Report report) {
    _printLog('Writing report to file');
    final json = report.toJson(
      enableDeviceParameters: enableDeviceParameters,
      enableApplicationParameters: enableApplicationParameters,
      enableStackTrace: enableStackTrace,
      enableCustomParameters: enableCustomParameters,
    );
    sink
      ?..add(utf8.encode(jsonEncode(json)))
      ..writeln();
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
