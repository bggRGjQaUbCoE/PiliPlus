import 'package:PiliPlus/models_new/pgc/pgc_timeline/result.dart';

class PgcTimeline {
  int? code;
  String? message;
  List<TimelineResult>? result;

  PgcTimeline({this.code, this.message, this.result});

  factory PgcTimeline.fromJson(Map<String, dynamic> json) => PgcTimeline(
    code: json['code'] as int?,
    message: json['message'] as String?,
    result: (json['result'] as List<dynamic>?)
        ?.map((e) => TimelineResult.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
