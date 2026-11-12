class ConfigPlusData {
  late bool closeSpaceMedal;
  late bool onlyShowWearing;

  static const kCloseSpaceMedalKey = 'close_space_medal';
  static const kOnlyShowWearingKey = 'only_show_wearing';

  ConfigPlusData.fromJson(Map<String, dynamic> json) {
    final config = json['configs'];
    closeSpaceMedal = config[kCloseSpaceMedalKey]['status'] == 1;
    onlyShowWearing = config[kOnlyShowWearingKey]['status'] == 1;
  }
}
