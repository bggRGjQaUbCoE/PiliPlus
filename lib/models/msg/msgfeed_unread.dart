import 'package:fixnum/fixnum.dart';

class MsgFeedUnread {
  int at = 0;
  int like = 0;
  int reply = 0;
  int sysMsg = 0;

  MsgFeedUnread.fromJson(Map<String, Int64> json) {
    at = json['at']?.toInt() ?? 0;
    like = json['like']?.toInt() ?? 0;
    reply = json['reply']?.toInt() ?? 0;
    sysMsg = json['sys_msg']?.toInt() ?? 0;
  }
}
