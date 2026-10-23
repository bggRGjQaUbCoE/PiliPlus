class Eva3Video {
  Eva3VideoInfo? info;

  Eva3Video({this.info});

  factory Eva3Video.fromJson(Map<String, dynamic> json) => Eva3Video(
    info: json['info'] == null
        ? null
        : Eva3VideoInfo.fromJson(json['info'] as Map<String, dynamic>),
  );
}

class Eva3VideoInfo {
  String? avid;
  String? cid;
  String? epid;
  String? bvid;
  String? cover;
  String? uri;
  String? jumpUrl;
  String? title;
  String? desc;
  List<StatInfo>? statInfos;
  VideoTs? videoTs;

  Eva3VideoInfo({
    this.avid,
    this.cid,
    this.epid,
    this.bvid,
    this.cover,
    this.uri,
    this.jumpUrl,
    this.title,
    this.desc,
    this.statInfos,
    this.videoTs,
  });

  factory Eva3VideoInfo.fromJson(Map<String, dynamic> json) => Eva3VideoInfo(
    avid: json['avid'] as String?,
    cid: json['cid'] as String?,
    epid: json['epid'] as String?,
    bvid: json['bvid'] as String?,
    cover: json['cover'] as String?,
    uri: json['uri'] as String?,
    jumpUrl: json['jump_url'] as String?,
    title: json['title'] as String?,
    desc: json['desc'] as String?,
    statInfos: (json['stat_infos'] as List<dynamic>?)
        ?.map((e) => StatInfo.fromJson(e as Map<String, dynamic>))
        .toList(),
    videoTs: json['video_ts'] == null
        ? null
        : VideoTs.fromJson(json['video_ts'] as Map<String, dynamic>),
  );
}

class StatInfo {
  String? text;

  StatInfo({this.text});

  factory StatInfo.fromJson(Map<String, dynamic> json) => StatInfo(
    text: json['text'] as String?,
  );
}

class VideoTs {
  String? durationText;

  VideoTs({
    this.durationText,
  });

  factory VideoTs.fromJson(Map<String, dynamic> json) => VideoTs(
    durationText: json['duration_text'] as String?,
  );
}
