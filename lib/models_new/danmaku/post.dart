class DanmakuPost {
  DanmakuPost({
    required this.action,
    required this.animation,
    required this.colorfulSrc,
    required this.dmContent,
    required this.dmid,
    required this.dmidStr,
    required this.visible,
  });

  final String? action;
  final String? animation;
  final dynamic colorfulSrc;
  final String? dmContent;
  final int? dmid;
  final String? dmidStr;
  final bool? visible;

  factory DanmakuPost.fromJson(Map<String, dynamic> json) {
    return DanmakuPost(
      action: json["action"],
      animation: json["animation"],
      colorfulSrc: json["colorful_src"],
      dmContent: json["dm_content"],
      dmid: json["dmid"],
      dmidStr: json["dmid_str"],
      visible: json["visible"],
    );
  }
}
