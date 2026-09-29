import 'package:PiliPlus/l10n/l10n.dart';

enum WebviewMenuItem {
  refresh,
  copy,
  openInBrowser,
  clearCache,
  resetCookie,
  goBack,
  ;

  String get title => switch (this) {
    refresh => L10n.current.refresh,
    copy => L10n.current.copyLink,
    openInBrowser => L10n.current.webviewMenuItemOpenInBrowserTitle,
    clearCache => L10n.current.clearCache,
    resetCookie => L10n.current.webviewMenuItemResetCookieTitle,
    goBack => L10n.current.back,
  };
}
