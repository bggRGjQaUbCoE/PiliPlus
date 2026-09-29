import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/l10n/l10n.dart';
import 'package:material_ui/material_ui.dart' show BoxFit;

enum VideoFitType {
  fill(boxFit: BoxFit.fill),
  contain(boxFit: BoxFit.contain),
  cover(boxFit: BoxFit.cover),
  fitWidth(boxFit: BoxFit.fitWidth),
  fitHeight(boxFit: BoxFit.fitHeight),
  none(boxFit: BoxFit.none),
  scaleDown(boxFit: BoxFit.scaleDown),
  ratio_4x3(aspectRatio: 4 / 3),
  ratio_16x9(aspectRatio: Style.aspectRatio16x9),
  ;

  String get desc => switch (this) {
    fill => L10n.current.videoFitTypeFillDesc,
    contain => L10n.current.automatic,
    cover => L10n.current.videoFitTypeCoverDesc,
    fitWidth => L10n.current.videoFitTypeFitWidthDesc,
    fitHeight => L10n.current.videoFitTypeFitHeightDesc,
    none => L10n.current.videoFitTypeNoneDesc,
    scaleDown => L10n.current.videoFitTypeScaleDownDesc,
    ratio_4x3 => '4:3',
    ratio_16x9 => '16:9',
  };
  final BoxFit boxFit;
  final double? aspectRatio;
  const VideoFitType({this.boxFit = BoxFit.contain, this.aspectRatio});
}
