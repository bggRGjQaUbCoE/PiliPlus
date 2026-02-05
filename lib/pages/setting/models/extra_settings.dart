import 'dart:io';
import 'dart:math' show pi, max;

import 'package:PiliPlus/common/widgets/custom_icon.dart';
import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/gesture/horizontal_drag_gesture_recognizer.dart'
    show touchSlopH;
import 'package:PiliPlus/common/widgets/image/custom_grid_view.dart'
    show CustomGridView, ImageModel;
import 'package:PiliPlus/common/widgets/pendant_avatar.dart';
import 'package:PiliPlus/grpc/reply.dart';
import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/audio_normalization.dart';
import 'package:PiliPlus/models/common/dynamic/dynamics_type.dart';
import 'package:PiliPlus/models/common/member/tab_type.dart';
import 'package:PiliPlus/models/common/reply/reply_sort_type.dart';
import 'package:PiliPlus/models/common/sponsor_block/skip_type.dart';
import 'package:PiliPlus/models/common/super_resolution_type.dart';
import 'package:PiliPlus/models/dynamics/result.dart'
    show DynamicsDataModel, ItemModulesModel;
import 'package:PiliPlus/pages/common/slide/common_slide_page.dart';
import 'package:PiliPlus/pages/home/controller.dart';
import 'package:PiliPlus/pages/main/controller.dart';
import 'package:PiliPlus/pages/setting/models/model.dart';
import 'package:PiliPlus/pages/setting/widgets/select_dialog.dart';
import 'package:PiliPlus/pages/setting/widgets/slide_dialog.dart';
import 'package:PiliPlus/pages/video/reply/widgets/reply_item_grpc.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/services/download/download_service.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/cache_manager.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:PiliPlus/utils/path_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/update.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

