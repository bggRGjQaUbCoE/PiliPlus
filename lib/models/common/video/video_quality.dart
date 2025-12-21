enum VideoQuality {
  hdrVivid(129, 'HDR Vivid', 'HDR Vivid'),
  super8k(127, '8K 超高清', '8K'),
  dolbyVision(126, '杜比视界', '杜比'),
  hdr(125, 'HDR 真彩', 'HDR'),
  super4K(120, '4K 超高清', '4K'),
  high108060(116, '1080P 60帧', '1080P60'),
  high1080plus(112, '1080P 高码率', '1080P+'),
  high1080(80, '1080P 高清', '1080P'),
  high72060(74, '720P 60帧', '720P60'),
  high720(64, '720P 准高清', '720P'),
  clear480(32, '480P 标清', '480P'),
  fluent360(16, '360P 流畅', '360P'),
  speed240(6, '240P 极速', '240P');

  final int code;
  final String desc;
  final String shortDesc;

  const VideoQuality(this.code, this.desc, this.shortDesc);

  static final _codeMap = {for (var i in values) i.code: i};

  static VideoQuality fromCode(int code) => _codeMap[code]!;
}
