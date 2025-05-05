import 'dart:async';

import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/video/cdn_type.dart';
import 'package:PiliPlus/models/video/play/url.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/video_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SelectDialog<T> extends StatelessWidget {
  final T? value;
  final String title;
  final List<(T, String)> values;
  final Widget Function(BuildContext, int)? subtitleBuilder;

  const SelectDialog({
    super.key,
    this.value,
    required this.values,
    required this.title,
    this.subtitleBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      clipBehavior: Clip.hardEdge,
      title: Text(title),
      contentPadding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            values.length,
            (index) => RadioListTile<T>(
              dense: true,
              value: values[index].$1,
              title: Text(
                values[index].$2,
                style: Theme.of(context).textTheme.titleMedium!,
              ),
              subtitle: subtitleBuilder?.call(context, index),
              groupValue: value,
              onChanged: Navigator.of(context).pop,
            ),
          ),
        ),
      ),
    );
  }
}

class CdnSelectDialog extends StatefulWidget {
  final VideoItem? sample;

  const CdnSelectDialog({
    super.key,
    this.sample,
  });

  @override
  State<CdnSelectDialog> createState() => _CdnSelectDialogState();
}

class _CdnSelectDialogState extends State<CdnSelectDialog> {
  late final List<ValueNotifier<String?>> _cdnResList;
  late final CancelToken _cancelToken;
  bool _cdnSpeedTest = false;

  @override
  void initState() {
    _cdnSpeedTest = GStorage.cdnSpeedTest;
    if (_cdnSpeedTest) {
      _cdnResList = List.generate(
          CDNService.values.length, (_) => ValueNotifier<String?>(null));
      _cancelToken = CancelToken();
      _startSpeedTest();
    }
    super.initState();
  }

  @override
  void dispose() {
    if (_cdnSpeedTest) {
      _cancelToken.cancel();
      for (final notifier in _cdnResList) {
        notifier.dispose();
      }
    }
    super.dispose();
  }

  Future<VideoItem> _getSampleUrl() async {
    final result =
        await VideoHttp.videoUrl(cid: 196018899, bvid: 'BV1fK4y1t7hj');
    if (!result['status']) throw Exception('无法获取视频流');
    return result['data'].dash.video.first;
  }

  Future<void> _startSpeedTest() async {
    try {
      final videoItem = widget.sample ?? await _getSampleUrl();
      await _testAllCdnServices(videoItem);
    } catch (e) {
      debugPrint('CDN speed test failed: $e');
    }
  }

  Future<void> _testAllCdnServices(VideoItem videoItem) async {
    for (final item in CDNService.values) {
      if (!mounted) break;
      await _testSingleCdn(item, videoItem);
    }
  }

  Future<void> _testSingleCdn(CDNService item, VideoItem videoItem) async {
    try {
      final cdnUrl = VideoUtils.getCdnUrl(videoItem, item.code);
      await _measureDownloadSpeed(cdnUrl, item.index);
    } catch (e) {
      _handleSpeedTestError(e, item.index);
    }
  }

  Future<void> _measureDownloadSpeed(String url, int index) async {
    const maxSize = 8 * 1024 * 1024;
    int downloaded = 0;
    final dio = Dio()..options.headers['referer'] = HttpString.baseUrl;
    final start = DateTime.now().microsecondsSinceEpoch;

    await dio.get(
      url,
      cancelToken: _cancelToken,
      onReceiveProgress: (count, total) {
        if (!mounted) {
          dio.close(force: true);
          return;
        }
        final duration = DateTime.now().microsecondsSinceEpoch - start;

        downloaded += count;

        if (duration > 15000000) {
          dio.close(force: true);
          if (downloaded > 0) {
            _updateSpeedResult(index, downloaded, duration);
            downloaded = 0;
          } else {
            throw TimeoutException('测速超时');
          }
        } else if (downloaded >= maxSize) {
          dio.close(force: true);
          _updateSpeedResult(index, downloaded, duration);
          downloaded = 0;
        }
      },
    );
  }

  void _updateSpeedResult(int index, int downloaded, int duration) {
    final speed = (downloaded / duration).toStringAsPrecision(3);
    _cdnResList[index].value = '${speed}MB/s';
  }

  void _handleSpeedTestError(dynamic error, int index) {
    if (_cdnResList[index].value != null) return;

    debugPrint('CDN speed test error: $error');
    if (!mounted) return;
    var message = error.toString();
    if (message.isEmpty) {
      message = '测速失败';
    }
    _cdnResList[index].value = message;
  }

  @override
  Widget build(BuildContext context) {
    return SelectDialog<String>(
      title: 'CDN 设置',
      values: CDNService.values.map((i) => (i.code, i.description)).toList(),
      value: GStorage.defaultCDNService,
      subtitleBuilder: _cdnSpeedTest
          ? (context, index) => ValueListenableBuilder(
                valueListenable: _cdnResList[index],
                builder: (context, value, _) {
                  return Text(
                    _cdnResList[index].value ?? '---',
                    style: const TextStyle(fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  );
                },
              )
          : null,
    );
  }
}
