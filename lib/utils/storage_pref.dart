import 'dart:io';
import 'dart:math' show pow, sqrt;

import 'package:PiliPlus/common/widgets/pair.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/models/common/dynamic/dynamic_badge_mode.dart';
import 'package:PiliPlus/models/common/dynamic/up_panel_position.dart';
import 'package:PiliPlus/models/common/member/tab_type.dart';
import 'package:PiliPlus/models/common/msg/msg_unread_type.dart';
import 'package:PiliPlus/models/common/sponsor_block/segment_type.dart';
import 'package:PiliPlus/models/common/sponsor_block/skip_type.dart';
import 'package:PiliPlus/models/common/super_resolution_type.dart';
import 'package:PiliPlus/models/common/theme/theme_type.dart';
import 'package:PiliPlus/models/common/video/audio_quality.dart';
import 'package:PiliPlus/models/common/video/cdn_type.dart';
import 'package:PiliPlus/models/common/video/live_quality.dart';
import 'package:PiliPlus/models/common/video/subtitle_pref_type.dart';
import 'package:PiliPlus/models/common/video/video_decode_type.dart';
import 'package:PiliPlus/models/common/video/video_quality.dart';
import 'package:PiliPlus/models/user/danmaku_rule.dart';
import 'package:PiliPlus/models/user/info.dart';
import 'package:PiliPlus/plugin/pl_player/models/bottom_progress_behavior.dart';
import 'package:PiliPlus/plugin/pl_player/models/fullscreen_mode.dart';
import 'package:PiliPlus/plugin/pl_player/models/hwdec_type.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_repeat.dart';
import 'package:PiliPlus/utils/context_ext.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/login_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

abstract class Pref {
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

  static set blackMids(Set<int> blackMidsSet) {
    _localCache.put(LocalCacheKey.blackMids, blackMidsSet);
  }

  static RuleFilter get danmakuFilterRule => _localCache.get(
    LocalCacheKey.danmakuFilterRules,
    defaultValue: RuleFilter.empty(),
  );

  static void setBlackMid(int mid) {
    _localCache.put(LocalCacheKey.blackMids, GlobalData().blackMids..add(mid));
  }

  static void removeBlackMid(int mid) {
    _localCache.put(
      LocalCacheKey.blackMids,
      GlobalData().blackMids..remove(mid),
    );
  }

  static MemberTabType get memberTab =>
      MemberTabType.values[_setting.get(
        SettingBoxKey.memberTab,
        defaultValue: 0,
      )];

  static int get themeTypeInt => _setting.get(
    SettingBoxKey.themeMode,
    defaultValue: ThemeType.system.index,
  );

