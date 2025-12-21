class HighlightIneffectiveOtt {
  String? typeUrl;

  HighlightIneffectiveOtt({this.typeUrl});

  factory HighlightIneffectiveOtt.fromJson(Map<String, dynamic> json) {
    return HighlightIneffectiveOtt(typeUrl: json['type_url'] as String?);
  }
}
