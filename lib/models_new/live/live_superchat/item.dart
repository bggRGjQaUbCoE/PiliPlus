import 'package:PiliPlus/models_new/live/live_superchat/user_info.dart';
import 'package:PiliPlus/utils/utils.dart';

class SuperChatItem {
  int id;
  int uid;
  int price;
  String backgroundColor;
  String backgroundBottomColor;
  String backgroundPriceColor;
  String messageFontColor;
  int endTime;
  String message;
  String token;
  int ts;
  UserInfo userInfo;
  bool expired = false;

  SuperChatItem({
    required this.id,
    required this.uid,
    required this.price,
    required this.backgroundColor,
    required this.backgroundBottomColor,
    required this.backgroundPriceColor,
    required this.messageFontColor,
    required this.endTime,
    required this.message,
    required this.token,
    required this.ts,
    required this.userInfo,
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
  });

  factory SuperChatItem.fromJson(Map<String, dynamic> json) => SuperChatItem(
    id: Utils.safeToInt(json['id']) ?? Utils.random.nextInt(2147483647),
    uid: Utils.safeToInt(json['uid'])!,
    price: json['price'],
    backgroundColor: json['background_color'] ?? '#EDF5FF',
    backgroundBottomColor: json['background_bottom_color'] ?? '#2A60B2',
    backgroundPriceColor: json['background_price_color'] ?? '#7497CD',
    messageFontColor: json['message_font_color'] ?? '#FFFFFF',
    endTime: Utils.safeToInt(json['end_time'])!,
    message: json['message'],
    token: json['token'],
    ts: Utils.safeToInt(json['ts'])!,
    userInfo: UserInfo.fromJson(json['user_info'] as Map<String, dynamic>),
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
    );
  }
}
