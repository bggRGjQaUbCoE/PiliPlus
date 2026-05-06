enum MemberTabType {
  def('默认'),
  home('主页'),
  dynamic('动态'),
  contribute('投稿'),
  favorite('收藏'),
  bangumi('番剧'),
  cheese('课堂'),
  shop('小店'),
  ;

  static bool contains(String type) {
    for (final e in MemberTabType.values) {
      if (e.name == type) {
        return true;
      }
    }
    return false;
  }

  final String title;
  const MemberTabType(this.title);
}
