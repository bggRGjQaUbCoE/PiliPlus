import 'package:PiliPlus/l10n/l10n.dart';

class SpaceSettingModel {
  SpaceSettingModel({
    required this.getName,
    required this.key,
    required this.value,
    this.isReverse = false,
  });

  final String Function() getName;
  String get name => getName();
  String key;
  int? value;
  bool isReverse;

  bool get boolVal => isReverse ? value == 0 : value == 1;
}

class Privacy {
  List<SpaceSettingModel> list1;
  List<SpaceSettingModel> list2;
  List<SpaceSettingModel> list3;

  Privacy({
    required this.list1,
    required this.list2,
    required this.list3,
  });

  factory Privacy.fromJson(Map<String, dynamic> json) => Privacy(
    list1: [
      SpaceSettingModel(
        getName: () => L10n.current.privacyFromJsonName,
        key: 'fav_video',
        value: json['fav_video'],
      ),
      SpaceSettingModel(
        getName: () => L10n.current.privacyFromJsonName4,
        key: 'bangumi',
        value: json['bangumi'],
      ),
      SpaceSettingModel(
        getName: () => L10n.current.privacyFromJsonName2,
        key: 'comic',
        value: json['comic'],
      ),
      SpaceSettingModel(
        getName: () => L10n.current.privacyFromJsonName7,
        key: 'coins_video',
        value: json['coins_video'],
      ),
      SpaceSettingModel(
        getName: () => L10n.current.privacyFromJsonName8,
        key: 'likes_video',
        value: json['likes_video'],
      ),
      SpaceSettingModel(
        getName: () => L10n.current.privacyFromJsonName9,
        key: 'played_game',
        value: json['played_game'],
      ),
      SpaceSettingModel(
        getName: () => L10n.current.privacyFromJsonName10,
        key: 'dress_up',
        value: json['dress_up'],
      ),
      SpaceSettingModel(
        getName: () => L10n.current.privacyFromJsonName5,
        key: 'disable_following',
        value: json['disable_following'],
        isReverse: true,
      ),
      SpaceSettingModel(
        getName: () => L10n.current.privacyFromJsonName6,
        key: 'disable_show_fans',
        value: json['disable_show_fans'],
        isReverse: true,
      ),
    ],
    list2: [
      SpaceSettingModel(
        getName: () => L10n.current.privacyFromJsonName11,
        key: 'close_space_medal',
        value: json['close_space_medal'],
        isReverse: true,
      ),
      SpaceSettingModel(
        getName: () => L10n.current.privacyFromJsonName12,
        key: 'only_show_wearing',
        value: json['only_show_wearing'],
        isReverse: true,
      ),
      SpaceSettingModel(
        getName: () => L10n.current.privacyFromJsonName3,
        key: 'disable_show_school',
        value: json['disable_show_school'],
        isReverse: true,
      ),
    ],
    list3: [
      SpaceSettingModel(
        getName: () => L10n.current.privacyFromJsonName13,
        key: 'live_playback',
        value: json['live_playback'],
      ),
      SpaceSettingModel(
        getName: () => L10n.current.privacyFromJsonName15,
        key: 'charge_video',
        value: json['charge_video'],
      ),
      SpaceSettingModel(
        getName: () => L10n.current.privacyFromJsonName14,
        key: 'lesson_video',
        value: json['lesson_video'],
      ),
    ],
  );
}
