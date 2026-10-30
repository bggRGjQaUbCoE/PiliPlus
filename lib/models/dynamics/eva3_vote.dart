class Eva3Vote {
  Eva3VoteInfo? info;

  Eva3Vote({this.info});

  factory Eva3Vote.fromJson(Map<String, dynamic> json) => Eva3Vote(
    info: json['info'] == null
        ? null
        : Eva3VoteInfo.fromJson(json['info'] as Map<String, dynamic>),
  );
}

class Eva3VoteInfo {
  String? voteId;
  String? joinNum;
  String? title;

  Eva3VoteInfo({
    this.voteId,
    this.joinNum,
    this.title,
  });

  factory Eva3VoteInfo.fromJson(Map<String, dynamic> json) => Eva3VoteInfo(
    voteId: json['vote_id'] as String?,
    joinNum: json['join_num'] as String?,
    title: json['title'] as String?,
  );
}
