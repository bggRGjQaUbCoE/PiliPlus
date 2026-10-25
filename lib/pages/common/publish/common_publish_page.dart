import 'dart:async';
import 'dart:io';
import 'dart:math' show max;

import 'package:PiliPlus/models/common/publish_panel_type.dart';
import 'package:PiliPlus/utils/extension/context_ext.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:chat_bottom_container/chat_bottom_container.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

abstract class CommonPublishPage<T> extends StatefulWidget {
  const CommonPublishPage({
    super.key,
    this.initialValue,
    this.imageLengthLimit = 9,
    this.onSave,
    this.autofocus = true,
    this.panelType = .none,
  });

  final String? initialValue;
  final int imageLengthLimit;
  final ValueChanged<T>? onSave;
  final bool autofocus;
  final PanelType panelType;
}

abstract class CommonPublishPageState<T extends CommonPublishPage>
    extends State<T>
    with WidgetsBindingObserver {
  late bool _paused = false;
  late final FocusNode focusNode;
  late final ChatBottomPanelContainerController<PanelType> controller;
  TextEditingController get editController;

  late final Rx<PanelType> panelType;
  late final RxBool enablePublish = false.obs;

  bool isPublishing = false;

  bool hasPub = false;
  void initPubState();

  bool get handleKeyboard => Platform.isAndroid && widget.autofocus;

  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    final panelType = widget.panelType;
    this.panelType = Rx(panelType);
    controller = ChatBottomPanelContainerController<PanelType>(
      data: panelType,
      uiScale: Pref.uiScale,
      currentPanelType: panelType == .none ? .none : .other,
    );

    focusNode = FocusNode();

    if (handleKeyboard) {
      WidgetsBinding.instance.addObserver(this);
    }

    initPubState();

    if (widget.autofocus) {
      _requestFocus(duration: const Duration(milliseconds: 300));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initTheme();
  }

  void initTheme() {
    theme = Theme.of(context);
  }

  @override
  void dispose() {
    if (!hasPub) {
      onSave();
    }
    focusNode.dispose();
    editController.dispose();
    if (handleKeyboard) {
      WidgetsBinding.instance.removeObserver(this);
    }
    super.dispose();
  }

  void _safeRequestFocus() {
    if (mounted) {
      focusNode.requestFocus();
    }
  }

  void _requestFocus({Duration duration = const Duration(microseconds: 200)}) {
    Timer(duration, _safeRequestFocus);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == .resumed) {
      if (_paused) {
        _paused = false;
        final panelType = this.panelType.value;
        if (panelType == .keyboard || panelType == .none) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (focusNode.hasFocus) {
              focusNode.unfocus();
              _requestFocus();
            } else {
              _requestFocus();
            }
          });
        }
      }
    } else if (state == .paused) {
      _paused = true;
      if (focusNode.hasFocus) {
        focusNode.unfocus();
      }
    }
  }

  void updatePanelType(PanelType type) {
    controller.updatePanelType(
      type == .keyboard ? .keyboard : .other,
      data: type,
    );
  }

  void hidePanel([_]) {
    if (focusNode.hasFocus) focusNode.unfocus();
    if (ChatBottomPanelType.none == controller.currentPanelType) return;
    controller.updatePanelType(ChatBottomPanelType.none);
  }

  Widget buildEmojiPickerPanel() {
    double height = context.isTablet ? 300 : 170;
    final keyboardHeight = controller.keyboardHeight;
    if (keyboardHeight != 0) {
      height = max(height, keyboardHeight);
    }
    return SizedBox(
      height: height,
      child: customPanel,
    );
  }

  Widget buildMorePanel() => throw UnimplementedError();

  Widget _buildPanel(PanelType? type) {
    if (type == null) return const SizedBox.shrink();
    switch (type) {
      case .emoji:
        return buildEmojiPickerPanel();
      case .more:
        return buildMorePanel();
      default:
        return const SizedBox.shrink();
    }
  }

  void _onPanelTypeChange(ChatBottomPanelType panelType, PanelType? data) {
    switch (panelType) {
      case .none:
        this.panelType.value = .none;
      case .keyboard:
        this.panelType.value = .keyboard;
      case .other:
        if (data == null) return;
        this.panelType.value = data;
    }
  }

  Widget buildPanelContainer([Color? panelBgColor]) {
    return ChatBottomPanelContainer<PanelType>(
      controller: controller,
      inputFocusNode: focusNode,
      otherPanelWidget: _buildPanel,
      onPanelTypeChange: _onPanelTypeChange,
      panelBgColor: panelBgColor ?? theme.colorScheme.surface,
    );
  }

  void onSubmitted(String value) {
    if (enablePublish.value) {
      onPublishThrottle();
    }
  }

  void onPublishThrottle() {
    if (isPublishing) return;
    isPublishing = true;
    onPublish().whenComplete(() => isPublishing = false);
  }

  Future<void> onPublish();

  Future<void> onCustomPublish({List? pictures});

  Widget? get customPanel => null;

  void onChanged(String value) {
    enablePublish.value = value.trim().isNotEmpty;
  }

  void onSave();
}