List<SettingsModel> get extraSettings => [
  if (PlatformUtils.isDesktop) ...[
    SwitchModel(
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
    NormalModel(
      title: '缓存路径',
      getSubtitle: () => downloadPath,
      leading: const Icon(Icons.storage),
      onTap: _showDownPathDialog,
    ),
  ],
  SwitchModel(
    title: '空降助手',
    subtitle: '点击配置',
    setKey: SettingBoxKey.enableSponsorBlock,
    defaultVal: false,
    onTap: (context) => Get.toNamed('/sponsorBlock'),
    leading: const Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Icon(Icons.shield_outlined),
        Icon(Icons.play_arrow_rounded, size: 15),
      ],
    ),
  ),
  PopupModel<SkipType>(
    title: '番剧片头/片尾跳过类型',
    leading: const Icon(MdiIcons.debugStepOver),
    value: () => Pref.pgcSkipType,
    items: SkipType.values,
    onSelected: (value, setState) async {
      await GStorage.setting.put(SettingBoxKey.pgcSkipType, value.index);
      setState();
    },
  ),
  SwitchModel(
    title: '检查未读动态',
    subtitle: '点击设置检查周期(min)',
    leading: const Icon(Icons.notifications_none),
    setKey: SettingBoxKey.checkDynamic,
    defaultVal: true,
    onChanged: (value) => Get.find<MainController>().checkDynamic = value,
    onTap: _showDynDialog,
  ),
  SwitchModel(
    title: '显示视频分段信息',
    leading: Transform.rotate(
      angle: pi / 2,
      child: const Icon(MdiIcons.viewHeadline),
    ),
    setKey: SettingBoxKey.showViewPoints,
    defaultVal: true,
  ),
  const SwitchModel(
    title: '视频页显示相关视频',
    leading: Icon(MdiIcons.motionPlayOutline),
    setKey: SettingBoxKey.showRelatedVideo,
    defaultVal: true,
  ),
  const SwitchModel(
    title: '显示视频评论',
    leading: Icon(MdiIcons.commentTextOutline),
    setKey: SettingBoxKey.showVideoReply,
    defaultVal: true,
  ),
  const SwitchModel(
    title: '显示番剧评论',
    leading: Icon(MdiIcons.commentTextOutline),
    setKey: SettingBoxKey.showBangumiReply,
    defaultVal: true,
  ),
  const SwitchModel(
    title: '默认展开视频简介',
    leading: Icon(Icons.expand_more),
    setKey: SettingBoxKey.alwaysExpandIntroPanel,
    defaultVal: false,
  ),
  const SwitchModel(
    title: '横屏自动展开视频简介',
    leading: Icon(Icons.expand_more),
    setKey: SettingBoxKey.expandIntroPanelH,
    defaultVal: false,
  ),
  SwitchModel(
    title: '横屏分P/合集列表显示在Tab栏',
    leading: const Icon(Icons.format_list_numbered_rtl_sharp),
    setKey: SettingBoxKey.horizontalSeasonPanel,
    defaultVal: PlatformUtils.isDesktop,
  ),
  SwitchModel(
    title: '横屏播放页在侧栏打开UP主页',
    leading: const Icon(Icons.account_circle_outlined),
    setKey: SettingBoxKey.horizontalMemberPage,
    defaultVal: PlatformUtils.isDesktop,
  ),
  SwitchModel(
    title: '横屏在侧栏打开图片预览',
    leading: const Icon(Icons.photo_outlined),
    setKey: SettingBoxKey.horizontalPreview,
    defaultVal: false,
    onChanged: (value) => CustomGridView.horizontalPreview = value,
  ),
  NormalModel(
    title: '评论折叠行数',
    subtitle: '0行为不折叠',
    leading: const Icon(Icons.compress),
    getTrailing: (theme) => Text(
      '${ReplyItemGrpc.replyLengthLimit}行',
      style: theme.textTheme.titleSmall,
    ),
    onTap: _showReplyLengthDialog,
  ),
  NormalModel(
    title: '弹幕行高',
    subtitle: '默认1.6',
    leading: const Icon(CustomIcons.dm_settings),
    getTrailing: (theme) => Text(
      Pref.danmakuLineHeight.toString(),
      style: theme.textTheme.titleSmall,
    ),
    onTap: _showDmHeightDialog,
  ),
  const SwitchModel(
    title: '显示视频警告/争议信息',
    leading: Icon(Icons.warning_amber_rounded),
    setKey: SettingBoxKey.showArgueMsg,
    defaultVal: true,
  ),
  SwitchModel(
    title: '显示动态警告/争议信息',
    leading: const Icon(Icons.warning_amber_rounded),
    setKey: SettingBoxKey.showDynDispute,
    defaultVal: false,
    onChanged: (val) => ItemModulesModel.showDynDispute = val,
  ),
  const SwitchModel(
    title: '分P/合集：倒序播放从首集开始播放',
    subtitle: '开启则自动切换为倒序首集，否则保持当前集',
    leading: Icon(MdiIcons.sort),
    setKey: SettingBoxKey.reverseFromFirst,
    defaultVal: true,
  ),
  const SwitchModel(
    title: '禁用 SSL 证书验证',
    subtitle: '谨慎开启，禁用容易受到中间人攻击',
    leading: Icon(Icons.security),
    needReboot: true,
    setKey: SettingBoxKey.badCertificateCallback,
  ),
  const SwitchModel(
    title: '显示继续播放分P提示',
    leading: Icon(Icons.local_parking),
    setKey: SettingBoxKey.continuePlayingPart,
    defaultVal: true,
  ),
  getBanWordModel(
    title: '评论关键词过滤',
    key: SettingBoxKey.banWordForReply,
    onChanged: (value) {
      ReplyGrpc.replyRegExp = value;
      ReplyGrpc.enableFilter = value.pattern.isNotEmpty;
    },
  ),
  getBanWordModel(
    title: '动态关键词过滤',
    key: SettingBoxKey.banWordForDyn,
    onChanged: (value) {
      DynamicsDataModel.banWordForDyn = value;
      DynamicsDataModel.enableFilter = value.pattern.isNotEmpty;
    },
  ),
  const SwitchModel(
    title: '使用外部浏览器打开链接',
    leading: Icon(Icons.open_in_browser),
    setKey: SettingBoxKey.openInBrowser,
    defaultVal: false,
  ),
  NormalModel(
    title: '横向滑动阈值',
    getSubtitle: () => '当前:「${Pref.touchSlopH}」',
    onTap: _showTouchSlopDialog,
    leading: const Icon(Icons.pan_tool_alt_outlined),
  ),
  NormalModel(
    title: '刷新滑动距离',
    leading: const Icon(Icons.refresh),
    getSubtitle: () => '当前滑动距离: ${Pref.refreshDragPercentage}x',
    onTap: _showRefreshDragDialog,
  ),
  NormalModel(
    title: '刷新指示器高度',
    leading: const Icon(Icons.height),
    getSubtitle: () => '当前指示器高度: ${Pref.refreshDisplacement}',
    onTap: _showRefreshDialog,
  ),
  const SwitchModel(
    title: '显示会员彩色弹幕',
    leading: Icon(MdiIcons.gradientHorizontal),
    setKey: SettingBoxKey.showVipDanmaku,
    defaultVal: true,
  ),
  const SwitchModel(
    title: '合并弹幕',
    subtitle: '合并一段时间内获取到的相同弹幕',
    leading: Icon(Icons.merge),
    setKey: SettingBoxKey.mergeDanmaku,
    defaultVal: false,
  ),
  const SwitchModel(
    title: '显示热门推荐',
    subtitle: '热门页面显示每周必看等推荐内容入口',
    leading: Icon(Icons.local_fire_department_outlined),
    setKey: SettingBoxKey.showHotRcmd,
    defaultVal: false,
    needReboot: true,
  ),
  if (kDebugMode || Platform.isAndroid)
    NormalModel(
      title: '音量均衡',
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
  NormalModel(
    title: '超分辨率',
    leading: const Icon(Icons.stay_current_landscape_outlined),
    getSubtitle: () =>
        '当前:「${Pref.superResolutionType.label}」\n默认设置对番剧生效, 其他视频默认关闭\n超分辨率需要启用硬件解码, 若启用硬件解码后仍然不生效, 尝试切换硬件解码器为 auto-copy',
    onTap: _showSuperResolutionDialog,
  ),
  const SwitchModel(
    title: '提前初始化播放器',
    subtitle: '相对减少手动播放加载时间',
    leading: Icon(Icons.play_circle_outlined),
    setKey: SettingBoxKey.preInitPlayer,
    defaultVal: false,
  ),
  const SwitchModel(
    title: '首页切换页面动画',
    leading: Icon(Icons.home_outlined),
    setKey: SettingBoxKey.mainTabBarView,
    defaultVal: false,
    needReboot: true,
  ),
  const SwitchModel(
    title: '搜索建议',
    leading: Icon(Icons.search),
    setKey: SettingBoxKey.searchSuggestion,
    defaultVal: true,
  ),
  const SwitchModel(
    title: '记录搜索历史',
    leading: Icon(Icons.history),
    setKey: SettingBoxKey.recordSearchHistory,
    defaultVal: true,
  ),
  SwitchModel(
    title: '展示头像/评论/动态装饰',
    leading: const Icon(MdiIcons.stickerCircleOutline),
    setKey: SettingBoxKey.showDynDecorate,
    defaultVal: true,
    onChanged: (value) => PendantAvatar.showDynDecorate = value,
  ),
  SwitchModel(
    title: '预览 Live Photo',
    subtitle: '开启则以视频形式预览 Live Photo，否则预览静态图片',
    leading: const Icon(Icons.image_outlined),
    setKey: SettingBoxKey.enableLivePhoto,
    defaultVal: true,
    onChanged: (value) => ImageModel.enableLivePhoto = value,
  ),
  const SwitchModel(
    title: '滑动跳转预览视频缩略图',
    leading: Icon(Icons.preview_outlined),
    setKey: SettingBoxKey.showSeekPreview,
    defaultVal: true,
  ),
  const SwitchModel(
    title: '显示高能进度条',
    subtitle: '高能进度条反应了在时域上，单位时间内弹幕发送量的变化趋势',
    leading: Icon(Icons.show_chart),
    setKey: SettingBoxKey.showDmChart,
    defaultVal: false,
  ),
  const SwitchModel(
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
  if (Platform.isAndroid)
    const SwitchModel(
      title: '使用「哔哩发评反诈」检查评论',
      leading: Icon(
        FontAwesomeIcons.b,
        size: 22,
      ),
      setKey: SettingBoxKey.biliSendCommAntifraud,
      defaultVal: false,
    ),
  const SwitchModel(
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
  SwitchModel(
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
    onChanged: (value) => DynamicsDataModel.antiGoodsDyn = value,
  ),
  SwitchModel(
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
    onChanged: (value) => ReplyGrpc.antiGoodsReply = value,
  ),
  SwitchModel(
    title: '侧滑关闭二级页面',
    leading: Transform.rotate(
      angle: pi * 1.5,
      child: const Icon(Icons.touch_app),
    ),
    setKey: SettingBoxKey.slideDismissReplyPage,
    defaultVal: Platform.isIOS,
    onChanged: (value) => CommonSlideMixin.slideDismissReplyPage = value,
  ),
  const SwitchModel(
    title: '启用双指缩小视频',
    leading: Icon(Icons.pinch),
    setKey: SettingBoxKey.enableShrinkVideoSize,
    defaultVal: true,
  ),
  const SwitchModel(
    title: '动态/专栏详情页展示底部操作栏',
    leading: Icon(Icons.more_horiz),
    setKey: SettingBoxKey.showDynActionBar,
    defaultVal: true,
  ),
  const SwitchModel(
    title: '启用拖拽字幕调整底部边距',
    leading: Icon(MdiIcons.dragVariant),
    setKey: SettingBoxKey.enableDragSubtitle,
    defaultVal: false,
  ),
  const SwitchModel(
    title: '展示追番时间表',
    leading: Icon(MdiIcons.chartTimelineVariantShimmer),
    setKey: SettingBoxKey.showPgcTimeline,
    defaultVal: true,
    needReboot: true,
  ),
  SwitchModel(
    title: '静默下载图片',
    subtitle: '不显示下载 Loading 弹窗',
    leading: const Icon(Icons.download_for_offline_outlined),
    setKey: SettingBoxKey.silentDownImg,
    defaultVal: false,
    onChanged: (value) => ImageUtils.silentDownImg = value,
  ),
  SwitchModel(
    title: '长按/右键显示图片菜单',
    leading: const Icon(Icons.menu),
    setKey: SettingBoxKey.enableImgMenu,
    defaultVal: false,
    onChanged: (value) => CustomGridView.enableImgMenu = value,
  ),
  SwitchModel(
    setKey: SettingBoxKey.feedBackEnable,
    onChanged: (value) {
      enableFeedback = value;
      feedBack();
    },
    leading: const Icon(Icons.vibration_outlined),
    title: '震动反馈',
    subtitle: '请确定手机设置中已开启震动反馈',
  ),
  const SwitchModel(
    title: '大家都在搜',
    subtitle: '是否展示「大家都在搜」',
    leading: Icon(Icons.data_thresholding_outlined),
    setKey: SettingBoxKey.enableHotKey,
    defaultVal: true,
  ),
  const SwitchModel(
    title: '搜索发现',
    subtitle: '是否展示「搜索发现」',
    leading: Icon(Icons.search_outlined),
    setKey: SettingBoxKey.enableSearchRcmd,
    defaultVal: true,
  ),
  SwitchModel(
    title: '搜索默认词',
    subtitle: '是否展示搜索框默认词',
    leading: const Icon(Icons.whatshot_outlined),
    setKey: SettingBoxKey.enableSearchWord,
    defaultVal: false,
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
  const SwitchModel(
    title: '快速收藏',
    subtitle: '点击设置默认收藏夹\n点按收藏至默认，长按选择文件夹',
    leading: Icon(Icons.bookmark_add_outlined),
    setKey: SettingBoxKey.enableQuickFav,
    onTap: _showFavDialog,
    defaultVal: false,
  ),
  SwitchModel(
    title: '评论区搜索关键词',
    subtitle: '展示评论区搜索关键词',
    leading: const Icon(Icons.search_outlined),
    setKey: SettingBoxKey.enableWordRe,
    defaultVal: false,
    onChanged: (value) => ReplyItemGrpc.enableWordRe = value,
  ),
  const SwitchModel(
    title: '启用AI总结',
    subtitle: '视频详情页开启AI总结',
    leading: Icon(Icons.engineering_outlined),
    setKey: SettingBoxKey.enableAi,
    defaultVal: false,
  ),
  const SwitchModel(
    title: '消息页禁用"收到的赞"功能',
    subtitle: '禁止打开入口，降低网络社交依赖',
    leading: Icon(Icons.beach_access_outlined),
    setKey: SettingBoxKey.disableLikeMsg,
    defaultVal: false,
  ),
  const SwitchModel(
    title: '默认展示评论区',
    subtitle: '在视频详情页默认切换至评论区页（仅Tab型布局）',
    leading: Icon(Icons.mode_comment_outlined),
    setKey: SettingBoxKey.defaultShowComment,
    defaultVal: false,
  ),
  const SwitchModel(
    title: '启用HTTP/2',
    leading: Icon(Icons.swap_horizontal_circle_outlined),
    setKey: SettingBoxKey.enableHttp2,
    defaultVal: false,
    needReboot: true,
  ),
  const NormalModel(
    title: '连接重试次数',
    subtitle: '为0时禁用',
    leading: Icon(Icons.repeat),
    onTap: _showReplyCountDialog,
  ),
  const NormalModel(
    title: '连接重试间隔',
    subtitle: '实际间隔 = 间隔 * 第x次重试',
    leading: Icon(Icons.more_time_outlined),
    onTap: _showReplyDelayDialog,
  ),
  NormalModel(
    title: '评论展示',
    leading: const Icon(Icons.whatshot_outlined),
    getSubtitle: () => '当前优先展示「${Pref.replySortType.title}」',
    onTap: _showReplySortDialog,
  ),
  NormalModel(
    title: '动态展示',
    leading: const Icon(Icons.dynamic_feed_rounded),
    getSubtitle: () => '当前优先展示「${Pref.defaultDynamicType.label}」',
    onTap: _showDefDynDialog,
  ),
  SwitchModel(
    title: '显示动态互动内容',
    subtitle: '开启后则在动态卡片底部显示互动内容（如关注的人点赞、热评等）',
    leading: const Icon(Icons.quickreply_outlined),
    setKey: SettingBoxKey.showDynInteraction,
    defaultVal: true,
    onChanged: (val) => ItemModulesModel.showDynInteraction = val,
  ),
  NormalModel(
    title: '用户页默认展示TAB',
    leading: const Icon(Icons.tab),
    getSubtitle: () => '当前优先展示「${Pref.memberTab.title}」',
    onTap: _showMemberTabDialog,
  ),
  SwitchModel(
    title: '显示UP主页小店TAB',
    leading: const Icon(Icons.shop_outlined),
    setKey: SettingBoxKey.showMemberShop,
    defaultVal: false,
    onChanged: (value) => MemberTabType.showMemberShop = value,
  ),
  const SwitchModel(
    leading: Icon(Icons.airplane_ticket_outlined),
    title: '设置代理',
    subtitle: '设置代理 host:port',
    setKey: SettingBoxKey.enableSystemProxy,
    onTap: _showProxyDialog,
  ),
  const SwitchModel(
    title: '自动清除缓存',
    subtitle: '每次启动时清除缓存',
    leading: Icon(Icons.auto_delete_outlined),
    setKey: SettingBoxKey.autoClearCache,
    defaultVal: false,
  ),
  NormalModel(
    title: '最大缓存大小',
    getSubtitle: () {
      final num = Pref.maxCacheSize;
      return '当前最大缓存大小: 「${num == 0 ? '无限' : CacheManager.formatSize(Pref.maxCacheSize)}」';
    },
    leading: const Icon(Icons.delete_outlined),
    onTap: _showCacheDialog,
  ),
  SwitchModel(
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
  BuildContext context,
  VoidCallback setState, {
  bool fallback = false,
}) async {
  final key = fallback
      ? SettingBoxKey.fallbackNormalization
      : SettingBoxKey.audioNormalization;
  final res = await showDialog<String>(
    context: context,
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
  if (res != null && context.mounted) {
    if (res == '3') {
      String param = '';
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
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
                style: TextStyle(color: ColorScheme.of(context).outline),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                GStorage.setting.put(key, param);
                if (!fallback &&
                    PlPlayerController.loudnormRegExp.hasMatch(param)) {
                  audioNormalization(context, setState, fallback: true);
                }
                setState();
              },
              child: const Text('确定'),
            ),
          ],
        ),
      );
    } else {
      GStorage.setting.put(key, res);
      if (res == '2') {
        audioNormalization(context, setState, fallback: true);
      }
      setState();
    }
  }
}

