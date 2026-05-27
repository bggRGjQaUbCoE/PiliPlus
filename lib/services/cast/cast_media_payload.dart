// ignore_for_file: prefer_initializing_formals

class CastMediaPayload {
  final Uri url;
  final String title;
  final Uri? cover;
  final Duration position;
  final Duration? duration;
  final int? qualityCode;
  final String? _contentType;

  CastMediaPayload({
    required this.url,
    required this.title,
    this.cover,
    this.position = Duration.zero,
    this.duration,
    this.qualityCode,
    String? contentType,
  }) : _contentType = contentType;

  String get contentId => url.toString();

  String get contentType {
    final explicitType = _contentType;
    if (explicitType != null) return explicitType;
    final path = url.path.toLowerCase();
    if (path.endsWith('.m3u8')) return 'application/x-mpegURL';
    if (path.endsWith('.mpd')) return 'application/dash+xml';
    if (path.endsWith('.mp4')) return 'video/mp4';
    if (path.endsWith('.webm')) return 'video/webm';
    if (path.endsWith('.flv')) return 'video/x-flv';
    return 'application/octet-stream';
  }

  Map<String, dynamic> get customData {
    final data = <String, dynamic>{'title': title};
    if (qualityCode != null) {
      data['qualityCode'] = qualityCode;
    }
    return data;
  }

  CastMediaPayload copyWith({
    Uri? url,
    String? title,
    Uri? cover,
    Duration? position,
    Duration? duration,
    int? qualityCode,
    bool clearCover = false,
    bool clearDuration = false,
    bool clearQualityCode = false,
    String? contentType,
    bool clearContentType = false,
  }) {
    return CastMediaPayload(
      url: url ?? this.url,
      title: title ?? this.title,
      cover: clearCover ? null : (cover ?? this.cover),
      position: position ?? this.position,
      duration: clearDuration ? null : (duration ?? this.duration),
      qualityCode: clearQualityCode ? null : (qualityCode ?? this.qualityCode),
      contentType: clearContentType ? null : (contentType ?? _contentType),
    );
  }
}
