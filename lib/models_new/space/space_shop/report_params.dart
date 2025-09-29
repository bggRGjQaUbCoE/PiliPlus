class ReportParams {
  String? trail;
  String? trackId;

  ReportParams({this.trail, this.trackId});

  factory ReportParams.fromJson(Map<String, dynamic> json) => ReportParams(
    trail: json['trail'] as String?,
    trackId: json['track_id'] as String?,
  );
}
