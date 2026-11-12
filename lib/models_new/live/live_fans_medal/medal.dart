class Medal {
  int intimacy;
  int nextIntimacy;

  int todayFeed;
  int dayLimit;

  int wearingStatus;

  Medal({
    required this.intimacy,
    required this.nextIntimacy,
    required this.todayFeed,
    required this.dayLimit,
    required this.wearingStatus,
  });

  factory Medal.fromJson(Map<String, dynamic> json) => Medal(
    intimacy: json['intimacy'] ?? 0,
    nextIntimacy: json['next_intimacy'] ?? 0,
    todayFeed: json['today_feed'] ?? 0,
    dayLimit: json['day_limit'] ?? 0,
    wearingStatus: json['wearing_status'] ?? 0,
  );
}
