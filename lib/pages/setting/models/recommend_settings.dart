import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/rcmd_mode.dart';
import 'package:PiliPlus/pages/rcmd/controller.dart';
import 'package:PiliPlus/pages/setting/models/model.dart';
import 'package:PiliPlus/pages/setting/widgets/select_dialog.dart';
import 'package:PiliPlus/utils/recommend_filter.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

List<SettingsModel> get recommendSettings => [
  NormalModel(
    title: '初见推荐模式',
    getSubtitle: () => '${Pref.rcmdMode.label}：${Pref.rcmdMode.description}',
    leading: const Icon(Icons.explore_outlined),
    onTap: (context, setState) async {
      final result = await showDialog<RcmdMode>(
        context: context,
        builder: (context) => SelectDialog<RcmdMode>(
          title: '初见推荐模式',
          value: Pref.rcmdMode,
          values: RcmdMode.values.map((mode) => (mode, mode.label)).toList(),
        ),
      );
      if (result != null) {
        try {
          await Get.find<RcmdController>().switchMode(result);
        } catch (_) {
          await GStorage.setting.put(SettingBoxKey.rcmdMode, result.index);
        }
        setState();
      }
    },
  ),
  SwitchModel(
    title: '首页使用app端推荐',
    subtitle: '若web端推荐不太符合预期，可尝试切换至app端推荐',
    leading: const Icon(Icons.model_training_outlined),
    setKey: SettingBoxKey.appRcmd,
    defaultVal: true,
    onChanged: (value) {
      try {
        Get.find<RcmdController>().switchSource(value);
      } catch (e) {
        if (kDebugMode) debugPrint('$e');
      }
    },
  ),
  SwitchModel(
    title: '保留首页推荐刷新',
    subtitle: '下拉刷新时保留上次内容',
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
    title: '显示上次看到位置提示',
    subtitle: '保留上次推荐时，在上次刷新位置显示提示',
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
    title: '点赞率',
    suffix: '%',
    key: SettingBoxKey.minLikeRatioForRecommend,
    values: [0, 1, 2, 3, 4],
    onChanged: (value) => RecommendFilter.minLikeRatioForRecommend = value,
  ),
  getBanWordModel(
    title: '标题关键词过滤',
    key: SettingBoxKey.banWordForRecommend,
    onChanged: (value) {
      RecommendFilter.rcmdRegExp = value;
      RecommendFilter.enableFilter = value.pattern.isNotEmpty;
    },
  ),
  SwitchModel(
    title: '过滤广告推广标题',
    subtitle: '隐藏标题中包含商业合作、恰饭、推广、广告、赞助等内容的视频',
    leading: const Icon(Icons.block_outlined),
    setKey: SettingBoxKey.filterPromotionalTitles,
    defaultVal: false,
    onChanged: (value) => RecommendFilter.filterPromotionalTitles = value,
  ),
  SwitchModel(
    title: '过滤标题党',
    subtitle: '隐藏震惊体、夸张式和强诱导标题的视频',
    leading: const Icon(Icons.title_outlined),
    setKey: SettingBoxKey.filterClickbaitTitles,
    defaultVal: false,
    onChanged: (value) => RecommendFilter.filterClickbaitTitles = value,
  ),
  SwitchModel(
    title: '推荐中屏蔽相同标题视频',
    subtitle: '在当前推荐浏览会话中隐藏标题完全相同的视频',
    leading: const Icon(Icons.content_copy_outlined),
    setKey: SettingBoxKey.hideDuplicateRecommendTitles,
    onChanged: (_) => _reloadRecommend(),
  ),
  SwitchModel(
    title: '推荐中模糊屏蔽相似标题',
    subtitle: '隐藏标题文字高度相似的视频，保留每组中的第一条',
    leading: const Icon(Icons.filter_alt_outlined),
    setKey: SettingBoxKey.hideSimilarRecommendTitles,
    onChanged: (_) => _reloadRecommend(),
  ),
  const SwitchModel(
    title: '搜索中屏蔽相同标题视频',
    subtitle: '在每次搜索结果中隐藏标题完全相同的视频',
    leading: Icon(Icons.manage_search_outlined),
    setKey: SettingBoxKey.hideDuplicateSearchTitles,
  ),
  const SwitchModel(
    title: '搜索中模糊屏蔽相似标题',
    subtitle: '在每次搜索结果中隐藏标题文字高度相似的视频',
    leading: Icon(Icons.find_replace_outlined),
    setKey: SettingBoxKey.hideSimilarSearchTitles,
  ),
  getBanWordModel(
    title: 'App推荐/热门/排行榜: 视频分区关键词过滤',
    key: SettingBoxKey.banWordForZone,
    onChanged: (value) {
      VideoHttp.zoneRegExp = value;
      VideoHttp.enableFilter = value.pattern.isNotEmpty;
    },
  ),
  getVideoFilterSelectModel(
    title: '视频时长',
    suffix: 's',
    key: SettingBoxKey.minDurationForRcmd,
    values: [0, 30, 60, 90, 120],
    onChanged: (value) => RecommendFilter.minDurationForRcmd = value,
  ),
  getVideoFilterSelectModel(
    title: '播放量',
    key: SettingBoxKey.minPlayForRcmd,
    values: [0, 50, 100, 500, 1000],
    onChanged: (value) => RecommendFilter.minPlayForRcmd = value,
  ),
  SwitchModel(
    title: '已关注UP豁免推荐过滤',
    subtitle: '推荐中已关注用户发布的内容不会被过滤',
    leading: const Icon(Icons.favorite_border_outlined),
    setKey: SettingBoxKey.exemptFilterForFollowed,
    defaultVal: true,
    onChanged: (value) => RecommendFilter.exemptFilterForFollowed = value,
  ),
  SwitchModel(
    title: '过滤器也应用于详情页相关视频',
    subtitle: '其它（如热门视频、搜索等）均不受过滤器影响，无法豁免相关视频中的已关注UP',
    leading: const Icon(Icons.explore_outlined),
    setKey: SettingBoxKey.applyFilterToRelatedVideos,
    defaultVal: true,
    onChanged: (value) => RecommendFilter.applyFilterToRelatedVideos = value,
  ),
];

void _reloadRecommend() {
  try {
    Get.find<RcmdController>().onRefresh();
  } catch (_) {}
}
