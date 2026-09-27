import 'dart:convert';
import 'dart:io';

import 'package:PiliPlus/common/widgets/gesture/horizontal_drag_gesture_recognizer.dart'
    show deviceTouchSlop;
import 'package:PiliPlus/common/widgets/pair.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/models/common/bar_hide_type.dart';
import 'package:PiliPlus/models/common/danmaku/danmaku_font_sync_mode.dart';
import 'package:PiliPlus/models/common/dm_chart_source.dart';
import 'package:PiliPlus/models/common/dynamic/dynamic_badge_mode.dart';
import 'package:PiliPlus/models/common/dynamic/dynamics_type.dart';
import 'package:PiliPlus/models/common/dynamic/up_panel_position.dart';
import 'package:PiliPlus/models/common/follow_order_type.dart';
import 'package:PiliPlus/models/common/member/tab_type.dart';
import 'package:PiliPlus/models/common/msg/msg_unread_type.dart';
import 'package:PiliPlus/models/common/nav_bar_config.dart';
import 'package:PiliPlus/models/common/rcmd_mode.dart';
import 'package:PiliPlus/models/common/reply/reply_sort_type.dart';
import 'package:PiliPlus/models/common/sponsor_block/segment_type.dart';
import 'package:PiliPlus/models/common/sponsor_block/skip_type.dart';
import 'package:PiliPlus/models/common/super_chat_time_type.dart';
import 'package:PiliPlus/models/common/super_chat_type.dart';
import 'package:PiliPlus/models/common/super_resolution_type.dart';
import 'package:PiliPlus/models/common/theme/theme_type.dart';
import 'package:PiliPlus/models/common/video/audio_quality.dart';
import 'package:PiliPlus/models/common/video/author_play_speed.dart';
import 'package:PiliPlus/models/common/video/cdn_type.dart';
import 'package:PiliPlus/models/common/video/live_quality.dart';
import 'package:PiliPlus/models/common/video/subtitle_pref_type.dart';
import 'package:PiliPlus/models/common/video/video_decode_type.dart';
import 'package:PiliPlus/models/common/video/video_quality.dart';
import 'package:PiliPlus/models/user/danmaku_rule.dart';
import 'package:PiliPlus/models/user/info.dart';
import 'package:PiliPlus/pages/setting/pages/fullscreen_sc_size.dart'
    show kFullScreenSCWidth;
import 'package:PiliPlus/plugin/pl_player/models/audio_output_type.dart';
import 'package:PiliPlus/plugin/pl_player/models/bottom_progress_behavior.dart';
import 'package:PiliPlus/plugin/pl_player/models/double_tap_seek_layout.dart';
import 'package:PiliPlus/plugin/pl_player/models/fullscreen_mode.dart';
import 'package:PiliPlus/plugin/pl_player/models/hwdec_type.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_repeat.dart';
import 'package:PiliPlus/utils/device_utils.dart';
import 'package:PiliPlus/utils/extension/iterable_ext.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/login_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:crypto/crypto.dart';
import 'package:flex_seed_scheme/flex_seed_scheme.dart' show FlexSchemeVariant;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_ce/hive.dart';
import 'package:material_ui/material_ui.dart';

abstract final class Pref {
  static final Box _setting = GStorage.setting;
  static final Box _video = GStorage.video;
  static final Box _localCache = GStorage.localCache;

  static UserInfoData? get userInfoCache =>
      GStorage.userInfo.get('userInfoCache');

  static List<double> get dynamicDetailRatio => List<double>.from(
    _setting.get(
      SettingBoxKey.dynamicDetailRatio,
      defaultValue: const [60.0, 40.0],
    ),
  );

  static Set<int> get blackMids {
    final data = _localCache.get(
      LocalCacheKey.blackMids,
      defaultValue: <int>{},
    );
    // 处理 JSON 导入时可能为 List 的情况
    if (data is List) {
      final set = data.whereType<int>().toSet();
      if (set.isNotEmpty) {
        _localCache.put(LocalCacheKey.blackMids, set);
      }
      return set;
    }
    return data is Set<int> ? data : <int>{};
  }

  static set blackMids(Set<int> blackMidsSet) =>
      _localCache.put(LocalCacheKey.blackMids, blackMidsSet);

  static Set<int> get dynamicsBlockedMids {
    final data = _localCache.get(
      LocalCacheKey.dynamicsBlockedMids,
      defaultValue: <int>{},
    );
    // 处理 JSON 导入时可能为 List 的情况
    if (data is List) {
      final set = data.whereType<int>().toSet();
      if (set.isNotEmpty) {
        _localCache.put(LocalCacheKey.dynamicsBlockedMids, set);
      }
      return set;
    }
    return data is Set<int> ? data : <int>{};
  }

  static set dynamicsBlockedMids(Set<int> blockedMidsSet) {
    _localCache.put(LocalCacheKey.dynamicsBlockedMids, blockedMidsSet);
  }

  static Map<int, String> get whitelistMids {
    final data = _localCache.get(LocalCacheKey.whitelistMids);

    if (data is Set) {
      final map = <int, String>{};
      for (final mid in data) {
        if (mid is int) {
          map[mid] = 'UID:$mid';
        }
      }
      _localCache.put(LocalCacheKey.whitelistMids, map);
      return map;
    }

    if (data is Map) {
      final map = <int, String>{};
      for (final entry in data.entries) {
        final key = entry.key;
        final value = entry.value;

        int? uid;
        if (key is int) {
          uid = key;
        } else if (key is String) {
          uid = int.tryParse(key);
        }

        if (uid != null && value is String) {
          map[uid] = value;
        }
      }

      if (map.isNotEmpty && data.keys.first is! int) {
        _localCache.put(LocalCacheKey.whitelistMids, map);
      }

      return map;
    }

    return <int, String>{};
  }

  static set whitelistMids(Map<int, String> whitelistMidsMap) {
    _localCache.put(LocalCacheKey.whitelistMids, whitelistMidsMap);
  }

  static Map<int, String> get recommendBlockedMids {
    final data = _localCache.get(LocalCacheKey.recommendBlockedMids);

    // 向后兼容：如果是旧的 Set<int> 格式，转换为 Map<int, String>
    if (data is Set) {
      final map = <int, String>{};
      for (final mid in data) {
        if (mid is int) {
          map[mid] = 'UID:$mid'; // 旧数据使用默认名称
        }
      }
      // 自动迁移数据
      _localCache.put(LocalCacheKey.recommendBlockedMids, map);
      return map;
    }

    // 如果是新格式 Map，需要处理 key 可能是 String 的情况（JSON 导入）
    if (data is Map) {
      final map = <int, String>{};
      for (final entry in data.entries) {
        final key = entry.key;
        final value = entry.value;

        // 处理 key：可能是 int 或 String（JSON 导入时）
        int? uid;
        if (key is int) {
          uid = key;
        } else if (key is String) {
          uid = int.tryParse(key);
        }

        // 处理 value：确保是 String
        if (uid != null && value is String) {
          map[uid] = value;
        }
      }

      // 如果经过转换，保存标准格式
      if (map.isNotEmpty && data.keys.first is! int) {
        _localCache.put(LocalCacheKey.recommendBlockedMids, map);
      }

      return map;
    }

    // 默认返回空 Map
    return <int, String>{};
  }

  static set recommendBlockedMids(Map<int, String> blockedMidsMap) {
    _localCache.put(LocalCacheKey.recommendBlockedMids, blockedMidsMap);
  }

  static Map<int, String> get replyBlockedMids {
    final data = _localCache.get(LocalCacheKey.replyBlockedMids);

    if (data is Set) {
      final map = <int, String>{};
      for (final mid in data) {
        if (mid is int) {
          map[mid] = 'UID:$mid';
        }
      }
      _localCache.put(LocalCacheKey.replyBlockedMids, map);
      return map;
    }

    if (data is Map) {
      final map = <int, String>{};
      for (final entry in data.entries) {
        final key = entry.key;
        final value = entry.value;
        int? uid;
        if (key is int) {
          uid = key;
        } else if (key is String) {
          uid = int.tryParse(key);
        }
        if (uid != null && value is String) {
          map[uid] = value;
        }
      }
      if (map.isNotEmpty && data.keys.first is! int) {
        _localCache.put(LocalCacheKey.replyBlockedMids, map);
      }
      return map;
    }

    return <int, String>{};
  }

