import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:PiliPlus/http/browser_ua.dart';
import 'package:PiliPlus/utils/ios/sidx_parser.dart';

/// One already-authorized CDN track. Signed URLs are never rewritten.
class AirPlayTrack {
  const AirPlayTrack({
    required this.url,
    required this.codecs,
    required this.bandwidth,
    this.width = 0,
    this.height = 0,
  });

  final String url;
  final String codecs;
  final int bandwidth;
  final int width;
  final int height;
}

const airPlaySubtitleSegmentSeconds = 30;

typedef AirPlaySubtitleLoader = Future<String> Function(int segment);

/// Serves one AirPlay session on Wi-Fi. It forwards bytes without decoding or
/// encoding, and supplies the Referer required by Bilibili's DASH CDN.
/// Only fixed track paths under a random session token are reachable.
class AirPlayHlsSession {
  AirPlayHlsSession._(this._server, this._client, this._token);

  final HttpServer _server;
  final HttpClient _client;
  final String _token;
  final Map<String, AirPlayTrack> _tracks = {};
  final Map<String, String> _playlists = {};
  final Map<int, Future<String>> _subtitles = {};
  AirPlaySubtitleLoader? _subtitleLoader;
  int _subtitleCount = 0;
  bool _closed = false;
  void Function(String)? _onDiagnostic;
  int _diagnosticCount = 0;

  void _trace(String message) {
    if (_diagnosticCount++ < 32) _onDiagnostic?.call(message);
  }

  String get url =>
      'http://${_server.address.address}:${_server.port}/$_token/master.m3u8';

