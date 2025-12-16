import 'package:PiliPlus/utils/extension/iterable_ext.dart';

sealed class BiliDownloadMediaInfo {
  const BiliDownloadMediaInfo();

  Map<String, String> get httpHeader => {};

  Map<String, dynamic> toJson();
}

class Type1 extends BiliDownloadMediaInfo {
  final int availablePeriodMilli;
  final String description;
  final String format;
  final String? from;
  final bool intact;
  final bool isDownloaded;
  final bool isResolved;
  final String marlinToken;
  final bool needLogin;
  final bool needVip;
  final int parseTimestampMilli;
  final List<Type1PlayerCodecConfig> playerCodecConfigList;
  final int playerError;
  final int quality;
  final List<Type1Segment> segmentList;
  final int timeLength;
  final String? typeTag;
  final String? userAgent;
  final String? referer;
  final int videoCodecId;
  final bool videoProject;

  @override
  Map<String, String> get httpHeader => {
    if (referer?.isNotEmpty ?? false) 'referer': referer!,
    if (userAgent?.isNotEmpty ?? false) 'user-agent': userAgent!,
  };

  Type1({
    required this.availablePeriodMilli,
    required this.description,
    required this.format,
    this.from,
    required this.intact,
    required this.isDownloaded,
    required this.isResolved,
    required this.marlinToken,
    required this.needLogin,
    required this.needVip,
    required this.parseTimestampMilli,
    required this.playerCodecConfigList,
    required this.playerError,
    required this.quality,
    required this.segmentList,
    required this.timeLength,
    this.typeTag,
    this.userAgent,
    this.referer,
    required this.videoCodecId,
    required this.videoProject,
  });

  factory Type1.fromJson(Map<String, dynamic> json) => Type1(
    availablePeriodMilli: json['available_period_milli'] as int,
    description: json['description'] as String,
    format: json['format'] as String,
    from: json['from'] as String?,
    intact: json['intact'] as bool,
    isDownloaded: json['is_downloaded'] as bool,
    isResolved: json['is_resolved'] as bool,
    marlinToken: json['marlin_token'] as String,
    needLogin: json['need_login'] as bool,
    needVip: json['need_vip'] as bool,
    parseTimestampMilli: json['parse_timestamp_milli'] as int,
    playerCodecConfigList: (json['player_codec_config_list'] as List<dynamic>)
        .map((e) => Type1PlayerCodecConfig.fromJson(e as Map<String, dynamic>))
        .toList(),
    playerError: json['player_error'] as int,
    quality: json['quality'] as int,
    segmentList: (json['segment_list'] as List<dynamic>)
        .map((e) => Type1Segment.fromJson(e as Map<String, dynamic>))
        .toList(),
    timeLength: json['time_length'] as int,
    typeTag: json['type_tag'] as String?,
    userAgent: json['user_agent'] as String?,
    referer: json['referer'] as String?,
    videoCodecId: json['video_codec_id'] as int,
    videoProject: json['video_project'] as bool,
  );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    'available_period_milli': availablePeriodMilli,
    'description': description,
    'format': format,
    'from': ?from,
    'intact': intact,
    'is_downloaded': isDownloaded,
    'is_resolved': isResolved,
    'marlin_token': marlinToken,
    'need_login': needLogin,
    'need_vip': needVip,
    'parse_timestamp_milli': parseTimestampMilli,
    'player_codec_config_list': playerCodecConfigList
        .map((e) => e.toJson())
        .toList(),
    'player_error': playerError,
    'quality': quality,
    'segment_list': segmentList.map((e) => e.toJson()).toList(),
    'time_length': timeLength,
    'type_tag': ?typeTag,
    'user_agent': ?userAgent,
    'referer': ?referer,
    'video_codec_id': videoCodecId,
    'video_project': videoProject,
  };
}

class Type1PlayerCodecConfig {
  final String player;
  final bool useIjkMediaCodec;

  Type1PlayerCodecConfig({
    required this.player,
    required this.useIjkMediaCodec,
  });

