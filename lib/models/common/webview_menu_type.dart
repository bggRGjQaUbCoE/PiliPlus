enum WebviewMenuItem {
  refresh('刷新'),
  copy('复制链接'),
  openInBrowser('浏览器中打开'),
  clearCache('清除缓存'),
  resetCookie('重新设置Cookie'),
  goBack('返回');

  final String title;
  const WebviewMenuItem(this.title);
}
