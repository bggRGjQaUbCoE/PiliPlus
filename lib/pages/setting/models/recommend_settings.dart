import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/rcmd_mode.dart';
import 'package:PiliPlus/pages/rcmd/controller.dart';
import 'package:PiliPlus/pages/setting/models/model.dart';
import 'package:PiliPlus/pages/setting/widgets/select_dialog.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/recommend_filter.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/user_whitelist.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive_ce/hive.dart';
import 'package:material_ui/material_ui.dart';

List<SettingsModel> get recommendSettings => [
  NormalModel(
    title: '首页推荐模式',
    leading: const Icon(Icons.model_training_outlined),
    getSubtitle: () => '当前:「${Pref.rcmdMode.label}」',
    onTap: _showRcmdModeDialog,
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
  getListBanWordModel(
    title: '标题关键词过滤',
    key: SettingBoxKey.banWordForRecommend,
    onChanged: (value) {
      RecommendFilter.rcmdRegExp = value;
      RecommendFilter.enableFilter = value.pattern.isNotEmpty;
    },
  ),
  getListBanWordModel(
    title: 'UP名称关键词过滤',
    key: SettingBoxKey.banWordForRecommendUpName,
    onChanged: (value) {
      RecommendFilter.rcmdUpNameRegExp = value;
      RecommendFilter.enableUpNameFilter = value.pattern.isNotEmpty;
    },
  ),
  getListBanWordModel(
    title: 'App推荐/热门/排行榜: 视频分区关键词过滤',
    key: SettingBoxKey.banWordForZone,
    onChanged: (value) {
      VideoHttp.zoneRegExp = value;
      VideoHttp.enableFilter = value.pattern.isNotEmpty;
    },
  ),
  getListUidWithNameModel(
    title: '屏蔽用户',
    getUidsMap: () => Pref.recommendBlockedMids,
    setUidsMap: (uidsMap) {
      Pref.recommendBlockedMids = uidsMap;
      GlobalData().recommendBlockedMids = uidsMap;
      RecommendFilter.recommendBlockedMids = uidsMap;
    },
    onUpdate: () {
      // Changes are immediately reflected
    },
  ),
  getListUidWithNameModel(
    title: '白名单用户',
    leading: const Icon(Icons.person_add_alt_1_outlined),
    emptySubtitle: '点击添加白名单用户',
    countSubtitleBuilder: (count) => '已加入白名单 $count 个用户',
    getUidsMap: () => Pref.whitelistMids,
    setUidsMap: UserWhitelist.save,
    onUpdate: () {
      // Changes are immediately reflected
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
  NormalModel(
    title: '屏蔽无权查看视频',
    leading: const Icon(Icons.block_outlined),
    getSubtitle: () => Pref.rcmdMode != RcmdMode.web
        ? '仅对首页 app 端推荐生效，屏蔽无权查看的视频(如充电专属视频)'
        : '仅对首页 app 端推荐生效，请先切换为App端推荐或合并模式',
    getTrailing: (_) => StreamBuilder<BoxEvent>(
      stream: GStorage.setting.watch().where(
        (event) =>
            event.key == SettingBoxKey.rcmdMode ||
            event.key == SettingBoxKey.removeBlockedRcmd,
      ),
      builder: (_, _) => Switch(
        value: Pref.removeBlockedRcmd,
        onChanged: Pref.rcmdMode != RcmdMode.web
            ? (value) {
                GStorage.setting.put(SettingBoxKey.removeBlockedRcmd, value);
              }
            : null,
      ),
    ),
    onTap: (context, setState) {
      if (Pref.rcmdMode == RcmdMode.web) {
        return;
      }
      GStorage.setting.put(
        SettingBoxKey.removeBlockedRcmd,
        !Pref.removeBlockedRcmd,
      );
      setState();
    },
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
  SwitchModel(
    title: '过滤器也应用于热门视频',
    subtitle: '开启后对热门视频应用完整过滤（标题和UP名称关键词、时长、播放量、点赞率、屏蔽用户）',
    leading: const Icon(Icons.local_fire_department_outlined),
    setKey: SettingBoxKey.applyFilterToHotVideos,
    defaultVal: false,
    onChanged: (value) => RecommendFilter.applyFilterToHotVideos = value,
  ),
  SwitchModel(
    title: '过滤器也应用于分区视频',
    subtitle: '开启后对 UGC 分区视频应用完整过滤；番剧等 PGC 内容仅过滤标题关键词',
    leading: const Icon(Icons.leaderboard_outlined),
    setKey: SettingBoxKey.applyFilterToRankVideos,
    defaultVal: false,
    onChanged: (value) => RecommendFilter.applyFilterToRankVideos = value,
  ),
  SwitchModel(
    title: '过滤器也应用于搜索结果',
    subtitle: '对视频、专栏、用户搜索生效，仅过滤标题关键词和屏蔽用户',
    leading: const Icon(Icons.search_off_outlined),
    setKey: SettingBoxKey.applyFilterToSearch,
    defaultVal: false,
    onChanged: (value) => RecommendFilter.applyFilterToSearch = value,
  ),
  WidgetModel(
    searchTitle: '推荐过滤说明',
    searchSubtitle: '手动搜索、链接跳转不受过滤器影响',
    child: Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return ListTile(
          dense: true,
          subtitle: Text(
            '¹ 由于接口未提供关注信息，无法豁免相关视频中的已关注Up。\n\n'
            '* 手动搜索、链接跳转等均不受过滤器影响。\n'
            '* 推荐流屏蔽用户优先于白名单生效。\n'
            '* 白名单用户与动态流/评论区共享，白名单优先于常规过滤。\n'
            '* 设定较严苛的条件可导致推荐项数锐减或多次请求，请酌情选择。\n'
            '* 后续可能会增加更多过滤条件，敬请期待。',
            style: theme.textTheme.labelSmall!.copyWith(
              color: theme.colorScheme.outline.withValues(alpha: 0.7),
            ),
          ),
        );
      },
    ),
  ),
];

Future<void> _showRcmdModeDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<RcmdMode>(
    context: context,
    builder: (context) => SelectDialog<RcmdMode>(
      title: '首页推荐模式',
      value: Pref.rcmdMode,
      values: RcmdMode.values.map((e) => (e, e.label)).toList(),
    ),
  );
  if (res != null) {
    await GStorage.setting.put(SettingBoxKey.rcmdMode, res.index);
    SmartDialog.showToast('重启生效');
    setState();
  }
}