  factory Type1PlayerCodecConfig.fromJson(Map<String, dynamic> json) =>
      Type1PlayerCodecConfig(
        player: json['player'] as String,
        useIjkMediaCodec: json['use_ijk_media_codec'] as bool,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'player': player,
    'use_ijk_media_codec': useIjkMediaCodec,
  };
}

class Type1Segment {
  final List<String> backupUrls;
  final int bytes;
  final int duration;
  final String md5;
  final String metaUrl;
  final int order;
  final String url;

  Type1Segment({
    required this.backupUrls,
    required this.bytes,
    this.duration = 0,
    required this.md5,
    required this.metaUrl,
    required this.order,
    required this.url,
  });

  factory Type1Segment.fromJson(Map<String, dynamic> json) => Type1Segment(
    backupUrls: List<String>.from(json['backup_urls']),
    bytes: json['bytes'] as int,
    duration: json['duration'] as int,
    md5: json['md5'] as String,
    metaUrl: json['meta_url'] as String,
    order: json['order'] as int,
    url: json['url'] as String,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'backup_urls': backupUrls,
    'bytes': bytes,
    'duration': duration,
    'md5': md5,
    'meta_url': metaUrl,
    'order': order,
    'url': url,
  };
}

class Type2 extends BiliDownloadMediaInfo {
  final int duration;
  final List<Type2File> video;
  final List<Type2File>? audio;
  final String? userAgent;
  final String? referer;

  Type2({
    this.duration = 0,
    required this.video,
    this.audio,
    this.userAgent,
    this.referer,
  });

  @override
  Map<String, String> get httpHeader => {
    if (referer?.isNotEmpty ?? false) 'referer': referer!,
    if (userAgent?.isNotEmpty ?? false) 'user-agent': userAgent!,
  };

  factory Type2.fromJson(Map<String, dynamic> json) => Type2(
    duration: json['duration'] as int,
    video: (json['video'] as List<dynamic>)
        .map((e) => Type2File.fromJson(e as Map<String, dynamic>))
        .toList(),
    audio: (json['audio'] as List<dynamic>?)
        ?.map((e) => Type2File.fromJson(e as Map<String, dynamic>))
        .toList(),
    userAgent: json['user_agent'] as String?,
    referer: json['referer'] as String?,
  );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    'duration': duration,
    'video': video.map((e) => e.toJson()).toList(),
    'audio': ?audio?.map((e) => e.toJson()).toList(),
    'user_agent': ?userAgent,
    'referer': ?referer,
  };
}

class Type2File {
  final int id;
  final String baseUrl;
  final List<String>? backupUrl;
  final int bandwidth;
  final int codecid;
  int size;
  final String md5;
  final bool noRexcode;
  final String frameRate;
  final int width;
  final int height;
  final int dashDrmType;

  Type2File({
    required this.id,
    required this.baseUrl,
    this.backupUrl,
    required this.bandwidth,
    required this.codecid,
    required this.size,
    required this.md5,
    required this.noRexcode,
    this.frameRate = '',
    this.width = 1,
    this.height = 1,
    this.dashDrmType = 0,
  });

  factory Type2File.fromJson(Map<String, dynamic> json) => Type2File(
    id: json['id'] as int,
    baseUrl: json['base_url'] as String,
    backupUrl: (json['backup_url'] as List<dynamic>?)?.fromCast(),
    bandwidth: json['bandwidth'] as int,
    codecid: json['codecid'] as int,
    size: json['size'] as int,
    md5: json['md5'] as String,
    noRexcode: json['no_rexcode'] as bool,
    frameRate: json['frame_rate'] as String? ?? '',
    width: json['width'] as int,
    height: json['height'] as int,
    dashDrmType: json['dash_drm_type'] as int,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'base_url': baseUrl,
    'backup_url': ?backupUrl,
    'bandwidth': bandwidth,
    'codecid': codecid,
    'size': size,
    'md5': md5,
    'no_rexcode': noRexcode,
    'frame_rate': frameRate,
    'width': width,
    'height': height,
    'dash_drm_type': dashDrmType,
  };
}

class None extends BiliDownloadMediaInfo {
  final String message;

  const None({
    required this.message,
  });

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}
