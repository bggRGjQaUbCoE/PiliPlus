import 'package:PiliPlus/models_new/live/live_medal_wall/uinfo_medal.dart';
import 'package:PiliPlus/models_new/live/live_superchat/user_info.dart';
import 'package:PiliPlus/utils/bili_utils.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/parse_int.dart';
import 'package:PiliPlus/utils/parse_string.dart';
import 'package:PiliPlus/utils/utils.dart';

class SuperChatItem {
  int id;
  int uid;
  int price;
  String? backgroundImage;
  String backgroundColor;
  String backgroundBottomColor;
  String backgroundPriceColor;
  String messageFontColor;
  int startSime;
  int endTime;
  String message;
  String token;
  int ts;
  UserInfo userInfo;
  late bool expired = false;
  late bool deleted = false;
  UinfoMedal? medalInfo;
  int roomid;

  SuperChatItem({
    required this.id,
    required this.uid,
    required this.price,
    this.backgroundImage,
    required this.backgroundColor,
    required this.backgroundBottomColor,
    required this.backgroundPriceColor,
    required this.messageFontColor,
    required this.startSime,
    required this.endTime,
    required this.message,
    required this.token,
    required this.ts,
    required this.userInfo,
    this.medalInfo,
    required this.roomid,
  });

  static SuperChatItem get random {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return SuperChatItem.fromJson(
      {
        "id": Utils.random.nextInt(2147483647),
        "uid": 0,
        "price": 66,
        "start_time": now,
        "end_time": now + 5,
        "message": Utils.generateRandomString(55),
        "user_info": {
          "face": "",
          'face_frame': BiliUtils.liveGuardPendant(Utils.random.nextInt(4)),
          "uname": "UNAME",
        },
        'token': '',
        'ts': now,
        'uinfo': {
          'medal': {
            "name": "Medal",
            "level": Utils.random.nextInt(40),
            "id": 123,
            "ruid": 456,
            "v2_medal_color_start": "#4C7DFF99",
            "v2_medal_color_text": "#FFFFFF",
          },
        },
      },
      Utils.random.nextInt(2147483647),
    );
  }

  factory SuperChatItem.fromJson(Map<String, dynamic> json, int roomid) =>
      SuperChatItem(
        // Missing server IDs cannot be deduplicated or deleted reliably.
        // The timeline rejects zero; random IDs are only for explicit demos.
        id: safeToInt(json['id']) ?? 0,
        uid: safeToInt(json['uid']) ?? 0,
        price: safeToInt(json['price']) ?? 0,
        backgroundImage: nonNullOrEmptyString(json['background_image']),
        backgroundColor: json['background_color'] ?? '#EDF5FF',
        backgroundBottomColor: json['background_bottom_color'] ?? '#2A60B2',
        backgroundPriceColor: json['background_price_color'] ?? '#7497CD',
        messageFontColor: json['message_font_color'] ?? '#FFFFFF',
        startSime: safeToInt(json['start_time']) ?? 0,
        endTime: safeToInt(json['end_time']) ?? 0,
        message: json['message']?.toString() ?? '',
        token: json['token']?.toString() ?? '',
        ts: safeToInt(json['ts']) ?? safeToInt(json['start_time']) ?? 0,
        userInfo: UserInfo.fromJson(json['user_info'] as Map<String, dynamic>),
        medalInfo: GlobalData().showMedal
            ? UinfoMedal.lightMedal(json['uinfo']?['medal'])
            : null,
        roomid: roomid,
      );

  SuperChatItem copyWith({
    int? id,
    int? uid,
    int? price,
    String? backgroundColor,
    String? backgroundBottomColor,
    String? backgroundPriceColor,
    String? messageFontColor,
    int? startSime,
    int? endTime,
    String? message,
    String? token,
    int? ts,
    UserInfo? userInfo,
    bool? expired,
    bool? deleted,
    UinfoMedal? medalInfo,
  }) {
    return SuperChatItem(
        id: id ?? this.id,
        uid: uid ?? this.uid,
        price: price ?? this.price,
        backgroundImage: backgroundImage,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        backgroundBottomColor:
            backgroundBottomColor ?? this.backgroundBottomColor,
        backgroundPriceColor: backgroundPriceColor ?? this.backgroundPriceColor,
        messageFontColor: messageFontColor ?? this.messageFontColor,
        startSime: startSime ?? this.startSime,
        endTime: endTime ?? this.endTime,
        message: message ?? this.message,
        token: token ?? this.token,
        ts: ts ?? this.ts,
        userInfo: userInfo ?? this.userInfo,
        medalInfo: medalInfo ?? this.medalInfo,
        roomid: roomid,
      )
      ..expired = expired ?? this.expired
      ..deleted = deleted ?? this.deleted;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'uid': uid,
    'price': price,
    'background_image': backgroundImage,
    'background_color': backgroundColor,
    'background_bottom_color': backgroundBottomColor,
    'background_price_color': backgroundPriceColor,
    'message_font_color': messageFontColor,
    'start_time': startSime,
    'end_time': endTime,
    'message': message,
    'token': token,
    'ts': ts,
    'user_info': userInfo.toJson(),
    'medal': ?medalInfo?.toJson(),
    'roomid': roomid,
  };
}
