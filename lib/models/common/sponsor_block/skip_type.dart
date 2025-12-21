enum SkipType {
  alwaysSkip('总是跳过'),
  skipOnce('跳过一次'),
  skipManually('手动跳过'),
  showOnly('仅显示'),
  disable('禁用');

  final String title;
  const SkipType(this.title);
}
