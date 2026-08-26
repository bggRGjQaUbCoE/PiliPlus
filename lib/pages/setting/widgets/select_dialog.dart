import 'dart:async';

import 'package:PiliPlus/http/browser_ua.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/video/cdn_type.dart';
import 'package:PiliPlus/models/common/video/video_type.dart';
import 'package:PiliPlus/models/video/play/url.dart';
import 'package:PiliPlus/utils/connectivity_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/video_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:material_ui/material_ui.dart';

class SelectDialog<T> extends StatelessWidget {
  final T? value;
  final String title;
  final List<(T, String)> values;
  final Widget Function(BuildContext, int)? subtitleBuilder;
  final bool toggleable;

  const SelectDialog({
    super.key,
    this.value,
    required this.values,
    required this.title,
    this.subtitleBuilder,
    this.toggleable = false,
  });

  @override
  Widget build(BuildContext context) {
    final titleMedium = TextTheme.of(context).titleMedium!;
    return AlertDialog(
      clipBehavior: Clip.hardEdge,
      title: Text(title),
      constraints: subtitleBuilder != null
          ? const BoxConstraints.tightFor(width: 320)
          : null,
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
      content: Material(
        type: MaterialType.transparency,
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
  late final List<ValueNotifier<String?>> _cdnResList;
  late final List<CancelToken?> _tokens;
  late final bool _cdnSpeedTest;

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
        (_) => ValueNotifier<String?>(null),
      );
      _tokens = List.filled(length, null);
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
      tryLook: false,
      videoType: VideoType.ugc,
    );
    final item = result.dataOrNull?.dash?.video?.first;
    if (item == null) throw Exception('无法获取视频流');
    return item;
  }

  Future<void> _startSpeedTest() async {
    try {
      final limits =
          (await ConnectivityUtils.resolveForPlayback())
              .useCellularPreferences
          ? (warmup: 4194304, max: 16777216)
          : (warmup: 8388608, max: 67108864);
      final videoItem = widget.sample ?? await _getSampleUrl();
      await _testAllCdnServices(videoItem, limits);
    } catch (e) {
      if (kDebugMode) debugPrint('CDN speed test failed: $e');
    }
  }

  Future<void> _testAllCdnServices(
    BaseItem videoItem,
    ({int warmup, int max}) limits,
  ) async {
    for (final item in CDNService.values) {
      if (!mounted) break;
      await _testSingleCdn(item, videoItem, limits);
    }
  }

  Future<void> _testSingleCdn(
    CDNService item,
    BaseItem videoItem,
    ({int warmup, int max}) limits,
  ) async {
    try {
      final cdnUrl = VideoUtils.getCdnUrl(
        videoItem.playUrls,
        defaultCDNService: item,
      );
      await _measureDownloadSpeed(cdnUrl, item.index, limits);
    } catch (e) {
      _handleSpeedTestError(e, item.index);
    }
  }

  late final Dio _dio;

  Future<void> _measureDownloadSpeed(
    String url,
    int index,
    ({int warmup, int max}) limits,
  ) async {
    _CdnSpeedSample sample;
    try {
      sample = await _measureStream(url, index, limits);
    } catch (e) {
      if (!mounted) return;
      if (kDebugMode) debugPrint('CDN stream speed test failed: $e');
      sample = await _measureLegacy(url, index, limits);
    }
    if (mounted) _updateSpeedResult(index, sample);
  }

  CancelToken _newToken(int index) {
    final token = CancelToken();
    _tokens[index]?.cancel();
    _tokens[index] = token;
    return token;
  }

  Future<_CdnSpeedSample> _measureStream(
    String url,
    int index,
    ({int warmup, int max}) limits,
  ) async {
    final token = _newToken(index);
    final watch = Stopwatch()..start();
    Timer? measureTimer;
    var intentionalStop = false;
    var downloaded = 0;
    int? firstByteUs;
    int? sampleStartUs;
    var sampleStartBytes = 0;

    final totalTimer = Timer(const Duration(seconds: 15), () {
      intentionalStop = true;
      token.cancel();
    });

    try {
      final response = await _dio.get<ResponseBody>(
        url,
        cancelToken: token,
        options: Options(
          headers: {'range': 'bytes=0-${limits.max - 1}'},
          responseType: ResponseType.stream,
          receiveTimeout: Duration.zero,
          validateStatus: (status) => status == 200 || status == 206,
        ),
      );
      final stream = response.data?.stream;
      if (stream == null) throw StateError('测速响应为空');

      await for (final chunk in stream) {
        if (chunk.isEmpty) continue;
        final now = watch.elapsedMicroseconds;
        firstByteUs ??= now;
        final total = downloaded + chunk.length;
        downloaded = total > limits.max ? limits.max : total;

        if (sampleStartUs == null && downloaded >= limits.warmup) {
          sampleStartUs = now;
          sampleStartBytes = downloaded;
          measureTimer = Timer(const Duration(seconds: 8), () {
            intentionalStop = true;
            token.cancel();
          });
        }
        if (downloaded >= limits.max) break;
      }
    } on DioException {
      if (!intentionalStop) rethrow;
    } finally {
      totalTimer.cancel();
      measureTimer?.cancel();
      if (identical(_tokens[index], token)) _tokens[index] = null;
    }

    return _buildSample(
      watch: watch,
      downloaded: downloaded,
      firstByteUs: firstByteUs,
      sampleStartUs: sampleStartUs,
      sampleStartBytes: sampleStartBytes,
      type: downloaded >= limits.max
          ? _CdnSpeedSampleType.complete
          : _CdnSpeedSampleType.partial,
    );
  }

