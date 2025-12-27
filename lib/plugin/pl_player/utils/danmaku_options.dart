import 'package:PiliPlus/utils/extension/box_ext.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:canvas_danmaku/canvas_danmaku.dart';

abstract final class DanmakuOptions {
  static final Set<int> blockTypes = Pref.danmakuBlockType;
  static bool blockColorful = blockTypes.contains(6);

  static double danmakuFontScaleFS = Pref.danmakuFontScaleFS;
  static double danmakuFontScale = Pref.danmakuFontScale;
  static int danmakuFontWeight = Pref.fontWeight;
  static double danmakuShowArea = Pref.danmakuShowArea;
  static double danmakuDuration = Pref.danmakuDuration;
  static double danmakuStaticDuration = Pref.danmakuStaticDuration;
  static double danmakuStrokeWidth = Pref.strokeWidth;
  static bool scrollFixedVelocity = Pref.danmakuFixedV;
  static bool massiveMode = Pref.danmakuMassiveMode;
  static double danmakuLineHeight = Pref.danmakuLineHeight;

  static DanmakuOption get({
    required bool notFullscreen,
    double speed = 1.0,
  }) {
    return DanmakuOption(
      fontSize: notFullscreen ? danmakuFontScaleFS : danmakuFontScale,
      fontWeight: danmakuFontWeight,
      area: danmakuShowArea,
      duration: danmakuDuration / speed,
      staticDuration: danmakuStaticDuration / speed,
      hideBottom: blockTypes.contains(5),
      hideScroll: blockTypes.contains(2),
      hideTop: blockTypes.contains(4),
      hideSpecial: blockTypes.contains(7),
      strokeWidth: danmakuStrokeWidth,
      scrollFixedVelocity: scrollFixedVelocity,
      massiveMode: massiveMode,
      static2Scroll: true,
      safeArea: true,
      lineHeight: danmakuLineHeight,
    );
  }

  static Future<void>? save() {
    return GStorage.setting.putAllNE({
      SettingBoxKey.danmakuBlockType: blockTypes.toList(),
      SettingBoxKey.danmakuShowArea: danmakuShowArea,
      SettingBoxKey.danmakuFontScale: danmakuFontScale,
      SettingBoxKey.danmakuFontScaleFS: danmakuFontScaleFS,
      SettingBoxKey.danmakuDuration: danmakuDuration,
      SettingBoxKey.danmakuStaticDuration: danmakuStaticDuration,
      SettingBoxKey.strokeWidth: danmakuStrokeWidth,
      SettingBoxKey.fontWeight: danmakuFontWeight,
      SettingBoxKey.danmakuLineHeight: danmakuLineHeight,
    });
  }
}
