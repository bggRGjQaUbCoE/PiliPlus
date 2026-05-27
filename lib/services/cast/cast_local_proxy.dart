import 'dart:convert';
import 'dart:io';

import 'package:PiliPlus/http/browser_ua.dart';
import 'package:crypto/crypto.dart';

class CastLocalProxyPolicy {
  static const String dashProxyPathPrefix = '/cast/dash/proxy';

  static const Map<String, String> corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, HEAD, OPTIONS',
    'Access-Control-Allow-Headers': 'Range',
    'Access-Control-Expose-Headers':
        'Content-Type, Content-Length, Content-Range, Accept-Ranges',
  };

  static bool shouldProxy(String url) {
    if (url.isEmpty) return false;
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) return false;
    final scheme = uri.scheme.toLowerCase();
    if (scheme != 'http' && scheme != 'https') return false;
    final path = uri.path.toLowerCase();
    if (path.endsWith('.mpd')) return false;
    return path.endsWith('.m4s') ||
        path.endsWith('.mp4') ||
        path.endsWith('.m4a') ||
        path.endsWith('.webm') ||
        path.endsWith('.flv') ||
        path.endsWith('.m3u8');
  }

  static Uri buildProxyUrl(
    String remoteUrl, {
    required String proxyHost,
    required int proxyPort,
  }) {
    final encoded = base64Url
        .encode(utf8.encode(remoteUrl))
        .replaceAll('=', '');
    return Uri(
      scheme: 'http',
      host: proxyHost,
      port: proxyPort,
      path: '$dashProxyPathPrefix/$encoded',
    );
  }

  static String? extractRemoteUrl(String path) {
    const prefix = '$dashProxyPathPrefix/';
    if (!path.startsWith(prefix)) return null;
    final encoded = path.substring(prefix.length);
    if (encoded.isEmpty) return null;
    try {
      final mod = encoded.length % 4;
      final padded = mod == 0 ? encoded : encoded + '=' * (4 - mod);
      final bytes = base64Url.decode(padded);
      return utf8.decode(bytes);
    } catch (_) {
      return null;
    }
  }
}

class CastLocalProxyServer {
  static final CastLocalProxyServer instance = CastLocalProxyServer._();
  CastLocalProxyServer._();

  HttpServer? _server;
  final HttpClient _httpClient = HttpClient();
  final Map<String, String> _manifests = {};
  String? _lanHost;

  bool get isRunning => _server != null;
  int get port => _server?.port ?? 0;

  Future<void> ensureStarted() async {
    if (_server != null) return;

    if (_lanHost == null) {
      try {
        final interfaces = await NetworkInterface.list();
        for (final interface in interfaces) {
          for (final addr in interface.addresses) {
            if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
              _lanHost = addr.address;
              break;
            }
          }
          if (_lanHost != null) break;
        }
      } catch (_) {}
      _lanHost ??= InternetAddress.loopbackIPv4.address;
    }

    _server = await HttpServer.bind(InternetAddress.anyIPv4, 0);
    _server!.listen(_handleRequest);
  }

  Uri buildProxyUri(String remoteUrl) {
    return CastLocalProxyPolicy.buildProxyUrl(
      remoteUrl,
      proxyHost: _lanHost ?? InternetAddress.loopbackIPv4.address,
      proxyPort: port,
    );
  }

  Uri registerManifest(String manifest) {
    final key = _manifestKey(manifest);
    _manifests[key] = manifest;
    return Uri(
      scheme: 'http',
      host: _lanHost ?? InternetAddress.loopbackIPv4.address,
      port: port,
      path: '/cast/dash/manifest/$key.mpd',
    );
  }

  String _manifestKey(String manifest) {
    return sha1.convert(utf8.encode(manifest)).toString();
  }

  Future<void> _handleRequest(HttpRequest request) async {
    final response = request.response;
    CastLocalProxyPolicy.corsHeaders.forEach(response.headers.set);

    if (request.method == 'OPTIONS') {
      response.statusCode = 204;
      await response.close();
      return;
    }

    if (request.method != 'GET' && request.method != 'HEAD') {
      response.statusCode = 405;
      await response.close();
      return;
    }

    final path = request.uri.path;

    if (path.startsWith('/cast/dash/manifest/') && path.endsWith('.mpd')) {
      await _serveManifest(request, path);
      return;
    }

    final remoteUrl = CastLocalProxyPolicy.extractRemoteUrl(path);
    if (remoteUrl != null && CastLocalProxyPolicy.shouldProxy(remoteUrl)) {
      await _serveProxy(request, remoteUrl);
      return;
    }

    response.statusCode = 404;
    await response.close();
  }

  Future<void> _serveManifest(HttpRequest request, String path) async {
    final response = request.response;
    const prefix = '/cast/dash/manifest/';
    const suffix = '.mpd';
    final key = path.substring(prefix.length, path.length - suffix.length);
    final manifest = _manifests[key];
    if (manifest == null) {
      response.statusCode = 404;
      await response.close();
      return;
    }

    response.headers.contentType = ContentType('application', 'dash+xml');
    if (request.method == 'GET') {
      response.write(manifest);
    }
    await response.close();
  }

  Future<void> _serveProxy(HttpRequest request, String remoteUrl) async {
    final response = request.response;

    try {
      final clientRequest = await _httpClient.openUrl(
        request.method,
        Uri.parse(remoteUrl),
      );
      clientRequest.headers.set('Referer', 'https://www.bilibili.com');
      clientRequest.headers.set('User-Agent', BrowserUa.pc);

      final rangeHeader = request.headers.value('Range');
      if (rangeHeader != null) {
        clientRequest.headers.set('Range', rangeHeader);
      }

      final clientResponse = await clientRequest.close();

      response.statusCode = clientResponse.statusCode;

      const copyHeaders = [
        'Content-Type',
        'Content-Length',
        'Content-Range',
        'Accept-Ranges',
      ];
      for (final header in copyHeaders) {
        final value = clientResponse.headers.value(header);
        if (value != null) {
          response.headers.set(header, value);
        }
      }

      if (request.method == 'GET') {
        await response.addStream(clientResponse);
      }
      await response.close();
    } catch (_) {
      try {
        response.statusCode = 502;
      } catch (_) {}
      try {
        await response.close();
      } catch (_) {}
    }
  }

  Future<void> stop() async {
    _httpClient.close(force: true);
    await _server?.close(force: true);
    _server = null;
  }
}