  Future<_CdnSpeedSample> _measureLegacy(
    String url,
    int index,
    ({int warmup, int max}) limits,
  ) async {
    final token = _newToken(index);
    final watch = Stopwatch()..start();
    Timer? measureTimer;
    var intentionalStop = false;
    var downloaded = 0;
    int? firstByteUs;
    int? sampleStartUs;
    var sampleStartBytes = 0;

    final totalTimer = Timer(const Duration(seconds: 15), () {
      intentionalStop = true;
      token.cancel();
    });

    try {
      await _dio.get(
        url,
        cancelToken: token,
        onReceiveProgress: (count, _) {
          if (count <= 0 || intentionalStop) return;
          final now = watch.elapsedMicroseconds;
          firstByteUs ??= now;
          downloaded = count > limits.max ? limits.max : count;

          if (sampleStartUs == null && downloaded >= limits.warmup) {
            sampleStartUs = now;
            sampleStartBytes = downloaded;
            measureTimer = Timer(const Duration(seconds: 8), () {
              intentionalStop = true;
              token.cancel();
            });
          }
          if (downloaded >= limits.max) {
            intentionalStop = true;
            token.cancel();
          }
        },
      );
    } on DioException {
      if (!intentionalStop) rethrow;
    } finally {
      totalTimer.cancel();
      measureTimer?.cancel();
      if (identical(_tokens[index], token)) _tokens[index] = null;
    }

    return _buildSample(
      watch: watch,
      downloaded: downloaded,
      firstByteUs: firstByteUs,
      sampleStartUs: sampleStartUs,
      sampleStartBytes: sampleStartBytes,
      type: _CdnSpeedSampleType.fallback,
    );
  }

  _CdnSpeedSample _buildSample({
    required Stopwatch watch,
    required int downloaded,
    required int? firstByteUs,
    required int? sampleStartUs,
    required int sampleStartBytes,
    required _CdnSpeedSampleType type,
  }) {
    watch.stop();
    if (downloaded <= 0 || firstByteUs == null) {
      throw TimeoutException('测速超时');
    }

    var bytes = downloaded - sampleStartBytes;
    var startUs = sampleStartUs;
    if (bytes <= 0 || startUs == null) {
      bytes = downloaded;
      startUs = firstByteUs;
    }
    final elapsedUs = watch.elapsedMicroseconds - startUs;
    return (
      bytes: bytes,
      elapsedUs: elapsedUs > 0 ? elapsedUs : 1,
      firstByteUs: firstByteUs,
      type: type,
    );
  }

  void _updateSpeedResult(int index, _CdnSpeedSample sample) {
    final isFallback = sample.type == _CdnSpeedSampleType.fallback;
    final divisor = isFallback ? 1000 * 1000 : 1024 * 1024;
    final speed =
        sample.bytes *
        Duration.microsecondsPerSecond /
        sample.elapsedUs /
        divisor;
    final unit = switch (sample.type) {
      _CdnSpeedSampleType.complete => 'MiB/s',
      _CdnSpeedSampleType.partial => 'M/s',
      _CdnSpeedSampleType.fallback => 'MB/s',
    };
    final firstByteMs = sample.firstByteUs / 1000;
    _cdnResList[index].value =
        '${speed.toStringAsPrecision(3)} $unit · 首包 ${firstByteMs.toStringAsPrecision(3)}ms';
  }

  void _handleSpeedTestError(dynamic error, int index) {
    _tokens
      ..[index]?.cancel()
      ..[index] = null;
    final item = _cdnResList[index];
    if (item.value != null) return;

    if (kDebugMode) debugPrint('CDN speed test error: $error');
    if (!mounted) return;
    String message;
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      if (statusCode != null && 400 <= statusCode && statusCode < 500) {
        message = '此视频可能无法替换为该CDN';
      } else {
        message = error.toString();
      }
    } else {
      message = error.toString();
    }
    if (message.isEmpty) {
      message = '测速失败';
    }
    item.value = message;
  }

  @override
  Widget build(BuildContext context) {
    return SelectDialog<CDNService>(
      title: 'CDN 设置',
      values: CDNService.values.map((i) => (i, i.desc)).toList(),
      value: VideoUtils.cdnService,
      subtitleBuilder: _cdnSpeedTest
          ? (context, index) {
              final item = _cdnResList[index];
              return ValueListenableBuilder(
                valueListenable: item,
                builder: (context, value, _) {
                  return Text(
                    value ?? '---',
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

enum _CdnSpeedSampleType { complete, partial, fallback }

typedef _CdnSpeedSample = ({
  int bytes,
  int elapsedUs,
  int firstByteUs,
  _CdnSpeedSampleType type,
});
