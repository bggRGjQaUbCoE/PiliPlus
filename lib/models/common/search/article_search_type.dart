enum ArticleOrderType {
  totalrank('综合排序'),
  pubdate('最新发布'),
  click('最多点击'),
  attention('最多喜欢'),
  scores('最多评论');

  String get order => name;
  final String label;
  const ArticleOrderType(this.label);
}

enum ArticleZoneType {
  all('全部分区', 0),
  douga('动画', 2),
  game('游戏', 1),
  cinephile('影视', 28),
  life('生活', 3),
  interest('兴趣', 29),
  novel('轻小说', 16),
  tech('科技', 17),
  note('笔记', 41);

  final String label;
  final int categoryId;
  const ArticleZoneType(this.label, this.categoryId);
}
