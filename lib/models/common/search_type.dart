// ignore_for_file: constant_identifier_names
enum SearchType {
  // all,
  // 视频：video
  video('视频'),
  // 番剧：media_bangumi,
  media_bangumi('番剧'),
  // 影视：media_ft
  media_ft('影视'),
  // 直播间及主播：live
  // live,
  // 直播间：live_room
  live_room('直播间'),
  // 主播：live_user
  // live_user,
  // 话题：topic
  // topic,
  // 用户：bili_user
  bili_user('用户'),
  // 专栏：article
  article('专栏');
  // 相簿：photo
  // photo

  final String label;
  const SearchType(this.label);
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

  final String description;
  const ArchiveFilterType(this.description);
}
