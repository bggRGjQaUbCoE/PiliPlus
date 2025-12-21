enum SuperChatType {
  valid('有效时间内显示'),
  persist('常驻显示'),
  disable('不显示');

  final String title;
  const SuperChatType(this.title);
}
