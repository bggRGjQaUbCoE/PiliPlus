import 'package:PiliPlus/l10n/l10n.dart';

enum AudioQuality {
  u_100010(100010),
  u_100009(100009),
  u_100008(100008),
  hiRes(30251),
  dolby_30250(30250),
  dolby_30255(30255),
  k192(30280),
  k132(30232),
  k64(30216),
  ;

  final int code;
  String get desc => switch (this) {
    u_100010 => '100010',
    u_100009 => '100009',
    u_100008 => '100008',
    hiRes => L10n.current.audioQualityHiResDesc,
    dolby_30250 => L10n.current.audioQualityDolbyDesc,
    dolby_30255 => L10n.current.audioQualityDolbyDesc,
    k192 => '192K',
    k132 => '132K',
    k64 => '64K',
  };

  const AudioQuality(this.code);

  static final _codeMap = {for (final i in values) i.code: i};

  static AudioQuality fromCode(int code) => _codeMap[code]!;
}
