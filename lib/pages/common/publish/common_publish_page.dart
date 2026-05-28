import 'dart:io' show Platform;
import 'dart:math' show max;

import 'package:PiliPlus/models/common/publish_panel_type.dart';
import 'package:PiliPlus/utils/extension/context_ext.dart';
import 'package:chat_bottom_container/chat_bottom_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class CommonPublishPage<T> extends StatefulWidget {
  const CommonPublishPage({
    super.key,
    this.initialValue,
    this.imageLengthLimit,
    this.onSave,
    this.autofocus = true,
  });

  final String? initialValue;
  final int? imageLengthLimit;
  final ValueChanged<T>? onSave;
  final bool autofocus;
}

abstract class CommonPublishPageState<T extends CommonPublishPage>
    extends State<T>
    with WidgetsBindingObserver {
  late bool _paused = false;
  final FocusNode focusNode = FocusNode();
  late final controller = ChatBottomPanelContainerController<PanelType>();
  TextEditingController get editController;

  final Rx<PanelType> panelType = Rx(.none);
  late final RxBool readOnly = false.obs;
  late final RxBool enablePublish = false.obs;

  bool isPublishing = false;

  bool hasPub = false;
  void initPubState();

  bool get handleKeyboard => Platform.isAndroid && widget.autofocus;

  @override
  void initState() {
    super.initState();
    if (handleKeyboard) {
      WidgetsBinding.instance.addObserver(this);
    }

    initPubState();

    if (widget.autofocus) {
      _requestFocus(duration: const Duration(milliseconds: 300));
    }
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
    Future.delayed(duration, _safeRequestFocus);
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
    final isSwitchToKeyboard = type == .keyboard;
    bool isUpdated = false;
    switch (type) {
      case .keyboard:
        updateInputView(isReadOnly: false);
        break;
      case .emoji || .more:
        isUpdated = updateInputView(isReadOnly: true);
        break;
      default:
        break;
    }

    void updatePanelTypeFunc() {
      controller.updatePanelType(
        isSwitchToKeyboard ? .keyboard : .other,
        data: type,
        forceHandleFocus: isSwitchToKeyboard ? .requestFocus : .unfocus,
      );
    }

    if (isUpdated) {
      // Waiting for the input view to update.
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        updatePanelTypeFunc();
      });
    } else {
      updatePanelTypeFunc();
    }
  }

  Future<void> hidePanel([_]) async {
    if (focusNode.hasFocus) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
      focusNode.unfocus();
    }
    updateInputView(isReadOnly: false);
    if (controller.currentPanelType == .none) return;
    controller.updatePanelType(.none);
  }

  bool updateInputView({
    required bool isReadOnly,
  }) {
    if (readOnly.value != isReadOnly) {
      readOnly.value = isReadOnly;
      return true;
    }
    return false;
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

  Widget buildMorePanel(ThemeData theme) => throw UnimplementedError();

  Widget buildPanelContainer(ThemeData theme, [Color? panelBgColor]) {
    return ChatBottomPanelContainer<PanelType>(
      controller: controller,
      inputFocusNode: focusNode,
      otherPanelWidget: (type) {
        if (type == null) return const SizedBox.shrink();
        switch (type) {
          case .emoji:
            return buildEmojiPickerPanel();
          case .more:
            return buildMorePanel(theme);
          default:
            return const SizedBox.shrink();
        }
      },
      onPanelTypeChange: (panelType, data) {
        switch (panelType) {
          case .none:
            this.panelType.value = .none;
            break;
          case .keyboard:
            this.panelType.value = .keyboard;
            break;
          case .other:
            if (data == null) return;
            this.panelType.value = data;
            break;
        }
      },
      panelBgColor: panelBgColor ?? Theme.of(context).colorScheme.surface,
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
