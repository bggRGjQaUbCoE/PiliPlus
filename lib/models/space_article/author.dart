import 'package:PiliPlus/models/model_avatar.dart';
import 'package:PiliPlus/models/space_article/nameplate.dart';

class Author extends Avatar {
  Nameplate? nameplate;

  Author.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    nameplate = json['nameplate'] == null
        ? null
        : Nameplate.fromJson(json['nameplate']);
  }
}
