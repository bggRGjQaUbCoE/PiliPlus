enum UserOrderType {
  def('默认排序', 0, ''),
  fansDesc('粉丝数由高到低', 0, 'fans'),
  fansAsc('粉丝数由低到高', 1, 'fans'),
  levelDesc('Lv等级由高到低', 0, 'level'),
  levelAsc('Lv等级由低到高', 1, 'level');

  final String label;
  final int orderSort;
  final String order;
  const UserOrderType(this.label, this.orderSort, this.order);
}

enum UserType {
  all('全部用户'),
  up('UP主'),
  common('普通用户'),
  verified('认证用户');

  final String label;
  const UserType(this.label);
}
