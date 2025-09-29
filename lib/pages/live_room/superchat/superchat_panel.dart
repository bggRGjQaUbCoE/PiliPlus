import 'package:PiliPlus/pages/live_room/controller.dart';
import 'package:PiliPlus/pages/live_room/superchat/superchat_card.dart';
import 'package:PiliPlus/pages/search/controller.dart';
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

class _SuperChatPanelState extends DebounceStreamState<SuperChatPanel, bool>
    with AutomaticKeepAliveClientMixin {
  @override
  Duration get duration => const Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(
      () => ListView.separated(
        key: const PageStorageKey('live-sc'),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        physics: const ClampingScrollPhysics(),
        itemCount: widget.controller.superChatMsg.length,
        findChildIndexCallback: (key) {
          final index = widget.controller.superChatMsg.indexWhere(
            (i) => i.id == (key as ValueKey<int>).value,
          );
          return index == -1 ? null : index;
        },
        itemBuilder: (context, index) {
          final item = widget.controller.superChatMsg[index];
          return SuperChatCard(
            key: ValueKey(item.id),
            item: item,
            onRemove: () => ctr?.add(true),
          );
        },
        separatorBuilder: (_, _) => const SizedBox(height: 12),
      ),
    );
  }

  @override
  void onValueChanged(value) => widget.controller.clearSC();

  @override
  bool get wantKeepAlive => true;
}
