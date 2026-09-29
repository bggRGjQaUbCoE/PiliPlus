import 'dart:io' show Platform, Directory;
import 'dart:math' show max;

import 'package:PiliPlus/common/widgets/custom_icon.dart';
import 'package:PiliPlus/common/widgets/dialog/simple_dialog_option.dart';
import 'package:PiliPlus/common/widgets/emote_tooltip.dart';
import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart'
    show RefreshIndicator, displacement, refreshDragExtent;
import 'package:PiliPlus/common/widgets/gesture/horizontal_drag_gesture_recognizer.dart'
    show deviceTouchSlop, touchSlopH;
import 'package:PiliPlus/common/widgets/image_grid/image_grid_view.dart'
    show ImageGridView, ImageModel;
import 'package:PiliPlus/common/widgets/pendant_avatar.dart';
import 'package:PiliPlus/grpc/reply.dart';
import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/l10n/l10n.dart';
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
import 'package:PiliPlus/pages/setting/widgets/slider_dialog.dart';
import 'package:PiliPlus/pages/video/reply/widgets/reply_item_grpc.dart';
import 'package:PiliPlus/services/download/download_service.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/android/bindings.g.dart';
import 'package:PiliPlus/utils/cache_manager.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/filtering_text.dart';
import 'package:PiliPlus/utils/global_data.dart';
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
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:material_ui/material_ui.dart' hide RefreshIndicator;

