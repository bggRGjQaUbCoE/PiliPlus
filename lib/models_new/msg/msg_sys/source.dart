class Source {
  String? name;
  String? logo;

  Source({this.name, this.logo});

  factory Source.fromJson(Map<String, dynamic> json) =>
      Source(name: json['name'] as String?, logo: json['logo'] as String?);
}
