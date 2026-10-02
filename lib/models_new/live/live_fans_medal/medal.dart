class FansMedalDetail {
  int? medalId;
  int? targetId;
  String? medalName;
  int? level;
  int? intimacy;
  int? nextIntimacy;
  int? dayLimit;
  int? todayFeed;
  int? isLighted;
  int? wearingStatus;

  FansMedalDetail({
    this.medalId,
    this.targetId,
    this.medalName,
    this.level,
    this.intimacy,
    this.nextIntimacy,
    this.dayLimit,
    this.todayFeed,
    this.isLighted,
    this.wearingStatus,
  });

  factory FansMedalDetail.fromJson(Map<String, dynamic> json) =>
      FansMedalDetail(
        medalId: json['medal_id'] as int?,
        targetId: json['target_id'] as int?,
        medalName: json['medal_name'] as String?,
        level: json['level'] as int?,
        intimacy: json['intimacy'] as int?,
        nextIntimacy: json['next_intimacy'] as int?,
        dayLimit: json['day_limit'] as int?,
        todayFeed: json['today_feed'] as int?,
        isLighted: json['is_lighted'] as int?,
        wearingStatus: json['wearing_status'] as int?,
      );
}