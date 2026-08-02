import 'dart:async' show Completer;

import 'package:PiliPlus/common/widgets/scaffold/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'
    show RenderStack, BoxHitTestResult, StackParentData;

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
  final _dismissedBottomSheets = <StandardBottomSheet>[];
  PersistentBottomSheetController? _currentBottomSheet;
  LocalHistoryEntry? _persistentSheetHistoryEntry;

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
    required bool isPersistent,
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

    void removePersistentSheetHistoryEntryIfNeeded() {
      assert(isPersistent);
      if (_persistentSheetHistoryEntry != null) {
        _persistentSheetHistoryEntry!.remove();
        _persistentSheetHistoryEntry = null;
      }
    }

    void removeCurrentBottomSheet() {
      removedEntry = true;
      if (_currentBottomSheet == null) {
        return;
      }
      assert(_currentBottomSheet!.widget == bottomSheet);
      assert(bottomSheetKey.currentState != null);

      if (isPersistent) {
        removePersistentSheetHistoryEntryIfNeeded();
      }

      bottomSheetKey.currentState!.close();
      setState(() {
        _currentBottomSheet = null;
      });

      if (!animationController.isDismissed) {
        _dismissedBottomSheets.add(bottomSheet);
      }
      completer.complete();
    }

    final LocalHistoryEntry? entry = isPersistent
        ? null
        : LocalHistoryEntry(
            onRemove: () {
              if (!removedEntry &&
                  _currentBottomSheet?.widget == bottomSheet &&
                  !doingDispose) {
                removeCurrentBottomSheet();
              }
            },
          );

    void removeEntryIfNeeded() {
      if (!isPersistent && !removedEntry) {
        assert(entry != null);
        entry!.remove();
        removedEntry = true;
      }
    }

    bottomSheet = _StandardBottomSheet(
      key: bottomSheetKey,
      animationController: animationController,
      enableDrag: enableDrag ?? !isPersistent,
      onClosing: () {
        if (_currentBottomSheet == null) {
          return;
        }
        assert(_currentBottomSheet!.widget == bottomSheet);
        removeEntryIfNeeded();
      },
      onDismissed: () {
        if (_dismissedBottomSheets.contains(bottomSheet)) {
          setState(() {
            _dismissedBottomSheets.remove(bottomSheet);
          });
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
      isPersistent: isPersistent,
      constraints: constraints,
    );

    if (!isPersistent) {
      ModalRoute.of(context)!.addLocalHistoryEntry(entry!);
    }

    return PersistentBottomSheetController(
      bottomSheet,
      completer,
      entry != null ? entry.remove : removeCurrentBottomSheet,
      (VoidCallback fn) {
        bottomSheetKey.currentState?.setState(fn);
      },
      !isPersistent,
    );
  }

  PersistentBottomSheetController showBottomSheet(
    WidgetBuilder builder, {
    BoxConstraints? constraints,
    bool? enableDrag,
    AnimationController? transitionAnimationController,
    AnimationStyle? sheetAnimationStyle,
  }) {
    assert(debugCheckHasMediaQuery(context));

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
        isPersistent: false,
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
    return BottomSheetStack(
      clipBehavior: .none,
      alignment: .bottomCenter,
      children: [
        widget.body,
        ..._dismissedBottomSheets,
        ?_currentBottomSheet?.widget,
      ],
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

class BottomSheetStack extends Stack {
  const BottomSheetStack({
    super.key,
    super.alignment,
    super.textDirection,
    super.fit,
    super.clipBehavior,
    super.children,
  });

  @override
  RenderBottomSheetStack createRenderObject(BuildContext context) {
    return RenderBottomSheetStack(
      alignment: alignment,
      textDirection: textDirection ?? Directionality.maybeOf(context),
      fit: fit,
      clipBehavior: clipBehavior,
    );
  }
}

class RenderBottomSheetStack extends RenderStack {
  RenderBottomSheetStack({
    super.children,
    super.alignment,
    super.textDirection,
    super.fit,
    super.clipBehavior,
  });

  /// HitTest lastChild only
  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    RenderBox? child = lastChild;
    if (child != null) {
      final childParentData = child.parentData! as StackParentData;
      return result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - childParentData.offset);
          final isHit = child.hitTest(result, position: transformed);
          if (childParentData.previousSibling != null) {
            return false;
          } else {
            return isHit;
          }
        },
      );
    }
    return false;
  }
}
