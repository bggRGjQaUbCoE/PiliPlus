class HighlightIneffectivePink {
  String? typeUrl;

  HighlightIneffectivePink({this.typeUrl});

  factory HighlightIneffectivePink.fromJson(Map<String, dynamic> json) {
    return HighlightIneffectivePink(typeUrl: json['type_url'] as String?);
  }
}
