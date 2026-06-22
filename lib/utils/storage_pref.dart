import 'dart:io' show Platform;
import 'dart:math' as math;

import 'package:PiliPlus/common/widgets/gesture/horizontal_drag_gesture_recognizer.dart'
    show deviceTouchSlop;
import 'package:PiliPlus/common/widgets/pair.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/models/common/dynamic/dynamic_badge_mode.dart';
import 'package:PiliPlus/models/common/dynamic/up_panel_position.dart';
import 'package:PiliPlus/models/common/follow_order_type.dart';
import 'package:PiliPlus/models/common/msg/msg_unread_type.dart';
import 'package:PiliPlus/models/common/sponsor_block/segment_type.dart';
import 'package:PiliPlus/models/common/sponsor_block/skip_type.dart';
import 'package:PiliPlus/models/common/theme/theme_type.dart';
import 'package:PiliPlus/models/common/video/audio_quality.dart';
import 'package:PiliPlus/models/common/video/cdn_type.dart';
import 'package:PiliPlus/models/common/video/live_quality.dart';
import 'package:PiliPlus/models/common/video/video_decode_type.dart';
import 'package:PiliPlus/models/common/video/video_quality.dart';
import 'package:PiliPlus/models/user/danmaku_rule.dart';
import 'package:PiliPlus/models/user/info.dart';
import 'package:PiliPlus/plugin/pl_player/models/audio_output_type.dart';
import 'package:PiliPlus/plugin/pl_player/models/hwdec_type.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_repeat.dart';
import 'package:PiliPlus/utils/device_utils.dart';
import 'package:PiliPlus/utils/extension/iterable_ext.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/login_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:crypto/crypto.dart';
import 'package:flex_seed_scheme/flex_seed_scheme.dart' show FlexSchemeVariant;
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:hive_ce/hive.dart';

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

  static Set<int> get blackMids =>
      _localCache.get(LocalCacheKey.blackMids, defaultValue: <int>{});

  static set blackMids(Set<int> blackMidsSet) =>
      _localCache.put(LocalCacheKey.blackMids, blackMidsSet);

  static RuleFilter get danmakuFilterRule => _localCache.get(
    LocalCacheKey.danmakuFilterRules,
    defaultValue: RuleFilter.empty(),
  );

  static void setBlackMid(int mid) => _localCache.put(
    LocalCacheKey.blackMids,
    GlobalData.blackMids..add(mid),
  );

  static void removeBlackMid(int mid) => _localCache.put(
    LocalCacheKey.blackMids,
    GlobalData.blackMids..remove(mid),
  );

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
        [0.5, 100.0, 2.2 * math.sqrt(50)], // [mass, stiffness, damping]
  );

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
          (item) => Pair(
            first: item,
            second: SkipType.values[list[item.index]],
          ),
        )
        .toList();
  }

  static List<Color> get blockColor {
    final list = _setting.get(SettingBoxKey.blockColor) as List?;
    if (list == null || list.length != SegmentType.values.length) {
      return SegmentType.values.map((i) => i.color).toList();
    }
    return SegmentType.values.map(
      (item) {
        final String e = list[item.index];
        final color = e.isNotEmpty ? int.tryParse('FF$e', radix: 16) : null;
        return color != null ? Color(color) : item.color;
      },
    ).toList();
  }

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

  static int get defaultAudioQa => _setting.get(
    SettingBoxKey.defaultAudioQa,
    defaultValue: AudioQuality.hiRes.code,
  );

  static int get defaultAudioQaCellular => _setting.get(
    SettingBoxKey.defaultAudioQaCellular,
    defaultValue: AudioQuality.k192.code,
  );

  static String get defaultDecode => _setting.get(
    SettingBoxKey.defaultDecode,
    defaultValue: VideoDecodeFormatType.AVC.codes.first,
  );

  static String get secondDecode => _setting.get(
    SettingBoxKey.secondDecode,
    defaultValue: VideoDecodeFormatType.AV1.codes.first,
  );

  static String get hardwareDecoding => _setting.get(
    SettingBoxKey.hardwareDecoding,
    defaultValue: Platform.isAndroid
        ? HwDecType.androidDefault
        : HwDecType.auto.hwdec,
  );

  static String get videoSync =>
      _setting.get(SettingBoxKey.videoSync, defaultValue: 'display-resample');

  static CDNService get defaultCDNService {
    if (_setting.get(SettingBoxKey.CDNService) case final String cdnName) {
      return CDNService.values.byName(cdnName);
    }
    return CDNService.backupUrl;
  }

  static double get refreshDragPercentage =>
      _setting.get(SettingBoxKey.refreshDragPercentage, defaultValue: 0.25);

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

  static String get blockServer => _setting.get(
    SettingBoxKey.blockServer,
    defaultValue: HttpString.sponsorBlockBaseUrl,
  );

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

  static bool get horizontalSeasonPanel => _setting.get(
    SettingBoxKey.horizontalSeasonPanel,
    defaultValue: horizontalScreen,
  );

  static bool get horizontalMemberPage => _setting.get(
    SettingBoxKey.horizontalMemberPage,
    defaultValue: horizontalScreen,
  );

  static int get defaultPicQa =>
      _setting.get(SettingBoxKey.defaultPicQa, defaultValue: 10);

  static double get danmakuLineHeight =>
      _setting.get(SettingBoxKey.danmakuLineHeight, defaultValue: 1.6);

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

  static bool get badCertificateCallback =>
      _setting.get(SettingBoxKey.badCertificateCallback, defaultValue: false);

  static bool get cdnSpeedTest =>
      _setting.get(SettingBoxKey.cdnSpeedTest, defaultValue: true);

  static bool get horizontalPreview =>
      _setting.get(SettingBoxKey.horizontalPreview, defaultValue: false);

  static bool get coinWithLike =>
      _setting.get(SettingBoxKey.coinWithLike, defaultValue: false);

  static bool get slideDismissReplyPage => _setting.get(
    SettingBoxKey.slideDismissReplyPage,
    defaultValue: Platform.isIOS,
  );

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

  static int get fastForBackwardDuration =>
      _setting.get(SettingBoxKey.fastForBackwardDuration, defaultValue: 10);

  static bool get showPgcTimeline =>
      _setting.get(SettingBoxKey.showPgcTimeline, defaultValue: true);

  static num get maxCacheSize =>
      _setting.get(SettingBoxKey.maxCacheSize) ?? math.pow(1024, 3);

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

  static bool get enableLog =>
      _setting.get(SettingBoxKey.enableLog, defaultValue: true);

  static bool get dynamicsWaterfallFlow => _setting.get(
    SettingBoxKey.dynamicsWaterfallFlow,
    defaultValue: horizontalScreen,
  );

  static bool get enableShowDanmaku =>
      _setting.get(SettingBoxKey.enableShowDanmaku, defaultValue: true);

  static bool get enableShowLiveDanmaku =>
      _setting.get(SettingBoxKey.enableShowLiveDanmaku, defaultValue: true);

  static bool get enableQuickFav =>
      _setting.get(SettingBoxKey.enableQuickFav, defaultValue: false);

  static int get customColor =>
      _setting.get(SettingBoxKey.customColor, defaultValue: 0);

  static bool get dynamicColor =>
      !Platform.isIOS &&
      _setting.get(SettingBoxKey.dynamicColor, defaultValue: true);

  static bool get enableHttp2 =>
      _setting.get(SettingBoxKey.enableHttp2, defaultValue: false);

  static DynamicBadgeMode get dynamicBadgeMode =>
      DynamicBadgeMode.values[_setting.get(
        SettingBoxKey.dynamicBadgeMode,
        defaultValue: DynamicBadgeMode.number.index,
      )];

  static Transition get pageTransition =>
      Transition.values[_setting.get(
        SettingBoxKey.pageTransition,
        defaultValue: Transition.native.index,
      )];

  static bool get enableSponsorBlock =>
      _setting.get(SettingBoxKey.enableSponsorBlock, defaultValue: false);

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

  static bool get enableOnlineTotal =>
      _setting.get(SettingBoxKey.enableOnlineTotal, defaultValue: false);

  static double get playSpeedDefault =>
      _video.get(VideoBoxKey.playSpeedDefault, defaultValue: 1.0);

  static double get longPressSpeedDefault =>
      _video.get(VideoBoxKey.longPressSpeedDefault, defaultValue: 3.0);

  static PlayRepeat get playRepeat =>
      PlayRepeat.values[_video.get(
        VideoBoxKey.playRepeat,
        defaultValue: PlayRepeat.pause.index,
      )];

  static int get cacheVideoFit =>
      _video.get(VideoBoxKey.cacheVideoFit, defaultValue: 1);

  static bool get continuePlayInBackground =>
      _setting.get(SettingBoxKey.continuePlayInBackground, defaultValue: false);

  static bool get historyPause =>
      _localCache.get(LocalCacheKey.historyPause, defaultValue: false);

  static int? get quickFavId => _setting.get(SettingBoxKey.quickFavId);

  static final String buvid = LoginUtils.generateBuvid();

  static Size get windowSize {
    final List<double>? size = (_setting.get(SettingBoxKey.windowSize) as List?)
        ?.fromCast<double>();
    return size == null ? const Size(1180.0, 720.0) : Size(size[0], size[1]);
  }

  static List<double>? get windowPosition =>
      (_setting.get(SettingBoxKey.windowPosition) as List?)?.fromCast<double>();

  static bool get isWindowMaximized =>
      _setting.get(SettingBoxKey.isWindowMaximized, defaultValue: false);

  static bool get keyboardControl => _setting.get(
    SettingBoxKey.keyboardControl,
    defaultValue: PlatformUtils.isDesktop,
  );

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

  static String? get downloadPath => _setting.get(SettingBoxKey.downloadPath);

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

  static double get touchSlopH => _setting.get(
    SettingBoxKey.touchSlopH,
    defaultValue: deviceTouchSlop + 6.0,
  );

  static int get angleDegrees =>
      _setting.get(SettingBoxKey.angleDegrees, defaultValue: 30);

  static double get playerVolume => // mobile
      _setting.get(SettingBoxKey.playerVolume, defaultValue: 100.0);

  static double get maxVolume => // desktop
      _setting.get(SettingBoxKey.maxVolume, defaultValue: 2.0);

  static List? get liveStream => _setting.get(SettingBoxKey.liveStream);
}
