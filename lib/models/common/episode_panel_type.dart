import 'package:PiliPlus/l10n/l10n.dart';

enum EpisodeType {
  part,
  season,
  pgc,
  ;

  String get title => switch (this) {
    part => L10n.current.episodeTypePartTitle,
    season => L10n.current.collection,
    pgc => L10n.current.rankTypeTvLabel,
  };
}
