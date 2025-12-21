enum VideoPubTimeType {
  all('不限'),
  day('最近一天'),
  week('最近一周'),
  halfYear('最近半年');

  final String label;
  const VideoPubTimeType(this.label);
}

enum VideoDurationType {
  all('全部时长'),
  tenMins('0-10分钟'),
  halfHour('10-30分钟'),
  hour('30-60分钟'),
  hourPlus('60分钟+');

  final String label;
  const VideoDurationType(this.label);
}

enum VideoZoneType {
  all('全部'),
  douga('动画', tids: 1),
  anime('番剧', tids: 13),
  guochuang('国创', tids: 167),
  music('音乐', tids: 3),
  dance('舞蹈', tids: 129),
  game('游戏', tids: 4),
  knowledge('知识', tids: 36),
  tech('科技', tids: 188),
  sports('运动', tids: 234),
  car('汽车', tids: 223),
  life('生活', tids: 160),
  food('美食', tids: 221),
  animal('动物', tids: 217),
  kichiku('鬼畜', tids: 119),
  fashion('时尚', tids: 115),
  info('资讯', tids: 202),
  ent('娱乐', tids: 5),
  cinephile('影视', tids: 181),
  documentary('记录', tids: 177),
  movie('电影', tids: 23),
  tv('电视', tids: 11);

  final String label;
  final int? tids;
  const VideoZoneType(this.label, {this.tids});
}

// 搜索类型为视频、专栏及相簿时
enum ArchiveFilterType {
  totalrank('默认排序'),
  click('播放多'),
  pubdate('新发布'),
  dm('弹幕多'),
  stow('收藏多'),
  scores('评论多');
  // 专栏
  // attention('最多喜欢'),

  final String desc;
  const ArchiveFilterType(this.desc);
}
