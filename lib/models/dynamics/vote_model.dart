import 'package:PiliPlus/utils/extension.dart';

class SimpleVoteInfo {
  int? choiceCnt;
  int? defaultShare;
  String? desc;
  int? endTime;
  int? status;
  int? uid;
  int? voteId;
  late int joinNum;

  SimpleVoteInfo({
    this.choiceCnt,
    this.defaultShare,
    this.desc,
    this.endTime,
    this.status,
    this.uid,
    this.voteId,
    this.joinNum = 0,
  });

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
  // 0 文字, 1 图片
  int? type;
  int? votePublisher;
  int? duration;
  int? onlyFansLevel;

  VoteInfo({
    super.choiceCnt,
    super.defaultShare,
    super.desc,
    super.endTime,
    super.status,
    super.uid,
    super.voteId,
    super.joinNum = 0,
    this.title,
    this.ctime,
    this.myVotes,
    List<Option>? options,
    this.optionsCnt,
    this.voterLevel,
    this.face,
    this.name,
    this.type,
    this.votePublisher,
    this.duration,
    this.onlyFansLevel,
  }) : options = options ?? <Option>[];

  VoteInfo.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    title = json['title'];
    uid = json['vote_publisher'];
    ctime = json['ctime'];
    myVotes = (json['my_votes'] as List?)?.fromCast(); // doVote
    options =
        (json['options'] as List?)?.map((v) => Option.fromJson(v)).toList() ??
        <Option>[];
    optionsCnt = json['options_cnt'];
    voterLevel = json['voter_level'];
    face = json['face'];
    name = json['name'];
    type = json['type'];
    votePublisher = json['vote_publisher'];
  }

  factory VoteInfo.fromSeparatedJson(Map<String, dynamic> json) {
    return VoteInfo.fromJson(json['vote_info'])
      ..myVotes = (json['my_votes'] as List?)?.fromCast(); // voteInfo
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'desc': desc,
    'type': type,
    'choice_cnt': choiceCnt,
    'duration': duration,
    'options': options.map((e) => e.toJson()).toList(),
    'only_fans_level': onlyFansLevel,
    'vote_publisher': votePublisher,
    if (voteId != null) 'vote_id': voteId,
  };
}

class Option {
  int? optIdx;
  String? optDesc;
  late int cnt;
  String? imgUrl;

  Option({
    this.optDesc,
    this.imgUrl,
  });

  Option.fromJson(Map<String, dynamic> json) {
    optIdx = json['opt_idx'];
    optDesc = json['opt_desc'];
    cnt = json['cnt'] ?? 0;
    imgUrl = json['img_url'];
  }

  Map<String, dynamic> toJson() => {
    'opt_desc': optDesc,
    'img_url': imgUrl,
  };
}
