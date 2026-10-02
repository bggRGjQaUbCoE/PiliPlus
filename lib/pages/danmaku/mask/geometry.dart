import 'package:PiliPlus/pages/danmaku/mask/controller.dart';
import 'package:material_ui/material_ui.dart';

/// 弹幕遮挡区的几何映射。
///
/// 与 `pl_player/view/view.dart` 的 `_videoWidget` 组件树互为镜像：
/// SimpleVideo 盒子 → FittedBox(fit, alignment) → Transform.flip → 交互 Transform(matrix)。
/// 那边的结构变了，这里的公式要一起变。
abstract final class DanmakuMaskGeometry {
  /// child 坐标 → box 坐标。与 RenderFittedBox._updatePaintData 同式。
  /// 尺寸退化时返回 null。
  static Matrix4? fittedBoxTransform({
    required BoxFit fit,
    required Alignment alignment,
    required Size childSize,
    required Size boxSize,
  }) {
    if (childSize.isEmpty || boxSize.isEmpty) return null;
    final sizes = applyBoxFit(fit, childSize, boxSize);
    if (sizes.source.isEmpty || sizes.destination.isEmpty) return null;
    final scaleX = sizes.destination.width / sizes.source.width;
    final scaleY = sizes.destination.height / sizes.source.height;
    final source = alignment.inscribe(sizes.source, Offset.zero & childSize);
    final destination = alignment.inscribe(
      sizes.destination,
      Offset.zero & boxSize,
    );
    return Matrix4.translationValues(destination.left, destination.top, 0)
      ..scaleByDouble(scaleX, scaleY, 1, 1)
      ..translateByDouble(-source.left, -source.top, 0, 1);
  }

  /// 绕 box 中心翻转。与 Transform.flip（alignment = Alignment.center，origin = null）同式。
  static Matrix4 flipTransform({
    required bool flipX,
    required bool flipY,
    required Size boxSize,
  }) {
    if (!flipX && !flipY) return Matrix4.identity();
    final cx = boxSize.width / 2;
    final cy = boxSize.height / 2;
    return Matrix4.translationValues(cx, cy, 0)
      ..scaleByDouble(flipX ? -1 : 1, flipY ? -1 : 1, 1, 1)
      ..translateByDouble(-cx, -cy, 0, 1);
  }

  /// viewBox 坐标 → 视频盒子坐标（各轴独立缩放到盒子尺寸）。
  static Matrix4 viewBoxTransform({
    required Rect viewBox,
    required Size videoSize,
  }) {
    return Matrix4.identity()
      ..scaleByDouble(
        videoSize.width / viewBox.width,
        videoSize.height / viewBox.height,
        1,
        1,
      )
      ..translateByDouble(-viewBox.left, -viewBox.top, 0, 1);
  }

  /// 遮挡区：viewBox 坐标 → 弹幕层坐标。无法计算时返回 null（= 不遮挡）。
  static Path? maskInLayer({
    required DanmakuMaskFrame frame,
    required Size videoSize,
    required Matrix4 videoToLayer,
  }) {
    if (videoSize.isEmpty || frame.viewBox.isEmpty) return null;
    final m = videoToLayer.multiplied(
      viewBoxTransform(viewBox: frame.viewBox, videoSize: videoSize),
    );
    if (!m.storage.every((v) => v.isFinite)) return null;
    return frame.blockedPath.transform(m.storage);
  }
}
