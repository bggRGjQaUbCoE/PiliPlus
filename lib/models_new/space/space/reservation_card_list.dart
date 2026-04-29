import 'package:PiliPlus/utils/parse_string.dart';

class ReservationCardItem {
  int? sid;
  String? name;
  int total;
  bool isFollow;
  int? livePlanStartTime;
  String? descText1;
  String? dynamicId;
  LotteryPrizeInfo? lotteryPrizeInfo;

  ReservationCardItem({
    this.sid,
    this.name,
    required this.total,
    required this.isFollow,
    this.livePlanStartTime,
    this.descText1,
    this.dynamicId,
    this.lotteryPrizeInfo,
  });

  factory ReservationCardItem.fromJson(Map<String, dynamic> json) =>
      ReservationCardItem(
        sid: json['sid'] as int?,
        name: json['name'] as String?,
        total: json['total'] ?? 0,
        isFollow: json['is_follow'] == 1,
        livePlanStartTime: json['live_plan_start_time'] as int?,
        descText1: nonNullOrEmptyString(json['desc_text_1']?['text']),
        dynamicId: json['dynamic_id'] as String?,
        lotteryPrizeInfo: json['lottery_prize_info'] == null
            ? null
            : LotteryPrizeInfo.fromJson(
                json['lottery_prize_info'] as Map<String, dynamic>,
              ),
      );
}

class LotteryPrizeInfo {
  String? text;
  String? jumpUrl;

  LotteryPrizeInfo({this.text, this.jumpUrl});

  factory LotteryPrizeInfo.fromJson(Map<String, dynamic> json) {
    return LotteryPrizeInfo(
      text: json['text'] as String?,
      jumpUrl: json['jump_url'] as String?,
    );
  }
}
