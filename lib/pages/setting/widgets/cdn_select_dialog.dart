import 'package:PiliPlus/http/browser_ua.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/video/cdn_type.dart';
import 'package:PiliPlus/models/common/video/video_quality.dart';
import 'package:PiliPlus/models/common/video/video_type.dart';
import 'package:PiliPlus/models/video/play/url.dart';
import 'package:PiliPlus/pages/setting/widgets/cdn_node_dialog.dart';
import 'package:PiliPlus/utils/cdn_node_store.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/video_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;
import 'package:material_ui/material_ui.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

sealed class CdnSelectResult {
  const CdnSelectResult();
}

final class CdnBuiltinResult extends CdnSelectResult {
  const CdnBuiltinResult(this.service);

  final CDNService service;
}

final class CdnCustomResult extends CdnSelectResult {
  const CdnCustomResult(this.host);

  final String host;
}

final class CdnClearCustomResult extends CdnSelectResult {
  const CdnClearCustomResult();
}

/// 保存 CDN 选择的唯一入口：写存储、同步运行时静态变量、toast
Future<void> applyCdnSelectResult(
  CdnSelectResult result, {
  String toastSuffix = '',
}) async {
  switch (result) {
    case CdnBuiltinResult(:final service):
      VideoUtils.cdnService = service;
      VideoUtils.customCDNUrl = null;
      await GStorage.setting.put(SettingBoxKey.CDNService, service.name);
      await GStorage.setting.delete(SettingBoxKey.customCDNUrl);
      SmartDialog.showToast('已设置为 ${service.desc}$toastSuffix');
    case CdnCustomResult(:final host):
      VideoUtils.customCDNUrl = host;
      await GStorage.setting.put(SettingBoxKey.customCDNUrl, host);
      SmartDialog.showToast('已设置自定义 CDN：$host$toastSuffix');
    case CdnClearCustomResult():
      VideoUtils.customCDNUrl = null;
      await GStorage.setting.delete(SettingBoxKey.customCDNUrl);
      SmartDialog.showToast('已清除自定义 CDN$toastSuffix');
  }
}

/// 下载测速，供内置枚举全量测速与节点点按测速复用
class CdnSpeedTester {
  CdnSpeedTester({this.sample});

  BaseItem? sample;
  Dio? _dio;
  final List<CancelToken> _tokens = [];

  Dio get dio => _dio ??= Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'user-agent': BrowserUa.pc,
        'referer': HttpString.baseUrl,
      },
    ),
  );

  Future<BaseItem> getSample() async {
    if (sample case final sample?) {
      return sample;
    }
    final result = await VideoHttp.videoUrl(
      cid: 196018899,
      bvid: 'BV1fK4y1t7hj',
      qn: VideoQuality.high1080.code,
      tryLook: false,
      videoType: VideoType.ugc,
    );
    final item = result.dataOrNull?.dash?.video?.first;
    if (item == null) throw Exception('无法获取视频流');
    return sample = item;
  }

  /// 从首包到达开始计时（剔除建连与首字节耗时），下载 2MB 或 5s 即出结果
  Future<String> measure(String url) async {
    const maxSize = 2 * 1024 * 1024;
    const maxDuration = 5000000;
    final token = CancelToken();
    _tokens.add(token);
    int received = 0;
    int baseline = 0;
    int? dataStart;
    String? result;
    final requestStart = DateTime.now().microsecondsSinceEpoch;
    String format(int bytes, int duration) =>
        '${(bytes / duration).toStringAsPrecision(3)}MB/s';
    // 首包后无增量（如单包完成）时退回全程计时
    String? snapshot() {
      final now = DateTime.now().microsecondsSinceEpoch;
      final bytes = received - baseline;
      if (bytes > 0 && dataStart != null && now > dataStart!) {
        return format(bytes, now - dataStart!);
      }
      if (received > 0 && now > requestStart) {
        return format(received, now - requestStart);
      }
      return null;
    }

    try {
      await dio.get(
        url,
        cancelToken: token,
        onReceiveProgress: (count, total) {
          if (dataStart == null) {
            dataStart = DateTime.now().microsecondsSinceEpoch;
            baseline = count;
            received = count;
            return;
          }
          received = count;
          if (count - baseline >= maxSize ||
              DateTime.now().microsecondsSinceEpoch - dataStart! >
                  maxDuration) {
            result ??= snapshot();
            token.cancel();
          }
        },
      );
      result ??= snapshot() ?? '测速失败';
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        result ??= '测速超时';
      } else {
        result ??= _describeError(e);
      }
    } catch (e) {
      result ??= e.toString();
    } finally {
      _tokens.remove(token);
    }
    return result!;
  }

  String _describeError(DioException error) {
    final statusCode = error.response?.statusCode;
    if (statusCode != null && 400 <= statusCode && statusCode < 500) {
      return '此视频可能无法替换为该CDN';
    }
    final message = error.toString();
    return message.isEmpty ? '测速失败' : message;
  }

  void dispose() {
    for (final token in List.of(_tokens)) {
      token.cancel();
    }
    _tokens.clear();
    _dio?.close(force: true);
  }
}

