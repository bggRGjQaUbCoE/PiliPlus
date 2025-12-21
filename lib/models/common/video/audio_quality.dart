enum AudioQuality {
  u_100010(100010, '100010'),
  u_100009(100009, '100009'),
  u_100008(100008, '100008'),
  hiRes(30251, 'Hi-Res无损'),
  dolby(30250, '杜比全景声'),
  k192(30280, '192K'),
  k132(30232, '132K'),
  k64(30216, '64K');

  final int code;
  final String desc;

  const AudioQuality(this.code, this.desc);

  static final _codeMap = {for (var i in values) i.code: i};

  static AudioQuality fromCode(int code) => _codeMap[code]!;
}
