import 'package:PiliPlus/l10n/l10n.dart';

enum MsgUnReadType {
  pm,
  reply,
  at,
  like,
  sysMsg,
  ;

  String get title => switch (this) {
    pm => L10n.current.privateMessage,
    reply => L10n.current.msgUnReadTypeReplyTitle,
    at => L10n.current.msgUnReadTypeAtTitle,
    like => L10n.current.msgUnReadTypeLikeTitle,
    sysMsg => L10n.current.msgUnReadTypeSysMsgTitle,
  };
}
