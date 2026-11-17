import 'package:material_ui/material_ui.dart';

/// HSL saturation reduction with Weeko's relative-luminance correction.
abstract final class SoftDynamicColors {
  static Color softenPrimary(ColorScheme scheme) => _soften(
    scheme.primary,
    scheme.brightness == Brightness.dark ? .72 : .75,
    [scheme.onPrimary],
  );

  static ColorScheme apply(ColorScheme scheme) {
    final dark = scheme.brightness == Brightness.dark;
    final primary = dark ? 0.72 : 0.75;
    final secondary = dark ? 0.62 : 0.65;
    final tertiary = dark ? 0.57 : 0.60;
    final primaryColor = softenPrimary(scheme);
    return scheme.copyWith(
      primary: primaryColor,
      primaryContainer: _soften(scheme.primaryContainer, primary, [
        scheme.onPrimaryContainer,
      ]),
      secondary: _soften(scheme.secondary, secondary, [scheme.onSecondary]),
      secondaryContainer: _soften(scheme.secondaryContainer, secondary, [
        scheme.onSecondaryContainer,
      ]),
      tertiary: _soften(scheme.tertiary, tertiary, [scheme.onTertiary]),
      tertiaryContainer: _soften(scheme.tertiaryContainer, tertiary, [
        scheme.onTertiaryContainer,
      ]),
      // Weeko also replaces uses of the original theme accents. Flutter has
      // additional accent roles, so soften those here rather than business UI.
      surfaceTint: scheme.surfaceTint == scheme.primary
          ? primaryColor
          : _soften(scheme.surfaceTint, primary),
      inversePrimary: _soften(scheme.inversePrimary, primary, [
        scheme.inverseSurface,
      ]),
      primaryFixed: _soften(scheme.primaryFixed, primary, [
        scheme.onPrimaryFixed,
        scheme.onPrimaryFixedVariant,
      ]),
      primaryFixedDim: _soften(scheme.primaryFixedDim, primary, [
        scheme.onPrimaryFixed,
        scheme.onPrimaryFixedVariant,
      ]),
      secondaryFixed: _soften(scheme.secondaryFixed, secondary, [
        scheme.onSecondaryFixed,
        scheme.onSecondaryFixedVariant,
      ]),
      secondaryFixedDim: _soften(scheme.secondaryFixedDim, secondary, [
        scheme.onSecondaryFixed,
        scheme.onSecondaryFixedVariant,
      ]),
      tertiaryFixed: _soften(scheme.tertiaryFixed, tertiary, [
        scheme.onTertiaryFixed,
        scheme.onTertiaryFixedVariant,
      ]),
      tertiaryFixedDim: _soften(scheme.tertiaryFixedDim, tertiary, [
        scheme.onTertiaryFixed,
        scheme.onTertiaryFixedVariant,
      ]),
    );
  }

  static double _contrast(double first, double second) => first > second
      ? (first + .05) / (second + .05)
      : (second + .05) / (first + .05);

  static Color _soften(
    Color color,
    double scale, [
    List<Color> foregrounds = const [],
  ]) {
    final hsl = HSLColor.fromColor(color);
    if (hsl.saturation == 0) return color;
    final softened = hsl.withSaturation(hsl.saturation * scale);
    final target = color.computeLuminance();
    // Quantization can push a previously valid pair just below 4.5. Keep the
    // closest HSL candidate on the valid side; do not alter foreground colors.
    final constraints = [
      for (final foreground in foregrounds)
        if (_contrast(target, foreground.computeLuminance()) >= 4.5)
          foreground.computeLuminance(),
    ];
    var low = 0.0;
    var high = 1.0;
    var closest = color;
    var closestDelta = double.infinity;
    for (var step = 0; step < 24; step++) {
      final lightness = (low + high) / 2;
      final candidate = softened.withLightness(lightness).toColor();
      final luminance = candidate.computeLuminance();
      final delta = (luminance - target).abs();
      if (delta < closestDelta &&
          constraints.every(
            (foreground) => _contrast(luminance, foreground) >= 4.5,
          )) {
        closest = candidate;
        closestDelta = delta;
      }
      if (luminance < target) {
        low = lightness;
      } else {
        high = lightness;
      }
    }
    return closest.withValues(alpha: color.a);
  }
}
