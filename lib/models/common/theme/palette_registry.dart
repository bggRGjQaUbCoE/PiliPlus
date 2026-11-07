import 'package:PiliPlus/models/common/theme/catppuccin.dart';
import 'package:PiliPlus/models/common/theme/nord.dart';
import 'package:PiliPlus/models/common/theme/palette_theme.dart';
import 'package:PiliPlus/models/common/theme/theme_color_type.dart';
import 'package:PiliPlus/models/common/theme/tokyo_night.dart';
import 'package:flex_seed_scheme/flex_seed_scheme.dart';

/// 调色板方案注册表。
///
/// id 会写进设置里，只能新增、不能改动或复用；新增方案时在 [all] 里补一项，
/// 并在 [overlays] 里暴露给下拉菜单即可。配色数据放在各自的
/// `xxx.dart` 里，只提供中性色覆盖和 accent 列表。
abstract final class PaletteRegistry {
  /// 种子色方案，沿用原有的 19 色取色列表。
  static const int seedId = 0;

  static const int macchiatoId = 1;

  static const int mochaId = 2;

  static const int frappeId = 3;

  static const int tokyoNightId = 4;

  static const int nordId = 5;

  /// 种子色方案：没有中性色覆盖，取色列表就是原有的 [colorThemeTypes]。
  static final PaletteTheme seed = PaletteTheme(
    id: seedId,
    label: '种子色',
    variant: FlexSchemeVariant.material3Legacy,
    accents: [
      for (final e in colorThemeTypes) AccentColor.same(e.label, e.color),
    ],
    defaultAccent: 0,
  );

  /// Catppuccin：浅色 Latte，深色 Macchiato。
  static final PaletteTheme macchiato = PaletteTheme(
    id: macchiatoId,
    label: 'Catppuccin Macchiato',
    variant: FlexSchemeVariant.material3Legacy,
    light: Catppuccin.latte,
    dark: Catppuccin.macchiato,
    accents: Catppuccin.macchiatoAccents,
    defaultAccent: 3,
  );

  /// Catppuccin：浅色 Latte，深色 Mocha。
  static final PaletteTheme mocha = PaletteTheme(
    id: mochaId,
    label: 'Catppuccin Mocha',
    variant: FlexSchemeVariant.material3Legacy,
    light: Catppuccin.latte,
    dark: Catppuccin.mocha,
    accents: Catppuccin.mochaAccents,
    defaultAccent: 3,
  );

  /// Catppuccin：浅色 Latte，深色 Frappé。
  static final PaletteTheme frappe = PaletteTheme(
    id: frappeId,
    label: 'Catppuccin Frappé',
    variant: FlexSchemeVariant.material3Legacy,
    light: Catppuccin.latte,
    dark: Catppuccin.frappe,
    accents: Catppuccin.frappeAccents,
    defaultAccent: 3,
  );

  /// Tokyo Night：浅色 Day，深色 Night。
  static const PaletteTheme tokyoNight = PaletteTheme(
    id: tokyoNightId,
    label: 'Tokyo Night',
    variant: FlexSchemeVariant.material3Legacy,
    light: TokyoNight.day,
    dark: TokyoNight.night,
    accents: TokyoNight.accents,
    defaultAccent: 0,
  );

  /// Nord：浅色 Snow Storm，深色 Polar Night。
  static const PaletteTheme nord = PaletteTheme(
    id: nordId,
    label: 'Nord',
    variant: FlexSchemeVariant.material3Legacy,
    light: Nord.light,
    dark: Nord.dark,
    accents: Nord.accents,
    defaultAccent: 0,
  );

  static final List<PaletteTheme> all = [
    seed,
    macchiato,
    mocha,
    frappe,
    tokyoNight,
    nord,
  ];

  /// 下拉菜单里的固定配色方案。
  static final List<PaletteTheme> overlays = [
    macchiato,
    mocha,
    frappe,
    tokyoNight,
    nord,
  ];

  static PaletteTheme byId(int id) =>
      all.firstWhere((e) => e.id == id, orElse: () => seed);
}
