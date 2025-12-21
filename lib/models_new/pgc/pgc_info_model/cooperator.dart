class Cooperator {
  int? mid;
  String? avatar;
  String? nickName;
  String? role;

  Cooperator({this.mid, this.avatar, this.nickName, this.role});

  factory Cooperator.fromJson(Map<String, dynamic> json) => Cooperator(
    mid: json['mid'] as int?,
    avatar: json['avatar'] as String?,
    nickName: json['nick_name'] as String?,
    role: json['role'] as String?,
  );
}
