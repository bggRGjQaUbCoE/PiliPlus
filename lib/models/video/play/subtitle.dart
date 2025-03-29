enum SubtitlePreference { off, on, withoutAi, auto }

extension SubtitlePreferenceDesc on SubtitlePreference {
  static final List<String> _descList = [
    '默认不显示字幕',
    '优先选择非自动生成(ai)字幕',
    '跳过自动生成(ai)字幕，选择第一个可用字幕',
    '静音时等同第二项，非静音时等同第三项'
  ];
  String get description => _descList[index];
}

extension SubtitlePreferenceCode on SubtitlePreference {
  static const List<String> _codeList = ['off', 'on', 'withoutAi', 'auto'];
  String get code => _codeList[index];

  static SubtitlePreference? fromCode(String code) {
    final index = _codeList.indexOf(code);
    if (index != -1) {
      return SubtitlePreference.values[index];
    }
    return null;
  }
}
