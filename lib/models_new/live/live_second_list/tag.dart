class LiveSecondTag {
  int? id;
  String? name;
  String? sortType;

  LiveSecondTag({this.id, this.name, this.sortType});

  factory LiveSecondTag.fromJson(Map json) => LiveSecondTag(
    id: json['id'],
    name: json['name'],
    sortType: json['sort_type'],
  );
}
