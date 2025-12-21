enum DmBlockType {
  keyword('关键词'),
  regex('正则'),
  uid('用户');

  final String label;
  const DmBlockType(this.label);
}
