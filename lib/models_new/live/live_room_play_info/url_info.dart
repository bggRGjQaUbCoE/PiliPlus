class UrlInfo {
  String host;
  String extra;

  UrlInfo({required this.host, required this.extra});

  factory UrlInfo.fromJson(Map<String, dynamic> json) => UrlInfo(
    host: json['host'] as String,
    extra: json['extra'] as String,
  );
}
