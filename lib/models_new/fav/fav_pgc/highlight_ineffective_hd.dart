class HighlightIneffectiveHd {
  String? typeUrl;

  HighlightIneffectiveHd({this.typeUrl});

  factory HighlightIneffectiveHd.fromJson(Map<String, dynamic> json) {
    return HighlightIneffectiveHd(typeUrl: json['type_url'] as String?);
  }
}
