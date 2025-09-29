import 'package:PiliPlus/models/common/video/audio_quality.dart';
import 'package:PiliPlus/models/common/video/video_quality.dart';
import 'package:PiliPlus/utils/extension.dart';

class PlayUrlModel {
  PlayUrlModel({
    this.from,
    this.result,
    this.message,
    this.quality,
    this.format,
    this.timeLength,
    this.acceptFormat,
    this.acceptDesc,
    this.acceptQuality,
    this.videoCodecid,
    this.seekParam,
    this.seekType,
    this.dash,
    this.supportFormats,
    this.lastPlayTime,
    this.lastPlayCid,
  });

  String? from;
  String? result;
  String? message;
  int? quality;
  String? format;
  int? timeLength;
  String? acceptFormat;
  List<dynamic>? acceptDesc;
  List<int>? acceptQuality;
  int? videoCodecid;
  String? seekParam;
  String? seekType;
  Dash? dash;
  List<Durl>? durl;
  List<FormatItem>? supportFormats;
  Volume? volume;
  int? lastPlayTime;
  int? lastPlayCid;
  String? curLanguage;
  Language? language;

  PlayUrlModel.fromJson(Map<String, dynamic> json) {
    from = json['from'];
    result = json['result'];
    message = json['message'];
    quality = json['quality'];
    format = json['format'];
    timeLength = json['timelength'];
    acceptFormat = json['accept_format'];
    acceptDesc = json['accept_description'];
    acceptQuality = (json['accept_quality'] as List?)
        ?.map<int>((e) => e as int)
        .toList();
    videoCodecid = json['video_codecid'];
    seekParam = json['seek_param'];
    seekType = json['seek_type'];
    dash = json['dash'] != null ? Dash.fromJson(json['dash']) : null;
    durl = (json['durl'] as List?)?.map<Durl>((e) => Durl.fromJson(e)).toList();
    supportFormats = (json['support_formats'] as List?)
        ?.map<FormatItem>((e) => FormatItem.fromJson(e))
        .toList();
    volume = json['volume'] == null ? null : Volume.fromJson(json['volume']);
    lastPlayTime = json['last_play_time'];
    lastPlayCid = json['last_play_cid'];
    curLanguage = json['cur_language'];
    language = json['language'] == null
        ? null
        : Language.fromJson(json['language']);
  }
}

class Language {
  Language({
    this.support,
    this.items,
  });

  bool? support;
  List<LanguageItem>? items;

  Language.fromJson(Map<String, dynamic> json) {
    support = json['support'];
    items = (json['items'] as List?)
        ?.map((e) => LanguageItem.fromJson(e))
        .toList();
  }
}

class LanguageItem {
  LanguageItem({
    this.lang,
    this.title,
    this.subtitleLang,
    this.videoDetext,
    this.videoMouthShapeChange,
  });

  String? lang;
  String? title;
  String? subtitleLang;
  bool? videoDetext;
  bool? videoMouthShapeChange;

  LanguageItem.fromJson(Map<String, dynamic> json) {
    lang = json['lang'];
    title = json['title'];
    subtitleLang = json['subtitle_lang'];
    videoDetext = json['video_detext'];
    videoMouthShapeChange = json['video_mouth_shape_change'];
  }
}

class Dash {
  Dash({
    this.duration,
    this.minBufferTime,
    this.video,
    this.audio,
  });

  int? duration;
  double? minBufferTime;
  List<VideoItem>? video;
  List<AudioItem>? audio;

  Dash.fromJson(Map<String, dynamic> json) {
    duration = json['duration'];
    minBufferTime = json['minBufferTime'];
    video = (json['video'] as List?)
        ?.map<VideoItem>((e) => VideoItem.fromJson(e))
        .toList();
    audio = (json['audio'] as List?)
        ?.map<AudioItem>((e) => AudioItem.fromJson(e))
        .toList();
    if (json['dolby']?['audio'] case List list) {
      (audio ??= <AudioItem>[]).insertAll(
        0,
        list.map((e) => AudioItem.fromJson(e)),
      );
    }
    final flacAudio = json['flac']?['audio'];
    if (flacAudio != null) {
      (audio ??= <AudioItem>[]).insert(0, AudioItem.fromJson(flacAudio));
    }
  }
}

class Durl {
  int? order;
  int? length;
  int? size;
  String? ahead;
  String? vhead;
  String? url;
  List<String>? backupUrl;

  Durl({
    this.order,
    this.length,
    this.size,
    this.ahead,
    this.vhead,
    this.url,
    this.backupUrl,
  });

