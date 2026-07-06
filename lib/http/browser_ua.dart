import 'package:PiliPlus/utils/platform_utils.dart';

abstract final class BrowserUa {
  static String get platform => PlatformUtils.isMobile ? mob : pc;

  static const pc =
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.2 Safari/605.1.15';

  static const mob =
      'Mozilla/5.0 (Linux; Android 10; SM-G975F) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.101 Mobile Safari/537.36 os/android build/8430300 osVer/10 sdkInt/29 network/2 BiliApp/8430300 mobi_app/android_q channel/master innerVer/8430300';
}
