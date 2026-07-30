enum PlayerMediaTrackType {
  video,
  audio,
  subtitle;

  static PlayerMediaTrackType? fromName(String? name) => switch (name) {
    'video' => video,
    'audio' => audio,
    'subtitle' => subtitle,
    _ => null,
  };
}

enum PlayerTrackSelectionMode { auto, disabled, track }

class PlayerMediaTrack {
  const PlayerMediaTrack({
    required this.type,
    required this.id,
    required this.groupIndex,
    required this.trackIndex,
    required this.selected,
    required this.supported,
    this.external = false,
    this.title,
    this.language,
    this.codec,
    this.mimeType,
    this.containerMimeType,
    this.bitrate,
    this.width,
    this.height,
    this.frameRate,
    this.rotationDegrees,
    this.pixelWidthHeightRatio,
    this.channelCount,
    this.sampleRate,
    this.colorInfo,
  });

  factory PlayerMediaTrack.fromMap(Map<Object?, Object?> map) {
    int? intValue(String key) => (map[key] as num?)?.toInt();
    final type = PlayerMediaTrackType.fromName(map['type'] as String?);
    if (type == null) {
      throw FormatException('Unknown media track type: ${map['type']}');
    }
    return PlayerMediaTrack(
      type: type,
      id: map['id'] as String? ?? '',
      groupIndex: intValue('groupIndex') ?? -1,
      trackIndex: intValue('trackIndex') ?? -1,
      selected: map['selected'] as bool? ?? false,
      supported: map['supported'] as bool? ?? true,
      external: map['external'] as bool? ?? false,
      title: map['title'] as String?,
      language: map['language'] as String?,
      codec: map['codec'] as String?,
      mimeType: map['mimeType'] as String?,
      containerMimeType: map['containerMimeType'] as String?,
      bitrate: intValue('bitrate'),
      width: intValue('width'),
      height: intValue('height'),
      frameRate: (map['frameRate'] as num?)?.toDouble(),
      rotationDegrees: intValue('rotationDegrees'),
      pixelWidthHeightRatio: (map['pixelWidthHeightRatio'] as num?)?.toDouble(),
      channelCount: intValue('channelCount'),
      sampleRate: intValue('sampleRate'),
      colorInfo: map['colorInfo'] as String?,
    );
  }

  final PlayerMediaTrackType type;
  final String id;
  final int groupIndex;
  final int trackIndex;
  final bool selected;
  final bool supported;
  final bool external;
  final String? title;
  final String? language;
  final String? codec;
  final String? mimeType;
  final String? containerMimeType;
  final int? bitrate;
  final int? width;
  final int? height;
  final double? frameRate;
  final int? rotationDegrees;
  final double? pixelWidthHeightRatio;
  final int? channelCount;
  final int? sampleRate;
  final String? colorInfo;

  String get displayName {
    final parts = <String>[
      if (title?.trim().isNotEmpty == true) title!.trim(),
      if (language?.trim().isNotEmpty == true) language!.trim(),
      if (type == PlayerMediaTrackType.video && width != null && height != null)
        '${width}x$height',
      if (type == PlayerMediaTrackType.audio && channelCount != null)
        '$channelCount 声道',
      if (codec?.trim().isNotEmpty == true) codec!.trim(),
    ];
    return parts.isEmpty ? '轨道 $id' : parts.join(' · ');
  }

  String get details {
    final values = <String>[
      'id: $id',
      if (title != null) 'title: $title',
      if (language != null) 'language: $language',
      if (codec != null) 'codec: $codec',
      if (mimeType != null) 'mimeType: $mimeType',
      if (containerMimeType != null) 'containerMimeType: $containerMimeType',
      if (bitrate != null) 'bitrate: $bitrate',
      if (width != null && height != null) 'resolution: ${width}x$height',
      if (frameRate != null) 'frameRate: $frameRate',
      if (rotationDegrees != null) 'rotation: $rotationDegrees',
      if (pixelWidthHeightRatio != null) 'pixelRatio: $pixelWidthHeightRatio',
      if (channelCount != null) 'channels: $channelCount',
      if (sampleRate != null) 'sampleRate: $sampleRate',
      if (colorInfo != null) 'colorInfo: $colorInfo',
      'selected: $selected',
      'supported: $supported',
      if (type == PlayerMediaTrackType.subtitle) 'external: $external',
    ];
    return values.join(', ');
  }
}

class PlayerInfoEntry {
  const PlayerInfoEntry(this.label, this.value);

  final String label;
  final String value;
}
