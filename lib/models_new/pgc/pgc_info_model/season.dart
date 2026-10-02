class Season {
  int? mediaId;
  int? seasonId;
  String? seasonTitle;

  Season({
    this.mediaId,
    this.seasonId,
    this.seasonTitle,
  });

  factory Season.fromJson(Map<String, dynamic> json) => Season(
    mediaId: json['media_id'] as int?,
    seasonId: json['season_id'] as int?,
    seasonTitle: json['season_title'] as String?,
  );
}
