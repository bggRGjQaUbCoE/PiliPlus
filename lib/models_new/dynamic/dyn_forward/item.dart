import 'package:PiliPlus/models/dynamics/result.dart';

class DynForwardItem {
  String? idStr;
  String? pubTime;
  DynamicDescModel? desc;
  ModuleAuthorModel? user;

  DynForwardItem.fromJson(Map<String, dynamic> json) {
    idStr = json['id_str']?.toString();
    pubTime = json['pub_time']?.toString();

    final desc = json['desc'];
    if (desc is Map) {
      this.desc = DynamicDescModel.fromJson(Map<String, dynamic>.from(desc));
    }

    final user = json['user'];
    if (user is Map) {
      this.user = ModuleAuthorModel.fromJson(Map<String, dynamic>.from(user));
    }
  }
}
