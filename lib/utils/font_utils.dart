import 'dart:ffi';
import 'dart:io' show Directory, File;
import 'dart:ui' show loadFontFromList;

import 'package:PiliPlus/models/common/danmaku/danmaku_font_sync_mode.dart';
import 'package:PiliPlus/utils/android/bindings.g.dart';
import 'package:PiliPlus/utils/font_name_parser.dart';
import 'package:PiliPlus/utils/fontconfig.g.dart';
import 'package:PiliPlus/utils/path_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:crypto/crypto.dart';
import 'package:ffi/ffi.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart'
    show kDebugMode, defaultTargetPlatform, debugPrint;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:jni/jni.dart';
import 'package:path/path.dart' as path;
import 'package:win32/win32.dart';

abstract final class FontUtils {
  static final _fonts = <String>{};
  static bool _initialized = false;

  static const _kFontExts = ['ttf', 'ttc', 'otf'];
  static final _kFontDir = path.join(appSupportDirPath, 'font');

  /// 旧版单槽位实现的字体目录，迁移完成后删除
  static const _kLegacyFontDirs = ['fonts', 'danmaku_fonts'];

  static final _loadedFonts = <String>{};
  static final _loadingFonts = <String, Future<void>>{};

  /// 已导入字体池：key 为字体族名，value 为文件绝对路径
  static final customFonts = Pref.customAppFont;

  /// 字体族名 → 从字体文件解析出的显示名
  static final _customFontNames = Pref.customAppFontNames;

  static String _familyOf(String hash) => 'custom_font_$hash';

  /// 已导入字体的显示名，取不到时回落到族名本身
  static String displayName(String fontFamily) =>
      _customFontNames[fontFamily] ?? fontFamily;

  /// 该字体名是否指向已导入的字体（而非系统字体）
  static bool isCustomFont(String? fontFamily) =>
      fontFamily != null && customFonts.containsKey(fontFamily);

  static Future<void> _saveFonts() => GStorage.setting.putAll({
    SettingBoxKey.customAppFont: customFonts,
    SettingBoxKey.customAppFontNames: _customFontNames,
  });

  /// 启动初始化：迁移旧格式 → 剔除失效条目 → 清理孤儿文件 → 装载在用字体。
  ///
  /// 字体不是启动的必需品，这里整体兜底：任何异常或卡住都只导致字体不生效，
  /// 绝不能阻断 App 启动（init 在 main 的 Future.wait 里，抛错会导致白屏）。
  @pragma('vm:notify-debugger-on-exception')
  static Future<void> init() async {
    try {
      await _init().timeout(const Duration(seconds: 10));
    } catch (e) {
      debugPrint('font init failed: $e');
    }
  }

  static Future<void> _init() async {
    await _migrateLegacyFonts();
    await _pruneMissingFonts();
    await _cleanupOrphanFiles();
    // 装载最多只挡 2 秒：正常远快于此，异常也不至于卡住启动。
    // 超时不会取消装载，它会在后台继续，
    // 引擎完成注册后发出的 fontsChange 会触发文本重新排版。
    await _loadActiveFonts().timeout(
      const Duration(seconds: 2),
      onTimeout: () {},
    );
  }

  /// 只装载当前真正会用到的字体：应用字体 + 独立弹幕字体
  static Future<void> _loadActiveFonts() {
    final families = <String>{
      ?Pref.appFont,
      if (Pref.enableCustomDanmakuFont &&
          Pref.danmakuFontSyncMode == DanmakuFontSyncMode.custom)
        ?Pref.customDanmakuFontFamily,
    };
    return Future.wait([
      for (final family in families)
        if (isCustomFont(family)) ?loadFontIfNecessary(family),
    ]);
  }

  static Future<void>? loadFontIfNecessary(String fontFamily) {
    if (_loadedFonts.contains(fontFamily)) return null;
    // 同一字体的并发装载合流到同一个 Future，避免重复注册
    return _loadingFonts.putIfAbsent(
      fontFamily,
      () => _loadFont(
        fontFamily,
      ).whenComplete(() => _loadingFonts.remove(fontFamily)),
    );
  }

  /// 装载失败时不记入 _loadedFonts，后续仍可重试
  @pragma('vm:notify-debugger-on-exception')
  static Future<void> _loadFont(String fontFamily) async {
    try {
      final filePath = customFonts[fontFamily];
      if (filePath == null) return;
      final bytes = await File(filePath).readAsBytes();
      await loadFontFromList(bytes, fontFamily: fontFamily);
      _loadedFonts.add(fontFamily);
    } catch (_) {}
  }

