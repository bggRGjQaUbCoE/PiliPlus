import 'dart:ui' as ui;

import 'package:PiliPlus/utils/soft_dynamic_colors.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/theme_utils.dart';
import 'package:material_ui/material_ui.dart';

abstract final class AdvancedMaterials {
  // Gaussian standard deviation in Flutter's logical coordinate space, not an
  // Android blur radius. The filter object is shared; no bitmap capture is used.
  static final _blurs = List.generate(
    17,
    (step) => ui.ImageFilter.blur(sigmaX: step * 7 / 16, sigmaY: step * 7 / 16),
    growable: false,
  );

  static ui.ImageFilter blurAt(double progress) =>
      _blurs[(progress * 16).round()];

  static Color tint(ColorScheme scheme) {
    final accent = Pref.softDynamicColors
        ? scheme.primary
        : SoftDynamicColors.softenPrimary(scheme);
    return Color.lerp(
      scheme.surface,
      accent,
      .06,
    )!;
  }

  static double toolbarOpacity(Brightness brightness) =>
      brightness == Brightness.dark ? .73 : .81;

  static SurfaceMaterialTheme theme(ColorScheme scheme) {
    final enabled = Pref.advancedMaterials;
    final color = tint(scheme);
    return SurfaceMaterialTheme(
      enabled: enabled,
      builder: (context, kind, material) {
        // Transparent sheets deliberately delegate their surface to their body.
        if (material.color == Colors.transparent ||
            material.type == MaterialType.transparency) {
          return material;
        }
        var progress = 1.0;
        if (kind == SurfaceMaterialKind.appBar && enabled) {
          final settings = context
              .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
          if (settings != null && settings.maxExtent > settings.minExtent) {
            // DynamicSliverAppBar measures its expanded height on first layout.
            progress = settings.maxExtent.isInfinite
                ? 0
                : ((settings.maxExtent - settings.currentExtent) /
                          (settings.maxExtent - settings.minExtent))
                      .clamp(0.0, 1.0);
          }
        }
        // Small floating controls expose more background. Text-heavy panels
        // retain their contrast backing, with the same tint and blur treatment.
        final floating =
            kind == SurfaceMaterialKind.navigationBar ||
            kind == SurfaceMaterialKind.floatingActionButton;
        final appBar = kind == SurfaceMaterialKind.appBar;
        final opacity = appBar
            ? toolbarOpacity(scheme.brightness)
            : scheme.brightness == Brightness.dark
            ? (floating ? .71 : .83)
            : (floating ? .79 : .93);
        // Player menus explicitly use black surfaces with white labels even
        // when the surrounding page is light. Keep that existing dark palette.
        if (kind == SurfaceMaterialKind.menu &&
            scheme.brightness == Brightness.light &&
            material.color != null &&
            (material.color!.toARGB32() & 0xffffff) == 0) {
          final dark = ThemeUtils.darkTheme;
          return Theme(
            data: dark,
            child: dark.extension<SurfaceMaterialTheme>()!.builder(
              context,
              kind,
              material,
            ),
          );
        }
        final shape = material.shape!;
        final foreground = Material(
          key: enabled ? null : material.key,
          type: material.type,
          color: enabled
              ? color.withValues(alpha: opacity * progress)
              : (material.color ?? scheme.surface).withValues(alpha: 1),
          elevation: enabled ? 0 : material.elevation,
          shadowColor: material.shadowColor,
          surfaceTintColor: enabled
              ? Colors.transparent
              : material.surfaceTintColor,
          shape: shape,
          clipBehavior: enabled ? Clip.antiAlias : material.clipBehavior,
          textStyle: material.textStyle,
          borderOnForeground: material.borderOnForeground,
          animationDuration: material.animationDuration,
          animateColor: material.animateColor,
          child: material.child,
        );
        if (!enabled || progress == 0) return foreground;
        return PhysicalShape(
          key: material.key,
          clipper: ShapeBorderClipper(shape: shape),
          color: Colors.transparent,
          elevation: material.elevation,
          shadowColor: material.shadowColor ?? scheme.shadow,
          child: ClipPath(
            clipper: ShapeBorderClipper(shape: shape),
            child: BackdropFilter(
              filter: blurAt(progress),
              child: foreground,
            ),
          ),
        );
      },
    );
  }
}
