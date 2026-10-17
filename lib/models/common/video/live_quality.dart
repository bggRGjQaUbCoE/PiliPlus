final class LiveQuality {
  final int code;
  final String desc;

  const LiveQuality(this.code, this.desc);

  @override
  String toString() => 'code: $code, desc: $desc';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is LiveQuality) {
      return code == other.code;
    }
    return false;
  }

  @override
  int get hashCode => code.hashCode;

  static const LiveQuality dolby = .new(30000, '杜比');
  static const LiveQuality origin4K = .new(25000, '4K 原画');
  static const LiveQuality super4K = .new(20000, '4K');
  static const LiveQuality super2K = .new(15000, '2K');
  static const LiveQuality origin = .new(10000, '原画');
  static const LiveQuality bluRay = .new(400, '蓝光');
  static const LiveQuality superHD = .new(250, '超清');
  static const LiveQuality smooth = .new(150, '高清');
  static const LiveQuality flunt = .new(80, '流畅');

  static const List<LiveQuality> values = [
    dolby,
    origin4K,
    super4K,
    super2K,
    origin,
    bluRay,
    superHD,
    smooth,
    flunt,
  ];

  static final _codeMap = {for (final i in values) i.code: i};

  factory LiveQuality.fromId(int code) => LiveQuality(code, code.toString());

  factory LiveQuality.fromCode(int code) => _codeMap[code] ?? .fromId(code);

  factory LiveQuality.fromJson(Map<String, dynamic> json) =>
      LiveQuality(json['qn'] ?? -1, json['desc'] ?? json['qn'].toString());

  factory LiveQuality.fromFormat(int code, List<LiveQuality>? liveQn) {
    if (liveQn != null && liveQn.isNotEmpty) {
      for (final qn in liveQn) {
        if (qn.code == code) {
          return qn;
        }
      }
    }

    return .fromCode(code);
  }
}
