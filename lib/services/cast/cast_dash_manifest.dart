import 'package:PiliPlus/models/video/play/url.dart';

const String castDashContentType = 'application/dash+xml';

class CastDashManifest {
  static String build({
    required VideoItem video,
    required AudioItem audio,
    required String baseUrl,
    Duration? duration,
    Duration? minBufferTime,
  }) {
    final buf = StringBuffer()
      ..write('<MPD xmlns="urn:mpeg:dash:schema:mpd:2011"')
      ..write(' type="static"')
      ..write(' profiles="urn:mpeg:dash:profile:isoff-on-demand:2011"');
    if (duration != null) {
      buf.write(' mediaPresentationDuration="${_formatDuration(duration)}"');
    }
    if (minBufferTime != null) {
      buf.write(' minBufferTime="${_formatDuration(minBufferTime)}"');
    }
    buf
      ..write('>\n')
      ..write('  <Period>\n')
      ..write(_buildAdaptationSet(video, baseUrl, isVideo: true))
      ..write(_buildAdaptationSet(audio, baseUrl, isVideo: false))
      ..write('  </Period>\n')
      ..write('</MPD>\n');
    return buf.toString();
  }

  static String _buildAdaptationSet(
    BaseItem item,
    String baseUrl, {
    required bool isVideo,
  }) {
    final mimeType = (item.mimeType?.isNotEmpty == true)
        ? item.mimeType!
        : (isVideo ? 'video/mp4' : 'audio/mp4');
    final buf = StringBuffer()
      ..write('    <AdaptationSet mimeType="${_escapeXml(mimeType)}">\n')
      ..write(_buildRepresentation(item, baseUrl, isVideo: isVideo))
      ..write('    </AdaptationSet>\n');
    return buf.toString();
  }

  static String _buildRepresentation(
    BaseItem item,
    String baseUrl, {
    required bool isVideo,
  }) {
    final buf = StringBuffer()
      ..write('      <Representation')
      ..write(' id="${item.id ?? 0}"')
      ..write(' bandwidth="${item.bandWidth ?? 0}"');
    if (item.codecs != null) {
      buf.write(' codecs="${_escapeXml(item.codecs!)}"');
    }
    if (isVideo) {
      if (item.width != null) {
        buf.write(' width="${item.width}"');
      }
      if (item.height != null) {
        buf.write(' height="${item.height}"');
      }
      if (item.frameRate != null) {
        buf.write(' frameRate="${_escapeXml(item.frameRate!)}"');
      }
    }
    buf
      ..write('>\n')
      ..write(
        '        <BaseURL>${_escapeXml(_buildBaseUrl(baseUrl, item.baseUrl))}</BaseURL>\n',
      );

    final segmentBaseXml = _buildSegmentBase(item.segmentBase);
    if (segmentBaseXml.isNotEmpty) {
      buf.write(segmentBaseXml);
    }

    buf.write('      </Representation>\n');
    return buf.toString();
  }

  static String _buildBaseUrl(String proxyBaseUrl, String? itemUrl) {
    if (itemUrl == null) return '';
    if (proxyBaseUrl.isEmpty) return itemUrl;
    final uri = Uri.parse(itemUrl);
    final path = uri.path;
    final query = uri.hasQuery ? '?${uri.query}' : '';
    final base = proxyBaseUrl.endsWith('/') ? proxyBaseUrl : '$proxyBaseUrl/';
    final relativePath = path.startsWith('/') ? path.substring(1) : path;
    return '$base$relativePath$query';
  }

  static String _buildSegmentBase(Map? segmentBase) {
    if (segmentBase == null) return '';
    final indexRange = segmentBase['indexRange'] ?? segmentBase['index_range'];
    if (indexRange == null) return '';

    final buf = StringBuffer()
      ..write(
        '        <SegmentBase indexRange="${_escapeXml('$indexRange')}">\n',
      );
    final initialization =
        segmentBase['Initialization'] ?? segmentBase['initialization'];
    if (initialization != null) {
      buf.write(
        '          <Initialization range="${_escapeXml('$initialization')}"/>\n',
      );
    }
    buf.write('        </SegmentBase>\n');
    return buf.toString();
  }

  static String _escapeXml(String value) {
    return value
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&apos;');
  }

  static String _formatDuration(Duration d) {
    final buf = StringBuffer('PT');
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inMilliseconds.remainder(60000) / 1000.0;
    if (hours > 0) buf.write('${hours}H');
    if (minutes > 0) buf.write('${minutes}M');
    if (seconds > 0 || (hours == 0 && minutes == 0)) {
      if (seconds == seconds.truncateToDouble()) {
        buf.write('${seconds.toInt()}S');
      } else {
        buf.write('${seconds}S');
      }
    }
    return buf.toString();
  }
}