  static ThemeMode get themeMode {
    return switch (themeTypeInt) {
      0 => ThemeMode.light,
      1 => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  static List<double> get springDescription => List<double>.from(
    _setting.get(SettingBoxKey.springDescription) ??
        [0.5, 100.0, 2.2 * sqrt(50)], // [mass, stiffness, damping]
  );

  static List<double> get speedList => List<double>.from(
    _video.get(
      VideoBoxKey.speedsList,
      defaultValue: const [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0, 3.0],
    ),
  );

  static List<Pair<SegmentType, SkipType>> get blockSettings {
    final list = _setting.get(SettingBoxKey.blockSettings) as List?;
    if (list == null) {
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
    if (list == null) {
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

  static bool get hiddenSettingUnlocked =>
      _setting.get(SettingBoxKey.hiddenSettingUnlocked, defaultValue: false);

  static bool get feedBackEnable =>
      _setting.get(SettingBoxKey.feedBackEnable, defaultValue: false);

  static int get picQuality =>
      _setting.get(SettingBoxKey.defaultPicQa, defaultValue: 10);

  static ThemeType get themeType => ThemeType.values[themeTypeInt];

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

  static int get defaultHomePage =>
      _setting.get(SettingBoxKey.defaultHomePage, defaultValue: 0);

  static int get previewQ =>
      _setting.get(SettingBoxKey.previewQuality, defaultValue: 100);

  static double get smallCardWidth =>
      _setting.get(SettingBoxKey.smallCardWidth, defaultValue: 240.0);

  static UpPanelPosition get upPanelPosition =>
      UpPanelPosition.values[_setting.get(
        SettingBoxKey.upPanelPosition,
        defaultValue: UpPanelPosition.leftFixed.index,
      )];

  static int get fullScreenMode => _setting.get(
    SettingBoxKey.fullScreenMode,
    defaultValue: FullScreenMode.auto.index,
  );

  static int get btmProgressBehavior => _setting.get(
    SettingBoxKey.btmProgressBehavior,
    defaultValue: BtmProgressBehavior.alwaysShow.index,
  );

  static int get subtitlePreferenceV2 => _setting.get(
    SettingBoxKey.subtitlePreferenceV2,
    defaultValue: SubtitlePrefType.off.index,
  );

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
    defaultValue: VideoDecodeFormatType.values.last.codes.first,
  );

  static String get secondDecode => _setting.get(
    SettingBoxKey.secondDecode,
    defaultValue: VideoDecodeFormatType.AV1.codes.first,
  );

  static String get hardwareDecoding => _setting.get(
    SettingBoxKey.hardwareDecoding,
    defaultValue: Platform.isAndroid
        ? HwDecType.autoSafe.hwdec
        : HwDecType.auto.hwdec,
  );

  static String get videoSync =>
      _setting.get(SettingBoxKey.videoSync, defaultValue: 'display-resample');

  static String get defaultCDNService => _setting.get(
    SettingBoxKey.CDNService,
    defaultValue: CDNService.backupUrl.code,
  );

  static String get banWordForRecommend =>
      _setting.get(SettingBoxKey.banWordForRecommend, defaultValue: '');

  static String get banWordForReply =>
      _setting.get(SettingBoxKey.banWordForReply, defaultValue: '');

  static String get banWordForZone =>
      _setting.get(SettingBoxKey.banWordForZone, defaultValue: '');

  static bool get appRcmd =>
      _setting.get(SettingBoxKey.appRcmd, defaultValue: true);

  static String get systemProxyHost =>
      _setting.get(SettingBoxKey.systemProxyHost, defaultValue: '');

  static String get systemProxyPort =>
      _setting.get(SettingBoxKey.systemProxyPort, defaultValue: '');

  static int get defaultDynamicType =>
      _setting.get(SettingBoxKey.defaultDynamicType, defaultValue: 0);

  static double get blockLimit =>
      _setting.get(SettingBoxKey.blockLimit, defaultValue: 0.0);

  static double get refreshDragPercentage =>
      _setting.get(SettingBoxKey.refreshDragPercentage, defaultValue: 0.25);

  static double get refreshDisplacement => _setting.get(
    SettingBoxKey.refreshDisplacement,
    defaultValue: Utils.isMobile ? 20.0 : 40.0,
  );

  static String get blockUserID {
    String blockUserID = _setting.get(
      SettingBoxKey.blockUserID,
      defaultValue: '',
    );
    if (blockUserID.isEmpty) {
      blockUserID = const Uuid().v4().replaceAll('-', '');
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

  static bool get blockTrack =>
      _setting.get(SettingBoxKey.blockTrack, defaultValue: true);

  static bool get checkDynamic =>
      _setting.get(SettingBoxKey.checkDynamic, defaultValue: true);

  static int get dynamicPeriod =>
      _setting.get(SettingBoxKey.dynamicPeriod, defaultValue: 5);

  static int get schemeVariant =>
      _setting.get(SettingBoxKey.schemeVariant, defaultValue: 10);

  static double get danmakuFontScaleFS =>
      _setting.get(SettingBoxKey.danmakuFontScaleFS, defaultValue: 1.2);

  static bool get danmakuMassiveMode =>
      _setting.get(SettingBoxKey.danmakuMassiveMode, defaultValue: false);

  static double get subtitleFontScale =>
      _setting.get(SettingBoxKey.subtitleFontScale, defaultValue: 1.0);

  static double get subtitleFontScaleFS =>
      _setting.get(SettingBoxKey.subtitleFontScaleFS, defaultValue: 1.5);

  static bool get showViewPoints =>
      _setting.get(SettingBoxKey.showViewPoints, defaultValue: true);

  static bool get showRelatedVideo =>
      _setting.get(SettingBoxKey.showRelatedVideo, defaultValue: true);

  static bool get showVideoReply =>
      _setting.get(SettingBoxKey.showVideoReply, defaultValue: true);

  static bool get showBangumiReply =>
      _setting.get(SettingBoxKey.showBangumiReply, defaultValue: true);

  static bool get alwaysExapndIntroPanel =>
      _setting.get(SettingBoxKey.alwaysExapndIntroPanel, defaultValue: false);

  static bool get exapndIntroPanelH =>
      _setting.get(SettingBoxKey.exapndIntroPanelH, defaultValue: false);

  static bool get horizontalSeasonPanel =>
      _setting.get(SettingBoxKey.horizontalSeasonPanel, defaultValue: false);

  static bool get horizontalMemberPage =>
      _setting.get(SettingBoxKey.horizontalMemberPage, defaultValue: false);

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

  static double get subtitleBgOpaticy =>
      _setting.get(SettingBoxKey.subtitleBgOpaticy, defaultValue: 0.67);

  static double get subtitleStrokeWidth =>
      _setting.get(SettingBoxKey.subtitleStrokeWidth, defaultValue: 2.0);

  static int get subtitleFontWeight =>
      _setting.get(SettingBoxKey.subtitleFontWeight, defaultValue: 5);

  static bool get badCertificateCallback =>
      _setting.get(SettingBoxKey.badCertificateCallback, defaultValue: false);

  static bool get continuePlayingPart =>
      _setting.get(SettingBoxKey.continuePlayingPart, defaultValue: true);

  static bool get cdnSpeedTest =>
      _setting.get(SettingBoxKey.cdnSpeedTest, defaultValue: true);

  static bool get autoUpdate =>
      _setting.get(SettingBoxKey.autoUpdate, defaultValue: true);

  static bool get horizontalPreview =>
      _setting.get(SettingBoxKey.horizontalPreview, defaultValue: false);

  static bool get openInBrowser =>
      _setting.get(SettingBoxKey.openInBrowser, defaultValue: false);

  static bool get savedRcmdTip =>
      _setting.get(SettingBoxKey.savedRcmdTip, defaultValue: true);

  static bool get showVipDanmaku =>
      _setting.get(SettingBoxKey.showVipDanmaku, defaultValue: true);

  static bool get showSpecialDanmaku =>
      _setting.get(SettingBoxKey.showSpecialDanmaku, defaultValue: false);

  static bool get mergeDanmaku =>
      _setting.get(SettingBoxKey.mergeDanmaku, defaultValue: false);

  static bool get showHotRcmd =>
      _setting.get(SettingBoxKey.showHotRcmd, defaultValue: false);

  static String get audioNormalization =>
      _setting.get(SettingBoxKey.audioNormalization, defaultValue: '0');

  static String get fallbackNormalization =>
      _setting.get(SettingBoxKey.fallbackNormalization, defaultValue: '0');

  static SuperResolutionType get superResolutionType {
    SuperResolutionType? superResolutionType;
    final index = _setting.get(SettingBoxKey.superResolutionType);
    if (index != null) {
      superResolutionType = SuperResolutionType.values.getOrNull(index);
    }
    superResolutionType ??= SuperResolutionType.disable;
    return superResolutionType;
  }

  static bool get preInitPlayer =>
      _setting.get(SettingBoxKey.preInitPlayer, defaultValue: false);

  static bool get mainTabBarView =>
      _setting.get(SettingBoxKey.mainTabBarView, defaultValue: false);

  static bool get searchSuggestion =>
      _setting.get(SettingBoxKey.searchSuggestion, defaultValue: true);

  static bool get showDynDecorate =>
      _setting.get(SettingBoxKey.showDynDecorate, defaultValue: true);

  static bool get enableLivePhoto =>
      _setting.get(SettingBoxKey.enableLivePhoto, defaultValue: true);

  static bool get showSeekPreview =>
      _setting.get(SettingBoxKey.showSeekPreview, defaultValue: true);

  static bool get showDmChart =>
      _setting.get(SettingBoxKey.showDmChart, defaultValue: false);

  static bool get enableCommAntifraud =>
      _setting.get(SettingBoxKey.enableCommAntifraud, defaultValue: false);

  static bool get biliSendCommAntifraud =>
      _setting.get(SettingBoxKey.biliSendCommAntifraud, defaultValue: false);

  static bool get enableCreateDynAntifraud =>
      _setting.get(SettingBoxKey.enableCreateDynAntifraud, defaultValue: false);

  static bool get coinWithLike =>
      _setting.get(SettingBoxKey.coinWithLike, defaultValue: false);

  static bool get isPureBlackTheme =>
      _setting.get(SettingBoxKey.isPureBlackTheme, defaultValue: false);

  static bool get antiGoodsDyn =>
      _setting.get(SettingBoxKey.antiGoodsDyn, defaultValue: false);

  static bool get antiGoodsReply =>
      _setting.get(SettingBoxKey.antiGoodsReply, defaultValue: false);

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

  static int get appFontWeight =>
      _setting.get(SettingBoxKey.appFontWeight, defaultValue: -1);

  static bool get enableDragSubtitle =>
      _setting.get(SettingBoxKey.enableDragSubtitle, defaultValue: false);

  static int get fastForBackwardDuration =>
      _setting.get(SettingBoxKey.fastForBackwardDuration, defaultValue: 10);

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
      _setting.get(SettingBoxKey.maxCacheSize) ?? pow(1024, 3);

  static bool get optTabletNav =>
      _setting.get(SettingBoxKey.optTabletNav, defaultValue: true);

  static bool get horizontalScreen =>
      _setting.get(SettingBoxKey.horizontalScreen) ?? isTablet;

  static bool get isTablet {
    bool isTablet;
    if (Get.context != null) {
      isTablet = Get.context!.isTablet;
    } else {
      final view = WidgetsBinding.instance.platformDispatcher.views.first;
      final screenSize = view.physicalSize / view.devicePixelRatio;
      isTablet = screenSize.shortestSide >= 600;
    }
    _setting.put(SettingBoxKey.horizontalScreen, isTablet);
    return isTablet;
  }

  static String get banWordForDyn =>
      _setting.get(SettingBoxKey.banWordForDyn, defaultValue: '');

  static bool get enableLog =>
      _setting.get(SettingBoxKey.enableLog, defaultValue: true);

  static bool get disableAudioCDN =>
      _setting.get(SettingBoxKey.disableAudioCDN, defaultValue: true);

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

  static bool get enableBackgroundPlay =>
      _setting.get(SettingBoxKey.enableBackgroundPlay, defaultValue: true);

  static bool get allowRotateScreen =>
      _setting.get(SettingBoxKey.allowRotateScreen, defaultValue: true);

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

  static bool get dynamicsWaterfallFlow =>
      _setting.get(SettingBoxKey.dynamicsWaterfallFlow, defaultValue: true);

  static bool get hideSearchBar =>
      _setting.get(SettingBoxKey.hideSearchBar, defaultValue: true);

  static bool get enableScrollThreshold =>
      _setting.get(SettingBoxKey.enableScrollThreshold, defaultValue: false);

  static double get scrollThreshold =>
      _setting.get(SettingBoxKey.scrollThreshold, defaultValue: 50.0);

  static bool get enableSearchWord =>
      _setting.get(SettingBoxKey.enableSearchWord, defaultValue: false);

  static bool get useSideBar =>
      _setting.get(SettingBoxKey.useSideBar, defaultValue: false);

  static bool get dynamicsShowAllFollowedUp => _setting.get(
    SettingBoxKey.dynamicsShowAllFollowedUp,
    defaultValue: false,
  );

  static bool get enableShowDanmaku =>
      _setting.get(SettingBoxKey.enableShowDanmaku, defaultValue: true);

  static bool get enableShowLiveDanmaku =>
      _setting.get(SettingBoxKey.enableShowLiveDanmaku, defaultValue: true);

  static bool get enableQuickFav =>
      _setting.get(SettingBoxKey.enableQuickFav, defaultValue: false);

  static bool get p1080 =>
      _setting.get(SettingBoxKey.p1080, defaultValue: true);

  static int get customColor =>
      _setting.get(SettingBoxKey.customColor, defaultValue: 0);

  static bool get dynamicColor =>
      _setting.get(SettingBoxKey.dynamicColor, defaultValue: true);

  static bool get autoClearCache =>
      _setting.get(SettingBoxKey.autoClearCache, defaultValue: false);

  static bool get enableSystemProxy =>
      _setting.get(SettingBoxKey.enableSystemProxy, defaultValue: false);

  static bool get enableHttp2 =>
      _setting.get(SettingBoxKey.enableHttp2, defaultValue: false);

  static int get replySortType =>
      _setting.get(SettingBoxKey.replySortType, defaultValue: 1);

  static bool get hideTabBar =>
      _setting.get(SettingBoxKey.hideTabBar, defaultValue: true);

  static int get dynamicBadgeMode => _setting.get(
    SettingBoxKey.dynamicBadgeMode,
    defaultValue: DynamicBadgeMode.number.index,
  );

  static bool get enableMYBar =>
      _setting.get(SettingBoxKey.enableMYBar, defaultValue: true);

  static int get pageTransition => _setting.get(
    SettingBoxKey.pageTransition,
    defaultValue: Transition.native.index,
  );

  static bool get enableQuickDouble =>
      _setting.get(SettingBoxKey.enableQuickDouble, defaultValue: true);

  static bool get fullScreenGestureReverse =>
      _setting.get(SettingBoxKey.fullScreenGestureReverse, defaultValue: false);

  static bool get autoPiP =>
      _setting.get(SettingBoxKey.autoPiP, defaultValue: false);

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

  static double get danmakuFontScale =>
      _setting.get(SettingBoxKey.danmakuFontScale, defaultValue: 1.0);

  static double get danmakuDuration =>
      _setting.get(SettingBoxKey.danmakuDuration, defaultValue: 7.0);

  static double get danmakuStaticDuration =>
      _setting.get(SettingBoxKey.danmakuStaticDuration, defaultValue: 4.0);

  static double get strokeWidth =>
      _setting.get(SettingBoxKey.strokeWidth, defaultValue: 1.5);

  static int get fontWeight =>
      _setting.get(SettingBoxKey.fontWeight, defaultValue: 5);

  static bool get enableLongShowControl =>
      _setting.get(SettingBoxKey.enableLongShowControl, defaultValue: false);

  static bool get expandBuffer =>
      _setting.get(SettingBoxKey.expandBuffer, defaultValue: false);

  static bool get useOpenSLES =>
      _setting.get(SettingBoxKey.useOpenSLES, defaultValue: true);

  static bool get enableAi =>
      _setting.get(SettingBoxKey.enableAi, defaultValue: false);

  static bool get enableOnlineTotal =>
      _setting.get(SettingBoxKey.enableOnlineTotal, defaultValue: false);

  static bool get enableAutoEnter =>
      _setting.get(SettingBoxKey.enableAutoEnter, defaultValue: false);

  static bool get enableAutoLongPressSpeed =>
      _setting.get(SettingBoxKey.enableAutoLongPressSpeed, defaultValue: false);

  static double get playSpeedDefault =>
      _video.get(VideoBoxKey.playSpeedDefault, defaultValue: 1.0);

  static double get longPressSpeedDefault =>
      _video.get(VideoBoxKey.longPressSpeedDefault, defaultValue: 3.0);

  static bool get defaultShowComment =>
      _setting.get(SettingBoxKey.defaultShowComment, defaultValue: false);

  static bool get enableTrending =>
      _setting.get(SettingBoxKey.enableHotKey, defaultValue: true);

  static bool get enableSearchRcmd =>
      _setting.get(SettingBoxKey.enableSearchRcmd, defaultValue: true);

  static bool get enableSaveLastData =>
      _setting.get(SettingBoxKey.enableSaveLastData, defaultValue: false);

  static double get defaultToastOp =>
      _setting.get(SettingBoxKey.defaultToastOp, defaultValue: 1.0);

  static int get playRepeat =>
      (_video.get(VideoBoxKey.playRepeat) as num?)?.toInt() ??
      PlayRepeat.pause.index;

  static int get cacheVideoFit =>
      _video.get(VideoBoxKey.cacheVideoFit, defaultValue: 1);

  static bool get continuePlayInBackground =>
      _setting.get(SettingBoxKey.continuePlayInBackground, defaultValue: false);

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

  static bool get showSuperChat =>
      _setting.get(SettingBoxKey.showSuperChat, defaultValue: true);

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
}
