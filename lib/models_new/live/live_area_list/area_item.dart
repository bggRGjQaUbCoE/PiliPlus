class AreaItem {
  dynamic id;
  String? name;
  String? pic;
  dynamic parentId;
  String? parentName;

  AreaItem({this.id, this.name, this.pic, this.parentId, this.parentName});

  factory AreaItem.fromJson(Map<String, dynamic> json) => AreaItem(
    id: json['id'],
    name: json['name'] as String?,
    pic: json['pic'] as String?,
    parentId: json['parent_id'],
    parentName: json['parent_name'] as String?,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is AreaItem) {
      return id == other.id && parentId == other.parentId;
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(id, parentId);
}
