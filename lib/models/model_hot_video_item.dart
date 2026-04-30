import 'package:PiliPlus/models/horizontal_video_model.dart';
import 'package:PiliPlus/models/model_owner.dart';
import 'package:PiliPlus/models/model_video.dart';
import 'package:PiliPlus/models_new/video/video_detail/dimension.dart';
import 'package:PiliPlus/pages/common/multi_select/base.dart';

// 稍后再看, 排行榜等网页返回也使用该类
class HotVideoItemModel extends HorizontalVideoModel with MultiSelectData {
  int? videos;
  int? tid;
  String? tname;
  int? copyright;
  int? ctime;
  int? state;
  String? firstFrame;
  String? pubLocation;

  HotVideoItemModel.fromJson(Map<String, dynamic> json) {
    aid = json["aid"];
    cid = json["cid"];
    bvid = json["bvid"];
    videos = json["videos"];
    tid = json["tid"];
    tname = json["tname"];
    copyright = json["copyright"];
    cover = json["pic"];
    title = json["title"];
    pubdate = json["pubdate"];
    ctime = json["ctime"];
    desc = json["desc"];
    state = json["state"];
    duration = json["duration"];
    owner = Owner.fromJson(json["owner"]);
    stat = HotStat.fromJson(json['stat']);
    dimension = json['dimension'] == null
        ? null
        : Dimension.fromJson(json['dimension']);
    firstFrame = json["first_frame"];
    pubLocation = json["pub_location"];
    redirectUrl = json['redirect_url'];
    progress = json['progress'];
    if (json['charging_pay']?['level'] != null) {
      badge = '充电专属';
    } else if (json['rights']?['is_cooperation'] == 1) {
      badge = '合作';
    } else {
      badge = json['pgc_label'];
    }
  }
}

class HotStat extends Stat {
  int? reply;
  int? favorite;
  num? coin;
  int? share;
  int? nowRank;
  int? hisRank;
  int? dislike;
  int? vt;
  int? vv;

  HotStat.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    reply = json["reply"];
    favorite = json["favorite"];
    coin = json['coin'];
    share = json["share"];
    nowRank = json["now_rank"];
    hisRank = json['his_rank'];
    dislike = json["dislike"];
    vt = json['vt'];
    vv = json["vv"];
  }
}

// class RcmdReason {
//   RcmdReason({
//     this.rcornerMark,
//     this.content,
//   });

//   int? rcornerMark;
//   String? content = '';

//   RcmdReason.fromJson(Map<String, dynamic> json) {
//     rcornerMark = json["corner_mark"];
//     content = json["content"] ?? '';
//   }
// }
