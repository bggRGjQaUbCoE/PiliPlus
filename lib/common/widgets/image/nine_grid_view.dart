import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;

import 'package:flutter/material.dart';

/**
 * @Author: Sky24n
 * @GitHub: https://github.com/Sky24n
 * @Description: NineGridView.
 * @Date: 2020/06/16
 */

/// NineGridView Type.
enum NineGridType {
  /// normal NineGridView.
  normal,

  /// like WeChat NineGridView.
  weChat,

  /// like WeiBo International NineGridView.
  weiBo,

  /// like WeChat group.
  weChatGp,

  /// like DingTalk group.
  dingTalkGp,

  /// like QQ group.
  qqGp,
}

/// big images size cache map.
Map<String, Rect> ngvBigImageSizeMap = HashMap();

/// NineGridView.
/// like WeChat, WeiBo International, WeChat group, DingTalk group, QQ group.
///
/// Another [NineGridView](https://github.com/flutterchina/flukit) in [flukit](https://github.com/flutterchina/flukit) UI Kit，using GridView implementation。
class NineGridView extends StatefulWidget {
  /// create NineGridView.
  /// If you want to show a single big picture.
  /// It is recommended to use a medium-quality picture, because the original picture is too large and takes time to load.
  /// 单张大图建议使用中等质量图片，因为原图太大加载耗时。
  /// you need input (bigImageWidth + bigImageHeight) or (bigImage + bigImageUrl).
  const NineGridView({
    super.key,
    this.width,
    this.height,
    this.space = 3,
    this.arcAngle = 0,
    this.initIndex = 1,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.alignment,
    this.color,
    this.decoration,
    this.type = NineGridType.weChat,
    required this.itemCount,
    required this.itemBuilder,
    this.bigImageWidth,
    this.bigImageHeight,
    this.bigImage,
    this.bigImageUrl,
  });

  /// View width.
  final double? width;

  /// View height.
  final double? height;

  /// The number of logical pixels between each child.
  final double space;

  /// QQ group arc angle (0 ~ 180).
  final double arcAngle;

  /// QQ group init index (0 or 1). def 1.
  final int initIndex;

  /// View padding.
  final EdgeInsets padding;

  /// View margin.
  final EdgeInsets margin;

  /// Align the [child] within the container.
  final AlignmentGeometry? alignment;

  /// The color to paint behind the [child].
  final Color? color;

  /// The decoration to paint behind the [child].
  final Decoration? decoration;

  /// NineGridView type.
  final NineGridType type;

  /// The total number of children this delegate can provide.
  final int itemCount;

  /// Called to build children for the view.
  final IndexedWidgetBuilder itemBuilder;

  /// Single big picture width.
  final double? bigImageWidth;

  /// Single big picture height.
  final double? bigImageHeight;

  /// It is recommended to use a medium-quality picture, because the original picture is too large and takes time to load.
  /// 单张大图建议使用中等质量图片，因为原图太大加载耗时。
  /// Single big picture Image.
  final Image? bigImage;

  /// Single big picture url.
  final String? bigImageUrl;

  @override
  State<StatefulWidget> createState() {
    return _NineGridViewState();
  }
}

/// _NineGridViewState.
class _NineGridViewState extends State<NineGridView> {
  /// init view size.
  Rect _initSize(BuildContext context) {
    EdgeInsets padding = widget.padding;
    if (widget.itemCount == 0) {
      return Rect.fromLTRB(0, 0, padding.horizontal, padding.vertical);
    }
    double width =
        widget.width ??
        (MediaQuery.sizeOf(context).width - widget.margin.horizontal);
    width = width - padding.horizontal;
    double space = widget.space;
    double itemW;
    if (widget.type == NineGridType.weiBo &&
        (widget.itemCount == 1 || widget.itemCount == 2)) {
      // || itemCount == 4
      itemW = (width - space) / 2;
    } else {
      itemW = (width - space * 2) / 3;
    }
    bool fourGrid =
        (widget.itemCount == 4 && widget.type != NineGridType.normal);
    int column = fourGrid ? 2 : math.min(3, widget.itemCount);
    int row = fourGrid ? 2 : (widget.itemCount / 3).ceil();
    double realWidth =
        itemW * column + space * (column - 1) + padding.horizontal;
    double realHeight = itemW * row + space * (row - 1) + padding.vertical;
    return Rect.fromLTRB(itemW, 0, realWidth, realHeight);
  }

