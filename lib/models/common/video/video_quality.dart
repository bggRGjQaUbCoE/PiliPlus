enum VideoQuality {
  speed240(6, '240P 极速'),
  fluent360(16, '360P 流畅'),
  clear480(32, '480P 清晰'),
  high720(64, '720P 高清'),
  high72060(74, '720P60 高帧率'),
  high1080(80, '1080P 高清'),
  high1080plus(112, '1080P+ 高码率'),
  high108060(116, '1080P60 高帧率'),
  super4K(120, '4K 超清'),
  hdr(125, 'HDR 真彩色'),
  dolbyVision(126, '杜比视界'),
  super8k(127, '8K 超高清');

  final int code;
  final String description;

  const VideoQuality(this.code, this.description);

  static final _codeMap = {for (var i in values) i.code: i};

  static VideoQuality fromCode(int code) => _codeMap[code]!;
}
