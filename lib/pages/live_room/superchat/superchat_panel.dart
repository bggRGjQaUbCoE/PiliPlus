import 'package:PiliPlus/models/common/super_chat_type.dart';
import 'package:PiliPlus/pages/live_room/controller.dart';
import 'package:PiliPlus/pages/live_room/superchat/superchat_card.dart';
import 'package:PiliPlus/pages/search/controller.dart';
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

class _SuperChatPanelState extends DebounceStreamState<SuperChatPanel, bool>
    with AutomaticKeepAliveClientMixin {
  @override
  Duration get duration => const Duration(milliseconds: 300);

  late final persistentSC =
      widget.controller.superChatType == SuperChatType.persist;

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
          // Multiply by 2 to account for separators
          return index == -1 ? null : index * 2;
        },
        itemBuilder: (context, index) {
          final item = widget.controller.superChatMsg[index];
          return SuperChatCard(
            key: ValueKey(item.id),
            item: item,
            onRemove: () => ctr?.add(true),
            persistentSC: persistentSC,
            onReport: () => widget.controller.reportSC(item),
          );
        },
        separatorBuilder: (_, _) => const SizedBox(height: 8),
      ),
    );
  }

  @override
  void onValueChanged(value) => widget.controller.clearSC();

  @override
  bool get wantKeepAlive => true;
}
