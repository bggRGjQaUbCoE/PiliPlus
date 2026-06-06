import 'dart:async';

import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/video_card/video_cover_preview_controller.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/video/video_quality.dart';
import 'package:PiliPlus/models/common/video/video_type.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models/video/play/url.dart';
import 'package:PiliPlus/models_new/video/video_detail/dimension.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/video_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoCoverPreview extends StatefulWidget {
  const VideoCoverPreview({
    super.key,
    required this.cover,
    required this.width,
    required this.height,
    this.aid,
    this.bvid,
    this.cid,
    this.dimension,
    this.isVertical,
    this.enabled = true,
    this.type = ImageType.def,
  });

  final String? cover;
  final double width;
  final double height;
  final dynamic aid;
  final String? bvid;
  final int? cid;
  final Dimension? dimension;
  final bool? isVertical;
  final bool enabled;
  final ImageType type;

  @override
  State<VideoCoverPreview> createState() => _VideoCoverPreviewState();
}

class _VideoCoverPreviewState extends State<VideoCoverPreview> {
  static const _hoverDelay = Duration(seconds: 3);

  final Object _owner = Object();
  final _controller = VideoCoverPreviewController.instance;

  Timer? _hoverTimer;
  int _requestId = 0;
  bool _hovering = false;
  bool _loading = false;
  double? _previewAspectRatio;

  bool get _canPreview =>
      widget.enabled &&
      PlatformUtils.isDesktop &&
      (widget.aid != null || widget.bvid?.isNotEmpty == true);

  double get _currentAspectRatio {
    return _dimensionAspectRatio(widget.dimension) ??
        _previewAspectRatio ??
        (widget.isVertical == true ? 9 / 16 : 16 / 9);
  }

  @override
  void dispose() {
    _requestId++;
    _hoverTimer?.cancel();
    _controller.detach(_owner);
    super.dispose();
  }

  void _onEnter(PointerEnterEvent _) {
    if (!_canPreview) return;
    _hovering = true;
    final requestId = ++_requestId;
    _hoverTimer?.cancel();
    _hoverTimer = Timer(_hoverDelay, () => _startPreview(requestId));
  }

  void _onExit(PointerExitEvent _) {
    _hovering = false;
    _requestId++;
    _hoverTimer?.cancel();
    _hoverTimer = null;
    _loading = false;
    _controller.stop(_owner);
    if (mounted) setState(() {});
  }

  Future<void> _startPreview(int requestId) async {
    if (!_isCurrentRequest(requestId) || _loading) return;
    setState(() => _loading = true);

    final preview = await _resolvePreview();
    if (!_isCurrentRequest(requestId)) return;

    if (preview == null) {
      setState(() => _loading = false);
      return;
    }

    _previewAspectRatio = preview.aspectRatio ?? _previewAspectRatio;
    await _controller.play(_owner, preview.url);
    if (!_isCurrentRequest(requestId)) return;
    setState(() => _loading = false);
  }

  bool _isCurrentRequest(int requestId) {
    return mounted && _hovering && requestId == _requestId && _canPreview;
  }

  Future<({String url, double? aspectRatio})?> _resolvePreview() async {
    try {
      int? cid = widget.cid;
      Dimension? dimension;
      if (cid == null) {
        final res = await SearchHttp.ab2cWithDimension(
          aid: widget.aid,
          bvid: widget.bvid,
        );
        cid = res?.cid;
        dimension = res?.dimension;
      }
      if (cid == null) return null;

      final res = await VideoHttp.videoUrl(
        avid: widget.aid,
        bvid: widget.bvid,
        cid: cid,
        qn: VideoQuality.speed240.code,
        tryLook: false,
        videoType: VideoType.ugc,
      );
      return switch (res) {
        Success(:final response) => _selectPreview(
          response,
          aspectRatio:
              _dimensionAspectRatio(widget.dimension) ??
              _dimensionAspectRatio(dimension) ??
              _boolAspectRatio(widget.isVertical),
        ),
        _ => null,
      };
    } catch (err, stackTrace) {
      if (kDebugMode) {
        debugPrint('resolve video cover preview failed: $err\n$stackTrace');
      }
      return null;
    }
  }

  ({String url, double? aspectRatio})? _selectPreview(
    PlayUrlModel playUrl, {
    required double? aspectRatio,
  }) {
    final videos = playUrl.dash?.video
        ?.where((item) => item.playUrls.isNotEmpty)
        .toList();
    if (videos?.isNotEmpty == true) {
      videos!.sort((a, b) {
        final qualityCompare = a.quality.code.compareTo(b.quality.code);
        if (qualityCompare != 0) return qualityCompare;
        final aAvc = a.codecs?.startsWith('avc1') == true;
        final bAvc = b.codecs?.startsWith('avc1') == true;
        if (aAvc != bAvc) return aAvc ? -1 : 1;
        return (a.bandWidth ?? 0).compareTo(b.bandWidth ?? 0);
      });
      final video = videos.first;
      return (
        url: VideoUtils.getCdnUrl(video.playUrls),
        aspectRatio: aspectRatio ?? _videoAspectRatio(video),
      );
    }

    final durls = playUrl.durl?.where((item) => item.playUrls.isNotEmpty);
    if (durls?.isNotEmpty == true) {
      return (
        url: VideoUtils.getCdnUrl(durls!.first.playUrls),
        aspectRatio: aspectRatio,
      );
    }

    return null;
  }

  double? _dimensionAspectRatio(Dimension? dimension) {
    return dimension?.width != null && dimension?.height != null
        ? dimension!.width! / dimension.height!
        : null;
  }

  double? _videoAspectRatio(VideoItem video) {
    return video.width != null && video.height != null
        ? video.width! / video.height!
        : null;
  }

  double? _boolAspectRatio(bool? isVertical) {
    return switch (isVertical) {
      true => 9 / 16,
      false => 16 / 9,
      null => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final videoController = _controller.videoController;
          final playing =
              _controller.owner == _owner && videoController != null;
          final aspectRatio = _currentAspectRatio;
          return Stack(
            fit: StackFit.expand,
            children: [
              NetworkImgLayer(
                src: widget.cover,
                width: widget.width,
                height: widget.height,
                type: widget.type,
              ),
              if (playing)
                IgnorePointer(
                  child: ColoredBox(
                    color: Colors.black,
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: aspectRatio,
                        child: SimpleVideo(
                          controller: videoController,
                          fill: Colors.black,
                          aspectRatio: aspectRatio,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
