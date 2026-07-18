import 'package:PiliPlus/models/common/bar_hide_type.dart';
import 'package:PiliPlus/models/common/dynamic/dynamic_badge_mode.dart';
import 'package:PiliPlus/models/common/dynamic/dynamics_type.dart';
import 'package:PiliPlus/models/common/dynamic/up_panel_position.dart';
import 'package:PiliPlus/models/common/follow_order_type.dart';
import 'package:PiliPlus/models/common/home_tab_type.dart';
import 'package:PiliPlus/models/common/member/tab_type.dart';
import 'package:PiliPlus/models/common/msg/msg_unread_type.dart';
import 'package:PiliPlus/models/common/nav_bar_config.dart';
import 'package:PiliPlus/models/common/reply/reply_sort_type.dart';
import 'package:PiliPlus/models/common/sponsor_block/segment_type.dart';
import 'package:PiliPlus/models/common/sponsor_block/skip_type.dart';
import 'package:PiliPlus/models/common/super_chat_type.dart';
import 'package:PiliPlus/models/common/super_resolution_type.dart';
import 'package:PiliPlus/models/common/theme/theme_color_type.dart';
import 'package:PiliPlus/models/common/theme/theme_type.dart';
import 'package:PiliPlus/models/common/video/cdn_type.dart';
import 'package:PiliPlus/models/common/video/subtitle_pref_type.dart';
import 'package:PiliPlus/models/common/video/video_decode_type.dart';
import 'package:PiliPlus/plugin/pl_player/models/bottom_progress_behavior.dart';
import 'package:PiliPlus/plugin/pl_player/models/fullscreen_mode.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_repeat.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:flex_seed_scheme/flex_seed_scheme.dart' show FlexSchemeVariant;
import 'package:get/get.dart' show Transition;

abstract final class SettingsImportValidator {
  /// Guards preferences read while storage, services, HTTP, theming, and root
  /// navigation initialize. It also rejects enum/list values that typed getters
  /// would otherwise index without bounds checks.
  static void validateAndNormalize(
    Map<dynamic, dynamic> setting,
    Map<dynamic, dynamic> video,
  ) {
    _validateTypes<bool>(setting, const [
      SettingBoxKey.horizontalScreen,
      SettingBoxKey.saveReply,
      SettingBoxKey.enableBackgroundPlay,
      SettingBoxKey.enableHttp2,
      SettingBoxKey.enableSystemProxy,
      SettingBoxKey.showWindowTitleBar,
      SettingBoxKey.isWindowMaximized,
      SettingBoxKey.dynamicColor,
      SettingBoxKey.enableLog,
      SettingBoxKey.badCertificateCallback,
      SettingBoxKey.checkDynamic,
      SettingBoxKey.enableMYBar,
      SettingBoxKey.floatingNavBar,
      SettingBoxKey.useSideBar,
      SettingBoxKey.mainTabBarView,
      SettingBoxKey.optTabletNav,
      SettingBoxKey.directExitOnBack,
      SettingBoxKey.showTrayIcon,
      SettingBoxKey.minimizeOnExit,
      SettingBoxKey.pauseOnMinimize,
      SettingBoxKey.autoUpdate,
      SettingBoxKey.hideBottomBar,
      SettingBoxKey.enableSearchWord,
      SettingBoxKey.hideTopBar,
    ]);
    _validateTypes<String>(setting, const [
      SettingBoxKey.downloadPath,
      SettingBoxKey.displayMode,
      SettingBoxKey.systemProxyHost,
      SettingBoxKey.systemProxyPort,
      SettingBoxKey.blockServer,
    ]);
    _validateTypes<int>(setting, const [
      SettingBoxKey.dynamicPeriod,
      SettingBoxKey.retryCount,
      SettingBoxKey.retryDelay,
    ]);

    _validateDouble(setting, SettingBoxKey.uiScale, mustBePositive: true);
    _validateDouble(
      setting,
      SettingBoxKey.defaultTextScale,
      mustBePositive: true,
    );
    _validateNumber(setting, SettingBoxKey.maxCacheSize);
    _validateDoubleList(
      setting,
      SettingBoxKey.windowSize,
      expectedLength: 2,
      mustBePositive: true,
    );
    _validateDoubleList(
      setting,
      SettingBoxKey.windowPosition,
      expectedLength: 2,
    );
    _validateDoubleList(
      setting,
      SettingBoxKey.dynamicDetailRatio,
      expectedLength: 2,
    );
    _validateDoubleList(
      setting,
      SettingBoxKey.springDescription,
      expectedLength: 3,
    );

    _validateEnumIndices(setting, {
      SettingBoxKey.memberTab: MemberTabType.values.length,
      SettingBoxKey.themeMode: ThemeType.values.length,
      SettingBoxKey.dynamicBadgeMode: DynamicBadgeMode.values.length,
      SettingBoxKey.msgBadgeMode: DynamicBadgeMode.values.length,
      SettingBoxKey.defaultHomePage: NavigationBarType.values.length,
      SettingBoxKey.upPanelPosition: UpPanelPosition.values.length,
      SettingBoxKey.fullScreenMode: FullScreenMode.values.length,
      SettingBoxKey.btmProgressBehavior: BtmProgressBehavior.values.length,
      SettingBoxKey.subtitlePreferenceV2: SubtitlePrefType.values.length,
      SettingBoxKey.defaultDynamicType: DynamicsTabType.values.length,
      SettingBoxKey.schemeVariant: FlexSchemeVariant.values.length,
      SettingBoxKey.barHideType: BarHideType.values.length,
      SettingBoxKey.replySortType: ReplySortType.values.length,
      SettingBoxKey.pageTransition: Transition.values.length,
      SettingBoxKey.superResolutionType: SuperResolutionType.values.length,
      SettingBoxKey.superChatType: SuperChatType.values.length,
      SettingBoxKey.pgcSkipType: SkipType.values.length,
      SettingBoxKey.audioPlayMode: PlayRepeat.values.length,
      SettingBoxKey.followOrderType: FollowOrderType.values.length,
      SettingBoxKey.customColor: colorThemeTypes.length,
    });
    _validateEnumIndices(video, {
      VideoBoxKey.playRepeat: PlayRepeat.values.length,
    });

    _validateIndexList(
      setting,
      SettingBoxKey.msgUnReadTypeV2,
      MsgUnReadType.values.length,
      requireUnique: true,
    );
    _validateIndexList(
      setting,
      SettingBoxKey.tabBarSort,
      HomeTabType.values.length,
      requireUnique: true,
    );
    _validateIndexList(
      setting,
      SettingBoxKey.navBarSort,
      NavigationBarType.values.length,
      requireUnique: true,
    );
    _validateIndexList(
      setting,
      SettingBoxKey.blockSettings,
      SkipType.values.length,
      expectedLength: SegmentType.values.length,
    );

    _validateStringEnum(
      setting,
      SettingBoxKey.CDNService,
      CDNService.values.map((item) => item.name).toSet(),
    );
    _validateStringList(
      setting,
      SettingBoxKey.preferCodecs,
      VideoDecodeFormatType.values.map((item) => item.name).toSet(),
    );

    _validateDouble(video, VideoBoxKey.playSpeedDefault, mustBePositive: true);
    _validateDouble(
      video,
      VideoBoxKey.longPressSpeedDefault,
      mustBePositive: true,
    );
    _validateDoubleList(
      video,
      VideoBoxKey.speedsList,
      mustBePositive: true,
    );
  }

