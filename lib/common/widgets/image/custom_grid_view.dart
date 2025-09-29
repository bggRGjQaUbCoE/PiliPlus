/*
 * This file is part of PiliPlus
 *
 * PiliPlus is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * PiliPlus is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with PiliPlus.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'dart:math' show min;

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/custom_layout.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/marquee.dart' show ContextSingleTicker;
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models/common/image_preview_type.dart';
import 'package:PiliPlus/utils/context_ext.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/material.dart'
    hide CustomMultiChildLayout, MultiChildLayoutDelegate;

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

class CustomGridView extends StatelessWidget {
  const CustomGridView({
    super.key,
    this.space = 5,
    required this.maxWidth,
    required this.picArr,
    this.onViewImage,
    this.onDismissed,
    this.fullScreen = false,
  });

  final double maxWidth;
  final double space;
  final List<ImageModel> picArr;
  final VoidCallback? onViewImage;
  final ValueChanged<int>? onDismissed;
  final bool fullScreen;

  static bool horizontalPreview = Pref.horizontalPreview;

  void onTap(BuildContext context, int index) {
    final imgList = picArr.map(
      (item) {
        bool isLive = item.isLivePhoto;
        return SourceModel(
          sourceType: isLive ? SourceType.livePhoto : SourceType.networkImage,
          url: item.url,
          liveUrl: isLive ? item.liveUrl : null,
          width: isLive ? item.width.toInt() : null,
          height: isLive ? item.height.toInt() : null,
        );
      },
    ).toList();
    if (horizontalPreview &&
        !fullScreen &&
        !context.mediaQuerySize.isPortrait) {
      final scaffoldState = Scaffold.maybeOf(context);
      if (scaffoldState != null) {
        PageUtils.onHorizontalPreviewState(
          scaffoldState,
          ContextSingleTicker(scaffoldState.context),
          imgList,
          index,
        );
        return;
      }
    }
    onViewImage?.call();
    PageUtils.imageView(
      initialPage: index,
      imgList: imgList,
      onDismissed: onDismissed,
    );
  }

  static BorderRadius borderRadius(
    int col,
    int length,
    int index, {
    Radius r = StyleString.imgRadius,
  }) {
    if (length == 1) return StyleString.mdRadius;

    final bool hasUp = index - col >= 0;
    final bool hasDown = index + col < length;

    final bool isRowStart = (index % col) == 0;
    final bool isRowEnd = (index % col) == col - 1 || index == length - 1;

    final bool hasLeft = !isRowStart;
    final bool hasRight = !isRowEnd && (index + 1) < length;

    return BorderRadius.only(
      topLeft: !hasUp && !hasLeft ? r : Radius.zero,
      topRight: !hasUp && !hasRight ? r : Radius.zero,
      bottomLeft: !hasDown && !hasLeft ? r : Radius.zero,
      bottomRight: !hasDown && !hasRight ? r : Radius.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    double imageWidth;
    double imageHeight;
    final length = picArr.length;
    final isSingle = length == 1;
    final isFour = length == 4;
    if (length == 2) {
      imageWidth = imageHeight = (maxWidth - space) / 2;
    } else {
      imageHeight = imageWidth = (maxWidth - 2 * space) / 3;
      if (isSingle) {
        final img = picArr.first;
        final width = img.width;
        final height = img.height;
        final ratioWH = width / height;
        final ratioHW = height / width;
        imageWidth = ratioWH > 1.5
            ? maxWidth
            : (ratioWH >= 1 || (height > width && ratioHW < 1.5))
            ? 2 * imageWidth
            : 1.5 * imageWidth;
        if (width != 1) {
          imageWidth = min(imageWidth, width.toDouble());
        }
        imageHeight = imageWidth * min(ratioHW, _maxRatio);
      }
    }

    final int column = isFour ? 2 : 3;
    final int row = isFour ? 2 : (length / 3).ceil();
    late final placeHolder = Container(
      width: imageWidth,
      height: imageHeight,
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.onInverseSurface.withValues(alpha: 0.4),
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

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: SizedBox(
        width: maxWidth,
        height: imageHeight * row + space * (row - 1),
        child: CustomMultiChildLayout(
          delegate: _CustomGridViewDelegate(
            space: space,
            itemCount: length,
            column: column,
            width: imageWidth,
            height: imageHeight,
          ),
          children: List.generate(length, (index) {
            final item = picArr[index];
            final radius = borderRadius(column, length, index);
            return LayoutId(
              id: index,
              child: Hero(
                tag: item.url,
                child: GestureDetector(
                  onTap: () => onTap(context, index),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: radius,
                        child: NetworkImgLayer(
                          radius: 0,
                          src: item.url,
                          width: imageWidth,
                          height: imageHeight,
                          isLongPic: item.isLongPic,
                          forceUseCacheWidth: item.width <= item.height,
                          getPlaceHolder: () => placeHolder,
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
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _CustomGridViewDelegate extends MultiChildLayoutDelegate {
  _CustomGridViewDelegate({
    required this.space,
    required this.itemCount,
    required this.column,
    required this.width,
    required this.height,
  });

  final double space;
  final int itemCount;
  final int column;
  final double width;
  final double height;

  @override
  void performLayout(Size size) {
    final constraints = BoxConstraints.expand(width: width, height: height);
    for (int i = 0; i < itemCount; i++) {
      layoutChild(i, constraints);
      positionChild(
        i,
        Offset(
          (space + width) * (i % column),
          (space + height) * (i ~/ column),
        ),
      );
    }
  }

  @override
  bool shouldRelayout(_CustomGridViewDelegate oldDelegate) {
    return space != oldDelegate.space ||
        itemCount != oldDelegate.itemCount ||
        column != oldDelegate.column ||
        width != oldDelegate.width ||
        height != oldDelegate.height;
  }
}
