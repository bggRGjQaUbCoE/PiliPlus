import 'package:PiliPlus/l10n/l10n.dart';

enum FavOrderType {
  mtime,
  view,
  pubtime,
  ;

  String get label => switch (this) {
    mtime => L10n.current.favOrderTypeMtimeLabel,
    view => L10n.current.archiveOrderTypeWebClickLabel,
    pubtime => L10n.current.favOrderTypePubtimeLabel,
  };
}
