import 'package:PiliPlus/l10n/l10n.dart';

enum ArticleOrderType {
  totalrank,
  pubdate,
  click,
  attention,
  scores,
  ;

  String get order => name;
  String get label => switch (this) {
    totalrank => L10n.current.articleOrderTypeTotalrankLabel,
    pubdate => L10n.current.archiveOrderTypeWebPubdateLabel,
    click => L10n.current.articleOrderTypeClickLabel,
    attention => L10n.current.articleOrderTypeAttentionLabel,
    scores => L10n.current.articleOrderTypeScoresLabel,
  };
}

enum ArticleZoneType {
  all(0),
  douga(2),
  game(1),
  cinephile(28),
  life(3),
  interest(29),
  novel(16),
  tech(17),
  note(41),
  ;

  String get label => switch (this) {
    all => L10n.current.articleZoneTypeAllLabel,
    douga => L10n.current.videoZoneTypeDougaLabel,
    game => L10n.current.videoZoneTypeGameLabel,
    cinephile => L10n.current.cinema,
    life => L10n.current.videoZoneTypeLifeLabel,
    interest => L10n.current.articleZoneTypeInterestLabel,
    novel => L10n.current.articleZoneTypeNovelLabel,
    tech => L10n.current.videoZoneTypeTechLabel,
    note => L10n.current.favTabTypeNoteTitle,
  };
  final int categoryId;
  const ArticleZoneType(this.categoryId);
}
