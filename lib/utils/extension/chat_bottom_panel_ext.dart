import 'package:chat_bottom_container/chat_bottom_container.dart';

final Expando<_ChatPanelState> _chatPanelState = Expando<_ChatPanelState>();

extension ChatBottomPanelControllerExt<T>
    on ChatBottomPanelContainerController<T> {
  void keepChatPanel() {
    _chatPanelState[this] = _ChatPanelState(
      currentPanelType,
      data,
    );
  }

  void restoreChatPanel() {
    final state = _chatPanelState[this];
    if (state == null) return;
    updatePanelType(
      state.panelType,
      data: state.data as T?,
    );
  }
}

class _ChatPanelState {
  const _ChatPanelState(this.panelType, this.data);

  final ChatBottomPanelType panelType;
  final Object? data;
}
