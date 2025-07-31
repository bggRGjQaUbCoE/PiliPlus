import 'package:PiliPlus/models_new/video/video_detail/stat_detail.dart';

class VideoStat extends StatDetail {
  int? aid;
  int? nowRank;
  int? hisRank;
  int? dislike;
  String? evaluation;

  VideoStat.fromJson(Map<String, dynamic> json) {
    aid = json['aid'] as int?;
    view = json['view'] as int?;
    danmaku = json['danmaku'] as int?;
    reply = json['reply'] as int?;
    favorite = json['favorite'] as int? ?? 0;
    coin = json['coin'] as num? ?? 0;
    share = json['share'] as int?;
    nowRank = json['now_rank'] as int?;
    hisRank = json['his_rank'] as int?;
    like = json['like'] as int? ?? 0;
    dislike = json['dislike'] as int?;
    evaluation = json['evaluation'] as String?;
    vt = json['vt'] as int?;
  }
}