void _showDownPathDialog(BuildContext context, VoidCallback setState) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      clipBehavior: Clip.hardEdge,
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: () {
              Get.back();
              Utils.copyText(downloadPath);
            },
            dense: true,
            title: const Text('复制', style: TextStyle(fontSize: 14)),
          ),
          ListTile(
            onTap: () {
              Get.back();
              final defPath = defDownloadPath;
              if (downloadPath == defPath) return;
              downloadPath = defPath;
              setState();
              Get.find<DownloadService>().initDownloadList();
              GStorage.setting.delete(SettingBoxKey.downloadPath);
            },
            dense: true,
            title: const Text('重置', style: TextStyle(fontSize: 14)),
          ),
          ListTile(
            onTap: () async {
              Get.back();
              final path = await FilePicker.platform.getDirectoryPath();
              if (path == null || path == downloadPath) return;
              downloadPath = path;
              setState();
              Get.find<DownloadService>().initDownloadList();
              GStorage.setting.put(SettingBoxKey.downloadPath, path);
            },
            dense: true,
            title: const Text('设置新路径', style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    ),
  );
}

void _showDynDialog(BuildContext context) {
  String dynamicPeriod = Pref.dynamicPeriod.toString();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('检查周期'),
      content: TextFormField(
        autofocus: true,
        initialValue: dynamicPeriod,
        keyboardType: TextInputType.number,
        onChanged: (value) => dynamicPeriod = value,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(suffixText: 'min'),
      ),
      actions: [
        TextButton(
          onPressed: Get.back,
          child: Text(
            '取消',
            style: TextStyle(color: ColorScheme.of(context).outline),
          ),
        ),
        TextButton(
          onPressed: () {
            try {
              final val = int.parse(dynamicPeriod);
              Get.back();
              GStorage.setting.put(SettingBoxKey.dynamicPeriod, val);
              Get.find<MainController>().dynamicPeriod = val * 60 * 1000;
            } catch (e) {
              SmartDialog.showToast(e.toString());
            }
          },
          child: const Text('确定'),
        ),
      ],
    ),
  );
}

