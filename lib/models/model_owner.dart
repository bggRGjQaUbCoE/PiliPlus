import 'package:hive/hive.dart';

import 'model_video.dart';

part 'model_owner.g.dart';

@HiveType(typeId: 3)
class Owner implements BaseOwner {
  Owner({
    this.mid,
    this.name,
    this.face,
  });
  @HiveField(0)
  @override
  int? mid;
  @HiveField(1)
  @override
  String? name;
  @HiveField(2)
  String? face;

  Owner.fromJson(Map<String, dynamic> json) {
    mid = json["mid"];
    name = json["name"];
    face = json['face'];
  }
}
