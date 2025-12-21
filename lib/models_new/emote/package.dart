import 'package:PiliPlus/models_new/emote/emote.dart';

class Package {
  String? url;
  int? type;
  List<Emote>? emote;

  Package({this.url, this.type, this.emote});

  factory Package.fromJson(Map<String, dynamic> json) => Package(
    url: json['url'] as String?,
    type: json['type'] as int?,
    emote: (json['emote'] as List<dynamic>?)
        ?.map((e) => Emote.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
