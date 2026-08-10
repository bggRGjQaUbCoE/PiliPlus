import 'package:PiliPlus/common/widgets/slotted_layout_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ChildLayoutHelper;

enum IntroType { playlist, body }

class IntroLayout
    extends SlottedMultiChildRenderObjectWidget<IntroType, RenderBox> {
  const IntroLayout({
    super.key,
    this.playlist,
    required this.body,
  });

  final Widget? playlist;
  final Widget body;

  @override
  Iterable<IntroType> get slots => IntroType.values;

  @override
  Widget? childForSlot(slot) => switch (slot) {
    .playlist => playlist,
    .body => body,
  };

  @override
  SlottedContainerRenderObjectMixin<IntroType, RenderBox> createRenderObject(
    BuildContext context,
  ) {
    return RenderIntroLayout();
  }
}

class RenderIntroLayout extends RenderBox
    with
        SlottedContainerRenderObjectMixin<IntroType, RenderBox>,
        SlottedLayoutMixin {
  RenderBox? get playlist => childForSlot(.playlist);
  RenderBox get body => childForSlot(.body)!;

  @override
  Iterable<IntroType> get slots => IntroType.values;

  @override
  void performLayout() {
    final constraints = this.constraints;
    size = constraints.biggest;

    final body = this.body..layout(constraints);
    setOffset(body, .zero);

    final playlist = this.playlist;
    if (playlist != null) {
      final playlistSize = ChildLayoutHelper.layoutChild(
        playlist,
        constraints.loosen(),
      );
      setOffset(
        playlist,
        Offset(
          (constraints.maxWidth - playlistSize.width) / 2,
          constraints.maxHeight - playlistSize.height,
        ),
      );
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    void doPaint(RenderBox? child) {
      if (child != null) {
        context.paintChild(child, getOffset(child) + offset);
      }
    }

    doPaint(body);
    doPaint(playlist);
  }
}
