import 'package:hive/hive.dart';

part 'stat.g.dart';

@HiveType(typeId: 1)
class UserStat {
  const UserStat({this.following, this.follower, this.dynamicCount});

  @HiveField(0)
  final int? following;
  @HiveField(1)
  final int? follower;
  @HiveField(2)
  final int? dynamicCount;

  factory UserStat.fromJson(Map<String, dynamic> json) => UserStat(
    following: json['following'],
    follower: json['follower'],
    dynamicCount: json['dynamic_count'],
  );
}
