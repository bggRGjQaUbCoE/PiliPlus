import 'dart:io';
import 'dart:typed_data';

import 'package:PiliPlus/models/video/play/url.dart';
import 'package:PiliPlus/utils/ubuntu_touch.dart';

const _playerUa = 'GStreamer/1.16.3';

class UbuntuTouchDashMpd {
  const UbuntuTouchDashMpd({
    required this.path,
    required this.bytes,
    required this.videoSegments,
    required this.audioSegments,
    required this.seconds,
  });

  final String path;
  final int bytes;
  final int videoSegments;
  final int audioSegments;
  final double seconds;
}

/// Writes the SegmentList manifest that already played on this phone.
///
/// Each `media` and the initialization `sourceURL` is the absolute address,
/// query included. GStreamer 1.16 drops a BaseURL query and then has no
/// picture. Returns null when the index or the last segment is not readable.
Future<UbuntuTouchDashMpd?> writeUbuntuTouchDashMpd({
  required String name,
  required VideoItem video,
  required AudioItem audio,
}) async {
  final videoTrack = await _track(video);
  final audioTrack = await _track(audio);
  if (videoTrack == null || audioTrack == null) {
    print(
      'piliplus: dash index missing video=${videoTrack != null} '
      'audio=${audioTrack != null}',
    );
    return null;
  }
  final videoUrl = await _usableUrl(video, videoTrack);
  final audioUrl = await _usableUrl(audio, audioTrack);
  if (videoUrl == null || audioUrl == null) {
    print(
      'piliplus: dash tail missing video=${videoUrl != null} '
      'audio=${audioUrl != null}',
    );
    return null;
  }
  final seconds = videoTrack.seconds;
  final xml = '''
<?xml version="1.0" encoding="UTF-8"?>
<MPD xmlns="urn:mpeg:dash:schema:mpd:2011" type="static" mediaPresentationDuration="PT${seconds.toStringAsFixed(3)}S" minBufferTime="PT2S" profiles="urn:mpeg:dash:profile:isoff-on-demand:2011">
  <Period>
    <AdaptationSet mimeType="video/mp4" contentType="video">
      <Representation id="v" bandwidth="${video.bandWidth ?? 1}" width="${video.width ?? 0}" height="${video.height ?? 0}" codecs="${_xml(video.codecs ?? 'avc1')}">
        ${_segmentList(videoUrl, videoTrack)}
      </Representation>
    </AdaptationSet>
    <AdaptationSet mimeType="audio/mp4" contentType="audio">
      <Representation id="a" bandwidth="${audio.bandWidth ?? 1}" codecs="${_xml(audio.codecs ?? 'mp4a.40.2')}" audioSamplingRate="${audioTrack.timescale}">
        ${_segmentList(audioUrl, audioTrack)}
      </Representation>
    </AdaptationSet>
  </Period>
</MPD>
''';
  final dir = Directory('${UbuntuTouch.cacheHome}/dash');
  await dir.create(recursive: true);
  final safe = name.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '');
  final file = File('${dir.path}/$safe.mpd');
  await file.writeAsString(xml, flush: true);
  for (final entity in dir.listSync(followLinks: false)) {
    if (entity is! File || entity.path == file.path) continue;
    if (!entity.path.endsWith('.mpd')) continue;
    try {
      entity.deleteSync();
    } catch (_) {}
  }
  return UbuntuTouchDashMpd(
    path: file.path,
    bytes: xml.length,
    videoSegments: videoTrack.segments.length,
    audioSegments: audioTrack.segments.length,
    seconds: seconds,
  );
}

String _segmentList(String url, _Track track) {
  final timeline = StringBuffer();
  final urls = StringBuffer();
  for (var i = 0; i < track.segments.length; i++) {
    final seg = track.segments[i];
    if (i == 0) {
      timeline.writeln('<S t="0" d="${seg.duration}"/>');
    } else {
      timeline.writeln('<S d="${seg.duration}"/>');
    }
    urls.writeln(
      '<SegmentURL media="${_xml(url)}" mediaRange="${seg.start}-${seg.end}"/>',
    );
  }
  return '''
<SegmentList timescale="${track.timescale}">
          <Initialization sourceURL="${_xml(url)}" range="${track.initStart}-${track.initEnd}"/>
          <SegmentTimeline>
            ${timeline.toString().trim()}
          </SegmentTimeline>
          ${urls.toString().trim()}
        </SegmentList>''';
}

