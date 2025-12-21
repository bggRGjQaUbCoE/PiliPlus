enum LiveQuality {
  dolby(30000, '杜比'),
  origin4K(25000, '4K 原画'),
  super4K(20000, '4K'),
  super2K(15000, '2K'),
  origin(10000, '原画'),
  bluRay(400, '蓝光'),
  superHD(250, '超清'),
  smooth(150, '高清'),
  flunt(80, '流畅');

  final int code;
  final String desc;
  const LiveQuality(this.code, this.desc);

  static LiveQuality? fromCode(int? code) {
    for (var e in LiveQuality.values) {
      if (e.code == code) {
        return e;
      }
    }
    return null;
  }
}
