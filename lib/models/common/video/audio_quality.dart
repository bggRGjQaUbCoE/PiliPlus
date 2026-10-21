final class AudioQuality {
  final int code;
  final String desc;

  /// 音质优先级，数值越大音质越高。未知音质为 0。
  final int rank;

  const AudioQuality(this.code, this.desc, {this.rank = 0});

  @override
  String toString() => 'code: $code, desc: $desc';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is AudioQuality) {
      return code == other.code;
    }
    return false;
  }

  @override
  int get hashCode => code.hashCode;

  static const AudioQuality hiRes = .new(30251, 'Hi-Res无损', rank: 60);
  static const AudioQuality dolby_30255 = .new(30255, '杜比全景声', rank: 50);
  static const AudioQuality dolby_30250 = .new(30250, '杜比全景声', rank: 50);
  static const AudioQuality k192 = .new(30280, '192K', rank: 40);
  static const AudioQuality k132 = .new(30232, '132K', rank: 30);
  static const AudioQuality k64 = .new(30216, '64K', rank: 20);

  static const List<AudioQuality> values = [
    hiRes,
    dolby_30255,
    dolby_30250,
    k192,
    k132,
    k64,
  ];

  static final _codeMap = {for (final i in values) i.code: i};

  factory AudioQuality.fromId(int code) => AudioQuality(code, code.toString());

  factory AudioQuality.fromCode(int code) => _codeMap[code] ?? .fromId(code);
}
