import 'package:PiliPlus/l10n/l10n.dart';
import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:get/get.dart';

extension TransitionLabel on Transition {
  String get label => switch (this) {
    Transition.fade => L10n.current.transitionFade,
    Transition.fadeIn => L10n.current.transitionFadeIn,
    Transition.rightToLeft => L10n.current.transitionRightToLeft,
    Transition.leftToRight => L10n.current.transitionLeftToRight,
    Transition.upToDown => L10n.current.transitionUpToDown,
    Transition.downToUp => L10n.current.transitionDownToUp,
    Transition.rightToLeftWithFade =>
      L10n.current.transitionRightToLeftWithFade,
    Transition.leftToRightWithFade =>
      L10n.current.transitionLeftToRightWithFade,
    Transition.zoom => L10n.current.transitionZoom,
    Transition.topLevel => L10n.current.transitionTopLevel,
    Transition.noTransition => L10n.current.transitionNoTransition,
    Transition.cupertino => L10n.current.transitionCupertino,
    Transition.cupertinoDialog => L10n.current.transitionCupertinoDialog,
    Transition.size => L10n.current.transitionSize,
    Transition.circularReveal => L10n.current.transitionCircularReveal,
    Transition.sharedAxis => L10n.current.transitionSharedAxis,
    Transition.native => L10n.current.transitionNative,
  };
}

extension FlexSchemeVariantLabel on FlexSchemeVariant {
  String get label => switch (this) {
    FlexSchemeVariant.tonalSpot => L10n.current.schemeTonalSpot,
    FlexSchemeVariant.fidelity => L10n.current.schemeFidelity,
    FlexSchemeVariant.monochrome => L10n.current.schemeMonochrome,
    FlexSchemeVariant.neutral => L10n.current.schemeNeutral,
    FlexSchemeVariant.vibrant => L10n.current.schemeVibrant,
    FlexSchemeVariant.expressive => L10n.current.schemeExpressive,
    FlexSchemeVariant.content => L10n.current.schemeContent,
    FlexSchemeVariant.rainbow => L10n.current.schemeRainbow,
    FlexSchemeVariant.fruitSalad => L10n.current.schemeFruitSalad,
    FlexSchemeVariant.material => L10n.current.schemeMaterial,
    FlexSchemeVariant.material3Legacy => L10n.current.schemeMaterial3Legacy,
    FlexSchemeVariant.soft => L10n.current.schemeSoft,
    FlexSchemeVariant.vivid => L10n.current.schemeVivid,
    FlexSchemeVariant.vividSurfaces => L10n.current.schemeVividSurfaces,
    FlexSchemeVariant.highContrast => L10n.current.schemeHighContrast,
    FlexSchemeVariant.ultraContrast => L10n.current.schemeUltraContrast,
    FlexSchemeVariant.jolly => L10n.current.schemeJolly,
    FlexSchemeVariant.vividBackground => L10n.current.schemeVividBackground,
    FlexSchemeVariant.oneHue => L10n.current.schemeOneHue,
    FlexSchemeVariant.candyPop => L10n.current.schemeCandyPop,
    FlexSchemeVariant.chroma => L10n.current.schemeChroma,
  };
}
