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

import 'package:PiliPlus/common/assets.dart';
import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/image_grid/image_grid_builder.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models/common/image_preview_type.dart';
import 'package:PiliPlus/utils/extension/context_ext.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/extension/size_ext.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

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

  bool get isLongPic => _isLongPic ??= (height / width) > Style.imgMaxRatio;
  bool get isLivePhoto =>
      _isLivePhoto ??= enableLivePhoto && liveUrl?.isNotEmpty == true;

  static bool enableLivePhoto = Pref.enableLivePhoto;
}

class ImageGridView extends StatelessWidget {
  const ImageGridView({
    super.key,
    required this.picArr,
    this.onViewImage,
    this.fullScreen = false,
  });

  final List<ImageModel> picArr;
  final VoidCallback? onViewImage;
  final bool fullScreen;

  static bool horizontalPreview = Pref.horizontalPreview;
  static final _regex = RegExp(r'/videoV|/dynamicDetail$|/articlePage');

  void _onTap(BuildContext context, int index) {
    final imgList = picArr.map(
      (item) {
        bool isLive = item.isLivePhoto;
        return SourceModel(
          sourceType: isLive ? .livePhoto : .networkImage,
          url: item.url,
          liveUrl: isLive ? item.liveUrl : null,
          width: isLive ? item.width.toInt() : null,
          height: isLive ? item.height.toInt() : null,
          isLongPic: item.isLongPic,
        );
      },
    ).toList();
    if (horizontalPreview &&
        !fullScreen &&
        Get.currentRoute.startsWith(_regex) &&
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
      tag: hashCode.toString(),
    );
  }

  static BorderRadius _borderRadius(
    int col,
    int length,
    int index, {
    Radius r = Style.imgRadius,
  }) {
    if (length == 1) return Style.mdRadius;

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

  void _showMenu(BuildContext context, int index, Offset offset) {
    HapticFeedback.mediumImpact();
    final item = picArr[index];
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
    return Padding(
      padding: const .only(top: 6),
      child: ImageGridBuilder(
        picArr: picArr,
        onTap: (index) => _onTap(context, index),
        onSecondaryTapUp: enableImgMenu && PlatformUtils.isDesktop
            ? (index, offset) => _showMenu(context, index, offset)
            : null,
        onLongPressStart: enableImgMenu && PlatformUtils.isMobile
            ? (index, offset) => _showMenu(context, index, offset)
            : null,
        builder: (BuildContext context, ImageGridInfo info) {
          final width = info.size.width;
          final height = info.size.height;
          late final placeHolder = Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.onInverseSurface.withValues(alpha: 0.4),
            ),
            child: Image.asset(
              Assets.loading,
              width: width,
              height: height,
              cacheWidth: width.cacheSize(context),
            ),
          );
          return List.generate(picArr.length, (index) {
            final item = picArr[index];
            final borderRadius = _borderRadius(
              info.column,
              picArr.length,
              index,
            );
            Widget child = Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                NetworkImgLayer(
                  src: item.url,
                  width: width,
                  height: height,
                  borderRadius: borderRadius,
                  alignment: item.isLongPic ? .topCenter : .center,
                  cacheWidth: item.width <= item.height,
                  getPlaceHolder: () => placeHolder,
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
            );
            if (!item.isLongPic) {
              child = Hero(
                tag: '${item.url}$hashCode',
                child: child,
              );
            }
            return LayoutId(
              id: index,
              child: child,
            );
          });
        },
      ),
    );
  }
}