void _showReplyLengthDialog(BuildContext context, VoidCallback setState) {
  String replyLengthLimit = ReplyItemGrpc.replyLengthLimit.toString();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('评论折叠行数'),
      content: TextFormField(
        autofocus: true,
        initialValue: replyLengthLimit,
        keyboardType: TextInputType.number,
        onChanged: (value) => replyLengthLimit = value,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(suffixText: '行'),
      ),
      actions: [
        TextButton(
          onPressed: Get.back,
          child: Text(
            '取消',
            style: TextStyle(color: ColorScheme.of(context).outline),
          ),
        ),
        TextButton(
          onPressed: () async {
            try {
              final val = int.parse(replyLengthLimit);
              Get.back();
              ReplyItemGrpc.replyLengthLimit = val == 0 ? null : val;
              await GStorage.setting.put(SettingBoxKey.replyLengthLimit, val);
              setState();
            } catch (e) {
              SmartDialog.showToast(e.toString());
            }
          },
          child: const Text('确定'),
        ),
      ],
    ),
  );
}

void _showDmHeightDialog(BuildContext context, VoidCallback setState) {
  String danmakuLineHeight = Pref.danmakuLineHeight.toString();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('弹幕行高'),
      content: TextFormField(
        autofocus: true,
        initialValue: danmakuLineHeight,
        keyboardType: const .numberWithOptions(decimal: true),
        onChanged: (value) => danmakuLineHeight = value,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[\d\.]+')),
        ],
      ),
      actions: [
        TextButton(
          onPressed: Get.back,
          child: Text(
            '取消',
            style: TextStyle(color: ColorScheme.of(context).outline),
          ),
        ),
        TextButton(
          onPressed: () async {
            try {
              final val = max(
                1.0,
                double.parse(danmakuLineHeight).toPrecision(1),
              );
              Get.back();
              await GStorage.setting.put(SettingBoxKey.danmakuLineHeight, val);
              setState();
            } catch (e) {
              SmartDialog.showToast(e.toString());
            }
          },
          child: const Text('确定'),
        ),
      ],
    ),
  );
}

