class History {
  int? oid;
  int? epid;
  String? bvid;
  int? page;
  int? cid;
  String? part;
  String? business;

  History({
    this.oid,
    this.epid,
    this.bvid,
    this.page,
    this.cid,
    this.part,
    this.business,
  });

  factory History.fromJson(Map<String, dynamic> json) => History(
    oid: json['oid'],
    epid: json['epid'],
    bvid: json['bvid'],
    page: json['page'],
    cid: json['cid'] == 0 ? null : json['cid'],
    part: json['part'],
    business: json['business'],
  );
}
