enum RankType {
  all('全站', rid: 0),
  anime('番剧', seasonType: 1),
  guochuang('国创', seasonType: 4),
  douga('动画', rid: 1005),
  music('音乐', rid: 1003),
  dance('舞蹈', rid: 1004),
  game('游戏', rid: 1008),
  knowledge('知识', rid: 1010),
  tech('科技', rid: 1012),
  sports('运动', rid: 1018),
  car('汽车', rid: 1013),
  food('美食', rid: 1020),
  animal('动物', rid: 1024),
  kichiku('鬼畜', rid: 1007),
  fashion('时尚', rid: 1014),
  ent('娱乐', rid: 1002),
  cinephile('影视', rid: 1001),
  documentary('记录', seasonType: 3),
  movie('电影', seasonType: 2),
  tv('剧集', seasonType: 5),
  variety('综艺', seasonType: 7);

  final String label;
  final int? rid;
  final int? seasonType;
  const RankType(this.label, {this.rid, this.seasonType});
}