void _showTouchSlopDialog(BuildContext context, VoidCallback setState) {
  String initialValue = Pref.touchSlopH.toString();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('横向滑动阈值'),
      content: TextFormField(
        autofocus: true,
        initialValue: initialValue,
        keyboardType: const .numberWithOptions(decimal: true),
        onChanged: (value) => initialValue = value,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[\d\.]+')),
        ],
      ),
      actions: [
        TextButton(
          onPressed: Get.back,
          child: Text(
            '取消',
            style: TextStyle(color: ColorScheme.of(context).outline),
          ),
        ),
        TextButton(
          onPressed: () async {
            try {
              final val = double.parse(initialValue);
              Get.back();
              touchSlopH = val;
              await GStorage.setting.put(SettingBoxKey.touchSlopH, val);
              setState();
            } catch (e) {
              SmartDialog.showToast(e.toString());
            }
          },
          child: const Text('确定'),
        ),
      ],
    ),
  );
}

Future<void> _showRefreshDragDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<double>(
    context: context,
    builder: (context) => SlideDialog(
      title: '刷新滑动距离',
      min: 0.1,
      max: 0.5,
      divisions: 8,
      precise: 2,
      value: Pref.refreshDragPercentage,
      suffix: 'x',
    ),
  );
  if (res != null) {
    kDragContainerExtentPercentage = res;
    await GStorage.setting.put(SettingBoxKey.refreshDragPercentage, res);
    Get.forceAppUpdate();
  }
}