  static set replyBlockedMids(Map<int, String> blockedMidsMap) {
    _localCache.put(LocalCacheKey.replyBlockedMids, blockedMidsMap);
  }

  static Map<int, String> get remarkMids {
    final data = _localCache.get(LocalCacheKey.remarkMids);
    if (data is Map) {
      final map = <int, String>{};
      for (final entry in data.entries) {
        final key = entry.key;
        final value = entry.value;
        int? uid;
        if (key is int) {
          uid = key;
        } else if (key is String) {
          uid = int.tryParse(key);
        }
        if (uid != null && value is String) {
          map[uid] = value;
        }
      }
      if (map.isNotEmpty && data.keys.first is! int) {
        _localCache.put(LocalCacheKey.remarkMids, map);
      }
      return map;
    }
    return <int, String>{};
  }

  static set remarkMids(Map<int, String> v) =>
      _localCache.put(LocalCacheKey.remarkMids, v);

  static RuleFilter get danmakuFilterRule => _localCache.get(
    LocalCacheKey.danmakuFilterRules,
    defaultValue: RuleFilter.empty(),
  );

  static void setBlackMid(int mid) => _localCache.put(
    LocalCacheKey.blackMids,
    GlobalData().blackMids..add(mid),
  );

  static void removeBlackMid(int mid) => _localCache.put(
    LocalCacheKey.blackMids,
    GlobalData().blackMids..remove(mid),
  );

  static MemberTabType get memberTab =>
      MemberTabType.values[_setting.get(
        SettingBoxKey.memberTab,
        defaultValue: 0,
      )];

  static int get _themeTypeInt => _setting.get(
    SettingBoxKey.themeMode,
    defaultValue: ThemeType.system.index,
  );

  static ThemeType get themeType => ThemeType.values[_themeTypeInt];

  static ThemeMode get themeMode => switch (_themeTypeInt) {
    0 => ThemeMode.light,
    1 => ThemeMode.dark,
    _ => ThemeMode.system,
  };

  static List<double> get springDescription => List<double>.from(
    _setting.get(SettingBoxKey.springDescription) ??
        // duration: 0.3, bounce: 0.0
        const [1.0, 438.64908449286037, 41.88790204786391],
  );
  //   [0.5, 100.0, 2.2 * math.sqrt(50)], // [mass, stiffness, damping]

  static List<double> get speedList => List<double>.from(
    _video.get(
      VideoBoxKey.speedsList,
      defaultValue: const [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0, 3.0],
    ),
  );

  static List<Pair<SegmentType, SkipType>> get blockSettings {
    final list = _setting.get(SettingBoxKey.blockSettings) as List?;
    if (list == null || list.length != SegmentType.values.length) {
      return SegmentType.values
          .map((i) => Pair(first: i, second: SkipType.skipOnce))
          .toList();
    }
    return SegmentType.values
        .map(
          (item) =>
              Pair(first: item, second: SkipType.values[list[item.index]]),
        )
        .toList();
  }

  static List<Color> get blockColor {
    final list = _setting.get(SettingBoxKey.blockColor) as List?;
    if (list == null || list.length != SegmentType.values.length) {
      return SegmentType.values.map((i) => i.color).toList();
    }
    return SegmentType.values.map((item) {
      final String e = list[item.index];
      final color = e.isNotEmpty ? int.tryParse('FF$e', radix: 16) : null;
      return color != null ? Color(color) : item.color;
    }).toList();
  }

  static bool get feedBackEnable =>
      _setting.get(SettingBoxKey.feedBackEnable, defaultValue: false);

  static int get picQuality =>
      _setting.get(SettingBoxKey.defaultPicQa, defaultValue: 10);

  static DynamicBadgeMode get dynamicBadgeType =>
      DynamicBadgeMode.values[_setting.get(
        SettingBoxKey.dynamicBadgeMode,
        defaultValue: DynamicBadgeMode.number.index,
      )];

  static DynamicBadgeMode get msgBadgeMode =>
      DynamicBadgeMode.values[_setting.get(
        SettingBoxKey.msgBadgeMode,
        defaultValue: DynamicBadgeMode.number.index,
      )];

  static Set<MsgUnReadType> get msgUnReadTypeV2 =>
      (_setting.get(SettingBoxKey.msgUnReadTypeV2) as List?)
          ?.map((index) => MsgUnReadType.values[index])
          .toSet() ??
      MsgUnReadType.values.toSet();

  static NavigationBarType get defaultHomePage =>
      NavigationBarType.values[defaultHomePageIndex];

  static int get defaultHomePageIndex => _setting.get(
    SettingBoxKey.defaultHomePage,
    defaultValue: NavigationBarType.home.index,
  );

  static int get previewQ =>
      _setting.get(SettingBoxKey.previewQuality, defaultValue: 100);

  static double get smallCardWidth =>
      _setting.get(SettingBoxKey.smallCardWidth, defaultValue: 240.0);

  static double get recommendCardWidth =>
      _setting.get(SettingBoxKey.recommendCardWidth, defaultValue: 240.0);

  static UpPanelPosition get upPanelPosition =>
      UpPanelPosition.values[_setting.get(
        SettingBoxKey.upPanelPosition,
        defaultValue: UpPanelPosition.leftFixed.index,
      )];

  static FullScreenMode get fullScreenMode {
    int? index = _setting.get(SettingBoxKey.fullScreenMode);
    if (index == null) {
      final FullScreenMode mode = horizontalScreen && DeviceUtils.isTablet
          ? .none
          : .auto;
      _setting.put(SettingBoxKey.fullScreenMode, mode.index);
      return mode;
    }
    return FullScreenMode.values[index];
  }

  static BtmProgressBehavior get btmProgressBehavior =>
      BtmProgressBehavior.values[_setting.get(
        SettingBoxKey.btmProgressBehavior,
        defaultValue: BtmProgressBehavior.alwaysShow.index,
      )];

  static SubtitlePrefType get subtitlePreferenceV2 =>
      SubtitlePrefType.values[_setting.get(
        SettingBoxKey.subtitlePreferenceV2,
        defaultValue: SubtitlePrefType.off.index,
      )];

  static bool get useRelativeSlide =>
      _setting.get(SettingBoxKey.useRelativeSlide, defaultValue: false);

  static int get sliderDuration =>
      _setting.get(SettingBoxKey.sliderDuration, defaultValue: 90);

  static int get defaultVideoQa => _setting.get(
    SettingBoxKey.defaultVideoQa,
    defaultValue: VideoQuality.super8k.code,
  );

  static int get defaultVideoQaCellular => _setting.get(
    SettingBoxKey.defaultVideoQaCellular,
    defaultValue: VideoQuality.high1080.code,
  );

  /// 半屏默认画质。null = 跟随全屏默认画质
  static int? get defaultVideoQaHalfScreen {
    final val = _setting.get(SettingBoxKey.defaultVideoQaHalfScreen);
    if (val == null || val == -1) return null;
    return val as int;
  }

  static int get defaultAudioQa => _setting.get(
    SettingBoxKey.defaultAudioQa,
    defaultValue: AudioQuality.hiRes.code,
  );

  static int get defaultAudioQaCellular => _setting.get(
    SettingBoxKey.defaultAudioQaCellular,
    defaultValue: AudioQuality.k192.code,
  );

  static List<VideoDecodeFormatType> get preferCodecs {
    final codecs = _setting.get(SettingBoxKey.preferCodecs);
    if (codecs is List) {
      return codecs.map((i) => VideoDecodeFormatType.values.byName(i)).toList();
    }
    return const <VideoDecodeFormatType>[.AVC, .AV1];
  }

  static List<VideoDecodeFormatType> get preferCodecsCellular {
    final codecs = _setting.get(SettingBoxKey.preferCodecsCellular);
    if (codecs is List) {
      return codecs.map((i) => VideoDecodeFormatType.values.byName(i)).toList();
    }
    return preferCodecs;
  }

