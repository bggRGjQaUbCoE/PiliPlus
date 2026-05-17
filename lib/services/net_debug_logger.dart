import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:PiliPlus/utils/path_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;
import 'package:path/path.dart' as p;

enum NetLogLevel { info, warn, error }

class NetLogEntry {
  final DateTime time;
  final NetLogLevel level;
  final String tag;
  final String message;
  final Map<String, dynamic>? extra;

  NetLogEntry({
    required this.level,
    required this.tag,
    required this.message,
    this.extra,
  }) : time = DateTime.now();

  Map<String, dynamic> toJson() => {
    'time': time.toIso8601String(),
    'level': level.name,
    'tag': tag,
    'message': message,
    if (extra != null) 'extra': extra,
  };

  @override
  String toString() {
    final ts = '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}:'
        '${time.second.toString().padLeft(2, '0')}.'
        '${time.millisecond.toString().padLeft(3, '0')}';
    final lvl = level.name.toUpperCase().padRight(5);
    final ext = extra != null ? ' | $extra' : '';
    return '[$ts] $lvl [$tag] $message$ext';
  }
}

class NetDebugLogger {
  NetDebugLogger._();
  static final NetDebugLogger _instance = NetDebugLogger._();
  static NetDebugLogger get instance => _instance;

  static const int _maxEntries = 2000;
  final _entries = ListQueue<NetLogEntry>();

  IOSink? _fileSink;
  String? _logFilePath;

  bool get enabled => Pref.enableNetLog;

  String? get logFilePath => _logFilePath;

  List<NetLogEntry> get entries => _entries.toList();

  List<NetLogEntry> getByTag(String tag) =>
      _entries.where((e) => e.tag == tag).toList();

  void _ensureFileSink() {
    if (_fileSink != null) return;
    try {
      final logDir = p.join(appSupportDirPath, 'logs');
      Directory(logDir).createSync(recursive: true);
      _logFilePath = p.join(logDir, 'net_debug.log');
      _fileSink = File(_logFilePath!).openWrite(mode: FileMode.append);
      _fileSink!.writeln(
        '\n===== Session ${DateTime.now().toIso8601String()} =====',
      );
    } catch (_) {
      _fileSink = null;
    }
  }

  void log(
    NetLogLevel level,
    String tag,
    String message, {
    Map<String, dynamic>? extra,
  }) {
    if (!enabled) return;
    final entry = NetLogEntry(level: level, tag: tag, message: message, extra: extra);
    _entries.addLast(entry);
    while (_entries.length > _maxEntries) {
      _entries.removeFirst();
    }
    _ensureFileSink();
    _fileSink?.writeln(entry.toString());
    // ignore: avoid_print
    print(entry.toString());
  }

  void info(String tag, String message, {Map<String, dynamic>? extra}) =>
      log(NetLogLevel.info, tag, message, extra: extra);

  void warn(String tag, String message, {Map<String, dynamic>? extra}) =>
      log(NetLogLevel.warn, tag, message, extra: extra);

  void error(String tag, String message, {Map<String, dynamic>? extra}) =>
      log(NetLogLevel.error, tag, message, extra: extra);

  void clear() => _entries.clear();

  Future<void> flush() async {
    await _fileSink?.flush();
  }

  Future<void> close() async {
    await _fileSink?.flush();
    await _fileSink?.close();
    _fileSink = null;
  }

  File get logFile => File(
    _logFilePath ?? p.join(appSupportDirPath, 'logs', 'net_debug.log'),
  );

  String exportToString() => _entries.map((e) => e.toString()).join('\n');

  String exportToJson() =>
      const JsonEncoder.withIndent('  ').convert(_entries.map((e) => e.toJson()).toList());
}

final netLog = NetDebugLogger.instance;

class NetDebugInterceptor extends Interceptor {
  static const _tag = 'HTTP';

  String _briefUrl(RequestOptions options) {
    final uri = options.uri;
    final path = uri.path;
    final host = uri.host;
    if (host.contains('bilibili') || host.contains('bilivideo')) {
      return '$host$path';
    }
    return uri.toString().split('?').first;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (netLog.enabled) {
      final extra = <String, dynamic>{
        'method': options.method,
      };
      if (options.responseType == ResponseType.bytes) {
        extra['type'] = 'bytes';
      }
      if (options.extra['_rt'] case final int rt when rt > 0) {
        extra['retry'] = rt;
      }
      netLog.info(_tag, '→ ${_briefUrl(options)}', extra: extra);
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (netLog.enabled) {
      final options = response.requestOptions;
      final elapsed = response.extra['_elapsed_ms'];
      final extra = <String, dynamic>{
        'status': response.statusCode ?? -1,
      };
      if (elapsed != null) extra['ms'] = elapsed;
      final contentLength = response.headers.value('content-length');
      if (contentLength != null) extra['bytes'] = contentLength;
      netLog.info(_tag, '← ${_briefUrl(options)}', extra: extra);
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (netLog.enabled) {
      final options = err.requestOptions;
      netLog.error(_tag, '✕ ${_briefUrl(options)}', extra: {
        'type': err.type.name,
        'status': err.response?.statusCode,
        'message': err.message?.take80,
      });
    }
    handler.next(err);
  }
}

class NetDebugTimingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['_req_start'] = DateTime.now().millisecondsSinceEpoch;
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final start = response.requestOptions.extra['_req_start'];
    if (start is int) {
      response.extra['_elapsed_ms'] =
          DateTime.now().millisecondsSinceEpoch - start;
    }
    handler.next(response);
  }
}

extension on String {
  String get take80 => length <= 80 ? this : '${substring(0, 80)}...';
}
