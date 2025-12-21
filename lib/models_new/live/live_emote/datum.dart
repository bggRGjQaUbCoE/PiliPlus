import 'package:PiliPlus/models_new/live/live_emote/emoticon.dart';

class LiveEmoteDatum {
  List<Emoticon>? emoticons;
  int? pkgType;
  String? currentCover;

  LiveEmoteDatum({this.emoticons, this.pkgType, this.currentCover});

  factory LiveEmoteDatum.fromJson(Map<String, dynamic> json) => LiveEmoteDatum(
    emoticons: (json['emoticons'] as List<dynamic>?)
        ?.map((e) => Emoticon.fromJson(e as Map<String, dynamic>))
        .toList(),
    pkgType: json['pkg_type'] as int?,
    currentCover: json['current_cover'] as String?,
  );
}
