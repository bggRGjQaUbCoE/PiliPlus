import './model_owner.dart';
import 'model_video.dart';

abstract class BaseRecVideoItemModel extends BaseVideoItemModel {
  String? goto;
  String? uri;
  String? rcmdReason;

  // app推荐专属
  int? param;
  String? bangumiBadge;
}

class RecVideoItemModel extends BaseRecVideoItemModel {
  RecVideoItemModel.fromJson(Map<String, dynamic> json) {
    aid = json["id"];
    bvid = json["bvid"];
    cid = json["cid"];
    goto = json["goto"];
    uri = json["uri"];
    pic = json["pic"];
    title = json["title"];
    duration = json["duration"];
    pubdate = json["pubdate"];
    owner = Owner.fromJson(json["owner"]);
    stat = Stat.fromJson(json["stat"]);
    isFollowed = json["is_followed"] == 1;
    // rcmdReason = json["rcmd_reason"] != null
    //     ? RcmdReason.fromJson(json["rcmd_reason"])
    //     : RcmdReason(content: '');
    rcmdReason = json["rcmd_reason"]?['content'];
  }

  // @override
  // String? get desc => null;
}

// @HiveType(typeId: 2)
// class RcmdReason {
//   RcmdReason({
//     this.reasonType,
//     this.content,
//   });
// //   int? reasonType;
// //   String? content;
//
//   RcmdReason.fromJson(Map<String, dynamic> json) {
//     reasonType = json["reason_type"];
//     content = json["content"] ?? '';
//   }
// }