String _xml(String value) {
  return value
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;');
}

Future<_Track?> _track(BaseItem item) async {
  final init = _byteRange(item.segmentBase, 'initialization', 'Initialization');
  final index = _byteRange(item.segmentBase, 'index_range', 'indexRange');
  if (init == null || index == null) return null;
  Uint8List? bytes;
  for (final url in item.playUrls) {
    bytes = await _fetchRange(url, index.$1, index.$2);
    if (bytes != null) break;
  }
  if (bytes == null) return null;
  final sidx = _parseSidx(bytes, index.$2);
  if (sidx == null) return null;
  return _Track(init.$1, init.$2, sidx.timescale, sidx.segments);
}

Future<String?> _usableUrl(BaseItem item, _Track track) async {
  if (track.segments.isEmpty) return null;
  final last = track.segments.last;
  final end = last.start + 15 <= last.end ? last.start + 15 : last.end;
  for (final url in item.playUrls) {
    final status = await _probe(url, last.start, end);
    if (status == 206) return url;
    print('piliplus: dash tail status=$status');
  }
  return null;
}

Future<int?> _probe(String url, int start, int end) async {
  try {
    final response = await _rawRange(url, start, end).timeout(
      const Duration(seconds: 15),
    );
    return response?.status;
  } catch (error) {
    print('piliplus: dash tail failed type=${error.runtimeType}');
    return null;
  }
}

Future<Uint8List?> _fetchRange(String? url, int start, int end) async {
  if (url == null || url.isEmpty) return null;
  if (end < start || end - start > 2 * 1024 * 1024) return null;
  try {
    final response = await _rawRange(url, start, end).timeout(
      const Duration(seconds: 20),
    );
    if (response == null) return null;
    if (response.status != 206 && response.status != 200) {
      print(
        'piliplus: dash index status=${response.status} '
        'host=${Uri.parse(url).host}',
      );
      return null;
    }
    final bytes = response.body;
    if (response.status == 200 && start > 0) {
      if (bytes.length < end + 1) return null;
      return Uint8List.sublistView(bytes, start, end + 1);
    }
    return bytes;
  } catch (error) {
    print('piliplus: dash index failed type=${error.runtimeType}');
    return null;
  }
}

class _Raw {
  const _Raw(this.status, this.body);
  final int status;
  final Uint8List body;
}

/// Sends the path and query exactly as they arrived. [Uri] would re-encode
/// the signed query and the CDN answers 403.
Future<_Raw?> _rawRange(String url, int start, int end) async {
  final uri = Uri.parse(url);
  final slash = url.indexOf('/', url.indexOf('://') + 3);
  if (slash < 0) return null;
  final pathAndQuery = url.substring(slash);
  final socket = uri.scheme == 'https'
      ? await SecureSocket.connect(
          uri.host,
          uri.hasPort ? uri.port : 443,
          timeout: const Duration(seconds: 15),
        )
      : await Socket.connect(
          uri.host,
          uri.hasPort ? uri.port : 80,
          timeout: const Duration(seconds: 15),
        );
  try {
    socket.write(
      'GET $pathAndQuery HTTP/1.1\r\n'
      'Host: ${uri.host}\r\n'
      'User-Agent: $_playerUa\r\n'
      'Range: bytes=$start-$end\r\n'
      'Connection: close\r\n'
      '\r\n',
    );
    final data = await _readAll(socket);
    final split = _headerEnd(data);
    if (split < 0) return null;
    final header = String.fromCharCodes(data.sublist(0, split));
    final line = header.split('\r\n').first.split(' ');
    if (line.length < 2) return null;
    final status = int.tryParse(line[1]);
    if (status == null) return null;
    var body = Uint8List.sublistView(data, split + 4);
    if (header.toLowerCase().contains('transfer-encoding: chunked')) {
      body = _decodeChunks(body);
    }
    return _Raw(status, body);
  } finally {
    await socket.close();
  }
}

