class PopularSeriesConfig {
  int? id;
  String? type;
  int? number;
  String? subject;
  int? stime;
  int? etime;
  int? status;
  String? name;
  String? label;
  String? hint;
  int? color;
  String? cover;
  String? shareTitle;
  String? shareSubtitle;
  int? mediaId;

  PopularSeriesConfig({
    this.id,
    this.type,
    this.number,
    this.subject,
    this.stime,
    this.etime,
    this.status,
    this.name,
    this.label,
    this.hint,
    this.color,
    this.cover,
    this.shareTitle,
    this.shareSubtitle,
    this.mediaId,
  });

  factory PopularSeriesConfig.fromJson(Map<String, dynamic> json) =>
      PopularSeriesConfig(
        id: json['id'] as int?,
        type: json['type'] as String?,
        number: json['number'] as int?,
        subject: json['subject'] as String?,
        stime: json['stime'] as int?,
        etime: json['etime'] as int?,
        status: json['status'] as int?,
        name: json['name'] as String?,
        label: json['label'] as String?,
        hint: json['hint'] as String?,
        color: json['color'] as int?,
        cover: json['cover'] as String?,
        shareTitle: json['share_title'] as String?,
        shareSubtitle: json['share_subtitle'] as String?,
        mediaId: json['media_id'] as int?,
      );
}