  static String get hardwareDecoding => _setting.get(
    SettingBoxKey.hardwareDecoding,
    defaultValue: HwDecType.kHwdec,
  );

  static String get videoSync =>
      _setting.get(SettingBoxKey.videoSync, defaultValue: 'display-resample');

  static String get autosync => _setting.get(
    SettingBoxKey.autosync,
    defaultValue: Platform.isAndroid ? '30' : '0',
  );

  static CDNService get defaultCDNService {
    if (_setting.get(SettingBoxKey.CDNService) case final String cdnName) {
      return CDNService.values.byName(cdnName);
    }
    return CDNService.backupUrl;
  }

  static String? get customCDNUrl {
    final value = _setting.get(SettingBoxKey.customCDNUrl);
    return value is String && value.isNotEmpty ? value : null;
  }

  static String get banWordForRecommend =>
      _setting.get(SettingBoxKey.banWordForRecommend, defaultValue: '');

  static String get banWordForRecommendUpName =>
      _setting.get(SettingBoxKey.banWordForRecommendUpName, defaultValue: '');

  static String get banWordForReply =>
      _setting.get(SettingBoxKey.banWordForReply, defaultValue: '');

  static String get banWordForZone =>
      _setting.get(SettingBoxKey.banWordForZone, defaultValue: '');

  static bool get appRcmd =>
      _setting.get(SettingBoxKey.appRcmd, defaultValue: true);

  /// 推荐流模式，首次读取时从旧 key appRcmd 迁移
  static RcmdMode get rcmdMode {
    final index = _setting.get(SettingBoxKey.rcmdMode);
    if (index != null) {
      return RcmdMode.values.elementAtOrNull(index) ?? RcmdMode.app;
    }
    // 旧版迁移：appRcmd true→App, false→Web
    return appRcmd ? RcmdMode.app : RcmdMode.web;
  }

  static bool get removeBlockedRcmd =>
      _setting.get(SettingBoxKey.removeBlockedRcmd, defaultValue: false);

  static String get systemProxyHost =>
      _setting.get(SettingBoxKey.systemProxyHost, defaultValue: '');

  static String get systemProxyPort =>
      _setting.get(SettingBoxKey.systemProxyPort, defaultValue: '');

  static DynamicsTabType get defaultDynamicType =>
      DynamicsTabType.values[defaultDynamicTypeIndex];

  static int get defaultDynamicTypeIndex => _setting.get(
    SettingBoxKey.defaultDynamicType,
    defaultValue: DynamicsTabType.all.index,
  );

  static bool get showDynInteraction =>
      _setting.get(SettingBoxKey.showDynInteraction, defaultValue: true);

  static double get blockLimit =>
      _setting.get(SettingBoxKey.blockLimit, defaultValue: 0.0);

  static double get refreshDisplacement => _setting.get(
    SettingBoxKey.refreshDisplacement,
    defaultValue: PlatformUtils.isMobile ? 20.0 : 40.0,
  );

  static String get blockUserID {
    String? blockUserID = _setting.get(SettingBoxKey.blockUserID);
    if (blockUserID == null || blockUserID.isEmpty) {
      blockUserID = Digest(
        List.generate(16, (_) => Utils.random.nextInt(256)),
      ).toString();
      _setting.put(SettingBoxKey.blockUserID, blockUserID);
    }
    return blockUserID;
  }

  static bool get blockToast =>
      _setting.get(SettingBoxKey.blockToast, defaultValue: true);

  static bool get blockSkipWhenSeekIntoSegment => _setting.get(
    SettingBoxKey.blockSkipWhenSeekIntoSegment,
    defaultValue: false,
  );

  static String get blockServer => _setting.get(
    SettingBoxKey.blockServer,
    defaultValue: HttpString.sponsorBlockBaseUrl,
  );

  static bool get blockTrack =>
      _setting.get(SettingBoxKey.blockTrack, defaultValue: !kDebugMode);

  static bool get checkDynamic =>
      _setting.get(SettingBoxKey.checkDynamic, defaultValue: true);

  static int get dynamicPeriod =>
      _setting.get(SettingBoxKey.dynamicPeriod, defaultValue: 5);

  static FlexSchemeVariant get schemeVariant =>
      FlexSchemeVariant.values[_setting.get(
        SettingBoxKey.schemeVariant,
        defaultValue: FlexSchemeVariant.material3Legacy.index,
      )];

  static double get danmakuFontScaleFS => _setting.get(
    SettingBoxKey.danmakuFontScaleFS,
    defaultValue: PlatformUtils.isMobile ? 1.2 : 1.7,
  );

  static bool get danmakuMassiveMode =>
      _setting.get(SettingBoxKey.danmakuMassiveMode, defaultValue: false);

  static bool get danmakuFixedV =>
      _setting.get(SettingBoxKey.danmakuFixedV, defaultValue: false);

  static bool get danmakuStatic2Scroll =>
      _setting.get(SettingBoxKey.danmakuStatic2Scroll, defaultValue: false);

  static double get subtitleFontScale =>
      _setting.get(SettingBoxKey.subtitleFontScale, defaultValue: 1.0);

  static double get subtitleFontScaleFS =>
      _setting.get(SettingBoxKey.subtitleFontScaleFS, defaultValue: 1.5);

  static bool get showViewPoints =>
      _setting.get(SettingBoxKey.showViewPoints, defaultValue: true);

  static bool get showViewPointsOverlay =>
      _setting.get(SettingBoxKey.showViewPointsOverlay, defaultValue: true);

  static bool get showRelatedVideo =>
      _setting.get(SettingBoxKey.showRelatedVideo, defaultValue: true);

  static bool get showVideoReply =>
      _setting.get(SettingBoxKey.showVideoReply, defaultValue: true);

  static bool get showBangumiReply =>
      _setting.get(SettingBoxKey.showBangumiReply, defaultValue: true);

  static bool get alwaysExpandIntroPanel =>
      _setting.get(SettingBoxKey.alwaysExpandIntroPanel, defaultValue: false);

  static bool get expandIntroPanelH =>
      _setting.get(SettingBoxKey.expandIntroPanelH, defaultValue: false);

  static bool get horizontalSeasonPanel => _setting.get(
    SettingBoxKey.horizontalSeasonPanel,
    defaultValue: horizontalScreen,
  );

  static bool get horizontalMemberPage => _setting.get(
    SettingBoxKey.horizontalMemberPage,
    defaultValue: horizontalScreen,
  );

  static int? get replyLengthLimit {
    int length = _setting.get(SettingBoxKey.replyLengthLimit, defaultValue: 6);
    if (length <= 0) {
      return null;
    }
    return length;
  }

  static int get defaultPicQa =>
      _setting.get(SettingBoxKey.defaultPicQa, defaultValue: 10);

  static double get danmakuLineHeight =>
      _setting.get(SettingBoxKey.danmakuLineHeight, defaultValue: 1.6);

  static bool get showArgueMsg =>
      _setting.get(SettingBoxKey.showArgueMsg, defaultValue: true);

  static bool get reverseFromFirst =>
      _setting.get(SettingBoxKey.reverseFromFirst, defaultValue: true);

  static int get subtitlePaddingH =>
      _setting.get(SettingBoxKey.subtitlePaddingH, defaultValue: 24);

  static int get subtitlePaddingB =>
      _setting.get(SettingBoxKey.subtitlePaddingB, defaultValue: 24);

  static double get subtitleBgOpacity =>
      _setting.get(SettingBoxKey.subtitleBgOpacity, defaultValue: 0.67);

  static double get subtitleStrokeWidth =>
      _setting.get(SettingBoxKey.subtitleStrokeWidth, defaultValue: 2.0);

  static int get subtitleFontWeight =>
      _setting.get(SettingBoxKey.subtitleFontWeight, defaultValue: 5);

  // 副字幕默认小一号(80%/全屏120%),其余默认同主字幕
  static double get subtitleSecondaryFontScale =>
      _setting.get(SettingBoxKey.subtitleSecondaryFontScale, defaultValue: 0.8);

  static double get subtitleSecondaryFontScaleFS => _setting.get(
    SettingBoxKey.subtitleSecondaryFontScaleFS,
    defaultValue: 1.1,
  );

