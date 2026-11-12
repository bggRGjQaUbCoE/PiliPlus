import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/live/live_fans_medal/item.dart';
import 'package:PiliPlus/pages/common/publish/publish_route.dart';
import 'package:PiliPlus/pages/fans_medal/medal_setting_mixin.dart';
import 'package:PiliPlus/pages/fans_medal/view.dart';
import 'package:PiliPlus/pages/live_room/controller.dart';
import 'package:PiliPlus/pages/member/widget/medal_widget.dart';
import 'package:PiliPlus/utils/theme_utils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

mixin LiveMedalMixin<T extends StatefulWidget>
    on State<T>, MedalSettingMixin<T> {
  ColorScheme get colorScheme;
  LiveRoomController get liveController;

  Widget? get medalBtn {
    if (liveController.isMainLogin) return Obx(buildMedalBtn);
    return null;
  }

  Widget buildMedalBtn() {
    final medal = liveController.medal.value;
    if (medal != null) {
      return GestureDetector(
        behavior: .translucent,
        onTap: showMedalDialog,
        child: Padding(
          padding: const .symmetric(vertical: 5),
          child: MedalWidget.fromMedalInfo(
            medal: medal,
            padding: MedalWidget.mediumPadding,
          ),
        ),
      );
    } else if (liveController.hasMedal) {
      return GestureDetector(
        behavior: .translucent,
        onTap: showMedalDialog,
        child: Container(
          margin: const .symmetric(vertical: 5),
          padding: const .symmetric(horizontal: 4, vertical: 3),
          decoration: BoxDecoration(
            border: .all(color: Colors.white70),
            borderRadius: const .all(.circular(4)),
          ),
          child: const Text(
            '未佩戴',
            style: TextStyle(color: Colors.white70, fontSize: 12, height: 1),
            strutStyle: StrutStyle(fontSize: 12, height: 1, leading: 0),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Future<void> showMedalDialog({bool refresh = true}) async {
    liveController.getUserMedal();
    final medalController = liveController.medalController;
    await medalController.onRefresh();
    if (!mounted) return;
    switch (medalController.loadingState.rawValue) {
      case Success(:final response):
        if (response != null && response.isNotEmpty) {
          showDialog(
            context: context,
            builder: (context) => Theme(
              data: ThemeUtils.darkTheme,
              child: AlertDialog(
                contentPadding: const .symmetric(vertical: 10),
                constraints: const BoxConstraints.tightFor(width: 380),
                title: const Text('我的粉丝勋章'),
                content: showMedalList(context, response),
              ),
            ),
          );
        }
      case Loading _ || Error _:
        return;
    }
  }

  Widget? showMedalList(BuildContext dialogCtx, List<FansMedalItem> response) {
    var length = response.length;
    final list = CustomScrollView(
      shrinkWrap: true,
      slivers: [
        SliverList.builder(
          itemCount: response.length,
          itemBuilder: (context, index) {
            if (!medalController.isEnd && index == response.length - 1) {
              medalController.onLoadMore().whenComplete(() {
                if (length != response.length && dialogCtx.mounted) {
                  (dialogCtx as Element).markNeedsBuild();
                }
              });
            }

            final item = response[index];
            return ListTile(
              dense: true,
              leading: Radio(
                value: item.medal.wearingStatus,
                // ignore: deprecated_member_use
                groupValue: 1,
                // ignore: deprecated_member_use
                onChanged: (value) {},
                visualDensity: .compact,
                materialTapTargetSize: .shrinkWrap,
              ),
              onTap: () async {
                final isWearing = item.medal.wearingStatus == 1;
                final updated = isWearing
                    ? await medalController.onTakeOff(item, refresh: false)
                    : await medalController.onWear(item, refresh: false);
                if (!mounted) return;
                if (updated) {
                  if (context.mounted) {
                    (context as Element).markNeedsBuild();
                  }
                  final res = await liveController.getUserMedal();
                  if (!isWearing && res && mounted) {
                    final medal = liveController.medal.rawValue;
                    if (medal != null && medal.id != item.uinfoMedal.id) {
                      SmartDialog.showToast('该直播间不支持展示其他粉丝牌');
                    }
                  }
                }
              },
              title: Row(
                spacing: 10,
                children: [
                  ConstrainedBox(
                    constraints: const .new(minWidth: 60),
                    child: Align(
                      alignment: .centerLeft,
                      child: MedalWidget.fromMedalInfo(
                        medal: item.uinfoMedal,
                        padding: MedalWidget.mediumPadding,
                      ),
                    ),
                  ),
                  Text(
                    item.anchorInfo.nickName,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );

    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        Flexible(child: list),
        Padding(
          padding: const .symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              GestureDetector(
                behavior: .translucent,
                onTap: () => {Get.back(), showMedalSettingDialog()},
                child: Padding(
                  padding: const .symmetric(vertical: 8),
                  child: Text(
                    '展示设置',
                    style: TextStyle(color: colorScheme.primary),
                  ),
                ),
              ),
              GestureDetector(
                behavior: .translucent,
                onTap: () => {
                  Get.back(),
                  Get.key.currentState!
                      .push(
                        PublishRoute(
                          transitionDuration: const Duration(milliseconds: 150),
                          pageBuilder: (_, _, _) => const FansMedalPage(),
                          transitionBuilder: (_, animation, _, child) =>
                              FadeTransition(opacity: animation, child: child),
                        ),
                      )
                      .whenComplete(liveController.getUserMedal),
                },
                child: Padding(
                  padding: const .symmetric(vertical: 8),
                  child: Text(
                    '勋章管理',
                    style: TextStyle(color: colorScheme.primary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
