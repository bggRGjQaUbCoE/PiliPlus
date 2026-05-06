import 'package:PiliPlus/pages/live_room/controller.dart';
import 'package:PiliPlus/pages/live_room/superchat/superchat_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class SuperChatPanel extends StatefulWidget {
  const SuperChatPanel({
    super.key,
    required this.controller,
  });

  final LiveRoomController controller;

  @override
  State<SuperChatPanel> createState() => _SuperChatPanelState();
}

class _SuperChatPanelState extends State<SuperChatPanel>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(
      () => ListView.separated(
        key: const PageStorageKey(_SuperChatPanelState),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        physics: const ClampingScrollPhysics(),
        itemCount: widget.controller.superChatMsg.length,
        findItemIndexCallback: (key) {
          final index = widget.controller.superChatMsg.indexWhere(
            (i) => i.id == (key as ValueKey<int>).value,
          );
          // Return item index directly - no need to multiply by 2.
          return index == -1 ? null : index;
        },
        itemBuilder: (context, index) {
          final item = widget.controller.superChatMsg[index];
          return SuperChatCard(
            key: ValueKey(item.id),
            item: item,
            persistentSC: true,
            onReport: () => widget.controller.reportSC(item),
          );
        },
        separatorBuilder: (_, _) => const SizedBox(height: 8),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
