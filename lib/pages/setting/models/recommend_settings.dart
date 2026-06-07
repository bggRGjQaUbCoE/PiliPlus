import 'package:PiliPlus/features/shielding/shielding_recommend_tag_enricher.dart';
import 'package:PiliPlus/pages/rcmd/controller.dart';
import 'package:PiliPlus/pages/setting/models/model.dart';
import 'package:PiliPlus/utils/recommend_filter.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

List<SettingsModel> get recommendSettings => [
  const SwitchModel(
    title: '首页使用app端推荐',
    subtitle: '若web端推荐不太符合预期，可尝试切换至app端推荐',
    leading: Icon(Icons.model_training_outlined),
    setKey: SettingBoxKey.appRcmd,
    defaultVal: true,
    needReboot: true,
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
    title: '过滤器也应用于相关视频',
    subtitle: '视频详情页的相关视频也进行过滤¹',
    leading: const Icon(Icons.explore_outlined),
    setKey: SettingBoxKey.applyFilterToRelatedVideos,
    defaultVal: true,
    onChanged: (value) => RecommendFilter.applyFilterToRelatedVideos = value,
  ),
  _buildNumberInputModel(
    title: '标签获取并发数',
    icon: Icons.memory_outlined,
    key: SettingBoxKey.tagEnrichConcurrency,
    defaultVal: 5,
    min: 1,
    max: 10,
  ),
  _buildNumberInputModel(
    title: '标签获取超时',
    icon: Icons.timer_outlined,
    key: SettingBoxKey.tagEnrichTimeout,
    defaultVal: 3,
    min: 1,
    max: 10,
    suffix: 's',
  ),
  _buildNumberInputModel(
    title: '标签缓存上限',
    icon: Icons.storage_outlined,
    key: SettingBoxKey.tagEnrichCacheMaxMb,
    defaultVal: 10,
    min: 1,
    max: 50,
    suffix: 'MB',
  ),
  NormalModel(
    title: '标签缓存状态',
    leading: const Icon(Icons.cached_outlined),
    getSubtitle: () {
      final count = RecommendationTagEnricher.cacheEntryCount;
      final bytes = RecommendationTagEnricher.cacheEstimatedBytes;
      final usedMb = bytes / (1024 * 1024);
      final maxMb = tagEnrichCacheMaxMb;
      return '${usedMb.toStringAsFixed(2)} / $maxMb MB，$count 条（点击可清空缓存）';
    },
    onTap: (context, setState) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('清空标签缓存'),
          content: const Text('缓存清空后，下一轮推荐会重新获取视频标签。'),
          actions: [
            TextButton(
              onPressed: Get.back,
              child: Text(
                '取消',
                style: TextStyle(color: ColorScheme.of(ctx).outline),
              ),
            ),
            TextButton(
              onPressed: () {
                RecommendationTagEnricher.resetCache();
                Get.back();
                setState();
                SmartDialog.showToast('标签缓存已清空');
              },
              child: const Text('清空'),
            ),
          ],
        ),
      );
    },
  ),
];

SettingsModel _buildNumberInputModel({
  required String title,
  required IconData icon,
  required String key,
  required int defaultVal,
  required int min,
  required int max,
  String? suffix,
}) {
  int value = GStorage.setting.get(key, defaultValue: defaultVal);
  return NormalModel(
    title: title,
    leading: Icon(icon),
    getSubtitle: () {
      final suffixStr = suffix ?? '';
      return '当前: $value$suffixStr（默认$defaultVal$suffixStr，范围$min–$max）';
    },
    onTap: (context, setState) async {
      String valueStr = '';
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(title),
          content: TextField(
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: '$defaultVal',
              suffixText: suffix,
            ),
            onChanged: (v) => valueStr = v,
          ),
          actions: [
            TextButton(
              onPressed: Get.back,
              child: Text(
                '取消',
                style: TextStyle(color: ColorScheme.of(ctx).outline),
              ),
            ),
            TextButton(
              onPressed: () {
                final parsed = int.tryParse(
                  valueStr.isEmpty ? '$defaultVal' : valueStr,
                );
                if (parsed == null) {
                  SmartDialog.showToast('请输入有效数字');
                  return;
                }
                value = parsed.clamp(min, max).toInt();
                GStorage.setting.put(key, value);
                Get.back();
                setState();
                SmartDialog.showToast('已保存: $value');
              },
              child: const Text('确定'),
            ),
          ],
        ),
      );
    },
  );
}
