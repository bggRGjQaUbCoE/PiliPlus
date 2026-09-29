import 'package:PiliPlus/l10n/l10n.dart';

enum DmBlockType {
  keyword,
  regex,
  uid,
  ;

  String get label => switch (this) {
    keyword => L10n.current.dmBlockTypeKeywordLabel,
    regex => L10n.current.dmBlockTypeRegexLabel,
    uid => L10n.current.user,
  };
}