  static double get subtitleSecondaryBgOpacity => _setting.get(
    SettingBoxKey.subtitleSecondaryBgOpacity,
    defaultValue: 0.67,
  );

  static double get subtitleSecondaryStrokeWidth => _setting.get(
    SettingBoxKey.subtitleSecondaryStrokeWidth,
    defaultValue: 2.0,
  );

  static int get subtitleSecondaryFontWeight =>
      _setting.get(SettingBoxKey.subtitleSecondaryFontWeight, defaultValue: 5);

  static double get subtitleSecondarySpacing => _setting.get(
    SettingBoxKey.subtitleSecondarySpacing,
    defaultValue: 4.0,
  );

  static bool get badCertificateCallback =>
      _setting.get(SettingBoxKey.badCertificateCallback, defaultValue: false);

  static bool get continuePlayingPart =>
      _setting.get(SettingBoxKey.continuePlayingPart, defaultValue: true);

  static bool get cdnSpeedTest =>
      _setting.get(SettingBoxKey.cdnSpeedTest, defaultValue: true);

  static bool get autoUpdate =>
      _setting.get(SettingBoxKey.autoUpdate, defaultValue: true);

  static bool get preReleaseUpdate =>
      _setting.get(SettingBoxKey.preReleaseUpdate, defaultValue: false);

  static String get skipVersion =>
      _setting.get(SettingBoxKey.skipVersion, defaultValue: '');

  static bool get horizontalPreview =>
      _setting.get(SettingBoxKey.horizontalPreview, defaultValue: false);

  static bool get openInBrowser =>
      _setting.get(SettingBoxKey.openInBrowser, defaultValue: false);

  static bool get savedRcmdTip =>
      _setting.get(SettingBoxKey.savedRcmdTip, defaultValue: true);

  static bool get showVipDanmaku =>
      _setting.get(SettingBoxKey.showVipDanmaku, defaultValue: true);

  static bool get mergeDanmaku =>
      _setting.get(SettingBoxKey.mergeDanmaku, defaultValue: false);

  static int get mergeDanmakuWindowSeconds =>
      _setting.get(SettingBoxKey.mergeDanmakuWindowSeconds, defaultValue: 20);

  static int get mergeDanmakuMaxDistance =>
      _setting.get(SettingBoxKey.mergeDanmakuMaxDistance, defaultValue: 5);

  static int get mergeDanmakuMaxCosine =>
      _setting.get(SettingBoxKey.mergeDanmakuMaxCosine, defaultValue: 45);

  static int get mergeDanmakuRepresentativePercent => _setting.get(
    SettingBoxKey.mergeDanmakuRepresentativePercent,
    defaultValue: 20,
  );

  static bool get mergeDanmakuUsePinyin =>
      _setting.get(SettingBoxKey.mergeDanmakuUsePinyin, defaultValue: true);

  static bool get mergeDanmakuCrossMode =>
      _setting.get(SettingBoxKey.mergeDanmakuCrossMode, defaultValue: false);

  static bool get mergeDanmakuSkipSubtitle =>
      _setting.get(SettingBoxKey.mergeDanmakuSkipSubtitle, defaultValue: true);

  static bool get mergeDanmakuSkipAdvanced =>
      _setting.get(SettingBoxKey.mergeDanmakuSkipAdvanced, defaultValue: true);

  static bool get mergeDanmakuSkipBottom =>
      _setting.get(SettingBoxKey.mergeDanmakuSkipBottom, defaultValue: false);

  static int get mergeDanmakuMarkPosition =>
      _setting.get(SettingBoxKey.mergeDanmakuMarkPosition, defaultValue: 2);

  static int get mergeDanmakuMarkThreshold =>
      _setting.get(SettingBoxKey.mergeDanmakuMarkThreshold, defaultValue: 1);

  static bool get danmakuEnlarge =>
      _setting.get(SettingBoxKey.danmakuEnlarge, defaultValue: true);

  static int get danmakuEnlargeThreshold =>
      _setting.get(SettingBoxKey.danmakuEnlargeThreshold, defaultValue: 7);

  static int get danmakuEnlargeLogBase =>
      _setting.get(SettingBoxKey.danmakuEnlargeLogBase, defaultValue: 7);

  static bool get showHotRcmd =>
      _setting.get(SettingBoxKey.showHotRcmd, defaultValue: false);

  static bool get mixWithOthers =>
      _setting.get(SettingBoxKey.mixWithOthers, defaultValue: false);

  static String get audioNormalization =>
      _setting.get(SettingBoxKey.audioNormalization, defaultValue: '0');

  static String get fallbackNormalization =>
      _setting.get(SettingBoxKey.fallbackNormalization, defaultValue: '0');

  static SuperResolutionType get superResolutionType {
    SuperResolutionType? superResolutionType;
    final index = _setting.get(SettingBoxKey.superResolutionType);
    if (index != null) {
      superResolutionType = SuperResolutionType.values.elementAtOrNull(index);
    }
    return superResolutionType ?? SuperResolutionType.disable;
  }

  static bool get preInitPlayer =>
      _setting.get(SettingBoxKey.preInitPlayer, defaultValue: false);

  static bool get mainTabBarView =>
      _setting.get(SettingBoxKey.mainTabBarView, defaultValue: false);

  static bool get searchSuggestion =>
      _setting.get(SettingBoxKey.searchSuggestion, defaultValue: true);

  static bool get showDecorate =>
      _setting.get(SettingBoxKey.showDecorate, defaultValue: true);

  static bool get showMedal =>
      _setting.get(SettingBoxKey.showMedal, defaultValue: true);

  static bool get showRcmdReason =>
      _setting.get(SettingBoxKey.showRcmdReason, defaultValue: true);

  static bool get enableLivePhoto =>
      _setting.get(SettingBoxKey.enableLivePhoto, defaultValue: true);

  static bool get showSeekPreview =>
      _setting.get(SettingBoxKey.showSeekPreview, defaultValue: true);

  static DmChartSource get dmChartSource {
    final index = _setting.get(SettingBoxKey.dmChartSource);
    if (index is int) {
      return DmChartSource.values.elementAtOrNull(index) ??
          DmChartSource.disabled;
    }
    // Backward compatibility with the old boolean switch.
    return showDmChart ? DmChartSource.officialFirst : DmChartSource.disabled;
  }

  static bool get showDmChart =>
      _setting.get(SettingBoxKey.showDmChart, defaultValue: false);

  static bool get enableCommAntifraud =>
      _setting.get(SettingBoxKey.enableCommAntifraud, defaultValue: false);

  static bool get biliSendCommAntifraud =>
      Platform.isAndroid &&
      _setting.get(SettingBoxKey.biliSendCommAntifraud, defaultValue: false);

  static bool get enableCreateDynAntifraud =>
      _setting.get(SettingBoxKey.enableCreateDynAntifraud, defaultValue: false);

  static bool get coinWithLike =>
      _setting.get(SettingBoxKey.coinWithLike, defaultValue: false);

  static bool get isPureBlackTheme =>
      _setting.get(SettingBoxKey.isPureBlackTheme, defaultValue: false);

  static bool get antiGoodsDyn =>
      _setting.get(SettingBoxKey.antiGoodsDyn, defaultValue: false);

  static bool get removeBlockedDyn =>
      _setting.get(SettingBoxKey.removeBlockedDyn, defaultValue: false);

  static bool get removeOnlyFansVideoDyn =>
      _setting.get(SettingBoxKey.removeOnlyFansVideoDyn, defaultValue: false);

  static bool get removeDynVideoDyn =>
      _setting.get(SettingBoxKey.removeDynVideoDyn, defaultValue: false);

  static bool get antiGoodsReply =>
      _setting.get(SettingBoxKey.antiGoodsReply, defaultValue: false);

  static int get replyMinLevel =>
      _setting.get(SettingBoxKey.replyMinLevel, defaultValue: 0);

  static set replyMinLevel(int v) =>
      _setting.put(SettingBoxKey.replyMinLevel, v);

  static bool get keepUpOwnerReply =>
      _setting.get(SettingBoxKey.keepUpOwnerReply, defaultValue: true);