  static Future<AirPlayHlsSession> start({
    required AirPlayTrack video,
    required AirPlayTrack audio,
    AirPlaySubtitleLoader? subtitles,
    InternetAddress? address,
    void Function(String)? onDiagnostic,
  }) async {
    final bindAddress = address ?? await _wifiAddress();
    final server = await HttpServer.bind(bindAddress, 0);
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 12)
      ..autoUncompress = false;
    final random = Random.secure();
    final token = List.generate(
      24,
      (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join();
    final session = AirPlayHlsSession._(server, client, token)
      .._onDiagnostic = onDiagnostic;
    try {
      final indexes = await Future.wait([
        session._prepareTrack('video', video),
        session._prepareTrack('audio', audio),
      ]);
      session._subtitleLoader = subtitles;
      final duration = indexes.first.segments.last.endTime;
      session._subtitleCount = (duration / airPlaySubtitleSegmentSeconds)
          .ceil();
      session._playlists['master.m3u8'] = airPlayMasterPlaylist(
        video: video,
        audio: audio,
        subtitles: subtitles != null,
      );
      if (subtitles != null) {
        final lines = <String>[
          '#EXTM3U',
          '#EXT-X-VERSION:7',
          '#EXT-X-TARGETDURATION:$airPlaySubtitleSegmentSeconds',
          '#EXT-X-PLAYLIST-TYPE:VOD',
          '#EXT-X-MEDIA-SEQUENCE:0',
        ];
        for (var i = 0; i < session._subtitleCount; i++) {
          lines
            ..add(
              '#EXTINF:${min(airPlaySubtitleSegmentSeconds, duration - i * airPlaySubtitleSegmentSeconds).toStringAsFixed(3)},',
            )
            ..add('danmaku-$i.vtt');
        }
        lines.add('#EXT-X-ENDLIST');
        session._playlists['danmaku.m3u8'] = '${lines.join('\n')}\n';
      }
      server.listen(session._serve, onError: (Object _) {});
      return session;
    } catch (_) {
      await session.close();
      rethrow;
    }
  }

  static Future<InternetAddress> _wifiAddress() async {
    final interfaces = await NetworkInterface.list(
      type: InternetAddressType.IPv4,
      includeLinkLocal: false,
    );
    for (final interface in interfaces) {
      // iOS Wi-Fi is en0. Do not expose a server on a VPN or cellular interface.
      if (interface.name == 'en0') {
        for (final address in interface.addresses) {
          if (isPrivateAirPlayAddress(address.address)) return address;
        }
      }
    }
    throw const SocketException('未获取到可用的 Wi-Fi 局域网地址，请连接 Wi-Fi 后重试');
  }

  Future<SidxResult> _prepareTrack(String name, AirPlayTrack track) async {
    final uri = Uri.parse(track.url);
    if (uri.scheme != 'https' || uri.host.isEmpty) {
      throw const FormatException('高清投屏需要 HTTPS 视频源');
    }
    final request = await _client.getUrl(uri);
    _setHeaders(request);
    request.headers.set(HttpHeaders.rangeHeader, 'bytes=0-262143');
    final response = await request.close().timeout(const Duration(seconds: 15));
    if (response.statusCode != 200 && response.statusCode != 206) {
      await response.drain<void>();
      throw HttpException('无法读取投屏视频索引：HTTP ${response.statusCode}');
    }
    final bytes = BytesBuilder(copy: false);
    await for (final chunk in response.timeout(const Duration(seconds: 15))) {
      bytes.add(chunk);
      if (bytes.length >= 262144) break;
    }
    final head = bytes.takeBytes();
    final index = SidxParser.parseSidx(head);
    final initLength = airPlayInitLength(head);
    if (index == null || initLength == null) {
      throw const FormatException('此视频缺少可用于 AirPlay 的分段索引');
    }
    _tracks['$name.m4s'] = track;
    _playlists['$name.m3u8'] = airPlayMediaPlaylist(
      index,
      mediaPath: '$name.m4s',
      initLength: initLength,
    );
    return index;
  }

  static void _setHeaders(HttpClientRequest request) {
    request.headers
      ..set(HttpHeaders.userAgentHeader, BrowserUa.pc)
      ..set(HttpHeaders.refererHeader, 'https://www.bilibili.com/');
  }

  Future<void> _serve(HttpRequest request) async {
    final response = request.response;
    try {
      final path = request.uri.pathSegments;
      if (_closed || path.length != 2 || path.first != _token) {
        response.statusCode = HttpStatus.notFound;
        return;
      }
      if (request.method != 'GET' && request.method != 'HEAD') {
        response.statusCode = HttpStatus.methodNotAllowed;
        return;
      }
      final name = path.last;
      if (_playlists[name] case final playlist?) {
        if (name == 'danmaku.m3u8') _trace('playlist ${request.method}');
        _text(
          response,
          playlist,
          'application/vnd.apple.mpegurl',
          request.method,
        );
      } else if (_tracks[name] case final track?) {
        final upstream = await _client.openUrl(
          request.method,
          Uri.parse(track.url),
        );
        _setHeaders(upstream);
        if (request.headers.value(HttpHeaders.rangeHeader) case final range?) {
          // AVPlayer uses a single byte range. Never forward arbitrary headers.
          if (!RegExp(r'^bytes=\d+-\d*$').hasMatch(range)) {
            response.statusCode = HttpStatus.requestedRangeNotSatisfiable;
            upstream.abort();
            return;
          }
          upstream.headers.set(HttpHeaders.rangeHeader, range);
        }
        final source = await upstream.close().timeout(
          const Duration(seconds: 15),
        );
        response.statusCode = source.statusCode;
        for (final header in [
          HttpHeaders.contentTypeHeader,
          HttpHeaders.contentRangeHeader,
          HttpHeaders.contentLengthHeader,
          HttpHeaders.acceptRangesHeader,
        ]) {
          if (source.headers.value(header) case final value?) {
            response.headers.set(header, value);
          }
        }
        await response.addStream(source.timeout(const Duration(seconds: 20)));
      } else {
        final match = RegExp(r'^danmaku-(\d+)\.vtt$').firstMatch(name);
        final segment = match == null ? null : int.tryParse(match.group(1)!);
        final loader = _subtitleLoader;
        if (loader == null || segment == null || segment >= _subtitleCount) {
          response.statusCode = HttpStatus.notFound;
          return;
        }
        final pending = _subtitles[segment] ??= loader(segment);
        final String text;
        try {
          text = await pending;
        } catch (_) {
          if (identical(_subtitles[segment], pending)) {
            _subtitles.remove(segment);
          }
          rethrow;
        }
        // Keep a bounded cache; seeking back can fetch a previous segment again.
        if (_subtitles.length > 4) {
          _subtitles.remove(
            _subtitles.keys.firstWhere((key) => key != segment),
          );
        }
        _trace(
          'vtt $segment cues=${' --> '.allMatches(text).length} '
          'bytes=${utf8.encode(text).length}',
        );
        _text(response, text, 'text/vtt; charset=utf-8', request.method);
      }
    } catch (error) {
      _trace('serve failed ${error.runtimeType}');
      try {
        response.statusCode = HttpStatus.badGateway;
      } catch (_) {}
    } finally {
      try {
        await response.close();
      } catch (_) {}
    }
  }

  static void _text(
    HttpResponse response,
    String value,
    String type,
    String method,
  ) {
    final bytes = utf8.encode(value);
    response.headers.set(HttpHeaders.contentTypeHeader, type);
    response.contentLength = bytes.length;
    if (method != 'HEAD') response.add(bytes);
  }

  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    _client.close(force: true);
    await _server.close(force: true);
    _subtitles.clear();
  }
}

