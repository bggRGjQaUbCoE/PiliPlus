import 'package:PiliPlus/models/model_owner.dart';

class FolloweeVote extends Owner {
  String _name;
  @override
  String get name => _name;
  String _face;
  @override
  String get face => _face;
  List<int> votes;
  int ctime;

  FolloweeVote({
    required super.mid,
    required String name,
    required String face,
    required this.votes,
    required this.ctime,
  }) : _name = name,
       _face = face;

  factory FolloweeVote.fromJson(Map<String, dynamic> json) => FolloweeVote(
    mid: json['uid'],
    name: json['name'],
    face: json['face'],
    votes: List<int>.from(json['votes']),
    ctime: json['ctime'],
  );
}
