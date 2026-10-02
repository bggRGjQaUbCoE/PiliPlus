enum SuperChatTimeType {
  whenPersist('仅SC常驻模式下显示'),
  always('始终显示'),
  disable('不显示'),
  ;

  final String title;
  const SuperChatTimeType(this.title);
}