  static bool get keepUpTopReply =>
      _setting.get(SettingBoxKey.keepUpTopReply, defaultValue: true);

  static bool get keepUpLikeReply =>
      _setting.get(SettingBoxKey.keepUpLikeReply, defaultValue: false);

  static bool get keepUpReplyReply =>
      _setting.get(SettingBoxKey.keepUpReplyReply, defaultValue: false);

  static bool get expandDynLivePanel =>
      _setting.get(SettingBoxKey.expandDynLivePanel, defaultValue: false);

  static bool get slideDismissReplyPage => _setting.get(
    SettingBoxKey.slideDismissReplyPage,
    defaultValue: Platform.isIOS,
  );

  static bool get showFSActionItem =>
      _setting.get(SettingBoxKey.showFSActionItem, defaultValue: true);

  static bool get enableShrinkVideoSize =>
      _setting.get(SettingBoxKey.enableShrinkVideoSize, defaultValue: true);

  static bool get enablePinchRotate =>
      _setting.get(SettingBoxKey.enablePinchRotate, defaultValue: true);

  static bool get showDynActionBar =>
      _setting.get(SettingBoxKey.showDynActionBar, defaultValue: true);

  static bool get darkVideoPage =>
      _setting.get(SettingBoxKey.darkVideoPage, defaultValue: false);

  static bool get enableSlideVolumeBrightness => _setting.get(
    SettingBoxKey.enableSlideVolumeBrightness,
    defaultValue: true,
  );

  static bool get enableSlideFS =>
      _setting.get(SettingBoxKey.enableSlideFS, defaultValue: true);

  static int get retryCount =>
      _setting.get(SettingBoxKey.retryCount, defaultValue: 2);

  static int get retryDelay =>
      _setting.get(SettingBoxKey.retryDelay, defaultValue: 500);

  static int get liveQuality => _setting.get(
    SettingBoxKey.liveQuality,
    defaultValue: LiveQuality.origin.code,
  );

  static int get liveQualityCellular => _setting.get(
    SettingBoxKey.liveQualityCellular,
    defaultValue: LiveQuality.superHD.code,
  );

  static FontWeight get appFontWeight {
    // TODO: remove next 2 version
    const appFontWeightV1 = 'appFontWeight';
    final int? valV1 = _setting.get(appFontWeightV1);
    if (valV1 != null) {
      _setting.delete(appFontWeightV1);
      if (valV1 == -1) {
        return .normal;
      } else {
        _setting.put(SettingBoxKey.appFontWeightV2, valV1);
        return .values[valV1];
      }
    }

    final int? val = _setting.get(SettingBoxKey.appFontWeightV2);
    if (val == null) {
      return .normal;
    }
    return .values[val];
  }

  static String? get customFontPath =>
      _setting.get(SettingBoxKey.customFontPath);

  static String? get customFontFamily {
    final value = _setting.get(
      SettingBoxKey.customFontFamily,
      defaultValue: '',
    );
    return value is String && value.isNotEmpty ? value : null;
  }

  static String? get customFontName {
    final value = _setting.get(SettingBoxKey.customFontName, defaultValue: '');
    return value is String && value.isNotEmpty ? value : null;
  }

  static DanmakuFontSyncMode get danmakuFontSyncMode =>
      DanmakuFontSyncMode.values[_setting.get(
        SettingBoxKey.danmakuFontSyncMode,
        defaultValue: DanmakuFontSyncMode.global.index,
      )];

  static bool get enableCustomDanmakuFont =>
      _setting.get(SettingBoxKey.enableCustomDanmakuFont, defaultValue: false);

  static String? get customDanmakuFontPath =>
      _setting.get(SettingBoxKey.customDanmakuFontPath);

  static String? get customDanmakuFontFamily {
    final value = _setting.get(
      SettingBoxKey.customDanmakuFontFamily,
      defaultValue: '',
    );
    return value is String && value.isNotEmpty ? value : null;
  }

  static String? get customDanmakuFontName {
    final value = _setting.get(
      SettingBoxKey.customDanmakuFontName,
      defaultValue: '',
    );
    return value is String && value.isNotEmpty ? value : null;
  }

  static bool get enableDragSubtitle =>
      _setting.get(SettingBoxKey.enableDragSubtitle, defaultValue: false);

  static int get fastForBackwardDuration =>
      _setting.get(SettingBoxKey.fastForBackwardDuration, defaultValue: 10);

  static int get doubleTapBackwardDuration => _setting.get(
    SettingBoxKey.doubleTapBackwardDuration,
    defaultValue: fastForBackwardDuration,
  );

  static int get doubleTapForwardDuration => _setting.get(
    SettingBoxKey.doubleTapForwardDuration,
    defaultValue: fastForBackwardDuration,
  );

  static int get doubleTapBackwardZoneRaw => _setting.get(
    SettingBoxKey.doubleTapBackwardZone,
    defaultValue: DoubleTapSeekLayout.defaultBackwardPercent,
  );

  static int get doubleTapForwardZoneRaw => _setting.get(
    SettingBoxKey.doubleTapForwardZone,
    defaultValue: DoubleTapSeekLayout.defaultForwardPercent,
  );

  static int get doubleTapBackwardZone =>
      DoubleTapSeekLayout.clampBackwardPercent(
        doubleTapBackwardZoneRaw,
        forwardPercent: doubleTapForwardZoneRaw,
      );

  static int get doubleTapForwardZone =>
      DoubleTapSeekLayout.clampForwardPercent(
        doubleTapForwardZoneRaw,
        backwardPercent: doubleTapBackwardZone,
      );

  static bool get enableTwoFingerTapPause =>
      _setting.get(SettingBoxKey.enableTwoFingerTapPause, defaultValue: false);

  static bool get recordSearchHistory =>
      _setting.get(SettingBoxKey.recordSearchHistory, defaultValue: true);

  static String get webdavUri =>
      _setting.get(SettingBoxKey.webdavUri, defaultValue: '');

  static String get webdavUsername =>
      _setting.get(SettingBoxKey.webdavUsername, defaultValue: '');

  static String get webdavPassword =>
      _setting.get(SettingBoxKey.webdavPassword, defaultValue: '');

  static String get webdavDirectory =>
      _setting.get(SettingBoxKey.webdavDirectory, defaultValue: '/');

  static bool get showPgcTimeline =>
      _setting.get(SettingBoxKey.showPgcTimeline, defaultValue: true);

  static num get maxCacheSize =>
      _setting.get(SettingBoxKey.maxCacheSize) ?? 1 << 30;

  static bool get optTabletNav =>
      _setting.get(SettingBoxKey.optTabletNav, defaultValue: true);

  static bool get horizontalScreen {
    bool? horizontalScreen = _setting.get(SettingBoxKey.horizontalScreen);
    if (horizontalScreen == null) {
      final isTablet = DeviceUtils.isTablet;
      _setting.put(SettingBoxKey.horizontalScreen, isTablet);
      return isTablet;
    }
    return horizontalScreen;
  }

  static String get banWordForDyn =>
      _setting.get(SettingBoxKey.banWordForDyn, defaultValue: '');

