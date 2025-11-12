import 'dart:async';
import 'dart:io';

import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:dio/dio.dart';

class DownloadManager {
  final String url;
  final String path;
  final void Function(int, int)? onReceiveProgress;
  final void Function([Object? error]) onDone;

  DownloadStatus _status = DownloadStatus.wait;
  DownloadStatus get status => _status;
  CancelToken? _cancelToken;
  Completer<void>? _completer;

  DownloadManager({
    required this.url,
    required this.path,
    required this.onReceiveProgress,
    required this.onDone,
  });

  Future<void> start() async {
    _cancelToken = CancelToken();
    _completer = Completer();
    _status = DownloadStatus.downloading;

    int received;

    final file = File(path);
    try {
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
        response = await Request.dio.get<ResponseBody>(
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

      if (received == 0) {
        onReceiveProgress?.call(0, data.contentLength);
      }

      try {
        await for (final chunk in data.stream) {
          sink.add(chunk);
          received += chunk.length;
          onReceiveProgress?.call(
            received,
            data.contentLength,
          );
        }
        await sink.close();
        _status = DownloadStatus.completed;
        onDone();
      } catch (e) {
        await onError(e);
        return;
      }
    } finally {
      _completer?.complete();
    }
  }

  Future<void>? cancel({required bool isDelete}) {
    if (!isDelete && _status == DownloadStatus.downloading) {
      _status = DownloadStatus.pause;
    }
    if (_cancelToken != null) {
      _cancelToken!.cancel();
      _cancelToken = null;
    }
    return _completer?.future;
  }
}
