import 'package:PiliPlus/pages/live_room/controller.dart';
import 'package:PiliPlus/pages/live_room/superchat/superchat_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 12),
        physics: const ClampingScrollPhysics(),
        itemCount: widget.controller.superChatMsg.length,
        itemBuilder: (context, index) {
          final item = widget.controller.superChatMsg[index];
          return SuperChatCard(
            key: ValueKey(item.id),
            item: item,
            onRemove: () => widget.controller.superChatMsg.removeAt(index),
          );
        },
        separatorBuilder: (_, _) => const SizedBox(height: 12),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
