import 'package:PiliPlus/l10n/l10n.dart';

enum AccountType {
  main,
  heartbeat,
  recommend,
  video,
  ;

  String get title => switch (this) {
    main => L10n.current.accountTypeMainTitle,
    heartbeat => L10n.current.accountTypeHeartbeatTitle,
    recommend => L10n.current.recommended,
    video => L10n.current.accountTypeVideoTitle,
  };
}
