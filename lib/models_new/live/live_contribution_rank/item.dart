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

  static String? _face(Map<String, dynamic> json) {
    // Risk-controlled (logged-in) responses may blank the top-level face;
    // the real avatar lives under uinfo.base(.origin_info).
    final face = json['face'] as String?;
    if (face != null && face.isNotEmpty) return face;
    final base = json['uinfo']?['base'];
    final baseFace = base?['face'] as String?;
    if (baseFace != null && baseFace.isNotEmpty) return baseFace;
    return base?['origin_info']?['face'] as String?;
  }

  factory LiveContributionRankItem.fromJson(Map<String, dynamic> json) =>
      LiveContributionRankItem(
        uid: json['uid'] as int?,
        name: json['name'] as String?,
        face: _face(json),
        score: json['score'] as int?,
        uinfoMedal: json['uinfo']?['medal'] == null
            ? null
            : UinfoMedal.fromJson(json['uinfo']?['medal']),
      );
}
