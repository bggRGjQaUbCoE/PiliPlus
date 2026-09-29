import 'package:PiliPlus/l10n/l10n.dart';

enum VideoPubTimeType {
  all,
  day,
  week,
  halfYear,
  ;

  String get label => switch (this) {
    all => L10n.current.videoPubTimeTypeAllLabel,
    day => L10n.current.videoPubTimeTypeDayLabel,
    week => L10n.current.videoPubTimeTypeWeekLabel,
    halfYear => L10n.current.videoPubTimeTypeHalfYearLabel,
  };
}

enum VideoDurationType {
  all,
  tenMins,
  halfHour,
  hour,
  hourPlus,
  ;

  String get label => switch (this) {
    all => L10n.current.videoDurationTypeAllLabel,
    tenMins => L10n.current.videoDurationTypeTenMinsLabel,
    halfHour => L10n.current.videoDurationTypeHalfHourLabel,
    hour => L10n.current.videoDurationTypeHourLabel,
    hourPlus => L10n.current.videoDurationTypeHourPlusLabel,
  };
}

enum VideoZoneType {
  all,
  douga(tids: 1),
  anime(tids: 13),
  guochuang(tids: 167),
  music(tids: 3),
  dance(tids: 129),
  game(tids: 4),
  knowledge(tids: 36),
  tech(tids: 188),
  sports(tids: 234),
  car(tids: 223),
  life(tids: 160),
  food(tids: 221),
  animal(tids: 217),
  kichiku(tids: 119),
  fashion(tids: 115),
  info(tids: 202),
  ent(tids: 5),
  cinephile(tids: 181),
  documentary(tids: 177),
  movie(tids: 23),
  tv(tids: 11),
  ;

  String get label => switch (this) {
    all => L10n.current.all,
    douga => L10n.current.videoZoneTypeDougaLabel,
    anime => L10n.current.bangumi,
    guochuang => L10n.current.videoZoneTypeGuochuangLabel,
    music => L10n.current.videoZoneTypeMusicLabel,
    dance => L10n.current.videoZoneTypeDanceLabel,
    game => L10n.current.videoZoneTypeGameLabel,
    knowledge => L10n.current.videoZoneTypeKnowledgeLabel,
    tech => L10n.current.videoZoneTypeTechLabel,
    sports => L10n.current.videoZoneTypeSportsLabel,
    car => L10n.current.videoZoneTypeCarLabel,
    life => L10n.current.videoZoneTypeLifeLabel,
    food => L10n.current.videoZoneTypeFoodLabel,
    animal => L10n.current.videoZoneTypeAnimalLabel,
    kichiku => L10n.current.videoZoneTypeKichikuLabel,
    fashion => L10n.current.videoZoneTypeFashionLabel,
    info => L10n.current.videoZoneTypeInfoLabel,
    ent => L10n.current.videoZoneTypeEntLabel,
    cinephile => L10n.current.cinema,
    documentary => L10n.current.videoZoneTypeDocumentaryLabel,
    movie => L10n.current.videoZoneTypeMovieLabel,
    tv => L10n.current.videoZoneTypeTvLabel,
  };
  final int? tids;
  const VideoZoneType({this.tids});
}

// 搜索类型为视频、专栏及相簿时
enum ArchiveFilterType {
  totalrank,
  click,
  pubdate,
  dm,
  stow,
  scores,
  ;

  // 专栏
  // attention('最多喜欢'),

  String get desc => switch (this) {
    totalrank => L10n.current.archiveFilterTypeTotalrankDesc,
    click => L10n.current.archiveFilterTypeClickDesc,
    pubdate => L10n.current.archiveFilterTypePubdateDesc,
    dm => L10n.current.archiveFilterTypeDmDesc,
    stow => L10n.current.archiveFilterTypeStowDesc,
    scores => L10n.current.archiveFilterTypeScoresDesc,
  };
}
