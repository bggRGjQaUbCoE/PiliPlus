import 'package:PiliPlus/models/model_owner.dart';

class Avatar extends Owner {
  Pendant? pendant;
  BaseOfficialVerify? officialVerify;
  Vip? vip;

  Avatar.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json['pendant'] != null) pendant = Pendant.fromJson(json['pendant']);
    if (json['official_verify'] != null) {
      officialVerify = BaseOfficialVerify.fromJson(json['official_verify']);
    }
    if (json['vip'] != null) vip = Vip.fromJson(json['vip']);
  }
}

class Pendant {
  int? pid;
  String? name;
  String? image;

  Pendant.fromJson(Map<String, dynamic> json) {
    pid = json['pid'];
    name = json['name'];
    image = json['image'];
  }
}

class BaseOfficialVerify {
  int? type;
  String? desc;

  BaseOfficialVerify.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    desc = json['desc'];
  }
}

class Vip {
  int? type;
  late int status;
  int? dueDate;
  Label? label;

  Vip.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    status = json['status'] ?? 0;
    dueDate = json['due_date'];
    if (json['label'] != null) label = Label.fromJson(json['label']);
  }
}

class Label {
  String? path;
  String? text;
  String? labelTheme;
  String? textColor;
  int? bgStyle;
  String? bgColor;
  String? borderColor;
  String? image;

  Label.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    text = json['text'];
    labelTheme = json['label_theme'];
    textColor = json['text_color'];
    bgStyle = json['bg_style'];
    bgColor = json['bg_color'];
    borderColor = json['border_color'];
    image = json['image'];
  }
}
