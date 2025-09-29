import 'package:PiliPlus/models_new/pgc/pgc_timeline/episode.dart';

class TimelineResult {
  String? date;
  int? dateTs;
  int? dayOfWeek;
  List<Episode>? episodes;
  int? isToday;

  TimelineResult({
    this.date,
    this.dateTs,
    this.dayOfWeek,
    this.episodes,
    this.isToday,
  });

  factory TimelineResult.fromJson(Map<String, dynamic> json) => TimelineResult(
    date: json['date'] as String?,
    dateTs: json['date_ts'] as int?,
    dayOfWeek: json['day_of_week'] as int?,
    episodes: (json['episodes'] as List<dynamic>?)
        ?.map((e) => Episode.fromJson(e as Map<String, dynamic>))
        .toList(),
    isToday: json['is_today'] as int?,
  );

  void operator +(TimelineResult other) {
    if (dateTs == other.dateTs) {
      if (other.episodes case final list?) {
        (episodes ??= <Episode>[]).addAll(list);
      }
    }
  }
}
