import 'package:PiliPlus/utils/parse_string.dart';

class SearchEsports {
  EsportsConfigInfo configInfo;
  List<EsportsContest> contest;

  SearchEsports({required this.configInfo, required this.contest});

  factory SearchEsports.fromJson(Map<String, dynamic> json) => SearchEsports(
    configInfo: EsportsConfigInfo.fromJson(
      json['config_info'] as Map<String, dynamic>,
    ),
    contest: (json['contest'] as List<dynamic>)
        .map((e) => EsportsContest.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

class EsportsContest {
  int id;
  String? gameStage;
  int? homeScore;
  int? awayScore;
  EsportsTeam homeTeam;
  EsportsTeam awayTeam;
  int liveRoom;
  String? playback;
  int? contestStatus;
  int? stime;

  EsportsContest({
    required this.id,
    this.gameStage,
    this.homeScore,
    this.awayScore,
    required this.homeTeam,
    required this.awayTeam,
    required this.liveRoom,
    this.playback,
    this.contestStatus,
    this.stime,
  });

  factory EsportsContest.fromJson(Map<String, dynamic> json) => EsportsContest(
    id: json['ID'] as int,
    gameStage: nonNullOrEmptyString(json['gameStage'] as String?),
    homeScore: json['homeScore'] as int?,
    awayScore: json['awayScore'] as int?,
    homeTeam: EsportsTeam.fromJson(json['homeTeam'] as Map<String, dynamic>),
    awayTeam: EsportsTeam.fromJson(json['awayTeam'] as Map<String, dynamic>),
    liveRoom: json['liveRoom'] as int,
    playback: json['playback'] as String?,
    contestStatus: json['contestStatus'] as int?,
    stime: json['stime'] as int?,
  );
}

class EsportsConfigInfo {
  String esportTitle;
  List<EsportsBtnList>? btnList;

  EsportsConfigInfo({required this.esportTitle, this.btnList});

  factory EsportsConfigInfo.fromJson(Map<String, dynamic> json) =>
      EsportsConfigInfo(
        esportTitle: json['esport_title'] as String,
        btnList: (json['btn_list'] as List<dynamic>?)
            ?.map((e) => EsportsBtnList.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class EsportsTeam {
  String title;
  String logoFull;

  EsportsTeam({required this.title, required this.logoFull});

  factory EsportsTeam.fromJson(Map<String, dynamic> json) => EsportsTeam(
    title: json['title'] as String,
    logoFull: json['logoFull'] as String,
  );
}

class EsportsBtnList {
  String text;
  String link;

  EsportsBtnList({required this.text, required this.link});

  factory EsportsBtnList.fromJson(Map<String, dynamic> json) => EsportsBtnList(
    text: json['text'] as String,
    link: json['link'] as String,
  );
}
