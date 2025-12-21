class Op {
  int? end;
  int? start;

  Op({this.end, this.start});

  factory Op.fromJson(Map<String, dynamic> json) =>
      Op(end: json['end'] as int?, start: json['start'] as int?);
}
