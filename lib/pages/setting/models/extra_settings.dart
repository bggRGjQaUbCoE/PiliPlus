import 'dart:io';
import 'dart:math' show pi, max;

import 'package:PiliPlus/common/widgets/custom_icon.dart';
import 'package:PiliPlus/common/widgets/image/custom_grid_view.dart'
    show CustomGridView, ImageModel;
import 'package:PiliPlus/common/widgets/pendant_avatar.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/grpc/reply.dart';
import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/models/common/audio_normalization.dart';
import 'package:PiliPlus/models/common/dynamic/dynamics_type.dart';
import 'package:PiliPlus/models/common/member/tab_type.dart';
import 'package:PiliPlus/models/common/reply/reply_sort_type.dart';
import 'package:PiliPlus/models/common/settings_type.dart';
import 'package:PiliPlus/models/common/super_resolution_type.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/common/slide/common_slide_page.dart';
import 'package:PiliPlus/pages/home/controller.dart';
import 'package:PiliPlus/pages/hot/controller.dart';
import 'package:PiliPlus/pages/main/controller.dart';
import 'package:PiliPlus/pages/setting/models/model.dart';
import 'package:PiliPlus/pages/setting/widgets/select_dialog.dart';
import 'package:PiliPlus/pages/setting/widgets/slide_dialog.dart';
import 'package:PiliPlus/pages/video/reply/widgets/reply_item_grpc.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/cache_manage.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/update.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

