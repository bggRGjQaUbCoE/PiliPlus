class Stat {
  int? aid;
  int? view;
  int? danmaku;

  Stat({
    this.aid,
    this.view,
    this.danmaku,
  });

  factory Stat.fromJson(Map<String, dynamic> json) => Stat(
    aid: json['aid'] as int?,
    view: json['view'] as int?,
    danmaku: json['danmaku'] as int?,
  );
}
