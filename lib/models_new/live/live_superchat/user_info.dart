class UserInfo {
  String face;
  String? faceFrame;
  String uname;
  String nameColor;

  UserInfo({
    required this.face,
    required this.faceFrame,
    required this.uname,
    required this.nameColor,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    face: json['face'],
    faceFrame: json['face_frame'],
    uname: json['uname'],
    nameColor: json['name_color'] ?? '#666666',
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'face': face,
    'face_frame': faceFrame,
    'uname': uname,
    'name_color': nameColor,
  };
}
