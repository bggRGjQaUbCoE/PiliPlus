import 'package:PiliPlus/l10n/l10n.dart';

enum RankType {
  all(rid: 0),
  anime(seasonType: 1),
  guochuang(seasonType: 4),
  douga(rid: 1005),
  music(rid: 1003),
  dance(rid: 1004),
  game(rid: 1008),
  knowledge(rid: 1010),
  tech(rid: 1012),
  sports(rid: 1018),
  car(rid: 1013),
  food(rid: 1020),
  animal(rid: 1024),
  kichiku(rid: 1007),
  fashion(rid: 1014),
  ent(rid: 1002),
  cinephile(rid: 1001),
  documentary(seasonType: 3),
  movie(seasonType: 2),
  tv(seasonType: 5),
  variety(seasonType: 7),
  ;

  String get label => switch (this) {
    all => L10n.current.rankTypeAllLabel,
    anime => L10n.current.bangumi,
    guochuang => L10n.current.videoZoneTypeGuochuangLabel,
    douga => L10n.current.videoZoneTypeDougaLabel,
    music => L10n.current.videoZoneTypeMusicLabel,
    dance => L10n.current.videoZoneTypeDanceLabel,
    game => L10n.current.videoZoneTypeGameLabel,
    knowledge => L10n.current.videoZoneTypeKnowledgeLabel,
    tech => L10n.current.videoZoneTypeTechLabel,
    sports => L10n.current.videoZoneTypeSportsLabel,
    car => L10n.current.videoZoneTypeCarLabel,
    food => L10n.current.videoZoneTypeFoodLabel,
    animal => L10n.current.videoZoneTypeAnimalLabel,
    kichiku => L10n.current.videoZoneTypeKichikuLabel,
    fashion => L10n.current.videoZoneTypeFashionLabel,
    ent => L10n.current.videoZoneTypeEntLabel,
    cinephile => L10n.current.cinema,
    documentary => L10n.current.videoZoneTypeDocumentaryLabel,
    movie => L10n.current.videoZoneTypeMovieLabel,
    tv => L10n.current.rankTypeTvLabel,
    variety => L10n.current.rankTypeVarietyLabel,
  };
  final int? rid;
  final int? seasonType;
  const RankType({this.rid, this.seasonType});
}
