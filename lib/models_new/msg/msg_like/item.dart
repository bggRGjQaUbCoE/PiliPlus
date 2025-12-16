import 'package:PiliPlus/models_new/msg/msg_like/content.dart';
import 'package:PiliPlus/models_new/msg/msg_like/user.dart';

class MsgLikeItem {
  int? id;
  List<User>? users;
  MsgLikeContent? item;
  int? counts;
  int? likeTime;
  int? noticeState;

  MsgLikeItem({
    this.id,
    this.users,
    this.item,
    this.counts,
    this.likeTime,
    this.noticeState,
  });

  factory MsgLikeItem.fromJson(Map<String, dynamic> json) => MsgLikeItem(
    id: json['id'] as int?,
    users: (json['users'] as List<dynamic>?)
        ?.map((e) => User.fromJson(e as Map<String, dynamic>))
        .toList(),
    item: json['item'] == null
        ? null
        : MsgLikeContent.fromJson(json['item'] as Map<String, dynamic>),
    counts: json['counts'] as int?,
    likeTime: json['like_time'] as int?,
    noticeState: json['notice_state'] as int?,
  );
}
