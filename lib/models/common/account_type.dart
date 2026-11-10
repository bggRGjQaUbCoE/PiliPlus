enum AccountType {
  main('主账号'),
  heartbeat('记录观看'),
  recommend('推荐'),
  video('视频取流'),
  search('搜索'),
  ;

  final String title;
  const AccountType(this.title);

  /// 仅用于界面展示顺序。
  ///
  /// index 会被 Hive 持久化，因此枚举声明顺序不能调整，
  /// 展示顺序改这里。
  static const List<AccountType> displayOrder = [
    main,
    heartbeat,
    recommend,
    search,
    video,
  ];
}
