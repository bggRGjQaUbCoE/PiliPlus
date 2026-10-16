import 'package:PiliPlus/models_new/live/live_medal_wall/uinfo_medal.dart';

class LiveContributionRankItem {
  int? uid;
  String? name;
  String? face;
  int? score;
  UinfoMedal? uinfoMedal;

  LiveContributionRankItem({
    this.uid,
    this.name,
    this.face,
    this.score,
    this.uinfoMedal,
  });

  factory LiveContributionRankItem.fromJson(Map<String, dynamic> json) =>
      LiveContributionRankItem(
        uid: json['uid'] as int?,
        name: json['name'] as String?,
        face: json['face'] as String?,
        score: json['score'] as int?,
        uinfoMedal: json['uinfo']?['medal'] == null
            ? null
            : UinfoMedal.fromJson(json['uinfo']['medal']),
      );
}
