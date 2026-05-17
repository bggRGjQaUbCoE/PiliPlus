enum ReplySortType {
  time('最新评论', '最新', text: '按时间'),
  hot('最热评论', '最热', text: '按热度'),
  select('精选评论', '精选'),
  ;

  final String title;
  final String label;
  final String? text;
  const ReplySortType(this.title, this.label, {this.text});
}
