class Area {
  int? id;
  String? name;

  Area({this.id, this.name});

  factory Area.fromJson(Map<String, dynamic> json) =>
      Area(id: json['id'] as int?, name: json['name'] as String?);
}
