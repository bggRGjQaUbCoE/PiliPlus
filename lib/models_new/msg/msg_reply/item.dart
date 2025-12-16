import 'package:PiliPlus/models_new/msg/msg_reply/content.dart';
import 'package:PiliPlus/models_new/msg/msg_reply/user.dart';

class MsgReplyItem {
  int? id;
  User? user;
  MsgReplyContent? item;
  int? counts;
  int? isMulti;
  int? replyTime;

  MsgReplyItem({
    this.id,
    this.user,
    this.item,
    this.counts,
    this.isMulti,
    this.replyTime,
  });

  factory MsgReplyItem.fromJson(Map<String, dynamic> json) => MsgReplyItem(
    id: json['id'] as int?,
    user: json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    item: json['item'] == null
        ? null
        : MsgReplyContent.fromJson(json['item'] as Map<String, dynamic>),
    counts: json['counts'] as int?,
    isMulti: json['is_multi'] as int?,
    replyTime: json['reply_time'] as int?,
  );
}
