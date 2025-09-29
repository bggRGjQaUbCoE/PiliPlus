import 'package:PiliPlus/common/widgets/custom_icon.dart';
import 'package:PiliPlus/pages/live_room/controller.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/video_fit_type.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/common_btn.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/play_pause_btn.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class BottomControl extends StatelessWidget {
  const BottomControl({
    super.key,
    required this.plPlayerController,
    required this.liveRoomCtr,
    required this.onRefresh,
    this.subTitleStyle = const TextStyle(fontSize: 12),
    this.titleStyle = const TextStyle(fontSize: 14),
  });

  final PlPlayerController plPlayerController;
  final LiveRoomController liveRoomCtr;
  final VoidCallback onRefresh;

  final TextStyle subTitleStyle;
  final TextStyle titleStyle;

  @override
  Widget build(BuildContext context) {
    final isFullScreen = plPlayerController.isFullScreen.value;
    return AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      primary: false,
      automaticallyImplyLeading: false,
      titleSpacing: 14,
      title: Row(
        children: [
          PlayOrPauseButton(plPlayerController: plPlayerController),
          ComBtn(
            height: 30,
            tooltip: '刷新',
            icon: const Icon(
              Icons.refresh,
              size: 18,
              color: Colors.white,
            ),
            onTap: onRefresh,
          ),
          const Spacer(),
          ComBtn(
            height: 30,
            tooltip: '屏蔽',
            icon: const Icon(
              size: 18,
              Icons.block,
              color: Colors.white,
            ),
            onTap: () {
              if (liveRoomCtr.isLogin) {
                Get.toNamed(
                  '/liveDmBlockPage',
                  parameters: {
                    'roomId': liveRoomCtr.roomId.toString(),
                  },
                );
              } else {
                SmartDialog.showToast('账号未登录');
              }
            },
          ),
          const SizedBox(width: 3),
          Obx(
            () {
              final enableShowLiveDanmaku =
                  plPlayerController.enableShowLiveDanmaku.value;
              return ComBtn(
                tooltip: "${enableShowLiveDanmaku ? '关闭' : '开启'}弹幕",
                icon: enableShowLiveDanmaku
                    ? const Icon(
                        size: 18,
                        CustomIcons.dm_on,
                        color: Colors.white,
                      )
                    : const Icon(
                        size: 18,
                        CustomIcons.dm_off,
                        color: Colors.white,
                      ),
                onTap: () {
                  final newVal = !enableShowLiveDanmaku;
                  plPlayerController.enableShowLiveDanmaku.value = newVal;
                  if (!plPlayerController.tempPlayerConf) {
                    GStorage.setting.put(
                      SettingBoxKey.enableShowLiveDanmaku,
                      newVal,
                    );
                  }
                },
              );
            },
          ),
          Obx(
            () => PopupMenuButton<VideoFitType>(
              tooltip: '画面比例',
              initialValue: plPlayerController.videoFit.value,
              color: Colors.black.withValues(alpha: 0.8),
              itemBuilder: (context) {
                return VideoFitType.values
                    .map(
                      (boxFit) => PopupMenuItem<VideoFitType>(
                        height: 35,
                        padding: const EdgeInsets.only(left: 30),
                        value: boxFit,
                        onTap: () => plPlayerController.toggleVideoFit(boxFit),
                        child: Text(
                          boxFit.desc,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    )
                    .toList();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  plPlayerController.videoFit.value.desc,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ),
          ),
          Obx(
            () => PopupMenuButton<int>(
              tooltip: '画质',
              padding: EdgeInsets.zero,
              initialValue: liveRoomCtr.currentQn,
              color: Colors.black.withValues(alpha: 0.8),
              itemBuilder: (context) {
                return liveRoomCtr.acceptQnList
                    .map(
                      (e) => PopupMenuItem<int>(
                        height: 35,
                        padding: const EdgeInsets.only(left: 30),
                        value: e.code,
                        onTap: () => liveRoomCtr.changeQn(e.code),
                        child: Text(
                          e.desc,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    )
                    .toList();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  liveRoomCtr.currentQnDesc.value,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ),
          ),
          ComBtn(
            height: 30,
            tooltip: isFullScreen ? '退出全屏' : '全屏',
            icon: isFullScreen
                ? const Icon(
                    Icons.fullscreen_exit,
                    size: 24,
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.fullscreen,
                    size: 24,
                    color: Colors.white,
                  ),
            onTap: () =>
                plPlayerController.triggerFullScreen(status: !isFullScreen),
          ),
        ],
      ),
    );
  }
}