  /// build nine grid view.
  Widget _buildChild(BuildContext context, double itemW) {
    double space = widget.space;
    int column = (widget.itemCount == 4 && widget.type != NineGridType.normal)
        ? 2
        : 3;
    List<Widget> list = [];
    for (int i = 0; i < widget.itemCount; i++) {
      list.add(
        Positioned(
          top: (space + itemW) * (i ~/ column),
          left: (space + itemW) * (i % column),
          child: SizedBox(
            width: itemW,
            height: itemW,
            child: widget.itemBuilder(context, i),
          ),
        ),
      );
    }
    return Stack(
      clipBehavior: Clip.none,
      children: list,
    );
  }

  /// build one child.
  Widget? _buildOneChild(BuildContext context) {
    double? bigImgWidth = widget.bigImageWidth?.toDouble();
    double? bigImgHeight = widget.bigImageHeight?.toDouble();
    if (!_isZero(bigImgWidth) && !_isZero(bigImgHeight)) {
      return _getOneChild(context, bigImgWidth!, bigImgHeight!);
    } else if (widget.bigImage != null) {
      String bigImageUrl = widget.bigImageUrl!;
      Rect? bigImgRect = ngvBigImageSizeMap[bigImageUrl];
      bigImgWidth = bigImgRect?.width;
      bigImgHeight = bigImgRect?.height;
      if (!_isZero(bigImgWidth) && !_isZero(bigImgHeight)) {
        return _getOneChild(context, bigImgWidth!, bigImgHeight!);
      } else {
        _ImageUtil()
            .getImageSize(widget.bigImage)
            ?.then((rect) {
              ngvBigImageSizeMap[bigImageUrl] = rect;
              if (!mounted) return;
              setState(() {});
            })
            .catchError((e) {});
      }
    }
    return null;
  }

  /// get one child.
  Widget _getOneChild(BuildContext context, double width, double height) {
    Rect rect = _getBigImgSize(width, height);
    return SizedBox(
      width: rect.width,
      height: rect.height,
      child: widget.itemBuilder(context, 0),
    );
  }

  /// build weChat group.
  Widget _buildWeChatGroup(BuildContext context) {
    double width = widget.width! - widget.padding.horizontal;
    double space = widget.space;
    double itemW;

    int column = widget.itemCount < 5 ? 2 : 3;
    int row = 0;
    if (widget.itemCount == 1) {
      row = 1;
      itemW = width;
    } else if (widget.itemCount < 5) {
      row = widget.itemCount == 2 ? 1 : 2;
      itemW = (width - space) / 2;
    } else if (widget.itemCount < 7) {
      row = 2;
      itemW = (width - space * 2) / 3;
    } else {
      row = 3;
      itemW = (width - space * 2) / 3;
    }

    int first = widget.itemCount % column;
    List<Widget> list = [];
    for (int i = 0; i < widget.itemCount; i++) {
      double left;
      if (first > 0 && i < first) {
        left =
            (width - itemW * first - space * (first - 1)) / 2 +
            (itemW + space) * i;
      } else {
        left = (space + itemW) * ((i - first) % column);
      }

      int itemIndex = (first > 0 && i < first)
          ? 0
          : (first > 0 ? (i + column - first) : i) ~/ column;

      double top =
          (width - itemW * row - space * (row - 1)) / 2 +
          (space + itemW) * itemIndex;

      list.add(
        Positioned(
          top: top,
          left: left,
          child: SizedBox(
            width: itemW,
            height: itemW,
            child: widget.itemBuilder(context, i),
          ),
        ),
      );
    }
    return Stack(
      clipBehavior: Clip.none,
      children: list,
    );
  }

  /// build dingTalk group.
  Widget _buildDingTalkGroup(BuildContext context) {
    double width = widget.width! - widget.padding.horizontal;
    int itemCount = math.min(4, widget.itemCount);
    double itemW = (width - widget.space) / 2;
    List<Widget> children = [];
    for (int i = 0; i < itemCount; i++) {
      children.add(
        Positioned(
          top: (widget.space + itemW) * (i ~/ 2),
          left:
              (widget.space + itemW) *
              (((itemCount == 3 && i == 2) ? i + 1 : i) % 2),
          child: SizedBox(
            width: itemCount == 1 ? width : itemW,
            height:
                (itemCount == 1 || itemCount == 2 || (itemCount == 3 && i == 0))
                ? width
                : itemW,
            child: widget.itemBuilder(context, i),
          ),
        ),
      );
    }
    return ClipOval(
      child: Stack(
        clipBehavior: Clip.none,
        children: children,
      ),
    );
  }

