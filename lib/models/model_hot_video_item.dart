import 'package:PiliPlus/models/model_owner.dart';
import 'package:PiliPlus/models/model_rec_video_item.dart';
import 'package:PiliPlus/models/model_video.dart';
import 'package:PiliPlus/models_new/video/video_detail/dimension.dart';
import 'package:PiliPlus/pages/common/multi_select/base.dart';

// 稍后再看, 排行榜等网页返回也使用该类
class HotVideoItemModel extends BaseRcmdVideoItemModel with MultiSelectData {
  int? videos;
  int? tid;
  String? tname;
  int? copyright;
  int? ctime;
  int? state;
  Dimension? dimension;
  String? firstFrame;
  String? pubLocation;
  String? pgcLabel;
  String? redirectUrl;
  num? progress;
  int? isCooperation;
  bool? isCharging;

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
    dimension = Dimension.fromJson(json['dimension']);
    firstFrame = json["first_frame"];
    pubLocation = json["pub_location"];
    dynamic rcmd = json['rcmd_reason'];
    rcmdReason = rcmd is Map ? rcmd['content'] : rcmd; // 相关视频里rcmd为String,
    if (rcmdReason?.isEmpty == true) rcmdReason = null;
    pgcLabel = json['pgc_label'];
    redirectUrl = json['redirect_url'];
    // uri = json['uri']; // 仅在稍后再看存在
    progress = json['progress'];
    isCooperation = json['rights']?['is_cooperation'];
    isCharging = json['charging_pay']?['level'] != null;
  }

  // @override
  // get isFollowed => false;
  // @override
  // get goto => 'av';
  // @override
  // get uri => 'bilibili://video/$aid';
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
