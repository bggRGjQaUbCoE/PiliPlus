import 'dart:async';
import 'dart:convert' show jsonDecode, utf8;
import 'dart:io';
import 'dart:math';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/button/icon_button.dart';
import 'package:PiliPlus/common/widgets/custom_icon.dart';
import 'package:PiliPlus/common/widgets/dialog/report.dart';
import 'package:PiliPlus/common/widgets/marquee.dart';
import 'package:PiliPlus/http/danmaku.dart';
import 'package:PiliPlus/http/danmaku_block.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/live.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/super_resolution_type.dart';
import 'package:PiliPlus/models/common/video/audio_quality.dart';
import 'package:PiliPlus/models/common/video/cdn_type.dart';
import 'package:PiliPlus/models/common/video/video_decode_type.dart';
import 'package:PiliPlus/models/common/video/video_quality.dart';
import 'package:PiliPlus/models/video/play/url.dart';
import 'package:PiliPlus/models_new/video/video_play_info/subtitle.dart';
import 'package:PiliPlus/pages/common/common_intro_controller.dart';
import 'package:PiliPlus/pages/danmaku/danmaku_model.dart';
import 'package:PiliPlus/pages/setting/widgets/popup_item.dart';
import 'package:PiliPlus/pages/setting/widgets/select_dialog.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/pages/video/introduction/local/controller.dart';
import 'package:PiliPlus/pages/video/introduction/pgc/controller.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/controller.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/widgets/action_item.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/widgets/menu_row.dart';
import 'package:PiliPlus/pages/video/widgets/header_mixin.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_repeat.dart';
import 'package:PiliPlus/plugin/pl_player/utils/fullscreen.dart';
import 'package:PiliPlus/services/service_locator.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/extension/iterable_ext.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/extension/string_ext.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:PiliPlus/utils/video_utils.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:canvas_danmaku/canvas_danmaku.dart';
import 'package:dio/dio.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:file_picker/file_picker.dart';
import 'package:floating/floating.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide showBottomSheet;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

