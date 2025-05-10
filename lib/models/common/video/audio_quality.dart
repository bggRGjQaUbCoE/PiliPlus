enum AudioQuality {
  k64(30216, '64K'),
  k132(30232, '132K'),
  k192(30280, '192K'),
  dolby(30250, '杜比全景声'),
  hiRes(30251, 'Hi-Res无损');

  final int code;
  final String description;

  const AudioQuality(this.code, this.description);

  static final _codeMap = {for (var i in values) i.code: i};

  static AudioQuality fromCode(int code) => _codeMap[code]!;
}
