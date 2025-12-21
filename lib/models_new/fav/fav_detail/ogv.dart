class Ogv {
  String? typeName;
  int? typeId;
  int? seasonId;

  Ogv({this.typeName, this.typeId, this.seasonId});

  factory Ogv.fromJson(Map<String, dynamic> json) => Ogv(
    typeName: json['type_name'],
    typeId: json['type_id'],
    seasonId: json['season_id'],
  );
}
