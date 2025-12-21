class Stat {
  String? view;
  String? like;

  Stat({this.view, this.like});

  factory Stat.fromJson(Map<String, dynamic> json) =>
      Stat(view: json['view'] as String?, like: json['like'] as String?);
}