  static void _validateTypes<T>(
    Map<dynamic, dynamic> values,
    List<String> keys,
  ) {
    for (final key in keys) {
      if (values.containsKey(key) && values[key] is! T) {
        _invalid(key, T.toString());
      }
    }
  }

  static void _validateEnumIndices(
    Map<dynamic, dynamic> values,
    Map<String, int> enumLengths,
  ) {
    for (final MapEntry(key: key, value: length) in enumLengths.entries) {
      if (!values.containsKey(key)) continue;
      final value = values[key];
      if (value is! int || value < 0 || value >= length) {
        _invalid(key, 'an enum index from 0 to ${length - 1}');
      }
    }
  }

  static void _validateIndexList(
    Map<dynamic, dynamic> values,
    String key,
    int enumLength, {
    int? expectedLength,
    bool requireUnique = false,
  }) {
    if (!values.containsKey(key)) return;
    final value = values[key];
    if (value is! List ||
        (expectedLength != null && value.length != expectedLength)) {
      _invalid(key, _listExpectation(expectedLength, 'enum indices'));
    }

    final seen = <int>{};
    for (final item in value) {
      if (item is! int || item < 0 || item >= enumLength) {
        _invalid(key, 'a list of enum indices from 0 to ${enumLength - 1}');
      }
      if (requireUnique && !seen.add(item)) {
        _invalid(key, 'a list of unique enum indices');
      }
    }
  }

  static void _validateDouble(
    Map<dynamic, dynamic> values,
    String key, {
    bool mustBePositive = false,
  }) {
    if (!values.containsKey(key)) return;
    final value = values[key];
    if (value is! num || !value.isFinite || (mustBePositive && value <= 0)) {
      _invalid(key, mustBePositive ? 'a positive finite number' : 'a number');
    }
    values[key] = value.toDouble();
  }

  static void _validateNumber(
    Map<dynamic, dynamic> values,
    String key, {
    bool mustBePositive = false,
  }) {
    if (!values.containsKey(key)) return;
    final value = values[key];
    if (value is! num || !value.isFinite || (mustBePositive && value <= 0)) {
      _invalid(key, mustBePositive ? 'a positive finite number' : 'a number');
    }
  }

  static void _validateDoubleList(
    Map<dynamic, dynamic> values,
    String key, {
    int? expectedLength,
    bool mustBePositive = false,
  }) {
    if (!values.containsKey(key)) return;
    final value = values[key];
    if (value is! List ||
        (expectedLength != null && value.length != expectedLength)) {
      _invalid(key, _listExpectation(expectedLength, 'numbers'));
    }

    final normalized = <double>[];
    for (final item in value) {
      if (item is! num || !item.isFinite || (mustBePositive && item <= 0)) {
        _invalid(
          key,
          _listExpectation(
            expectedLength,
            mustBePositive ? 'positive finite numbers' : 'finite numbers',
          ),
        );
      }
      normalized.add(item.toDouble());
    }
    values[key] = normalized;
  }

  static void _validateStringEnum(
    Map<dynamic, dynamic> values,
    String key,
    Set<String> validValues,
  ) {
    if (!values.containsKey(key)) return;
    final value = values[key];
    if (value is! String || !validValues.contains(value)) {
      _invalid(key, 'a known enum name');
    }
  }

  static void _validateStringList(
    Map<dynamic, dynamic> values,
    String key,
    Set<String> validValues,
  ) {
    if (!values.containsKey(key)) return;
    final value = values[key];
    if (value is! List ||
        value.any((item) => item is! String || !validValues.contains(item))) {
      _invalid(key, 'a list of known enum names');
    }
  }

  static String _listExpectation(int? length, String itemType) => length == null
      ? 'a list of $itemType'
      : 'a $length-item list of $itemType';

  static Never _invalid(String key, String expectation) {
    throw FormatException(
      'Invalid imported setting "$key": expected $expectation',
    );
  }
}
