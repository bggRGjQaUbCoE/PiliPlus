import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:PiliPlus/common/widgets/self_sized_horizontal_list.dart';
import 'package:PiliPlus/models/common/super_resolution_type.dart';
import 'package:PiliPlus/pages/setting/widgets/switch_item.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:canvas_danmaku/canvas_danmaku.dart';
import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:media_kit/media_kit.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/models/video/play/quality.dart';
import 'package:PiliPlus/models/video/play/url.dart';
import 'package:PiliPlus/pages/video/detail/index.dart';
import 'package:PiliPlus/pages/video/detail/introduction/widgets/menu_row.dart';
import 'package:PiliPlus/plugin/pl_player/index.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_repeat.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/services/shutdown_timer_service.dart';
import '../../../../models/video/play/CDN.dart';
import '../../../../models/video_detail_res.dart';
import '../../../setting/widgets/select_dialog.dart';
import '../introduction/index.dart';
import 'package:marquee/marquee.dart';

class HeaderControl extends StatefulWidget implements PreferredSizeWidget {
  const HeaderControl({
    required this.controller,
    required this.videoDetailCtr,
    this.floating,
    required this.heroTag,
    super.key,
  });
  final PlPlayerController controller;
  final VideoDetailController videoDetailCtr;
  final Floating? floating;
  final String heroTag;

  @override
  State<HeaderControl> createState() => _HeaderControlState();

  @override
  Size get preferredSize => throw UnimplementedError();
}

