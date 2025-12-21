class IconFont {
  String? name;
  String? text;

  IconFont({this.name, this.text});

  factory IconFont.fromJson(Map<String, dynamic> json) =>
      IconFont(name: json['name'] as String?, text: json['text'] as String?);
}
