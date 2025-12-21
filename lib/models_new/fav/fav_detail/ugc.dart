class Ugc {
  int? firstCid;

  Ugc({this.firstCid});

  factory Ugc.fromJson(Map<String, dynamic> json) =>
      Ugc(firstCid: json['first_cid'] as int?);
}
