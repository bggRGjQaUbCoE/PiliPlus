import 'dart:async';

import 'package:PiliPlus/http/browser_ua.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/video/cdn_type.dart';
import 'package:PiliPlus/models/common/video/video_quality.dart';
import 'package:PiliPlus/models/common/video/video_type.dart';
import 'package:PiliPlus/models/video/play/url.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
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
  late final List<ValueNotifier<String?>> _cdnResList;
  late final List<CancelToken?> _tokens;
  late final bool _cdnSpeedTest;
  StreamSubscription<dynamic>? _parallelLoadingSubscription;

  @override
  void initState() {
    _cdnSpeedTest = !Pref.cdnAutoSelect && Pref.cdnSpeedTest;
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
      _tokens = List.generate(length, (_) => CancelToken());
      _startSpeedTest();
    }
    _parallelLoadingSubscription = GStorage.setting
        .watch(key: SettingBoxKey.cdnAutoSelect)
        .listen((_) {
          if (Pref.cdnAutoSelect && _cdnSpeedTest) {
            for (final token in _tokens) {
              token?.cancel();
            }
          }
          if (mounted) setState(() {});
        });
    super.initState();
  }

  @override
  void dispose() {
    _parallelLoadingSubscription?.cancel();
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
    if (Pref.cdnAutoSelect) return;
    try {
      final videoItem = widget.sample ?? await _getSampleUrl();
      await _testAllCdnServices(videoItem);
    } catch (e) {
      if (kDebugMode) debugPrint('CDN speed test failed: $e');
    }
  }

  Future<void> _testAllCdnServices(BaseItem videoItem) async {
    for (final item in CDNService.values) {
      if (!mounted || Pref.cdnAutoSelect) break;
      await _testSingleCdn(item, videoItem);
    }
  }

  Future<void> _testSingleCdn(CDNService item, BaseItem videoItem) async {
    if (!mounted || Pref.cdnAutoSelect) return;
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
    const piece = 1024 * 1024;
    final rates = <double>[];
    var totalBytes = 0;
    final whole = Stopwatch()..start();
    double? firstBlock;
    // Three consecutive ranges of this representation. Include request setup
    // and first-byte wait; report the slowest window instead of a burst peak.
    for (var sample = 0; sample < 3; sample++) {
      final watch = Stopwatch()..start();
      final response = await _dio.get<ResponseBody>(
        url,
        options: Options(
          responseType: ResponseType.stream,
          headers: {
            'Range': 'bytes=${sample * piece}-${(sample + 1) * piece - 1}',
            'Accept-Encoding': 'identity',
          },
        ),
        cancelToken: _tokens[index],
      );
      final match = RegExp(r'^bytes (\d+)-(\d+)/(\d+)$')
          .firstMatch(response.headers.value('content-range') ?? '');
      if (response.statusCode != 206 ||
          match == null ||
          int.parse(match[1]!) != sample * piece) {
        _tokens[index]?.cancel();
        throw const FormatException('此来源不支持有效的分段测速');
      }
      final expected = int.parse(match[2]!) - int.parse(match[1]!) + 1;
      var bytes = 0;
      await for (final block in response.data!.stream.timeout(
        const Duration(seconds: 6),
      )) {
        if (!mounted || Pref.cdnAutoSelect || whole.elapsed.inSeconds >= 15) {
          _tokens[index]?.cancel();
          throw TimeoutException('测速超时');
        }
        firstBlock ??= whole.elapsedMicroseconds / 1e6;
        bytes += block.length;
        if (bytes > piece) {
          _tokens[index]?.cancel();
          throw const FormatException('来源未遵守分段长度');
        }
      }
      if (bytes != expected || bytes == 0) {
        throw const FormatException('分段未完整返回');
      }
      rates.add(bytes / (watch.elapsedMicroseconds / 1e6) / (1024 * 1024));
      totalBytes += bytes;
      if (int.parse(match[2]!) + 1 >= int.parse(match[3]!)) break;
    }
    if (!mounted || Pref.cdnAutoSelect) return;
    rates.sort();
    final mean = totalBytes / (whole.elapsedMicroseconds / 1e6) / (1024 * 1024);
    _cdnResList[index].value =
        '均速 ${mean.toStringAsFixed(2)} MiB/s · 最慢段 ${rates.first.toStringAsFixed(2)} MiB/s\n'
        '首包 ${firstBlock?.toStringAsFixed(2) ?? "未知"} 秒 · ${widget.sample == null ? "固定样片，仅供参考" : "当前视频抽样"}';
  }

  void _handleSpeedTestError(dynamic error, int index) {
    if (!mounted || Pref.cdnAutoSelect) return;
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
    if (Pref.cdnAutoSelect) {
      return AlertDialog(
        title: const Text('CDN 设置已停用'),
        content: const Text(
          '自动选源已接管视频与音频。关闭自动选择 CDN 后恢复手动设置。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      );
    }
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