List<SettingsModel> get extraSettings => [
  if (Utils.isDesktop)
    SettingsModel(
      settingsType: SettingsType.sw1tch,
      title: '退出时最小化',
      leading: const Icon(Icons.exit_to_app),
      setKey: SettingBoxKey.minimizeOnExit,
      defaultVal: true,
      onChanged: (value) {
        try {
          Get.find<MainController>().minimizeOnExit = value;
        } catch (_) {}
      },
    ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '空降助手',
    subtitle: '点击配置',
    setKey: SettingBoxKey.enableSponsorBlock,
    defaultVal: false,
    onTap: () => Get.toNamed('/sponsorBlock'),
    leading: const Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Icon(Icons.shield_outlined),
        Icon(Icons.play_arrow_rounded, size: 15),
      ],
    ),
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '检查未读动态',
    subtitle: '点击设置检查周期(min)',
    leading: const Icon(Icons.notifications_none),
    setKey: SettingBoxKey.checkDynamic,
    defaultVal: true,
    onChanged: (value) {
      Get.find<MainController>().checkDynamic = value;
    },
    onTap: () {
      int dynamicPeriod = Pref.dynamicPeriod;
      showDialog(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            title: const Text('检查周期'),
            content: TextFormField(
              autofocus: true,
              initialValue: dynamicPeriod.toString(),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                dynamicPeriod = int.tryParse(value) ?? 5;
              },
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(suffixText: 'min'),
            ),
            actions: [
              TextButton(
                onPressed: Get.back,
                child: Text(
                  '取消',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  GStorage.setting.put(
                    SettingBoxKey.dynamicPeriod,
                    dynamicPeriod,
                  );
                  Get.find<MainController>().dynamicPeriod =
                      dynamicPeriod * 60 * 1000;
                },
                child: const Text('确定'),
              ),
            ],
          );
        },
      );
    },
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '显示视频分段信息',
    leading: Transform.rotate(
      angle: pi / 2,
      child: const Icon(MdiIcons.viewHeadline),
    ),
    setKey: SettingBoxKey.showViewPoints,
    defaultVal: true,
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '视频页显示相关视频',
    leading: Icon(MdiIcons.motionPlayOutline),
    setKey: SettingBoxKey.showRelatedVideo,
    defaultVal: true,
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '显示视频评论',
    leading: Icon(MdiIcons.commentTextOutline),
    setKey: SettingBoxKey.showVideoReply,
    defaultVal: true,
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '显示番剧评论',
    leading: Icon(MdiIcons.commentTextOutline),
    setKey: SettingBoxKey.showBangumiReply,
    defaultVal: true,
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '默认展开视频简介',
    leading: Icon(Icons.expand_more),
    setKey: SettingBoxKey.alwaysExapndIntroPanel,
    defaultVal: false,
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '横屏自动展开视频简介',
    leading: Icon(Icons.expand_more),
    setKey: SettingBoxKey.exapndIntroPanelH,
    defaultVal: false,
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '横屏分P/合集列表显示在Tab栏',
    leading: Icon(Icons.format_list_numbered_rtl_sharp),
    setKey: SettingBoxKey.horizontalSeasonPanel,
    defaultVal: false,
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '横屏播放页在侧栏打开UP主页',
    leading: Icon(Icons.account_circle_outlined),
    setKey: SettingBoxKey.horizontalMemberPage,
    defaultVal: false,
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    title: '评论折叠行数',
    subtitle: '0行为不折叠',
    leading: const Icon(Icons.compress),
    setKey: SettingBoxKey.replyLengthLimit,
    getTrailing: () => Text(
      '${ReplyItemGrpc.replyLengthLimit}行',
      style: Get.theme.textTheme.titleSmall,
    ),
    onTap: (setState) {
      String replyLengthLimit = ReplyItemGrpc.replyLengthLimit.toString();
      showDialog(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            title: const Text('评论折叠行数'),
            content: TextFormField(
              autofocus: true,
              initialValue: replyLengthLimit,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                replyLengthLimit = value;
              },
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(suffixText: '行'),
            ),
            actions: [
              TextButton(
                onPressed: Get.back,
                child: Text(
                  '取消',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Get.back();
                  int length = int.tryParse(replyLengthLimit) ?? 6;
                  ReplyItemGrpc.replyLengthLimit = length == 0 ? null : length;
                  await GStorage.setting.put(
                    SettingBoxKey.replyLengthLimit,
                    length,
                  );
                  setState();
                },
                child: const Text('确定'),
              ),
            ],
          );
        },
      );
    },
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    title: '弹幕行高',
    subtitle: '默认1.6',
    setKey: SettingBoxKey.danmakuLineHeight,
    leading: const Icon(CustomIcons.dm_settings),
    getTrailing: () => Text(
      Pref.danmakuLineHeight.toString(),
      style: Get.theme.textTheme.titleSmall,
    ),
    onTap: (setState) {
      String danmakuLineHeight = Pref.danmakuLineHeight.toString();
      showDialog(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            title: const Text('弹幕行高'),
            content: TextFormField(
              autofocus: true,
              initialValue: danmakuLineHeight,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: (value) {
                danmakuLineHeight = value;
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d\.]+')),
              ],
            ),
            actions: [
              TextButton(
                onPressed: Get.back,
                child: Text(
                  '取消',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Get.back();
                  await GStorage.setting.put(
                    SettingBoxKey.danmakuLineHeight,
                    max(
                      1.0,
                      double.tryParse(danmakuLineHeight)?.toPrecision(1) ?? 1.6,
                    ),
                  );
                  setState();
                },
                child: const Text('确定'),
              ),
            ],
          );
        },
      );
    },
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '显示视频警告/争议信息',
    leading: Icon(Icons.warning_amber_rounded),
    setKey: SettingBoxKey.showArgueMsg,
    defaultVal: true,
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '分P/合集：倒序播放从首集开始播放',
    subtitle: '开启则自动切换为倒序首集，否则保持当前集',
    leading: Icon(MdiIcons.sort),
    setKey: SettingBoxKey.reverseFromFirst,
    defaultVal: true,
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '禁用 SSL 证书验证',
    subtitle: '谨慎开启，禁用容易受到中间人攻击',
    leading: Icon(Icons.security),
    needReboot: true,
    setKey: SettingBoxKey.badCertificateCallback,
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '显示继续播放分P提示',
    leading: Icon(Icons.local_parking),
    setKey: SettingBoxKey.continuePlayingPart,
    defaultVal: true,
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '横屏在侧栏打开图片预览',
    leading: const Icon(Icons.photo_outlined),
    setKey: SettingBoxKey.horizontalPreview,
    defaultVal: false,
    onChanged: (value) => CustomGridView.horizontalPreview = value,
  ),
  getBanwordModel(
    context: Get.context!,
    title: '评论关键词过滤',
    key: SettingBoxKey.banWordForReply,
    onChanged: (value) {
      ReplyGrpc.replyRegExp = value;
      ReplyGrpc.enableFilter = value.pattern.isNotEmpty;
    },
  ),
  getBanwordModel(
    context: Get.context!,
    title: '动态关键词过滤',
    key: SettingBoxKey.banWordForDyn,
    onChanged: (value) {
      DynamicsDataModel.banWordForDyn = value;
      DynamicsDataModel.enableFilter = value.pattern.isNotEmpty;
    },
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '使用外部浏览器打开链接',
    leading: Icon(Icons.open_in_browser),
    setKey: SettingBoxKey.openInBrowser,
    defaultVal: false,
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    title: '刷新滑动距离',
    leading: const Icon(Icons.refresh),
    setKey: SettingBoxKey.refreshDragPercentage,
    getSubtitle: () => '当前滑动距离: ${Pref.refreshDragPercentage}x',
    onTap: (setState) async {
      double? result = await showDialog(
        context: Get.context!,
        builder: (context) {
          return SlideDialog(
            title: '刷新滑动距离',
            min: 0.1,
            max: 0.5,
            divisions: 8,
            precise: 2,
            value: Pref.refreshDragPercentage,
            suffix: 'x',
          );
        },
      );
      if (result != null) {
        kDragContainerExtentPercentage = result;
        await GStorage.setting.put(SettingBoxKey.refreshDragPercentage, result);
        Get.forceAppUpdate();
        setState();
      }
    },
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    title: '刷新指示器高度',
    leading: const Icon(Icons.height),
    setKey: SettingBoxKey.refreshDisplacement,
    getSubtitle: () => '当前指示器高度: ${Pref.refreshDisplacement}',
    onTap: (setState) async {
      double? result = await showDialog(
        context: Get.context!,
        builder: (context) {
          return SlideDialog(
            title: '刷新指示器高度',
            min: 10.0,
            max: 100.0,
            divisions: 9,
            value: Pref.refreshDisplacement,
          );
        },
      );
      if (result != null) {
        displacement = result;
        await GStorage.setting.put(SettingBoxKey.refreshDisplacement, result);
        Get.forceAppUpdate();
        setState();
      }
    },
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '显示会员彩色弹幕',
    leading: Icon(MdiIcons.gradientHorizontal),
    setKey: SettingBoxKey.showVipDanmaku,
    defaultVal: true,
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '显示高级弹幕',
    leading: Icon(MdiIcons.paletteAdvanced),
    setKey: SettingBoxKey.showSpecialDanmaku,
    defaultVal: false,
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '合并弹幕',
    subtitle: '合并一段时间内获取到的相同弹幕',
    leading: Icon(Icons.merge),
    setKey: SettingBoxKey.mergeDanmaku,
    defaultVal: false,
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '显示热门推荐',
    subtitle: '热门页面显示每周必看等推荐内容入口',
    leading: const Icon(Icons.local_fire_department_outlined),
    setKey: SettingBoxKey.showHotRcmd,
    defaultVal: false,
    onChanged: (value) {
      try {
        Get.find<HotController>().showHotRcmd.value = value;
      } catch (_) {}
    },
  ),
  if (kDebugMode || Platform.isAndroid)
    SettingsModel(
      settingsType: SettingsType.normal,
      title: '音量均衡',
      setKey: SettingBoxKey.audioNormalization,
      leading: const Icon(Icons.multitrack_audio),
      getSubtitle: () {
        final audioNormalization = AudioNormalization.getTitleFromConfig(
          Pref.audioNormalization,
        );
        String fallback = Pref.fallbackNormalization;
        if (fallback == '0') {
          fallback = '';
        } else {
          fallback =
              '，无参数时:「${AudioNormalization.getTitleFromConfig(fallback)}」';
        }
        return '当前:「$audioNormalization」$fallback';
      },
      onTap: audioNormalization,
    ),
  SettingsModel(
    settingsType: SettingsType.normal,
    title: '超分辨率',
    leading: const Icon(Icons.stay_current_landscape_outlined),
    getSubtitle: () =>
        '当前:「${Pref.superResolutionType.title}」\n默认设置对番剧生效, 其他视频默认关闭\n超分辨率需要启用硬件解码, 若启用硬件解码后仍然不生效, 尝试切换硬件解码器为 auto-copy',
    onTap: (setState) async {
      SuperResolutionType? result = await showDialog(
        context: Get.context!,
        builder: (context) {
          return SelectDialog<SuperResolutionType>(
            title: '超分辨率',
            value: Pref.superResolutionType,
            values: SuperResolutionType.values
                .map((e) => (e, e.title))
                .toList(),
          );
        },
      );
      if (result != null) {
        await GStorage.setting.put(
          SettingBoxKey.superResolutionType,
          result.index,
        );
        setState();
      }
    },
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '提前初始化播放器',
    subtitle: '相对减少手动播放加载时间',
    leading: Icon(Icons.play_circle_outlined),
    setKey: SettingBoxKey.preInitPlayer,
    defaultVal: false,
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '首页切换页面动画',
    leading: Icon(Icons.home_outlined),
    setKey: SettingBoxKey.mainTabBarView,
    defaultVal: false,
    needReboot: true,
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '搜索建议',
    leading: Icon(Icons.search),
    setKey: SettingBoxKey.searchSuggestion,
    defaultVal: true,
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '记录搜索历史',
    leading: Icon(Icons.history),
    setKey: SettingBoxKey.recordSearchHistory,
    defaultVal: true,
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '展示头像/评论/动态装饰',
    leading: const Icon(MdiIcons.stickerCircleOutline),
    setKey: SettingBoxKey.showDynDecorate,
    defaultVal: true,
    onChanged: (value) => PendantAvatar.showDynDecorate = value,
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '预览 Live Photo',
    subtitle: '开启则以视频形式预览 Live Photo，否则预览静态图片',
    leading: const Icon(Icons.image_outlined),
    setKey: SettingBoxKey.enableLivePhoto,
    defaultVal: true,
    onChanged: (value) => ImageModel.enableLivePhoto = value,
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '滑动跳转预览视频缩略图',
    leading: Icon(Icons.preview_outlined),
    setKey: SettingBoxKey.showSeekPreview,
    defaultVal: true,
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '显示高能进度条',
    subtitle: '高能进度条反应了在时域上，单位时间内弹幕发送量的变化趋势',
    leading: Icon(Icons.show_chart),
    setKey: SettingBoxKey.showDmChart,
    defaultVal: false,
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '发评反诈',
    subtitle: '发送评论后检查评论是否可见',
    leading: Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Icon(Icons.shield_outlined),
        Icon(Icons.reply, size: 14),
      ],
    ),
    setKey: SettingBoxKey.enableCommAntifraud,
    defaultVal: false,
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '使用「哔哩发评反诈」检查评论',
    subtitle: '仅对Android生效',
    leading: Icon(
      FontAwesomeIcons.b,
      size: 22,
    ),
    setKey: SettingBoxKey.biliSendCommAntifraud,
    defaultVal: false,
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '发布/转发动态反诈',
    subtitle: '发布/转发动态后检查动态是否可见',
    leading: Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Icon(Icons.shield_outlined),
        Icon(Icons.motion_photos_on, size: 12),
      ],
    ),
    setKey: SettingBoxKey.enableCreateDynAntifraud,
    defaultVal: false,
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '屏蔽带货动态',
    leading: const Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Icon(Icons.shopping_bag_outlined, size: 14),
        Icon(Icons.not_interested),
      ],
    ),
    setKey: SettingBoxKey.antiGoodsDyn,
    defaultVal: false,
    onChanged: (value) {
      DynamicsDataModel.antiGoodsDyn = value;
    },
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '屏蔽带货评论',
    leading: const Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Icon(Icons.shopping_bag_outlined, size: 14),
        Icon(Icons.not_interested),
      ],
    ),
    setKey: SettingBoxKey.antiGoodsReply,
    defaultVal: false,
    onChanged: (value) {
      ReplyGrpc.antiGoodsReply = value;
    },
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '侧滑关闭二级页面',
    leading: Transform.rotate(
      angle: pi * 1.5,
      child: const Icon(Icons.touch_app),
    ),
    setKey: SettingBoxKey.slideDismissReplyPage,
    defaultVal: Platform.isIOS,
    onChanged: (value) {
      CommonSlideMixin.slideDismissReplyPage = value;
    },
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '启用双指缩小视频',
    leading: Icon(Icons.pinch),
    setKey: SettingBoxKey.enableShrinkVideoSize,
    defaultVal: true,
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '动态/专栏详情页展示底部操作栏',
    leading: Icon(Icons.more_horiz),
    setKey: SettingBoxKey.showDynActionBar,
    defaultVal: true,
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '启用拖拽字幕调整底部边距',
    leading: Icon(MdiIcons.dragVariant),
    setKey: SettingBoxKey.enableDragSubtitle,
    defaultVal: false,
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '展示追番时间表',
    leading: Icon(MdiIcons.chartTimelineVariantShimmer),
    setKey: SettingBoxKey.showPgcTimeline,
    defaultVal: true,
    needReboot: true,
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '静默下载图片',
    subtitle: '不显示下载 Loading 弹窗',
    leading: const Icon(Icons.download_for_offline_outlined),
    setKey: SettingBoxKey.silentDownImg,
    defaultVal: false,
    onChanged: (value) => ImageUtils.silentDownImg = value,
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    setKey: SettingBoxKey.feedBackEnable,
    onChanged: (value) {
      enableFeedback = value;
      feedBack();
    },
    leading: const Icon(Icons.vibration_outlined),
    title: '震动反馈',
    subtitle: '请确定手机设置中已开启震动反馈',
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '大家都在搜',
    subtitle: '是否展示「大家都在搜」',
    leading: Icon(Icons.data_thresholding_outlined),
    setKey: SettingBoxKey.enableHotKey,
    defaultVal: true,
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '搜索发现',
    subtitle: '是否展示「搜索发现」',
    leading: Icon(Icons.search_outlined),
    setKey: SettingBoxKey.enableSearchRcmd,
    defaultVal: true,
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '搜索默认词',
    subtitle: '是否展示搜索框默认词',
    leading: const Icon(Icons.whatshot_outlined),
    setKey: SettingBoxKey.enableSearchWord,
    defaultVal: true,
    onChanged: (val) {
      try {
        final controller = Get.find<HomeController>()..enableSearchWord = val;
        if (val) {
          controller.querySearchDefault();
        } else {
          controller.defaultSearch.value = '';
        }
      } catch (_) {}
    },
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '快速收藏',
    subtitle: '点击设置默认收藏夹\n点按收藏至默认，长按选择文件夹',
    leading: const Icon(Icons.bookmark_add_outlined),
    setKey: SettingBoxKey.enableQuickFav,
    onTap: () async {
      if (Accounts.main.isLogin) {
        final res = await FavHttp.allFavFolders(Accounts.main.mid);
        if (res.isSuccess) {
          final list = res.data.list;
          if (list == null || list.isEmpty) {
            return;
          }
          final quickFavId = Pref.quickFavId;
          Get.dialog(
            AlertDialog(
              clipBehavior: Clip.hardEdge,
              title: const Text('选择默认收藏夹'),
              contentPadding: const EdgeInsets.only(top: 5, bottom: 18),
              content: SingleChildScrollView(
                child: RadioGroup(
                  onChanged: (value) {
                    Get.back();
                    GStorage.setting.put(SettingBoxKey.quickFavId, value);
                    SmartDialog.showToast('设置成功');
                  },
                  groupValue: quickFavId,
                  child: Column(
                    children: list.map((item) {
                      return RadioListTile(
                        toggleable: true,
                        dense: true,
                        title: Text(item.title),
                        value: item.id,
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          );
        } else {
          res.toast();
        }
      }
    },
    defaultVal: false,
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '评论区搜索关键词',
    subtitle: '展示评论区搜索关键词',
    leading: const Icon(Icons.search_outlined),
    setKey: SettingBoxKey.enableWordRe,
    defaultVal: false,
    onChanged: (value) {
      ReplyItemGrpc.enableWordRe = value;
    },
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '启用AI总结',
    subtitle: '视频详情页开启AI总结',
    leading: Icon(Icons.engineering_outlined),
    setKey: SettingBoxKey.enableAi,
    defaultVal: false,
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '消息页禁用"收到的赞"功能',
    subtitle: '禁止打开入口，降低网络社交依赖',
    leading: Icon(Icons.beach_access_outlined),
    setKey: SettingBoxKey.disableLikeMsg,
    defaultVal: false,
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '默认展示评论区',
    subtitle: '在视频详情页默认切换至评论区页（仅Tab型布局）',
    leading: Icon(Icons.mode_comment_outlined),
    setKey: SettingBoxKey.defaultShowComment,
    defaultVal: false,
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '启用HTTP/2',
    leading: Icon(Icons.swap_horizontal_circle_outlined),
    setKey: SettingBoxKey.enableHttp2,
    defaultVal: false,
    needReboot: true,
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    title: '连接重试次数',
    subtitle: '为0时禁用',
    leading: const Icon(Icons.repeat),
    onTap: (setState) async {
      final result = await showDialog<double>(
        context: Get.context!,
        builder: (context) {
          return SlideDialog(
            title: '连接重试次数',
            min: 0,
            max: 8,
            divisions: 8,
            precise: 0,
            value: Pref.retryCount.toDouble(),
          );
        },
      );
      if (result != null) {
        await GStorage.setting.put(SettingBoxKey.retryCount, result.toInt());
        setState();
        SmartDialog.showToast('重启生效');
      }
    },
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    title: '连接重试间隔',
    subtitle: '实际间隔 = 间隔 * 第x次重试',
    leading: const Icon(Icons.more_time_outlined),
    onTap: (setState) async {
      final result = await showDialog<double>(
        context: Get.context!,
        builder: (context) {
          return SlideDialog(
            title: '连接重试间隔',
            min: 0,
            max: 1000,
            divisions: 10,
            precise: 0,
            value: Pref.retryDelay.toDouble(),
            suffix: 'ms',
          );
        },
      );
      if (result != null) {
        await GStorage.setting.put(SettingBoxKey.retryDelay, result.toInt());
        setState();
        SmartDialog.showToast('重启生效');
      }
    },
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    title: '评论展示',
    setKey: SettingBoxKey.replySortType,
    leading: const Icon(Icons.whatshot_outlined),
    getSubtitle: () =>
        '当前优先展示「${ReplySortType.values[Pref.replySortType].title}」',
    onTap: (setState) async {
      int? result = await showDialog(
        context: Get.context!,
        builder: (context) {
          return SelectDialog<int>(
            title: '评论展示',
            value: Pref.replySortType,
            values: ReplySortType.values
                .map((e) => (e.index, e.title))
                .toList(),
          );
        },
      );
      if (result != null) {
        await GStorage.setting.put(SettingBoxKey.replySortType, result);
        setState();
      }
    },
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    title: '动态展示',
    setKey: SettingBoxKey.defaultDynamicType,
    leading: const Icon(Icons.dynamic_feed_rounded),
    getSubtitle: () =>
        '当前优先展示「${DynamicsTabType.values[Pref.defaultDynamicType].label}」',
    onTap: (setState) async {
      int? result = await showDialog(
        context: Get.context!,
        builder: (context) {
          return SelectDialog<int>(
            title: '动态展示',
            value: Pref.defaultDynamicType,
            values: DynamicsTabType.values
                .sublist(0, 4)
                .map((e) => (e.index, e.label))
                .toList(),
          );
        },
      );
      if (result != null) {
        await GStorage.setting.put(SettingBoxKey.defaultDynamicType, result);
        setState();
      }
    },
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    title: '用户页默认展示TAB',
    setKey: SettingBoxKey.memberTab,
    leading: const Icon(Icons.tab),
    getSubtitle: () => '当前优先展示「${Pref.memberTab.title}」',
    onTap: (setState) async {
      MemberTabType? result = await showDialog(
        context: Get.context!,
        builder: (context) {
          return SelectDialog<MemberTabType>(
            title: '用户页默认展示TAB',
            value: Pref.memberTab,
            values: MemberTabType.values.map((e) => (e, e.title)).toList(),
          );
        },
      );
      if (result != null) {
        await GStorage.setting.put(SettingBoxKey.memberTab, result.index);
        setState();
      }
    },
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '显示UP主页小店TAB',
    leading: const Icon(Icons.shop_outlined),
    setKey: SettingBoxKey.showMemberShop,
    defaultVal: false,
    onChanged: (value) => MemberTabType.showMemberShop = value,
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    onTap: () {
      String systemProxyHost = Pref.systemProxyHost;
      String systemProxyPort = Pref.systemProxyPort;

      showDialog(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            title: const Text('设置代理'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 6),
                TextField(
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: systemProxyHost.isNotEmpty
                        ? systemProxyHost
                        : '请输入Host，使用 . 分割',
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                    hintText: systemProxyHost,
                  ),
                  onChanged: (e) => systemProxyHost = e,
                ),
                const SizedBox(height: 10),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: systemProxyPort.isNotEmpty
                        ? systemProxyPort
                        : '请输入Port',
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                    hintText: systemProxyPort,
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (e) => systemProxyPort = e,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: Get.back,
                child: Text(
                  '取消',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  GStorage.setting.put(
                    SettingBoxKey.systemProxyHost,
                    systemProxyHost,
                  );
                  GStorage.setting.put(
                    SettingBoxKey.systemProxyPort,
                    systemProxyPort,
                  );
                },
                child: const Text('确认'),
              ),
            ],
          );
        },
      );
    },
    leading: const Icon(Icons.airplane_ticket_outlined),
    title: '设置代理',
    subtitle: '设置代理 host:port',
    setKey: SettingBoxKey.enableSystemProxy,
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '自动清除缓存',
    subtitle: '每次启动时清除缓存',
    leading: Icon(Icons.auto_delete_outlined),
    setKey: SettingBoxKey.autoClearCache,
    defaultVal: false,
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    title: '最大缓存大小',
    getSubtitle: () {
      final num = Pref.maxCacheSize;
      return '当前最大缓存大小: 「${num == 0 ? '无限' : CacheManage.formatSize(Pref.maxCacheSize)}」';
    },
    onTap: (setState) {
      showDialog(
        context: Get.context!,
        builder: (context) {
          String valueStr = '';
          return AlertDialog(
            title: const Text('最大缓存大小'),
            content: TextField(
              autofocus: true,
              onChanged: (value) => valueStr = value,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d\.]+')),
              ],
              decoration: const InputDecoration(suffixText: 'MB'),
            ),
            actions: [
              TextButton(
                onPressed: Get.back,
                child: Text(
                  '取消',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Get.back();
                  num value = num.tryParse(valueStr) ?? 0;
                  await GStorage.setting.put(
                    SettingBoxKey.maxCacheSize,
                    value * 1024 * 1024,
                  );
                  setState();
                },
                child: const Text('确定'),
              ),
            ],
          );
        },
      );
    },
    leading: const Icon(Icons.delete_outlined),
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '检查更新',
    subtitle: '每次启动时检查是否需要更新',
    leading: const Icon(Icons.system_update_alt),
    setKey: SettingBoxKey.autoUpdate,
    defaultVal: true,
    onChanged: (val) {
      if (val) {
        Update.checkUpdate(false);
      }
    },
  ),
];

