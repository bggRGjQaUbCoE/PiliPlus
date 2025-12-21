class Meta {
  int? size;
  String? alias;

  Meta({this.size, this.alias});

  factory Meta.fromJson(Map<String, dynamic> json) =>
      Meta(size: json['size'] as int?, alias: json['alias'] as String?);
}