List<SettingsModel> get extraSettings => [
  if (PlatformUtils.isDesktop) ...[
    SwitchModel(
      title: L10n.current.minimizeOnExitExtraSettingsTitle,
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
      title: L10n.current.pagesSettingModelsExtraSettingsExtraSettingsTitle,
      getSubtitle: () => downloadPath,
      leading: const Icon(Icons.storage),
      onTap: _showDownPathDialog,
    ),
  ] else if (Platform.isAndroid)
    SwitchModel(
      title: L10n.current.enableDocProviderExtraSettingsTitle,
      subtitle: L10n.current.enableDocProviderExtraSettingsSubtitle,
      leading: const Icon(Icons.storage),
      setKey: SettingBoxKey.enableDocProvider,
      defaultVal: Pref.enableDocProvider,
      onChanged: AndroidHelper.updateDocProvider,
    ),
  SplitModel(
    normalModel: NormalModel.split(
      title: L10n.current.pagesSettingModelsExtraSettingsExtraSettingsTitle2,
      subtitle:
          L10n.current.pagesSettingModelsExtraSettingsExtraSettingsSubtitle,
      leading: const Icon(CustomIcons.shield_play_arrow),
    ),
    switchModel: SwitchModel.split(
      defaultVal: false,
      setKey: SettingBoxKey.enableSponsorBlock,
      onTap: (context) => Get.toNamed('/sponsorBlock'),
    ),
  ),
  PopupModel<SkipType>(
    title: L10n.current.pagesSettingModelsExtraSettingsExtraSettingsTitle19,
    leading: const Icon(MdiIcons.debugStepOver),
    value: () => Pref.pgcSkipType,
    items: SkipType.values,
    onSelected: (value, setState) => GStorage.setting
        .put(SettingBoxKey.pgcSkipType, value.index)
        .whenComplete(setState),
  ),
  SplitModel(
    normalModel: NormalModel.split(
      title: L10n.current.pagesSettingModelsExtraSettingsExtraSettingsTitle8,
      subtitle:
          L10n.current.pagesSettingModelsExtraSettingsExtraSettingsSubtitle5,
      leading: const Icon(Icons.notifications_none),
    ),
    switchModel: SwitchModel.split(
      defaultVal: true,
      setKey: SettingBoxKey.checkDynamic,
      onChanged: (value) => Get.find<MainController>().checkDynamic = value,
      onTap: _showDynDialog,
    ),
  ),
  SwitchModel(
    title: L10n.current.showViewPointsExtraSettingsTitle,
    leading: const Icon(CustomIcons.view_headline_rotate_90),
    setKey: SettingBoxKey.showViewPoints,
    defaultVal: true,
  ),
  SwitchModel(
    title: L10n.current.showRelatedVideoExtraSettingsTitle,
    leading: const Icon(MdiIcons.motionPlayOutline),
    setKey: SettingBoxKey.showRelatedVideo,
    defaultVal: true,
  ),
  SwitchModel(
    title: L10n.current.showVideoReplyExtraSettingsTitle,
    leading: const Icon(MdiIcons.commentTextOutline),
    setKey: SettingBoxKey.showVideoReply,
    defaultVal: true,
  ),
  SwitchModel(
    title: L10n.current.showBangumiReplyExtraSettingsTitle,
    leading: const Icon(MdiIcons.commentTextOutline),
    setKey: SettingBoxKey.showBangumiReply,
    defaultVal: true,
  ),
  SwitchModel(
    title: L10n.current.alwaysExpandIntroPanelExtraSettingsTitle,
    leading: const Icon(Icons.expand_more),
    setKey: SettingBoxKey.alwaysExpandIntroPanel,
    defaultVal: false,
  ),
  SwitchModel(
    title: L10n.current.expandIntroPanelHExtraSettingsTitle,
    leading: const Icon(Icons.expand_more),
    setKey: SettingBoxKey.expandIntroPanelH,
    defaultVal: false,
  ),
  SwitchModel(
    title: L10n.current.horizontalSeasonPanelExtraSettingsTitle,
    leading: const Icon(Icons.format_list_numbered_rtl_sharp),
    setKey: SettingBoxKey.horizontalSeasonPanel,
    defaultVal: Pref.horizontalScreen,
  ),
  SwitchModel(
    title: L10n.current.horizontalMemberPageExtraSettingsTitle,
    leading: const Icon(Icons.account_circle_outlined),
    setKey: SettingBoxKey.horizontalMemberPage,
    defaultVal: Pref.horizontalScreen,
  ),
  SwitchModel(
    title: L10n.current.horizontalPreviewExtraSettingsTitle,
    leading: const Icon(Icons.photo_outlined),
    setKey: SettingBoxKey.horizontalPreview,
    defaultVal: false,
    onChanged: (value) => ImageGridView.horizontalPreview = value,
  ),
  NormalModel(
    title: L10n.current.pagesSettingModelsExtraSettingsExtraSettingsTitle9,
    subtitle:
        L10n.current.pagesSettingModelsExtraSettingsExtraSettingsSubtitle4,
    leading: const Icon(Icons.compress),
    getTrailing: (theme) => Text(
      L10n.current.pagesSettingModelsExtraSettingsExtraSettingsGetTrailing(
        ReplyItemGrpc.replyLengthLimit.toString(),
      ),
      style: theme.textTheme.titleSmall,
    ),
    onTap: _showReplyLengthDialog,
  ),
  NormalModel(
    title: L10n.current.pagesSettingModelsExtraSettingsExtraSettingsTitle3,
    subtitle:
        L10n.current.pagesSettingModelsExtraSettingsExtraSettingsSubtitle2,
    leading: const Icon(CustomIcons.dm_settings),
    getTrailing: (theme) => Text(
      Pref.danmakuLineHeight.toString(),
      style: theme.textTheme.titleSmall,
    ),
    onTap: _showDmHeightDialog,
  ),
  SwitchModel(
    title: L10n.current.showArgueMsgExtraSettingsTitle,
    leading: const Icon(Icons.warning_amber_rounded),
    setKey: SettingBoxKey.showArgueMsg,
    defaultVal: true,
  ),
  SwitchModel(
    title: L10n.current.showDynDisputeExtraSettingsTitle,
    leading: const Icon(Icons.warning_amber_rounded),
    setKey: SettingBoxKey.showDynDispute,
    defaultVal: false,
    onChanged: (val) => ItemModulesModel.showDynDispute = val,
  ),
  SwitchModel(
    title: L10n.current.reverseFromFirstExtraSettingsTitle,
    subtitle: L10n.current.reverseFromFirstExtraSettingsSubtitle,
    leading: const Icon(MdiIcons.sort),
    setKey: SettingBoxKey.reverseFromFirst,
    defaultVal: true,
  ),
  SwitchModel(
    title: L10n.current.badCertificateCallbackExtraSettingsTitle,
    subtitle: L10n.current.badCertificateCallbackExtraSettingsSubtitle,
    leading: const Icon(Icons.security),
    needReboot: true,
    setKey: SettingBoxKey.badCertificateCallback,
  ),
  SwitchModel(
    title: L10n.current.continuePlayingPartExtraSettingsTitle,
    leading: const Icon(Icons.local_parking),
    setKey: SettingBoxKey.continuePlayingPart,
    defaultVal: true,
  ),
  getBanWordModel(
    title: L10n.current.pagesSettingModelsExtraSettingsExtraSettingsTitle14,
    key: SettingBoxKey.banWordForReply,
    onChanged: (value) {
      ReplyGrpc.replyRegExp = value;
      ReplyGrpc.enableFilter = value.pattern.isNotEmpty;
    },
  ),
  getBanWordModel(
    title: L10n.current.pagesSettingModelsExtraSettingsExtraSettingsTitle15,
    key: SettingBoxKey.banWordForDyn,
    onChanged: (value) {
      DynamicsDataModel.banWordForDyn = value;
      DynamicsDataModel.enableFilter = value.pattern.isNotEmpty;
    },
  ),
  SwitchModel(
    title: L10n.current.openInBrowserExtraSettingsTitle,
    leading: const Icon(Icons.open_in_browser),
    setKey: SettingBoxKey.openInBrowser,
    defaultVal: false,
  ),
  NormalModel(
    title: L10n.current.pagesSettingModelsExtraSettingsExtraSettingsTitle10,
    getSubtitle: () =>
        L10n.current.pagesSettingModelsExtraSettingsExtraSettingsGetSubtitle3(
          Pref.touchSlopH,
          deviceTouchSlop,
        ),
    onTap: _showTouchSlopDialog,
    leading: const Icon(Icons.pan_tool_alt_outlined),
  ),
  NormalModel(
    title: L10n.current.pagesSettingModelsExtraSettingsExtraSettingsTitle16,
    leading: const Icon(Icons.height),
    getSubtitle: () =>
        L10n.current.pagesSettingModelsExtraSettingsExtraSettingsGetSubtitle6(
          Pref.refreshDisplacement,
          refreshDragExtent,
        ),
    onTap: _showRefreshDialog,
  ),
  SwitchModel(
    title: L10n.current.showVipDanmakuExtraSettingsTitle,
    leading: const Icon(MdiIcons.gradientHorizontal),
    setKey: SettingBoxKey.showVipDanmaku,
    defaultVal: true,
  ),
  SwitchModel(
    title: L10n.current.mergeDanmakuExtraSettingsTitle,
    subtitle: L10n.current.mergeDanmakuExtraSettingsSubtitle,
    leading: const Icon(Icons.merge),
    setKey: SettingBoxKey.mergeDanmaku,
    defaultVal: false,
  ),
  SwitchModel(
    title: L10n.current.showHotRcmdExtraSettingsTitle,
    subtitle: L10n.current.showHotRcmdExtraSettingsSubtitle,
    leading: const Icon(Icons.local_fire_department_outlined),
    setKey: SettingBoxKey.showHotRcmd,
    defaultVal: false,
    needReboot: true,
  ),
  if (kDebugMode || Platform.isAndroid)
    NormalModel(
      title: L10n.current.pagesSettingModelsExtraSettingsExtraSettingsTitle4,
      leading: const Icon(Icons.multitrack_audio),
      getSubtitle: () {
        final audioNormalization = AudioNormalization.getTitleFromConfig(
          Pref.audioNormalization,
        );
        String fallback = Pref.fallbackNormalization;
        if (fallback == '0') {
          fallback = '';
        } else {
          fallback = L10n.current
              .pagesSettingModelsExtraSettingsExtraSettingsGetSubtitle5(
                AudioNormalization.getTitleFromConfig(fallback),
              );
        }
        return L10n.current
            .pagesSettingModelsExtraSettingsExtraSettingsGetSubtitle2(
              audioNormalization,
              fallback,
            );
      },
      onTap: audioNormalization,
    ),
  NormalModel(
    title: L10n.current.pagesSettingModelsExtraSettingsExtraSettingsTitle5,
    leading: const Icon(Icons.stay_current_landscape_outlined),
    getSubtitle: () =>
        L10n.current.pagesSettingModelsExtraSettingsExtraSettingsGetSubtitle7(
          Pref.superResolutionType.label,
        ),
    onTap: _showSuperResolutionDialog,
  ),
  SwitchModel(
    title: L10n.current.preInitPlayerExtraSettingsTitle,
    subtitle: L10n.current.preInitPlayerExtraSettingsSubtitle,
    leading: const Icon(Icons.play_circle_outlined),
    setKey: SettingBoxKey.preInitPlayer,
    defaultVal: false,
  ),
  SwitchModel(
    title: L10n.current.mainTabBarViewExtraSettingsTitle,
    leading: const Icon(Icons.home_outlined),
    setKey: SettingBoxKey.mainTabBarView,
    defaultVal: false,
    needReboot: true,
  ),
  SwitchModel(
    title: L10n.current.searchSuggestionExtraSettingsTitle,
    leading: const Icon(Icons.search),
    setKey: SettingBoxKey.searchSuggestion,
    defaultVal: true,
  ),
  SwitchModel(
    title: L10n.current.recordSearchHistoryExtraSettingsTitle,
    leading: const Icon(Icons.history),
    setKey: SettingBoxKey.recordSearchHistory,
    defaultVal: true,
  ),
  SwitchModel(
    title: L10n.current.showDecorateExtraSettingsTitle,
    leading: const Icon(MdiIcons.stickerCircleOutline),
    setKey: SettingBoxKey.showDecorate,
    defaultVal: true,
    onChanged: (value) => PendantAvatar.showDecorate = value,
  ),
  SwitchModel(
    title: L10n.current.enableEmoteTooltipExtraSettingsTitle,
    leading: const Icon(Icons.emoji_emotions_outlined),
    setKey: SettingBoxKey.enableEmoteTooltip,
    defaultVal: false,
    onChanged: (value) => enableEmoteTooltip = value,
  ),
  SwitchModel(
    title: L10n.current.showMedalExtraSettingsTitle,
    leading: const Icon(MdiIcons.medalOutline),
    setKey: SettingBoxKey.showMedal,
    defaultVal: true,
    onChanged: (value) => GlobalData().showMedal = value,
  ),
  SwitchModel(
    title: L10n.current.enableLivePhotoExtraSettingsTitle,
    subtitle: L10n.current.enableLivePhotoExtraSettingsSubtitle,
    leading: const Icon(Icons.image_outlined),
    setKey: SettingBoxKey.enableLivePhoto,
    defaultVal: true,
    onChanged: (value) => ImageModel.enableLivePhoto = value,
  ),
  SwitchModel(
    title: L10n.current.showSeekPreviewExtraSettingsTitle,
    leading: const Icon(Icons.preview_outlined),
    setKey: SettingBoxKey.showSeekPreview,
    defaultVal: true,
  ),
  SwitchModel(
    title: L10n.current.showDmChartExtraSettingsTitle,
    subtitle: L10n.current.showDmChartExtraSettingsSubtitle,
    leading: const Icon(Icons.show_chart),
    setKey: SettingBoxKey.showDmChart,
    defaultVal: false,
  ),
  SwitchModel(
    title: L10n.current.saveReplyExtraSettingsTitle,
    leading: const Icon(Icons.message_outlined),
    setKey: SettingBoxKey.saveReply,
    defaultVal: true,
    needReboot: true,
  ),
  SwitchModel(
    title: L10n.current.enableCommAntifraudExtraSettingsTitle,
    subtitle: L10n.current.enableCommAntifraudExtraSettingsSubtitle,
    leading: const Icon(CustomIcons.shield_reply),
    setKey: SettingBoxKey.enableCommAntifraud,
    defaultVal: false,
  ),
  if (Platform.isAndroid)
    SwitchModel(
      title: L10n.current.biliSendCommAntifraudExtraSettingsTitle,
      leading: const Icon(
        FontAwesomeIcons.b,
        size: 22,
      ),
      setKey: SettingBoxKey.biliSendCommAntifraud,
      defaultVal: false,
    ),
  SwitchModel(
    title: L10n.current.enableCreateDynAntifraudExtraSettingsTitle,
    subtitle: L10n.current.enableCreateDynAntifraudExtraSettingsSubtitle,
    leading: const Icon(CustomIcons.shield_published),
    setKey: SettingBoxKey.enableCreateDynAntifraud,
    defaultVal: false,
  ),
  SwitchModel(
    title: L10n.current.antiGoodsDynExtraSettingsTitle,
    leading: const Icon(CustomIcons.shopping_bag_not_interested),
    setKey: SettingBoxKey.antiGoodsDyn,
    defaultVal: false,
    onChanged: (value) => DynamicsDataModel.antiGoodsDyn = value,
  ),
  SwitchModel(
    title: L10n.current.antiGoodsReplyExtraSettingsTitle,
    leading: const Icon(CustomIcons.shopping_bag_not_interested),
    setKey: SettingBoxKey.antiGoodsReply,
    defaultVal: false,
    onChanged: (value) => ReplyGrpc.antiGoodsReply = value,
  ),
  SwitchModel(
    title: L10n.current.slideDismissReplyPageExtraSettingsTitle,
    leading: const Icon(CustomIcons.touch_app_rotate_270),
    setKey: SettingBoxKey.slideDismissReplyPage,
    defaultVal: Platform.isIOS,
    onChanged: (value) => CommonSlideMixin.slideDismissReplyPage = value,
  ),
  SwitchModel(
    title: L10n.current.enableShrinkVideoSizeExtraSettingsTitle,
    leading: const Icon(Icons.pinch),
    setKey: SettingBoxKey.enableShrinkVideoSize,
    defaultVal: true,
  ),
  SwitchModel(
    title: L10n.current.showDynActionBarExtraSettingsTitle,
    leading: const Icon(Icons.more_horiz),
    setKey: SettingBoxKey.showDynActionBar,
    defaultVal: true,
  ),
  SwitchModel(
    title: L10n.current.enableDragSubtitleExtraSettingsTitle,
    leading: const Icon(MdiIcons.dragVariant),
    setKey: SettingBoxKey.enableDragSubtitle,
    defaultVal: false,
  ),
  SwitchModel(
    title: L10n.current.showPgcTimelineExtraSettingsTitle,
    leading: const Icon(MdiIcons.chartTimelineVariantShimmer),
    setKey: SettingBoxKey.showPgcTimeline,
    defaultVal: true,
    needReboot: true,
  ),
  SwitchModel(
    title: L10n.current.silentDownImgExtraSettingsTitle,
    subtitle: L10n.current.silentDownImgExtraSettingsSubtitle,
    leading: const Icon(Icons.download_for_offline_outlined),
    setKey: SettingBoxKey.silentDownImg,
    defaultVal: false,
    onChanged: (value) => ImageUtils.silentDownImg = value,
  ),
  SwitchModel(
    title: L10n.current.enableImgMenuExtraSettingsTitle,
    leading: const Icon(Icons.menu),
    setKey: SettingBoxKey.enableImgMenu,
    defaultVal: false,
    onChanged: (value) => ImageGridView.enableImgMenu = value,
  ),
  SwitchModel(
    setKey: SettingBoxKey.feedBackEnable,
    onChanged: (value) {
      enableFeedback = value;
      feedBack();
    },
    leading: const Icon(Icons.vibration_outlined),
    title: L10n.current.feedBackEnableExtraSettingsTitle,
    subtitle: L10n.current.feedBackEnableExtraSettingsSubtitle,
  ),
  SwitchModel(
    title: L10n.current.textBuildHotSearchText2,
    subtitle: L10n.current.enableHotKeyExtraSettingsSubtitle,
    leading: const Icon(Icons.data_thresholding_outlined),
    setKey: SettingBoxKey.enableHotKey,
    defaultVal: true,
  ),
  SwitchModel(
    title: L10n.current.textBuildHotSearchText,
    subtitle: L10n.current.enableSearchRcmdExtraSettingsSubtitle,
    leading: const Icon(Icons.search_outlined),
    setKey: SettingBoxKey.enableSearchRcmd,
    defaultVal: true,
  ),
  SwitchModel(
    title: L10n.current.enableSearchWordExtraSettingsTitle,
    subtitle: L10n.current.enableSearchWordExtraSettingsSubtitle,
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
  SwitchModel(
    title: L10n.current.enableQuickFavExtraSettingsTitle,
    subtitle: L10n.current.enableQuickFavExtraSettingsSubtitle,
    leading: const Icon(Icons.bookmark_add_outlined),
    setKey: SettingBoxKey.enableQuickFav,
    onTap: _showFavDialog,
    defaultVal: false,
  ),
  SwitchModel(
    title: L10n.current.enableWordReExtraSettingsTitle,
    subtitle: L10n.current.enableWordReExtraSettingsSubtitle,
    leading: const Icon(Icons.search_outlined),
    setKey: SettingBoxKey.enableWordRe,
    defaultVal: false,
    onChanged: (value) => ReplyItemGrpc.enableWordRe = value,
  ),
  SwitchModel(
    title: L10n.current.enableAiExtraSettingsTitle,
    subtitle: L10n.current.enableAiExtraSettingsSubtitle,
    leading: const Icon(Icons.engineering_outlined),
    setKey: SettingBoxKey.enableAi,
    defaultVal: false,
  ),
  SwitchModel(
    title: L10n.current.disableLikeMsgExtraSettingsTitle,
    subtitle: L10n.current.disableLikeMsgExtraSettingsSubtitle,
    leading: const Icon(Icons.beach_access_outlined),
    setKey: SettingBoxKey.disableLikeMsg,
    defaultVal: false,
  ),
  SwitchModel(
    title: L10n.current.defaultShowCommentExtraSettingsTitle,
    subtitle: L10n.current.defaultShowCommentExtraSettingsSubtitle,
    leading: const Icon(Icons.mode_comment_outlined),
    setKey: SettingBoxKey.defaultShowComment,
    defaultVal: false,
  ),
  SwitchModel(
    title: L10n.current.enableHttp2ExtraSettingsTitle,
    leading: const Icon(Icons.swap_horizontal_circle_outlined),
    setKey: SettingBoxKey.enableHttp2,
    defaultVal: false,
    needReboot: true,
  ),
  NormalModel(
    title: L10n.current.pagesSettingModelsExtraSettingsExtraSettingsTitle11,
    subtitle:
        L10n.current.pagesSettingModelsExtraSettingsExtraSettingsSubtitle3,
    leading: const Icon(Icons.repeat),
    onTap: _showReplyCountDialog,
  ),
  NormalModel(
    title: L10n.current.pagesSettingModelsExtraSettingsExtraSettingsTitle12,
    subtitle:
        L10n.current.pagesSettingModelsExtraSettingsExtraSettingsSubtitle6,
    leading: const Icon(Icons.more_time_outlined),
    onTap: _showReplyDelayDialog,
  ),
  PopupModel(
    title: L10n.current.pagesSettingModelsExtraSettingsExtraSettingsTitle6,
    leading: const Icon(Icons.whatshot_outlined),
    value: () => Pref.replySortType,
    items: ReplySortType.values.take(2),
    onSelected: (value, setState) => GStorage.setting
        .put(SettingBoxKey.replySortType, value.index)
        .whenComplete(setState),
  ),
  PopupModel(
    title: L10n.current.pagesSettingModelsExtraSettingsExtraSettingsTitle17,
    leading: const Icon(Icons.subdirectory_arrow_right_outlined),
    value: () => Pref.reply2SortType,
    items: ReplySortType.values.take(2),
    onSelected: (value, setState) => GStorage.setting
        .put(SettingBoxKey.reply2SortType, value.index)
        .whenComplete(setState),
  ),
  PopupModel(
    title: L10n.current.pagesSettingModelsExtraSettingsExtraSettingsTitle7,
    leading: const Icon(Icons.dynamic_feed_rounded),
    value: () => Pref.defaultDynamicType,
    items: DynamicsTabType.values.take(4),
    onSelected: (value, setState) => GStorage.setting
        .put(SettingBoxKey.defaultDynamicType, value.index)
        .whenComplete(setState),
  ),
  SwitchModel(
    title: L10n.current.showDynInteractionExtraSettingsTitle,
    subtitle: L10n.current.showDynInteractionExtraSettingsSubtitle,
    leading: const Icon(Icons.quickreply_outlined),
    setKey: SettingBoxKey.showDynInteraction,
    defaultVal: true,
    onChanged: (val) => ItemModulesModel.showDynInteraction = val,
  ),
  NormalModel(
    title: L10n.current.pagesSettingModelsExtraSettingsExtraSettingsTitle18,
    leading: const Icon(Icons.tab),
    getSubtitle: () =>
        L10n.current.pagesSettingModelsExtraSettingsExtraSettingsGetSubtitle(
          Pref.memberTab.title,
        ),
    onTap: _showMemberTabDialog,
  ),
  SwitchModel(
    title: L10n.current.showMemberShopExtraSettingsTitle,
    leading: const Icon(Icons.shop_outlined),
    setKey: SettingBoxKey.showMemberShop,
    defaultVal: false,
    onChanged: (value) => MemberTabType.showMemberShop = value,
  ),
  SplitModel(
    normalModel: NormalModel.split(
      title: L10n.current.proxySettings,
      subtitle: L10n.current.proxySettingsHint,
      leading: const Icon(Icons.airplane_ticket_outlined),
    ),
    switchModel: const SwitchModel.split(
      defaultVal: false,
      setKey: SettingBoxKey.enableSystemProxy,
      onTap: _showProxyDialog,
    ),
  ),
  NormalModel(
    title: L10n.current.pagesSettingModelsExtraSettingsExtraSettingsTitle13,
    getSubtitle: () =>
        L10n.current.pagesSettingModelsExtraSettingsExtraSettingsGetSubtitle4(
          CacheManager.formatSize(Pref.maxCacheSize),
        ),
    leading: const Icon(Icons.delete_outlined),
    onTap: _showCacheDialog,
  ),
  SwitchModel(
    title: L10n.current.checkForUpdates,
    subtitle: L10n.current.autoUpdateExtraSettingsSubtitle,
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
        title: fallback
            ? L10n.current.resAudioNormalizationTitle
            : L10n.current.pagesSettingModelsExtraSettingsExtraSettingsTitle4,
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
          title: Text(L10n.current.audioNormalizationCustomTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              Text(
                L10n
                    .current
                    .pagesSettingModelsExtraSettingsAudioNormalizationChildren,
              ),
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
                L10n.current.cancel,
                style: TextStyle(color: ColorScheme.of(context).outline),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                GStorage.setting.put(key, param);
                if (!fallback &&
                    AudioNormalization.loudnormRegExp.hasMatch(param)) {
                  audioNormalization(context, setState, fallback: true);
                }
                setState();
              },
              child: Text(L10n.current.ok),
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
    builder: (context) => SimpleDialog(
      clipBehavior: Clip.hardEdge,
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        DialogOption(
          onPressed: () {
            Get.back();
            PathUtils.openDir(downloadPath);
          },
          child: Text(L10n.current.open),
        ),
        DialogOption(
          onPressed: () {
            Get.back();
            Utils.copyText(downloadPath);
          },
          child: Text(L10n.current.copy, style: const TextStyle(fontSize: 14)),
        ),
        DialogOption(
          onPressed: () {
            Get.back();
            final defPath = defDownloadPath;
            if (downloadPath == defPath) return;
            downloadPath = defPath;
            setState();
            Get.find<DownloadService>().initDownloadList();
            GStorage.setting.delete(SettingBoxKey.downloadPath);
          },
          child: Text(
            L10n
                .current
                .pagesSettingModelsExtraSettingsShowDownPathDialogChild2,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        DialogOption(
          onPressed: () async {
            Get.back();
            final path = await FilePicker.getDirectoryPath(
              initialDirectory: Directory(downloadPath).existsSync()
                  ? downloadPath
                  : null,
            );
            if (path == null || path == downloadPath) return;
            downloadPath = path;
            setState();
            Get.find<DownloadService>().initDownloadList();
            GStorage.setting.put(SettingBoxKey.downloadPath, path);
          },
          child: Text(
            L10n
                .current
                .pagesSettingModelsExtraSettingsShowDownPathDialogChild3,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    ),
  );
}

void _showDynDialog(BuildContext context) {
  String dynamicPeriod = Pref.dynamicPeriod.toString();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        L10n.current.pagesSettingModelsExtraSettingsShowDynDialogTitle,
      ),
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
            L10n.current.cancel,
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
          child: Text(L10n.current.ok),
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
      title: Text(
        L10n.current.pagesSettingModelsExtraSettingsExtraSettingsTitle9,
      ),
      content: TextFormField(
        autofocus: true,
        initialValue: replyLengthLimit,
        keyboardType: TextInputType.number,
        onChanged: (value) => replyLengthLimit = value,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          suffixText: L10n
              .current
              .pagesSettingModelsExtraSettingsShowReplyLengthDialogSuffixText,
        ),
      ),
      actions: [
        TextButton(
          onPressed: Get.back,
          child: Text(
            L10n.current.cancel,
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
          child: Text(L10n.current.ok),
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
      title: Text(
        L10n.current.pagesSettingModelsExtraSettingsExtraSettingsTitle3,
      ),
      content: TextFormField(
        autofocus: true,
        initialValue: danmakuLineHeight,
        keyboardType: const .numberWithOptions(decimal: true),
        onChanged: (value) => danmakuLineHeight = value,
        inputFormatters: FilteringText.decimal,
      ),
      actions: [
        TextButton(
          onPressed: Get.back,
          child: Text(
            L10n.current.cancel,
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
          child: Text(L10n.current.ok),
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
      title: Text(
        L10n.current.pagesSettingModelsExtraSettingsExtraSettingsTitle10,
      ),
      content: TextFormField(
        autofocus: true,
        initialValue: initialValue,
        keyboardType: const .numberWithOptions(decimal: true),
        onChanged: (value) => initialValue = value,
        inputFormatters: FilteringText.decimal,
      ),
      actions: [
        TextButton(
          onPressed: Get.back,
          child: Text(
            L10n.current.cancel,
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
          child: Text(L10n.current.ok),
        ),
      ],
    ),
  );
}

Future<void> _showRefreshDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<double>(
    context: context,
    builder: (context) => SliderDialog(
      title: Text(
        L10n.current.pagesSettingModelsExtraSettingsExtraSettingsTitle16,
      ),
      min: 10.0,
      max: 100.0,
      divisions: 9,
      value: Pref.refreshDisplacement,
    ),
  );
  if (res != null) {
    displacement = res;
    await GStorage.setting.put(SettingBoxKey.refreshDisplacement, res);
    if (WidgetsBinding.instance.rootElement case final context?) {
      context.visitChildElements(_visitor);
    }
    setState();
  }
}

void _visitor(Element context) {
  if (!context.mounted) return;
  if (context.widget is RefreshIndicator) {
    context.markNeedsBuild();
  } else {
    context.visitChildren(_visitor);
  }
}

Future<void> _showSuperResolutionDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<SuperResolutionType>(
    context: context,
    builder: (context) => SelectDialog<SuperResolutionType>(
      title: L10n.current.pagesSettingModelsExtraSettingsExtraSettingsTitle5,
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
          title: Text(
            L10n.current.pagesSettingModelsExtraSettingsShowFavDialogTitle,
          ),
          contentPadding: const EdgeInsets.only(top: 5, bottom: 18),
          content: SingleChildScrollView(
            child: RadioGroup(
              onChanged: (value) {
                Get.back();
                GStorage.setting.put(SettingBoxKey.quickFavId, value);
                SmartDialog.showToast(L10n.current.settingsSaved);
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
    builder: (context) => SliderDialog(
      title: Text(
        L10n.current.pagesSettingModelsExtraSettingsExtraSettingsTitle11,
      ),
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
    SmartDialog.showToast(L10n.current.restartRequired);
  }
}

Future<void> _showReplyDelayDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<double>(
    context: context,
    builder: (context) => SliderDialog(
      title: Text(
        L10n.current.pagesSettingModelsExtraSettingsExtraSettingsTitle12,
      ),
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
    SmartDialog.showToast(L10n.current.restartRequired);
  }
}

Future<void> _showMemberTabDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<MemberTabType>(
    context: context,
    builder: (context) => SelectDialog<MemberTabType>(
      title: L10n.current.pagesSettingModelsExtraSettingsExtraSettingsTitle18,
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
      title: Text(
        L10n.current.pagesSettingModelsExtraSettingsShowProxyDialogTitle,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 6),
          TextFormField(
            initialValue: systemProxyHost,
            decoration: InputDecoration(
              isDense: true,
              labelText: L10n
                  .current
                  .pagesSettingModelsExtraSettingsShowProxyDialogLabelText2,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
            ),
            onChanged: (e) => systemProxyHost = e,
          ),
          const SizedBox(height: 10),
          TextFormField(
            initialValue: systemProxyPort,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              isDense: true,
              labelText: L10n
                  .current
                  .pagesSettingModelsExtraSettingsShowProxyDialogLabelText,
              border: const OutlineInputBorder(
                borderRadius: .all(.circular(6)),
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
            L10n.current.cancel,
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
          child: Text(L10n.current.confirm),
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
      title: Text(
        L10n.current.pagesSettingModelsExtraSettingsExtraSettingsTitle13,
      ),
      content: TextField(
        autofocus: true,
        onChanged: (value) => valueStr = value,
        keyboardType: TextInputType.number,
        inputFormatters: FilteringText.decimal,
        decoration: const InputDecoration(suffixText: 'MB'),
      ),
      actions: [
        TextButton(
          onPressed: Get.back,
          child: Text(
            L10n.current.cancel,
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
          child: Text(L10n.current.ok),
        ),
      ],
    ),
  );
}
