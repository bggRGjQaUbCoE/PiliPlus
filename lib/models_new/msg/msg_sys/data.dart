import 'dart:convert' show jsonDecode;

class MsgSysItem {
  int? id;
  int? cursor;
  String? title;
  String? content;
  String? timeAt;

  MsgSysItem({
    this.id,
    this.cursor,
    this.title,
    this.content,
    this.timeAt,
  });

  MsgSysItem.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    cursor = json['cursor'] as int?;
    title = json['title'] as String?;
    content = json['content'] as String?;
    if (content != null) {
      try {
        dynamic json = jsonDecode(content!);
        if (json?['web'] != null) {
          content = json['web'];
        }
      } catch (_) {}
    }
    timeAt = json['time_at'] as String?;
  }
}