Future<Uint8List> _readAll(Socket socket) async {
  final builder = BytesBuilder(copy: false);
  await for (final chunk in socket) {
    builder.add(chunk);
    if (builder.length > 3 * 1024 * 1024) break;
  }
  return builder.takeBytes();
}

Uint8List _decodeChunks(Uint8List data) {
  final builder = BytesBuilder(copy: false);
  var i = 0;
  while (i < data.length) {
    final lineEnd = data.indexOf(10, i);
    if (lineEnd < 0) break;
    final sizeText = String.fromCharCodes(data.sublist(i, lineEnd)).trim();
    final size = int.tryParse(sizeText, radix: 16);
    if (size == null || size == 0) break;
    final start = lineEnd + 1;
    if (start + size > data.length) break;
    builder.add(Uint8List.sublistView(data, start, start + size));
    i = start + size + 2;
  }
  return builder.takeBytes();
}

int _headerEnd(Uint8List data) {
  for (var i = 0; i + 3 < data.length; i++) {
    if (data[i] == 13 &&
        data[i + 1] == 10 &&
        data[i + 2] == 13 &&
        data[i + 3] == 10) {
      return i;
    }
  }
  return -1;
}

(int, int)? _byteRange(Map? base, String snake, String camel) {
  final raw = base?[snake] ?? base?[camel];
  if (raw is! String) return null;
  final parts = raw.split('-');
  if (parts.length != 2) return null;
  final start = int.tryParse(parts[0]);
  final end = int.tryParse(parts[1]);
  if (start == null || end == null || end < start) return null;
  return (start, end);
}

class _Seg {
  const _Seg(this.start, this.end, this.duration);
  final int start;
  final int end;
  final int duration;
}

class _Sidx {
  const _Sidx(this.timescale, this.segments);
  final int timescale;
  final List<_Seg> segments;
}

class _Track {
  const _Track(this.initStart, this.initEnd, this.timescale, this.segments);
  final int initStart;
  final int initEnd;
  final int timescale;
  final List<_Seg> segments;

  double get seconds {
    var ticks = 0;
    for (final seg in segments) {
      ticks += seg.duration;
    }
    return timescale == 0 ? 0 : ticks / timescale;
  }
}

_Sidx? _parseSidx(Uint8List data, int indexEnd) {
  if (data.length < 32) return null;
  if (data[4] != 0x73 ||
      data[5] != 0x69 ||
      data[6] != 0x64 ||
      data[7] != 0x78) {
    return null;
  }
  final version = data[8];
  var p = 16;
  final timescale = _u32(data, p);
  p += 4;
  if (version == 0) {
    p += 4;
  } else {
    if (data.length < p + 8) return null;
    p += 8;
  }
  if (data.length < p + 4) return null;
  final firstOffset = version == 0 ? _u32(data, p) : _u64(data, p);
  p += version == 0 ? 4 : 8;
  if (data.length < p + 4) return null;
  p += 2;
  final count = _u16(data, p);
  p += 2;
  if (count <= 0 || count > 10000 || timescale == 0) return null;
  var byte = indexEnd + 1 + firstOffset;
  final segments = <_Seg>[];
  for (var i = 0; i < count; i++) {
    if (data.length < p + 12) return null;
    final size = _u32(data, p) & 0x7fffffff;
    p += 4;
    final duration = _u32(data, p);
    p += 8;
    if (size <= 0 || duration <= 0) return null;
    segments.add(_Seg(byte, byte + size - 1, duration));
    byte += size;
  }
  return _Sidx(timescale, segments);
}

int _u16(Uint8List data, int offset) {
  return (data[offset] << 8) | data[offset + 1];
}

int _u32(Uint8List data, int offset) {
  return (data[offset] << 24) |
      (data[offset + 1] << 16) |
      (data[offset + 2] << 8) |
      data[offset + 3];
}

int _u64(Uint8List data, int offset) {
  return (_u32(data, offset) << 32) | _u32(data, offset + 4);
}