/// CDN 对话框共用列表项：选项使用 radio 明确单选状态，选中项使用强调色。
class M3eOptionItem extends StatelessWidget {
  const M3eOptionItem({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.selected = false,
    this.selectionControl = false,
    this.onTap,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool selected;
  final bool selectionControl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    final textTheme = TextTheme.of(context);
    final foreground = selected
        ? colorScheme.onSecondaryContainer
        : colorScheme.onSurface;
    final secondary = selected
        ? colorScheme.onSecondaryContainer
        : colorScheme.onSurfaceVariant;
    final effectiveLeading = leading ??
        (selectionControl
            ? Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
              )
            : null);
    return Material(
      color: selected ? colorScheme.secondaryContainer : Colors.transparent,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: subtitle == null ? 56 : 72,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                if (effectiveLeading case final effectiveLeading?) ...[
                  IconTheme(
                    data: IconThemeData(size: 20, color: secondary),
                    child: effectiveLeading,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultTextStyle(
                        style: textTheme.bodyLarge!.copyWith(
                          color: foreground,
                        ),
                        child: title,
                      ),
                      if (subtitle case final subtitle?)
                        DefaultTextStyle(
                          style: textTheme.bodyMedium!.copyWith(
                            color: secondary,
                          ),
                          child: subtitle,
                        ),
                    ],
                  ),
                ),
                if (trailing case final trailing?) ...[
                  const SizedBox(width: 8),
                  IconTheme(
                    data: IconThemeData(
                      size: 20,
                      color: selected
                          ? colorScheme.onSecondaryContainer
                          : colorScheme.onSurface,
                    ),
                    child: trailing,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CdnSelectDialog extends StatefulWidget {
  const CdnSelectDialog({
    super.key,
    this.sample,
  });

  final BaseItem? sample;

  @override
  State<CdnSelectDialog> createState() => _CdnSelectDialogState();
}

class _CdnSelectDialogState extends State<CdnSelectDialog> {
  late final bool _cdnSpeedTest = Pref.cdnSpeedTest;
  CdnSpeedTester? _tester;
  late final List<ValueNotifier<String?>> _speedResults;

  @override
  void initState() {
    super.initState();
    if (_cdnSpeedTest) {
      _tester = CdnSpeedTester(sample: widget.sample);
      _speedResults = List.generate(
        CDNService.values.length,
        (_) => ValueNotifier<String?>(null),
      );
      _testAll();
    }
  }

  @override
  void dispose() {
    _tester?.dispose();
    if (_cdnSpeedTest) {
      for (final notifier in _speedResults) {
        notifier.dispose();
      }
    }
    super.dispose();
  }

  Future<void> _testAll() async {
    final tester = _tester!;
    try {
      final sample = await tester.getSample();
      for (final service in CDNService.values) {
        if (!mounted) return;
        // 显式绕过全局自定义节点，否则每行测到的都是同一个自定义 host
        final url = VideoUtils.getCdnUrl(
          sample.playUrls,
          defaultCDNService: service,
          applyCustomCDN: false,
        );
        final result = await tester.measure(url);
        if (!mounted) return;
        _speedResults[service.index].value = result;
      }
    } catch (e) {
      if (kDebugMode) debugPrint('CDN speed test failed: $e');
    }
  }

  Future<void> _pickNode() async {
    final host = await showDialog<String>(
      context: context,
      builder: (context) =>
          CdnNodeDialog(sample: _tester?.sample ?? widget.sample),
    );
    if (host != null && mounted) {
      Navigator.pop(context, CdnCustomResult(host));
    }
  }

  Future<void> _inputCustom() async {
    final host = await showDialog<String>(
      context: context,
      builder: (context) =>
          _CdnInputDialog(initialValue: VideoUtils.customCDNUrl),
    );
    if (host != null && mounted) {
      Navigator.pop(context, CdnCustomResult(host));
    }
  }

  @override
  Widget build(BuildContext context) {
    final customHost = VideoUtils.customCDNUrl;
    const services = CDNService.values;
    return AlertDialog(
      clipBehavior: Clip.hardEdge,
      title: const Text('CDN 设置'),
      constraints: const BoxConstraints.tightFor(width: 320),
      contentPadding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (customHost != null) ...[
              M3eOptionItem(
                selected: true,
                selectionControl: true,
                title: Text(CdnNodeStore.labelOf(customHost) ?? '自定义节点'),
                subtitle: Text(
                  customHost,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  tooltip: '清除自定义 CDN',
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.close),
                  onPressed: () =>
                      Navigator.pop(context, const CdnClearCustomResult()),
                ),
              ),
              const SizedBox(height: 8),
            ],
            for (final service in services)
              M3eOptionItem(
                selected:
                    customHost == null && service == VideoUtils.cdnService,
                selectionControl: true,
                title: Text(service.desc),
                subtitle: _cdnSpeedTest
                    ? ValueListenableBuilder(
                        valueListenable: _speedResults[service.index],
                        builder: (context, value, _) => Text(
                          value ?? '测速中',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    : null,
                onTap: () =>
                    Navigator.pop(context, CdnBuiltinResult(service)),
              ),
            const SizedBox(height: 8),
            const Divider(height: 1, indent: 8, endIndent: 8),
            const SizedBox(height: 8),
            M3eOptionItem(
              leading: const Icon(Icons.travel_explore_outlined),
              title: const Text('从节点列表选择'),
              subtitle: const Text('按地区选择全国 CDN 节点'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _pickNode,
            ),
            M3eOptionItem(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('手动输入'),
              subtitle: const Text('输入任意节点 host 或完整 URL'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _inputCustom,
            ),
          ],
        ),
      ),
    );
  }
}

class _CdnInputDialog extends StatefulWidget {
  const _CdnInputDialog({this.initialValue});

  final String? initialValue;

  @override
  State<_CdnInputDialog> createState() => _CdnInputDialogState();
}

class _CdnInputDialogState extends State<_CdnInputDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialValue ?? '',
  );
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onConfirm() {
    final host = VideoUtils.normalizeCustomCDNHost(_controller.text);
    if (host == null) {
      setState(() => _errorText = '请输入有效的 host 或完整 URL');
      return;
    }
    Navigator.pop(context, host);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('自定义 CDN 节点'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'upos-sz-mirrorali.bilivideo.com',
          helperText: '支持输入完整 URL，自动提取 host',
          errorText: _errorText,
        ),
        onChanged: (_) {
          if (_errorText != null) {
            setState(() => _errorText = null);
          }
        },
        onSubmitted: (_) => _onConfirm(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            '取消',
            style: TextStyle(color: ColorScheme.of(context).outline),
          ),
        ),
        TextButton(
          onPressed: _onConfirm,
          child: const Text('确定'),
        ),
      ],
    );
  }
}
