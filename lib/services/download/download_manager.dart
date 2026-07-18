import 'dart:async';
import 'dart:io';

import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/utils/extension/file_ext.dart';
import 'package:PiliPlus/utils/extension/string_ext.dart';
import 'package:dio/dio.dart';

abstract interface class DownloadTask {
  DownloadStatus get status;

  Future<void> cancel({required bool isDelete});
}

class DownloadManager implements DownloadTask {
  static final _contentRangeRegExp = RegExp(
    r'^bytes\s+(\d+)-\d+/(?:\d+|\*)$',
    caseSensitive: false,
  );
  static final _unsatisfiedContentRangeRegExp = RegExp(
    r'^bytes\s+\*/(\d+)$',
    caseSensitive: false,
  );

  final String url;
  final String path;
  final void Function(int, int)? onReceiveProgress;
  final void Function([Object? error]) onDone;

  DownloadStatus _status = DownloadStatus.downloading;

  @override
  DownloadStatus get status => _status;
  final _cancelToken = CancelToken();
  late Future<void> task;

  DownloadManager({
    required this.url,
    required this.path,
    required this.onReceiveProgress,
    required this.onDone,
  }) {
    task = _start();
  }

  Future<void> _start() async {
    int received;

    final file = File(path);
    if (file.existsSync()) {
      received = await file.length();
    } else {
      file.createSync(recursive: true);
      received = 0;
    }

    IOSink? sink;

    Future<void> onError(Object e, {bool delete = false}) async {
      try {
        if (sink case final sink?) {
          await sink.close();
        }
      } catch (_) {}
      if (_status == DownloadStatus.downloading) {
        _status = DownloadStatus.failDownload;
        if (delete && file.existsSync()) {
          await file.tryDel();
        }
      }
      onDone(e);
    }

    Response<ResponseBody> response;
    try {
      response = await Request.http11Dio.get<ResponseBody>(
        url.http2https,
        options: Options(
          headers: {'range': 'bytes=$received-'},
          responseType: ResponseType.stream,
          validateStatus: (status) =>
              status != null &&
              (status == 416 || (status >= 200 && status < 300)),
        ),
        cancelToken: _cancelToken,
      );
    } on DioException catch (e) {
      await onError(e, delete: true);
      return;
    }
    try {
      final data = response.data!;
      final statusCode = response.statusCode;
      if (statusCode == HttpStatus.requestedRangeNotSatisfiable) {
        await data.stream.drain<void>();
        final contentRange = response.headers.value(
          HttpHeaders.contentRangeHeader,
        );
        final remoteLength = int.tryParse(
          _unsatisfiedContentRangeRegExp
                  .firstMatch(contentRange ?? '')
                  ?.group(1) ??
              '',
        );
        if (remoteLength != received) {
          throw StateError(
            'Unexpected Content-Range length $remoteLength, expected $received',
          );
        }
        _status = DownloadStatus.completed;
        onDone();
        return;
      }

      if (statusCode == HttpStatus.partialContent) {
        final contentRange = response.headers.value(
          HttpHeaders.contentRangeHeader,
        );
        final rangeStart = int.tryParse(
          _contentRangeRegExp.firstMatch(contentRange ?? '')?.group(1) ?? '',
        );
        if (rangeStart != received) {
          await data.stream.drain<void>();
          throw StateError(
            'Unexpected Content-Range start $rangeStart, expected $received',
          );
        }
      } else if (statusCode == HttpStatus.ok && received != 0) {
        received = 0;
      } else if (statusCode != HttpStatus.ok) {
        await data.stream.drain<void>();
        throw StateError('Unexpected download status $statusCode');
      }

      final contentLength = data.contentLength + received;
      if (received == 0) {
        onReceiveProgress?.call(0, contentLength);
      }

      final output = file.openWrite(
        mode: received == 0 ? FileMode.writeOnly : FileMode.writeOnlyAppend,
      );
      sink = output;
      int? last;
      await for (final chunk in data.stream) {
        output.add(chunk);
        received += chunk.length;
        final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        if (last != now) {
          last = now;
          onReceiveProgress?.call(received, contentLength);
        }
      }
      await output.close();
      _status = DownloadStatus.completed;
      onDone();
    } catch (e) {
      await onError(e);
      return;
    }
  }

  @override
  Future<void> cancel({required bool isDelete}) {
    if (!isDelete && _status == DownloadStatus.downloading) {
      _status = DownloadStatus.pause;
    }
    if (!_cancelToken.isCancelled) {
      _cancelToken.cancel();
    }
    return task;
  }
}
