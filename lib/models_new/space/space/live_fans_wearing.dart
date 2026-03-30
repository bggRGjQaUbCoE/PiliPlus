class LiveFansWearing {
  DetailV2? detailV2;

  LiveFansWearing({
    this.detailV2,
  });

  factory LiveFansWearing.fromJson(Map<String, dynamic> json) {
    return LiveFansWearing(
      detailV2: json['detail_v2'] == null
          ? null
          : DetailV2.fromJson(json['detail_v2']),
    );
  }
}

class DetailV2 {
  int? uid;
  int? level;
  String? medalColorName;
  String? medalName;
  int? medalId;
  String? medalColor;

  DetailV2({
    this.uid,
    this.level,
    this.medalColorName,
    this.medalName,
    this.medalId,
    this.medalColor,
  });

  factory DetailV2.fromJson(Map<String, dynamic> json) {
    return DetailV2(
      uid: json["uid"],
      level: json["level"],
      medalColorName: json["medal_color_name"],
      medalName: json["medal_name"],
      medalId: json["medal_id"],
      medalColor: json["medal_color"],
    );
  }
}
