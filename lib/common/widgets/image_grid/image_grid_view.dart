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
import 'package:PiliPlus/common/widgets/image_viewer/gallery_viewer.dart';
import 'package:PiliPlus/common/widgets/scaffold/mini_scaffold.dart';
import 'package:PiliPlus/models/common/image_preview_type.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:material_ui/material_ui.dart';

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

  bool get isLongPic =>
      _isLongPic ??= (height / width) > Style.imgMaxRatio && width > 100;
  bool get isLivePhoto =>
      _isLivePhoto ??= enableLivePhoto && liveUrl?.isNotEmpty == true;

  static bool enableLivePhoto = Pref.enableLivePhoto;
}

class ImageGridView extends StatefulWidget {
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
  static bool enableImgMenu = Pref.enableImgMenu;

  static BorderRadius _borderRadius(
    int col,
    int length,
    int index, {
    Radius r = Style.imgRadius,
  }) {
    if (length == 1) return Style.mdRadius;

    final bool hasUp = index - col >= 0;
    final bool hasDown = index + col < length;

    final bool isRowStart = index % col == 0;
    final bool isRowEnd = index % col == col - 1 || index == length - 1;

    return BorderRadius.only(
      topLeft: !hasUp && isRowStart ? r : Radius.zero,
      topRight: !hasUp && isRowEnd ? r : Radius.zero,
      bottomLeft: !hasDown && isRowStart ? r : Radius.zero,
      bottomRight: !hasDown && isRowEnd ? r : Radius.zero,
    );
  }

  @override
  State<ImageGridView> createState() => _ImageGridViewState();
}

class _ImageGridViewState extends State<ImageGridView> {
  late final String _heroTag = UniqueKey().toString();
  final Map<int, ({String url, ImageProvider provider})> _loadedImages = {};
  final Set<(int, String)> _pendingImageReady = {};
  int _column = 3;

  String _tagFor(int index, ImageModel item) => '${item.url}$_heroTag$index';

  void _onImageReady(int index, String url, ImageProvider provider) {
    final loaded = _loadedImages[index];
    if (loaded?.url == url && loaded?.provider == provider) return;
    final pending = (index, url);
    if (!_pendingImageReady.add(pending)) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pendingImageReady.remove(pending);
      if (!mounted ||
          index >= widget.picArr.length ||
          widget.picArr[index].url != url) {
        return;
      }
      if (_loadedImages[index]?.provider == provider) return;
      setState(() => _loadedImages[index] = (url: url, provider: provider));
    });
  }

  void _onTap(BuildContext context, int index) {
    final imgList = List<SourceModel>.generate(widget.picArr.length, (i) {
      final item = widget.picArr[i];
      final isLive = item.isLivePhoto;
      return SourceModel(
        sourceType: isLive ? .livePhoto : .networkImage,
        url: item.url,
        liveUrl: isLive ? item.liveUrl : null,
        width: item.width.toInt(),
        height: item.height.toInt(),
        isLongPic: item.isLongPic,
        previewImageProvider: _loadedImages[i]?.provider,
        heroBorderRadius: ImageGridView._borderRadius(
          _column,
          widget.picArr.length,
          i,
        ),
      );
    });
    final item = widget.picArr[index];
    final reduceImageMotion =
        !item.isLivePhoto && MediaQuery.disableAnimationsOf(context);
    final canFly =
        !item.isLongPic &&
        (item.isLivePhoto ||
            (!reduceImageMotion &&
                (_loadedImages[index]?.url == item.url &&
                    item.width > 1 &&
                    item.height > 1)));
    if (ImageGridView.horizontalPreview &&
        !widget.fullScreen &&
        Get.currentRoute.startsWith(ImageGridView._regex) &&
        !MediaQuery.isPortraitOf(context)) {
      final scaffoldState = MiniScaffold.maybeOf(context);
      if (scaffoldState != null) {
        widget.onViewImage?.call();
        scaffoldState.showBottomSheet(
          constraints: const BoxConstraints(),
          (context) => GalleryViewer(
            sources: imgList,
            initIndex: index,
            quality: GlobalData().imgQuality,
          ),
          enableDrag: false,
        );
        return;
      }
    }
    PageUtils.imageView(
      initialPage: index,
      imgList: imgList,
      tag: canFly ? _heroTag : '',
      fade: item.isLivePhoto ? null : !reduceImageMotion,
      indexedHeroTags: true,
      transitionDuration: reduceImageMotion ? Duration.zero : null,
    );
  }

  @override
  void didUpdateWidget(covariant ImageGridView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.picArr.length != widget.picArr.length ||
        List.generate(
              oldWidget.picArr.length,
              (index) => oldWidget.picArr[index].url,
            ).join('\n') !=
            List.generate(
              widget.picArr.length,
              (index) => widget.picArr[index].url,
            ).join('\n')) {
      _loadedImages.clear();
      _pendingImageReady.clear();
    }
  }

  void _showMenu(BuildContext context, int index, Offset offset) {
    HapticFeedback.mediumImpact();
    final item = widget.picArr[index];
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
          ),
        if (widget.picArr.length > 1)
          PopupMenuItem(
            height: 42,
            onTap: () => ImageUtils.downloadImg(
              widget.picArr.map((item) => item.url).toList(),
            ),
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
        picArr: widget.picArr,
        onTap: (index) => _onTap(context, index),
        onSecondaryTapUp: ImageGridView.enableImgMenu && PlatformUtils.isDesktop
            ? (index, offset) => _showMenu(context, index, offset)
            : null,
        onLongPressStart: ImageGridView.enableImgMenu && PlatformUtils.isMobile
            ? (index, offset) => _showMenu(context, index, offset)
            : null,
        builder: (BuildContext context, ImageGridInfo info) {
          final width = info.size.width;
          final height = info.size.height;
          _column = info.column;
          late final placeHolder = Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: ColorScheme.of(
                context,
              ).onInverseSurface.withValues(alpha: 0.4),
            ),
            child: Image.asset(
              Assets.loading,
              width: width,
              height: height,
              cacheWidth: width.cacheSize(context),
            ),
          );
          return List.generate(widget.picArr.length, (index) {
            void onTap() => _onTap(context, index);
            final item = widget.picArr[index];
            final borderRadius = ImageGridView._borderRadius(
              info.column,
              widget.picArr.length,
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
                  borderRadius: item.isLivePhoto
                      ? borderRadius
                      : BorderRadius.zero,
                  alignment: item.isLongPic ? .topCenter : .center,
                  cacheWidth: item.width <= item.height,
                  getPlaceHolder: () => placeHolder,
                  onImageReady: (provider) =>
                      _onImageReady(index, item.url, provider),
                ),
                if (item.isLivePhoto)
                  const PBadge(text: 'Live', right: 8, bottom: 8, type: .gray)
                else if (item.isLongPic)
                  const PBadge(text: '长图', right: 8, bottom: 8),
              ],
            );
            if (!item.isLongPic) {
              child = Hero(
                tag: _tagFor(index, item),
                child: child,
              );
              if (!item.isLivePhoto) {
                child = ClipRRect(borderRadius: borderRadius, child: child);
              }
            }
            child = Semantics(
              label: '图片，第 ${index + 1} 张，共 ${widget.picArr.length} 张',
              button: true,
              onTap: onTap,
              child: child,
            );
            return LayoutId(id: index, child: child);
          });
        },
      ),
    );
  }
}
