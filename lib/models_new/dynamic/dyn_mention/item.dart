import 'package:PiliPlus/pages/common/multi_select/base.dart';

class MentionItem with MultiSelectData {
  final String? face;
  final int? fans;
  final String? name;
  final String? uid;

  MentionItem({
    required this.face,
    this.fans,
    required this.name,
    required this.uid,
  });

  factory MentionItem.fromJson(Map<String, dynamic> json) => MentionItem(
    face: json['face'] as String?,
    fans: json['fans'] as int?,
    name: json['name'] as String?,
    uid: json['uid'] as String?,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is MentionItem) {
      return uid == other.uid;
    }
    return false;
  }

  @override
  int get hashCode => uid.hashCode;
}
