class UserInfo {
  String face;
  String uname;
  String nameColor;

  UserInfo({
    required this.face,
    required this.uname,
    required this.nameColor,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    face: json['face'],
    uname: json['uname'],
    nameColor: json['name_color'] ?? '#666666',
  );
}
