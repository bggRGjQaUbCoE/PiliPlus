import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/pages/rcmd/controller.dart';
import 'package:PiliPlus/pages/setting/models/model.dart';
import 'package:PiliPlus/utils/recommend_filter.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

List<SettingsModel> get recommendSettings => [
  SwitchModel(
    title: L10n.current.appRcmdRecommendSettingsTitle,
    subtitle: L10n.current.appRcmdRecommendSettingsSubtitle,
    leading: const Icon(Icons.model_training_outlined),
    setKey: SettingBoxKey.appRcmd,
    defaultVal: true,
    needReboot: true,
  ),
  SwitchModel(
    title: L10n.current.enableSaveLastDataRecommendSettingsTitle,
    subtitle: L10n.current.enableSaveLastDataRecommendSettingsSubtitle,
    leading: const Icon(Icons.refresh),
    setKey: SettingBoxKey.enableSaveLastData,
    defaultVal: true,
    onChanged: (value) {
      try {
        Get.find<RcmdController>()
          ..enableSaveLastData = value
          ..lastRefreshAt = null;
      } catch (e) {
        if (kDebugMode) debugPrint('$e');
      }
    },
  ),
  SwitchModel(
    title: L10n.current.savedRcmdTipRecommendSettingsTitle,
    subtitle: L10n.current.savedRcmdTipRecommendSettingsSubtitle,
    leading: const Icon(Icons.tips_and_updates_outlined),
    setKey: SettingBoxKey.savedRcmdTip,
    defaultVal: true,
    onChanged: (value) {
      try {
        Get.find<RcmdController>()
          ..savedRcmdTip = value
          ..lastRefreshAt = null;
      } catch (e) {
        if (kDebugMode) debugPrint('$e');
      }
    },
  ),
  getVideoFilterSelectModel(
    title:
        L10n.current.pagesSettingModelsRecommendSettingsRecommendSettingsTitle,
    suffix: '%',
    key: SettingBoxKey.minLikeRatioForRecommend,
    values: [0, 1, 2, 3, 4],
    onChanged: (value) => RecommendFilter.minLikeRatioForRecommend = value,
  ),
  getBanWordModel(
    title:
        L10n.current.pagesSettingModelsRecommendSettingsRecommendSettingsTitle4,
    key: SettingBoxKey.banWordForRecommend,
    onChanged: (value) {
      RecommendFilter.rcmdRegExp = value;
      RecommendFilter.enableFilter = value.pattern.isNotEmpty;
    },
  ),
  getBanWordModel(
    title:
        L10n.current.pagesSettingModelsRecommendSettingsRecommendSettingsTitle5,
    key: SettingBoxKey.banWordForZone,
    onChanged: (value) {
      VideoHttp.zoneRegExp = value;
      VideoHttp.enableFilter = value.pattern.isNotEmpty;
    },
  ),
  getVideoFilterSelectModel(
    title:
        L10n.current.pagesSettingModelsRecommendSettingsRecommendSettingsTitle3,
    suffix: 's',
    key: SettingBoxKey.minDurationForRcmd,
    values: [0, 30, 60, 90, 120],
    onChanged: (value) => RecommendFilter.minDurationForRcmd = value,
  ),
  getVideoFilterSelectModel(
    title:
        L10n.current.pagesSettingModelsRecommendSettingsRecommendSettingsTitle2,
    key: SettingBoxKey.minPlayForRcmd,
    values: [0, 50, 100, 500, 1000],
    onChanged: (value) => RecommendFilter.minPlayForRcmd = value,
  ),
  SwitchModel(
    title: L10n.current.exemptFilterForFollowedRecommendSettingsTitle,
    subtitle: L10n.current.exemptFilterForFollowedRecommendSettingsSubtitle,
    leading: const Icon(Icons.favorite_border_outlined),
    setKey: SettingBoxKey.exemptFilterForFollowed,
    defaultVal: true,
    onChanged: (value) => RecommendFilter.exemptFilterForFollowed = value,
  ),
  SwitchModel(
    title: L10n.current.applyFilterToRelatedVideosRecommendSettingsTitle,
    subtitle: L10n.current.applyFilterToRelatedVideosRecommendSettingsSubtitle,
    leading: const Icon(Icons.explore_outlined),
    setKey: SettingBoxKey.applyFilterToRelatedVideos,
    defaultVal: true,
    onChanged: (value) => RecommendFilter.applyFilterToRelatedVideos = value,
  ),
];
