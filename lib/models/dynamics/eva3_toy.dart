import 'package:PiliPlus/models/dynamics/eva3_user.dart';

class Eva3Toy {
  Eva3ToyInfo? info;

  Eva3Toy({this.info});

  factory Eva3Toy.fromJson(Map<String, dynamic> json) => Eva3Toy(
    info: json['info'] == null
        ? null
        : Eva3ToyInfo.fromJson(json['info'] as Map<String, dynamic>),
  );
}

class Eva3ToyInfo {
  Eva3UserDetail? up;
  String? title;
  String? poster;
  String? statText;
  String? jumpUri;

  Eva3ToyInfo({
    this.up,
    this.title,
    this.poster,
    this.statText,
    this.jumpUri,
  });

  factory Eva3ToyInfo.fromJson(Map<String, dynamic> json) => Eva3ToyInfo(
    up: json['up'] == null ? null : Eva3UserDetail.fromJson(json['up']),
    title: json['title'],
    poster: json['poster'],
    statText: json['stat_text'],
    jumpUri: json['jump_uri'],
  );
}