bool isPrivateAirPlayAddress(String host) {
  final address = InternetAddress.tryParse(host);
  if (address == null || address.type != InternetAddressType.IPv4) return false;
  final bytes = address.rawAddress;
  return bytes[0] == 10 ||
      (bytes[0] == 172 && bytes[1] >= 16 && bytes[1] <= 31) ||
      (bytes[0] == 192 && bytes[1] == 168);
}

/// The HLS initialization is the complete ftyp + moov preceding sidx.
int? airPlayInitLength(Uint8List bytes) {
  final data = ByteData.sublistView(bytes);
  var offset = 0;
  var hasMovie = false;
  while (offset + 8 <= bytes.length) {
    var size = data.getUint32(offset);
    final type = String.fromCharCodes(bytes.sublist(offset + 4, offset + 8));
    if (size == 1) {
      if (offset + 16 > bytes.length) return null;
      size = data.getUint64(offset + 8);
    }
    if (size < 8 || offset + size > bytes.length) return null;
    if (type == 'moov') hasMovie = true;
    if (type == 'sidx') return hasMovie ? offset : null;
    offset += size;
  }
  return null;
}

String airPlayMasterPlaylist({
  required AirPlayTrack video,
  required AirPlayTrack audio,
  bool subtitles = false,
}) => [
  '#EXTM3U',
  '#EXT-X-VERSION:7',
  '#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="audio",NAME="Audio",DEFAULT=YES,AUTOSELECT=YES,URI="audio.m3u8"',
  if (subtitles) '#EXT-X-MEDIA:TYPE=SUBTITLES,GROUP-ID="danmaku",NAME="弹幕（测试）",LANGUAGE="zh",DEFAULT=YES,AUTOSELECT=YES,URI="danmaku.m3u8"',
  '#EXT-X-STREAM-INF:BANDWIDTH=${video.bandwidth + audio.bandwidth},RESOLUTION=${video.width}x${video.height},CODECS="${video.codecs},${audio.codecs}",AUDIO="audio"${subtitles ? ',SUBTITLES="danmaku"' : ''}',
  'video.m3u8',
  '',
].join('\n');

String airPlayMediaPlaylist(
  SidxResult index, {
  required String mediaPath,
  required int initLength,
}) => [
  '#EXTM3U',
  '#EXT-X-VERSION:7',
  '#EXT-X-PLAYLIST-TYPE:VOD',
  '#EXT-X-TARGETDURATION:${index.segments.map((s) => s.durationSeconds).reduce(max).ceil()}',
  '#EXT-X-MEDIA-SEQUENCE:0',
  '#EXT-X-MAP:URI="$mediaPath",BYTERANGE="$initLength@0"',
  for (final segment in index.segments) ...[
    '#EXTINF:${segment.durationSeconds.toStringAsFixed(6)},',
    '#EXT-X-BYTERANGE:${segment.length}@${segment.start}',
    mediaPath,
  ],
  '#EXT-X-ENDLIST',
  '',
].join('\n');
