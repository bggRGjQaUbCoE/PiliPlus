import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/rcmd_source.dart';
import 'package:PiliPlus/pages/rcmd/controller.dart';
import 'package:PiliPlus/pages/setting/models/model.dart';
import 'package:PiliPlus/pages/setting/widgets/select_dialog.dart';
import 'package:PiliPlus/utils/recommend_filter.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart' hide StatefulBuilder;

List<SettingsModel> get recommendSettings => [
  NormalModel(
    title: '首页推荐来源',
    getSubtitle: () => Pref.rcmdSource.label,
    leading: const Icon(Icons.swap_horiz_outlined),
    onTap: _showRcmdSourceDialog,
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
    filterScope: 'Web推荐、热门、分区',
  ),
  getBanWordModel(
    title: '标题关键词过滤',
    key: SettingBoxKey.banWordForRecommend,
    onChanged: (value) {
      RecommendFilter.rcmdRegExp = value;
      RecommendFilter.enableFilter = value.pattern.isNotEmpty;
    },
    banScope: '推荐、热门、分区、相关视频',
  ),
  getBanWordModel(
    title: '分区关键词过滤',
    key: SettingBoxKey.banWordForZone,
    onChanged: (value) {
      VideoHttp.zoneRegExp = value;
      VideoHttp.enableFilter = value.pattern.isNotEmpty;
    },
    banScope: 'App推荐、热门、分区',
  ),
  getVideoFilterSelectModel(
    title: '视频时长',
    suffix: 's',
    key: SettingBoxKey.minDurationForRcmd,
    values: [0, 30, 60, 90, 120],
    onChanged: (value) => RecommendFilter.minDurationForRcmd = value,
    filterScope: '推荐、相关视频',
  ),
  getVideoFilterSelectModel(
    title: '播放量',
    key: SettingBoxKey.minPlayForRcmd,
    values: [0, 50, 100, 500, 1000],
    onChanged: (value) => RecommendFilter.minPlayForRcmd = value,
    filterScope: '推荐、热门、分区、相关视频',
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

Future<void> _showRcmdSourceDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<RcmdSource>(
    context: context,
    builder: (context) => SelectDialog<RcmdSource>(
      title: '首页推荐来源',
      value: Pref.rcmdSource,
      values: RcmdSource.values.map((e) => (e, e.label)).toList(),
      subtitleBuilder: (context, index) {
        if (RcmdSource.values[index] != RcmdSource.desktop) {
          return null;
        }
        return const Text(
          '沿用公开的网页推荐接口，按哔哩哔哩官方 Windows 客户端'
          '首页实际发送的参数组合请求，不涉及私有接口与设备指纹',
        );
      },
    ),
  );
  if (res != null) {
    _switchRcmdSource(res, setState);
  }
}

void _switchRcmdSource(RcmdSource value, VoidCallback setState) {
  // 同步旧键（旧版本只有 app / web 二选一），保证降级后语义一致
  GStorage.setting
      .put(SettingBoxKey.appRcmd, value == RcmdSource.app)
      .whenComplete(setState);
  GStorage.setting.put(SettingBoxKey.rcmdSource, value.index);
  try {
    Get.find<RcmdController>()
      ..rcmdSource = value
      ..lastRefreshAt = null
      // 用 onReload 而不是 onRefresh：切换来源后不应把旧来源的列表
      // 拼到新来源的数据前面（"保留上次内容"只在同一来源内生效）
      ..onReload();
  } catch (e) {
    if (kDebugMode) debugPrint('$e');
  }
  SmartDialog.showToast('已切换为${value.label}');
}
