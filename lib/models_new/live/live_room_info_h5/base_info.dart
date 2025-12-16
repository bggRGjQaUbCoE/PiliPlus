class BaseInfo {
  String? uname;
  String? face;

  BaseInfo({this.uname, this.face});

  factory BaseInfo.fromJson(Map<String, dynamic> json) => BaseInfo(
    uname: json['uname'] as String?,
    face: json['face'] as String?,
  );
}
