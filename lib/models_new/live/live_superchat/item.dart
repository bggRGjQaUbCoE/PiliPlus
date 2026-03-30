import 'package:PiliPlus/models_new/live/live_medal_wall/uinfo_medal.dart';
import 'package:PiliPlus/models_new/live/live_superchat/user_info.dart';
import 'package:PiliPlus/utils/global_data.dart';
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
  int endTime;
  String message;
  String token;
  int ts;
  UserInfo userInfo;
  late bool expired = false;
  late bool deleted = false;
  UinfoMedal? medalInfo;

  SuperChatItem({
    required this.id,
    required this.uid,
    required this.price,
    this.backgroundImage,
    required this.backgroundColor,
    required this.backgroundBottomColor,
    required this.backgroundPriceColor,
    required this.messageFontColor,
    required this.endTime,
    required this.message,
    required this.token,
    required this.ts,
    required this.userInfo,
    this.medalInfo,
  });

  static SuperChatItem get random => SuperChatItem.fromJson({
    "id": Utils.random.nextInt(2147483647),
    "uid": 0,
    "price": 66,
    "end_time": DateTime.now().millisecondsSinceEpoch ~/ 1000 + 5,
    "message": Utils.generateRandomString(55),
    "user_info": {
      "face": "",
      "uname": "UNAME",
    },
    'token': '',
    'ts': 0,
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
  });

  factory SuperChatItem.fromJson(Map<String, dynamic> json) => SuperChatItem(
    id: Utils.safeToInt(json['id']) ?? Utils.random.nextInt(2147483647),
    uid: Utils.safeToInt(json['uid'])!,
    price: json['price'],
    backgroundImage: noneNullOrEmptyString(json['background_image']),
    backgroundColor: json['background_color'] ?? '#EDF5FF',
    backgroundBottomColor: json['background_bottom_color'] ?? '#2A60B2',
    backgroundPriceColor: json['background_price_color'] ?? '#7497CD',
    messageFontColor: json['message_font_color'] ?? '#FFFFFF',
    endTime: Utils.safeToInt(json['end_time'])!,
    message: json['message'],
    token: json['token'],
    ts: Utils.safeToInt(json['ts'])!,
    userInfo: UserInfo.fromJson(json['user_info'] as Map<String, dynamic>),
    medalInfo: !GlobalData().showMedal || json['uinfo']?['medal'] == null
        ? null
        : UinfoMedal.fromJson(json['uinfo']['medal']),
  );

  SuperChatItem copyWith({
    int? id,
    int? uid,
    int? price,
    String? backgroundColor,
    String? backgroundBottomColor,
    String? backgroundPriceColor,
    String? messageFontColor,
    int? endTime,
    String? message,
    String? token,
    int? ts,
    UserInfo? userInfo,
    bool? expired,
    UinfoMedal? medalInfo,
  }) {
    return SuperChatItem(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      price: price ?? this.price,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundBottomColor:
          backgroundBottomColor ?? this.backgroundBottomColor,
      backgroundPriceColor: backgroundPriceColor ?? this.backgroundPriceColor,
      messageFontColor: messageFontColor ?? this.messageFontColor,
      endTime: endTime ?? this.endTime,
      message: message ?? this.message,
      token: token ?? this.token,
      ts: ts ?? this.ts,
      userInfo: userInfo ?? this.userInfo,
      medalInfo: medalInfo ?? this.medalInfo,
    );
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
    'end_time': endTime,
    'message': message,
    'token': token,
    'ts': ts,
    'user_info': userInfo.toJson(),
    'medal': ?medalInfo?.toJson(),
  };
}
