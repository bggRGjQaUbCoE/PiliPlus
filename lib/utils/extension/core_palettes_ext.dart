import 'package:collection/collection.dart';
import 'package:material_color_utilities/dynamiccolor/dynamic_color.dart';
import 'package:material_color_utilities/dynamiccolor/dynamic_scheme.dart';
import 'package:material_color_utilities/dynamiccolor/variant.dart';
import 'package:material_color_utilities/palettes/core_palettes.dart';
import 'package:material_color_utilities/palettes/tonal_palette.dart';
import 'package:material_ui/material_ui.dart';

extension CorePalettesExt on CorePalettes {
  static CorePalettes fromList(List<int> colors) {
    return CorePalettes(
      TonalPalette.fromList(_getPartition(colors, 0, TonalPalette.commonSize)),
      TonalPalette.fromList(_getPartition(colors, 1, TonalPalette.commonSize)),
      TonalPalette.fromList(_getPartition(colors, 2, TonalPalette.commonSize)),
      TonalPalette.fromList(_getPartition(colors, 3, TonalPalette.commonSize)),
      TonalPalette.fromList(_getPartition(colors, 4, TonalPalette.commonSize)),
    );
  }

  ColorScheme toColorScheme({
    Variant variant = .tonalSpot,
    Brightness brightness = .light,
  }) {
    final scheme = DynamicScheme(
      sourceColorHct: primary.keyColor,
      variant: variant,
      isDark: brightness == .dark,
      primaryPalette: primary,
      secondaryPalette: secondary,
      tertiaryPalette: tertiary,
      neutralPalette: neutral,
      neutralVariantPalette: neutralVariant,
      errorPalette: TonalPalette.of(25, 84),
    );

    return ColorScheme(
      brightness: brightness,
      // background: Color(scheme.background),
      // onBackground: Color(scheme.onBackground),
      // surface: Color(scheme.surface),
      surface: Color(MaterialLegacyDynamicColors.surface.getArgb(scheme)),
      surfaceDim: Color(scheme.surfaceDim),
      surfaceBright: Color(scheme.surfaceBright),
      surfaceContainerLowest: Color(scheme.surfaceContainerLowest),
      surfaceContainerLow: Color(scheme.surfaceContainerLow),
      surfaceContainer: Color(scheme.surfaceContainer),
      surfaceContainerHigh: Color(scheme.surfaceContainerHigh),
      surfaceContainerHighest: Color(scheme.surfaceContainerHighest),
      onSurface: Color(scheme.onSurface),
      // surfaceVariant: Color(scheme.surfaceVariant),
      onSurfaceVariant: Color(scheme.onSurfaceVariant),
      inverseSurface: Color(scheme.inverseSurface),
      onInverseSurface: Color(scheme.inverseOnSurface),
      outline: Color(scheme.outline),
      outlineVariant: Color(scheme.outlineVariant),
      shadow: Color(scheme.shadow),
      scrim: Color(scheme.scrim),
      surfaceTint: Color(scheme.surfaceTint),
      primary: Color(scheme.primary),
      onPrimary: Color(scheme.onPrimary),
      primaryContainer: Color(scheme.primaryContainer),
      onPrimaryContainer: Color(scheme.onPrimaryContainer),
      inversePrimary: Color(scheme.inversePrimary),
      secondary: Color(scheme.secondary),
      onSecondary: Color(scheme.onSecondary),
      secondaryContainer: Color(scheme.secondaryContainer),
      onSecondaryContainer: Color(scheme.onSecondaryContainer),
      tertiary: Color(scheme.tertiary),
      onTertiary: Color(scheme.onTertiary),
      tertiaryContainer: Color(scheme.tertiaryContainer),
      onTertiaryContainer: Color(scheme.onTertiaryContainer),
      error: Color(scheme.error),
      onError: Color(scheme.onError),
      errorContainer: Color(scheme.errorContainer),
      onErrorContainer: Color(scheme.onErrorContainer),
      primaryFixed: Color(scheme.primaryFixed),
      primaryFixedDim: Color(scheme.primaryFixedDim),
      onPrimaryFixed: Color(scheme.onPrimaryFixed),
      onPrimaryFixedVariant: Color(scheme.onPrimaryFixedVariant),
      secondaryFixed: Color(scheme.secondaryFixed),
      secondaryFixedDim: Color(scheme.secondaryFixedDim),
      onSecondaryFixed: Color(scheme.onSecondaryFixed),
      onSecondaryFixedVariant: Color(scheme.onSecondaryFixedVariant),
      tertiaryFixed: Color(scheme.tertiaryFixed),
      tertiaryFixedDim: Color(scheme.tertiaryFixedDim),
      onTertiaryFixed: Color(scheme.onTertiaryFixed),
      onTertiaryFixedVariant: Color(scheme.onTertiaryFixedVariant),
    );
  }
}

// ignore: deprecated_member_use
/// [CorePalette._getPartition]
// Returns a partition from a list.
//
// For example, given a list with 2 partitions of size 3.
// range = [1, 2, 3, 4, 5, 6];
//
// range.getPartition(0, 3) // [1, 2, 3]
// range.getPartition(1, 3) // [4, 5, 6]
List<int> _getPartition(
  List<int> list,
  int partitionNumber,
  int partitionSize,
) {
  return list.slice(
    partitionNumber * partitionSize,
    (partitionNumber + 1) * partitionSize,
  );
}

class MaterialLegacyDynamicColors {
  static final surface = DynamicColor.fromPalette(
    name: 'surface',
    palette: (s) => s.neutralPalette,
    // tone: (s) => s.isDark ? 6 : 98,
    tone: (s) => s.isDark ? 10 : 99,
    isBackground: true,
  );
}

extension SystemDynamicColorScheme on ColorScheme {
  ColorScheme withSystemRoles(Map<String, int> roles) => copyWith(
    primary: Color(roles['primary']!),
    onPrimary: Color(roles['on_primary']!),
    primaryContainer: Color(roles['primary_container']!),
    onPrimaryContainer: Color(roles['on_primary_container']!),
    secondary: Color(roles['secondary']!),
    onSecondary: Color(roles['on_secondary']!),
    secondaryContainer: Color(roles['secondary_container']!),
    onSecondaryContainer: Color(roles['on_secondary_container']!),
    tertiary: Color(roles['tertiary']!),
    onTertiary: Color(roles['on_tertiary']!),
    tertiaryContainer: Color(roles['tertiary_container']!),
    onTertiaryContainer: Color(roles['on_tertiary_container']!),
    surface: Color(roles['surface']!),
    surfaceDim: Color(roles['surface_dim']!),
    surfaceBright: Color(roles['surface_bright']!),
    surfaceContainerLowest: Color(roles['surface_container_lowest']!),
    surfaceContainerLow: Color(roles['surface_container_low']!),
    surfaceContainer: Color(roles['surface_container']!),
    surfaceContainerHigh: Color(roles['surface_container_high']!),
    surfaceContainerHighest: Color(roles['surface_container_highest']!),
    onSurface: Color(roles['on_surface']!),
    onSurfaceVariant: Color(roles['on_surface_variant']!),
    outline: Color(roles['outline']!),
    outlineVariant: Color(roles['outline_variant']!),
    surfaceTint: Color(roles['primary']!),
  );
}