Future<void> _showRefreshDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<double>(
    context: context,
    builder: (context) => SlideDialog(
      title: '刷新指示器高度',
      min: 10.0,
      max: 100.0,
      divisions: 9,
      value: Pref.refreshDisplacement,
    ),
  );
  if (res != null) {
    displacement = res;
    await GStorage.setting.put(SettingBoxKey.refreshDisplacement, res);
    Get.forceAppUpdate();
  }
}

Future<void> _showSuperResolutionDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<SuperResolutionType>(
    context: context,
    builder: (context) => SelectDialog<SuperResolutionType>(
      title: '超分辨率',
      value: Pref.superResolutionType,
      values: SuperResolutionType.values.map((e) => (e, e.label)).toList(),
    ),
  );
  if (res != null) {
    await GStorage.setting.put(
      SettingBoxKey.superResolutionType,
      res.index,
    );
    setState();
  }
}

Future<void> _showFavDialog(BuildContext context) async {
  if (Accounts.main.isLogin) {
    final res = await FavHttp.allFavFolders(Accounts.main.mid);
    if (res case Success(:final response)) {
      final list = response.list;
      if (list == null || list.isEmpty) {
        return;
      }
      final quickFavId = Pref.quickFavId;
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
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
                children: list
                    .map(
                      (item) => RadioListTile(
                        toggleable: true,
                        dense: true,
                        title: Text(item.title),
                        value: item.id,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      );
    } else {
      res.toast();
    }
  }
}

Future<void> _showReplyCountDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<double>(
    context: context,
    builder: (context) => SlideDialog(
      title: '连接重试次数',
      min: 0,
      max: 8,
      divisions: 8,
      precise: 0,
      value: Pref.retryCount.toDouble(),
    ),
  );
  if (res != null) {
    await GStorage.setting.put(SettingBoxKey.retryCount, res.toInt());
    setState();
    SmartDialog.showToast('重启生效');
  }
}

