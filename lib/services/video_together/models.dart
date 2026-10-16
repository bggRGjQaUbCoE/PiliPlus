enum VideoTogetherRole { none, host, member }

enum VideoTogetherConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
  error,
}

final class VideoTogetherRoom {
  const VideoTogetherRoom({
    required this.name,
    required this.lastUpdateClientTime,
    required this.lastUpdateServerTime,
    required this.playbackRate,
    required this.currentTime,
    required this.paused,
    required this.url,
    required this.duration,
    required this.isPublic,
    required this.isProtected,
    required this.videoTitle,
    required this.waitForLoading,
    required this.memberCount,
    this.uuid = '',
    this.m3u8Url = '',
    this.timestamp,
  });

  factory VideoTogetherRoom.fromJson(Map<String, dynamic> json) {
    return VideoTogetherRoom(
      name: json['name'] as String? ?? '',
      lastUpdateClientTime: _toDouble(json['lastUpdateClientTime']),
      lastUpdateServerTime: _toDouble(json['lastUpdateServerTime']),
      playbackRate: _toDouble(json['playbackRate'], fallback: 1),
      currentTime: _toDouble(json['currentTime']),
      paused: json['paused'] as bool? ?? true,
      url: json['url'] as String? ?? '',
      duration: _toDouble(json['duration']),
      isPublic: json['public'] as bool? ?? false,
      isProtected: json['protected'] as bool? ?? false,
      videoTitle: json['videoTitle'] as String? ?? '',
      waitForLoading: json['waitForLoadding'] as bool? ?? false,
      memberCount: _toInt(json['memberCount']),
      uuid: json['uuid'] as String? ?? '',
      m3u8Url: json['m3u8Url'] as String? ?? '',
      timestamp: json['timestamp'] == null
          ? null
          : _toDouble(json['timestamp']),
    );
  }

  final String name;
  final double lastUpdateClientTime;
  final double lastUpdateServerTime;
  final double playbackRate;
  final double currentTime;
  final bool paused;
  final String url;
  final double duration;
  final bool isPublic;
  final bool isProtected;
  final String videoTitle;
  final bool waitForLoading;
  final int memberCount;
  final String uuid;
  final String m3u8Url;
  final double? timestamp;

  double targetPosition(double serverNow) {
    if (paused) return currentTime;
    final elapsed = (serverNow - lastUpdateClientTime).clamp(
      0,
      double.infinity,
    );
    final position = currentTime + elapsed * playbackRate;
    if (duration <= 0 || !duration.isFinite) return position;
    return position.clamp(0, duration);
  }
}

final class VideoTogetherMedia {
  const VideoTogetherMedia({required this.url, required this.title});

  final String url;
  final String title;
}

final class VideoTogetherTextMessage {
  const VideoTogetherTextMessage({
    required this.sender,
    required this.text,
    required this.receivedAt,
    required this.isMine,
  });

  final String sender;
  final String text;
  final DateTime receivedAt;
  final bool isMine;
}

final class VideoTogetherMediaIdentity {
  const VideoTogetherMediaIdentity._({
    required this.kind,
    required this.id,
    required this.part,
  });

  factory VideoTogetherMediaIdentity.fromUrl(String value) {
    final uri = Uri.tryParse(value.trim());
    if (uri == null) {
      return VideoTogetherMediaIdentity._(
        kind: 'raw',
        id: value.trim(),
        part: 1,
      );
    }

    final path = uri.path;
    final videoMatch = RegExp(
      r'/video/(BV[0-9A-Za-z]+|av\d+)',
      caseSensitive: false,
    ).firstMatch(path);
    if (videoMatch != null) {
      return VideoTogetherMediaIdentity._(
        kind: 'video',
        id: videoMatch.group(1)!.toUpperCase(),
        part: int.tryParse(uri.queryParameters['p'] ?? '') ?? 1,
      );
    }

    final pgcMatch = RegExp(
      r'/bangumi/play/(ep|ss)(\d+)',
      caseSensitive: false,
    ).firstMatch(path);
    if (pgcMatch != null) {
      return VideoTogetherMediaIdentity._(
        kind: pgcMatch.group(1)!.toLowerCase(),
        id: pgcMatch.group(2)!,
        part: 1,
      );
    }

    final query = <String, String>{
      for (final entry in uri.queryParameters.entries)
        if (!entry.key.startsWith('VideoTogether') &&
            entry.key != 'spm_id_from' &&
            entry.key != 'vd_source')
          entry.key: entry.value,
    };
    final keys = query.keys.toList()..sort();
    final normalizedQuery = <String, String>{
      for (final key in keys) key: query[key]!,
    };
    final normalized = Uri(
      scheme: uri.scheme.toLowerCase(),
      userInfo: uri.userInfo,
      host: uri.host.toLowerCase(),
      port: uri.hasPort ? uri.port : null,
      pathSegments: uri.pathSegments,
      queryParameters: normalizedQuery.isEmpty ? null : normalizedQuery,
    );
    return VideoTogetherMediaIdentity._(
      kind: 'url',
      id: normalized.toString(),
      part: 1,
    );
  }

  final String kind;
  final String id;
  final int part;

  bool sameAs(VideoTogetherMediaIdentity other) =>
      kind == other.kind && id == other.id && part == other.part;
}

double _toDouble(Object? value, {double fallback = 0}) => switch (value) {
  num value => value.toDouble(),
  String value => double.tryParse(value) ?? fallback,
  _ => fallback,
};

int _toInt(Object? value) => switch (value) {
  int value => value,
  num value => value.toInt(),
  String value => int.tryParse(value) ?? 0,
  _ => 0,
};
