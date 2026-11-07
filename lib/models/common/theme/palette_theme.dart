import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:material_ui/material_ui.dart';

/// 固定配色方案对 M3 中性色角色的覆盖。
///
/// 只描述背景 / 文字 / 描边这一组角色，彩度角色（primary、secondary、tertiary）
/// 仍由种子色经 [SeedColorScheme.fromSeeds] 生成。
class PaletteOverlay {
  const PaletteOverlay({
    required this.base,
    required this.mantle,
    required this.crust,
    required this.surface0,
    required this.surface1,
    required this.surface2,
    required this.text,
    required this.subtext1,
    required this.overlay2,
  });

  final Color base;
  final Color mantle;
  final Color crust;
  final Color surface0;
  final Color surface1;
  final Color surface2;
  final Color text;
  final Color subtext1;
  final Color overlay2;
}

/// 取色区里的一项，可以随明暗取不同色值。
class AccentColor {
  const AccentColor(this.label, {required this.light, required this.dark});

  const AccentColor.same(this.label, Color color) : light = color, dark = color;

  final String label;
  final Color light;
  final Color dark;

  Color colorOf(Brightness brightness) =>
      brightness == Brightness.light ? light : dark;
}

/// 一个调色板方案：固定一个 [FlexSchemeVariant]，可选地叠加一套中性色，
/// 并自带取色列表。
class PaletteTheme {
  const PaletteTheme({
    required this.id,
    required this.label,
    required this.variant,
    required this.accents,
    required this.defaultAccent,
    this.light,
    this.dark,
  });

  final int id;
  final String label;
  final FlexSchemeVariant variant;
  final PaletteOverlay? light;
  final PaletteOverlay? dark;
  final List<AccentColor> accents;
  final int defaultAccent;

  PaletteOverlay? overlayOf(Brightness brightness) =>
      brightness == Brightness.light ? light : dark;
}

/// 用种子色 + 方案的中性色覆盖生成完整配色。
///
/// [theme] 没有覆盖层时，结果与 [ColorScheme.fromSeed] 之外的
/// `asColorSchemeSeed` 完全一致。
ColorScheme buildPaletteScheme(
  PaletteTheme theme,
  Brightness brightness,
  Color seed,
  FlexSchemeVariant variant,
) {
  final overlay = theme.overlayOf(brightness);
  if (overlay == null) {
    return SeedColorScheme.fromSeeds(
      primaryKey: seed,
      variant: variant,
      brightness: brightness,
      useExpressiveOnContainerColors: false,
    );
  }
  final isLight = brightness == Brightness.light;
  return SeedColorScheme.fromSeeds(
    primaryKey: seed,
    variant: variant,
    brightness: brightness,
    useExpressiveOnContainerColors: false,
    surface: overlay.base,
    onSurface: overlay.text,
    surfaceDim: overlay.crust,
    surfaceBright: isLight ? overlay.base : overlay.surface2,
    surfaceContainerLowest: isLight ? overlay.base : overlay.crust,
    surfaceContainerLow: overlay.mantle,
    surfaceContainer: isLight ? overlay.crust : overlay.base,
    surfaceContainerHigh: overlay.surface0,
    surfaceContainerHighest: overlay.surface1,
    onSurfaceVariant: overlay.subtext1,
    outline: overlay.overlay2,
    outlineVariant: overlay.surface2,
    inverseSurface: overlay.text,
    onInverseSurface: overlay.base,
  );
}
