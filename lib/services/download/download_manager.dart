import 'dart:async';
import 'dart:io';

import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/services/download/download_resume.dart';
import 'package:PiliPlus/utils/extension/file_ext.dart';
import 'package:PiliPlus/utils/extension/string_ext.dart';
import 'package:dio/dio.dart';

class DownloadManager {
  final String url;
  final String path;
  final void Function(int, int)? onReceiveProgress;
  final void Function([Object? error]) onDone;

  DownloadStatus _status = DownloadStatus.downloading;

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
        await sink?.close();
      } catch (_) {}
      if (_status == DownloadStatus.downloading) {
        _status = DownloadStatus.failDownload;
        if (delete && file.existsSync()) {
          await file.tryDel();
        }
      }
      onDone(e);
    }

    Future<Response<ResponseBody>> request([int? rangeStart]) =>
        Request.http11Dio.get<ResponseBody>(
          url.http2https,
          options: Options(
            headers: {
              if (rangeStart != null) 'range': 'bytes=$rangeStart-',
            },
            responseType: ResponseType.stream,
            validateStatus: (status) =>
                status == 200 || status == 206 || status == 416,
          ),
          cancelToken: _cancelToken,
        );

    try {
      var response = await request(received);
      var data = response.data;
      if (data == null) {
        throw StateError('Download response has no body');
      }
      var plan = DownloadResumePolicy.fromResponse(
        statusCode: response.statusCode!,
        localLength: received,
        contentLength: data.contentLength,
        contentRange: response.headers.value('content-range'),
      );

      if (plan.mode == DownloadWriteMode.retryWithoutRange) {
        await data.stream.drain<void>();
        response = await request();
        data = response.data;
        if (data == null) {
          throw StateError('Download retry response has no body');
        }
        plan = DownloadResumePolicy.fromResponse(
          statusCode: response.statusCode!,
          localLength: 0,
          contentLength: data.contentLength,
          contentRange: response.headers.value('content-range'),
        );
        if (plan.mode == DownloadWriteMode.retryWithoutRange) {
          throw StateError('Server rejected a full download request');
        }
      }

      if (plan.mode == DownloadWriteMode.complete) {
        await data.stream.drain<void>();
        plan.validateCompletedLength(received);
        onReceiveProgress?.call(received, plan.expectedLength ?? 0);
        _status = DownloadStatus.completed;
        onDone();
        return;
      }

      if (plan.mode == DownloadWriteMode.overwrite) {
        received = 0;
      }
      sink = file.openWrite(
        mode: plan.mode == DownloadWriteMode.append
            ? FileMode.writeOnlyAppend
            : FileMode.writeOnly,
      );
      final contentLength = plan.expectedLength ?? 0;
      if (received == 0) {
        onReceiveProgress?.call(0, contentLength);
      }

      int? last;
      await for (final chunk in data.stream) {
        sink.add(chunk);
        received += chunk.length;
        final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        if (last != now) {
          last = now;
          onReceiveProgress?.call(received, contentLength);
        }
      }
      await sink.close();
      sink = null;
      plan.validateCompletedLength(received);
      onReceiveProgress?.call(received, contentLength);
      _status = DownloadStatus.completed;
      onDone();
    } catch (e) {
      await onError(e, delete: e is FormatException);
      return;
    }
  }

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
