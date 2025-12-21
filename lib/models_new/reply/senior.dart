class Senior {
  int? status;

  Senior({this.status});

  factory Senior.fromJson(Map<String, dynamic> json) =>
      Senior(status: json['status'] as int?);
}
