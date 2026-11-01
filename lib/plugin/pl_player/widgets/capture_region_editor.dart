import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart' show DragStartBehavior;

import 'package:PiliPlus/plugin/pl_player/models/animated_capture.dart';
import 'package:material_ui/material_ui.dart';

class CaptureRegionEditor extends StatefulWidget {
  const CaptureRegionEditor({
    super.key,
    required this.image,
    required this.initial,
  });
  final ui.Image image;
  final CaptureRegion initial;

  @override
  State<CaptureRegionEditor> createState() => _CaptureRegionEditorState();
}

class _CaptureRegionEditorState extends State<CaptureRegionEditor> {
  Size get frameSize =>
      Size(widget.image.width.toDouble(), widget.image.height.toDouble());
  late CaptureRegion selection = widget.initial.aspectRatio.fits(frameSize)
      ? widget.initial.withAspectRatio(widget.initial.aspectRatio, frameSize)
      : widget.initial;
  late final ScrollController ratioScroll = ScrollController(
    initialScrollOffset: widget.initial.aspectRatio.index * 48.0,
  );
  Offset origin = Offset.zero;
  CaptureRegion before = CaptureRegion.full;
  int mode = -1;
  late bool explicit =
      !selection.aspectRatio.isFree ||
      selection.rect != CaptureRegion.full.rect;

  @override
  void dispose() {
    ratioScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Dialog.fullscreen(
    child: SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 16),
              const Expanded(child: Text('框选区域')),
              TextButton(
                onPressed: () => setState(() {
                  selection = CaptureRegion.full;
                  explicit = false;
                  ratioScroll.jumpTo(0);
                }),
                child: const Text('重置'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: selection.aspectRatio.fits(frameSize)
                    ? () => Navigator.pop(context, selection)
                    : null,
                child: const Text('确定'),
              ),
            ],
          ),
          if (!selection.aspectRatio.fits(frameSize))
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text('画面尺寸不足以使用此比例，请选择其他比例'),
            ),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  child: ListView.builder(
                    controller: ratioScroll,
                    itemExtent: 48,
                    itemCount: CaptureAspectRatio.values.length,
                    itemBuilder: (context, index) {
                      final ratio = CaptureAspectRatio.values[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 3,
                        ),
                        child: ChoiceChip(
                          label: Text(ratio.label),
                          showCheckmark: false,
                          selected: selection.aspectRatio == ratio,
                          onSelected: !ratio.fits(frameSize)
                              ? null
                              : (_) => setState(() {
                                  selection = selection.withAspectRatio(
                                    ratio,
                                    frameSize,
                                  );
                                  explicit =
                                      !ratio.isFree ||
                                      selection.rect != CaptureRegion.full.rect;
                                }),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      const margin = 12.0;
                      final scale = math.min(
                        math.max(0.0, constraints.maxWidth - margin * 2) /
                            frameSize.width,
                        math.max(0.0, constraints.maxHeight - margin * 2) /
                            frameSize.height,
                      );
                      final size = Size(
                        frameSize.width * scale,
                        frameSize.height * scale,
                      );
                      Offset normalized(Offset point) => Offset(
                        (point.dx - margin) / size.width,
                        (point.dy - margin) / size.height,
                      );
                      return Center(
                        child: SizedBox.fromSize(
                          size: Size(
                            size.width + margin * 2,
                            size.height + margin * 2,
                          ),
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            dragStartBehavior: DragStartBehavior.down,
                            onPanStart: (details) {
                              origin = normalized(details.localPosition);
                              before = selection;
                              final rect = selection.rect;
                              final corners = [
                                rect.topLeft,
                                rect.topRight,
                                rect.bottomRight,
                                rect.bottomLeft,
                              ];
                              mode = -2;
                              var nearest = 24.0;
                              for (var i = 0; i < corners.length; i++) {
                                final delta = corners[i] - origin;
                                final distance = Offset(
                                  delta.dx * size.width,
                                  delta.dy * size.height,
                                ).distance;
                                if (distance < nearest) {
                                  nearest = distance;
                                  mode = i;
                                }
                              }
                              final insideImage =
                                  origin.dx >= 0 &&
                                  origin.dx <= 1 &&
                                  origin.dy >= 0 &&
                                  origin.dy <= 1;
                              if (mode == -2 && insideImage) {
                                mode = explicit && rect.contains(origin)
                                    ? 4
                                    : -1;
                              }
                            },
                            onPanUpdate: (details) {
                              if (mode == -2) return;
                              setState(() {
                                final position = normalized(
                                  details.localPosition,
                                );
                                final point = Offset(
                                  position.dx.clamp(0.0, 1.0),
                                  position.dy.clamp(0.0, 1.0),
                                );
                                selection = mode == 4
                                    ? before.moved(point - origin)
                                    : mode >= 0
                                    ? before.resizeCorner(
                                        mode,
                                        point,
                                        frameSize,
                                      )
                                    : before.drawFrom(origin, point, frameSize);
                                explicit = true;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(margin),
                              child: CustomPaint(
                                painter: _RegionPainter(
                                  widget.image,
                                  selection.rect,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _RegionPainter extends CustomPainter {
  _RegionPainter(this.image, this.rect);
  final ui.Image image;
  final Rect rect;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Offset.zero & size,
      Paint(),
    );
    final selected = Rect.fromLTRB(
      rect.left * size.width,
      rect.top * size.height,
      rect.right * size.width,
      rect.bottom * size.height,
    );
    canvas
      ..drawPath(
        Path.combine(
          PathOperation.difference,
          Path()..addRect(Offset.zero & size),
          Path()..addRect(selected),
        ),
        Paint()..color = const Color(0x88000000),
      )
      ..drawRect(
        selected,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    for (final point in [
      selected.topLeft,
      selected.topRight,
      selected.bottomLeft,
      selected.bottomRight,
    ]) {
      canvas.drawCircle(point, 6, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(_RegionPainter oldDelegate) =>
      oldDelegate.rect != rect || oldDelegate.image != image;
}
