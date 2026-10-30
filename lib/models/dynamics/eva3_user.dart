class Eva3User {
  Eva3UserInfo? info;

  Eva3User({this.info});

  factory Eva3User.fromJson(Map<String, dynamic> json) => Eva3User(
    info: json['info'] == null
        ? null
        : Eva3UserInfo.fromJson(json['info'] as Map<String, dynamic>),
  );
}

class Eva3UserInfo {
  Eva3UserDetail? user;
  String? follower;
  String? like;
  String? desc;

  Eva3UserInfo({
    this.user,
    this.follower,
    this.like,
    this.desc,
  });

  factory Eva3UserInfo.fromJson(Map<String, dynamic> json) => Eva3UserInfo(
    user: json['user'] == null ? null : Eva3UserDetail.fromJson(json['user']),
    follower: json['follower'],
    like: json['like'],
    desc: json['desc'],
  );
}

class Eva3UserDetail {
  String? mid;
  String? name;
  String? face;

  Eva3UserDetail({
    this.mid,
    this.name,
    this.face,
  });

  factory Eva3UserDetail.fromJson(Map<String, dynamic> json) => Eva3UserDetail(
    mid: json['mid'],
    name: json['name'],
    face: json['face'],
  );
}