Future<void> _showReplyDelayDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<double>(
    context: context,
    builder: (context) => SlideDialog(
      title: '连接重试间隔',
      min: 0,
      max: 1000,
      divisions: 10,
      precise: 0,
      value: Pref.retryDelay.toDouble(),
      suffix: 'ms',
    ),
  );
  if (res != null) {
    await GStorage.setting.put(SettingBoxKey.retryDelay, res.toInt());
    setState();
    SmartDialog.showToast('重启生效');
  }
}

Future<void> _showReplySortDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<ReplySortType>(
    context: context,
    builder: (context) => SelectDialog<ReplySortType>(
      title: '评论展示',
      value: Pref.replySortType,
      values: ReplySortType.values.map((e) => (e, e.title)).toList(),
    ),
  );
  if (res != null) {
    await GStorage.setting.put(SettingBoxKey.replySortType, res.index);
    setState();
  }
}

Future<void> _showDefDynDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<DynamicsTabType>(
    context: context,
    builder: (context) => SelectDialog<DynamicsTabType>(
      title: '动态展示',
      value: Pref.defaultDynamicType,
      values: DynamicsTabType.values.take(4).map((e) => (e, e.label)).toList(),
    ),
  );
  if (res != null) {
    await GStorage.setting.put(
      SettingBoxKey.defaultDynamicType,
      res.index,
    );
    setState();
  }
}

