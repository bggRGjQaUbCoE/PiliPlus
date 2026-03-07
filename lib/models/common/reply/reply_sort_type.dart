enum ReplySortType {
  time('最新评论', '最新'),
  hot('最热评论', '最热'),
  select('精选评论', '精选')
  ;

  final String title;
  final String label;
  const ReplySortType(this.title, this.label);
}
