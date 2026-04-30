import 'dart:async';

import 'package:PiliPlus/http/browser_ua.dart';
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
          ? const BoxConstraints(maxWidth: 320, minWidth: 320)
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

enum CdnSelectResultType { builtIn, custom, clearCustom }

final class CdnSelectResult {
  final CdnSelectResultType type;
  final CDNService? service;
  final String? customCDNUrl;

  const CdnSelectResult._({
    required this.type,
    this.service,
    this.customCDNUrl,
  });

  const CdnSelectResult.builtIn(CDNService service)
    : this._(
        type: CdnSelectResultType.builtIn,
        service: service,
      );

  const CdnSelectResult.custom(String customCDNUrl)
    : this._(
        type: CdnSelectResultType.custom,
        customCDNUrl: customCDNUrl,
      );

  const CdnSelectResult.clearCustom()
    : this._(type: CdnSelectResultType.clearCustom);
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

  Future<void> _testAllCdnServices(BaseItem videoItem) async {
    for (final item in CDNService.values) {
      if (!mounted) break;
      await _testSingleCdn(item, videoItem);
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

    final cancelToken = _tokens[index];
    final start = DateTime.now().microsecondsSinceEpoch;

    void onClose() {
      cancelToken?.cancel();
      _tokens[index] = null;
    }

    await _dio.get(
      url,
      cancelToken: cancelToken,
      onReceiveProgress: (count, total) {
        if (!mounted) {
          return;
        }

        final duration = DateTime.now().microsecondsSinceEpoch - start;

        downloaded += count;

        if (duration > 15000000) {
          onClose();
          if (downloaded > 0) {
            _updateSpeedResult(index, downloaded, duration);
            downloaded = 0;
          } else {
            throw TimeoutException('测速超时');
          }
        } else if (downloaded >= maxSize) {
          onClose();
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
    final titleMedium = TextTheme.of(context).titleMedium!;
    final customHost = VideoUtils.normalizeCustomCDNHost(
      VideoUtils.customCDNUrl,
    );
    return AlertDialog(
      clipBehavior: Clip.hardEdge,
      title: const Text('CDN 设置'),
      constraints: _cdnSpeedTest
          ? const BoxConstraints(maxWidth: 320, minWidth: 320)
          : null,
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
      content: Material(
        type: .transparency,
        child: SingleChildScrollView(
          child: RadioGroup<CDNService>(
            onChanged: (v) {
              if (v == null) return;
              Navigator.of(context).pop(CdnSelectResult.builtIn(v));
            },
            groupValue: VideoUtils.cdnService,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...List.generate(
                  CDNService.values.length,
                  (index) {
                    final item = CDNService.values[index];
                    return RadioListTile<CDNService>(
                      dense: true,
                      value: item,
                      title: Text(
                        item.desc,
                        style: titleMedium,
                      ),
                      subtitle: _cdnSpeedTest
                          ? _CdnSpeedResultText(notifier: _cdnResList[index])
                          : null,
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.edit_outlined),
                  title: Text('自定义 CDN 节点', style: titleMedium),
                  subtitle: Text(
                    customHost ?? '未设置，点击输入 host 或 URL',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: customHost == null
                      ? null
                      : IconButton(
                          tooltip: '清除自定义 CDN',
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(
                            context,
                          ).pop(const CdnSelectResult.clearCustom()),
                        ),
                  onTap: () async {
                    final host = await _showCustomCdnDialog(
                      context,
                      customHost,
                    );
                    if (!context.mounted || host == null) return;
                    Navigator.of(context).pop(CdnSelectResult.custom(host));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> _showCustomCdnDialog(
    BuildContext context,
    String? initialValue,
  ) async {
    final controller = TextEditingController(text: initialValue ?? '');
    String? errorText;
    try {
      return await showDialog<String>(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: const Text('自定义 CDN 节点'),
            content: TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'upos-sz-mirrorali.bilivideo.com',
                errorText: errorText,
              ),
              onChanged: (_) {
                if (errorText == null) return;
                setDialogState(() => errorText = null);
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  '取消',
                  style: TextStyle(color: ColorScheme.of(context).outline),
                ),
              ),
              TextButton(
                onPressed: () {
                  final host = VideoUtils.normalizeCustomCDNHost(
                    controller.text,
                  );
                  if (host == null) {
                    setDialogState(() => errorText = '请输入有效的 host 或完整 URL');
                    return;
                  }
                  Navigator.of(context).pop(host);
                },
                child: const Text('确定'),
              ),
            ],
          ),
        ),
      );
    } finally {
      controller.dispose();
    }
  }
}

class _CdnSpeedResultText extends StatelessWidget {
  final ValueNotifier<String?> notifier;

  const _CdnSpeedResultText({required this.notifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifier,
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
}
