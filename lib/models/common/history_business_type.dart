enum HistoryBusinessType {
  // 普通视频
  archive('archive'),
  // 剧集（番剧 / 影视）
  pgc('pgc'),
  // 直播
  live('live'),
  // 文章
  articleList('article-list'),
  // 文章
  article('article');

  // 隐藏时长
  static const hiddenDurationType = {'live', 'article-list', 'article'};
  // 右上
  static const showBadge = {'pgc', 'article-list', 'article'};

  final String type;
  const HistoryBusinessType(this.type);
}
