import 'package:PiliPlus/plugin/pl_player/widgets/play_pause_btn.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:PiliPlus/pages/live_room/index.dart';
import 'package:PiliPlus/plugin/pl_player/index.dart';
import 'package:get/get.dart';

class BottomControl extends StatelessWidget implements PreferredSizeWidget {
  const BottomControl({
    required this.plPlayerController,
    required this.liveRoomCtr,
    required this.onRefresh,
    super.key,
  });

  final PlPlayerController plPlayerController;
  final LiveRoomController liveRoomCtr;
  final VoidCallback onRefresh;

  final TextStyle subTitleStyle = const TextStyle(fontSize: 12);

  final TextStyle titleStyle = const TextStyle(fontSize: 14);

  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      primary: false,
      automaticallyImplyLeading: false,
      titleSpacing: 14,
      title: Row(
        children: [
          PlayOrPauseButton(
            plPlayerController: plPlayerController,
          ),
          const SizedBox(width: 10),
          ComBtn(
            icon: const Icon(
              Icons.refresh,
              size: 18,
              color: Colors.white,
            ),
            onTap: onRefresh,
          ),
          const Spacer(),
          Obx(
            () => IconButton(
              onPressed: () {
                plPlayerController.isOpenDanmu.value =
                    !plPlayerController.isOpenDanmu.value;
                GStorage.setting.put(SettingBoxKey.enableShowDanmaku,
                    plPlayerController.isOpenDanmu.value);
              },
              icon: Icon(
                size: 18,
                plPlayerController.isOpenDanmu.value
                    ? Icons.subtitles_outlined
                    : Icons.subtitles_off_outlined,
                color: Colors.white,
              ),
            ),
          ),
          Obx(
            () => Container(
              height: 30,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.center,
              child: PopupMenuButton<BoxFit>(
                initialValue: plPlayerController.videoFit.value,
                color: Colors.black.withOpacity(0.8),
                itemBuilder: (BuildContext context) {
                  return BoxFit.values.map((BoxFit boxFit) {
                    return PopupMenuItem<BoxFit>(
                      height: 35,
                      padding: const EdgeInsets.only(left: 30),
                      value: boxFit,
                      onTap: () {
                        plPlayerController.toggleVideoFit(boxFit);
                      },
                      child: Text(
                        boxFit.desc,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    );
                  }).toList();
                },
                child: Text(
                  plPlayerController.videoFit.value.desc,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Obx(
            () => SizedBox(
              width: 30,
              child: PopupMenuButton<int>(
                padding: EdgeInsets.zero,
                initialValue: liveRoomCtr.currentQn,
                color: Colors.black.withOpacity(0.8),
                child: Text(
                  liveRoomCtr.currentQnDesc.value,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
                itemBuilder: (BuildContext context) {
                  return liveRoomCtr.acceptQnList.map((e) {
                    return PopupMenuItem<int>(
                      height: 35,
                      padding: const EdgeInsets.only(left: 30),
                      value: e['code'],
                      onTap: () {
                        liveRoomCtr.changeQn(e['code']);
                      },
                      child: Text(
                        e['desc'],
                        style:
                            const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          ),
          const SizedBox(width: 10),
          ComBtn(
            icon: const Icon(
              Icons.fullscreen,
              semanticLabel: '全屏切换',
              size: 20,
              color: Colors.white,
            ),
            onTap: () => plPlayerController.triggerFullScreen(
                status: !plPlayerController.isFullScreen.value),
          ),
        ],
      ),
    );
  }
}
