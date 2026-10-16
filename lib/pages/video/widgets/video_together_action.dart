import 'package:PiliPlus/pages/video/introduction/ugc/widgets/action_item.dart';
import 'package:PiliPlus/services/video_together/entry_policy.dart';
import 'package:PiliPlus/services/video_together/preferences.dart';
import 'package:PiliPlus/services/video_together/session.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class VideoTogetherActionItem extends StatelessWidget {
  const VideoTogetherActionItem({super.key});

  @override
  Widget build(BuildContext context) {
    final session = VideoTogetherSession.instance;
    return Obx(() {
      session.preferenceRevision.value;
      final inRoom = session.inRoom;
      final shouldShow = VideoTogetherPlayerEntryPolicy.shouldShow(
        inRoom: inRoom,
        hideWhenNotInRoom:
            VideoTogetherPreferences.hidePlayerEntryWhenNotInRoom,
      );
      if (!shouldShow) return const SizedBox.shrink();
      return ActionItem(
        icon: const Icon(Icons.groups_2_outlined),
        selectIcon: const Icon(Icons.groups_2),
        selectStatus: inRoom,
        onTap: () => Get.toNamed('/videoTogether'),
        semanticsLabel: '一起看',
        text: '一起看',
      );
    });
  }
}
