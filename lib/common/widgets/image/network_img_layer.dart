import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkImgLayer extends StatelessWidget {
  const NetworkImgLayer({
    super.key,
    required this.src,
    required this.width,
    this.height,
    this.type = ImageType.def,
    this.fadeOutDuration,
    this.fadeInDuration,
    // 图片质量 默认1%
    this.quality,
    this.semanticsLabel,
    this.radius,
    this.imageBuilder,
    this.isLongPic = false,
    this.forceUseCacheWidth = false,
    this.getPlaceHolder,
    this.boxFit,
  });

  final String? src;
  final double width;
  final double? height;
  final ImageType type;
  final Duration? fadeOutDuration;
  final Duration? fadeInDuration;
  final int? quality;
  final String? semanticsLabel;
  final double? radius;
  final ImageWidgetBuilder? imageBuilder;
  final bool isLongPic;
  final bool forceUseCacheWidth;
  final Widget Function()? getPlaceHolder;
  final BoxFit? boxFit;

  static Color? reduceLuxColor = Pref.reduceLuxColor;
  static bool reduce = false;

  @override
  Widget build(BuildContext context) {
    final noRadius = type == ImageType.emote || radius == 0;
    final Widget child;

    if (src?.isNotEmpty == true) {
      child = noRadius
          ? _buildImage(context, noRadius)
          : type == ImageType.avatar
          ? ClipOval(child: _buildImage(context, noRadius))
          : ClipRRect(
              borderRadius: radius != null
                  ? BorderRadius.circular(radius!)
                  : StyleString.mdRadius,
              child: _buildImage(context, noRadius),
            );
    } else {
      child = getPlaceHolder?.call() ?? _placeholder(context, noRadius);
    }

    return semanticsLabel?.isNotEmpty == true
        ? Semantics(
            container: true,
            image: true,
            excludeSemantics: true,
            label: semanticsLabel,
            child: child,
          )
        : child;
  }

  Widget _buildImage(BuildContext context, bool noRadius) {
    int? memCacheWidth, memCacheHeight;
    if (height == null || forceUseCacheWidth || width <= height!) {
      memCacheWidth = width.cacheSize(context);
    } else {
      memCacheHeight = height?.cacheSize(context);
    }
    return CachedNetworkImage(
      imageUrl: ImageUtils.thumbnailUrl(src, quality),
      width: width,
      height: height,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      fit: boxFit ?? BoxFit.cover,
      alignment: isLongPic ? Alignment.topCenter : Alignment.center,
      fadeOutDuration: fadeOutDuration ?? const Duration(milliseconds: 120),
      fadeInDuration: fadeInDuration ?? const Duration(milliseconds: 120),
      filterQuality: FilterQuality.low,
      placeholder: (BuildContext context, String url) =>
          getPlaceHolder?.call() ?? _placeholder(context, noRadius),
      imageBuilder: imageBuilder,
      errorWidget: (context, url, error) => _placeholder(context, noRadius),
      colorBlendMode: reduce ? BlendMode.modulate : null,
      color: reduce ? reduceLuxColor : null,
    );
  }

  Widget _placeholder(BuildContext context, bool noRadius) {
    final isAvatar = type == ImageType.avatar;
    return Container(
      width: width,
      height: height,
      clipBehavior: noRadius ? Clip.none : Clip.antiAlias,
      decoration: BoxDecoration(
        shape: isAvatar ? BoxShape.circle : BoxShape.rectangle,
        color: Theme.of(
          context,
        ).colorScheme.onInverseSurface.withValues(alpha: 0.4),
        borderRadius: noRadius || isAvatar
            ? null
            : radius != null
            ? BorderRadius.circular(radius!)
            : StyleString.mdRadius,
      ),
      child: Center(
        child: Image.asset(
          isAvatar ? 'assets/images/noface.jpeg' : 'assets/images/loading.png',
          width: width,
          height: height,
          cacheWidth: width.cacheSize(context),
          colorBlendMode: reduce ? BlendMode.modulate : null,
          color: reduce ? reduceLuxColor : null,
        ),
      ),
    );
  }
}
