import 'dart:math';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/image/nine_grid_view.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models/common/image_preview_type.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/material.dart';

class ImageModel {
  ImageModel({
    required num? width,
    required num? height,
    required this.url,
    this.liveUrl,
  }) {
    this.width = width == null || width == 0 ? 1 : width;
    this.height = height == null || height == 0 ? 1 : height;
  }

  late num width;
  late num height;
  String url;
  String? liveUrl;
  bool? _isLongPic;
  bool? _isLivePhoto;

  bool get isLongPic => _isLongPic ??= (height / width) > _maxRatio;
  bool get isLivePhoto =>
      _isLivePhoto ??= enableLivePhoto && liveUrl?.isNotEmpty == true;

  static bool enableLivePhoto = Pref.enableLivePhoto;
}

const double _maxRatio = 22 / 9;

Widget imageView(
  double maxWidth,
  List<ImageModel> picArr, {
  VoidCallback? onViewImage,
  ValueChanged<int>? onDismissed,
  Function(List<String>, int)? callback,
}) {
  double imageWidth = (maxWidth - 2 * 5) / 3;
  double imageHeight = imageWidth;
  if (picArr.length == 1) {
    dynamic width = picArr[0].width;
    dynamic height = picArr[0].height;
    double ratioWH = width / height;
    double ratioHW = height / width;
    imageWidth = ratioWH > 1.5
        ? maxWidth
        : (ratioWH >= 1 || (height > width && ratioHW < 1.5))
        ? 2 * imageWidth
        : 1.5 * imageWidth;
    imageHeight = imageWidth * min(ratioHW, _maxRatio);
  } else if (picArr.length == 2) {
    imageWidth = imageHeight = 2 * imageWidth;
  }
  late final int row = picArr.length == 4 ? 2 : 3;
  BorderRadius borderRadius(index) {
    if (picArr.length == 1) {
      return StyleString.mdRadius;
    }
    return BorderRadius.only(
      topLeft:
          index - row >= 0 ||
              ((index - 1) >= 0 && (index - 1) % row < index % row)
          ? Radius.zero
          : StyleString.imgRadius,
      topRight:
          index - row >= 0 ||
              ((index + 1) < picArr.length && (index + 1) % row > index % row)
          ? Radius.zero
          : StyleString.imgRadius,
      bottomLeft:
          index + row < picArr.length ||
              ((index - 1) >= 0 && (index - 1) % row < index % row)
          ? Radius.zero
          : StyleString.imgRadius,
      bottomRight:
          index + row < picArr.length ||
              ((index + 1) < picArr.length && (index + 1) % row > index % row)
          ? Radius.zero
          : StyleString.imgRadius,
    );
  }

  int parseSize(size) {
    return switch (size) {
      int() => size,
      double() => size.round(),
      String() => int.tryParse(size) ?? 1,
      _ => 1,
    };
  }

  void onTap(int index) {
    if (callback != null) {
      callback(picArr.map((item) => item.url).toList(), index);
    } else {
      onViewImage?.call();
      PageUtils.imageView(
        initialPage: index,
        imgList: picArr.map(
          (item) {
            bool isLive = item.isLivePhoto;
            return SourceModel(
              sourceType: isLive
                  ? SourceType.livePhoto
                  : SourceType.networkImage,
              url: item.url,
              liveUrl: isLive ? item.liveUrl : null,
              width: isLive ? parseSize(item.width) : null,
              height: isLive ? parseSize(item.height) : null,
            );
          },
        ).toList(),
        onDismissed: onDismissed,
      );
    }
  }

  return NineGridView(
    type: NineGridType.weiBo,
    margin: const EdgeInsets.only(top: 6),
    bigImageWidth: imageWidth,
    bigImageHeight: imageHeight,
    space: 5,
    height: picArr.length == 1 ? imageHeight : null,
    width: picArr.length == 1 ? imageWidth : maxWidth,
    itemCount: picArr.length,
    itemBuilder: (context, index) {
      final item = picArr[index];
      return Hero(
        tag: item.url,
        child: GestureDetector(
          onTap: () => onTap(index),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: borderRadius(index),
                child: NetworkImgLayer(
                  radius: 0,
                  src: item.url,
                  width: imageWidth,
                  height: imageHeight,
                  isLongPic: item.isLongPic,
                  forceUseCacheWidth: item.width <= item.height,
                  getPlaceHolder: () {
                    return Container(
                      width: imageWidth,
                      height: imageHeight,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.onInverseSurface.withValues(alpha: 0.4),
                        borderRadius: borderRadius(index),
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/images/loading.png',
                          width: imageWidth,
                          height: imageHeight,
                          cacheWidth: imageWidth.cacheSize(context),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (item.isLivePhoto)
                const PBadge(
                  text: 'Live',
                  right: 8,
                  bottom: 8,
                  type: PBadgeType.gray,
                )
              else if (item.isLongPic)
                const PBadge(
                  text: '长图',
                  right: 8,
                  bottom: 8,
                ),
            ],
          ),
        ),
      );
    },
  );
}
