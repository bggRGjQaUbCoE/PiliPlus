import 'dart:async';

import 'package:PiliPlus/http/browser_ua.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/video/cdn_type.dart';
import 'package:PiliPlus/models/common/video/video_quality.dart';
import 'package:PiliPlus/models/common/video/video_type.dart';
import 'package:PiliPlus/models/video/play/url.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/video_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:material_ui/material_ui.dart';

class SelectDialog<T> extends StatelessWidget {
  final T? value;
  final String title;
  final Widget? titleBottom;
  final List<(T, String)> values;
  final Widget Function(BuildContext, int)? subtitleBuilder;
  final bool toggleable;

  const SelectDialog({
    super.key,
    this.value,
    required this.values,
    required this.title,
    this.titleBottom,
    this.subtitleBuilder,
    this.toggleable = false,
  });

  @override
  Widget build(BuildContext context) {
    final titleMedium = TextTheme.of(context).titleMedium!;
    return AlertDialog(
      clipBehavior: Clip.hardEdge,
      title: titleBottom == null
          ? Text(title)
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(title), titleBottom!],
            ),
      constraints: subtitleBuilder != null
          ? const BoxConstraints.tightFor(width: 320)
          : null,
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
      content: Material(
        type: .transparency,
        child: SingleChildScrollView(
          child: RadioGroup<T>(
            onChanged: (v) => Navigator.of(context).pop(v ?? value),
            groupValue: value,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                values.length,
                (index) {
                  final item = values[index];
                  return RadioListTile<T>(
                    toggleable: toggleable,
                    dense: true,
                    value: item.$1,
                    title: Text(
                      item.$2,
                      style: titleMedium,
                    ),
                    subtitle: subtitleBuilder?.call(context, index),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CdnSelectDialog extends StatefulWidget {
  final BaseItem? sample;

  const CdnSelectDialog({
    super.key,
    this.sample,
  });

  @override
  State<CdnSelectDialog> createState() => _CdnSelectDialogState();
}

class _CdnSelectDialogState extends State<CdnSelectDialog> {
  late final List<ValueNotifier<String>> _cdnResList;
  late final List<CancelToken?> _tokens;
  late final bool _cdnSpeedTest;
  int _completed = 0;
  CDNService? _testingCdn;
  bool _sampleFailed = false;

  @override
  void initState() {
    _cdnSpeedTest = Pref.cdnSpeedTest;
    if (_cdnSpeedTest) {
      _dio =
          Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 15),
              ),
            )
            ..options.headers = {
              'user-agent': BrowserUa.pc,
              'referer': HttpString.baseUrl,
            };
      final length = CDNService.values.length;
      _cdnResList = List.generate(
        length,
        (_) => ValueNotifier('等待测速'),
      );
      _tokens = List.generate(length, (_) => CancelToken());
      _startSpeedTest();
    }
    super.initState();
  }

  @override
  void dispose() {
    if (_cdnSpeedTest) {
      for (final e in _tokens) {
        e?.cancel();
      }
      for (final notifier in _cdnResList) {
        notifier.dispose();
      }
      _dio.close(force: true);
    }
    super.dispose();
  }

  Future<BaseItem> _getSampleUrl() async {
    final result = await VideoHttp.videoUrl(
      cid: 196018899,
      bvid: 'BV1fK4y1t7hj',
      qn: VideoQuality.high1080.code,
      tryLook: false,
      videoType: VideoType.ugc,
    );
    final item = result.dataOrNull?.dash?.video?.first;
    if (item == null) throw Exception('无法获取视频流');
    return item;
  }

  Future<void> _startSpeedTest() async {
    try {
      final videoItem = widget.sample ?? await _getSampleUrl();
      await _testAllCdnServices(videoItem);
    } catch (e) {
      if (kDebugMode) debugPrint('CDN speed test failed: $e');
      if (!mounted) return;
      for (final notifier in _cdnResList) {
        notifier.value = '未测速：无法获取视频流';
      }
      setState(() => _sampleFailed = true);
    }
  }

  Future<void> _testAllCdnServices(BaseItem videoItem) async {
    for (final item in CDNService.values) {
      if (!mounted) break;
      setState(() => _testingCdn = item);
      _cdnResList[item.index].value = '测速中…';
      await _testSingleCdn(item, videoItem);
      if (!mounted) break;
      setState(() {
        _completed++;
        _testingCdn = null;
      });
    }
  }

  Future<void> _testSingleCdn(CDNService item, BaseItem videoItem) async {
    try {
      final cdnUrl = VideoUtils.getCdnUrl(
        videoItem.playUrls,
        defaultCDNService: item,
      );
      await _measureDownloadSpeed(cdnUrl, item.index);
    } catch (e) {
      _handleSpeedTestError(e, item.index);
    }
  }

  late final Dio _dio;

  Future<void> _measureDownloadSpeed(String url, int index) async {
    const maxSize = 8 * 1024 * 1024;
    int downloaded = 0;
    bool sampleComplete = false;

    final cancelToken = _tokens[index];
    final stopwatch = Stopwatch()..start();

    try {
      await _dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
        cancelToken: cancelToken,
        onReceiveProgress: (count, total) {
          if (!mounted || sampleComplete) return;
          downloaded = count;
          final duration = stopwatch.elapsedMicroseconds;
          if (duration > 15000000 || downloaded >= maxSize) {
            if (downloaded == 0) throw TimeoutException('测速超时');
            _updateSpeedResult(index, downloaded, duration);
            sampleComplete = true;
            cancelToken?.cancel();
          }
        },
      );
      if (!mounted || sampleComplete) return;
      if (downloaded == 0) throw StateError('未收到视频数据');
      _updateSpeedResult(index, downloaded, stopwatch.elapsedMicroseconds);
    } on DioException catch (e) {
      if (!sampleComplete || !CancelToken.isCancel(e)) rethrow;
    } finally {
      stopwatch.stop();
      cancelToken?.cancel();
      _tokens[index] = null;
    }
  }

  void _updateSpeedResult(int index, int downloaded, int duration) {
    final speed = (downloaded / (duration > 0 ? duration : 1))
        .toStringAsPrecision(3);
    _cdnResList[index].value = '${speed}MB/s';
  }

  void _handleSpeedTestError(dynamic error, int index) {
    _tokens
      ..[index]?.cancel()
      ..[index] = null;
    if (kDebugMode) debugPrint('CDN speed test error: $error');
    if (!mounted) return;
    String message;
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      if (statusCode != null && 400 <= statusCode && statusCode < 500) {
        message = '测速失败：此视频可能无法替换为该CDN';
      } else {
        message = switch (error.type) {
          DioExceptionType.connectionTimeout ||
          DioExceptionType.sendTimeout ||
          DioExceptionType.receiveTimeout => '测速超时',
          _ => '测速失败',
        };
      }
    } else {
      message = error is TimeoutException ? '测速超时' : '测速失败';
    }
    _cdnResList[index].value = message;
  }

  @override
  Widget build(BuildContext context) {
    return SelectDialog<CDNService>(
      title: 'CDN 设置',
      titleBottom: _cdnSpeedTest
          ? Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _sampleFailed
                        ? '无法开始测速：获取视频流失败'
                        : _completed == CDNService.values.length
                        ? '测速完成（$_completed / ${CDNService.values.length}）'
                        : '已完成 $_completed / ${CDNService.values.length}',
                    style: TextTheme.of(context).bodyMedium,
                  ),
                  if (!_sampleFailed) ...[
                    if (_completed < CDNService.values.length)
                      Text(
                        _testingCdn == null
                            ? '获取测速视频…'
                            : '正在测速：${_testingCdn!.desc}',
                        style: TextTheme.of(context).bodySmall,
                      ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: _completed / CDNService.values.length,
                      semanticsLabel: 'CDN 测速进度',
                    ),
                  ],
                ],
              ),
            )
          : null,
      values: CDNService.values.map((i) => (i, i.desc)).toList(),
      value: VideoUtils.cdnService,
      subtitleBuilder: _cdnSpeedTest
          ? (context, index) {
              final item = _cdnResList[index];
              return ValueListenableBuilder(
                valueListenable: item,
                builder: (context, value, _) {
                  return Text(
                    value,
                    style: const TextStyle(fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  );
                },
              );
            }
          : null,
    );
  }
}
