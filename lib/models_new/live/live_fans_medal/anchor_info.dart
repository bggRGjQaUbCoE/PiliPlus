class AnchorInfo {
  String nickName;

  AnchorInfo({required this.nickName});

  factory AnchorInfo.fromJson(Map<String, dynamic> json) =>
      AnchorInfo(nickName: json['nick_name']);
}
