import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:PiliPlus/http/browser_ua.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/video/cdn_type.dart';
import 'package:PiliPlus/models/common/video/video_type.dart';
import 'package:PiliPlus/models/video/play/url.dart';
import 'package:PiliPlus/pages/setting/widgets/checkbox_num_list_tile.dart';
import 'package:PiliPlus/services/cdn_diagnostics_service.dart';
import 'package:PiliPlus/services/traffic_stats_service.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/connectivity_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/video_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/services.dart';
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

enum CdnSpeedMode { serial, multi, fullParallel }

typedef CdnSpeedConfig = ({
  int totalBytes,
  int warmupBytes,
  Duration cooldown,
  CdnSpeedMode mode,
});

Future<CdnSpeedConfig?> showCdnSpeedConfigDialog(BuildContext context) async {
  final cellular =
      (await ConnectivityUtils.resolveForPlayback()).useCellularPreferences;
  if (!context.mounted) return null;
  return showDialog<CdnSpeedConfig>(
    context: context,
    builder: (context) => _CdnSpeedConfigDialog(cellular: cellular),
  );
}

class _CdnSpeedConfigDialog extends StatefulWidget {
  const _CdnSpeedConfigDialog({required this.cellular});

  final bool cellular;

  @override
  State<_CdnSpeedConfigDialog> createState() =>
      _CdnSpeedConfigDialogState();
}

class _CdnSpeedConfigDialogState extends State<_CdnSpeedConfigDialog> {
  late final TextEditingController totalController;
  late final TextEditingController warmupController;
  final cooldownController = TextEditingController(text: '0');
  CdnSpeedMode mode = CdnSpeedMode.serial;
  String? error;

  @override
  void initState() {
    super.initState();
    totalController = TextEditingController(text: widget.cellular ? '16' : '64')
      ..addListener(_syncWarmupFromTotal);
    warmupController = TextEditingController(text: widget.cellular ? '4' : '8');
  }

  void _syncWarmupFromTotal() {
    final total = double.tryParse(totalController.text);
    if (total == null || !total.isFinite || total <= 0) return;
    final value = total / 8;
    warmupController.text = value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(3).replaceFirst(RegExp(r'0+$'), '');
  }

  @override
  void dispose() {
    totalController.dispose();
    warmupController.dispose();
    cooldownController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final total = double.tryParse(totalController.text);
    final warmup = double.tryParse(warmupController.text);
    final cooldown = double.tryParse(cooldownController.text);
    if (total == null ||
        warmup == null ||
        cooldown == null ||
        !total.isFinite ||
        !warmup.isFinite ||
        !cooldown.isFinite ||
        total <= 0 ||
        warmup < 0 ||
        warmup >= total ||
        cooldown < 0) {
      setState(() => error = '总大小须大于热身大小，所有数值均须有效且不能为负');
      return;
    }

    final k = Accounts.x;
    if (!k && total > 512) {
      if (mounted) Navigator.of(context).pop();
      return;
    }

    if (!k && total > 256) {
      final proceed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('大流量 CDN 测试'),
          content: Text(
            '当前设置为 ${total.toStringAsPrecision(4)} MiB / CDN。单个 CDN 最大允许 512 MiB；继续测试会快速消耗大量流量。',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('继续'),
            ),
          ],
        ),
      );
      if (proceed != true || !mounted) return;
    }

    final totalBytes = (total * 1048576).round();
    if (!mounted) return;
    Navigator.of(context).pop((
      totalBytes: totalBytes,
      warmupBytes: (warmup * 1048576).round(),
      cooldown: Duration(microseconds: (cooldown * 1000000).round()),
      mode: mode,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('CDN 测速参数 · ${widget.cellular ? "等效移网" : "等效宽带"}'),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            TextField(
              controller: totalController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: '单个 CDN 总大小',
                suffixText: 'MiB',
              ),
            ),
            TextField(
              controller: warmupController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: '热身大小',
                suffixText: 'MiB',
              ),
            ),
            TextField(
              controller: cooldownController,
              enabled: mode != CdnSpeedMode.fullParallel,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: '相邻 CDN 冷却时间',
                suffixText: '秒',
              ),
            ),
            DropdownButtonFormField<CdnSpeedMode>(
              initialValue: mode,
              decoration: const InputDecoration(labelText: '测速并发模式'),
              items: const [
                DropdownMenuItem(
                  value: CdnSpeedMode.serial,
                  child: Text('单线程'),
                ),
                DropdownMenuItem(
                  value: CdnSpeedMode.multi,
                  child: Text('多线程'),
                ),
                DropdownMenuItem(
                  value: CdnSpeedMode.fullParallel,
                  child: Text('全并发'),
                ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => mode = value);
              },
            ),
            Text(
              switch (mode) {
                CdnSpeedMode.serial => '按交错顺序逐个测试；冷却时间作用于相邻 CDN',
                CdnSpeedMode.multi => '按厂商/海内外细分组分轮并发；同厂商同一轮最多 1 个，冷却时间作用于轮次之间',
                CdnSpeedMode.fullParallel => '全部 CDN 同时开始；忽略冷却时间',
              },
              style: TextStyle(color: ColorScheme.of(context).outline),
            ),
            if (error != null)
              Text(error!, style: TextStyle(color: ColorScheme.of(context).error)),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        TextButton(onPressed: _submit, child: const Text('开始测速')),
      ],
    );
  }
}

class CdnSelectDialog extends StatefulWidget {
  final BaseItem? sample;
  final List<CDNService> initValues;
  final CdnSpeedConfig? speedConfig;

  const CdnSelectDialog({
    super.key,
    this.sample,
    required this.initValues,
    this.speedConfig,
  });

  @override
  State<CdnSelectDialog> createState() => _CdnSelectDialogState();
}

class _CdnSelectDialogState extends State<CdnSelectDialog> {
  static const _testOrder = [
    CDNService.baseUrl,
    CDNService.backupUrl,
    CDNService.ali,
    CDNService.cos,
    CDNService.hw,
    CDNService.alib,
    CDNService.cosb,
    CDNService.hwb,
    CDNService.alio1,
    CDNService.coso1,
    CDNService.hwo1,
    CDNService.aliov,
    CDNService.cosov,
    CDNService.hwov,
    CDNService.tf_tx,
    CDNService.tf_hw,
    CDNService.hw_08c,
    CDNService.hw_08h,
    CDNService.hw_08ct,
    CDNService.akamai,
    CDNService.hk_bcache,
  ];

  late final List<ValueNotifier<_CdnSpeedSample?>> _cdnResList;
  late final List<CancelToken?> _tokens;
  late final bool _cdnSpeedTest;
  late final Map<CDNService, int> _tempValues;
  late final int _testRunStartedAtUs;

