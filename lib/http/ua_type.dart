import 'package:PiliPlus/utils/platform_utils.dart';

enum UaType {
  mob(mobUa),
  pc(pcUa)
  ;

  static UaType get platformUA => PlatformUtils.isMobile ? mob : pc;

  final String ua;
  const UaType(this.ua);

  static const pcUa =
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.2 Safari/605.1.15';

  static const mobUa =
      'Mozilla/5.0 (Linux; Android 10; SM-G975F) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.101 Mobile Safari/537.36';
}
