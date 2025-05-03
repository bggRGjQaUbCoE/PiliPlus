class SimpleVoteInfo {
  int? choiceCnt;
  int? defaultShare;
  String? desc;
  int? endTime;
  int? status;
  int? uid;
  int? voteId;
  late int joinNum;

  SimpleVoteInfo.fromJson(Map<String, dynamic> json) {
    choiceCnt = json['choice_cnt'];
    defaultShare = json['default_share'];
    desc = json['desc'];
    endTime = json['end_time'];
    status = json['status'];
    uid = json['uid'];
    voteId = json['vote_id'];
    joinNum = json['join_num'] ?? 0;
  }
}

class VoteInfo extends SimpleVoteInfo {
  String? title;
  int? ctime;
  List<int>? myVotes;
  late List<Option> options;
  int? optionsCnt;
  int? voterLevel;
  String? face;
  String? name;

  VoteInfo.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    title = json['title'];
    uid = json['vote_publisher'];
    ctime = json['ctime'];
    myVotes = (json['my_votes'] as List?)?.cast(); // doVote
    options =
        (json['options'] as List?)?.map((v) => Option.fromJson(v)).toList() ??
            [];
    optionsCnt = json['options_cnt'];
    voterLevel = json['voter_level'];
    face = json['face'];
    name = json['name'];
  }

  factory VoteInfo.fromSeparatedJson(Map<String, dynamic> json) {
    return VoteInfo.fromJson(json['vote_info'])
      ..myVotes = (json['my_votes'] as List?)?.cast(); // voteInfo
  }
}

class Option {
  int? optidx;
  String? optdesc;
  late int cnt;

  Option.fromJson(Map<String, dynamic> json) {
    optidx = json['opt_idx'];
    optdesc = json['opt_desc'];
    cnt = json['cnt'] ?? 0;
  }
}
