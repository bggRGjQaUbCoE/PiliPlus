enum MsgUnReadType {
  pm('私信'),
  reply('回复我的'),
  at('@我'),
  like('收到的赞'),
  sysMsg('系统通知');

  final String title;
  const MsgUnReadType(this.title);
}
