import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:PiliPlus/main.dart' show MyApp;
import 'package:PiliPlus/models/common/theme/theme_color_type.dart';
import 'package:PiliPlus/pages/setting/widgets/switch_item.dart';
import 'package:PiliPlus/utils/extension/core_palettes_ext.dart';
import 'package:PiliPlus/utils/extension/theme_ext.dart';
import 'package:PiliPlus/utils/soft_dynamic_colors.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/theme_utils.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:hive_ce/hive.dart';
import 'package:material_ui/material_ui.dart';

double contrast(Color a, Color b) {
  final first = a.computeLuminance();
  final second = b.computeLuminance();
  return (math.max(first, second) + .05) / (math.min(first, second) + .05);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory directory;

  setUpAll(() async {
    directory = await Directory.systemTemp.createTemp('piliplus-soft-colors-');
    Hive.init(directory.path);
    GStorage.setting = await Hive.openBox('setting');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('com.example.piliplus/theme'),
          (_) async => null,
        );
  });
  setUp(() => GStorage.setting.clear());
  tearDownAll(() async {
    await Hive.close();
    await directory.delete(recursive: true);
  });

  test(
    'matches outputs executed from Weeko Java, including alpha and gray',
    () {
      final reference = jsonDecode(
        File('test/utils/fixtures/soft_dynamic_colors_weeko.json')
            .readAsStringSync(),
      ) as List;
      for (final row in reference) {
        final input = Color(row['input'] as int);
        final scheme = ColorScheme.fromSeed(seedColor: input).copyWith(
          brightness: row['dark'] == true ? Brightness.dark : Brightness.light,
          primary: input,
          primaryContainer: input,
          secondary: input,
          secondaryContainer: input,
          tertiary: input,
          tertiaryContainer: input,
        );
        final output = SoftDynamicColors.apply(scheme);
        final colors = [output.primary, output.secondary, output.tertiary];
        expect(output.primaryContainer, output.primary);
        expect(output.secondaryContainer, output.secondary);
        expect(output.tertiaryContainer, output.tertiary);
        for (var i = 0; i < colors.length; i++) {
          final expected = Color(row['expected'][i] as int);
          expect(colors[i].toARGB32(), expected.toARGB32());
          expect(colors[i].a, input.a);
          expect(
            (colors[i].computeLuminance() - input.computeLuminance()).abs(),
            lessThan(.003),
          );
        }
        // Only accent backgrounds and their Material aliases may change.
        expect(
          output.copyWith(
            primary: input,
            primaryContainer: input,
            secondary: input,
            secondaryContainer: input,
            tertiary: input,
            tertiaryContainer: input,
            surfaceTint: scheme.surfaceTint,
            inversePrimary: scheme.inversePrimary,
            primaryFixed: scheme.primaryFixed,
            primaryFixedDim: scheme.primaryFixedDim,
            secondaryFixed: scheme.secondaryFixed,
            secondaryFixedDim: scheme.secondaryFixedDim,
            tertiaryFixed: scheme.tertiaryFixed,
            tertiaryFixedDim: scheme.tertiaryFixedDim,
          ),
          scheme,
        );
        expect(output.vipColor, scheme.vipColor);
      }
    },
  );

  test('luminance correction improves over saturation-only conversion', () {
    const input = Color(0xff00ff00);
    final scheme = ColorScheme.fromSeed(seedColor: input)
        .copyWith(primary: input);
    final corrected = SoftDynamicColors.apply(scheme).primary;
    final naive = HSLColor.fromColor(input).withSaturation(.75).toColor();
    final target = input.computeLuminance();
    expect(
      (corrected.computeLuminance() - target).abs(),
      lessThan((naive.computeLuminance() - target).abs() / 10),
    );
    expect(HSLColor.fromColor(corrected).hue, closeTo(120, 1));
    expect(HSLColor.fromColor(corrected).saturation, closeTo(.75, .02));
    final translucent = input.withValues(alpha: .413);
    expect(
      SoftDynamicColors.apply(scheme.copyWith(primary: translucent)).primary.a,
      translucent.a,
    );
  });

  test('Material accent aliases stay coordinated without recoloring errors or foregrounds', () {
    for (final brightness in Brightness.values) {
      final base = ColorScheme.fromSeed(
        seedColor: const Color(0xff2962ff),
        brightness: brightness,
      );
      final source = base.copyWith(error: base.primary);
      final soft = SoftDynamicColors.apply(source);
      expect(soft.surfaceTint, soft.primary);
      expect(soft.error, source.error);
      expect(soft.onPrimary, source.onPrimary);
      expect(soft.onPrimaryFixed, source.onPrimaryFixed);
      expect(soft.onPrimaryFixedVariant, source.onPrimaryFixedVariant);
      expect(soft.surface, source.surface);
      for (final (before, after) in [
        (source.primaryFixed, soft.primaryFixed),
        (source.primaryFixedDim, soft.primaryFixedDim),
        (source.secondaryFixed, soft.secondaryFixed),
        (source.tertiaryFixedDim, soft.tertiaryFixedDim),
        (source.inversePrimary, soft.inversePrimary),
      ]) {
        expect(after, isNot(before));
        expect(
          (before.computeLuminance() - after.computeLuminance()).abs(),
          lessThan(.004),
        );
        expect(after.a, before.a);
      }
    }
  });

  test(
    'light and dark palette variants retain text and button contrast',
    () async {
      var minimum = double.infinity;
      var defaultMinimum = double.infinity;
      var baselineLowContrast = 0;
      var newLowContrast = 0;
      final thresholdCrossings = <String>[];
      var maximumLuminanceDelta = 0.0;
      var count = 0;
      await GStorage.setting.put(SettingBoxKey.softDynamicColors, true);
      for (final seed in colorThemeTypes) {
        for (final variant in FlexSchemeVariant.values) {
          for (final brightness in Brightness.values) {
            final scheme = seed.color.asColorSchemeSeed(variant, brightness);
            final theme = ThemeUtils.getThemeData(
              colorScheme: scheme,
              isDynamic: false,
              isDark: brightness == Brightness.dark,
            );
            final soft = theme.colorScheme;
            final pairs = [
              (scheme.primary, soft.primary, soft.onPrimary),
              (scheme.secondary, soft.secondary, soft.onSecondary),
              (scheme.tertiary, soft.tertiary, soft.onTertiary),
              (
                scheme.primaryContainer,
                soft.primaryContainer,
                soft.onPrimaryContainer,
              ),
              (
                scheme.secondaryContainer,
                soft.secondaryContainer,
                soft.onSecondaryContainer,
              ),
              (
                scheme.tertiaryContainer,
                soft.tertiaryContainer,
                soft.onTertiaryContainer,
              ),
              (scheme.primaryFixed, soft.primaryFixed, soft.onPrimaryFixed),
              (
                scheme.primaryFixed,
                soft.primaryFixed,
                soft.onPrimaryFixedVariant,
              ),
              (
                scheme.primaryFixedDim,
                soft.primaryFixedDim,
                soft.onPrimaryFixed,
              ),
              (
                scheme.primaryFixedDim,
                soft.primaryFixedDim,
                soft.onPrimaryFixedVariant,
              ),
              (
                scheme.secondaryFixed,
                soft.secondaryFixed,
                soft.onSecondaryFixed,
              ),
              (
                scheme.secondaryFixed,
                soft.secondaryFixed,
                soft.onSecondaryFixedVariant,
              ),
              (
                scheme.secondaryFixedDim,
                soft.secondaryFixedDim,
                soft.onSecondaryFixed,
              ),
              (
                scheme.secondaryFixedDim,
                soft.secondaryFixedDim,
                soft.onSecondaryFixedVariant,
              ),
              (scheme.tertiaryFixed, soft.tertiaryFixed, soft.onTertiaryFixed),
              (
                scheme.tertiaryFixed,
                soft.tertiaryFixed,
                soft.onTertiaryFixedVariant,
              ),
              (
                scheme.tertiaryFixedDim,
                soft.tertiaryFixedDim,
                soft.onTertiaryFixed,
              ),
              (
                scheme.tertiaryFixedDim,
                soft.tertiaryFixedDim,
                soft.onTertiaryFixedVariant,
              ),
              (scheme.inversePrimary, soft.inversePrimary, soft.inverseSurface),
            ];
            for (final (before, after, foreground) in pairs) {
              final ratio = contrast(after, foreground);
              final baseline = contrast(before, foreground);
              minimum = math.min(minimum, ratio);
              maximumLuminanceDelta = math.max(
                maximumLuminanceDelta,
                (before.computeLuminance() - after.computeLuminance()).abs(),
              );
              expect(
                ratio,
                greaterThanOrEqualTo(baseline * .98),
                reason: '${seed.label}/${variant.name}/${brightness.name}',
              );
              if (baseline < 4.5) baselineLowContrast++;
              if (baseline >= 4.5 && ratio < 4.5) {
                newLowContrast++;
                thresholdCrossings.add(
                  '${seed.label}/${variant.name}/${brightness.name}: $baseline -> $ratio',
                );
              }
              if (baseline >= 4.5) expect(ratio, greaterThanOrEqualTo(4.5));
              if (variant == FlexSchemeVariant.material3Legacy) {
                defaultMinimum = math.min(defaultMinimum, ratio);
                expect(ratio, greaterThanOrEqualTo(4.5));
              }
            }
            expect(
              contrast(soft.onSurface, soft.surface),
              greaterThanOrEqualTo(4.5),
            );
            expect(
              contrast(soft.primary, soft.surface),
              greaterThanOrEqualTo(
                contrast(scheme.primary, scheme.surface) * .98,
              ),
            );
            expect(soft.error, scheme.error);
            expect(soft.onSurface, scheme.onSurface);
            count++;
          }
        }
      }
      debugPrint(
        'Palette matrix: $count schemes; minimum role contrast $minimum; '
        'default variant minimum $defaultMinimum; baseline roles below 4.5: '
        '$baselineLowContrast; new roles below 4.5: $newLowContrast; '
        'maximum luminance delta $maximumLuminanceDelta',
      );
      debugPrint('8-bit threshold crossings: $thresholdCrossings');
      expect(newLowContrast, 0);
      expect(maximumLuminanceDelta, lessThan(.004));
    },
  );

  test(
    'dynamic and custom sources can switch without double softening',
    () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            DynamicColorPlugin.channel,
            (call) async =>
                call.method == DynamicColorPlugin.accentColorMethodName
                ? 0xff2962ff
                : null,
          );
      expect(await MyApp.initPlatformState(), isTrue);
      await GStorage.setting.put(SettingBoxKey.dynamicColor, true);
      final (originalLight, originalDark) = MyApp.getAllTheme();
      await GStorage.setting.put(SettingBoxKey.softDynamicColors, true);
      final (light, dark) = MyApp.getAllTheme();
      expect(
        light.colorScheme,
        SoftDynamicColors.apply(originalLight.colorScheme),
      );
      expect(
        dark.colorScheme,
        SoftDynamicColors.apply(originalDark.colorScheme),
      );
      expect(MyApp.getAllTheme().$1.colorScheme, light.colorScheme);
      await GStorage.setting.put(SettingBoxKey.dynamicColor, false);
      await GStorage.setting.put(SettingBoxKey.customColor, 0xffff7299);
      final custom = MyApp.getAllTheme().$1.colorScheme;
      expect(custom.primary, isNot(light.colorScheme.primary));
      await GStorage.setting.put(SettingBoxKey.dynamicColor, true);
      expect(MyApp.getAllTheme().$1.colorScheme, light.colorScheme);
      await GStorage.setting.put(SettingBoxKey.softDynamicColors, false);
      expect(MyApp.getAllTheme().$2.colorScheme, originalDark.colorScheme);
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(DynamicColorPlugin.channel, null);
    },
  );

  test('re-enabling dynamic colors reads a changed system accent', () async {
    var accent = 0xff2962ff;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          DynamicColorPlugin.channel,
          (call) async =>
              call.method == DynamicColorPlugin.accentColorMethodName
              ? accent
              : null,
        );
    await GStorage.setting.put(SettingBoxKey.dynamicColor, true);
    expect(await MyApp.initPlatformState(), isTrue);
    final before = MyApp.getAllTheme().$1.colorScheme;
    accent = 0xff008577;
    expect(await MyApp.initPlatformState(), isTrue);
    expect(MyApp.getAllTheme().$1.colorScheme.primary, isNot(before.primary));
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(DynamicColorPlugin.channel, null);
  });

  test(
    'soft dynamic themes use official system roles and keep the off state',
    () async {
      final fixture =
          (jsonDecode(
            File('test/utils/fixtures/system_dynamic_roles_android17.json')
                .readAsStringSync(),
          ) as Map).map(
            (mode, roles) =>
                MapEntry(mode as String, Map<String, int>.from(roles as Map)),
          );
      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            ..setMockMethodCallHandler(
              DynamicColorPlugin.channel,
              (call) async =>
                  call.method == DynamicColorPlugin.accentColorMethodName
                  ? 0xffa6d1b2
                  : null,
            )
            ..setMockMethodCallHandler(
              const MethodChannel('com.example.piliplus/theme'),
              (call) async {
                expect(call.method, 'getSystemColorRoles');
                return fixture;
              },
            );
      expect(await MyApp.initPlatformState(), isTrue);
      await GStorage.setting.put(SettingBoxKey.dynamicColor, true);
      final original = MyApp.getAllTheme();
      await GStorage.setting.put(SettingBoxKey.softDynamicColors, true);
      final updated = MyApp.getAllTheme();
      for (final (before, after, mode) in [
        (original.$1.colorScheme, updated.$1.colorScheme, 'light'),
        (original.$2.colorScheme, updated.$2.colorScheme, 'dark'),
      ]) {
        final roles = fixture[mode]!;
        expect(after, SoftDynamicColors.apply(before.withSystemRoles(roles)));
        expect(after.surface, Color(roles['surface']!));
        expect(after.surface, isNot(before.surface));
        expect(after.error, before.error);
        expect(after.onError, before.onError);
        expect(after.errorContainer, before.errorContainer);
        expect(after.onErrorContainer, before.onErrorContainer);
        for (final (foreground, background) in [
          (after.onPrimary, after.primary),
          (after.onPrimaryContainer, after.primaryContainer),
          (after.onSecondary, after.secondary),
          (after.onSecondaryContainer, after.secondaryContainer),
          (after.onTertiary, after.tertiary),
          (after.onTertiaryContainer, after.tertiaryContainer),
          (after.onSurface, after.surface),
        ]) {
          expect(
            contrast(foreground, background),
            greaterThanOrEqualTo(4.5),
            reason: mode,
          );
        }
      }
      await GStorage.setting.put(SettingBoxKey.dynamicColor, false);
      final custom = MyApp.getAllTheme();
      expect(
        custom.$1.colorScheme.surface,
        isNot(updated.$1.colorScheme.surface),
      );
      await GStorage.setting.put(SettingBoxKey.dynamicColor, true);
      await GStorage.setting.put(SettingBoxKey.softDynamicColors, false);
      expect(MyApp.getAllTheme().$1.colorScheme, original.$1.colorScheme);
      expect(MyApp.getAllTheme().$2.colorScheme, original.$2.colorScheme);
      messenger
        ..setMockMethodCallHandler(DynamicColorPlugin.channel, null)
        ..setMockMethodCallHandler(
          const MethodChannel('com.example.piliplus/theme'),
          (_) async => null,
        );
    },
  );

  testWidgets(
    'switch persists and enabled/disabled button colors retain contrast',
    (tester) async {
      expect(Pref.softDynamicColors, isFalse);
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SetSwitchItem(
              title: '柔和动态色',
              setKey: SettingBoxKey.softDynamicColors,
            ),
          ),
        ),
      );
      await tester.runAsync(() async {
        await tester.tap(find.byType(Switch));
        await GStorage.setting.flush();
      });
      await tester.pumpAndSettle();
      expect(Pref.softDynamicColors, isTrue);
      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SetSwitchItem(
              title: '柔和动态色',
              setKey: SettingBoxKey.softDynamicColors,
            ),
          ),
        ),
      );
      expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);
      for (final brightness in Brightness.values) {
        final original = ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: brightness,
        );
        Color? baselineDisabledBackground;
        Color? baselineDisabledForeground;
        for (final scheme in [original, SoftDynamicColors.apply(original)]) {
          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData(colorScheme: scheme),
              home: Scaffold(
                body: FilledButton(onPressed: () {}, child: const Text('按钮')),
              ),
            ),
          );
          await tester.pumpAndSettle();
          final button = tester.widget<FilledButton>(find.byType(FilledButton));
          final style = button.defaultStyleOf(
            tester.element(find.byType(FilledButton)),
          );
          expect(
            contrast(
              style.foregroundColor!.resolve({})!,
              style.backgroundColor!.resolve({})!,
            ),
            greaterThanOrEqualTo(4.5),
          );
          final disabledBackground = Color.alphaBlend(
            style.backgroundColor!.resolve({WidgetState.disabled})!,
            scheme.surface,
          );
          final disabledForeground = Color.alphaBlend(
            style.foregroundColor!.resolve({WidgetState.disabled})!,
            disabledBackground,
          );
          final disabledRatio = contrast(
            disabledForeground,
            disabledBackground,
          );
          expect(
            disabledRatio,
            lessThan(contrast(scheme.onPrimary, scheme.primary)),
          );
          expect(scheme.onSurface, original.onSurface);
          baselineDisabledBackground ??= disabledBackground;
          baselineDisabledForeground ??= disabledForeground;
          expect(disabledBackground, baselineDisabledBackground);
          expect(disabledForeground, baselineDisabledForeground);
          debugPrint(
            '${brightness.name} disabled button contrast: $disabledRatio',
          );
        }
      }
    },
  );
}
