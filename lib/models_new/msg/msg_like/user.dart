class User {
  int? mid;
  String? nickname;
  String? avatar;

  User({
    this.mid,
    this.nickname,
    this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    mid: json['mid'] as int?,
    nickname: json['nickname'] as String?,
    avatar: json['avatar'] as String?,
  );
}
