import 'dart:async' show Completer;

import 'package:PiliPlus/common/widgets/scaffold/bottom_sheet.dart';
import 'package:PiliPlus/common/widgets/scaffold/bottom_sheet_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class MiniScaffold extends StatefulWidget {
  const MiniScaffold({
    super.key,
    required this.body,
  });

  final Widget body;

  static MiniScaffoldState of(BuildContext context) {
    return context.findAncestorStateOfType<MiniScaffoldState>()!;
  }

  static MiniScaffoldState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<MiniScaffoldState>();
  }

  @override
  State<MiniScaffold> createState() => MiniScaffoldState();
}

class MiniScaffoldState extends State<MiniScaffold>
    with TickerProviderStateMixin {
  PersistentBottomSheetController? _currentBottomSheet;

  void _closeCurrentBottomSheet() {
    if (_currentBottomSheet != null) {
      if (!_currentBottomSheet!.isLocalHistoryEntry) {
        _currentBottomSheet!.close();
      }
      assert(() {
        _currentBottomSheet?.completer.future.whenComplete(() {
          assert(_currentBottomSheet == null);
        });
        return true;
      }());
    }
  }

  PersistentBottomSheetController _buildBottomSheet(
    WidgetBuilder builder, {
    required AnimationController animationController,
    BoxConstraints? constraints,
    bool? enableDrag,
    bool shouldDisposeAnimationController = true,
  }) {
    final completer = Completer<void>();
    final bottomSheetKey = GlobalKey<StandardBottomSheetState>();
    late StandardBottomSheet bottomSheet;

    var removedEntry = false;
    var doingDispose = false;

    void removeCurrentBottomSheet() {
      removedEntry = true;
      if (_currentBottomSheet == null) {
        return;
      }
      assert(_currentBottomSheet!.widget == bottomSheet);
      assert(bottomSheetKey.currentState != null);

      bottomSheetKey.currentState!.close();

      completer.complete();
    }

    final LocalHistoryEntry entry = LocalHistoryEntry(
      onRemove: () {
        if (!removedEntry &&
            _currentBottomSheet?.widget == bottomSheet &&
            !doingDispose) {
          removeCurrentBottomSheet();
        }
      },
    );

    void removeEntryIfNeeded() {
      if (!removedEntry) {
        entry.remove();
        removedEntry = true;
      }
    }

    bottomSheet = _StandardBottomSheet(
      key: bottomSheetKey,
      animationController: animationController,
      enableDrag: enableDrag ?? true,
      onClosing: () {
        if (_currentBottomSheet == null) {
          return;
        }
        assert(_currentBottomSheet!.widget == bottomSheet);
        removeEntryIfNeeded();
      },
      onDismissed: () {
        if (bottomSheet == _currentBottomSheet?.widget) {
          _currentBottomSheet = null;
          if (mounted) {
            setState(() {});
          }
        }
      },
      onDispose: () {
        doingDispose = true;
        removeEntryIfNeeded();
        if (shouldDisposeAnimationController) {
          animationController.dispose();
        }
      },
      builder: builder,
      isPersistent: false,
      constraints: constraints,
    );

    (Get.routing.route! as ModalRoute).addLocalHistoryEntry(entry);

    return PersistentBottomSheetController(
      bottomSheet,
      completer,
      entry.remove,
      (VoidCallback fn) {
        bottomSheetKey.currentState?.setState(fn);
      },
      true,
    );
  }

  PersistentBottomSheetController showBottomSheet(
    WidgetBuilder builder, {
    BoxConstraints? constraints,
    bool? enableDrag,
    AnimationController? transitionAnimationController,
    AnimationStyle? sheetAnimationStyle,
  }) {
    _closeCurrentBottomSheet();
    final AnimationController controller =
        (transitionAnimationController ??
              BottomSheet.createAnimationController(
                this,
                sheetAnimationStyle: sheetAnimationStyle,
              ))
          ..forward();
    setState(() {
      _currentBottomSheet = _buildBottomSheet(
        builder,
        animationController: controller,
        constraints: constraints,
        enableDrag: enableDrag,
        shouldDisposeAnimationController: transitionAnimationController == null,
      );
    });
    return _currentBottomSheet!;
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetLayout(
      body: widget.body,
      bottomSheet: _currentBottomSheet?.widget,
    );
  }
}

class _StandardBottomSheet extends StandardBottomSheet {
  const _StandardBottomSheet({
    super.key,
    required super.animationController,
    super.enableDrag,
    required super.onClosing,
    required super.onDismissed,
    required super.builder,
    super.isPersistent,
    super.constraints,
    super.onDispose,
  });

  @override
  StandardBottomSheetState createState() => _StandardBottomSheetState();
}

class _StandardBottomSheetState extends StandardBottomSheetState {
  @override
  Widget build(BuildContext context) {
    final child = BottomSheet_(
      animationController: widget.animationController,
      enableDrag: widget.enableDrag,
      onDragStart: handleDragStart,
      onDragEnd: handleDragEnd,
      onClosing: widget.onClosing!,
      builder: widget.builder,
      constraints: widget.constraints,
    );
    if (widget.enableDrag) {
      return AnimatedBuilder(
        animation: widget.animationController,
        builder: (context, child) => Align(
          alignment: AlignmentDirectional.topStart,
          heightFactor: animationCurve.transform(
            widget.animationController.value,
          ),
          child: child,
        ),
        child: child,
      );
    }
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (context, child) => Opacity(
        opacity: widget.animationController.value,
        child: child,
      ),
      child: child,
    );
  }
}