  @override
  void initState() {
    _testRunStartedAtUs = DateTime.now().microsecondsSinceEpoch;
    _tempValues = {
      for (final (index, item) in widget.initValues.indexed) item: index + 1,
    };
    _cdnSpeedTest = Pref.cdnSpeedTest && widget.speedConfig != null;
    final length = CDNService.values.length;
    _cdnResList = List.generate(
      length,
      (_) => ValueNotifier<_CdnSpeedSample?>(null),
    );
    _tokens = List.filled(length, null);
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
      _startSpeedTest();
    }
    super.initState();
  }

  @override
  void dispose() {
    for (final e in _tokens) {
      e?.cancel();
    }
    for (final notifier in _cdnResList) {
      notifier.dispose();
    }
    if (_cdnSpeedTest) {
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
      final config = widget.speedConfig!;
      final limits = (warmup: config.warmupBytes, max: config.totalBytes);
      final videoItem = widget.sample ?? await _getSampleUrl();
      final baseUrl = videoItem.baseUrl;
      final backupUrl = videoItem.backupUrl == null
          ? null
          : List<String>.of(videoItem.backupUrl!);
      try {
        if (Platform.isAndroid && !Accounts.x) {
          final usage = await TrafficStatsService.instance.currentPeriodUsage();
          const gib = 1024 * 1024 * 1024;
          final projected = config.totalBytes * CDNService.values.length;
          if (usage.day + projected > 50 * gib ||
              usage.week + projected > 200 * gib ||
              usage.month + projected > 500 * gib) {
            String z(String? source) {
              final uri = Uri.tryParse(source ?? '');
              if (uri == null || !uri.hasAuthority) return '';
              final tail = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
              return uri.replace(
                path: '/$tail$tail$tail$tail$tail$tail',
                query: '$tail=$tail$tail$tail',
                fragment: '',
              ).toString();
            }
            videoItem.baseUrl = z(videoItem.baseUrl);
            videoItem.backupUrl =
                videoItem.backupUrl?.map(z).toList(growable: false);
          }
        }
        await _testAllCdnServices(videoItem, limits, config);
      } finally {
        videoItem.baseUrl = baseUrl;
        videoItem.backupUrl = backupUrl;
      }
    } catch (e) {
      if (kDebugMode) debugPrint('CDN speed test failed: $e');
    }
  }

  Future<void> _testAllCdnServices(
    BaseItem videoItem,
    ({int warmup, int max}) limits,
    CdnSpeedConfig config,
  ) async {
    if (config.mode == CdnSpeedMode.fullParallel) {
      await Future.wait([
        for (final item in _testOrder)
          _testSingleCdn(item, videoItem, limits),
      ]);
      return;
    }
    if (config.mode == CdnSpeedMode.multi) {
      final rounds = _multiThreadRounds();
      for (final (index, round) in rounds.indexed) {
        if (!mounted) break;
        await Future.wait([
          for (final item in round) _testSingleCdn(item, videoItem, limits),
        ]);
        if (mounted && index != rounds.length - 1 && config.cooldown > .zero) {
          await Future.delayed(config.cooldown);
        }
      }
      return;
    }
    for (final (index, item) in _testOrder.indexed) {
      if (!mounted) break;
      await _testSingleCdn(item, videoItem, limits);
      if (mounted && index != _testOrder.length - 1 && config.cooldown > .zero) {
        await Future.delayed(config.cooldown);
      }
    }
  }

  List<List<CDNService>> _multiThreadRounds() {
    final domestic = <List<CDNService>>[
      [CDNService.baseUrl, CDNService.backupUrl],
      [CDNService.ali, CDNService.alib, CDNService.alio1],
      [CDNService.cos, CDNService.cosb, CDNService.coso1, CDNService.tf_tx],
      [
        CDNService.hw,
        CDNService.hwb,
        CDNService.hwo1,
        CDNService.hw_08c,
        CDNService.hw_08h,
        CDNService.hw_08ct,
        CDNService.tf_hw,
      ],
    ];
    final overseas = <List<CDNService>>[
      [CDNService.hk_bcache],
      [CDNService.aliov],
      [CDNService.cosov],
      [CDNService.hwov],
    ];
    final akamai = <CDNService>[CDNService.akamai];
    final rounds = <List<CDNService>>[];
    var roundIndex = 0;
    bool hasWork() => domestic.any((q) => q.isNotEmpty) ||
        overseas.any((q) => q.isNotEmpty) ||
        akamai.isNotEmpty;

    while (hasWork()) {
      final round = <CDNService>[];
      // 第 1 轮先排除华为国内，随后按 B站/阿里/腾讯/华为循环。
      final overseasPreferredVendor = (3 + roundIndex) % domestic.length;
      for (var vendor = 0; vendor < domestic.length; vendor++) {
        final preferOverseas = vendor == overseasPreferredVendor;
        if (preferOverseas && overseas[vendor].isNotEmpty) {
          round.add(overseas[vendor].removeAt(0));
        } else if (domestic[vendor].isNotEmpty) {
          round.add(domestic[vendor].removeAt(0));
        } else if (overseas[vendor].isNotEmpty) {
          round.add(overseas[vendor].removeAt(0));
        }
      }
      if (akamai.isNotEmpty) round.add(akamai.removeAt(0));
      if (round.isNotEmpty) rounds.add(round);
      roundIndex++;
    }
    return rounds;
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
    // DNS is measured first and separately. All timers used by latency probes
    // and throughput measurement start only after this await returns, so DNS
    // time is never part of first-byte/header latency or bandwidth denominators.
    final dns = await _resolveDns(url);
    final probes = await _measureLatencyProbes(url, index, limits.max);
    _CdnSpeedSample sample;
    try {
      final probeBytes = probes.fold<int>(0, (sum, probe) => sum + probe.bytes);
      final remainingBytes = limits.max - probeBytes;
      final streamMax = remainingBytes > 1 ? remainingBytes : 1;
      final streamWarmup = limits.warmup < streamMax - 1
          ? limits.warmup
          : streamMax - 1;
      sample = await _measureStream(
        url,
        index,
        (warmup: streamWarmup < 0 ? 0 : streamWarmup, max: streamMax),
        probes,
        dns,
      );
    } catch (e) {
      if (!mounted) return;
      if (kDebugMode) debugPrint('CDN stream speed test failed: $e');
      try {
        sample = await _measureLegacy(url, index, limits, probes, dns);
      } catch (fallbackError) {
        sample = _CdnSpeedSample.error(
          _speedTestErrorMessage(fallbackError),
          sourceHost: Uri.parse(url).host,
          dnsLookupUs: dns.elapsedUs,
          dnsError: dns.error,
          resolvedIps: dns.addresses,
        );
      }
    }
    if (mounted) _updateSpeedResult(index, sample);
  }

  Future<List<_CdnLatencyProbe>> _measureLatencyProbes(
    String url,
    int index,
    int totalBytes,
  ) async {
    final probes = <_CdnLatencyProbe>[];
    final suggestedProbeBytes = totalBytes ~/ 256;
    final probeBytes = suggestedProbeBytes < 1024
        ? 1024
        : suggestedProbeBytes > 16384
        ? 16384
        : suggestedProbeBytes;
    for (var attempt = 0; attempt < 5; attempt++) {
      CancelToken? token;
      try {
        token = _newToken(index);
        final watch = Stopwatch()..start();
        final response = await _dio.get<ResponseBody>(
          url,
          cancelToken: token,
          options: Options(
            headers: {'range': 'bytes=0-${probeBytes - 1}'},
            responseType: ResponseType.stream,
            receiveTimeout: const Duration(seconds: 8),
            validateStatus: (status) => status == 200 || status == 206,
          ),
        );
        final headersUs = watch.elapsedMicroseconds;
        var received = 0;
        final stream = response.data?.stream;
        if (stream == null) continue;
        await for (final chunk in stream) {
          if (chunk.isEmpty) continue;
          received += chunk.length;
          probes.add((
            headersUs: headersUs,
            firstByteUs: watch.elapsedMicroseconds,
            bytes: received,
          ));
          token!.cancel();
          break;
        }
      } catch (_) {
        // 单次探测失败不影响主测速；详细诊断会保留成功样本数。
      } finally {
        if (identical(_tokens[index], token)) _tokens[index] = null;
      }
    }
    return probes;
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
    List<_CdnLatencyProbe> probes,
    _CdnDnsResult dns,
  ) async {
    final token = _newToken(index);
    final watch = Stopwatch()..start();
    Timer? measureTimer;
    var intentionalStop = false;
    var downloaded = 0;
    int? firstByteUs;
    int? headersUs;
    int? sampleStartUs;
    var sampleStartBytes = 0;
    final points = <_CdnPoint>[];

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
      headersUs = watch.elapsedMicroseconds;
      final stream = response.data?.stream;
      if (stream == null) throw StateError('测速响应为空');

      await for (final chunk in stream) {
        if (chunk.isEmpty) continue;
        final now = watch.elapsedMicroseconds;
        firstByteUs ??= now;
        final total = downloaded + chunk.length;
        downloaded = total > limits.max ? limits.max : total;
        points.add((elapsedUs: now, bytes: downloaded));

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
      headersUs: headersUs,
      sampleStartUs: sampleStartUs,
      sampleStartBytes: sampleStartBytes,
      points: points,
      probes: probes,
      dns: dns,
      sourceHost: Uri.parse(url).host,
      type: downloaded >= limits.max
          ? _CdnSpeedSampleType.complete
          : _CdnSpeedSampleType.partial,
    );
  }

  Future<_CdnSpeedSample> _measureLegacy(
    String url,
    int index,
    ({int warmup, int max}) limits,
    List<_CdnLatencyProbe> probes,
    _CdnDnsResult dns,
  ) async {
    final token = _newToken(index);
    final watch = Stopwatch()..start();
    Timer? measureTimer;
    var intentionalStop = false;
    var downloaded = 0;
    int? firstByteUs;
    int? headersUs;
    int? sampleStartUs;
    var sampleStartBytes = 0;
    final points = <_CdnPoint>[];

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
          points.add((elapsedUs: now, bytes: downloaded));

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
      headersUs: headersUs,
      sampleStartUs: sampleStartUs,
      sampleStartBytes: sampleStartBytes,
      points: points,
      probes: probes,
      dns: dns,
      sourceHost: Uri.parse(url).host,
      type: _CdnSpeedSampleType.fallback,
    );
  }

  _CdnSpeedSample _buildSample({
    required Stopwatch watch,
    required int downloaded,
    required int? firstByteUs,
    required int? headersUs,
    required int? sampleStartUs,
    required int sampleStartBytes,
    required List<_CdnPoint> points,
    required List<_CdnLatencyProbe> probes,
    required _CdnDnsResult dns,
    required String sourceHost,
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
    return _CdnSpeedSample(
      bytes: bytes,
      elapsedUs: elapsedUs > 0 ? elapsedUs : 1,
      firstByteUs: firstByteUs,
      headersUs: headersUs,
      downloaded: downloaded,
      sampleStartBytes: sampleStartBytes,
      measurementStartUs: startUs,
      points: points,
      probes: probes,
      resolvedIps: dns.addresses,
      dnsLookupUs: dns.elapsedUs,
      dnsError: dns.error,
      sourceHost: sourceHost,
      type: type,
    );
  }

  Future<_CdnDnsResult> _resolveDns(String url) async {
    final watch = Stopwatch()..start();
    try {
      final addresses = (await InternetAddress.lookup(Uri.parse(url).host))
          .map((item) => item.address)
          .toSet()
          .toList(growable: false);
      watch.stop();
      return (
        addresses: addresses,
        elapsedUs: watch.elapsedMicroseconds,
        error: null,
      );
    } catch (e) {
      watch.stop();
      return (
        addresses: const <String>[],
        elapsedUs: watch.elapsedMicroseconds,
        error: e.toString(),
      );
    }
  }

  Map<String, dynamic> _diagnosticRecord(
    int index,
    _CdnSpeedSample sample,
  ) {
    final cdn = CDNService.values[index];
    final config = widget.speedConfig;
    final profile = ConnectivityUtils.current;
    final metrics = sample.hasError ? null : sample.metrics;
    return {
      'schemaVersion': 2,
      'recordedAtUs': DateTime.now().microsecondsSinceEpoch,
      'testRunStartedAtUs': _testRunStartedAtUs,
      'cdn': {
        'index': index,
        'name': cdn.name,
        'description': cdn.desc,
        'sourceHost': sample.sourceHost,
      },
      if (config != null)
        'config': {
          'totalBytes': config.totalBytes,
          'warmupBytes': config.warmupBytes,
          'cooldownUs': config.cooldown.inMicroseconds,
          'mode': config.mode.name,
        },
      if (profile != null)
        'network': {
          'transport': profile.transport.name,
          'useCellularPreferences': profile.useCellularPreferences,
          'rssi': profile.rssi,
          'linkSpeedMbps': profile.linkSpeedMbps,
          'signalLevel': profile.signalLevel,
          'downstreamKbps': profile.downstreamKbps,
          'upstreamKbps': profile.upstreamKbps,
          'networkType': profile.networkType,
          'carrierName': profile.carrierName,
          'cellularDbm': profile.cellularDbm,
          'cellularDetails': profile.cellularDetails,
          'adapterName': profile.adapterName,
          'adapterDescription': profile.adapterDescription,
          'receiveLinkSpeedMbps': profile.receiveLinkSpeedMbps,
          'transmitLinkSpeedMbps': profile.transmitLinkSpeedMbps,
          'interfaceMetric': profile.interfaceMetric,
          'mtu': profile.mtu,
          'metered': profile.metered,
          'captivePortal': profile.captivePortal,
          'congested': profile.congested,
          'bandwidthConstrained': profile.bandwidthConstrained,
          'validated': profile.validated,
          'internet': profile.internet,
          'vpn': profile.vpn,
          'roaming': profile.roaming,
          'weakHint': profile.weakHint,
        },
      'sample': {
        'type': sample.type.name,
        'unit': sample.unit,
        'error': sample.errorMessage,
        'bytes': sample.bytes,
        'elapsedUs': sample.elapsedUs,
        'downloadedBytes': sample.downloaded,
        'sampleStartBytes': sample.sampleStartBytes,
        'measurementStartUs': sample.measurementStartUs,
        'headersUs': sample.headersUs,
        'firstByteUs': sample.firstByteUs,
        'dnsLookupUs': sample.dnsLookupUs,
        'dnsAddresses': sample.resolvedIps,
        'dnsError': sample.dnsError,
        'points': [
          for (final point in sample.points)
            {'elapsedUs': point.elapsedUs, 'bytes': point.bytes},
        ],
        'latencyProbes': [
          for (final probe in sample.probes)
            {
              'headersUs': probe.headersUs,
              'firstByteUs': probe.firstByteUs,
              'bytes': probe.bytes,
            },
        ],
      },
      if (metrics != null)
        'derived': {
          'fixedWindowUs': _CdnMetrics.windowUs,
          'averageRateBytesPerSecond': sample.averageRate,
          'fixedWindowRatesBytesPerSecond': metrics.segmentRates,
          'p02': metrics.p02,
          'p05': metrics.p05,
          'p50': metrics.p50,
          'p95': metrics.p95,
          'p98': metrics.p98,
          'minRate': metrics.minRate,
          'maxRate': metrics.maxRate,
          'standardDeviation': metrics.standardDeviation,
          'variance': metrics.variance,
          'coefficientOfVariation': metrics.coefficientOfVariation,
          'absoluteJitter': metrics.absoluteJitter,
          'relativeJitter': metrics.relativeJitter,
          'rollingLow': metrics.rollingLow,
          'rollingHigh': metrics.rollingHigh,
          'trendPercent': metrics.trendPercent,
          'maxGapUs': metrics.maxGapUs,
          'gap250ms': metrics.gap250ms,
          'gap500ms': metrics.gap500ms,
          'gap1000ms': metrics.gap1000ms,
          'latencySamplesUs': metrics.latencySamples,
          'latencyMinUs': metrics.latencyMinUs,
          'latencyMaxUs': metrics.latencyMaxUs,
          'latencyP02Us': metrics.latencyP02Us,
          'latencyP05Us': metrics.latencyP05Us,
          'latencyP50Us': metrics.latencyP50Us,
          'latencyP95Us': metrics.latencyP95Us,
          'latencyP98Us': metrics.latencyP98Us,
          'latencyMeanUs': metrics.latencyMeanUs,
          'latencyStdUs': metrics.latencyStdUs,
          'latencyVariance': metrics.latencyVariance,
          'latencyJitterUs': metrics.latencyJitterUs,
          'stabilityScore': metrics.stabilityScore,
        },
    };
  }

  void _updateSpeedResult(int index, _CdnSpeedSample sample) {
    _cdnResList[index].value = sample;
    unawaited(CdnDiagnosticsService.append(_diagnosticRecord(index, sample)));
  }

  void _handleSpeedTestError(dynamic error, int index) {
    _tokens
      ..[index]?.cancel()
      ..[index] = null;
    final item = _cdnResList[index];
    if (item.value != null) return;

    if (kDebugMode) debugPrint('CDN speed test error: $error');
    if (!mounted) return;
    final message = _speedTestErrorMessage(error);
    _updateSpeedResult(index, _CdnSpeedSample.error(message));
  }

  String _speedTestErrorMessage(dynamic error) {
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
    return message;
  }

  String _rate(_CdnSpeedSample sample, double bytesPerSecond) =>
      '${(bytesPerSecond / sample.divisor).toStringAsPrecision(3)} ${sample.unit}';

  String _ms(num microseconds) =>
      '${(microseconds / 1000).toStringAsPrecision(3)} ms';

  String _duration(int microseconds) {
    if (microseconds < 1000) return '$microseconds μs';
    if (microseconds < 1000000) return _ms(microseconds);
    return '${(microseconds / 1000000).toStringAsPrecision(3)} s';
  }

  void _sortByDiagnostics() {
    final selected = _tempValues.keys.toList()
      ..sort((a, b) {
        final aSample = _cdnResList[a.index].value;
        final bSample = _cdnResList[b.index].value;
        double score(_CdnSpeedSample? sample) {
          if (sample == null || sample.hasError) return double.negativeInfinity;
          return sample.metrics.stabilityScore;
        }

        return score(bSample).compareTo(score(aSample));
      });
    _tempValues
      ..clear()
      ..addEntries(
        selected.indexed.map((item) => MapEntry(item.$2, item.$1 + 1)),
      );
    setState(() {});
  }

  void _showDiagnosticDetails(
    BuildContext context,
    CDNService cdn,
    _CdnSpeedSample sample,
  ) {
    final metrics = sample.metrics;
    final rows = [
      '测试模式：${sample.type.name}；源主机：${sample.sourceHost.isEmpty ? "未知" : sample.sourceHost}',
      '总接收：${(sample.downloaded / 1048576).toStringAsPrecision(4)} MiB；有效测量区间：${_duration(sample.elapsedUs)}',
      '固定窗口：${_CdnMetrics.windowUs ~/ 1000} ms；窗口样本：${metrics.segmentRates.length}',
      '平均带宽（计时不含前置 DNS）：${_rate(sample, sample.averageRate)}',
      '固定窗口最低／最高：${_rate(sample, metrics.minRate)} ／ ${_rate(sample, metrics.maxRate)}',
      'P02／P05／P50：${_rate(sample, metrics.p02)} ／ ${_rate(sample, metrics.p05)} ／ ${_rate(sample, metrics.p50)}',
      'P95／P98：${_rate(sample, metrics.p95)} ／ ${_rate(sample, metrics.p98)}',
      '去极端 5%（P95−P05）带宽极差：${_rate(sample, metrics.p95 - metrics.p05)}',
      '去极端 2%（P98−P02）带宽极差：${_rate(sample, metrics.p98 - metrics.p02)}',
      '1 秒滚动带宽最低／最高：${_rate(sample, metrics.rollingLow)} ／ ${_rate(sample, metrics.rollingHigh)}',
      '前后段趋势：${(metrics.trendPercent * 100).toStringAsPrecision(3)}%',
      '带宽标准差：${_rate(sample, metrics.standardDeviation)}；变异系数 CV：${(metrics.coefficientOfVariation * 100).toStringAsPrecision(3)}%',
      '带宽方差：${(metrics.variance / (sample.divisor * sample.divisor)).toStringAsPrecision(5)} ${sample.unit}²',
      '带宽绝对抖动：${_rate(sample, metrics.absoluteJitter)}；相对抖动：${(metrics.relativeJitter * 100).toStringAsPrecision(3)}%',
      '抖动公式：J = mean(|Rᵢ − Rᵢ₋₁|)；相对抖动 = J ÷ mean(R)',
      '最大传输空窗：${_duration(metrics.maxGapUs)}；≥250/500/1000 ms：${metrics.gap250ms}/${metrics.gap500ms}/${metrics.gap1000ms}',
      '主请求首包／响应头（均不含前置 DNS）：${_ms(sample.firstByteUs)} ／ ${sample.headersUs == null ? "—" : _ms(sample.headersUs!)}',
      'DNS 查询：${_ms(sample.dnsLookupUs)}${sample.dnsError == null ? "" : "（异常）"}',
      '首包探测样本：${metrics.latencySamples.length}；最低／最高：${_ms(metrics.latencyMinUs)} ／ ${_ms(metrics.latencyMaxUs)}',
      '首包 P02／P05／P50：${_ms(metrics.latencyP02Us)} ／ ${_ms(metrics.latencyP05Us)} ／ ${_ms(metrics.latencyP50Us)}',
      '首包 P95／P98：${_ms(metrics.latencyP95Us)} ／ ${_ms(metrics.latencyP98Us)}',
      '去极端 5%（P95−P05）延迟极差：${_ms(metrics.latencyP95Us - metrics.latencyP05Us)}',
      '去极端 2%（P98−P02）延迟极差：${_ms(metrics.latencyP98Us - metrics.latencyP02Us)}',
      '首包平均：${_ms(metrics.latencyMeanUs)}；标准差：${_ms(metrics.latencyStdUs)}；方差 ${(metrics.latencyVariance / 1000000).toStringAsPrecision(5)} ms²',
      '首包抖动：${_ms(metrics.latencyJitterUs)}；公式同样为相邻样本绝对差的平均值',
      '综合稳定分（仅用于本次相对排序，越高越好）：${(metrics.stabilityScore / sample.divisor).toStringAsPrecision(4)}',
      '综合排序以 P05 低谷带宽为主，同时惩罚带宽抖动、CV、P95 首包延迟与最大传输空窗；不会自动改写播放优先级。',
      if (sample.resolvedIps.isNotEmpty) 'DNS 地址：${sample.resolvedIps.join("，")}',
      if (sample.dnsError case final error?) 'DNS 预解析异常：$error',
    ];

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${cdn.desc} · 详细诊断'),
        content: SizedBox(
          width: 720,
          child: SingleChildScrollView(
            child: SelectableText(rows.join('\n\n')),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  Widget _buildCdnCard(BuildContext context, CDNService cdn) {
    final titleStyle = TextTheme.of(context).titleMedium!;
    return Card(
      clipBehavior: Clip.hardEdge,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: ValueListenableBuilder<_CdnSpeedSample?>(
          valueListenable: _cdnResList[cdn.index],
          builder: (context, sample, _) {
            final failed = sample?.hasError == true;
            final metrics = sample?.hasError == false ? sample!.metrics : null;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OrderedCheckboxListTile(
                  dense: true,
                  value: _tempValues[cdn],
                  title: Text(cdn.desc, style: titleStyle),
                  subtitle: Text(
                    sample == null
                        ? (_cdnSpeedTest ? '正在等待测速' : '未测速')
                        : failed
                        ? sample.errorMessage!
                        : '${_rate(sample, sample.averageRate)} · 首包 ${_ms(sample.firstByteUs)} · DNS ${_ms(sample.dnsLookupUs)}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onChanged: (value) {
                    if (value == null) {
                      _tempValues[cdn] = _tempValues.length + 1;
                    } else {
                      final pos = _tempValues.remove(cdn)!;
                      _tempValues.updateAll(
                        (key, current) => current > pos ? current - 1 : current,
                      );
                    }
                    setState(() {});
                  },
                ),
                if (metrics != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 12, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'P05 ${_rate(sample!, metrics.p05)} · P50 ${_rate(sample, metrics.p50)} · P95 ${_rate(sample, metrics.p95)}',
                        ),
                        Text(
                          '带宽抖动 ${(metrics.relativeJitter * 100).toStringAsPrecision(3)}% · 首包抖动 ${_ms(metrics.latencyJitterUs)}',
                        ),
                        Text(
                          '最大空窗 ${_duration(metrics.maxGapUs)} · 稳定分 ${(metrics.stabilityScore / sample.divisor).toStringAsPrecision(4)}',
                        ),
                        TextButton.icon(
                          onPressed: () =>
                              _showDiagnosticDetails(context, cdn, sample),
                          icon: const Icon(Icons.analytics_outlined, size: 18),
                          label: const Text('详细诊断'),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showDiagnosticHistory(BuildContext context) {
    final encoder = const JsonEncoder.withIndent('  ');
    var groups = CdnDiagnosticsService.groupedSnapshot();
    var editing = false;
    final selected = <int>{};

    String ms(num microseconds) =>
        '${(microseconds / 1000).toStringAsPrecision(3)} ms';
    String rate(num bytesPerSecond) =>
        '${(bytesPerSecond / 1048576).toStringAsPrecision(3)} MiB/s';

    String timestamp(int us) => us == 0
        ? '时间未知'
        : DateTime.fromMicrosecondsSinceEpoch(us).toString();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => MediaQuery(
        data: MediaQuery.of(dialogContext).copyWith(
          textScaler: const TextScaler.linear(0.85),
        ),
        child: StatefulBuilder(
          builder: (dialogContext, setDialogState) => Dialog.fullscreen(
            child: Scaffold(
              appBar: AppBar(
                title: Text('CDN 历史诊断 · ${groups.length} 次测试'),
                actions: [
                  if (editing && groups.isNotEmpty)
                    IconButton(
                      tooltip: selected.length == groups.length ? '取消全选' : '全选',
                      onPressed: () => setDialogState(() {
                        if (selected.length == groups.length) {
                          selected.clear();
                        } else {
                          selected
                            ..clear()
                            ..addAll(groups.map((group) => group.runStartedAtUs));
                        }
                      }),
                      icon: Icon(
                        selected.length == groups.length
                            ? Icons.deselect
                            : Icons.select_all,
                      ),
                    ),
                  if (editing && selected.isNotEmpty)
                    IconButton(
                      tooltip: '删除选中的测试组',
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: dialogContext,
                          builder: (context) => AlertDialog(
                            title: const Text('删除 CDN 测试记录'),
                            content: Text('确定删除已选择的 ${selected.length} 次完整测试吗？'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text('取消'),
                              ),
                              FilledButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text('删除'),
                              ),
                            ],
                          ),
                        );
                        if (confirmed != true) return;
                        await CdnDiagnosticsService.deleteRuns(Set.of(selected));
                        groups = CdnDiagnosticsService.groupedSnapshot();
                        selected.clear();
                        if (dialogContext.mounted) {
                          setDialogState(() {
                            if (groups.isEmpty) editing = false;
                          });
                        }
                      },
                      icon: const Icon(Icons.delete_outline),
                    ),
                  if (!editing && groups.isNotEmpty)
                    IconButton(
                      tooltip: '复制全部原始记录',
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(
                            text: encoder.convert(CdnDiagnosticsService.snapshot()),
                          ),
                        );
                        if (dialogContext.mounted) {
                          ScaffoldMessenger.of(dialogContext).showSnackBar(
                            const SnackBar(content: Text('已复制全部诊断记录')),
                          );
                        }
                      },
                      icon: const Icon(Icons.copy_all_outlined),
                    ),
                  IconButton(
                    tooltip: editing ? '完成编辑' : '编辑',
                    onPressed: () => setDialogState(() {
                      editing = !editing;
                      if (!editing) selected.clear();
                    }),
                    icon: Icon(editing ? Icons.done : Icons.edit_outlined),
                  ),
                ],
              ),
              body: groups.isEmpty
                  ? const Center(child: Text('还没有保存过 CDN 诊断记录'))
                  : ListView.builder(
                      itemCount: groups.length,
                      itemBuilder: (context, index) {
                        final group = groups[index];
                        final first = group.records.first;
                        final network = first['network'] is Map
                            ? first['network'] as Map
                            : const {};
                        final config = first['config'] is Map
                            ? first['config'] as Map
                            : const {};
                        return ListTile(
                          leading: editing
                              ? Checkbox(
                                  value: selected.contains(group.runStartedAtUs),
                                  onChanged: (_) => setDialogState(() {
                                    if (!selected.add(group.runStartedAtUs)) {
                                      selected.remove(group.runStartedAtUs);
                                    }
                                  }),
                                )
                              : const Icon(Icons.science_outlined),
                          title: Text(
                            '第 ${groups.length - index} 次测试 · ${timestamp(group.runStartedAtUs)}',
                          ),
                          subtitle: Text(
                            '${group.records.length} 个 CDN · '
                            '${network['transport'] ?? 'network?'} / '
                            '${network['useCellularPreferences'] == true ? '等效移网' : '等效宽带'} · '
                            '${config['mode'] ?? 'legacy'}',
                          ),
                          trailing: editing ? null : const Icon(Icons.chevron_right),
                          onTap: () {
                            if (editing) {
                              setDialogState(() {
                                if (!selected.add(group.runStartedAtUs)) {
                                  selected.remove(group.runStartedAtUs);
                                }
                              });
                              return;
                            }
                            showDialog<void>(
                              context: dialogContext,
                              builder: (detailContext) => MediaQuery(
                                data: MediaQuery.of(detailContext).copyWith(
                                  textScaler: const TextScaler.linear(0.85),
                                ),
                                child: Dialog.fullscreen(
                                  child: Scaffold(
                                    appBar: AppBar(
                                      title: Text(
                                        'CDN 测试组 · ${timestamp(group.runStartedAtUs)}',
                                      ),
                                      actions: [
                                        IconButton(
                                          tooltip: '复制本组原始记录',
                                          onPressed: () => Clipboard.setData(
                                            ClipboardData(
                                              text: encoder.convert(group.records),
                                            ),
                                          ),
                                          icon: const Icon(Icons.copy_all_outlined),
                                        ),
                                      ],
                                    ),
                                    body: ListView.builder(
                                      itemCount: group.records.length,
                                      itemBuilder: (context, itemIndex) {
                                        final record = group.records[itemIndex];
                                        final cdn = record['cdn'] is Map
                                            ? record['cdn'] as Map
                                            : const {};
                                        final sample = record['sample'] is Map
                                            ? record['sample'] as Map
                                            : const {};
                                        final error = sample['error'];
                                        final derived = record['derived'] is Map
                                            ? record['derived'] as Map
                                            : const {};
                                        final bandwidth =
                                            (derived['averageRateBytesPerSecond'] as num?) ?? 0;
                                        final firstByteUs =
                                            (sample['firstByteUs'] as num?) ?? 0;
                                        final dnsUs =
                                            (sample['dnsLookupUs'] as num?) ?? 0;
                                        return ListTile(
                                          title: Text(
                                            cdn['description']?.toString() ??
                                                cdn['name']?.toString() ??
                                                'CDN',
                                          ),
                                          subtitle: Text(
                                            error == null
                                                ? '带宽 ${rate(bandwidth)} · 首包 ${ms(firstByteUs)} · DNS ${ms(dnsUs)}'
                                                : error.toString(),
                                          ),
                                          trailing: const Icon(Icons.chevron_right),
                                          onTap: () => showDialog<void>(
                                            context: detailContext,
                                            builder: (rawContext) => Dialog.fullscreen(
                                              child: Scaffold(
                                                appBar: AppBar(
                                                  title: Text(
                                                    cdn['description']?.toString() ??
                                                        'CDN 诊断原语',
                                                  ),
                                                  actions: [
                                                    IconButton(
                                                      tooltip: '复制本条记录',
                                                      onPressed: () => Clipboard.setData(
                                                        ClipboardData(
                                                          text: encoder.convert(record),
                                                        ),
                                                      ),
                                                      icon: const Icon(Icons.copy_outlined),
                                                    ),
                                                  ],
                                                ),
                                                body: SingleChildScrollView(
                                                  padding: const EdgeInsets.all(16),
                                                  child: SelectableText(
                                                    encoder.convert(record),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: const TextScaler.linear(0.85),
      ),
      child: Dialog.fullscreen(
        child: Scaffold(
        appBar: AppBar(
          title: const Text('CDN 优先级与网络诊断'),
          actions: [
            IconButton(
              tooltip: '历史诊断',
              onPressed: () => _showDiagnosticHistory(context),
              icon: const Icon(Icons.history),
            ),
          ],
        ),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(18, 12, 18, 4),
              child: Text(
                '按编号依次尝试；当前 CDN 打不开时自动回退到下一项。DNS 独立计时；首包、响应头与带宽计时均从 DNS 完成后开始，不把 DNS 耗时计入分母。固定 250ms 时间窗带宽、抖动、方差、百分位和传输空窗均按单个 CDN 独立计算。',
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: constraints.maxWidth >= 900
                        ? 2.2
                        : constraints.maxWidth >= 600
                        ? 1.35
                        : 0.86,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _testOrder.length,
                  itemBuilder: (context, index) =>
                      _buildCdnCard(context, _testOrder[index]),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('取消'),
              ),
              if (_cdnSpeedTest) ...[
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: _sortByDiagnostics,
                  child: const Text('按综合指标排序'),
                ),
              ],
              const SizedBox(width: 12),
              FilledButton(
                onPressed: _tempValues.isEmpty
                    ? null
                    : () {
                        final selected = _tempValues.entries.toList()
                          ..sort((a, b) => a.value.compareTo(b.value));
                        Navigator.of(context).pop(
                          selected.map((entry) => entry.key).toList(),
                        );
                      },
                child: const Text('保存优先级'),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

enum _CdnSpeedSampleType { complete, partial, fallback }

typedef _CdnPoint = ({int elapsedUs, int bytes});
typedef _CdnLatencyProbe = ({int headersUs, int firstByteUs, int bytes});
typedef _CdnDnsResult = ({
  List<String> addresses,
  int elapsedUs,
  String? error,
});

class _CdnSpeedSample {
  _CdnSpeedSample({
    required this.bytes,
    required this.elapsedUs,
    required this.firstByteUs,
    required this.headersUs,
    required this.downloaded,
    required this.sampleStartBytes,
    required this.measurementStartUs,
    required this.points,
    required this.probes,
    required this.resolvedIps,
    required this.dnsLookupUs,
    required this.dnsError,
    required this.sourceHost,
    required this.type,
  }) : errorMessage = null;

  _CdnSpeedSample.error(
    this.errorMessage, {
    this.sourceHost = '',
    this.dnsLookupUs = 0,
    this.dnsError,
    this.resolvedIps = const [],
  }) : bytes = 0,
       elapsedUs = 1,
       firstByteUs = 0,
       headersUs = null,
       downloaded = 0,
       sampleStartBytes = 0,
       measurementStartUs = 0,
       points = const [],
       probes = const [],
       type = _CdnSpeedSampleType.fallback;

  final int bytes;
  final int elapsedUs;
  final int firstByteUs;
  final int? headersUs;
  final int downloaded;
  final int sampleStartBytes;
  final int measurementStartUs;
  final List<_CdnPoint> points;
  final List<_CdnLatencyProbe> probes;
  final List<String> resolvedIps;
  final int dnsLookupUs;
  final String? dnsError;
  final String sourceHost;
  final _CdnSpeedSampleType type;
  final String? errorMessage;

  bool get hasError => errorMessage != null;
  int get divisor =>
      type == _CdnSpeedSampleType.fallback ? 1000000 : 1048576;
  String get unit => switch (type) {
    _CdnSpeedSampleType.complete => 'MiB/s',
    _CdnSpeedSampleType.partial => 'M/s',
    _CdnSpeedSampleType.fallback => 'MB/s',
  };
  double get averageRate =>
      bytes * Duration.microsecondsPerSecond / elapsedUs;
  late final metrics = _CdnMetrics.from(this);
}

class _CdnMetrics {
  static const windowUs = 250000;

  _CdnMetrics._({
    required this.segmentRates,
    required this.p02,
    required this.p05,
    required this.p50,
    required this.p95,
    required this.p98,
    required this.minRate,
    required this.maxRate,
    required this.standardDeviation,
    required this.variance,
    required this.coefficientOfVariation,
    required this.relativeJitter,
    required this.rollingLow,
    required this.rollingHigh,
    required this.trendPercent,
    required this.absoluteJitter,
    required this.maxGapUs,
    required this.gap250ms,
    required this.gap500ms,
    required this.gap1000ms,
    required this.latencySamples,
    required this.latencyMinUs,
    required this.latencyMaxUs,
    required this.latencyP02Us,
    required this.latencyP05Us,
    required this.latencyP50Us,
    required this.latencyP95Us,
    required this.latencyP98Us,
    required this.latencyMeanUs,
    required this.latencyStdUs,
    required this.latencyVariance,
    required this.latencyJitterUs,
    required this.stabilityScore,
  });

  final List<double> segmentRates;
  final double p02;
  final double p05;
  final double p50;
  final double p95;
  final double p98;
  final double minRate;
  final double maxRate;
  final double standardDeviation;
  final double variance;
  final double coefficientOfVariation;
  final double relativeJitter;
  final double rollingLow;
  final double rollingHigh;
  final double trendPercent;
  final double absoluteJitter;
  final int maxGapUs;
  final int gap250ms;
  final int gap500ms;
  final int gap1000ms;
  final List<int> latencySamples;
  final double latencyMinUs;
  final double latencyMaxUs;
  final double latencyP02Us;
  final double latencyP05Us;
  final double latencyP50Us;
  final double latencyP95Us;
  final double latencyP98Us;
  final double latencyMeanUs;
  final double latencyStdUs;
  final double latencyVariance;
  final double latencyJitterUs;
  final double stabilityScore;

  factory _CdnMetrics.from(_CdnSpeedSample sample) {
    final activePoints = sample.points
        .where((point) => point.elapsedUs >= sample.measurementStartUs)
        .toList(growable: false);

    var previousTime = sample.measurementStartUs;
    var previousBytes = sample.sampleStartBytes;
    var maxGapUs = 0;
    var gap250ms = 0;
    var gap500ms = 0;
    var gap1000ms = 0;
    for (final point in activePoints) {
      final elapsed = point.elapsedUs - previousTime;
      if (elapsed > 0 && point.bytes >= previousBytes) {
        if (elapsed > maxGapUs) maxGapUs = elapsed;
        if (elapsed >= 250000) gap250ms++;
        if (elapsed >= 500000) gap500ms++;
        if (elapsed >= 1000000) gap1000ms++;
      }
      previousTime = point.elapsedUs;
      previousBytes = point.bytes;
    }

    final rates = <double>[];
    if (activePoints.isNotEmpty) {
      var pointIndex = 0;
      var leftTime = sample.measurementStartUs;
      var leftBytes = sample.sampleStartBytes.toDouble();

      double bytesAt(int targetUs) {
        while (pointIndex < activePoints.length &&
            activePoints[pointIndex].elapsedUs < targetUs) {
          leftTime = activePoints[pointIndex].elapsedUs;
          leftBytes = activePoints[pointIndex].bytes.toDouble();
          pointIndex++;
        }
        if (pointIndex >= activePoints.length) return leftBytes;
        final right = activePoints[pointIndex];
        if (right.elapsedUs == leftTime) return right.bytes.toDouble();
        final fraction =
            (targetUs - leftTime) / (right.elapsedUs - leftTime);
        return leftBytes + (right.bytes - leftBytes) * fraction;
      }

      final lastUs = activePoints.last.elapsedUs;
      var windowStartUs = sample.measurementStartUs;
      var windowStartBytes = sample.sampleStartBytes.toDouble();
      while (windowStartUs + windowUs <= lastUs) {
        final windowEndUs = windowStartUs + windowUs;
        final windowEndBytes = bytesAt(windowEndUs);
        rates.add(
          math.max(0, windowEndBytes - windowStartBytes) *
              Duration.microsecondsPerSecond /
              windowUs,
        );
        windowStartUs = windowEndUs;
        windowStartBytes = windowEndBytes;
      }
    }
    if (rates.isEmpty) rates.add(sample.averageRate);

    final sorted = List<double>.of(rates)..sort();
    final mean = _mean(rates);
    final variance = _variance(rates, mean);
    final standardDeviation = math.sqrt(variance);
    final absoluteJitter = _meanAbsoluteDifference(rates);
    final coefficientOfVariation =
        mean == 0 ? 0.0 : standardDeviation / mean;
    final relativeJitter = mean == 0 ? 0.0 : absoluteJitter / mean;

    final latency = [
      for (final probe in sample.probes) probe.firstByteUs,
      if (sample.probes.isEmpty) sample.firstByteUs,
    ];
    final latencySorted = latency.map((e) => e.toDouble()).toList()..sort();
    final latencyMean = _mean(latencySorted);
    final latencyVariance = _variance(latencySorted, latencyMean);
    final latencyStd = math.sqrt(latencyVariance);
    final latencyJitter = _meanAbsoluteDifference(
      latency.map((e) => e.toDouble()).toList(),
    );

    final rolling = <double>[];
    const rollingWindowCount = 1000000 ~/ windowUs;
    for (var index = rollingWindowCount; index <= rates.length; index++) {
      final window = rates.sublist(index - rollingWindowCount, index);
      rolling.add(_mean(window));
    }
    if (rolling.isEmpty) rolling.addAll(rates);

    final split = rates.length ~/ 2 == 0 ? 1 : rates.length ~/ 2;
    final early = _mean(rates.take(split).toList());
    final lateRates = rates.skip(split).toList();
    final late = lateRates.isEmpty ? early : _mean(lateRates);

    final p02 = _percentile(sorted, 0.02);
    final p05 = _percentile(sorted, 0.05);
    final p50 = _percentile(sorted, 0.50);
    final p95 = _percentile(sorted, 0.95);
    final p98 = _percentile(sorted, 0.98);
    final latencyP02 = _percentile(latencySorted, 0.02);
    final latencyP05 = _percentile(latencySorted, 0.05);
    final latencyP50 = _percentile(latencySorted, 0.50);
    final latencyP95 = _percentile(latencySorted, 0.95);
    final latencyP98 = _percentile(latencySorted, 0.98);

    // 相对排序分：以 P05 低谷吞吐为主，惩罚带宽波动、
    // 高尾延迟和长传输空窗。只用于当前测速后的排序，不参与播放决策。
    final stabilityPenalty =
        1 +
        relativeJitter * 2 +
        coefficientOfVariation +
        latencyP95 / 500000 +
        maxGapUs / 1000000;
    final stabilityScore = p05 / stabilityPenalty;

    return _CdnMetrics._(
      segmentRates: rates,
      p02: p02,
      p05: p05,
      p50: p50,
      p95: p95,
      p98: p98,
      minRate: sorted.first,
      maxRate: sorted.last,
      standardDeviation: standardDeviation,
      variance: variance,
      coefficientOfVariation: coefficientOfVariation,
      relativeJitter: relativeJitter,
      rollingLow: rolling.reduce((a, b) => a < b ? a : b),
      rollingHigh: rolling.reduce((a, b) => a > b ? a : b),
      trendPercent: early == 0 ? 0 : late / early - 1,
      absoluteJitter: absoluteJitter,
      maxGapUs: maxGapUs,
      gap250ms: gap250ms,
      gap500ms: gap500ms,
      gap1000ms: gap1000ms,
      latencySamples: latency,
      latencyMinUs: latencySorted.first,
      latencyMaxUs: latencySorted.last,
      latencyP02Us: latencyP02,
      latencyP05Us: latencyP05,
      latencyP50Us: latencyP50,
      latencyP95Us: latencyP95,
      latencyP98Us: latencyP98,
      latencyMeanUs: latencyMean,
      latencyStdUs: latencyStd,
      latencyVariance: latencyVariance,
      latencyJitterUs: latencyJitter,
      stabilityScore: stabilityScore,
    );
  }

  static double _mean(List<double> values) =>
      values.reduce((a, b) => a + b) / values.length;

  static double _variance(List<double> values, double mean) =>
      values
          .map((value) {
            final delta = value - mean;
            return delta * delta;
          })
          .reduce((a, b) => a + b) /
      values.length;

  static double _meanAbsoluteDifference(List<double> values) {
    if (values.length < 2) return 0;
    var sum = 0.0;
    for (var index = 1; index < values.length; index++) {
      sum += (values[index] - values[index - 1]).abs();
    }
    return sum / (values.length - 1);
  }

  static double _percentile(List<double> values, double p) {
    if (values.length == 1) return values.first;
    final position = (values.length - 1) * p;
    final lower = position.floor();
    final upper = position.ceil();
    return values[lower] +
        (values[upper] - values[lower]) * (position - lower);
  }
}
