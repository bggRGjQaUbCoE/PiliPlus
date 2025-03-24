class SubDetailModelData {
  DetailInfo? info;
  List<SubDetailMediaItem>? list;

  List<SubDetailMediaItem>? get medias => list; // 不知道哪里使用了这个

  SubDetailModelData({this.info, this.list});

  SubDetailModelData.fromJson(Map<String, dynamic> json) {
    info = DetailInfo.fromJson(json['info']);
    list = (json['medias'] as List?)
        ?.map((i) => SubDetailMediaItem.fromJson(i))
        .toList();
  }
}

class SubDetailMediaItem {
  int? id;
  String? title;
  String? cover;
  String? pic;
  int? duration;
  int? pubtime;
  String? bvid;
  Map<String, dynamic>? upper;
  Map<String, dynamic>? cntInfo;
  int? enableVt;
  String? vtDisplay;

  SubDetailMediaItem({
    this.id,
    this.title,
    this.cover,
    this.pic,
    this.duration,
    this.pubtime,
    this.bvid,
    this.upper,
    this.cntInfo,
    this.enableVt,
    this.vtDisplay,
  });

  SubDetailMediaItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    cover = json['cover'];
    pic = json['cover'];
    duration = json['duration'];
    pubtime = json['pubtime'];
    bvid = json['bvid'];
    upper = json['upper'];
    cntInfo = json['cnt_info'];
    enableVt = json['enable_vt'];
    vtDisplay = json['vt_display'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['cover'] = cover;
    data['duration'] = duration;
    data['pubtime'] = pubtime;
    data['bvid'] = bvid;
    data['upper'] = upper;
    data['cnt_info'] = cntInfo;
    data['enable_vt'] = enableVt;
    data['vt_display'] = vtDisplay;
    return data;
  }
}

class DetailInfo {
  int? id;
  int? seasonType;
  String? title;
  String? cover;
  Map? upper;
  Map? cntInfo;
  int? mediaCount;
  String? intro;
  int? enableVt;

  DetailInfo({
    this.id,
    this.seasonType,
    this.title,
    this.cover,
    this.upper,
    this.cntInfo,
    this.mediaCount,
    this.intro,
    this.enableVt,
  });

  DetailInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    seasonType = json['season_type'];
    title = json['title'];
    cover = json['cover'];
    upper = json['upper'];
    cntInfo = json['cnt_info'];
    mediaCount = json['media_count'];
    intro = json['intro'];
    enableVt = json['enable_vt'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['season_type'] = seasonType;
    data['title'] = title;
    data['cover'] = cover;
    data['upper'] = upper;
    data['cnt_info'] = cntInfo;
    data['media_count'] = mediaCount;
    data['intro'] = intro;
    data['enable_vt'] = enableVt;
    return data;
  }
}