  /// 导入字体文件（可多选），返回本批次第一个成功导入的字体族名。
  ///
  /// 只落盘与建立索引，不在这里装载字体：多选时逐个装载会让导入非常慢，
  /// 字体一律等到被选中时再按需装载。
  @pragma('vm:notify-debugger-on-exception')
  static Future<String?> pickFonts() async {
    try {
final result = await FilePicker.pickFiles(
        type: .custom,
        allowedExtensions: _kFontExts,
      );
      final files = result?.files;
      if (files == null || files.isEmpty) return null;

      String? firstFont;
      var failed = 0;
      // loading 只覆盖落盘与解析，不覆盖用户在系统文件选择器里的操作
      SmartDialog.showLoading();
      try {
        final dir = Directory(_kFontDir);
        if (!dir.existsSync()) {
          await dir.create(recursive: true);
        }

        // 逐个导入：并发落盘会让多个大字体同时占用内存和磁盘带宽
        var imported = false;
        for (final file in files) {
          final font = await _importFont(file);
          if (font == null) {
            failed++;
            continue;
          }
          imported = true;
          firstFont ??= font.family;
          customFonts[font.family] = font.path;
          _customFontNames[font.family] = font.name;
        }

        if (imported) {
          await _saveFonts();
        }
      } finally {
        // 必须指定 loading：默认的 smart 关的是最顶层弹窗，
        // 若之后弹了 toast，被关掉的就是 toast，loading 会一直转下去
        SmartDialog.dismiss(status: SmartStatus.loading);
      }

      if (failed != 0) {
        SmartDialog.showToast(
          firstFont == null ? '字体导入失败' : '$failed 个字体导入失败',
        );
      }
      return firstFont;
    } catch (_) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      if (kDebugMode) rethrow;
      SmartDialog.showToast('字体导入失败');
    }
    return null;
  }

  /// 落盘 → 内容哈希 → 解析显示名 → 生成族名。
  /// 先写临时文件再改名，中断不会在池目录留下半个字体。
  static Future<({String family, String path, String name})?> _importFont(
    PlatformFile file,
  ) async {
    final xFile = file.xFile;
    final tmpFile = File(
      path.join(
        _kFontDir,
        '.importing-${DateTime.now().microsecondsSinceEpoch}',
      ),
    );
    try {
      await xFile.saveTo(tmpFile.path);

      final hash = await _hashFile(tmpFile);
      if (hash == null) return null;

      final family = _familyOf(hash);
      final name = await _resolveName(tmpFile.path, xFile.name);

      // 同一文件已经导入过，直接复用
      final existing = customFonts[family];
      if (existing != null && File(existing).existsSync()) {
        await _deleteFile(tmpFile);
        return (family: family, path: existing, name: name);
      }

      final saveTo = path.join(_kFontDir, '$hash${_extensionOf(xFile.name)}');
      await _deleteFile(File(saveTo));
      await tmpFile.rename(saveTo);
      return (family: family, path: saveTo, name: name);
    } catch (_) {
      await _deleteFile(tmpFile);
      return null;
    }
  }

  /// 显示名优先取字体文件内部的名字，解析不出来才回落到文件名
  static Future<String> _resolveName(
    String filePath,
    String? fallbackName,
  ) async {
    final name = await FontNameParser.parse(filePath);
    if (name != null) return name;
    if (fallbackName != null) {
      final fromFile = Utils.getFileName(fallbackName, fileExt: false);
      if (fromFile.isNotEmpty) return fromFile;
    }
    return '未命名字体';
  }

  /// 取内容哈希前 16 位十六进制：足够防碰撞，又不会让族名过长
  static Future<String?> _hashFile(File file) async {
    try {
      final digest = await sha1.bind(file.openRead()).first;
      return digest.toString().substring(0, 16);
    } catch (_) {
      return null;
    }
  }

  static String _extensionOf(String fileName) {
    final ext = path.extension(fileName).toLowerCase();
    return _kFontExts.contains(ext.replaceFirst('.', '')) ? ext : '.ttf';
  }

  /// 移除单个已导入字体
  static Future<void> removeFont(String fontFamily) async {
    final filePath = customFonts.remove(fontFamily);
    if (filePath == null) return;
    _customFontNames.remove(fontFamily);
    _loadedFonts.remove(fontFamily);
    await _deleteFile(File(filePath));
    await _saveFonts();
    await _resetSelection({fontFamily});
  }

  /// 清空整个导入池。只回收指向池内字体的选中项，系统字体的选择不受影响。
  static Future<void> clearFonts() async {
    final removed = customFonts.keys.toSet();
    customFonts.clear();
    _customFontNames.clear();
    _loadedFonts.clear();

    final dir = Directory(_kFontDir);
    if (dir.existsSync()) {
      try {
        await dir.delete(recursive: true);
      } catch (_) {}
    }
    await _saveFonts();
    await _resetSelection(removed);
  }

  /// 被移除的字体若正在使用，立即回落到默认，
  /// 避免设置项指向一个已经不存在的字体
  static Future<void> _resetSelection(Set<String> removed) async {
    final updates = <String, dynamic>{};
    if (removed.contains(Pref.appFont)) {
      updates[SettingBoxKey.appFont] = null;
    }
    if (removed.contains(Pref.customDanmakuFontFamily)) {
      updates[SettingBoxKey.customDanmakuFontFamily] = null;
      if (Pref.danmakuFontSyncMode == DanmakuFontSyncMode.custom) {
        updates[SettingBoxKey.danmakuFontSyncMode] =
            DanmakuFontSyncMode.global.index;
      }
    }
    if (updates.isNotEmpty) {
      await GStorage.setting.putAll(updates);
    }
  }

  /// 剔除文件已丢失的池条目（用户手动删了文件、跨设备恢复设置等）
  static Future<void> _pruneMissingFonts() async {
    final missing = <String>{
      for (final entry in customFonts.entries)
        if (!File(entry.value).existsSync()) entry.key,
    };
    if (missing.isEmpty) return;
    for (final family in missing) {
      customFonts.remove(family);
      _customFontNames.remove(family);
      _loadedFonts.remove(family);
    }
    await _saveFonts();
    await _resetSelection(missing);
  }

  /// 删除池里已无引用的字体文件（导入中断、异常退出留下的残留）
  static Future<void> _cleanupOrphanFiles() async {
    final dir = Directory(_kFontDir);
    if (!dir.existsSync()) return;
    final referenced = customFonts.values.map(path.canonicalize).toSet();
    try {
      await for (final entity in dir.list()) {
        if (entity is File &&
            !referenced.contains(path.canonicalize(entity.path))) {
          await _deleteFile(entity);
        }
      }
    } catch (_) {}
  }

  static Future<void> _deleteFile(File file) async {
    if (!file.existsSync()) return;
    try {
      await file.delete();
    } catch (_) {}
  }

  /// 迁移旧版单槽位字体（customFontPath / customDanmakuFontPath）到导入池。
  /// 迁移后清空旧键，只会执行一次。
  static Future<void> _migrateLegacyFonts() async {
    final legacyAppPath = Pref.customFontPath;
    final legacyDanmakuPath = Pref.customDanmakuFontPath;
    if (legacyAppPath == null && legacyDanmakuPath == null) return;

    final updates = <String, dynamic>{};
    var poolChanged = false;

    if (legacyAppPath != null) {
      final legacyFamily = Pref.customFontFamily;
      final family = await _adoptLegacyFont(
        legacyAppPath,
        Pref.customFontName,
      );
      poolChanged |= family != null;
      // appFont 为空时不自动选中：更早的版本没有 appFont 这个 key，
      // 与"导入过字体但特意选了系统默认"在存储上无法区分，
      // 宁可回到系统默认——字体已在池中，用户可自行选回。
      // 旧字体文件已丢失时 family 为 null，选中项一并置空。
      if (legacyFamily != null && Pref.appFont == legacyFamily) {
        updates[SettingBoxKey.appFont] = family;
      }
    }

    if (legacyDanmakuPath != null) {
      final legacyFamily = Pref.customDanmakuFontFamily;
      final family = await _adoptLegacyFont(
        legacyDanmakuPath,
        Pref.customDanmakuFontName,
      );
      poolChanged |= family != null;
      if (legacyFamily != null) {
        // customDanmakuFontFamily 语义变更：改为存导入池的字体族名
        updates[SettingBoxKey.customDanmakuFontFamily] = family;
        if (family == null &&
            Pref.danmakuFontSyncMode == DanmakuFontSyncMode.custom) {
          updates[SettingBoxKey.danmakuFontSyncMode] =
              DanmakuFontSyncMode.global.index;
        }
      }
    }

    if (poolChanged) {
      await _saveFonts();
    }
    if (updates.isNotEmpty) {
      await GStorage.setting.putAll(updates);
    }
    await GStorage.setting.deleteAll(const {
      SettingBoxKey.customFontPath,
      SettingBoxKey.customFontFamily,
      SettingBoxKey.customFontName,
      SettingBoxKey.customDanmakuFontPath,
      SettingBoxKey.customDanmakuFontName,
    });

    for (final name in _kLegacyFontDirs) {
      final dir = Directory(path.join(appSupportDirPath, name));
      if (dir.existsSync()) {
        try {
          await dir.delete(recursive: true);
        } catch (_) {}
      }
    }
  }

  /// 把旧版字体文件复制进导入池，返回新的字体族名；文件已丢失时返回 null
  static Future<String?> _adoptLegacyFont(
    String filePath,
    String? legacyName,
  ) async {
    try {
      final file = File(filePath);
      if (!file.existsSync()) return null;

      final dir = Directory(_kFontDir);
      if (!dir.existsSync()) {
        await dir.create(recursive: true);
      }

      final hash = await _hashFile(file);
      if (hash == null) return null;

      final family = _familyOf(hash);
      _customFontNames[family] = await _resolveName(filePath, legacyName);

      final existing = customFonts[family];
      if (existing != null && File(existing).existsSync()) return family;

      final saveTo = path.join(
        _kFontDir,
        '$hash${_extensionOf(legacyName ?? filePath)}',
      );
      await _deleteFile(File(saveTo));
      await file.copy(saveTo);
      customFonts[family] = saveTo;
      return family;
    } catch (_) {
      return null;
    }
  }

  static Set<String> getFont() {
    if (_initialized) return _fonts;
    _initialized = true;
    if (!switch (defaultTargetPlatform) {
      .android => _initAndroid(),
      .windows => _initWindows(),
      .linux => _initLinux(),
      _ => true,
    }) {
      // TODO: ios/macos CTFontManagerCopyAvailableFontFamilyNames
      SmartDialog.showToast('加载系统字体失败');
    }
    return _fonts;
  }

  static int _enumFontCallback(
    Pointer<LOGFONT> lpelfe,
    Pointer<TEXTMETRIC> lpntme,
    int fontType,
    int lParam,
  ) {
    final familyName = lpelfe.ref.lfFaceName;
    if (familyName.startsWith('@')) return 1;
    _fonts.add(lpelfe.ref.lfFaceName);
    return 1;
  }

  @pragma('vm:prefer-inline')
  static bool _initWindows() {
    final hdc = GetDC(null);

    final logfont = calloc<LOGFONT>();
    logfont.ref.lfCharSet = DEFAULT_CHARSET;
    logfont.ref.lfFaceName = '';

    try {
      final result = EnumFontFamiliesEx(
        hdc,
        logfont,
        Pointer.fromFunction(_enumFontCallback, 0),
        const LPARAM(0),
        0,
      );

      return result != 0;
    } finally {
      calloc.free(logfont);
      ReleaseDC(null, hdc);
    }
  }

  @pragma('vm:prefer-inline')
  static bool _initLinux() {
    final FontConfig fc;
    try {
      fc = FontConfig(DynamicLibrary.open('libfontconfig.so.1'));
    } catch (e) {
      if (kDebugMode) debugPrint('无法加载 Fontconfig 库: $e');
      return false;
    }

    final config = fc.FcInitLoadConfigAndFonts();
    if (config == nullptr) {
      if (kDebugMode) debugPrint('Fontconfig 初始化失败');
      return false;
    }

    final fontSet = fc.FcConfigGetFonts(config, FcSetName.FcSetSystem);
    if (fontSet == nullptr) {
      if (kDebugMode) debugPrint('无法获取系统字体集');
      fc.FcConfigDestroy(config);
      return false;
    }

    final nfont = fontSet.ref.nfont;
    final family = FC_FAMILY.toNativeUtf8().cast<Char>();
    for (int i = 0; i < nfont; i++) {
      final pattern = fontSet.ref.fonts[i];
      if (pattern == nullptr) continue;

      final outPtr = calloc<Pointer<UnsignedChar>>();

      try {
        final result = fc.FcPatternGetString(pattern, family, 0, outPtr);

        if (result == 0) {
          final strPtr = outPtr.value;
          if (strPtr != nullptr) {
            _fonts.add(strPtr.cast<Utf8>().toDartString());
          }
        }
      } finally {
        calloc.free(outPtr);
      }
    }
    calloc.free(family);
    fc.FcConfigDestroy(config);

    return true;
  }

  @pragma('vm:prefer-inline')
  static bool _initAndroid() {
    final fontFamilies = AndroidHelper.fontFamilies();
    if (fontFamilies != null) {
      try {
        final length = fontFamilies.length;
        for (var i = 0; i < length; i++) {
          _fonts.add(fontFamilies[i]!.toDartString(releaseOriginal: true));
        }
        return true;
      } finally {
        fontFamilies.release();
      }
    }
    return false;
  }
}
