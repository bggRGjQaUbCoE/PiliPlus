import 'dart:io' show Platform;

/// Set only by the Ubuntu Touch release build:
/// `--dart-define=PILI_UBUNTU_TOUCH=true`.
/// Desktop builds leave it false.
abstract final class UbuntuTouch {
  static const bool enabled = bool.fromEnvironment('PILI_UBUNTU_TOUCH');

  /// Click package name. AppArmor allows writes under this directory, not
  /// under `com.example.piliplus` or the executable name.
  static const String clickPackage = 'piliplus.alphaliu01';

  static const List<String> cjkFallback = [
    'WenQuanYi Micro Hei',
    'Noto Sans CJK SC',
    'Noto Sans CJK TC',
    'Droid Sans Fallback',
  ];

  static String get dataHome => _home('.local/share/$clickPackage');

  static String get cacheHome => _home('.cache/$clickPackage');

  static String _home(String relative) {
    final home = Platform.environment['HOME'];
    if (home == null || home.isEmpty) {
      throw StateError('HOME is unset');
    }
    return '$home/$relative';
  }
}
