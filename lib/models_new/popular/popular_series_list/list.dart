class PopularSeriesListItem {
  int? number;
  String? subject;
  int? status;
  String? name;

  PopularSeriesListItem({this.number, this.subject, this.status, this.name});

  factory PopularSeriesListItem.fromJson(Map<String, dynamic> json) =>
      PopularSeriesListItem(
        number: json['number'] as int?,
        subject: json['subject'] as String?,
        status: json['status'] as int?,
        name: json['name'] as String?,
      );
}
