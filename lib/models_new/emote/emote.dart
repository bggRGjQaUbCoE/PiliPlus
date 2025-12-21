import 'package:PiliPlus/models_new/emote/meta.dart';

class Emote {
  String? text;
  String? url;
  Meta? meta;

  Emote({this.text, this.url, this.meta});

  factory Emote.fromJson(Map<String, dynamic> json) => Emote(
    text: json['text'] as String?,
    url: json['url'] as String?,
    meta: json['meta'] == null
        ? null
        : Meta.fromJson(json['meta'] as Map<String, dynamic>),
  );
}