mixin TimeBatteryMixin<T extends StatefulWidget> on State<T> {
  PlPlayerController get plPlayerController;
  late final titleKey = GlobalKey();
  ContextSingleTicker? provider;
  ContextSingleTicker get effectiveProvider => provider ??= ContextSingleTicker(
    context,
    autoStart: () =>
        plPlayerController.showControls.value &&
        !plPlayerController.controlsLock.value,
  );

  bool get isPortrait;
  bool get isFullScreen;
  bool get horizontalScreen;

  Timer? _clock;
  RxString now = ''.obs;

  static final _format = DateFormat('HH:mm');

  @override
  void dispose() {
    stopClock();
    super.dispose();
  }

  void startClock() {
    if (!_showCurrTime) return;
    if (_clock == null) {
      now.value = _format.format(DateTime.now());
      _clock ??= Timer.periodic(const Duration(seconds: 1), (Timer t) {
        if (!mounted) {
          stopClock();
          return;
        }
        now.value = _format.format(DateTime.now());
      });
    }
  }

  void stopClock() {
    _clock?.cancel();
    _clock = null;
  }

  bool _showCurrTime = false;
  void showCurrTimeIfNeeded(bool isFullScreen) {
    _showCurrTime = !isPortrait && (isFullScreen || !horizontalScreen);
    if (!_showCurrTime) {
      stopClock();
    }
  }

  late final _battery = Battery();
  late final RxnInt _batteryLevel = RxnInt();
  late final _showBatteryLevel = Pref.showBatteryLevel;
  void getBatteryLevelIfNeeded() {
    if (!_showCurrTime || !_showBatteryLevel) return;
    EasyThrottle.throttle(
      'getBatteryLevel$hashCode',
      const Duration(seconds: 30),
      () async {
        try {
          _batteryLevel.value = await _battery.batteryLevel;
        } catch (_) {}
      },
    );
  }

  List<Widget>? get timeBatteryWidgets {
    if (_showCurrTime) {
      return [
        if (_showBatteryLevel) ...[
          Obx(
            () {
              final batteryLevel = _batteryLevel.value;
              if (batteryLevel == null) {
                return const SizedBox.shrink();
              }
              return Text(
                '$batteryLevel%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
        Obx(
          () => Text(
            now.value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
        ),
      ];
    }
    return null;
  }
}

class HeaderControl extends StatefulWidget {
  const HeaderControl({
    required this.isPortrait,
    required this.controller,
    required this.videoDetailCtr,
    required this.heroTag,
    super.key,
  });

  final bool isPortrait;
  final PlPlayerController controller;
  final VideoDetailController videoDetailCtr;
  final String heroTag;

  @override
  State<HeaderControl> createState() => HeaderControlState();

  static Future<bool> likeDanmaku(VideoDanmaku extra, int cid) async {
    if (!Accounts.main.isLogin) {
      SmartDialog.showToast('请先登录');
      return false;
    }
    final isLike = !extra.isLike;
    final res = await DanmakuHttp.danmakuLike(
      isLike: isLike,
      cid: cid,
      id: extra.id,
    );
    if (res.isSuccess) {
      extra.isLike = isLike;
      if (isLike) {
        extra.like++;
      } else {
        extra.like--;
      }
      SmartDialog.showToast('${isLike ? '' : '取消'}点赞成功');
      return true;
    } else {
      res.toast();
      if (res case Error(:final code)) {
        if (code == 65006) {
          extra.isLike = true;
          return true;
        }
        if (code == 65004) {
          extra.isLike = false;
          return true;
        }
      }
      return false;
    }
  }

  static Future<bool> deleteDanmaku(int id, int cid) async {
    final res = await DanmakuHttp.danmakuRecall(
      cid: cid,
      id: id,
    );
    if (res.isSuccess) {
      SmartDialog.showToast('删除成功');
      return true;
    } else {
      res.toast();
      return false;
    }
  }

  static Future<void> reportDanmaku(
    BuildContext context, {
    required VideoDanmaku extra,
    required PlPlayerController ctr,
  }) {
    if (Accounts.main.isLogin) {
      return autoWrapReportDialog(
        context,
        ReportOptions.danmakuReport,
        (reasonType, reasonDesc, banUid) {
          if (banUid) {
            final filter = ctr.filters;
            if (filter.dmUid.add(extra.mid)) {
              filter.count++;
              GStorage.localCache.put(
                LocalCacheKey.danmakuFilterRules,
                filter,
              );
            }
            DanmakuFilterHttp.danmakuFilterAdd(
              filter: extra.mid,
              type: 2,
            );
          }
          return DanmakuHttp.danmakuReport(
            reason: reasonType == 0 ? 11 : reasonType,
            cid: ctr.cid!,
            id: extra.id,
            content: reasonType == 0 ? reasonDesc : null,
          );
        },
      );
    } else {
      return SmartDialog.showToast('请先登录');
    }
  }

  static Future<void> reportLiveDanmaku(
    BuildContext context, {
    required int roomId,
    required String msg,
    required LiveDanmaku extra,
  }) {
    if (Accounts.main.isLogin) {
      return autoWrapReportDialog(
        context,
        ban: false,
        ReportOptions.liveDanmakuReport,
        (reasonType, reasonDesc, banUid) {
          // if (banUid) {
          //   final filter = ctr.filters;
          //   if (filter.dmUid.add(extra.mid)) {
          //     filter.count++;
          //     GStorage.localCache.put(
          //       LocalCacheKey.danmakuFilterRules,
          //       filter,
          //     );
          //   }
          //   DanmakuFilterHttp.danmakuFilterAdd(
          //     filter: extra.mid,
          //     type: 2,
          //   );
          // }
          return LiveHttp.liveDmReport(
            roomId: roomId,
            mid: extra.mid,
            msg: msg,
            reason: ReportOptions.liveDanmakuReport['']![reasonType]!,
            reasonId: reasonType,
            dmType: extra.dmType,
            idStr: extra.id,
            ts: extra.ts,
            sign: extra.ct,
          );
        },
      );
    } else {
      return SmartDialog.showToast('请先登录');
    }
  }
}

class HeaderControlState extends State<HeaderControl>
    with HeaderMixin, TimeBatteryMixin {
  @override
  late final PlPlayerController plPlayerController = widget.controller;
  late final VideoDetailController videoDetailCtr = widget.videoDetailCtr;
  late final PlayUrlModel videoInfo = videoDetailCtr.data;
  static const TextStyle subTitleStyle = TextStyle(fontSize: 12);
  static const TextStyle titleStyle = TextStyle(fontSize: 14);

  String get heroTag => widget.heroTag;
  late final UgcIntroController ugcIntroController;
  late final PgcIntroController pgcIntroController;
  late final LocalIntroController localIntroController;
  late CommonIntroController introController = isFileSource
      ? localIntroController
      : videoDetailCtr.isUgc
      ? ugcIntroController
      : pgcIntroController;

  @override
  bool get isPortrait => widget.isPortrait;
  @override
  late final horizontalScreen = videoDetailCtr.horizontalScreen;

  Box setting = GStorage.setting;

  @override
  void initState() {
    super.initState();
    if (isFileSource) {
      introController = Get.find<LocalIntroController>(tag: heroTag);
    } else if (videoDetailCtr.isUgc) {
      introController = Get.find<UgcIntroController>(tag: heroTag);
    } else {
      introController = Get.find<PgcIntroController>(tag: heroTag);
    }
  }

  /// 设置面板
  void showSettingSheet() {
    showBottomSheet(
      (context, setState) {
        final theme = Theme.of(context);
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Material(
            clipBehavior: Clip.hardEdge,
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 14),
              children: [
                ListTile(
                  dense: true,
                  onTap: () {
                    Get.back();
                    introController.viewLater();
                  },
                  leading: const Icon(Icons.watch_later_outlined, size: 20),
                  title: const Text('添加至「稍后再看」', style: titleStyle),
                ),
                if (videoDetailCtr.epId == null)
                  ListTile(
                    dense: true,
                    onTap: () {
                      Get.back();
                      videoDetailCtr.showNoteList(context);
                    },
                    leading: const Icon(Icons.note_alt_outlined, size: 20),
                    title: const Text('查看笔记', style: titleStyle),
                  ),
                if (!isFileSource)
                  ListTile(
                    dense: true,
                    onTap: () {
                      Get.back();
                      videoDetailCtr.onDownload(this.context);
                    },
                    leading: const Icon(
                      MdiIcons.folderDownloadOutline,
                      size: 20,
                    ),
                    title: const Text('离线缓存', style: titleStyle),
                  ),
                if (widget.videoDetailCtr.cover.value.isNotEmpty)
                  ListTile(
                    dense: true,
                    onTap: () {
                      Get.back();
                      ImageUtils.downloadImg([
                        widget.videoDetailCtr.cover.value,
                      ]);
                    },
                    leading: const Icon(Icons.image_outlined, size: 20),
                    title: const Text('保存封面', style: titleStyle),
                  ),
                ListTile(
                  dense: true,
                  onTap: () {
                    Get.back();
                    PageUtils.scheduleExit(this.context, isFullScreen);
                  },
                  leading: const Icon(Icons.hourglass_top_outlined, size: 20),
                  title: const Text('定时关闭', style: titleStyle),
                ),
                if (!isFileSource) ...[
                  ListTile(
                    dense: true,
                    onTap: () {
                      Get.back();
                      videoDetailCtr.editPlayUrl();
                    },
                    leading: const Icon(
                      Icons.link,
                      size: 20,
                    ),
                    title: const Text('播放地址', style: titleStyle),
                  ),
                  ListTile(
                    dense: true,
                    onTap: () {
                      Get.back();
                      videoDetailCtr.queryVideoUrl(
                        defaultST: videoDetailCtr.playedTime,
                        fromReset: true,
                      );
                    },
                    leading: const Icon(Icons.refresh_outlined, size: 20),
                    title: const Text('重载视频', style: titleStyle),
                  ),
                ],
                PopupListTile<SuperResolutionType>(
                  dense: true,
                  leading: const Icon(
                    Icons.stay_current_landscape_outlined,
                    size: 20,
                  ),
                  title: const Text('超分辨率'),
                  value: () {
                    final value = plPlayerController.superResolutionType.value;
                    return (value, value.label);
                  },
                  itemBuilder: (_) => enumItemBuilder<SuperResolutionType>(
                    SuperResolutionType.values,
                  ),
                  onSelected: (value, setState) {
                    plPlayerController.setShader(value);
                    setState();
                  },
                  descPosType: .title,
                ),
                if (!isFileSource)
                  ListTile(
                    dense: true,
                    title: const Text('CDN 设置', style: titleStyle),
                    leading: const Icon(MdiIcons.cloudPlusOutline, size: 20),
                    subtitle: Text(
                      '当前：${VideoUtils.cdnService.desc}，无法播放请切换',
                      style: subTitleStyle,
                    ),
                    onTap: () async {
                      Get.back();
                      final result = await showDialog<CDNService>(
                        context: context,
                        builder: (context) => CdnSelectDialog(
                          sample: videoInfo.dash?.video?.firstOrNull,
                        ),
                      );
                      if (result != null) {
                        VideoUtils.cdnService = result;
                        setting.put(SettingBoxKey.CDNService, result.name);
                        SmartDialog.showToast('已设置为 ${result.desc}，正在重载视频');
                        videoDetailCtr.queryVideoUrl(
                          defaultST: videoDetailCtr.playedTime,
                          fromReset: true,
                        );
                      }
                    },
                  ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    spacing: 10,
                    children: [
                      Obx(
                        () {
                          final flipX = plPlayerController.flipX.value;
                          return ActionRowLineItem(
                            iconData: Icons.flip,
                            onTap: () =>
                                plPlayerController.flipX.value = !flipX,
                            text: " 左右翻转 ",
                            selectStatus: flipX,
                          );
                        },
                      ),
                      Obx(
                        () {
                          final flipY = plPlayerController.flipY.value;
                          return ActionRowLineItem(
                            icon: Transform.rotate(
                              angle: pi / 2,
                              child: Icon(
                                Icons.flip,
                                size: 13,
                                color: flipY
                                    ? theme.colorScheme.onSecondaryContainer
                                    : theme.colorScheme.outline,
                              ),
                            ),
                            onTap: () {
                              plPlayerController.flipY.value = !flipY;
                            },
                            text: " 上下翻转 ",
                            selectStatus: flipY,
                          );
                        },
                      ),
                      if ((isFileSource && plPlayerController.mediaType != 1) ||
                          (!isFileSource &&
                              videoDetailCtr.audioUrl?.isNotEmpty == true))
                        Obx(
                          () {
                            final onlyPlayAudio =
                                plPlayerController.onlyPlayAudio.value;
                            return ActionRowLineItem(
                              iconData: Icons.headphones,
                              onTap: () {
                                plPlayerController.onlyPlayAudio.value =
                                    !onlyPlayAudio;
                                widget.videoDetailCtr.playerInit();
                              },
                              text: " 听视频 ",
                              selectStatus: onlyPlayAudio,
                            );
                          },
                        ),
                      Obx(
                        () => ActionRowLineItem(
                          iconData: Icons.play_circle_outline,
                          onTap: plPlayerController.setContinuePlayInBackground,
                          text: " 后台播放 ",
                          selectStatus:
                              plPlayerController.continuePlayInBackground.value,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isFileSource) ...[
                  ListTile(
                    dense: true,
                    onTap: () {
                      Get.back();
                      showSetVideoQa();
                    },
                    leading: const Icon(Icons.play_circle_outline, size: 20),
                    title: const Text('选择画质', style: titleStyle),
                    subtitle: Text(
                      '当前画质 ${videoDetailCtr.currentVideoQa.value?.desc}',
                      style: subTitleStyle,
                    ),
                  ),
                  if (videoDetailCtr.currentAudioQa != null)
                    ListTile(
                      dense: true,
                      onTap: () {
                        Get.back();
                        showSetAudioQa();
                      },
                      leading: const Icon(Icons.album_outlined, size: 20),
                      title: const Text('选择音质', style: titleStyle),
                      subtitle: Text(
                        '当前音质 ${videoDetailCtr.currentAudioQa!.desc}',
                        style: subTitleStyle,
                      ),
                    ),
                  ListTile(
                    dense: true,
                    onTap: () {
                      Get.back();
                      showSetDecodeFormats();
                    },
                    leading: const Icon(Icons.av_timer_outlined, size: 20),
                    title: const Text('解码格式', style: titleStyle),
                    subtitle: Text(
                      '当前解码格式 ${videoDetailCtr.currentDecodeFormats.description}',
                      style: subTitleStyle,
                    ),
                  ),
                ],
                ListTile(
                  dense: true,
                  onTap: () {
                    Get.back();
                    showSetRepeat();
                  },
                  leading: const Icon(Icons.repeat, size: 20),
                  title: const Text('播放顺序', style: titleStyle),
                  subtitle: Text(
                    plPlayerController.playRepeat.desc,
                    style: subTitleStyle,
                  ),
                ),
                ListTile(
                  dense: true,
                  onTap: () {
                    Get.back();
                    showDanmakuPool();
                  },
                  leading: const Icon(CustomIcons.dm_on, size: 20),
                  title: const Text('弹幕列表', style: titleStyle),
                ),
                ListTile(
                  dense: true,
                  onTap: () {
                    Get.back();
                    showSetDanmaku();
                  },
                  leading: const Icon(CustomIcons.dm_settings, size: 20),
                  title: const Text('弹幕设置', style: titleStyle),
                ),
                ListTile(
                  dense: true,
                  onTap: () {
                    Get.back();
                    showSetSubtitle();
                  },
                  leading: const Icon(Icons.subtitles_outlined, size: 20),
                  title: const Text('字幕设置', style: titleStyle),
                ),
                ListTile(
                  dense: true,
                  onTap: () async {
                    Get.back();
                    try {
                      final result = await FilePicker.platform.pickFiles();
                      if (result != null) {
                        final file = result.files.single;
                        final path = file.path;
                        if (path != null) {
                          final name = file.name;
                          final length = videoDetailCtr.subtitles.length;
                          if (name.endsWith('.json')) {
                            final file = File(path);
                            final stream = file.openRead().transform(
                              utf8.decoder,
                            );
                            final buffer = StringBuffer();
                            await for (final chunk in stream) {
                              if (!mounted) return;
                              buffer.write(chunk);
                            }
                            if (!mounted) return;
                            String sub = buffer.toString();
                            sub = await compute<List, String>(
                              VideoHttp.processList,
                              jsonDecode(sub)['body'],
                            );
                            if (!mounted) return;
                            videoDetailCtr.vttSubtitles[length] = (
                              isData: true,
                              id: sub,
                            );
                          } else {
                            videoDetailCtr.vttSubtitles[length] = (
                              isData: false,
                              id: path,
                            );
                          }
                          videoDetailCtr.subtitles.add(
                            Subtitle(
                              lan: '',
                              lanDoc: name.split('.').firstOrNull ?? name,
                            ),
                          );
                          await videoDetailCtr.setSubtitle(length + 1);
                        }
                      }
                    } catch (e) {
                      SmartDialog.showToast('加载失败: $e');
                    }
                  },
                  leading: const Icon(Icons.file_open_outlined, size: 20),
                  title: const Text('加载字幕', style: titleStyle),
                ),
                if (!videoDetailCtr.isFileSource &&
                    videoDetailCtr.subtitles.isNotEmpty)
                  ListTile(
                    dense: true,
                    onTap: () {
                      Get.back();
                      onExportSubtitle();
                    },
                    leading: const Icon(Icons.download_outlined, size: 20),
                    title: const Text('保存字幕', style: titleStyle),
                  ),
                ListTile(
                  dense: true,
                  title: const Text('播放信息', style: titleStyle),
                  leading: const Icon(Icons.info_outline, size: 20),
                  onTap: () => showPlayerInfo(
                    context,
                    plPlayerController: plPlayerController,
                  ),
                ),
                ListTile(
                  dense: true,
                  onTap: () {
                    if (!Accounts.main.isLogin) {
                      SmartDialog.showToast('账号未登录');
                      return;
                    }
                    Get.back();
                    PageUtils.reportVideo(videoDetailCtr.aid);
                  },
                  leading: const Icon(Icons.error_outline, size: 20),
                  title: const Text('举报', style: titleStyle),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> showPlayerInfo(
    BuildContext context, {
    required PlPlayerController plPlayerController,
  }) async {
    final player = plPlayerController.videoPlayerController;
    if (player == null) {
      SmartDialog.showToast('播放器未初始化');
      return;
    }
    final hwdec = await player.platform!.getProperty(
      'hwdec-current',
    );
    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (context) {
        final state = player.state;
        final colorScheme = ColorScheme.of(context);
        return AlertDialog(
          title: const Text('播放信息'),
          contentPadding: const EdgeInsets.only(top: 16),
          content: Material(
            type: MaterialType.transparency,
            child: ListTileTheme(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListTile(
                      dense: true,
                      title: const Text("Resolution"),
                      subtitle: Text(
                        '${state.width}x${state.height}',
                      ),
                      onTap: () => Utils.copyText(
                        'Resolution\n${state.width}x${state.height}',
                      ),
                    ),
                    ListTile(
                      dense: true,
                      title: const Text("VideoParams"),
                      subtitle: Text(
                        state.videoParams.toString(),
                      ),
                      onTap: () => Utils.copyText(
                        'VideoParams\n${state.videoParams}',
                      ),
                    ),
                    ListTile(
                      dense: true,
                      title: const Text("AudioParams"),
                      subtitle: Text(
                        state.audioParams.toString(),
                      ),
                      onTap: () => Utils.copyText(
                        'AudioParams\n${state.audioParams}',
                      ),
                    ),
                    ListTile(
                      dense: true,
                      title: const Text("Media"),
                      subtitle: Text(
                        state.playlist.toString(),
                      ),
                      onTap: () => Utils.copyText(
                        'Media\n${state.playlist}',
                      ),
                    ),
                    ListTile(
                      dense: true,
                      title: const Text("AudioTrack"),
                      subtitle: Text(
                        state.track.audio.toString(),
                      ),
                      onTap: () => Utils.copyText(
                        'AudioTrack\n${state.track.audio}',
                      ),
                    ),
                    ListTile(
                      dense: true,
                      title: const Text("VideoTrack"),
                      subtitle: Text(
                        state.track.video.toString(),
                      ),
                      onTap: () => Utils.copyText(
                        'VideoTrack\n${state.track.audio}',
                      ),
                    ),
                    ListTile(
                      dense: true,
                      title: const Text("pitch"),
                      subtitle: Text(state.pitch.toString()),
                      onTap: () => Utils.copyText(
                        'pitch\n${state.pitch}',
                      ),
                    ),
                    ListTile(
                      dense: true,
                      title: const Text("rate"),
                      subtitle: Text(state.rate.toString()),
                      onTap: () => Utils.copyText('rate\n${state.rate}'),
                    ),
                    ListTile(
                      dense: true,
                      title: const Text("AudioBitrate"),
                      subtitle: Text(
                        state.audioBitrate.toString(),
                      ),
                      onTap: () => Utils.copyText(
                        'AudioBitrate\n${state.audioBitrate}',
                      ),
                    ),
                    ListTile(
                      dense: true,
                      title: const Text("Volume"),
                      subtitle: Text(
                        state.volume.toString(),
                      ),
                      onTap: () => Utils.copyText(
                        'Volume\n${state.volume}',
                      ),
                    ),
                    ListTile(
                      dense: true,
                      title: const Text('hwdec'),
                      subtitle: Text(hwdec),
                      onTap: () => Utils.copyText('hwdec\n$hwdec'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: Get.back,
              child: Text(
                '确定',
                style: TextStyle(color: colorScheme.outline),
              ),
            ),
          ],
        );
      },
    );
  }

  /// 选择画质
  void showSetVideoQa() {
    if (videoInfo.dash == null) {
      SmartDialog.showToast('当前视频不支持选择画质');
      return;
    }
    final VideoQuality? currentVideoQa = videoDetailCtr.currentVideoQa.value;
    if (currentVideoQa == null) return;

    final List<FormatItem> videoFormat = videoInfo.supportFormats!;

    /// 总质量分类
    final int totalQaSam = videoFormat.length;

    /// 可用的质量分类
    int usefulQaSam = 0;
    final List<VideoItem> video = videoInfo.dash!.video!;
    final Set<int> idSet = {};
    for (final VideoItem item in video) {
      final int id = item.id!;
      if (!idSet.contains(id)) {
        idSet.add(id);
        usefulQaSam++;
      }
    }

    showBottomSheet(
      (context, setState) {
        final theme = Theme.of(context);
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Material(
            clipBehavior: Clip.hardEdge,
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 45,
                    child: GestureDetector(
                      onTap: () => SmartDialog.showToast(
                        '标灰画质需要bilibili会员（已是会员？请关闭无痕模式）；4k和杜比视界播放效果可能不佳',
                      ),
                      child: Row(
                        spacing: 8,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('选择画质', style: titleStyle),
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: theme.colorScheme.outline,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverList.builder(
                  itemCount: totalQaSam,
                  itemBuilder: (context, index) {
                    final item = videoFormat[index];
                    final isCurr = currentVideoQa.code == item.quality;
                    return ListTile(
                      dense: true,
                      onTap: () async {
                        if (isCurr) {
                          return;
                        }
                        Get.back();
                        final int quality = item.quality!;
                        final newQa = VideoQuality.fromCode(quality);
                        videoDetailCtr
                          ..plPlayerController.cacheVideoQa = newQa.code
                          ..currentVideoQa.value = newQa
                          ..updatePlayer();

                        SmartDialog.showToast("画质已变为：${newQa.desc}");

                        // update
                        if (!plPlayerController.tempPlayerConf) {
                          setting.put(
                            await Utils.isWiFi
                                ? SettingBoxKey.defaultVideoQa
                                : SettingBoxKey.defaultVideoQaCellular,
                            quality,
                          );
                        }
                      },
                      // 可能包含会员解锁画质
                      enabled: index >= totalQaSam - usefulQaSam,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      title: Text(item.newDesc!),
                      trailing: isCurr
                          ? Icon(
                              Icons.done,
                              color: theme.colorScheme.primary,
                            )
                          : Text(
                              item.format!,
                              style: subTitleStyle,
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 选择音质
  void showSetAudioQa() {
    final AudioQuality currentAudioQa = videoDetailCtr.currentAudioQa!;
    final List<AudioItem> audio = videoInfo.dash!.audio!;
    showBottomSheet(
      (context, setState) {
        final theme = Theme.of(context);
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Material(
            clipBehavior: Clip.hardEdge,
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 45,
                    child: Center(
                      child: Text('选择音质', style: titleStyle),
                    ),
                  ),
                ),
                SliverList.builder(
                  itemCount: audio.length,
                  itemBuilder: (context, index) {
                    final item = audio[index];
                    final isCurr = currentAudioQa.code == item.id;
                    return ListTile(
                      dense: true,
                      onTap: () async {
                        if (isCurr) {
                          return;
                        }
                        Get.back();
                        final int quality = item.id!;
                        final newQa = AudioQuality.fromCode(quality);
                        videoDetailCtr
                          ..plPlayerController.cacheAudioQa = newQa.code
                          ..currentAudioQa = newQa
                          ..updatePlayer();

                        SmartDialog.showToast("音质已变为：${newQa.desc}");

                        // update
                        if (!plPlayerController.tempPlayerConf) {
                          setting.put(
                            await Utils.isWiFi
                                ? SettingBoxKey.defaultAudioQa
                                : SettingBoxKey.defaultAudioQaCellular,
                            quality,
                          );
                        }
                      },
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      title: Text(item.quality),
                      subtitle: Text(
                        item.codecs!,
                        style: subTitleStyle,
                      ),
                      trailing: isCurr
                          ? Icon(
                              Icons.done,
                              color: theme.colorScheme.primary,
                            )
                          : null,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 选择解码格式
  void showSetDecodeFormats() {
    final VideoItem firstVideo = videoDetailCtr.firstVideo;
    // 当前视频可用的解码格式
    final List<FormatItem> videoFormat = videoInfo.supportFormats!;
    final List<String>? list = videoFormat
        .firstWhere((FormatItem e) => e.quality == firstVideo.quality.code)
        .codecs;
    if (list == null) {
      SmartDialog.showToast('当前视频不支持选择解码格式');
      return;
    }

    // 当前选中的解码格式
    final VideoDecodeFormatType currentDecodeFormats =
        videoDetailCtr.currentDecodeFormats;
    showBottomSheet(
      (context, setState) {
        final theme = Theme.of(context);
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Material(
            clipBehavior: Clip.hardEdge,
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: Column(
              children: [
                const SizedBox(
                  height: 45,
                  child: Center(
                    child: Text('选择解码格式', style: titleStyle),
                  ),
                ),
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverList.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final item = list[index];
                          final format = VideoDecodeFormatType.fromString(item);
                          final isCurr = currentDecodeFormats.codes.any(
                            item.startsWith,
                          );
                          return ListTile(
                            dense: true,
                            onTap: () {
                              if (isCurr) {
                                return;
                              }
                              Get.back();
                              videoDetailCtr
                                ..currentDecodeFormats = format
                                ..updatePlayer();
                            },
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            title: Text(format.description),
                            subtitle: Text(item, style: subTitleStyle),
                            trailing: isCurr
                                ? Icon(
                                    Icons.done,
                                    color: theme.colorScheme.primary,
                                  )
                                : null,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void onExportSubtitle() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        clipBehavior: Clip.hardEdge,
        contentPadding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
        title: const Text('保存字幕'),
        content: SingleChildScrollView(
          child: Column(
            children: videoDetailCtr.subtitles
                .map(
                  (item) => ListTile(
                    dense: true,
                    onTap: () async {
                      Get.back();
                      final url = item.subtitleUrl;
                      if (url == null || url.isEmpty) return;
                      try {
                        final res = await Request.dio.get<Uint8List>(
                          url.http2https,
                          options: Options(
                            responseType: ResponseType.bytes,
                            headers: Constants.baseHeaders,
                            extra: {'account': const NoAccount()},
                          ),
                        );
                        if (res.statusCode == 200) {
                          final bytes = Uint8List.fromList(
                            Request.responseBytesDecoder(
                              res.data!,
                              res.headers.map,
                            ),
                          );
                          String name =
                              '${introController.videoDetail.value.title}-${videoDetailCtr.bvid}-${videoDetailCtr.cid.value}-${item.lanDoc}.json';
                          if (Platform.isWindows) {
                            // Reserved characters may not be used in file names. See: https://docs.microsoft.com/en-us/windows/win32/fileio/naming-a-file#naming-conventions
                            name = name.replaceAll(
                              RegExp(r'[<>:/\\|?*"]'),
                              '',
                            );
                          }
                          Utils.saveBytes2File(
                            name: name,
                            bytes: bytes,
                            allowedExtensions: const ['json'],
                          );
                        }
                      } catch (e, s) {
                        Utils.reportError(e, s);
                        SmartDialog.showToast(e.toString());
                      }
                    },
                    title: Text(
                      item.lanDoc!,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  double get subtitleFontScale => plPlayerController.subtitleFontScale;
  double get subtitleFontScaleFS => plPlayerController.subtitleFontScaleFS;
  int get subtitlePaddingH => plPlayerController.subtitlePaddingH;
  int get subtitlePaddingB => plPlayerController.subtitlePaddingB;
  double get subtitleBgOpacity => plPlayerController.subtitleBgOpacity;
  double get subtitleStrokeWidth => plPlayerController.subtitleStrokeWidth;
  int get subtitleFontWeight => plPlayerController.subtitleFontWeight;

  /// 字幕设置
  void showSetSubtitle() {
    showBottomSheet(
      padding: isFullScreen ? 70 : null,
      (context, setState) {
        final theme = Theme.of(context);

        final sliderTheme = SliderThemeData(
          trackHeight: 10,
          trackShape: const MSliderTrackShape(),
          thumbColor: theme.colorScheme.primary,
          activeTrackColor: theme.colorScheme.primary,
          inactiveTrackColor: theme.colorScheme.onInverseSurface,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
        );

        void updateStrokeWidth(double val) {
          plPlayerController
            ..subtitleStrokeWidth = val
            ..updateSubtitleStyle();
          setState(() {});
        }

        void updateOpacity(double val) {
          plPlayerController
            ..subtitleBgOpacity = val.toPrecision(2)
            ..updateSubtitleStyle();
          setState(() {});
        }

        void updateBottomPadding(double val) {
          plPlayerController
            ..subtitlePaddingB = val.round()
            ..updateSubtitleStyle();
          setState(() {});
        }

        void updateHorizontalPadding(double val) {
          plPlayerController
            ..subtitlePaddingH = val.round()
            ..updateSubtitleStyle();
          setState(() {});
        }

        void updateFontScaleFS(double val) {
          plPlayerController
            ..subtitleFontScaleFS = val
            ..updateSubtitleStyle();
          setState(() {});
        }

        void updateFontScale(double val) {
          plPlayerController
            ..subtitleFontScale = val
            ..updateSubtitleStyle();
          setState(() {});
        }

        void updateFontWeight(double val) {
          plPlayerController
            ..subtitleFontWeight = val.toInt()
            ..updateSubtitleStyle();
          setState(() {});
        }

        return Padding(
          padding: const EdgeInsets.all(12),
          child: Material(
            clipBehavior: Clip.hardEdge,
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const SizedBox(
                    height: 45,
                    child: Center(child: Text('字幕设置', style: titleStyle)),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '字体大小 ${(subtitleFontScale * 100).toStringAsFixed(1)}%',
                      ),
                      resetBtn(theme, '100.0%', () => updateFontScale(1.0)),
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
                      data: sliderTheme,
                      child: Slider(
                        min: 0.5,
                        max: 2.5,
                        value: subtitleFontScale,
                        divisions: 20,
                        label:
                            '${(subtitleFontScale * 100).toStringAsFixed(1)}%',
                        onChanged: updateFontScale,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '全屏字体大小 ${(subtitleFontScaleFS * 100).toStringAsFixed(1)}%',
                      ),
                      resetBtn(theme, '150.0%', () => updateFontScaleFS(1.5)),
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
                      data: sliderTheme,
                      child: Slider(
                        min: 0.5,
                        max: 2.5,
                        value: subtitleFontScaleFS,
                        divisions: 20,
                        label:
                            '${(subtitleFontScaleFS * 100).toStringAsFixed(1)}%',
                        onChanged: updateFontScaleFS,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('字体粗细 ${subtitleFontWeight + 1}（可能无法精确调节）'),
                      resetBtn(theme, 6, () => updateFontWeight(5)),
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
                      data: sliderTheme,
                      child: Slider(
                        min: 0,
                        max: 8,
                        value: subtitleFontWeight.toDouble(),
                        divisions: 8,
                        label: '${subtitleFontWeight + 1}',
                        onChanged: updateFontWeight,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('描边粗细 $subtitleStrokeWidth'),
                      resetBtn(theme, 2.0, () => updateStrokeWidth(2.0)),
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
                      data: sliderTheme,
                      child: Slider(
                        min: 0,
                        max: 5,
                        value: subtitleStrokeWidth,
                        divisions: 10,
                        label: '$subtitleStrokeWidth',
                        onChanged: updateStrokeWidth,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('左右边距 $subtitlePaddingH'),
                      resetBtn(theme, 24, () => updateHorizontalPadding(24)),
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
                      data: sliderTheme,
                      child: Slider(
                        min: 0,
                        max: 100,
                        value: subtitlePaddingH.toDouble(),
                        divisions: 100,
                        label: '$subtitlePaddingH',
                        onChanged: updateHorizontalPadding,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('底部边距 $subtitlePaddingB'),
                      resetBtn(theme, 24, () => updateBottomPadding(24)),
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
                      data: sliderTheme,
                      child: Slider(
                        min: 0,
                        max: 200,
                        value: subtitlePaddingB.toDouble(),
                        divisions: 200,
                        label: '$subtitlePaddingB',
                        onChanged: updateBottomPadding,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('背景不透明度 ${(subtitleBgOpacity * 100).toInt()}%'),
                      resetBtn(theme, '67%', () => updateOpacity(0.67)),
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
                      data: sliderTheme,
                      child: Slider(
                        min: 0,
                        max: 1,
                        value: subtitleBgOpacity,
                        onChanged: updateOpacity,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    )?.whenComplete(plPlayerController.putSubtitleSettings);
  }

  void showDanmakuPool() {
    final ctr = plPlayerController.danmakuController;
    if (ctr == null) return;
    showBottomSheet((context, setState) {
      final theme = Theme.of(context);
      return Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Column(
          children: [
            Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.1),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('弹幕列表'),
                  iconButton(
                    onPressed: () => setState(() {}),
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Material(
                type: .transparency,
                clipBehavior: .hardEdge,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
                child: CustomScrollView(
                  slivers: [
                    ?_buildDanmakuList(ctr.staticDanmaku.nonNulls.toList()),
                    ?_buildDanmakuList(
                      ctr.scrollDanmaku.expand((e) => e).toList(),
                    ),
                    ?_buildDanmakuList(ctr.specialDanmaku.toList()),
                    const SliverToBoxAdapter(child: SizedBox(height: 12)),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget? _buildDanmakuList(List<DanmakuItem<DanmakuExtra>> list) {
    if (list.isEmpty) return null;

    return SliverList.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        final extra = item.content.extra! as VideoDanmaku;
        return ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
          onLongPress: () => Utils.copyText(item.content.text),
          title: Text(
            item.content.text,
            style: const TextStyle(fontSize: 14),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Builder(
                builder: (context) => Stack(
                  clipBehavior: Clip.none,
                  children: [
                    iconButton(
                      onPressed: () async {
                        if (await HeaderControl.likeDanmaku(
                              extra,
                              plPlayerController.cid!,
                            ) &&
                            context.mounted) {
                          (context as Element).markNeedsBuild();
                        }
                      },
                      icon: extra.isLike
                          ? const Icon(CustomIcons.player_dm_tip_like_solid)
                          : const Icon(CustomIcons.player_dm_tip_like),
                    ),
                    if (extra.like > 0)
                      Positioned(
                        left: 24.5,
                        top: 1.5,
                        child: Text(
                          extra.like.toString(),
                          style: const TextStyle(
                            fontSize: 10.5,
                            letterSpacing: 0,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (item.content.selfSend)
                iconButton(
                  onPressed: () => HeaderControl.deleteDanmaku(
                    extra.id,
                    plPlayerController.cid!,
                  ).then((_) => item.expired = true),
                  icon: const Icon(CustomIcons.player_dm_tip_recall),
                )
              else
                iconButton(
                  onPressed: () => HeaderControl.reportDanmaku(
                    context,
                    extra: extra,
                    ctr: plPlayerController,
                  ),
                  icon: const Icon(CustomIcons.player_dm_tip_back),
                ),
            ],
          ),
        );
      },
    );
  }

  /// 播放顺序
  void showSetRepeat() {
    showBottomSheet(
      (context, setState) {
        final theme = Theme.of(context);
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Material(
            clipBehavior: Clip.hardEdge,
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 45,
                    child: Center(
                      child: Text('选择播放顺序', style: titleStyle),
                    ),
                  ),
                ),
                SliverList.builder(
                  itemCount: PlayRepeat.values.length,
                  itemBuilder: (context, index) {
                    final i = PlayRepeat.values[index];
                    return ListTile(
                      dense: true,
                      onTap: () {
                        Get.back();
                        plPlayerController.setPlayRepeat(i);
                      },
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      title: Text(i.desc),
                      trailing: plPlayerController.playRepeat == i
                          ? Icon(
                              Icons.done,
                              color: theme.colorScheme.primary,
                            )
                          : null,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  late final isFileSource = videoDetailCtr.isFileSource;

  @override
  Widget build(BuildContext context) {
    final isFullScreen = this.isFullScreen;
    final isFSOrPip = isFullScreen || plPlayerController.isDesktopPip;
    final showFSActionItem =
        !isFileSource && plPlayerController.showFSActionItem && isFSOrPip;
    showCurrTimeIfNeeded(isFullScreen);
    Widget title;
    if (introController.videoDetail.value.title != null &&
        (isFullScreen ||
            ((!horizontalScreen || plPlayerController.isDesktopPip) &&
                !isPortrait))) {
      title = Padding(
        key: titleKey,
        padding: isPortrait
            ? EdgeInsets.zero
            : const EdgeInsets.only(right: 10),
        child: Obx(
          () {
            final videoDetail = introController.videoDetail.value;
            final String title;
            if (isFileSource || videoDetail.videos == 1) {
              title = videoDetail.title!;
            } else {
              title =
                  videoDetail.pages
                      ?.firstWhereOrNull(
                        (e) => e.cid == videoDetailCtr.cid.value,
                      )
                      ?.part ??
                  videoDetail.title!;
            }
            return MarqueeText(
              title,
              spacing: 30,
              velocity: 30,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              provider: effectiveProvider,
            );
          },
        ),
      );
      if (introController.isShowOnlineTotal) {
        title = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title,
            Obx(
              () => Text(
                '${introController.total.value}人正在看',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        );
      }
      title = Expanded(child: title);
    } else {
      title = const Spacer();
    }

    const btnWidth = 40.0;
    const btnHeight = 34.0;
    const btnStyle = ButtonStyle(padding: WidgetStatePropertyAll(.zero));

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      primary: false,
      automaticallyImplyLeading: false,
      toolbarHeight: showFSActionItem ? 112 : null,
      flexibleSpace: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 11),
          Row(
            children: [
              SizedBox(
                width: btnWidth,
                height: btnHeight,
                child: IconButton(
                  tooltip: '返回',
                  style: btnStyle,
                  icon: const Icon(
                    FontAwesomeIcons.arrowLeft,
                    size: 15,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (plPlayerController.onPopInvokedWithResult(
                      false,
                      null,
                    )) {
                      return;
                    }
                    if (PlatformUtils.isMobile &&
                        !horizontalScreen &&
                        !isPortrait) {
                      verticalScreenForTwoSeconds();
                    } else {
                      Get.back();
                    }
                  },
                ),
              ),
              if (!plPlayerController.isDesktopPip &&
                  (!isFullScreen || !isPortrait))
                SizedBox(
                  width: btnWidth,
                  height: btnHeight,
                  child: IconButton(
                    tooltip: '返回主页',
                    style: btnStyle,
                    icon: const Icon(
                      FontAwesomeIcons.house,
                      size: 15,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      videoDetailCtr.plPlayerController
                        ..isCloseAll = true
                        ..dispose();
                      Get.until((route) => route.isFirst);
                    },
                  ),
                ),
              title,
              // show current datetime
              ...?timeBatteryWidgets,
              if (PlatformUtils.isDesktop && !plPlayerController.isDesktopPip)
                Obx(() {
                  final isAlwaysOnTop = plPlayerController.isAlwaysOnTop.value;
                  return SizedBox(
                    width: btnWidth,
                    height: btnHeight,
                    child: IconButton(
                      style: btnStyle,
                      tooltip: '${isAlwaysOnTop ? '取消' : ''}置顶',
                      onPressed: () =>
                          plPlayerController.setAlwaysOnTop(!isAlwaysOnTop),
                      icon: isAlwaysOnTop
                          ? const Icon(
                              size: 19,
                              Icons.push_pin,
                              color: Colors.white,
                            )
                          : const Icon(
                              size: 19,
                              Icons.push_pin_outlined,
                              color: Colors.white,
                            ),
                    ),
                  );
                }),
              if (!isFileSource) ...[
                if (!isFSOrPip) ...[
                  if (videoDetailCtr.isUgc)
                    SizedBox(
                      width: btnWidth,
                      height: btnHeight,
                      child: IconButton(
                        tooltip: '听音频',
                        style: btnStyle,
                        onPressed: videoDetailCtr.toAudioPage,
                        icon: const Icon(
                          Icons.headphones_outlined,
                          size: 19,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  SizedBox(
                    width: btnWidth,
                    height: btnHeight,
                    child: IconButton(
                      tooltip: '投屏',
                      style: btnStyle,
                      onPressed: videoDetailCtr.onCast,
                      icon: const Icon(
                        Icons.cast,
                        size: 19,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
                if (plPlayerController.enableSponsorBlock)
                  SizedBox(
                    width: btnWidth,
                    height: btnHeight,
                    child: IconButton(
                      tooltip: '提交片段',
                      style: btnStyle,
                      onPressed: () => videoDetailCtr.onBlock(context),
                      icon: const Stack(
                        clipBehavior: Clip.none,
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
                  () => videoDetailCtr.segmentProgressList.isNotEmpty
                      ? SizedBox(
                          width: btnWidth,
                          height: btnHeight,
                          child: IconButton(
                            tooltip: '片段信息',
                            style: btnStyle,
                            onPressed: () =>
                                videoDetailCtr.showSBDetail(context),
                            icon: const Icon(
                              MdiIcons.advertisements,
                              size: 19,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
              if (isFullScreen || PlatformUtils.isDesktop) ...[
                SizedBox(
                  width: btnWidth,
                  height: btnHeight,
                  child: IconButton(
                    tooltip: '发弹幕',
                    style: btnStyle,
                    onPressed: videoDetailCtr.showShootDanmakuSheet,
                    icon: const Icon(
                      Icons.comment_outlined,
                      size: 19,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: btnWidth,
                  height: btnHeight,
                  child: Obx(
                    () {
                      final enableShowDanmaku =
                          plPlayerController.enableShowDanmaku.value;
                      return IconButton(
                        tooltip: "${enableShowDanmaku ? '关闭' : '开启'}弹幕",
                        style: btnStyle,
                        onPressed: () {
                          final newVal = !enableShowDanmaku;
                          plPlayerController.enableShowDanmaku.value = newVal;
                          if (!plPlayerController.tempPlayerConf) {
                            setting.put(
                              SettingBoxKey.enableShowDanmaku,
                              newVal,
                            );
                          }
                        },
                        icon: enableShowDanmaku
                            ? const Icon(
                                size: 20,
                                CustomIcons.dm_on,
                                color: Colors.white,
                              )
                            : const Icon(
                                size: 20,
                                CustomIcons.dm_off,
                                color: Colors.white,
                              ),
                      );
                    },
                  ),
                ),
              ],
              SizedBox(
                width: btnWidth,
                height: btnHeight,
                child: IconButton(
                  tooltip: '弹幕设置',
                  style: btnStyle,
                  onPressed: showSetDanmaku,
                  icon: const Icon(
                    size: 20,
                    CustomIcons.dm_settings,
                    color: Colors.white,
                  ),
                ),
              ),
              if (Platform.isAndroid ||
                  (PlatformUtils.isDesktop && !isFullScreen))
                SizedBox(
                  width: btnWidth,
                  height: btnHeight,
                  child: IconButton(
                    tooltip: '画中画',
                    style: btnStyle,
                    onPressed: () async {
                      if (PlatformUtils.isDesktop) {
                        plPlayerController.toggleDesktopPip();
                        return;
                      }
                      if (await Floating().isPipAvailable) {
                        if (context.mounted &&
                            !videoPlayerServiceHandler!.enableBackgroundPlay) {
                          final theme = Theme.of(context);
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
                                      Text(
                                        '画中画',
                                        style: TextStyle(
                                          fontSize: 15,
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    '建议开启【后台音频服务】\n'
                                    '避免画中画没有暂停按钮',
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      height: 1.5,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      TextButton(
                                        style: ButtonStyle(
                                          foregroundColor:
                                              WidgetStatePropertyAll(
                                                theme
                                                    .snackBarTheme
                                                    .actionTextColor,
                                              ),
                                        ),
                                        onPressed: () {
                                          plPlayerController.setBackgroundPlay(
                                            true,
                                          );
                                          SmartDialog.showToast("请重新载入本页面刷新");
                                        },
                                        child: const Text('启用后台音频服务'),
                                      ),
                                      const SizedBox(width: 10),
                                      TextButton(
                                        style: ButtonStyle(
                                          foregroundColor:
                                              WidgetStatePropertyAll(
                                                theme
                                                    .snackBarTheme
                                                    .actionTextColor,
                                              ),
                                        ),
                                        onPressed: () {},
                                        child: const Text('不启用'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              duration: const Duration(seconds: 2),
                              showCloseIcon: true,
                            ),
                          );
                          await Future.delayed(const Duration(seconds: 3));
                        }
                        if (!context.mounted) return;
                        plPlayerController.enterPip();
                      }
                    },
                    icon: const Icon(
                      Icons.picture_in_picture_outlined,
                      size: 19,
                      color: Colors.white,
                    ),
                  ),
                ),
              SizedBox(
                width: btnWidth,
                height: btnHeight,
                child: IconButton(
                  tooltip: "更多设置",
                  style: btnStyle,
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
          if (showFSActionItem)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: btnWidth,
                  height: btnHeight,
                  child: Obx(
                    () => ActionItem(
                      expand: false,
                      icon: const Icon(
                        FontAwesomeIcons.thumbsUp,
                        color: Colors.white,
                      ),
                      selectIcon: const Icon(
                        FontAwesomeIcons.solidThumbsUp,
                      ),
                      selectStatus: introController.hasLike.value,
                      semanticsLabel: '点赞',
                      animation: introController.tripleAnimation,
                      onStartTriple: () {
                        plPlayerController.tripling = true;
                        introController.onStartTriple();
                      },
                      onCancelTriple: ([bool isTapUp = false]) {
                        plPlayerController
                          ..tripling = false
                          ..hideTaskControls();
                        introController.onCancelTriple(isTapUp);
                      },
                    ),
                  ),
                ),
                if (introController case final UgcIntroController ugc)
                  SizedBox(
                    width: btnWidth,
                    height: btnHeight,
                    child: Obx(
                      () => ActionItem(
                        expand: false,
                        icon: const Icon(
                          FontAwesomeIcons.thumbsDown,
                          color: Colors.white,
                        ),
                        selectIcon: const Icon(
                          FontAwesomeIcons.solidThumbsDown,
                        ),
                        onTap: () => ugc.handleAction(ugc.actionDislikeVideo),
                        selectStatus: ugc.hasDislike.value,
                        semanticsLabel: '点踩',
                      ),
                    ),
                  ),
                SizedBox(
                  width: btnWidth,
                  height: btnHeight,
                  child: Obx(
                    () => ActionItem(
                      expand: false,
                      animation: introController.tripleAnimation,
                      icon: const Icon(
                        FontAwesomeIcons.b,
                        color: Colors.white,
                      ),
                      selectIcon: const Icon(FontAwesomeIcons.b),
                      onTap: introController.actionCoinVideo,
                      selectStatus: introController.hasCoin,
                      semanticsLabel: '投币',
                    ),
                  ),
                ),
                SizedBox(
                  width: btnWidth,
                  height: btnHeight,
                  child: Obx(
                    () => ActionItem(
                      expand: false,
                      animation: introController.tripleAnimation,
                      icon: const Icon(
                        FontAwesomeIcons.star,
                        color: Colors.white,
                      ),
                      selectIcon: const Icon(FontAwesomeIcons.solidStar),
                      onTap: () => introController.showFavBottomSheet(context),
                      onLongPress: () => introController.showFavBottomSheet(
                        context,
                        isLongPress: true,
                      ),
                      selectStatus: introController.hasFav.value,
                      semanticsLabel: '收藏',
                    ),
                  ),
                ),
                SizedBox(
                  width: btnWidth,
                  height: btnHeight,
                  child: ActionItem(
                    expand: false,
                    icon: const Icon(
                      FontAwesomeIcons.shareFromSquare,
                      color: Colors.white,
                    ),
                    onTap: () => introController.actionShareVideo(context),
                    semanticsLabel: '分享',
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
