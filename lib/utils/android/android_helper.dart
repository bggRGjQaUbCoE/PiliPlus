/// 鸿蒙分支替身：上游此类通过 `jni` 直调 Android 原生方法（见 [bindings.g.dart]）。
/// 鸿蒙上不引入 `jni`，且所有调用点均由 `Platform.isAndroid` 守卫，故这里只保留
/// 与上游一致的 API 形态，实现为空操作。鸿蒙的对应能力由 `harmony_adapt/` 与
/// `floating` 插件提供。
library;

abstract final class PiliAndroidHelper {
  static void back() {}

  static ({
    int? linkSpeed,
    int? rssi,
    int? signalLevel,
    bool metered,
    bool weakHint,
  })? networkInfo() => null;

  static void biliSendCommAntifraud(
    int action,
    int oid,
    int type,
    int rpId,
    int root,
    int parent,
    int ctime,
    String commentText,
    List pictures,
    String sourceId,
    int uid,
    String cookie,
  ) {}

  static void openLinkVerifySettings() {}

  static bool openMusic(String title, String? artist, String? album) => false;

  static void enterPip(
    int width,
    int height, {
    required bool autoEnter,
    required bool isLive,
    required bool isPlaying,
  }) {}

  static void disableAutoEnterPip() {}

  static (int, int)? maxScreenSize() => null;

  static void createShortcut(
    String id,
    String uri,
    String label,
    String path,
  ) {}
}