Future<void> _showMemberTabDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<MemberTabType>(
    context: context,
    builder: (context) => SelectDialog<MemberTabType>(
      title: '用户页默认展示TAB',
      value: Pref.memberTab,
      values: MemberTabType.values.map((e) => (e, e.title)).toList(),
    ),
  );
  if (res != null) {
    await GStorage.setting.put(SettingBoxKey.memberTab, res.index);
    setState();
  }
}

void _showProxyDialog(BuildContext context) {
  String systemProxyHost = Pref.systemProxyHost;
  String systemProxyPort = Pref.systemProxyPort;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('设置代理'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 6),
          TextFormField(
            initialValue: systemProxyHost,
            decoration: const InputDecoration(
              isDense: true,
              labelText: '请输入Host，使用 . 分割',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
            ),
            onChanged: (e) => systemProxyHost = e,
          ),
          const SizedBox(height: 10),
          TextFormField(
            initialValue: systemProxyPort,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              isDense: true,
              labelText: '请输入Port',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
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
            style: TextStyle(color: ColorScheme.of(context).outline),
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
    ),
  );
}

void _showCacheDialog(BuildContext context, VoidCallback setState) {
  String valueStr = '';
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
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
            style: TextStyle(color: ColorScheme.of(context).outline),
          ),
        ),
        TextButton(
          onPressed: () async {
            try {
              final val = num.parse(valueStr);
              Get.back();
              await GStorage.setting.put(
                SettingBoxKey.maxCacheSize,
                val * 1024 * 1024,
              );
              setState();
            } catch (e) {
              SmartDialog.showToast(e.toString());
            }
          },
          child: const Text('确定'),
        ),
      ],
    ),
  );
}
