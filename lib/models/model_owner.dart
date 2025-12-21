import 'package:PiliPlus/models/model_video.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:hive/hive.dart';

part 'model_owner.g.dart';

@HiveType(typeId: 3)
class Owner implements BaseOwner {
  Owner({this.mid, this.name, this.face});
  @HiveField(0)
  @override
  int? mid;
  @HiveField(1)
  @override
  String? name;
  @HiveField(2)
  String? face;

  Owner.fromJson(Map<String, dynamic> json) {
    mid = Utils.safeToInt(json["mid"]);
    name = json["name"];
    face = json['face'];
  }

  Map<String, dynamic> toJson() => {'mid': mid, 'name': name, 'face': face};
}
