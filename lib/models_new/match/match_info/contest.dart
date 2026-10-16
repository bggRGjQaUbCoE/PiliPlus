import 'package:PiliPlus/models_new/match/match_info/season.dart';
import 'package:PiliPlus/models_new/match/match_info/team.dart';
import 'package:PiliPlus/utils/parse_string.dart';

class MatchContest {
  int? id;
  String? gameStage;
  int? stime;
  int? homeScore;
  int? awayScore;
  int? liveRoom;
  MatchSeason? season;
  MatchTeam? homeTeam;
  MatchTeam? awayTeam;
  int? contestStatus;
  String? playback;

  MatchContest({
    this.id,
    this.gameStage,
    this.stime,
    this.homeScore,
    this.awayScore,
    this.liveRoom,
    this.season,
    this.homeTeam,
    this.awayTeam,
    this.contestStatus,
    this.playback,
  });

  factory MatchContest.fromJson(Map<String, dynamic> json) => MatchContest(
    gameStage: nonNullOrEmptyString(json['game_stage'] as String?),
    stime: json['stime'] as int?,
    homeScore: json['home_score'] as int?,
    awayScore: json['away_score'] as int?,
    liveRoom: json['live_room'] as int?,
    season: json['season'] == null
        ? null
        : MatchSeason.fromJson(json['season'] as Map<String, dynamic>),
    homeTeam: json['home_team'] == null
        ? null
        : MatchTeam.fromJson(json['home_team'] as Map<String, dynamic>),
    awayTeam: json['away_team'] == null
        ? null
        : MatchTeam.fromJson(json['away_team'] as Map<String, dynamic>),
    contestStatus: json['contest_status'] as int?,
    playback: json['playback'] as String?,
  );

  factory MatchContest.fromSearch(Map<String, dynamic> json) => MatchContest(
    id: json['ID'] as int,
    gameStage: nonNullOrEmptyString(json['gameStage'] as String?),
    stime: json['stime'] as int?,
    homeScore: json['homeScore'] as int?,
    awayScore: json['awayScore'] as int?,
    liveRoom: json['liveRoom'] as int?,
    season: json['season'] == null
        ? null
        : MatchSeason.fromJson(json['season']),
    homeTeam: MatchTeam.fromJson(json['homeTeam']),
    awayTeam: MatchTeam.fromJson(json['awayTeam']),
    contestStatus: json['contestStatus'] as int?,
    playback: json['playback'] as String?,
  );
}