  /// build QQ group.
  Widget _buildQQGroup(BuildContext context) {
    double width = widget.width! - widget.padding.horizontal;
    int itemCount = math.min(5, widget.itemCount);
    if (itemCount == 1) {
      return ClipOval(
        child: SizedBox(
          width: width,
          height: width,
          child: widget.itemBuilder(context, 0),
        ),
      );
    }

    List<Widget> children = [];
    double startDegree = 0;
    double r = 0;
    double r1 = 0;
    double centerX = width / 2;
    double centerY = width / 2;
    switch (itemCount) {
      case 2:
        startDegree = 135;
        r = width / (2 + 2 * math.sin(math.pi / 4));
        r1 = r;
        break;
      case 3:
        startDegree = 210;
        r = width / (2 + 4 * math.sin(math.pi * (3 - 2) / (2 * 3)));
        r1 = r / math.cos(math.pi * (3 - 2) / (2 * 3));
        double R =
            r *
            (1 + math.sin(math.pi / itemCount)) /
            math.sin(math.pi / itemCount);
        double dy = 0.5 * (width - R - r * (1 + 1 / math.tan(math.pi / 3)));
        centerY = dy + r + r1;
        break;
      case 4:
        startDegree = 180;
        r = width / 4;
        r1 = r / math.cos(math.pi / 4);
        break;
      case 5:
        startDegree = 126;
        r = width / (2 + 4 * math.sin(math.pi * (5 - 2) / (2 * 5)));
        r1 = r / math.cos(math.pi * (5 - 2) / (2 * 5));
        double R =
            r *
            (1 + math.sin(math.pi / itemCount)) /
            math.sin(math.pi / itemCount);
        double dy = 0.5 * (width - R - r * (1 + 1 / math.tan(math.pi / 5)));
        centerY = dy + r + r1;
        break;
    }

    for (int i = 0; i < itemCount; i++) {
      double degree1 = (itemCount == 2 || itemCount == 4) ? (-math.pi / 4) : 0;
      double x = centerX + r1 * math.sin(degree1 + i * 2 * math.pi / itemCount);
      double y = centerY - r1 * math.cos(degree1 + i * 2 * math.pi / itemCount);

      double degree = startDegree + i * 2 * 180 / itemCount;
      if (degree >= 360) degree = degree % 360;
      double previousX = r + 2 * r * math.sin(degree / 180 * math.pi);
      double previousY = r - 2 * r * math.cos(degree / 180 * math.pi);

      Widget child = Positioned.fromRect(
        rect: Rect.fromCircle(center: Offset(x, y), radius: r),
        child: ClipPath(
          clipper: QQClipper(
            total: itemCount,
            index: i,
            initIndex: widget.initIndex,
            previousX: previousX,
            previousY: previousY,
            degree: degree,
            arcAngle: widget.arcAngle,
            space: widget.space,
          ),
          child: widget.itemBuilder(context, i),
        ),
      );
      children.add(child);
    }

    return Stack(
      clipBehavior: Clip.none,
      children: children,
    );
  }

  /// double is zero.
  bool _isZero(double? value) {
    return value == null || value == 0;
  }

  /// get big image size.
  Rect _getBigImgSize(double originalWidth, double originalHeight) {
    double width =
        widget.width ??
        (MediaQuery.sizeOf(context).width - widget.margin.horizontal);
    width = width - widget.padding.horizontal;
    double itemW = (width - widget.space * 2) / 3;

    // double devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    double devicePixelRatio = 1.0;
    double tempWidth = originalWidth / devicePixelRatio;
    double tempHeight = originalHeight / devicePixelRatio;
    double maxW = itemW * 2 + widget.space;
    double minW = width / 2;

    double relWidth = tempWidth >= maxW ? maxW : math.max(minW, tempWidth);

    double relHeight;
    double ratio = tempWidth / tempHeight;
    if (tempWidth == tempHeight) {
      relHeight = relWidth;
    } else if (tempWidth > tempHeight) {
      relHeight = relWidth / (math.min(ratio, 4 / 3));
    } else {
      relHeight = relWidth / (math.max(ratio, 3 / 4));
    }
    return Rect.fromLTRB(0, 0, relWidth, relHeight);
  }

