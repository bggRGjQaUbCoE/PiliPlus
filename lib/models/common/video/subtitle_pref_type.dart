import 'package:PiliPlus/l10n/l10n.dart';

enum SubtitlePrefType {
  off,
  on,
  withoutAi,
  auto,
  ;

  String get desc => switch (this) {
    off => L10n.current.subtitlePrefTypeOffDesc,
    on => L10n.current.subtitlePrefTypeOnDesc,
    withoutAi => L10n.current.subtitlePrefTypeWithoutAiDesc,
    auto => L10n.current.subtitlePrefTypeAutoDesc,
  };
}