  /// Helper method to parse ban word storage format into regex pattern
  /// Supports both old (pipe-separated) and new (newline-separated) formats
  /// Returns a regex pattern string with proper alternation
  static String parseBanWordToRegex(String stored) {
    if (stored.isEmpty) return '';

    List<String> items;

    // Check if it's the old pipe-separated format (no newlines)
    if (!stored.contains('\n') && stored.contains('|')) {
      // Old format: pipe-separated
      // Heuristic: if it looks like multiple short items, it's old format
      final parts = stored
          .split('|')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      if (parts.length > 1) {
        final hasComplexRegex = parts.any(
          (p) =>
              p.contains('(') ||
              p.contains('[') ||
              p.contains('{') ||
              p.contains('\\') ||
              p.contains('^') ||
              p.contains('\$'),
        );

        if (!hasComplexRegex) {
          // Old format with simple keywords
          items = parts;
        } else {
          // Single complex regex - use as-is
          return stored;
        }
      } else {
        // Single item, keep as-is
        return stored;
      }
    } else {
      // New format: newline-separated
      items = stored
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    if (items.isEmpty) return '';

    // Build regex by joining all patterns with alternation
    return items
        .map((item) {
          // If the item contains '|' and isn't already grouped, wrap it
          if (item.contains('|') && !item.startsWith('(')) {
            return '($item)';
          }
          return item;
        })
        .join('|');
  }

  static bool get enableLog =>
      _setting.get(SettingBoxKey.enableLog, defaultValue: true);

  static bool get disableAudioCDN =>
      _setting.get(SettingBoxKey.disableAudioCDN, defaultValue: false);

  static int get minDurationForRcmd =>
      _setting.get(SettingBoxKey.minDurationForRcmd, defaultValue: 0);

  static int get minPlayForRcmd =>
      _setting.get(SettingBoxKey.minPlayForRcmd, defaultValue: 0);

  static int get minLikeRatioForRecommend =>
      _setting.get(SettingBoxKey.minLikeRatioForRecommend, defaultValue: 0);

  static bool get exemptFilterForFollowed =>
      _setting.get(SettingBoxKey.exemptFilterForFollowed, defaultValue: true);

  static bool get applyFilterToRelatedVideos => _setting.get(
    SettingBoxKey.applyFilterToRelatedVideos,
    defaultValue: true,
  );

  static bool get applyFilterToHotVideos =>
      _setting.get(SettingBoxKey.applyFilterToHotVideos, defaultValue: false);

  static bool get applyFilterToRankVideos =>
      _setting.get(SettingBoxKey.applyFilterToRankVideos, defaultValue: false);

  static bool get applyFilterToSearch => _setting.get(
    SettingBoxKey.applyFilterToSearch,
    defaultValue: false,
  );

  static bool get enableBackgroundPlay =>
      _setting.get(SettingBoxKey.enableBackgroundPlay, defaultValue: true);

  static bool get disableLikeMsg =>
      _setting.get(SettingBoxKey.disableLikeMsg, defaultValue: false);

  static bool get enableWordRe =>
      _setting.get(SettingBoxKey.enableWordRe, defaultValue: false);

  static bool get autoExitFullscreen =>
      _setting.get(SettingBoxKey.enableAutoExit, defaultValue: true);

  static bool get autoPlayEnable =>
      _setting.get(SettingBoxKey.autoPlayEnable, defaultValue: false);

  static bool get pipNoDanmaku =>
      _setting.get(SettingBoxKey.pipNoDanmaku, defaultValue: false);

  static bool get enableVerticalExpand =>
      _setting.get(SettingBoxKey.enableVerticalExpand, defaultValue: false);

  static double get defaultTextScale =>
      _setting.get(SettingBoxKey.defaultTextScale, defaultValue: 1.0);

  static double get uiScale =>
      _setting.get(SettingBoxKey.uiScale, defaultValue: 1.0);

  static bool get dynamicsWaterfallFlow => _setting.get(
    SettingBoxKey.dynamicsWaterfallFlow,
    defaultValue: horizontalScreen,
  );

  static bool get hideTopBar => _setting.get(
    SettingBoxKey.hideTopBar,
    defaultValue: PlatformUtils.isMobile,
  );

  static bool get hideBottomBar => _setting.get(
    SettingBoxKey.hideBottomBar,
    defaultValue: PlatformUtils.isMobile,
  );

  static BarHideType get barHideType =>
      BarHideType.values[_setting.get(
        SettingBoxKey.barHideType,
        defaultValue: BarHideType.sync.index,
      )];

  static bool get enableSearchWord =>
      _setting.get(SettingBoxKey.enableSearchWord, defaultValue: false);

  static bool get useSideBar =>
      _setting.get(SettingBoxKey.useSideBar, defaultValue: false);

  static bool get autoSideBar =>
      _setting.get(SettingBoxKey.autoSideBar, defaultValue: false);

  static double get sideBarThreshold =>
      (_setting.get(SettingBoxKey.sideBarThreshold, defaultValue: 600.0) as num)
          .toDouble();

  static bool get dynamicsShowAllFollowedUp => _setting.get(
    SettingBoxKey.dynamicsShowAllFollowedUp,
    defaultValue: false,
  );

  static bool get dynamicsShowSelfUp =>
      _setting.get(SettingBoxKey.dynamicsShowSelfUp, defaultValue: true);

  static bool get enableShowDanmaku =>
      _setting.get(SettingBoxKey.enableShowDanmaku, defaultValue: true);

  static bool get enableShowLiveDanmaku =>
      _setting.get(SettingBoxKey.enableShowLiveDanmaku, defaultValue: true);

  static bool get enableDanmakuMask =>
      _setting.get(SettingBoxKey.enableDanmakuMask, defaultValue: false);

  static bool get enableQuickFav =>
      _setting.get(SettingBoxKey.enableQuickFav, defaultValue: false);

  static bool get p1080 =>
      _setting.get(SettingBoxKey.p1080, defaultValue: true);

  static int get customColor =>
      _setting.get(SettingBoxKey.customColor, defaultValue: 0);

  static bool get dynamicColor =>
      !Platform.isIOS &&
      _setting.get(SettingBoxKey.dynamicColor, defaultValue: true);

  static bool get enableSystemProxy =>
      _setting.get(SettingBoxKey.enableSystemProxy, defaultValue: false);

  static bool get enableHttp2 =>
      _setting.get(SettingBoxKey.enableHttp2, defaultValue: false);

  static ReplySortType get replySortType =>
      ReplySortType.values[_setting.get(
        SettingBoxKey.replySortType,
        defaultValue: ReplySortType.hot.index,
      )];

  static ReplySortType get reply2SortType =>
      ReplySortType.values[_setting.get(
        SettingBoxKey.reply2SortType,
        defaultValue: ReplySortType.time.index,
      )];

  static DynamicBadgeMode get dynamicBadgeMode =>
      DynamicBadgeMode.values[_setting.get(
        SettingBoxKey.dynamicBadgeMode,
        defaultValue: DynamicBadgeMode.number.index,
      )];

  static bool get enableMYBar =>
      _setting.get(SettingBoxKey.enableMYBar, defaultValue: true);

  static bool get enableGradientBg =>
      _setting.get(SettingBoxKey.enableGradientBg, defaultValue: false);

  static Transition get pageTransition =>
      Transition.values[_setting.get(
        SettingBoxKey.pageTransition,
        defaultValue: Transition.native.index,
      )];

  static bool get enableQuickDouble =>
      _setting.get(SettingBoxKey.enableQuickDouble, defaultValue: true);

  static bool get fullScreenGestureReverse =>
      _setting.get(SettingBoxKey.fullScreenGestureReverse, defaultValue: false);

  static bool get autoPiP =>
      _setting.get(SettingBoxKey.autoPiP, defaultValue: false);

  static bool get enableInAppPip =>
      _setting.get(SettingBoxKey.enableInAppPip, defaultValue: true);

  static bool get enableInAppPipToSystemPip =>
      _setting.get(SettingBoxKey.enableInAppPipToSystemPip, defaultValue: true);

  static bool get enableSponsorBlock =>
      _setting.get(SettingBoxKey.enableSponsorBlock, defaultValue: false);

  static bool get enableHA =>
      _setting.get(SettingBoxKey.enableHA, defaultValue: true);

  static Set<int> get danmakuBlockType => Set<int>.from(
    _setting.get(SettingBoxKey.danmakuBlockType, defaultValue: const <int>{}),
  );

  static int get danmakuWeight =>
      _setting.get(SettingBoxKey.danmakuWeight, defaultValue: 0);

  static double get danmakuShowArea =>
      _setting.get(SettingBoxKey.danmakuShowArea, defaultValue: 0.5);

  static double get danmakuOpacity =>
      _setting.get(SettingBoxKey.danmakuOpacity, defaultValue: 1.0);

  static double get danmakuFontScale => _setting.get(
    SettingBoxKey.danmakuFontScale,
    defaultValue: PlatformUtils.isMobile ? 1.0 : 1.4,
  );

  static double get danmakuDuration =>
      _setting.get(SettingBoxKey.danmakuDuration, defaultValue: 7.0);

  static double get danmakuStaticDuration =>
      _setting.get(SettingBoxKey.danmakuStaticDuration, defaultValue: 4.0);

  static double get danmakuStrokeWidth => _setting.get(
    SettingBoxKey.danmakuStrokeWidth,
    defaultValue: PlatformUtils.isMobile ? 1.5 : 2.5,
  );

  static int get danmakuFontWeight => _setting.get(
    SettingBoxKey.danmakuFontWeight,
    defaultValue: PlatformUtils.isMobile ? 5 : 6,
  );

  static bool get enableLongShowControl =>
      _setting.get(SettingBoxKey.enableLongShowControl, defaultValue: false);

  static bool get showControlsOnManualEpisodeChange => _setting.get(
    SettingBoxKey.showControlsOnManualEpisodeChange,
    defaultValue: false,
  );

  static double get bufferSize =>
      _setting.get(SettingBoxKey.bufferSize, defaultValue: 4.0);

  static double get bufferSec =>
      _setting.get(SettingBoxKey.bufferSec, defaultValue: 16.0);

  static Map<String, String> initBuffer([double playbackSpeed = 1.0]) {
    final bufSec = Pref.bufferSec * playbackSpeed;
    final bufSiz = (Pref.bufferSize * 0x100000).toStringAsFixed(0);
    return {
      'cache': 'yes',
      'cache-secs': bufSec.toStringAsFixed(3),
      'demuxer-hysteresis-secs': (bufSec / 1.5).toStringAsFixed(3),
      'demuxer-max-bytes': bufSiz,
      'demuxer-max-back-bytes': bufSiz,
    };
  }

  static Map<String, String> initLiveBuffer() {
    return {
      'cache': 'yes',
      'demuxer-max-bytes': (Pref.bufferSize * 0x200000).toStringAsFixed(0),
      'demuxer-max-back-bytes': '0',
    };
  }

  static String get audioOutput => _setting.get(
    SettingBoxKey.audioOutput,
    defaultValue: AudioOutput.defaultValue,
  );

  static bool get enableAi =>
      _setting.get(SettingBoxKey.enableAi, defaultValue: false);

  static bool get enablePredictiveBack =>
      _setting.get(SettingBoxKey.enablePredictiveBack, defaultValue: true);

  static bool get enableOnlineTotal =>
      _setting.get(SettingBoxKey.enableOnlineTotal, defaultValue: false);

  static bool get enableDmCount =>
      _setting.get(SettingBoxKey.enableDmCount, defaultValue: false);

  static bool get autoEnterFullScreen =>
      _setting.get(SettingBoxKey.enableAutoEnter, defaultValue: false);

  static bool get enableAutoLongPressSpeed =>
      _setting.get(SettingBoxKey.enableAutoLongPressSpeed, defaultValue: false);

  static double get playSpeedDefault =>
      _video.get(VideoBoxKey.playSpeedDefault, defaultValue: 1.0);

  static double get longPressSpeedDefault =>
      _video.get(VideoBoxKey.longPressSpeedDefault, defaultValue: 3.0);

  static Map<int, AuthorPlaySpeed> get authorPlaySpeeds =>
      decodeAuthorPlaySpeeds(_video.get(VideoBoxKey.authorPlaySpeeds));

  static set authorPlaySpeeds(Map<int, AuthorPlaySpeed> value) {
    _video.put(VideoBoxKey.authorPlaySpeeds, encodeAuthorPlaySpeeds(value));
  }

  static double playSpeedForAuthor(int? mid) {
    return resolvePlaySpeedForAuthor(
      mid: mid,
      authorSpeeds: authorPlaySpeeds,
      defaultSpeed: playSpeedDefault,
    );
  }

  static void upsertAuthorPlaySpeed(AuthorPlaySpeed entry) {
    final map = Map<int, AuthorPlaySpeed>.from(authorPlaySpeeds);
    map[entry.mid] = entry;
    authorPlaySpeeds = map;
  }

  static void removeAuthorPlaySpeed(int mid) {
    final map = Map<int, AuthorPlaySpeed>.from(authorPlaySpeeds);
    if (map.remove(mid) != null) {
      authorPlaySpeeds = map;
    }
  }

  static bool get defaultShowComment =>
      _setting.get(SettingBoxKey.defaultShowComment, defaultValue: false);

  static bool get swapReplyLikeDislike =>
      _setting.get(SettingBoxKey.swapReplyLikeDislike, defaultValue: false);

  static bool get remarkReplaceName =>
      _setting.get(SettingBoxKey.remarkReplaceName, defaultValue: false);

  static bool get enableTrending =>
      _setting.get(SettingBoxKey.enableHotKey, defaultValue: true);

  static bool get enableSearchRcmd =>
      _setting.get(SettingBoxKey.enableSearchRcmd, defaultValue: true);

  static bool get enableSaveLastData =>
      _setting.get(SettingBoxKey.enableSaveLastData, defaultValue: true);

  static double get defaultToastOp =>
      _setting.get(SettingBoxKey.defaultToastOp, defaultValue: 1.0);

  static PlayRepeat get playRepeat =>
      PlayRepeat.values[_video.get(
        VideoBoxKey.playRepeat,
        defaultValue: PlayRepeat.pause.index,
      )];

  static int get cacheVideoFit =>
      _video.get(VideoBoxKey.cacheVideoFit, defaultValue: 1);

  static bool get continuePlayInBackground =>
      _setting.get(SettingBoxKey.continuePlayInBackground, defaultValue: false);

  static bool get autoAudioOnlyInBackground => _setting.get(
    SettingBoxKey.autoAudioOnlyInBackground,
    defaultValue: false,
  );

  static bool get directExitOnBack =>
      _setting.get(SettingBoxKey.directExitOnBack, defaultValue: false);

  static bool get historyPause =>
      _localCache.get(LocalCacheKey.historyPause, defaultValue: false);

  static int? get quickFavId => _setting.get(SettingBoxKey.quickFavId);

  static bool get tempPlayerConf =>
      _setting.get(SettingBoxKey.tempPlayerConf, defaultValue: false);

  static Color? get reduceLuxColor {
    final int? color = _setting.get(SettingBoxKey.reduceLuxColor);
    if (color != null && color != 0xFFFFFFFF) {
      return Color(color);
    }
    return null;
  }

  static bool get showFsScreenshotBtn =>
      _setting.get(SettingBoxKey.showFsScreenshotBtn, defaultValue: true);

  static bool get showFsLockBtn =>
      _setting.get(SettingBoxKey.showFsLockBtn, defaultValue: true);

  static bool get showFsLockBtnRight =>
      _setting.get(SettingBoxKey.showFsLockBtnRight, defaultValue: false);

  static bool get silentDownImg =>
      _setting.get(SettingBoxKey.silentDownImg, defaultValue: false);

  static String get buvid {
    String? buvid = _localCache.get(LocalCacheKey.buvid);
    if (buvid == null) {
      buvid = LoginUtils.generateBuvid();
      _localCache.put(LocalCacheKey.buvid, buvid);
    }
    return buvid;
  }

  static bool get showMemberShop =>
      _setting.get(SettingBoxKey.showMemberShop, defaultValue: false);

  static SuperChatType get superChatType =>
      SuperChatType.values[_setting.get(
        SettingBoxKey.superChatType,
        defaultValue: SuperChatType.valid.index,
      )];

  static SuperChatTimeType get superChatTimeType =>
      SuperChatTimeType.values[_setting.get(
        SettingBoxKey.superChatTimeType,
        defaultValue: SuperChatTimeType.whenPersist.index,
      )];

  static double get fullScreenSCWidth => _setting.get(
    SettingBoxKey.fullScreenSCWidth,
    defaultValue: kFullScreenSCWidth,
  );

  static bool get minimizeOnExit =>
      _setting.get(SettingBoxKey.minimizeOnExit, defaultValue: true);

  static Size get windowSize {
    final List<double>? size = (_setting.get(SettingBoxKey.windowSize) as List?)
        ?.fromCast<double>();
    return size == null ? const Size(1180.0, 720.0) : Size(size[0], size[1]);
  }

  static List<double>? get windowPosition =>
      (_setting.get(SettingBoxKey.windowPosition) as List?)?.fromCast<double>();

  static bool get isWindowMaximized =>
      _setting.get(SettingBoxKey.isWindowMaximized, defaultValue: false);

  static bool get keyboardControl =>
      _setting.get(SettingBoxKey.keyboardControl, defaultValue: true);

  static bool get pauseOnMinimize =>
      _setting.get(SettingBoxKey.pauseOnMinimize, defaultValue: false);

  static bool get showWindowTitleBar =>
      _setting.get(SettingBoxKey.showWindowTitleBar, defaultValue: true);

  static double get desktopVolume =>
      _setting.get(SettingBoxKey.desktopVolume, defaultValue: 1.0);

  static SkipType get pgcSkipType =>
      SkipType.values[_setting.get(SettingBoxKey.pgcSkipType) ??
          SkipType.skipOnce.index];

  static PlayRepeat get audioPlayMode =>
      PlayRepeat.values[_setting.get(SettingBoxKey.audioPlayMode) ??
          PlayRepeat.listOrder.index];

  static bool get enablePlayAll =>
      _setting.get(SettingBoxKey.enablePlayAll, defaultValue: true);

  static bool get enableTapDm =>
      _setting.get(SettingBoxKey.enableTapDm, defaultValue: true);

  static bool get showTrayIcon =>
      _setting.get(SettingBoxKey.showTrayIcon, defaultValue: true);

  static bool get setSystemBrightness =>
      _setting.get(SettingBoxKey.setSystemBrightness, defaultValue: false);

  static bool get enableAppVolume =>
      _setting.get(SettingBoxKey.enableAppVolume, defaultValue: false);

  static double get appVolume =>
      _setting.get(SettingBoxKey.appVolume, defaultValue: 1.0);

  static set appVolume(double value) =>
      _setting.put(SettingBoxKey.appVolume, value.toPrecision(3));

  static bool get enableVolumeBoost =>
      _setting.get(SettingBoxKey.enableVolumeBoost, defaultValue: false);

  static String? get downloadPath => _setting.get(SettingBoxKey.downloadPath);

  static String? get imageSavePath => _setting.get(SettingBoxKey.imageSavePath);

  static String? get liveCdnUrl => _setting.get(SettingBoxKey.liveCdnUrl);

  static bool get showBatteryLevel => _setting.get(
    SettingBoxKey.showBatteryLevel,
    defaultValue: PlatformUtils.isMobile,
  );

  static FollowOrderType get followOrderType =>
      FollowOrderType.values[_setting.get(
        SettingBoxKey.followOrderType,
        defaultValue: FollowOrderType.def.index,
      )];

  static bool get enableImgMenu =>
      _setting.get(SettingBoxKey.enableImgMenu, defaultValue: false);

  static bool get showDynDispute =>
      _setting.get(SettingBoxKey.showDynDispute, defaultValue: false);

  static double get touchSlopH => _setting.get(
    SettingBoxKey.touchSlopH,
    defaultValue: deviceTouchSlop + 6.0,
  );

  static bool get saveReply =>
      _setting.get(SettingBoxKey.saveReply, defaultValue: true);

  static bool get floatingNavBar =>
      _setting.get(SettingBoxKey.floatingNavBar, defaultValue: false);

  static bool get enableCurrentPageRefresh => _setting.get(
    SettingBoxKey.enableCurrentPageRefresh,
    defaultValue: false,
  );

  static bool get removeSafeArea =>
      _setting.get(SettingBoxKey.removeSafeArea, defaultValue: false);

  // AI 视频分析设置
  static bool get enableAiChat =>
      _setting.get(SettingBoxKey.enableAiChat, defaultValue: false);

  static set enableAiChat(bool value) =>
      _setting.put(SettingBoxKey.enableAiChat, value);
  static String get aiApiUrl =>
      _setting.get(SettingBoxKey.aiApiUrl, defaultValue: '');

  static set aiApiUrl(String value) =>
      _setting.put(SettingBoxKey.aiApiUrl, value);

  static String get aiApiKey =>
      _setting.get(SettingBoxKey.aiApiKey, defaultValue: '');

  static set aiApiKey(String value) =>
      _setting.put(SettingBoxKey.aiApiKey, value);

  static String get aiModel =>
      _setting.get(SettingBoxKey.aiModel, defaultValue: '');

  static set aiModel(String value) =>
      _setting.put(SettingBoxKey.aiModel, value);

  static List<String> get aiModelListCache {
    final raw = _setting.get(SettingBoxKey.aiModelListCache, defaultValue: '');
    if (raw.isEmpty) return [];
    try {
      return (jsonDecode(raw) as List).cast<String>();
    } catch (_) {
      return [];
    }
  }

  static set aiModelListCache(List<String> value) =>
      _setting.put(SettingBoxKey.aiModelListCache, jsonEncode(value));

  static int get aiModelListCacheTime =>
      _setting.get(SettingBoxKey.aiModelListCacheTime, defaultValue: 0);

  static set aiModelListCacheTime(int value) =>
      _setting.put(SettingBoxKey.aiModelListCacheTime, value);

  static String get aiPromptTemplates =>
      _setting.get(SettingBoxKey.aiPromptTemplates, defaultValue: '');

  static set aiPromptTemplates(String value) =>
      _setting.put(SettingBoxKey.aiPromptTemplates, value);

  static bool get aiAutoScroll =>
      _setting.get(SettingBoxKey.aiAutoScroll, defaultValue: true);

  static set aiAutoScroll(bool value) =>
      _setting.put(SettingBoxKey.aiAutoScroll, value);

  /// 思考强度（reasoning_effort）：未干预服务商默认行为时为 'default'。
  static String get aiReasoningEffort {
    final value =
        _setting.get(SettingBoxKey.aiReasoningEffort, defaultValue: 'default');
    return value == 'auto' ? 'default' : value;
  }

  static set aiReasoningEffort(String value) =>
      _setting.put(SettingBoxKey.aiReasoningEffort, value);

  static int get angleDegrees =>
      _setting.get(SettingBoxKey.angleDegrees, defaultValue: 30);

  static double get playerVolume => // mobile
      _setting.get(SettingBoxKey.playerVolume, defaultValue: 100.0);

  static double get maxVolume => // desktop
      _setting.get(SettingBoxKey.maxVolume, defaultValue: 2.0);

  static int _videoPictureParameter(String key) {
    final value = _setting.get(key, defaultValue: 0);
    final number = value is num ? value.round() : int.tryParse('$value') ?? 0;
    return number.clamp(-100, 100).toInt();
  }

  static int get videoBrightness =>
      _videoPictureParameter(SettingBoxKey.videoBrightness);

  static int get videoContrast =>
      _videoPictureParameter(SettingBoxKey.videoContrast);

  static int get videoSaturation =>
      _videoPictureParameter(SettingBoxKey.videoSaturation);

  static int get videoGamma => _videoPictureParameter(SettingBoxKey.videoGamma);

  static int get videoHue => _videoPictureParameter(SettingBoxKey.videoHue);

  static int get audioDelayMs {
    final value = _setting.get(SettingBoxKey.audioDelayMs, defaultValue: 0);
    final number = value is num ? value.round() : int.tryParse('$value') ?? 0;
    return number.clamp(-1000, 1000).toInt();
  }

  static List? get liveStream => _setting.get(SettingBoxKey.liveStream);

  static String? get appFont => _setting.get(SettingBoxKey.appFont);

  static bool get enableDocProvider =>
      _setting.get(SettingBoxKey.enableDocProvider, defaultValue: false);

  static Map<String, String> get customAppFont => Map<String, String>.from(
    _setting.get(
      SettingBoxKey.customAppFont,
      defaultValue: const <String, String>{},
    ),
  );

  /// 已导入字体的显示名：字体族名 → 从字体文件解析出的名字
  static Map<String, String> get customAppFontNames => Map<String, String>.from(
    _setting.get(
      SettingBoxKey.customAppFontNames,
      defaultValue: const <String, String>{},
    ),
  );

  static bool get enableEmoteTooltip =>
      _setting.get(SettingBoxKey.enableEmoteTooltip, defaultValue: false);
}
