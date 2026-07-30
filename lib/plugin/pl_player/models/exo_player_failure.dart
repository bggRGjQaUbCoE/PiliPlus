enum ExoPlayerFailureCategory {
  network,
  source,
  decoder,
  drm,
  remote,
  unexpected;

  static ExoPlayerFailureCategory fromName(String? name) => switch (name) {
    'network' => network,
    'source' => source,
    'decoder' => decoder,
    'drm' => drm,
    'remote' => remote,
    _ => unexpected,
  };
}

class ExoPlayerPlaybackFailure implements Exception {
  const ExoPlayerPlaybackFailure({
    required this.message,
    required this.errorCode,
    required this.errorCodeName,
    required this.category,
    required this.phase,
    required this.recoverable,
    required this.position,
    required this.playWhenReady,
    this.httpStatus,
    this.uri,
    this.rendererName,
    this.videoDecoder,
    this.audioDecoder,
    this.mediaDescription,
    this.causeChain = const [],
  });

  factory ExoPlayerPlaybackFailure.fromMap(Map<Object?, Object?> map) {
    return ExoPlayerPlaybackFailure(
      message: map['message'] as String? ?? 'Unknown playback error',
      errorCode: (map['errorCode'] as num?)?.toInt() ?? 0,
      errorCodeName:
          map['errorCodeName'] as String? ?? 'ERROR_CODE_UNSPECIFIED',
      category: ExoPlayerFailureCategory.fromName(map['category'] as String?),
      phase: map['phase'] as String? ?? 'playback',
      recoverable: map['recoverable'] as bool? ?? false,
      position: Duration(
        milliseconds: (map['positionMs'] as num?)?.toInt() ?? 0,
      ),
      playWhenReady: map['playWhenReady'] as bool? ?? false,
      httpStatus: (map['httpStatus'] as num?)?.toInt(),
      uri: map['uri'] as String?,
      rendererName: map['rendererName'] as String?,
      videoDecoder: map['videoDecoder'] as String?,
      audioDecoder: map['audioDecoder'] as String?,
      mediaDescription: map['mediaDescription'] as String?,
      causeChain: switch (map['causeChain']) {
        final List values => values.whereType<String>().toList(growable: false),
        _ => const [],
      },
    );
  }

  factory ExoPlayerPlaybackFailure.legacy(String message) {
    return ExoPlayerPlaybackFailure(
      message: message,
      errorCode: 0,
      errorCodeName: 'ERROR_CODE_UNSPECIFIED',
      category: ExoPlayerFailureCategory.unexpected,
      phase: 'playback',
      recoverable: false,
      position: Duration.zero,
      playWhenReady: false,
      causeChain: [message],
    );
  }

  final String message;
  final int errorCode;
  final String errorCodeName;
  final ExoPlayerFailureCategory category;
  final String phase;
  final bool recoverable;
  final Duration position;
  final bool playWhenReady;
  final int? httpStatus;
  final String? uri;
  final String? rendererName;
  final String? videoDecoder;
  final String? audioDecoder;
  final String? mediaDescription;
  final List<String> causeChain;

  String get userMessage {
    if (httpStatus case final status?) {
      return '视频源请求失败（HTTP $status），请重载视频或切换 CDN';
    }
    return switch (category) {
      ExoPlayerFailureCategory.network => '网络连接失败，请检查网络后重载视频',
      ExoPlayerFailureCategory.source => '视频源无法读取，请重载视频或切换 CDN',
      ExoPlayerFailureCategory.decoder => '当前设备解码失败，请尝试切换画质或解码格式',
      ExoPlayerFailureCategory.drm => '受保护内容授权失败，暂时无法播放',
      ExoPlayerFailureCategory.remote => '远程播放组件发生错误',
      ExoPlayerFailureCategory.unexpected => '视频播放失败，请重载后重试',
    };
  }

  String diagnostics({int? retryAttempt, int? retryLimit}) {
    final lines = <String>[
      'ExoPlayer playback failure',
      'phase: $phase',
      'category: ${category.name}',
      'recoverable: $recoverable',
      'errorCode: $errorCode',
      'errorCodeName: $errorCodeName',
      'message: $message',
      'positionMs: ${position.inMilliseconds}',
      'playWhenReady: $playWhenReady',
      if (httpStatus != null) 'httpStatus: $httpStatus',
      if (uri != null) 'uri: $uri',
      if (rendererName != null) 'renderer: $rendererName',
      if (videoDecoder != null) 'videoDecoder: $videoDecoder',
      if (audioDecoder != null) 'audioDecoder: $audioDecoder',
      if (mediaDescription != null) 'media:\n$mediaDescription',
      if (retryAttempt != null && retryLimit != null)
        'retry: $retryAttempt/$retryLimit',
      if (causeChain.isNotEmpty) 'causeChain:\n${causeChain.join('\n')}',
    ];
    return lines.join('\n');
  }

  StackTrace get diagnosticStackTrace => StackTrace.fromString(
    causeChain.isEmpty
        ? '$errorCodeName: $message'
        : causeChain.join('\nCaused by: '),
  );

  @override
  String toString() => diagnostics();
}

bool shouldRetryExoPlaybackFailure(
  ExoPlayerPlaybackFailure failure, {
  required int attempt,
  required int limit,
  required bool localSource,
  required bool sessionActive,
}) => failure.recoverable && !localSource && sessionActive && attempt < limit;

Duration exoPlaybackRetryDelay({
  required int baseDelayMs,
  required int attempt,
}) => Duration(milliseconds: baseDelayMs * attempt);
