import 'package:PiliPlus/models/video/play/quality.dart';

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
    // this.highFormat,
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
  // String? highFormat;
  int? lastPlayTime;
  int? lastPlayCid;

  PlayUrlModel.fromJson(Map<String, dynamic> json) {
    from = json['from'];
    result = json['result'];
    message = json['message'];
    quality = json['quality'];
    format = json['format'];
    timeLength = json['timelength'];
    acceptFormat = json['accept_format'];
    acceptDesc = json['accept_description'];
    acceptQuality =
        (json['accept_quality'] as List?)?.map<int>((e) => e as int).toList();
    videoCodecid = json['video_codecid'];
    seekParam = json['seek_param'];
    seekType = json['seek_type'];
    dash = json['dash'] != null ? Dash.fromJson(json['dash']) : null;
    durl = (json['durl'] as List?)?.map<Durl>((e) => Durl.fromJson(e)).toList();
    supportFormats = (json['support_formats'] as List?)
        ?.map<FormatItem>((e) => FormatItem.fromJson(e))
        .toList();
    lastPlayTime = json['last_play_time'];
    lastPlayCid = json['last_play_cid'];
  }
}

class Dash {
  Dash({
    this.duration,
    this.minBufferTime,
    this.video,
    this.audio,
    this.dolby,
    this.flac,
  });

  int? duration;
  double? minBufferTime;
  List<VideoItem>? video;
  List<AudioItem>? audio;
  Dolby? dolby;
  Flac? flac;

  Dash.fromJson(Map<String, dynamic> json) {
    duration = json['duration'];
    minBufferTime = json['minBufferTime'];
    video = (json['video'] as List?)
        ?.map<VideoItem>((e) => VideoItem.fromJson(e))
        .toList();
    audio = (json['audio'] as List?)
        ?.map<AudioItem>((e) => AudioItem.fromJson(e))
        .toList();
    dolby = json['dolby'] != null ? Dolby.fromJson(json['dolby']) : null;
    flac = json['flac'] != null ? Flac.fromJson(json['flac']) : null;
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

class VideoItem {
  VideoItem({
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
    this.quality,
  });

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
  VideoQuality? quality;

  VideoItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    baseUrl = json['baseUrl'];
    var backupUrls = json['backupUrl']?.toList() ?? [];
    backupUrl = backupUrls.isNotEmpty
      ? backupUrls.firstWhere((i) => !_isMCDNorPCDN(i), orElse: () => backupUrls.first)
      : '';
    bandWidth = json['bandWidth'];
    mimeType = json['mime_type'];
    codecs = json['codecs'];
    width = json['width'];
    height = json['height'];
    frameRate = json['frameRate'];
    sar = json['sar'];
    startWithSap = json['startWithSap'];
    segmentBase = json['segmentBase'];
    codecid = json['codecid'];
    quality = VideoQuality.values.firstWhere((i) => i.code == json['id']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['baseUrl'] = baseUrl;
    data['backupUrl'] = backupUrl;
    data['bandWidth'] = bandWidth;
    data['mime_type'] = mimeType;
    data['codecs'] = codecs;
    data['width'] = width;
    data['height'] = height;
    data['frameRate'] = frameRate;
    data['sar'] = sar;
    data['startWithSap'] = startWithSap;
    data['segmentBase'] = segmentBase;
    data['codecid'] = codecid;
    data['quality'] = quality;
    return data;
  }
}

class AudioItem {
  AudioItem({
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
    this.quality,
  });

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
  String? quality;

  AudioItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    baseUrl = json['baseUrl'];
    var backupUrls = json['backupUrl']?.toList() ?? [];
    backupUrl = backupUrls.isNotEmpty
      ? backupUrls.firstWhere((i) => !_isMCDNorPCDN(i), orElse: () => backupUrls.first)
      : '';
    bandWidth = json['bandWidth'];
    mimeType = json['mime_type'];
    codecs = json['codecs'];
    width = json['width'];
    height = json['height'];
    frameRate = json['frameRate'];
    sar = json['sar'];
    startWithSap = json['startWithSap'];
    segmentBase = json['segmentBase'];
    codecid = json['codecid'];
    quality =
        AudioQuality.values.firstWhere((i) => i.code == json['id']).description;
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
  List? codecs;

  FormatItem.fromJson(Map<String, dynamic> json) {
    quality = json['quality'];
    format = json['format'];
    newDesc = json['new_description'];
    displayDesc = json['display_desc'];
    codecs = json['codecs'];
  }
}

class Dolby {
  Dolby({
    this.type,
    this.audio,
  });

  // 1：普通杜比音效 2：全景杜比音效
  int? type;
  List<AudioItem>? audio;

  Dolby.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    audio = (json['audio'] as List?)
        ?.map<AudioItem>((e) => AudioItem.fromJson(e))
        .toList();
  }
}

class Flac {
  Flac({this.display, this.audio});

  bool? display;
  AudioItem? audio;

  Flac.fromJson(Map<String, dynamic> json) {
    display = json['display'];
    audio = json['audio'] != null ? AudioItem.fromJson(json['audio']) : null;
  }
}
