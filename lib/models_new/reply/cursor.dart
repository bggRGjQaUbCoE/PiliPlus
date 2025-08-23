import 'package:PiliPlus/models_new/reply/pagination_reply.dart';
import 'package:PiliPlus/utils/extension.dart';

class ReplyCursor {
  bool? isBegin;
  int? prev;
  int? next;
  bool? isEnd;
  PaginationReply? paginationReply;
  String? sessionId;
  int? mode;
  String? modeText;
  int? allCount;
  List<int>? supportMode;
  String? name;

  ReplyCursor({
    this.isBegin,
    this.prev,
    this.next,
    this.isEnd,
    this.paginationReply,
    this.sessionId,
    this.mode,
    this.modeText,
    this.allCount,
    this.supportMode,
    this.name,
  });

  factory ReplyCursor.fromJson(Map<String, dynamic> json) => ReplyCursor(
    isBegin: json['is_begin'] as bool?,
    prev: json['prev'] as int?,
    next: json['next'] as int?,
    isEnd: json['is_end'] as bool?,
    paginationReply: json['pagination_reply'] == null
        ? null
        : PaginationReply.fromJson(
            json['pagination_reply'] as Map<String, dynamic>,
          ),
    sessionId: json['session_id'] as String?,
    mode: json['mode'] as int?,
    modeText: json['mode_text'] as String?,
    allCount: json['all_count'] as int?,
    supportMode: (json['support_mode'] as List?)?.fromCast(),
    name: json['name'] as String?,
  );
}