  @override
  Widget build(BuildContext context) {
    Widget? child;
    double? realWidth = widget.width;
    double? realHeight = widget.height;
    switch (widget.type) {
      case NineGridType.normal:
      case NineGridType.weiBo:
      case NineGridType.weChat:
        Rect size = _initSize(context);
        if (widget.itemCount == 1) {
          child = _buildOneChild(context);
          if (child == null) {
            realWidth = size.right;
            realHeight = size.bottom;
            child = _buildChild(context, size.left);
          }
        } else {
          realWidth = size.right;
          realHeight = size.bottom;
          child = _buildChild(context, size.left);
        }
        break;
      case NineGridType.weChatGp:
        child = _buildWeChatGroup(context);
        break;
      case NineGridType.dingTalkGp:
        child = _buildDingTalkGroup(context);
        break;
      case NineGridType.qqGp:
        child = _buildQQGroup(context);
        break;
    }
    return Container(
      alignment: widget.alignment,
      color: widget.color,
      decoration: widget.decoration,
      margin: widget.margin,
      padding: widget.padding,
      width: realWidth,
      height: realHeight,
      child: child,
    );
  }
}

/// image util.
class _ImageUtil {
  late ImageStreamListener listener;
  late ImageStream imageStream;

  /// get image size.
  Future<Rect>? getImageSize(Image? image) {
    if (image == null) {
      return null;
    }
    Completer<Rect> completer = Completer<Rect>();
    listener = ImageStreamListener(
      (ImageInfo info, bool synchronousCall) {
        imageStream.removeListener(listener);
        if (!completer.isCompleted) {
          completer.complete(
            Rect.fromLTWH(
              0,
              0,
              info.image.width.toDouble(),
              info.image.height.toDouble(),
            ),
          );
        }
      },
      onError: (exception, stackTrace) {
        imageStream.removeListener(listener);
        if (!completer.isCompleted) {
          completer.completeError(exception, stackTrace);
        }
      },
    );
    imageStream = image.image.resolve(ImageConfiguration.empty);
    imageStream.addListener(listener);
    return completer.future;
  }
}

/// QQ Clipper.
class QQClipper extends CustomClipper<Path> {
  QQClipper({
    this.total = 0,
    this.index = 0,
    this.initIndex = 1,
    this.previousX = 0,
    this.previousY = 0,
    this.degree = 0,
    this.arcAngle = 0,
    this.space = 0,
  }) : assert(arcAngle >= 0 && arcAngle <= 180);

  final int total;
  final int index;
  final int initIndex;
  final double previousX;
  final double previousY;
  final double degree;
  final double arcAngle;
  final double space;

  @override
  Path getClip(Size size) {
    double r = size.width / 2;
    Path path = Path();
    List<Offset> points = [];

    if (total == 2 && index == initIndex) {
      path.addOval(Rect.fromLTRB(0, 0, size.width, size.height));
    } else {
      /// arcAngle and space, prefer to use arcAngle.
      double spaceA = arcAngle > 0
          ? (arcAngle / 2)
          : (math.acos((r - math.min(r, space)) / r) / math.pi * 180);
      double startA = degree + spaceA;
      double endA = degree - spaceA;
      for (double i = startA; i <= 360 + endA; i = i + 1) {
        double x1 = r + r * math.sin(d2r(i));
        double y1 = r - r * math.cos(d2r(i));
        points.add(Offset(x1, y1));
      }

      double spaceB =
          math.atan(
            r * math.sin(d2r(spaceA)) / (2 * r - r * math.cos(d2r(spaceA))),
          ) /
          math.pi *
          180;
      double r1 = (2 * r - r * math.cos(d2r(spaceA))) / math.cos(d2r(spaceB));
      double startB = degree - 180 - spaceB;
      double endB = degree - 180 + spaceB;
      List<Offset> pointsB = [];
      for (double i = startB; i < endB; i = i + 1) {
        double x1 = previousX + r1 * math.sin(d2r(i));
        double y1 = previousY - r1 * math.cos(d2r(i));
        pointsB.add(Offset(x1, y1));
      }
      points.addAll(pointsB.reversed);
      path.addPolygon(points, true);
    }
    return path;
  }

  /// degree to radian.
  double d2r(double degree) {
    return degree / 180 * math.pi;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return this != oldClipper;
  }
}
