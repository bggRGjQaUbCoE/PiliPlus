class BaseEmote {
  late String url;
  late String emoticonUnique;
  late double width;
  double? height;
  late final isUpower = emoticonUnique.startsWith('upower_');

  BaseEmote.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    emoticonUnique = json['emoticon_unique'];
    width = (json['width'] as num).toDouble();
    height = (json['height'] as num?)?.toDouble();
  }
}

// class Emote extends BaseEmote {
//   late int count;
//   late String descript;
//   late String emoji;
//   late int emoticonId;
// }

/*
{
  "bulge_display": 1,
  "emoticon_unique": "upower_[{{emote}}]",
  "height": {{height}},
  "in_player_area": 1,
  "is_dynamic": 0, // 0 or 1
  "url": "{{url}}",
  "width": {{width}}
}

{
  "bulge_display": 1,
  "emoticon_unique": "room_{{room_id}}_{{int}}",
  "height": {{height}},
  "in_player_area": 1,
  "is_dynamic": 1,
  "url": "{{url}}",
  "width": {{width}}
}

*/
// class Uemote extends BaseEmote {
//   late int bulgeDisplay;
//   late int inPlayerArea;
//   late int isDynamic;
// }
