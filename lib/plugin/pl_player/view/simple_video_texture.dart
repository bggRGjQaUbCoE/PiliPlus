import 'dart:async';

import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';

class SimpleVideoTexture extends StatefulWidget {
  final Color fill;
  final VideoController controller;
  final double? aspectRatio;
  final FilterQuality filterQuality;

  const SimpleVideoTexture({
    super.key,
    this.fill = Colors.black,
    required this.controller,
    this.aspectRatio,
    this.filterQuality = FilterQuality.low,
  });

  @override
  State<SimpleVideoTexture> createState() => SimpleVideoTextureState();
}

class SimpleVideoTextureState extends State<SimpleVideoTexture> {
  late double _devicePixelRatio;
  late bool _visible =
      widget.controller.player.state.width > 0 &&
      widget.controller.player.state.height > 0;

  late final StreamSubscription<(int, int)> _subscription;

  @override
  void initState() {
    super.initState();
    // --------------------------------------------------
    // Do not show the video frame until width & height are available.
    // Since [ValueNotifier<Rect?>] inside [VideoController] only gets updated by the render loop (i.e. it will not fire when video's width & height are not available etc.), it's important to handle this separately here.
    _subscription = widget.controller.player.stream.size.listen((value) {
      final visible = value.$1 > 0 && value.$2 > 0;
      if (_visible != visible) {
        _visible = visible;
        // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
        widget.controller.rect.notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
  }

  @override
  Widget build(BuildContext context) {
    final ctr = widget.controller;
    return ListenableBuilder(
      listenable: Listenable.merge([ctr.id, ctr.rect]),
      builder: (context, _) {
        final id = ctr.id.value;
        final rect = ctr.rect.value;
        if (id != null && rect != null && _visible) {
          return SizedBox(
            width: widget.aspectRatio == null
                ? rect.width / _devicePixelRatio
                : rect.height / _devicePixelRatio * widget.aspectRatio!,
            height: rect.height / _devicePixelRatio,
            child: Stack(
              children: [
                if (rect.width <= 1.0 &&
                    rect.height <= 1.0 &&
                    widget.fill != Colors.transparent)
                  Positioned.fill(child: ColoredBox(color: widget.fill)),
                Texture(textureId: id, filterQuality: widget.filterQuality),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
