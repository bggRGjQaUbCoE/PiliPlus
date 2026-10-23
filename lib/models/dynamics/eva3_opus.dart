class Eva3Opus {
  Eva3OpusInfo? info;

  Eva3Opus({this.info});

  factory Eva3Opus.fromJson(Map<String, dynamic> json) => Eva3Opus(
    info: json['info'] == null
        ? null
        : Eva3OpusInfo.fromJson(json['info'] as Map<String, dynamic>),
  );
}

class Eva3OpusInfo {
  String? opusId;
  String? title;
  String? content;
  String? jumpUrl;
  String? authorName;
  String? view;
  String? reply;
  List<Eva3OpusPic>? pics;
  String? badge;
  String? cardType;

  Eva3OpusInfo({
    this.opusId,
    this.title,
    this.content,
    this.jumpUrl,
    this.authorName,
    this.view,
    this.reply,
    this.pics,
    this.badge,
    this.cardType,
  });

  factory Eva3OpusInfo.fromJson(Map<String, dynamic> json) => Eva3OpusInfo(
    opusId: json['opus_id'] as String?,
    title: json['title'] as String?,
    content: json['content'] as String?,
    jumpUrl: json['jump_url'] as String?,
    authorName: json['author_name'] as String?,
    view: json['view'] as String?,
    reply: json['reply'] as String?,
    pics: (json['pics'] as List<dynamic>?)
        ?.map((e) => Eva3OpusPic.fromJson(e as Map<String, dynamic>))
        .toList(),
    badge: json['badge'] as String?,
    cardType: json['card_type'] as String?,
  );
}

class Eva3OpusPic {
  String? src;
  String? width;
  String? height;
  double? size;
  String? srcDark;
  bool? isLivePhoto;
  String? liveVideoUrl;
  int? liveVideoSize;

  Eva3OpusPic({
    this.src,
    this.width,
    this.height,
    this.size,
    this.srcDark,
    this.isLivePhoto,
    this.liveVideoUrl,
    this.liveVideoSize,
  });

  factory Eva3OpusPic.fromJson(Map<String, dynamic> json) => Eva3OpusPic(
    src: json['src'] as String?,
    width: json['width'] as String?,
    height: json['height'] as String?,
    size: (json['size'] as num?)?.toDouble(),
    srcDark: json['src_dark'] as String?,
    isLivePhoto: json['is_live_photo'] as bool?,
    liveVideoUrl: json['live_video_url'] as String?,
    liveVideoSize: json['live_video_size'] as int?,
  );
}
