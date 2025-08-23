import 'dart:async';

import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/video/cdn_type.dart';
import 'package:PiliPlus/models/common/video/video_type.dart';
import 'package:PiliPlus/models/video/play/url.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/video_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
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
    final titleMedium = Theme.of(context).textTheme.titleMedium!;
    return AlertDialog(
      clipBehavior: Clip.hardEdge,
      title: Text(title),
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            values.length,
            (index) {
              final item = values[index];
              return RadioListTile<T>(
                dense: true,
                value: item.$1,
                title: Text(
                  item.$2,
                  style: titleMedium,
                ),
                subtitle: subtitleBuilder?.call(context, index),
                groupValue: value,
                onChanged: Navigator.of(context).pop,
              );
            },
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
  late final bool _cdnSpeedTest;

  @override
  void initState() {
    _cdnSpeedTest = Pref.cdnSpeedTest;
    if (_cdnSpeedTest) {
      _cdnResList = List.generate(
        CDNService.values.length,
        (_) => ValueNotifier<String?>(null),
      );
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
      final videoItem = widget.sample ?? await _getSampleUrl();
      await _testAllCdnServices(videoItem);
    } catch (e) {
      if (kDebugMode) debugPrint('CDN speed test failed: $e');
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

  void _handleSpeedTestError(Object error, int index) {
    final item = _cdnResList[index];
    if (item.value != null) return;

    if (kDebugMode) debugPrint('CDN speed test error: $error');
    if (!mounted) return;
    var message = error.toString();
    if (message.isEmpty) {
      message = '测速失败';
    }
    item.value = message;
  }

  @override
  Widget build(BuildContext context) {
    return SelectDialog<String>(
      title: 'CDN 设置',
      values: CDNService.values.map((i) => (i.code, i.desc)).toList(),
      value: VideoUtils.cdnService,
      subtitleBuilder: _cdnSpeedTest
          ? (context, index) {
              final item = _cdnResList[index];
              return ValueListenableBuilder(
                valueListenable: item,
                builder: (context, value, _) {
                  return Text(
                    item.value ?? '---',
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
