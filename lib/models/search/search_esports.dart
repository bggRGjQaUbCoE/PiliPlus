import 'package:PiliPlus/models_new/match/match_info/contest.dart';

class SearchEsports {
  List<MatchContest> contest;

  SearchEsports({required this.contest});

  factory SearchEsports.fromJson(Map<String, dynamic> json) => SearchEsports(
    contest: (json['contest'] as List<dynamic>)
        .map((e) => MatchContest.fromSearch(e as Map<String, dynamic>))
        .toList(),
  );
}
