class ListTag {
  int? tid;
  int? count;
  String? name;
  String? specialType;

  ListTag({this.tid, this.count, this.name, this.specialType});

  factory ListTag.fromJson(Map<String, dynamic> json) => ListTag(
    tid: json['tid'] as int?,
    count: json['count'] as int?,
    name: json['name'] as String?,
    specialType: json['special_type'] as String?,
  );
}
