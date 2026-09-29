import 'package:PiliPlus/l10n/l10n.dart';

enum VideoQuality {
  hdrVivid(129),
  super8k(127),
  dolbyVision(126),
  hdr(125),
  super4K(120),
  high108060(116),
  high1080plus(112),
  high1080(80),
  high72060(74),
  high720(64),
  clear480(32),
  fluent360(16),
  speed240(6),
  ;

  final int code;
  String get desc => switch (this) {
    hdrVivid => 'HDR Vivid',
    super8k => L10n.current.videoQualitySuper8kDesc,
    dolbyVision => L10n.current.videoQualityDolbyVisionDesc,
    hdr => L10n.current.videoQualityHdrDesc,
    super4K => L10n.current.videoQualitySuper4KDesc,
    high108060 => L10n.current.videoQualityHigh108060Desc,
    high1080plus => L10n.current.videoQualityHigh1080plusDesc,
    high1080 => L10n.current.videoQualityHigh1080Desc,
    high72060 => L10n.current.videoQualityHigh72060Desc,
    high720 => L10n.current.videoQualityHigh720Desc,
    clear480 => L10n.current.videoQualityClear480Desc,
    fluent360 => L10n.current.videoQualityFluent360Desc,
    speed240 => L10n.current.videoQualitySpeed240Desc,
  };
  String get shortDesc => switch (this) {
    hdrVivid => 'HDR Vivid',
    super8k => '8K',
    dolbyVision => L10n.current.videoQualityDolbyVisionShortDesc,
    hdr => 'HDR',
    super4K => '4K',
    high108060 => '1080P60',
    high1080plus => '1080P+',
    high1080 => '1080P',
    high72060 => '720P60',
    high720 => '720P',
    clear480 => '480P',
    fluent360 => '360P',
    speed240 => '240P',
  };

  const VideoQuality(this.code);

  static final _codeMap = {for (final i in values) i.code: i};

  static VideoQuality fromCode(int code) => _codeMap[code]!;
}
