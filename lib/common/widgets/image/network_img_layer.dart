import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkImgLayer extends StatelessWidget {
  const NetworkImgLayer({
    super.key,
    this.src,
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
    this.isLongPic,
    this.callback,
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
  final Function? isLongPic;
  final Function? callback;
  final Function? getPlaceHolder;
  final BoxFit? boxFit;

  @override
  Widget build(BuildContext context) {
    return src.isNullOrEmpty.not
        ? type == ImageType.avatar
            ? ClipOval(child: _buildImage(context))
            : radius == 0 || type == ImageType.emote
                ? _buildImage(context)
                : ClipRRect(
                    borderRadius: radius != null
                        ? BorderRadius.circular(radius!)
                        : StyleString.mdRadius,
                    child: _buildImage(context),
                  )
        : getPlaceHolder?.call() ?? placeholder(context);
  }

  Widget _buildImage(context) {
    int? memCacheWidth, memCacheHeight;
    if (height == null || callback?.call() == true || width <= height!) {
      memCacheWidth = width.cacheSize(context);
    } else {
      memCacheHeight = height.cacheSize(context);
    }
    return CachedNetworkImage(
      imageUrl: Utils.thumbnailImgUrl(src, quality),
      width: width,
      height: height,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      fit: boxFit ?? BoxFit.cover,
      alignment:
          isLongPic?.call() == true ? Alignment.topCenter : Alignment.center,
      fadeOutDuration: fadeOutDuration ?? const Duration(milliseconds: 120),
      fadeInDuration: fadeInDuration ?? const Duration(milliseconds: 120),
      filterQuality: FilterQuality.low,
      placeholder: (BuildContext context, String url) =>
          getPlaceHolder?.call() ?? placeholder(context),
      imageBuilder: imageBuilder,
    );
  }

  Widget placeholder(BuildContext context) {
    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: type == ImageType.avatar ? BoxShape.circle : BoxShape.rectangle,
        color: Theme.of(context).colorScheme.onInverseSurface.withOpacity(0.4),
        borderRadius:
            type == ImageType.avatar || type == ImageType.emote || radius == 0
                ? null
                : radius != null
                    ? BorderRadius.circular(radius!)
                    : StyleString.mdRadius,
      ),
      child: Center(
        child: Image.asset(
          type == ImageType.avatar
              ? 'assets/images/noface.jpeg'
              : 'assets/images/loading.png',
          width: width,
          height: height,
          cacheWidth: width.cacheSize(context),
        ),
      ),
    );
  }
}
