class FirstEp {
  String? cover;
  int? epId;

  FirstEp({this.cover, this.epId});

  factory FirstEp.fromJson(Map<String, dynamic> json) =>
      FirstEp(cover: json['cover'] as String?, epId: json['ep_id'] as int?);
}
