import 'package:PiliPlus/l10n/l10n.dart';

enum LiveQuality {
  dolby(30000),
  origin4K(25000),
  super4K(20000),
  super2K(15000),
  origin(10000),
  bluRay(400),
  superHD(250),
  smooth(150),
  flunt(80),
  ;

  final int code;
  String get desc => switch (this) {
    dolby => L10n.current.videoQualityDolbyVisionShortDesc,
    origin4K => L10n.current.liveQualityOrigin4KDesc,
    super4K => '4K',
    super2K => '2K',
    origin => L10n.current.liveQualityOriginDesc,
    bluRay => L10n.current.liveQualityBluRayDesc,
    superHD => L10n.current.liveQualitySuperHDDesc,
    smooth => L10n.current.liveQualitySmoothDesc,
    flunt => L10n.current.liveQualityFluntDesc,
  };
  const LiveQuality(this.code);

  static LiveQuality? fromCode(int? code) {
    for (final e in LiveQuality.values) {
      if (e.code == code) {
        return e;
      }
    }
    return null;
  }
}