  factory Durl.fromJson(Map<String, dynamic> json) {
    return Durl(
      order: json['order'],
      length: json['length'],
      size: json['size'],
      ahead: json['ahead'],
      vhead: json['vhead'],
      url: json['url'],
      backupUrl: json['backup_url'] != null
          ? List<String>.from(json['backup_url'])
          : [],
    );
  }
}

final _ipRegExp = RegExp(r'^https?://\d{1,3}\.\d{1,3}');

bool _isMCDNorPCDN(String url) {
  return url.contains("szbdyd.com") ||
      url.contains(".mcdn.bilivideo") ||
      _ipRegExp.hasMatch(url);
}

abstract class BaseItem {
  int? id;
  String? baseUrl;
  String? backupUrl;
  int? bandWidth;
  String? mimeType;
  String? codecs;
  int? width;
  int? height;
  String? frameRate;
  String? sar;
  int? startWithSap;
  Map? segmentBase;
  int? codecid;

  BaseItem({
    this.id,
    this.baseUrl,
    this.backupUrl,
    this.bandWidth,
    this.mimeType,
    this.codecs,
    this.width,
    this.height,
    this.frameRate,
    this.sar,
    this.startWithSap,
    this.segmentBase,
    this.codecid,
  });

  BaseItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    baseUrl = json['baseUrl'] ?? json['base_url'];
    final backupUrls =
        ((json['backupUrl'] ?? json['backup_url']) as List?)
            ?.fromCast<String>() ??
        <String>[];
    backupUrl = backupUrls.isNotEmpty
        ? backupUrls.firstWhere(
            (i) => !_isMCDNorPCDN(i),
            orElse: () => backupUrls.first,
          )
        : null;
    bandWidth = json['bandWidth'] ?? json['bandwidth'];
    mimeType = json['mime_type'];
    codecs = json['codecs'];
    width = json['width'];
    height = json['height'];
    frameRate = json['frameRate'] ?? json['frame_rate'];
    sar = json['sar'];
    startWithSap = json['startWithSap'] ?? json['start_with_sap'];
    segmentBase = json['segmentBase'] ?? json['segment_base'];
    codecid = json['codecid'];
  }
}

class VideoItem extends BaseItem {
  late VideoQuality quality;

  VideoItem({
    super.id,
    super.baseUrl,
    super.backupUrl,
    super.bandWidth,
    super.mimeType,
    super.codecs,
    super.width,
    super.height,
    super.frameRate,
    super.sar,
    super.startWithSap,
    super.segmentBase,
    super.codecid,
    required this.quality,
  });

  VideoItem.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    quality = VideoQuality.fromCode(json['id']);
  }
}

class AudioItem extends BaseItem {
  late String quality;

  AudioItem();

  AudioItem.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    quality = AudioQuality.fromCode(json['id']).desc;
  }
}

class FormatItem {
  FormatItem({
    this.quality,
    this.format,
    this.newDesc,
    this.displayDesc,
    this.codecs,
  });

  int? quality;
  String? format;
  String? newDesc;
  String? displayDesc;
  List<String>? codecs;

  FormatItem.fromJson(Map<String, dynamic> json) {
    quality = json['quality'];
    format = json['format'];
    newDesc = json['new_description'];
    displayDesc = json['display_desc'];
    codecs = (json['codecs'] as List?)?.fromCast<String>();
  }
}

class Volume {
  Volume({
    required this.measuredI,
    required this.measuredLra,
    required this.measuredTp,
    required this.measuredThreshold,
    required this.targetOffset,
    required this.targetI,
    required this.targetTp,
    // required this.multiSceneArgs,
  });

  final num measuredI;
  final num measuredLra;
  final num measuredTp;
  final num measuredThreshold;
  final num targetOffset;
  final num targetI;
  final num targetTp;
  // final MultiSceneArgs? multiSceneArgs;

  factory Volume.fromJson(Map<String, dynamic> json) {
    return Volume(
      measuredI: json["measured_i"] ?? 0,
      measuredLra: json["measured_lra"] ?? 0,
      measuredTp: json["measured_tp"] ?? 0,
      measuredThreshold: json["measured_threshold"] ?? 0,
      targetOffset: json["target_offset"] ?? 0,
      targetI: json["target_i"] ?? 0,
      targetTp: json["target_tp"] ?? 0,
      // multiSceneArgs: json["multi_scene_args"] == null ? null : MultiSceneArgs.fromJson(json["multi_scene_args"]),
    );
  }

  @override
  String toString() =>
      'measured_I=$measuredI:measured_LRA=$measuredLra:measured_TP=$measuredTp:measured_thresh=$measuredThreshold';

  bool get isNotEmpty =>
      measuredI != 0 ||
      measuredLra != 0 ||
      measuredTp != 0 ||
      measuredThreshold != 0;
}