Future<void> audioNormalization(
  VoidCallback setState, {
  bool fallback = false,
}) async {
  final key = fallback
      ? SettingBoxKey.fallbackNormalization
      : SettingBoxKey.audioNormalization;
  final result = await showDialog<String>(
    context: Get.context!,
    builder: (context) {
      String audioNormalization = fallback
          ? Pref.fallbackNormalization
          : Pref.audioNormalization;
      Set<String> values = {
        '0',
        '1',
        if (!fallback) '2',
        audioNormalization,
        '3',
      };
      return SelectDialog<String>(
        title: fallback ? '服务器无loudnorm配置时使用' : '音量均衡',
        toggleable: true,
        value: audioNormalization,
        values: values
            .map(
              (e) => (
                e,
                switch (e) {
                  '0' => AudioNormalization.disable.title,
                  '1' => AudioNormalization.dynaudnorm.title,
                  '2' => AudioNormalization.loudnorm.title,
                  '3' => AudioNormalization.custom.title,
                  _ => e,
                },
              ),
            )
            .toList(),
      );
    },
  );
  if (result != null) {
    if (result == '3') {
      String param = '';
      await showDialog(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            title: const Text('自定义参数'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 16,
              children: [
                const Text('等同于 --lavfi-complex="[aid1] 参数 [ao]"'),
                TextField(
                  autofocus: true,
                  onChanged: (value) => param = value,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: Get.back,
                child: Text(
                  '取消',
                  style: TextStyle(
                    color: ColorScheme.of(context).outline,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Get.back();
                  await GStorage.setting.put(key, param);
                  if (!fallback &&
                      PlPlayerController.loudnormRegExp.hasMatch(param)) {
                    audioNormalization(setState, fallback: true);
                  }
                  setState();
                },
                child: const Text('确定'),
              ),
            ],
          );
        },
      );
    } else {
      await GStorage.setting.put(key, result);
      if (result == '2') {
        audioNormalization(setState, fallback: true);
      }
      setState();
    }
  }
}
