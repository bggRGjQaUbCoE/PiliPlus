import 'dart:async';
import 'dart:io';

import 'package:PiliPlus/services/net_debug_logger.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:get/get.dart';

final _netLog = NetDebugLogger.instance;

/// Android 上 CDN 频繁断开连接（mbedTLS 问题 + 服务端主动关闭），
/// 导致 mpv 不断触发重连 → 数据损坏 → 卡顿。
///
/// 本代理在断连时自动用 Range 请求断点续传，
/// 对 mpv 暴露为一个稳定的不中断的 HTTP 流。
/// 当某个 CDN 持续失败时，自动切换到备用 CDN 节点。
class VideoStreamProxy {
  static final instance = VideoStreamProxy._();

  VideoStreamProxy._();

  HttpServer? _server;
  HttpClient? _client;
  int _port = 0;

  /// 实时下载速度 (KB/s)，供 UI 层观察
  final RxInt speedKBps = 0.obs;

  int _totalBytes = 0;
  int _lastSampleBytes = 0;
  Timer? _speedTimer;

  int get port => _port;
  bool get isRunning => _server != null;

  // B站 CDN 镜像 host 列表，用于自动回退。
  // 所有 mirror URL 路径相同，仅 host 不同，可直接替换。
  static const _fallbackHosts = [
    // 阿里云
    'upos-sz-mirrorali.bilivideo.com',
    'upos-sz-mirroralib.bilivideo.com',
    'upos-sz-mirroralio1.bilivideo.com',
    // 百度云
    'upos-sz-mirrorbos.bilivideo.com',
    // 腾讯云
    'upos-sz-mirrorcos.bilivideo.com',
    'upos-sz-mirrorcosb.bilivideo.com',
    'upos-sz-mirrorcoso1.bilivideo.com',
    'upos-sz-mirrorcoso2.bilivideo.com',
    // 华为云
    'upos-sz-mirrorhw.bilivideo.com',
    'upos-sz-mirrorhwb.bilivideo.com',
    'upos-sz-mirrorhwo1.bilivideo.com',
    'upos-sz-mirror08c.bilivideo.com',
    'upos-sz-mirror08h.bilivideo.com',
    'upos-sz-mirror08ct.bilivideo.com',
    // 金山云
    'upos-sz-mirrorks3.bilivideo.com',
    'upos-sz-mirrorks3b.bilivideo.com',
    'upos-sz-mirrorks3c.bilivideo.com',
    // 七牛云
    'upos-sz-mirrorkodo.bilivideo.com',
    'upos-sz-mirrorkodob.bilivideo.com',
    // UPCDN 加速
    'upos-sz-upcdnbda2.bilivideo.com',
    'upos-sz-upcdnws.bilivideo.com',
    // 海外
    'upos-sz-mirroraliov.bilivideo.com',
    'upos-sz-mirrorcosov.bilivideo.com',
    'upos-sz-mirrorhwov.bilivideo.com',
    'upos-hz-mirrorakam.akamaized.net',
    'upos-sz-mirrorakam.akamaized.net',
  ];

  /// 匹配可替换 host 的 CDN 域名（mirror / upcdn 系列）
  static final _mirrorHostRegex = RegExp(
    r'^upos-(?:sz|hz)-(?:mirror|upcdn)\w+\.(?:bilivideo\.com|akamaized\.net)$',
  );

  Future<void> start() async {
    if (_server != null) return;

    _client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 15)
      ..idleTimeout = const Duration(seconds: 300)
      ..maxConnectionsPerHost = 2
      ..autoUncompress = false;

