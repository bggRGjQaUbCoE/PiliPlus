import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter/material.dart';

const _pinkLight = Color(0xFFFF6699);
const _pinkDark = Color(0xFFD44E7D);

extension ColorSchemeExt on ColorScheme {
  Color get vipColor => brightness.isLight ? _pinkLight : _pinkDark;

  Color get btnColor =>
      brightness.isLight ? _pinkLight : const Color(0xFF8F0030);

  Color get freeColor =>
      brightness.isLight ? const Color(0xFFFF7F24) : const Color(0xFFD66011);

  bool get isLight => brightness.isLight;

  bool get isDark => brightness.isDark;
}

extension ColorExtension on Color {
  Color darken([double amount = .5]) {
    assert(amount >= 0 && amount <= 1, 'Amount must be between 0 and 1');
    return Color.lerp(this, Colors.black, amount)!;
  }

  ColorScheme asColorSchemeSeed([
    FlexSchemeVariant variant = .material,
    Brightness brightness = .light,
  ]) => SeedColorScheme.fromSeeds(
    primaryKey: this,
    variant: variant,
    brightness: brightness,
    useExpressiveOnContainerColors: false,
  );
}

extension BrightnessExt on Brightness {
  Brightness get reverse => isLight ? Brightness.dark : Brightness.light;

  bool get isLight => this == Brightness.light;

  bool get isDark => this == Brightness.dark;
}
