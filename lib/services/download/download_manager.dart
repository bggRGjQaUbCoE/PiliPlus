import 'dart:async';
import 'dart:io';

import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/utils/extension/file_ext.dart';
import 'package:PiliPlus/utils/extension/string_ext.dart';
import 'package:dio/dio.dart';

enum DownloadRangeAction { write, complete, restart }

DownloadRangeAction downloadRangeAction({
  required int? statusCode,
  required int received,
  required int? resourceSize,
}) {
  if (statusCode != 416) {
    return DownloadRangeAction.write;
  }
  if (resourceSize != null && received == resourceSize && received > 0) {
    return DownloadRangeAction.complete;
  }
  return DownloadRangeAction.restart;
}

int? contentRangeSize(String? header) {
  if (header == null || header.isEmpty) return null;
  final slash = header.lastIndexOf('/');
  if (slash < 0 || slash == header.length - 1) return null;
  final total = header.substring(slash + 1).trim();
  if (total == '*') return null;
  return int.tryParse(total);
}

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

    final sink = file.openWrite(
      mode: received == 0 ? FileMode.writeOnly : FileMode.writeOnlyAppend,
    );

    Future<void> onError(Object e, {bool delete = false}) async {
      try {
        await sink.close();
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
    final data = response.data!;
    if (response.statusCode == 416) {
      final resourceSize = contentRangeSize(
        response.headers.value(HttpHeaders.contentRangeHeader),
      );
      await data.stream.drain<void>();
      switch (downloadRangeAction(
        statusCode: response.statusCode,
        received: received,
        resourceSize: resourceSize,
      )) {
        case DownloadRangeAction.complete:
          await sink.close();
          _status = DownloadStatus.completed;
          onDone();
        case DownloadRangeAction.restart:
          await onError(const HttpException('HTTP 416'), delete: true);
        case DownloadRangeAction.write:
          await onError(const HttpException('HTTP 416'), delete: true);
      }
      return;
    }
    final contentLength = data.contentLength + received;

    if (received == 0) {
      onReceiveProgress?.call(0, contentLength);
    }

    int? last;
    try {
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
      _status = DownloadStatus.completed;
      onDone();
    } catch (e) {
      await onError(e);
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