    _server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    _port = _server!.port;
    _totalBytes = 0;
    _lastSampleBytes = 0;
    _speedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final delta = _totalBytes - _lastSampleBytes;
      speedKBps.value = (delta / 1024).round();
      _lastSampleBytes = _totalBytes;
    });
    _netLog.info('PROXY', 'started', extra: {'port': _port});
    _server!.listen(_handleRequest);
  }

  Future<void> stop() async {
    _speedTimer?.cancel();
    _speedTimer = null;
    speedKBps.value = 0;
    await _server?.close(force: true);
    _client?.close(force: true);
    _server = null;
    _client = null;
    _port = 0;
  }

  String proxyUrl(String originalUrl) {
    return 'http://127.0.0.1:$_port/proxy'
        '?url=${Uri.encodeComponent(originalUrl)}';
  }

  Future<void> _handleRequest(HttpRequest req) async {
    final sw = Stopwatch()..start();
    final targetUrl = req.uri.queryParameters['url'];
    if (targetUrl == null || targetUrl.isEmpty) {
      req.response.statusCode = 400;
      await req.response.close();
      return;
    }

    final targetUri = Uri.parse(targetUrl);
    final tag = targetUri.path.split('/').last;

    // 解析 mpv 发来的 Range 头
    int startByte = 0;
    int? endByte;
    final rangeHeader = req.headers.value('range');
    if (rangeHeader != null) {
      final match = RegExp(r'bytes=(\d+)-(\d*)').firstMatch(rangeHeader);
      if (match != null) {
        startByte = int.parse(match.group(1)!);
        final endStr = match.group(2)!;
        if (endStr.isNotEmpty) endByte = int.parse(endStr);
      }
    }

    try {
      // 第一次请求获取 Content-Length 和 Content-Type
      final firstResult = await _fetchRange(
        targetUri,
        startByte,
        endByte,
        req.headers,
      );
      if (firstResult == null) {
        req.response.statusCode = 502;
        await req.response.close();
        return;
      }

      final totalLength = firstResult.totalLength;
      final contentType = firstResult.contentType;
      final actualEnd = endByte ?? (totalLength != null ? totalLength - 1 : null);

      // 设置响应头
      if (totalLength != null && startByte == 0 && endByte == null) {
        req.response.statusCode = 200;
        req.response.contentLength = totalLength;
      } else if (totalLength != null) {
        req.response.statusCode = 206;
        req.response.headers.set(
          'content-range',
          'bytes $startByte-${actualEnd ?? '*'}/$totalLength',
        );
        if (actualEnd != null) {
          req.response.contentLength = actualEnd - startByte + 1;
        }
      } else {
        req.response.statusCode = firstResult.statusCode;
      }
      if (contentType != null) {
        req.response.headers.set('content-type', contentType);
      }
      req.response.headers.set('accept-ranges', 'bytes');

      // 断点续传循环（带 CDN 自动回退）
      int bytesSent = 0;
      int retries = 0;
      const maxRetries = 30;
      const cdnSwitchThreshold = 4;
      _FetchResult? current = firstResult;

      final canSwitchCdn = Pref.enableCdnAutoSwitch &&
          _mirrorHostRegex.hasMatch(targetUri.host);
      Uri activeUri = targetUri;
      String currentHost = targetUri.host;
      int hostFailCount = 0;
      int cdnSwitchCount = 0;

      while (current != null) {
        try {
          await for (final chunk in current.stream) {
            bytesSent += chunk.length;
            _totalBytes += chunk.length;
            req.response.add(chunk);
            hostFailCount = 0;
          }
          break;
        } catch (e) {
          retries++;
          hostFailCount++;
          final currentOffset = startByte + bytesSent;

          _netLog.warn('PROXY', 'upstream drop, resuming', extra: {
            'file': tag,
            'bytesSent': bytesSent,
            'resumeAt': currentOffset,
            'retry': retries,
            'host': currentHost,
            'error': e.runtimeType.toString(),
          });

          if (retries > maxRetries) {
            _netLog.error('PROXY', 'max retries exceeded', extra: {
              'file': tag,
              'bytesSent': bytesSent,
            });
            break;
          }

          // 当前 CDN 连续失败达到阈值，尝试切换
          if (canSwitchCdn && hostFailCount >= cdnSwitchThreshold) {
            final nextHost = _pickNextHost(currentHost, cdnSwitchCount);
            if (nextHost != null) {
              final oldHost = currentHost;
              activeUri = activeUri.replace(host: nextHost);
              currentHost = nextHost;
              hostFailCount = 0;
              cdnSwitchCount++;
              _netLog.warn('PROXY', 'CDN switch', extra: {
                'file': tag,
                'from': oldHost,
                'to': nextHost,
                'bytesSent': bytesSent,
              });
            }
          }

          await Future<void>.delayed(
            Duration(milliseconds: (500 * retries).clamp(500, 5000)),
          );

          // 重试连接本身也可能失败，循环重试
          _FetchResult? next;
          for (int ci = 0; ci < 3 && next == null; ci++) {
            next = await _fetchRange(
              activeUri,
              currentOffset,
              actualEnd,
              req.headers,
            );
            if (next == null) {
              retries++;
              hostFailCount++;
              if (retries > maxRetries) break;

              // 连接都建立不了，立刻尝试下一个 CDN
              if (canSwitchCdn && hostFailCount >= cdnSwitchThreshold) {
                final nextHost = _pickNextHost(currentHost, cdnSwitchCount);
                if (nextHost != null) {
                  final oldHost = currentHost;
                  activeUri = activeUri.replace(host: nextHost);
                  currentHost = nextHost;
                  hostFailCount = 0;
                  cdnSwitchCount++;
                  _netLog.warn('PROXY', 'CDN switch (connect fail)', extra: {
                    'file': tag,
                    'from': oldHost,
                    'to': nextHost,
                  });
                }
              }

              await Future<void>.delayed(
                Duration(milliseconds: (1000 * ci + 1000).clamp(1000, 5000)),
              );
            }
          }
          current = next;
          if (current == null) {
            _netLog.error('PROXY', 'reconnect failed', extra: {
              'file': tag,
              'bytesSent': bytesSent,
            });
            break;
          }
        }
      }

      await req.response.close();

      final elapsedMs = sw.elapsedMilliseconds;
      final speedKBs = elapsedMs > 0
          ? (bytesSent / 1024 / elapsedMs * 1000).round()
          : 0;
      _netLog.info('PROXY', 'done', extra: {
        'file': tag,
        'bytes': bytesSent,
        'retries': retries,
        'cdnSwitches': cdnSwitchCount,
        'host': currentHost,
        'totalMs': elapsedMs,
        'speed': '${speedKBs}KB/s',
      });
    } catch (e) {
      _netLog.error('PROXY', 'fatal', extra: {
        'file': tag,
        'error': e.toString().length > 120
            ? e.toString().substring(0, 120)
            : e.toString(),
        'ms': sw.elapsedMilliseconds,
      });
      try {
        req.response.statusCode = 502;
        await req.response.close();
      } catch (_) {}
    }
  }

  /// 从回退列表中选下一个不同于当前的 CDN host。
  /// [switchIndex] 用来避免重复选到同一个。
  String? _pickNextHost(String currentHost, int switchIndex) {
    final candidates = _fallbackHosts
        .where((h) => h != currentHost)
        .toList();
    if (candidates.isEmpty) return null;
    return candidates[switchIndex % candidates.length];
  }

  Future<_FetchResult?> _fetchRange(
    Uri targetUri,
    int rangeStart,
    int? rangeEnd,
    HttpHeaders mpvHeaders,
  ) async {
    try {
      final upReq = await _client!.getUrl(targetUri);

      // 转发 mpv 的请求头（User-Agent / Referer 等）
      mpvHeaders.forEach((name, values) {
        final lower = name.toLowerCase();
        if (lower == 'host' ||
            lower == 'transfer-encoding' ||
            lower == 'range') return;
        for (final v in values) {
          upReq.headers.add(name, v);
        }
      });
      upReq.headers.set('Host', targetUri.host);
      upReq.headers.set('Accept-Encoding', 'identity');

      if (rangeStart > 0 || rangeEnd != null) {
        final rangeSpec = rangeEnd != null
            ? 'bytes=$rangeStart-$rangeEnd'
            : 'bytes=$rangeStart-';
        upReq.headers.set('Range', rangeSpec);
      }

      final resp = await upReq.close();

      // 解析 Content-Range 得到总长度
      int? totalLength;
      final crHeader = resp.headers.value('content-range');
      if (crHeader != null) {
        final match = RegExp(r'/(\d+)').firstMatch(crHeader);
        if (match != null) totalLength = int.parse(match.group(1)!);
      } else if (resp.contentLength >= 0 && rangeStart == 0) {
        totalLength = resp.contentLength;
      }

      return _FetchResult(
        stream: resp,
        statusCode: resp.statusCode,
        totalLength: totalLength,
        contentType: resp.headers.value('content-type'),
      );
    } catch (e) {
      _netLog.error('PROXY', 'connect failed', extra: {
        'uri': targetUri.host,
        'rangeStart': rangeStart,
        'error': e.runtimeType.toString(),
      });
      return null;
    }
  }
}

class _FetchResult {
  final HttpClientResponse stream;
  final int statusCode;
  final int? totalLength;
  final String? contentType;

  _FetchResult({
    required this.stream,
    required this.statusCode,
    this.totalLength,
    this.contentType,
  });
}
