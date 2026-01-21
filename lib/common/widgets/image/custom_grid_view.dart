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

import 'dart:io' show Platform;
import 'dart:math' show min;

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models/common/image_preview_type.dart';
import 'package:PiliPlus/utils/extension/context_ext.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/extension/size_ext.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/material.dart'
    hide CustomMultiChildLayout, MultiChildLayoutDelegate;
import 'package:flutter/rendering.dart'
    show
        ContainerRenderObjectMixin,
        RenderBoxContainerDefaultsMixin,
        MultiChildLayoutParentData,
        BoxHitTestResult;
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

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
    this.fullScreen = false,
  });

  final double maxWidth;
  final double space;
  final List<ImageModel> picArr;
  final VoidCallback? onViewImage;
  final bool fullScreen;

  static bool horizontalPreview = Pref.horizontalPreview;
  static const _routes = ['/videoV', '/dynamicDetail'];

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
        _routes.contains(Get.currentRoute) &&
        !context.mediaQuerySize.isPortrait) {
      final scaffoldState = Scaffold.maybeOf(context);
      if (scaffoldState != null) {
        onViewImage?.call();
        PageUtils.onHorizontalPreviewState(
          scaffoldState,
          imgList,
          index,
        );
        return;
      }
    }
    PageUtils.imageView(
      initialPage: index,
      imgList: imgList,
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

  static bool enableImgMenu = Pref.enableImgMenu;

  void _showMenu(BuildContext context, Offset offset, ImageModel item) {
    HapticFeedback.mediumImpact();
    showMenu(
      context: context,
      position: PageUtils.menuPosition(offset),
      items: [
        if (PlatformUtils.isMobile)
          PopupMenuItem(
            height: 42,
            onTap: () => ImageUtils.onShareImg(item.url),
            child: const Text('分享', style: TextStyle(fontSize: 14)),
          ),
        PopupMenuItem(
          height: 42,
          onTap: () => ImageUtils.downloadImg([item.url]),
          child: const Text('保存图片', style: TextStyle(fontSize: 14)),
        ),
        if (PlatformUtils.isDesktop)
          PopupMenuItem(
            height: 42,
            onTap: () => PageUtils.launchURL(item.url),
            child: const Text('网页打开', style: TextStyle(fontSize: 14)),
          )
        else if (picArr.length > 1)
          PopupMenuItem(
            height: 42,
            onTap: () =>
                ImageUtils.downloadImg(picArr.map((item) => item.url).toList()),
            child: const Text('保存全部', style: TextStyle(fontSize: 14)),
          ),
        if (item.isLivePhoto)
          PopupMenuItem(
            height: 42,
            onTap: () => ImageUtils.downloadLivePhoto(
              url: item.url,
              liveUrl: item.liveUrl!,
              width: item.width.toInt(),
              height: item.height.toInt(),
            ),
            child: Text(
              '保存${Platform.isIOS ? '实况' : '视频'}',
              style: const TextStyle(fontSize: 14),
            ),
          ),
      ],
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
      child: Image.asset(
        'assets/images/loading.png',
        width: imageWidth,
        height: imageHeight,
        cacheWidth: imageWidth.cacheSize(context),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: SizedBox(
        width: maxWidth,
        height: imageHeight * row + space * (row - 1),
        child: ImageGrid(
          space: space,
          column: column,
          width: imageWidth,
          height: imageHeight,
          children: List.generate(length, (index) {
            final item = picArr[index];
            final radius = borderRadius(column, length, index);
            return LayoutId(
              id: index,
              child: GestureDetector(
                onTap: () => onTap(context, index),
                onSecondaryTapUp: enableImgMenu && PlatformUtils.isDesktop
                    ? (details) =>
                          _showMenu(context, details.globalPosition, item)
                    : null,
                onLongPressStart: enableImgMenu && PlatformUtils.isMobile
                    ? (details) =>
                          _showMenu(context, details.globalPosition, item)
                    : null,
                child: Hero(
                  tag: item.url,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: radius,
                        child: NetworkImgLayer(
                          type: .emote,
                          src: item.url,
                          width: imageWidth,
                          height: imageHeight,
                          alignment: item.isLongPic ? .topCenter : .center,
                          cacheWidth: item.width <= item.height,
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

class ImageGrid extends MultiChildRenderObjectWidget {
  const ImageGrid({
    super.key,
    super.children,
    required this.space,
    required this.column,
    required this.width,
    required this.height,
  });

  final double space;
  final int column;
  final double width;
  final double height;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderImageGrid(
      space: space,
      column: column,
      width: width,
      height: height,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderImageGrid renderObject) {
    renderObject
      ..space = space
      ..column = column
      ..width = width
      ..height = height;
  }
}

class RenderImageGrid extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MultiChildLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MultiChildLayoutParentData> {
  RenderImageGrid({
    required double space,
    required int column,
    required double width,
    required double height,
  }) : _space = space,
       _column = column,
       _width = width,
       _height = height;

  double _space;
  double get space => _space;
  set space(double value) {
    if (_space == value) return;
    _space = value;
    markNeedsLayout();
  }

  int _column;
  int get column => _column;
  set column(int value) {
    if (_column == value) return;
    _column = value;
    markNeedsLayout();
  }

  double _width;
  double get width => _width;
  set width(double value) {
    if (_width == value) return;
    _width = value;
    markNeedsLayout();
  }

  double _height;
  double get height => _height;
  set height(double value) {
    if (_height == value) return;
    _height = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! MultiChildLayoutParentData) {
      child.parentData = MultiChildLayoutParentData();
    }
  }

  @override
  void performLayout() {
    size = constraints.constrain(constraints.biggest);

    final itemConstraints = BoxConstraints(
      minWidth: width,
      maxWidth: width,
      minHeight: height,
      maxHeight: height,
    );
    RenderBox? child = firstChild;
    while (child != null) {
      final childParentData = child.parentData as MultiChildLayoutParentData;
      final index = childParentData.id as int;
      child.layout(itemConstraints, parentUsesSize: true);
      childParentData.offset = Offset(
        (space + width) * (index % column),
        (space + height) * (index ~/ column),
      );
      child = childParentData.nextSibling;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox? child = firstChild;
    while (child != null) {
      final childParentData = child.parentData as MultiChildLayoutParentData;
      context.paintChild(child, childParentData.offset + offset);
      child = childParentData.nextSibling;
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  bool get isRepaintBoundary => true;
}
