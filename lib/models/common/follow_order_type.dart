enum FollowOrderType {
  def('', '最近关注'),
  attention('attention', '最常访问');

  final String type;
  final String title;

  const FollowOrderType(this.type, this.title);
}