class _HeaderControlState extends State<HeaderControl> {
  PlayUrlModel get videoInfo => widget.videoDetailCtr.data;
  static const TextStyle subTitleStyle = TextStyle(fontSize: 12);
  static const TextStyle titleStyle = TextStyle(fontSize: 14);
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);
  double buttonSpace = 8;
  String get heroTag => widget.heroTag;
  late VideoIntroController videoIntroController;
  late VideoDetailData videoDetail;
  late bool horizontalScreen;
  RxString now = ''.obs;
  Timer? clock;
  late String defaultCDNService;
  bool get isFullScreen => widget.controller.isFullScreen.value;
  Box get setting => GStorage.setting;

  @override
  void initState() {
    super.initState();
    videoIntroController = Get.put(VideoIntroController(), tag: heroTag);
    horizontalScreen =
        setting.get(SettingBoxKey.horizontalScreen, defaultValue: false);
    defaultCDNService = setting.get(SettingBoxKey.CDNService,
        defaultValue: CDNService.backupUrl.code);
  }

  @override
  void dispose() {
    clock?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).orientation == Orientation.landscape &&
        (isFullScreen || !horizontalScreen)) {
      startClock();
    } else {
      clock?.cancel();
      clock = null;
    }
  }

  /// 设置面板
  void showSettingSheet() {
    Utils.showFSSheet(
      isFullScreen: isFullScreen,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        margin: EdgeInsets.only(
          left: 12,
          top: 12,
          right: 12,
          bottom: 12 + MediaQuery.paddingOf(context).bottom,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 35,
              child: Center(
                child: Container(
                  width: 32,
                  height: 3,
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .onSecondaryContainer
                          .withOpacity(0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(3))),
                ),
              ),
            ),
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: MediaQuery.removePadding(
                  context: context,
                  removeBottom: true,
                  child: ListView(
                    children: [
                      // ListTile(
                      //   onTap: () {},
                      //   dense: true,
                      //   enabled: false,
                      //   leading:
                      //       const Icon(Icons.network_cell_outlined, size: 20),
                      //   title: Text('省流模式', style: titleStyle),
                      //   subtitle: Text('低画质 ｜ 减少视频缓存', style: subTitleStyle),
                      //   trailing: Transform.scale(
                      //     scale: 0.75,
                      //     child: Switch(
                      //       thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
                      //           (Set<WidgetState> states) {
                      //         if (states.isNotEmpty &&
                      //             states.first == WidgetState.selected) {
                      //           return const Icon(Icons.done);
                      //         }
                      //         return null; // All other states will use the default thumbIcon.
                      //       }),
                      //       value: false,
                      //       onChanged: (value) => {},
                      //     ),
                      //   ),
                      // ),
                      // if (widget.videoDetailCtr.userInfo != null)
                      ListTile(
                        dense: true,
                        onTap: () async {
                          Get.back();
                          final res = await UserHttp.toViewLater(
                              bvid: widget.videoDetailCtr.bvid);
                          SmartDialog.showToast(res['msg']);
                        },
                        leading:
                            const Icon(Icons.watch_later_outlined, size: 20),
                        title: const Text('添加至「稍后再看」', style: titleStyle),
                      ),
                      ListTile(
                        dense: true,
                        onTap: () => {Get.back(), scheduleExit()},
                        leading:
                            const Icon(Icons.hourglass_top_outlined, size: 20),
                        title: const Text('定时关闭', style: titleStyle),
                      ),
                      ListTile(
                        dense: true,
                        onTap: () => {
                          Get.back(),
                          widget.videoDetailCtr.queryVideoUrl(
                            widget.videoDetailCtr.playedTime,
                          )
                        },
                        leading: const Icon(Icons.refresh_outlined, size: 20),
                        title: const Text('重载视频', style: titleStyle),
                      ),
                      ListTile(
                        dense: true,
                        leading: const Icon(
                            Icons.stay_current_landscape_outlined,
                            size: 20),
                        title: Row(
                          children: [
                            const Text(
                              '超分辨率',
                              strutStyle: StrutStyle(leading: 0, height: 1),
                              style: TextStyle(
                                height: 1,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Builder(
                              builder: (context) => PopupMenuButton(
                                initialValue: SuperResolutionType.values[
                                    widget.controller.superResolutionType],
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        SuperResolutionType
                                            .values[widget
                                                .controller.superResolutionType]
                                            .title,
                                        strutStyle:
                                            StrutStyle(leading: 0, height: 1),
                                        style: TextStyle(
                                          height: 1,
                                          fontSize: 14,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                      Icon(
                                        MdiIcons.unfoldMoreHorizontal,
                                        size: MediaQuery.textScalerOf(context)
                                            .scale(14),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      )
                                    ],
                                  ),
                                ),
                                onSelected: (value) {
                                  widget.controller.setShader(value.index);
                                  if (context.mounted) {
                                    (context as Element).markNeedsBuild();
                                  }
                                },
                                itemBuilder: (context) =>
                                    SuperResolutionType.values
                                        .map((item) => PopupMenuItem(
                                              value: item,
                                              child: Text(item.title),
                                            ))
                                        .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        dense: true,
                        title: const Text('CDN 设置', style: titleStyle),
                        leading: Icon(MdiIcons.cloudPlusOutline, size: 20),
                        subtitle: Text(
                          '当前：${CDNServiceCode.fromCode(defaultCDNService)!.description}，无法播放请切换',
                          style: subTitleStyle,
                        ),
                        onTap: () async {
                          Get.back();
                          String? result = await showDialog(
                            context: context,
                            builder: (context) {
                              return SelectDialog<String>(
                                  title: 'CDN 设置',
                                  value: defaultCDNService,
                                  values: CDNService.values.map((e) {
                                    return {
                                      'title': e.description,
                                      'value': e.code
                                    };
                                  }).toList());
                            },
                          );
                          if (result != null) {
                            defaultCDNService = result;
                            setting.put(SettingBoxKey.CDNService, result);
                            SmartDialog.showToast(
                                '已设置为 ${CDNServiceCode.fromCode(result)!.description}，正在重载视频');
                            setState(() {});
                            widget.videoDetailCtr.queryVideoUrl(
                              widget.videoDetailCtr.playedTime,
                            );
                          }
                        },
                      ),
                      SelfSizedHorizontalList(
                        itemCount: 4,
                        gapSize: 10,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        childBuilder: (index) {
                          return switch (index) {
                            0 => Obx(
                                () => ActionRowLineItem(
                                  iconData: Icons.flip,
                                  onTap: () {
                                    widget.controller.flipX.value =
                                        !widget.controller.flipX.value;
                                  },
                                  text: " 左右翻转 ",
                                  selectStatus: widget.controller.flipX.value,
                                ),
                              ),
                            1 => Obx(
                                () => ActionRowLineItem(
                                  icon: Transform.rotate(
                                    angle: pi / 2,
                                    child: Icon(
                                      Icons.flip,
                                      size: 13,
                                      color: widget.controller.flipY.value
                                          ? Theme.of(context)
                                              .colorScheme
                                              .onSecondaryContainer
                                          : Theme.of(context)
                                              .colorScheme
                                              .outline,
                                    ),
                                  ),
                                  onTap: () {
                                    widget.controller.flipY.value =
                                        !widget.controller.flipY.value;
                                  },
                                  text: " 上下翻转 ",
                                  selectStatus: widget.controller.flipY.value,
                                ),
                              ),
                            2 => Obx(
                                () => ActionRowLineItem(
                                  iconData: Icons.headphones,
                                  onTap: widget.controller.setOnlyPlayAudio,
                                  text: " 听视频 ",
                                  selectStatus:
                                      widget.controller.onlyPlayAudio.value,
                                ),
                              ),
                            3 => Obx(
                                () => ActionRowLineItem(
                                  iconData: Icons.play_circle_outline,
                                  onTap: widget
                                      .controller.setContinuePlayInBackground,
                                  text: " 后台播放 ",
                                  selectStatus: widget.controller
                                      .continuePlayInBackground.value,
                                ),
                              ),
                            int() => throw UnimplementedError(),
                          };
                        },
                      ),

                      ListTile(
                        dense: true,
                        onTap: () => {Get.back(), showSetVideoQa()},
                        leading:
                            const Icon(Icons.play_circle_outline, size: 20),
                        title: const Text('选择画质', style: titleStyle),
                        subtitle: Text(
                            '当前画质 ${widget.videoDetailCtr.currentVideoQa.description}',
                            style: subTitleStyle),
                      ),
                      if (widget.videoDetailCtr.currentAudioQa != null)
                        ListTile(
                          dense: true,
                          onTap: () => {Get.back(), showSetAudioQa()},
                          leading: const Icon(Icons.album_outlined, size: 20),
                          title: const Text('选择音质', style: titleStyle),
                          subtitle: Text(
                              '当前音质 ${widget.videoDetailCtr.currentAudioQa!.description}',
                              style: subTitleStyle),
                        ),
                      ListTile(
                        dense: true,
                        onTap: () => {Get.back(), showSetDecodeFormats()},
                        leading: const Icon(Icons.av_timer_outlined, size: 20),
                        title: const Text('解码格式', style: titleStyle),
                        subtitle: Text(
                            '当前解码格式 ${widget.videoDetailCtr.currentDecodeFormats.description}',
                            style: subTitleStyle),
                      ),
                      ListTile(
                        dense: true,
                        onTap: () => {Get.back(), showSetRepeat()},
                        leading: const Icon(Icons.repeat, size: 20),
                        title: const Text('播放顺序', style: titleStyle),
                        subtitle: Text(widget.controller.playRepeat.description,
                            style: subTitleStyle),
                      ),
                      ListTile(
                        dense: true,
                        onTap: () => {Get.back(), showSetDanmaku()},
                        leading: const Icon(Icons.subtitles_outlined, size: 20),
                        title: const Text('弹幕/字幕设置', style: titleStyle),
                      ),
                      ListTile(
                        dense: true,
                        title: const Text('播放信息', style: titleStyle),
                        leading: const Icon(Icons.info_outline, size: 20),
                        onTap: () {
                          Player? player =
                              widget.controller.videoPlayerController;
                          if (player == null) {
                            SmartDialog.showToast('播放器未初始化');
                            return;
                          }
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('播放信息'),
                                content: SizedBox(
                                  width: double.maxFinite,
                                  child: ListView(
                                    children: [
                                      ListTile(
                                        dense: true,
                                        title: const Text("Resolution"),
                                        subtitle: Text(
                                            '${player.state.width}x${player.state.height}'),
                                        onTap: () {
                                          Utils.copyText(
                                            'Resolution\n${player.state.width}x${player.state.height}',
                                            needToast: false,
                                          );
                                        },
                                      ),
                                      ListTile(
                                        dense: true,
                                        title: const Text("VideoParams"),
                                        subtitle: Text(player.state.videoParams
                                            .toString()),
                                        onTap: () {
                                          Utils.copyText(
                                            'VideoParams\n${player.state.videoParams}',
                                            needToast: false,
                                          );
                                        },
                                      ),
                                      ListTile(
                                        dense: true,
                                        title: const Text("AudioParams"),
                                        subtitle: Text(player.state.audioParams
                                            .toString()),
                                        onTap: () {
                                          Utils.copyText(
                                            'AudioParams\n${player.state.audioParams}',
                                            needToast: false,
                                          );
                                        },
                                      ),
                                      ListTile(
                                        dense: true,
                                        title: const Text("Media"),
                                        subtitle: Text(
                                            player.state.playlist.toString()),
                                        onTap: () {
                                          Utils.copyText(
                                            'Media\n${player.state.playlist}',
                                            needToast: false,
                                          );
                                        },
                                      ),
                                      ListTile(
                                        dense: true,
                                        title: const Text("AudioTrack"),
                                        subtitle: Text(player.state.track.audio
                                            .toString()),
                                        onTap: () {
                                          Utils.copyText(
                                            'AudioTrack\n${player.state.track.audio}',
                                            needToast: false,
                                          );
                                        },
                                      ),
                                      ListTile(
                                        dense: true,
                                        title: const Text("VideoTrack"),
                                        subtitle: Text(player.state.track.video
                                            .toString()),
                                        onTap: () {
                                          Utils.copyText(
                                            'VideoTrack\n${player.state.track.audio}',
                                            needToast: false,
                                          );
                                        },
                                      ),
                                      ListTile(
                                          dense: true,
                                          title: const Text("pitch"),
                                          subtitle: Text(
                                              player.state.pitch.toString()),
                                          onTap: () {
                                            Utils.copyText(
                                              'pitch\n${player.state.pitch}',
                                              needToast: false,
                                            );
                                          }),
                                      ListTile(
                                          dense: true,
                                          title: const Text("rate"),
                                          subtitle: Text(
                                              player.state.rate.toString()),
                                          onTap: () {
                                            Utils.copyText(
                                              'rate\n${player.state.rate}',
                                              needToast: false,
                                            );
                                          }),
                                      ListTile(
                                        dense: true,
                                        title: const Text("AudioBitrate"),
                                        subtitle: Text(player.state.audioBitrate
                                            .toString()),
                                        onTap: () {
                                          Utils.copyText(
                                            'AudioBitrate\n${player.state.audioBitrate}',
                                            needToast: false,
                                          );
                                        },
                                      ),
                                      ListTile(
                                        dense: true,
                                        title: const Text("Volume"),
                                        subtitle: Text(
                                            player.state.volume.toString()),
                                        onTap: () {
                                          Utils.copyText(
                                            'Volume\n${player.state.volume}',
                                            needToast: false,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: Text(
                                      '确定',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      ListTile(
                        dense: true,
                        onTap: () {
                          if (widget.videoDetailCtr.userInfo == null) {
                            SmartDialog.showToast('账号未登录');
                            return;
                          }
                          Get.back();
                          Get.toNamed('/webview', parameters: {
                            'url':
                                'https://www.bilibili.com/appeal/?avid=${IdUtils.bv2av(widget.videoDetailCtr.bvid)}&bvid=${widget.videoDetailCtr.bvid}'
                          });
                        },
                        leading: const Icon(Icons.error_outline, size: 20),
                        title: const Text('举报', style: titleStyle),
                      ),
                      const SizedBox(height: 14),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 定时关闭
  void scheduleExit() async {
    const List<int> scheduleTimeChoices = [0, 15, 30, 45, 60];
    Utils.showFSSheet(
      isFullScreen: isFullScreen,
      child: StatefulBuilder(
        builder: (context, setState) {
          return Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            margin: EdgeInsets.only(
              left: 12,
              top: 12,
              right: 12,
              bottom: 12 + MediaQuery.paddingOf(context).bottom,
            ),
            padding: const EdgeInsets.only(left: 14, right: 14),
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    const Center(child: Text('定时关闭', style: titleStyle)),
                    const SizedBox(height: 10),
                    ...[
                      ...[
                        ...scheduleTimeChoices,
                        if (scheduleTimeChoices
                            .contains(
                                shutdownTimerService.scheduledExitInMinutes)
                            .not)
                          shutdownTimerService.scheduledExitInMinutes,
                      ]..sort(),
                      -1,
                    ].map(
                      (choice) => ListTile(
                        dense: true,
                        onTap: () {
                          if (choice == -1) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                String duration = '';
                                return AlertDialog(
                                  title: const Text('自定义时长'),
                                  content: TextField(
                                    autofocus: true,
                                    onChanged: (value) => duration = value,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'\d+')),
                                    ],
                                    decoration: const InputDecoration(
                                        suffixText: 'min'),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: Get.back,
                                      child: Text(
                                        '取消',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                        int choice =
                                            int.tryParse(duration) ?? 0;
                                        shutdownTimerService
                                            .scheduledExitInMinutes = choice;
                                        shutdownTimerService
                                            .startShutdownTimer();
                                        setState(() {});
                                      },
                                      child: Text('确定'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            Get.back();
                            shutdownTimerService.scheduledExitInMinutes =
                                choice;
                            shutdownTimerService.startShutdownTimer();
                          }
                        },
                        contentPadding: const EdgeInsets.only(),
                        title: Text(choice == -1
                            ? '自定义'
                            : choice == 0
                                ? "禁用"
                                : "$choice分钟后"),
                        trailing: shutdownTimerService.scheduledExitInMinutes ==
                                choice
                            ? Icon(
                                Icons.done,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Center(
                      child: SizedBox(
                        width: 125,
                        child: Divider(height: 1),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      dense: true,
                      onTap: () {
                        shutdownTimerService.waitForPlayingCompleted =
                            !shutdownTimerService.waitForPlayingCompleted;
                        setState(() {});
                      },
                      contentPadding: const EdgeInsets.only(),
                      title: const Text("额外等待视频播放完毕", style: titleStyle),
                      trailing: Transform.scale(
                        alignment: Alignment
                            .centerRight, // 缩放Switch的大小后保持右侧对齐, 避免右侧空隙过大
                        scale: 0.8,
                        child: Switch(
                          thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
                              (Set<WidgetState> states) {
                            if (states.isNotEmpty &&
                                states.first == WidgetState.selected) {
                              return const Icon(Icons.done);
                            }
                            return null;
                          }),
                          value: shutdownTimerService.waitForPlayingCompleted,
                          onChanged: (value) => setState(() =>
                              shutdownTimerService.waitForPlayingCompleted =
                                  value),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text('倒计时结束:', style: titleStyle),
                        const Spacer(),
                        ActionRowLineItem(
                          onTap: () {
                            shutdownTimerService.exitApp = false;
                            setState(() {});
                            // Get.back();
                          },
                          text: " 暂停视频 ",
                          selectStatus: !shutdownTimerService.exitApp,
                        ),
                        const Spacer(),
                        // const SizedBox(width: 10),
                        ActionRowLineItem(
                          onTap: () {
                            shutdownTimerService.exitApp = true;
                            setState(() {});
                            // Get.back();
                          },
                          text: " 退出APP ",
                          selectStatus: shutdownTimerService.exitApp,
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// 选择画质
  void showSetVideoQa() {
    if (videoInfo.dash == null) {
      SmartDialog.showToast('当前视频不支持选择画质');
      return;
    }
    final List<FormatItem> videoFormat = videoInfo.supportFormats!;
    final VideoQuality currentVideoQa = widget.videoDetailCtr.currentVideoQa;

    /// 总质量分类
    final int totalQaSam = videoFormat.length;

    /// 可用的质量分类
    int userfulQaSam = 0;
    final List<VideoItem> video = videoInfo.dash!.video!;
    final Set<int> idSet = {};
    for (final VideoItem item in video) {
      final int id = item.id!;
      if (!idSet.contains(id)) {
        idSet.add(id);
        userfulQaSam++;
      }
    }

    Utils.showFSSheet(
      isFullScreen: isFullScreen,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        margin: EdgeInsets.only(
          left: 12,
          top: 12,
          right: 12,
          bottom: 12 + MediaQuery.paddingOf(context).bottom,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 45,
              child: GestureDetector(
                onTap: () {
                  SmartDialog.showToast(
                      '标灰画质需要bilibili会员（已是会员？请关闭无痕模式）；4k和杜比视界播放效果可能不佳');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('选择画质', style: titleStyle),
                    SizedBox(width: buttonSpace),
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Theme.of(context).colorScheme.outline,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: Scrollbar(
                  child: MediaQuery.removePadding(
                    context: context,
                    removeBottom: true,
                    child: ListView(
                      children: [
                        for (int i = 0; i < totalQaSam; i++) ...[
                          ListTile(
                            dense: true,
                            onTap: () {
                              if (currentVideoQa.code ==
                                  videoFormat[i].quality) {
                                return;
                              }
                              Get.back();
                              final int quality = videoFormat[i].quality!;
                              widget.videoDetailCtr.currentVideoQa =
                                  VideoQualityCode.fromCode(quality)!;
                              widget.videoDetailCtr.updatePlayer();
                              // String oldQualityDesc =
                              //     VideoQualityCode.fromCode(setting.get(
                              //             SettingBoxKey.defaultVideoQa,
                              //             defaultValue:
                              //                 VideoQuality.values.last.code))!
                              //         .description;
                              // setting.put(
                              //     SettingBoxKey.defaultVideoQa, quality);
                              // SmartDialog.showToast(
                              //     "默认画质由：$oldQualityDesc 变为：${VideoQualityCode.fromCode(quality)!.description}");
                            },
                            // 可能包含会员解锁画质
                            enabled: i >= totalQaSam - userfulQaSam,
                            contentPadding:
                                const EdgeInsets.only(left: 20, right: 20),
                            title: Text(videoFormat[i].newDesc!),
                            trailing: currentVideoQa.code ==
                                    videoFormat[i].quality
                                ? Icon(
                                    Icons.done,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )
                                : Text(
                                    videoFormat[i].format!,
                                    style: subTitleStyle,
                                  ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 选择音质
  void showSetAudioQa() {
    final AudioQuality currentAudioQa = widget.videoDetailCtr.currentAudioQa!;
    final List<AudioItem> audio = videoInfo.dash!.audio!;
    Utils.showFSSheet(
      isFullScreen: isFullScreen,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        margin: EdgeInsets.only(
          left: 12,
          top: 12,
          right: 12,
          bottom: 12 + MediaQuery.paddingOf(context).bottom,
        ),
        child: Column(
          children: [
            const SizedBox(
                height: 45,
                child: Center(child: Text('选择音质', style: titleStyle))),
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: MediaQuery.removePadding(
                  context: context,
                  removeBottom: true,
                  child: ListView(
                    children: [
                      for (final AudioItem i in audio) ...[
                        ListTile(
                          dense: true,
                          onTap: () {
                            if (currentAudioQa.code == i.id) {
                              return;
                            }
                            Get.back();
                            final int quality = i.id!;
                            widget.videoDetailCtr.currentAudioQa =
                                AudioQualityCode.fromCode(quality)!;
                            widget.videoDetailCtr.updatePlayer();
                            // String oldQualityDesc = AudioQualityCode.fromCode(
                            //         setting.get(SettingBoxKey.defaultAudioQa,
                            //             defaultValue:
                            //                 AudioQuality.values.last.code))!
                            //     .description;
                            // setting.put(
                            //     SettingBoxKey.defaultAudioQa, quality);
                            // SmartDialog.showToast(
                            //     "默认音质由：$oldQualityDesc 变为：${AudioQualityCode.fromCode(quality)!.description}");
                          },
                          contentPadding:
                              const EdgeInsets.only(left: 20, right: 20),
                          title: Text(i.quality!),
                          subtitle: Text(
                            i.codecs!,
                            style: subTitleStyle,
                          ),
                          trailing: currentAudioQa.code == i.id
                              ? Icon(
                                  Icons.done,
                                  color: Theme.of(context).colorScheme.primary,
                                )
                              : const SizedBox(),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 选择解码格式
  void showSetDecodeFormats() {
    // 当前选中的解码格式
    final VideoDecodeFormats currentDecodeFormats =
        widget.videoDetailCtr.currentDecodeFormats;
    final VideoItem firstVideo = widget.videoDetailCtr.firstVideo;
    // 当前视频可用的解码格式
    final List<FormatItem> videoFormat = videoInfo.supportFormats!;
    final List? list = videoFormat
        .firstWhere((FormatItem e) => e.quality == firstVideo.quality!.code)
        .codecs;
    if (list == null) {
      SmartDialog.showToast('当前视频不支持选择解码格式');
      return;
    }

    Utils.showFSSheet(
      isFullScreen: isFullScreen,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        margin: EdgeInsets.only(
          left: 12,
          top: 12,
          right: 12,
          bottom: 12 + MediaQuery.paddingOf(context).bottom,
        ),
        child: Column(
          children: [
            const SizedBox(
                height: 45,
                child: Center(child: Text('选择解码格式', style: titleStyle))),
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: MediaQuery.removePadding(
                  context: context,
                  removeBottom: true,
                  child: ListView(
                    children: [
                      for (var i in list) ...[
                        ListTile(
                          dense: true,
                          onTap: () {
                            if (i.startsWith(currentDecodeFormats.code)) {
                              return;
                            }
                            widget.videoDetailCtr.currentDecodeFormats =
                                VideoDecodeFormatsCode.fromString(i)!;
                            widget.videoDetailCtr.updatePlayer();
                            Get.back();
                          },
                          contentPadding:
                              const EdgeInsets.only(left: 20, right: 20),
                          title: Text(VideoDecodeFormatsCode.fromString(i)!
                              .description!),
                          subtitle: Text(
                            i!,
                            style: subTitleStyle,
                          ),
                          trailing: i.startsWith(currentDecodeFormats.code)
                              ? Icon(
                                  Icons.done,
                                  color: Theme.of(context).colorScheme.primary,
                                )
                              : const SizedBox(),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 弹幕功能
  void showSetDanmaku() async {
    // 屏蔽类型
    final List<Map<String, dynamic>> blockTypesList = [
      {'value': 5, 'label': '顶部'},
      {'value': 2, 'label': '滚动'},
      {'value': 4, 'label': '底部'},
      {'value': 6, 'label': '彩色'},
    ];
    final List blockTypes = widget.controller.blockTypes;
    // 显示区域
    final List<Map<String, dynamic>> showAreas = [
      {'value': 0.25, 'label': '1/4屏'},
      {'value': 0.5, 'label': '半屏'},
      {'value': 0.75, 'label': '3/4屏'},
      {'value': 1.0, 'label': '满屏'},
    ];
    // 智能云屏蔽
    int danmakuWeight = widget.controller.danmakuWeight;
    // 显示区域
    double showArea = widget.controller.showArea;
    // 不透明度
    double opacityVal = widget.controller.opacityVal;
    // 字体大小
    double fontSizeVal = widget.controller.fontSizeVal;
    // 全屏字体大小
    double fontSizeFSVal = widget.controller.fontSizeFSVal;
    double subtitleFontScale = widget.controller.subtitleFontScale;
    double subtitleFontScaleFS = widget.controller.subtitleFontScaleFS;
    double danmakuLineHeight = widget.controller.danmakuLineHeight;
    // 弹幕速度
    double danmakuDurationVal = widget.controller.danmakuDurationVal;
    // 弹幕描边
    double strokeWidth = widget.controller.strokeWidth;
    // 字体粗细
    int fontWeight = widget.controller.fontWeight;
    bool massiveMode = widget.controller.massiveMode;
    int subtitlePaddingH = widget.controller.subtitlePaddingH;
    int subtitlePaddingB = widget.controller.subtitlePaddingB;
    double subtitleBgOpaticy = widget.controller.subtitleBgOpaticy;

    final DanmakuController? danmakuController =
        widget.controller.danmakuController;
    Utils.showFSSheet(
      isFullScreen: isFullScreen,
      padding: isFullScreen ? 70 : null,
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          margin: EdgeInsets.only(
            left: 12,
            top: 12,
            right: 12,
            bottom: MediaQuery.paddingOf(context).bottom + 12,
          ),
          padding: const EdgeInsets.only(left: 14, right: 14),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 45,
                  child: Center(child: Text('弹幕/字幕设置', style: titleStyle)),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text('智能云屏蔽 $danmakuWeight 级'),
                    const Spacer(),
                    TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () => {
                              Get.back(),
                              Get.toNamed('/danmakuBlock',
                                  arguments: widget.controller)
                            },
                        child: Text(
                            "屏蔽管理(${widget.controller.filterCount})")),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 0,
                    bottom: 6,
                    left: 10,
                    right: 10,
                  ),
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackShape: MSliderTrackShape(),
                      thumbColor: Theme.of(context).colorScheme.primary,
                      activeTrackColor: Theme.of(context).colorScheme.primary,
                      trackHeight: 10,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                    ),
                    child: Slider(
                      min: 0,
                      max: 10,
                      value: danmakuWeight.toDouble(),
                      divisions: 10,
                      label: '$danmakuWeight',
                      onChanged: (double val) {
                        danmakuWeight = val.toInt();
                        widget.controller
                          ..danmakuWeight = danmakuWeight
                          ..putDanmakuSettings();
                        setState(() {});
                      },
                    ),
                  ),
                ),
                const Text('按类型屏蔽'),
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 18),
                  child: Row(
                    children: [
                      for (final Map<String, dynamic> i in blockTypesList) ...[
                        ActionRowLineItem(
                          onTap: () async {
                            final bool isChoose =
                                blockTypes.contains(i['value']);
                            if (isChoose) {
                              blockTypes.remove(i['value']);
                            } else {
                              blockTypes.add(i['value']);
                            }
                            widget.controller
                              ..blockTypes = blockTypes
                              ..putDanmakuSettings();
                            setState(() {});
                            try {
                              danmakuController?.updateOption(
                                danmakuController.option.copyWith(
                                  hideTop: blockTypes.contains(5),
                                  hideBottom: blockTypes.contains(4),
                                  hideScroll: blockTypes.contains(2),
                                  // 添加或修改其他需要修改的选项属性
                                ),
                              );
                            } catch (_) {}
                          },
                          text: i['label'],
                          selectStatus: blockTypes.contains(i['value']),
                        ),
                        const SizedBox(width: 10),
                      ]
                    ],
                  ),
                ),
                const Text('显示区域'),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    children: [
                      for (final Map<String, dynamic> i in showAreas) ...[
                        ActionRowLineItem(
                          onTap: () {
                            showArea = i['value'];
                            widget.controller
                              ..showArea = showArea
                              ..putDanmakuSettings();
                            setState(() {});
                            try {
                              danmakuController?.updateOption(
                                danmakuController.option
                                    .copyWith(area: i['value']),
                              );
                            } catch (_) {}
                          },
                          text: i['label'],
                          selectStatus: showArea == i['value'],
                        ),
                        const SizedBox(width: 10),
                      ]
                    ],
                  ),
                ),
                SetSwitchItem(
                  title: '海量弹幕',
                  contentPadding: EdgeInsets.all(0),
                  titleStyle: TextStyle(fontSize: 14),
                  defaultVal: massiveMode,
                  setKey: SettingBoxKey.danmakuMassiveMode,
                  onChanged: (value) {
                    massiveMode = value;
                    widget.controller.massiveMode = value;
                    setState(() {});
                    try {
                      danmakuController?.updateOption(
                        danmakuController.option.copyWith(massiveMode: value),
                      );
                    } catch (_) {}
                  },
                ),
                Text('不透明度 ${opacityVal * 100}%'),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 0,
                    bottom: 6,
                    left: 10,
                    right: 10,
                  ),
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackShape: MSliderTrackShape(),
                      thumbColor: Theme.of(context).colorScheme.primary,
                      activeTrackColor: Theme.of(context).colorScheme.primary,
                      trackHeight: 10,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                    ),
                    child: Slider(
                      min: 0,
                      max: 1,
                      value: opacityVal,
                      divisions: 10,
                      label: '${opacityVal * 100}%',
                      onChanged: (double val) {
                        opacityVal = val;
                        widget.controller
                          ..opacityVal = opacityVal
                          ..putDanmakuSettings();
                        setState(() {});
                        try {
                          danmakuController?.updateOption(
                            danmakuController.option.copyWith(opacity: val),
                          );
                        } catch (_) {}
                      },
                    ),
                  ),
                ),
                Text('字体粗细 ${fontWeight + 1}（可能无法精确调节）'),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 0,
                    bottom: 6,
                    left: 10,
                    right: 10,
                  ),
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackShape: MSliderTrackShape(),
                      thumbColor: Theme.of(context).colorScheme.primary,
                      activeTrackColor: Theme.of(context).colorScheme.primary,
                      trackHeight: 10,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                    ),
                    child: Slider(
                      min: 0,
                      max: 8,
                      value: fontWeight.toDouble(),
                      divisions: 8,
                      label: '${fontWeight + 1}',
                      onChanged: (double val) {
                        fontWeight = val.toInt();
                        widget.controller
                          ..fontWeight = fontWeight
                          ..putDanmakuSettings();
                        setState(() {});
                        try {
                          danmakuController?.updateOption(
                            danmakuController.option
                                .copyWith(fontWeight: fontWeight),
                          );
                        } catch (_) {}
                      },
                    ),
                  ),
                ),
                Text('描边粗细 $strokeWidth'),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 0,
                    bottom: 6,
                    left: 10,
                    right: 10,
                  ),
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackShape: MSliderTrackShape(),
                      thumbColor: Theme.of(context).colorScheme.primary,
                      activeTrackColor: Theme.of(context).colorScheme.primary,
                      trackHeight: 10,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                    ),
                    child: Slider(
                      min: 0,
                      max: 3,
                      value: strokeWidth,
                      divisions: 6,
                      label: '$strokeWidth',
                      onChanged: (double val) {
                        strokeWidth = val;
                        widget.controller
                          ..strokeWidth = val
                          ..putDanmakuSettings();
                        setState(() {});
                        try {
                          danmakuController?.updateOption(
                            danmakuController.option.copyWith(strokeWidth: val),
                          );
                        } catch (_) {}
                      },
                    ),
                  ),
                ),
                Text('字体大小 ${(fontSizeVal * 100).toStringAsFixed(1)}%'),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 0,
                    bottom: 6,
                    left: 10,
                    right: 10,
                  ),
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackShape: MSliderTrackShape(),
                      thumbColor: Theme.of(context).colorScheme.primary,
                      activeTrackColor: Theme.of(context).colorScheme.primary,
                      trackHeight: 10,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                    ),
                    child: Slider(
                      min: 0.5,
                      max: 2.5,
                      value: fontSizeVal,
                      divisions: 20,
                      label: '${(fontSizeVal * 100).toStringAsFixed(1)}%',
                      onChanged: (double val) {
                        fontSizeVal = val;
                        widget.controller
                          ..fontSizeVal = fontSizeVal
                          ..putDanmakuSettings();
                        setState(() {});
                        if (widget.controller.isFullScreen.value == false) {
                          try {
                            danmakuController?.updateOption(
                              danmakuController.option.copyWith(
                                fontSize: (15 * fontSizeVal).toDouble(),
                              ),
                            );
                          } catch (_) {}
                        }
                      },
                    ),
                  ),
                ),
                Text('全屏字体大小 ${(fontSizeFSVal * 100).toStringAsFixed(1)}%'),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 0,
                    bottom: 6,
                    left: 10,
                    right: 10,
                  ),
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackShape: MSliderTrackShape(),
                      thumbColor: Theme.of(context).colorScheme.primary,
                      activeTrackColor: Theme.of(context).colorScheme.primary,
                      trackHeight: 10,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                    ),
                    child: Slider(
                      min: 0.5,
                      max: 2.5,
                      value: fontSizeFSVal,
                      divisions: 20,
                      label: '${(fontSizeFSVal * 100).toStringAsFixed(1)}%',
                      onChanged: (double val) {
                        fontSizeFSVal = val;
                        widget.controller
                          ..fontSizeFSVal = fontSizeFSVal
                          ..putDanmakuSettings();
                        setState(() {});
                        if (widget.controller.isFullScreen.value == true) {
                          try {
                            danmakuController?.updateOption(
                              danmakuController.option.copyWith(
                                fontSize: (15 * fontSizeFSVal).toDouble(),
                              ),
                            );
                          } catch (_) {}
                        }
                      },
                    ),
                  ),
                ),
                Text('弹幕时长 $danmakuDurationVal 秒'),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 0,
                    bottom: 6,
                    left: 10,
                    right: 10,
                  ),
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackShape: MSliderTrackShape(),
                      thumbColor: Theme.of(context).colorScheme.primary,
                      activeTrackColor: Theme.of(context).colorScheme.primary,
                      trackHeight: 10,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                    ),
                    child: Slider(
                      min: 1,
                      max: 4,
                      value: pow(danmakuDurationVal, 1 / 4) as double,
                      divisions: 60,
                      label: danmakuDurationVal.toString(),
                      onChanged: (double val) {
                        danmakuDurationVal =
                            (pow(val, 4) as double).toPrecision(2);
                        widget.controller
                          ..danmakuDurationVal = danmakuDurationVal
                          ..putDanmakuSettings();
                        setState(() {});
                        try {
                          danmakuController?.updateOption(
                            danmakuController.option.copyWith(
                                duration: danmakuDurationVal ~/
                                    widget.controller.playbackSpeed),
                          );
                        } catch (_) {}
                      },
                    ),
                  ),
                ),
                Text('弹幕行高 $danmakuLineHeight'),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 0,
                    bottom: 6,
                    left: 10,
                    right: 10,
                  ),
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackShape: MSliderTrackShape(),
                      thumbColor: Theme.of(context).colorScheme.primary,
                      activeTrackColor: Theme.of(context).colorScheme.primary,
                      trackHeight: 10,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                    ),
                    child: Slider(
                      min: 1.0,
                      max: 3.0,
                      value: danmakuLineHeight,
                      // label: '$danmakuLineHeight',
                      onChanged: (double val) {
                        danmakuLineHeight = val.toPrecision(1);
                        widget.controller
                          ..danmakuLineHeight = danmakuLineHeight
                          ..putDanmakuSettings();
                        setState(() {});
                        try {
                          danmakuController?.updateOption(
                            danmakuController.option.copyWith(
                              lineHeight: danmakuLineHeight,
                            ),
                          );
                        } catch (_) {}
                      },
                    ),
                  ),
                ),
                Text('字幕字体大小 ${(subtitleFontScale * 100).toStringAsFixed(1)}%'),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 0,
                    bottom: 6,
                    left: 10,
                    right: 10,
                  ),
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackShape: MSliderTrackShape(),
                      thumbColor: Theme.of(context).colorScheme.primary,
                      activeTrackColor: Theme.of(context).colorScheme.primary,
                      trackHeight: 10,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                    ),
                    child: Slider(
                      min: 0.5,
                      max: 2.5,
                      value: subtitleFontScale,
                      divisions: 20,
                      label: '${(subtitleFontScale * 100).toStringAsFixed(1)}%',
                      onChanged: (double val) {
                        subtitleFontScale = val;
                        widget.controller
                          ..subtitleFontScale = subtitleFontScale
                          ..updateSubtitleStyle()
                          ..putDanmakuSettings();
                        setState(() {});
                      },
                    ),
                  ),
                ),
                Text(
                    '全屏字幕字体大小 ${(subtitleFontScaleFS * 100).toStringAsFixed(1)}%'),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 0,
                    bottom: 6,
                    left: 10,
                    right: 10,
                  ),
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackShape: MSliderTrackShape(),
                      thumbColor: Theme.of(context).colorScheme.primary,
                      activeTrackColor: Theme.of(context).colorScheme.primary,
                      trackHeight: 10,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                    ),
                    child: Slider(
                      min: 0.5,
                      max: 2.5,
                      value: subtitleFontScaleFS,
                      divisions: 20,
                      label:
                          '${(subtitleFontScaleFS * 100).toStringAsFixed(1)}%',
                      onChanged: (double val) {
                        subtitleFontScaleFS = val;
                        widget.controller
                          ..subtitleFontScaleFS = subtitleFontScaleFS
                          ..updateSubtitleStyle()
                          ..putDanmakuSettings();
                        setState(() {});
                      },
                    ),
                  ),
                ),
                Text('字幕左右边距 $subtitlePaddingH'),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 0,
                    bottom: 6,
                    left: 10,
                    right: 10,
                  ),
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackShape: MSliderTrackShape(),
                      thumbColor: Theme.of(context).colorScheme.primary,
                      activeTrackColor: Theme.of(context).colorScheme.primary,
                      trackHeight: 10,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                    ),
                    child: Slider(
                      min: 0,
                      max: 100,
                      value: subtitlePaddingH.toDouble(),
                      divisions: 100,
                      label: '$subtitlePaddingH',
                      onChanged: (double val) {
                        subtitlePaddingH = val.round();
                        widget.controller
                          ..subtitlePaddingH = subtitlePaddingH
                          ..updateSubtitleStyle()
                          ..putDanmakuSettings();
                        setState(() {});
                      },
                    ),
                  ),
                ),
                Text('字幕底部边距 $subtitlePaddingB'),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 0,
                    bottom: 6,
                    left: 10,
                    right: 10,
                  ),
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackShape: MSliderTrackShape(),
                      thumbColor: Theme.of(context).colorScheme.primary,
                      activeTrackColor: Theme.of(context).colorScheme.primary,
                      trackHeight: 10,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                    ),
                    child: Slider(
                      min: 0,
                      max: 100,
                      value: subtitlePaddingB.toDouble(),
                      divisions: 100,
                      label: '$subtitlePaddingB',
                      onChanged: (double val) {
                        subtitlePaddingB = val.round();
                        widget.controller
                          ..subtitlePaddingB = subtitlePaddingB
                          ..updateSubtitleStyle()
                          ..putDanmakuSettings();
                        setState(() {});
                      },
                    ),
                  ),
                ),
                Text('字幕背景不透明度 ${(subtitleBgOpaticy * 100).toInt()}%'),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 0,
                    bottom: 6,
                    left: 10,
                    right: 10,
                  ),
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackShape: MSliderTrackShape(),
                      thumbColor: Theme.of(context).colorScheme.primary,
                      activeTrackColor: Theme.of(context).colorScheme.primary,
                      trackHeight: 10,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                    ),
                    child: Slider(
                      min: 0,
                      max: 1,
                      value: subtitleBgOpaticy,
                      // label: '${(subtitleBgOpaticy * 100).toInt()}%',
                      onChanged: (double val) {
                        subtitleBgOpaticy = val.toPrecision(2);
                        widget.controller
                          ..subtitleBgOpaticy = subtitleBgOpaticy
                          ..updateSubtitleStyle()
                          ..putDanmakuSettings();
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  /// 播放顺序
  void showSetRepeat() async {
    Utils.showFSSheet(
      isFullScreen: isFullScreen,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        margin: EdgeInsets.only(
          left: 12,
          top: 12,
          right: 12,
          bottom: 12 + MediaQuery.paddingOf(context).bottom,
        ),
        child: Column(
          children: [
            const SizedBox(
                height: 45,
                child: Center(child: Text('选择播放顺序', style: titleStyle))),
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: MediaQuery.removePadding(
                  context: context,
                  removeBottom: true,
                  child: ListView(
                    children: [
                      for (final PlayRepeat i in PlayRepeat.values) ...[
                        ListTile(
                          dense: true,
                          onTap: () {
                            widget.controller.setPlayRepeat(i);
                            Get.back();
                          },
                          contentPadding:
                              const EdgeInsets.only(left: 20, right: 20),
                          title: Text(i.description),
                          trailing: widget.controller.playRepeat == i
                              ? Icon(
                                  Icons.done,
                                  color: Theme.of(context).colorScheme.primary,
                                )
                              : const SizedBox(),
                        )
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  startClock() {
    clock ??= Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (!mounted) {
        return;
      }
      now.value = DateTime.now().toString().split(' ')[1].substring(0, 5);
    });
  }

  @override
  Widget build(BuildContext context) {
    final plPlayerController = widget.controller;
    // final bool isLandscape =
    //     MediaQuery.of(context).orientation == Orientation.landscape;

    bool equivalentFullScreen = !isFullScreen &&
        !horizontalScreen &&
        MediaQuery.of(context).orientation == Orientation.landscape;
    return LayoutBuilder(builder: (context, boxConstraints) {
      return AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        primary: false,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            SizedBox(
              width: 42,
              height: 34,
              child: IconButton(
                tooltip: '返回',
                icon: const Icon(
                  FontAwesomeIcons.arrowLeft,
                  size: 15,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (isFullScreen) {
                    widget.controller.triggerFullScreen(status: false);
                  } else if (MediaQuery.of(context).orientation ==
                          Orientation.landscape &&
                      !horizontalScreen) {
                    verticalScreenForTwoSeconds();
                  } else {
                    Get.back();
                  }
                },
              ),
            ),
            if (!isFullScreen ||
                MediaQuery.of(context).orientation != Orientation.portrait)
              SizedBox(
                width: 42,
                height: 34,
                child: IconButton(
                  tooltip: '返回主页',
                  icon: const Icon(
                    FontAwesomeIcons.house,
                    size: 15,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Get.until((route) => route.isFirst);
                  },
                ),
              ),
            if ((videoIntroController.videoDetail.value.title != null) &&
                (isFullScreen || equivalentFullScreen))
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: boxConstraints.maxWidth / 2 - 60,
                        maxHeight: 25),
                    child: Obx(
                      () => Marquee(
                        text: videoIntroController.videoDetail.value.title!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        scrollAxis: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        blankSpace: 200,
                        velocity: 40,
                        startAfter: const Duration(seconds: 1),
                        showFadingOnlyWhenScrolling: true,
                        fadingEdgeStartFraction: 0,
                        fadingEdgeEndFraction: 0.1,
                        numberOfRounds: 1,
                        startPadding: 0,
                        accelerationDuration: const Duration(seconds: 1),
                        accelerationCurve: Curves.linear,
                        decelerationDuration: const Duration(milliseconds: 500),
                        decelerationCurve: Curves.easeOut,
                      ),
                    ),
                  ),
                  if (videoIntroController.isShowOnlineTotal)
                    Obx(
                      () => Text(
                        '${videoIntroController.total.value}人正在看',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ),
                ],
              ),
            const Spacer(),
            if (MediaQuery.of(context).orientation == Orientation.landscape &&
                (isFullScreen || !horizontalScreen)) ...[
              // const Spacer(),
              // show current datetime
              Obx(
                () => Text(
                  now.value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 15),
            ],
            // ComBtn(
            //   icon: const Icon(
            //     FontAwesomeIcons.cropSimple,
            //     size: 15,
            //     color: Colors.white,
            //   ),
            //   fuc: () => _.screenshot(),
            // ),
            if (widget.videoDetailCtr.enableSponsorBlock == true)
              SizedBox(
                width: 42,
                height: 34,
                child: IconButton(
                  tooltip: '提交片段',
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(EdgeInsets.zero),
                  ),
                  onPressed: () => widget.videoDetailCtr.onBlock(context),
                  icon: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        size: 19,
                        color: Colors.white,
                      ),
                      Icon(
                        Icons.play_arrow_rounded,
                        size: 13,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            Obx(
              () => widget.videoDetailCtr.segmentList.isNotEmpty == true
                  ? SizedBox(
                      width: 42,
                      height: 34,
                      child: IconButton(
                        tooltip: '片段信息',
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all(EdgeInsets.zero),
                        ),
                        onPressed: () =>
                            widget.videoDetailCtr.showSBDetail(context),
                        icon: Icon(
                          MdiIcons.advertisements,
                          size: 19,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            SizedBox(
              width: 42,
              height: 34,
              child: IconButton(
                tooltip: '发弹幕',
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(EdgeInsets.zero),
                ),
                onPressed: widget.videoDetailCtr.showShootDanmakuSheet,
                icon: const Icon(
                  Icons.comment_outlined,
                  size: 19,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              width: 42,
              height: 34,
              child: Obx(
                () => IconButton(
                  tooltip:
                      "${plPlayerController.isOpenDanmu.value ? '关闭' : '开启'}弹幕",
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(EdgeInsets.zero),
                  ),
                  onPressed: () {
                    plPlayerController.isOpenDanmu.value =
                        !plPlayerController.isOpenDanmu.value;
                    setting.put(SettingBoxKey.enableShowDanmaku,
                        plPlayerController.isOpenDanmu.value);
                    // SmartDialog.showToast(
                    //     "已${plPlayerController.isOpenDanmu.value ? '开启' : '关闭'}弹幕",
                    //     displayTime: const Duration(seconds: 1));
                  },
                  icon: Icon(
                    plPlayerController.isOpenDanmu.value
                        ? Icons.subtitles_outlined
                        : Icons.subtitles_off_outlined,
                    size: 19,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            if (Platform.isAndroid)
              SizedBox(
                width: 42,
                height: 34,
                child: IconButton(
                  tooltip: '画中画',
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(EdgeInsets.zero),
                  ),
                  onPressed: () async {
                    bool canUsePiP = widget.floating != null &&
                        await widget.floating!.isPipAvailable;
                    widget.controller.hiddenControls(false);
                    if (canUsePiP) {
                      bool enableBackgroundPlay = setting.get(
                          SettingBoxKey.enableBackgroundPlay,
                          defaultValue: true);
                      if (!enableBackgroundPlay && context.mounted) {
                        // SmartDialog.showToast('建议开启【后台播放】功能\n避免画中画没有暂停按钮');
                        // await Future.delayed(const Duration(seconds: 2), () {
                        // });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Column(
                              children: [
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ),
                                    SizedBox(width: 10),
                                    Text('画中画',
                                        style: TextStyle(
                                            fontSize: 15, height: 1.5))
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                    '建议开启【后台音频服务】\n'
                                    '避免画中画没有暂停按钮',
                                    style:
                                        TextStyle(fontSize: 12.5, height: 1.5)),
                                Row(children: [
                                  TextButton(
                                      style: ButtonStyle(
                                        foregroundColor:
                                            WidgetStateProperty.resolveWith(
                                                (states) {
                                          return Theme.of(context)
                                              .snackBarTheme
                                              .actionTextColor;
                                        }),
                                      ),
                                      onPressed: () async {
                                        plPlayerController
                                            .setBackgroundPlay(true);
                                        SmartDialog.showToast("请重新载入本页面刷新");
                                        // Get.back();
                                      },
                                      child: const Text('启用后台音频服务')),
                                  const SizedBox(width: 10),
                                  TextButton(
                                      style: ButtonStyle(
                                        foregroundColor:
                                            WidgetStateProperty.resolveWith(
                                                (states) {
                                          return Theme.of(context)
                                              .snackBarTheme
                                              .actionTextColor;
                                        }),
                                      ),
                                      onPressed: () {},
                                      child: const Text('不启用'))
                                ])
                              ],
                            ),
                            duration: const Duration(seconds: 2),
                            showCloseIcon: true,
                          ),
                        );
                        await Future.delayed(const Duration(seconds: 3), () {});
                      }
                      final Rational aspectRatio = Rational(
                        widget.videoDetailCtr.data.dash!.video!.first.width!,
                        widget.videoDetailCtr.data.dash!.video!.first.height!,
                      );
                      if (!context.mounted) return;
                      await widget.floating!.enable(EnableManual(
                        aspectRatio: aspectRatio,
                      ));
                    } else {}
                  },
                  icon: const Icon(
                    Icons.picture_in_picture_outlined,
                    size: 19,
                    color: Colors.white,
                  ),
                ),
              ),
            SizedBox(
              width: 42,
              height: 34,
              child: IconButton(
                tooltip: "更多设置",
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(EdgeInsets.zero),
                ),
                onPressed: showSettingSheet,
                icon: const Icon(
                  Icons.more_vert_outlined,
                  size: 19,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class MSliderTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    SliderThemeData? sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    const double trackHeight = 3;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2 + 4;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
