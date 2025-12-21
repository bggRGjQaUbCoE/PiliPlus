class Ed {
  int? end;
  int? start;

  Ed({this.end, this.start});

  factory Ed.fromJson(Map<String, dynamic> json) =>
      Ed(end: json['end'] as int?, start: json['start'] as int?);
}
