class WatchedShow {
  String? textLarge;

  WatchedShow({this.textLarge});

  factory WatchedShow.fromJson(Map<String, dynamic> json) =>
      WatchedShow(textLarge: json['text_large'] as String?);
}
