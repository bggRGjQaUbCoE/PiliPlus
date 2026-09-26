import 'dart:async' show Timer;

import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/selection_text.dart';
import 'package:PiliPlus/models_new/live/live_superchat/item.dart';
import 'package:PiliPlus/pages/member/widget/medal_widget.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/color_utils.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/extension/iterable_ext.dart';
import 'package:PiliPlus/utils/extension/selectable_region_ext.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/screenshot.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

part 'package:PiliPlus/common/widgets/context_menu/live_menu_helper.dart';

class SuperChatCard extends StatefulWidget {
  const SuperChatCard({
    super.key,
    required this.item,
    this.onRemove,
    this.persistentSC = false,
    this.onReport,
  });

  final SuperChatItem item;
  final VoidCallback? onRemove;
  final bool persistentSC;
  final VoidCallback? onReport;

  @override
  State<SuperChatCard> createState() => _SuperChatCardState();
}

class _SuperChatCardState extends State<SuperChatCard> {
  Timer? _timer;
  RxInt? _remains;

  @override
  void initState() {
    super.initState();
    if (!widget.persistentSC) {
      if (widget.item.expired) {
        _remove();
        return;
      }
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final offset = widget.item.endTime - now;
      if (offset > 0) {
        _remains = offset.obs;
        _startTimer();
      } else {
        _remove();
      }
    }
  }

  void _remove() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(const Duration(seconds: 1), _onRemove);
    });
  }

  void _onRemove() {
    widget
      ..item.expired = true
      ..onRemove?.call();
  }

  void _callback(_) {
    final remains = _remains!.value;
    if (remains > 0) {
      _remains!.value = remains - 1;
    } else {
      _cancelTimer();
      _onRemove();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), _callback);
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  void _showMenu(Offset offset, SuperChatItem item) {
    final flag = _timer != null;
    if (flag) {
      _cancelTimer();
    }
    showMenu(
      context: context,
      position: PageUtils.menuPosition(offset),
      items: [
        PopupMenuItem(
          height: 38,
          onTap: () => Get.toNamed('/member?mid=${item.uid}'),
          child: Text(
            '访问: ${item.userInfo.uname}',
            style: const TextStyle(fontSize: 13),
          ),
        ),
        PopupMenuItem(
          height: 38,
          onTap: () => Utils.copyText(Utils.jsonEncoder.convert(item.toJson())),
          child: const Text(
            '复制 SC 信息',
            style: TextStyle(fontSize: 13),
          ),
        ),
        PopupMenuItem(
          height: 38,
          onTap: () {
            if (!mounted) return;
            _screenShot(context, item);
          },
          child: const Text(
            '保存为图片',
            style: TextStyle(fontSize: 13),
          ),
        ),
        PopupMenuItem(
          height: 38,
          onTap: widget.onReport,
          child: const Text(
            '举报',
            style: TextStyle(fontSize: 13),
          ),
        ),
      ],
    ).whenComplete(() {
      if (flag && mounted) {
        _startTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _build(item: widget.item, remains: _remains, showMenu: _showMenu);
  }
}

Widget _build({
  required SuperChatItem item,
  Function(Offset, SuperChatItem)? showMenu,
  RxInt? remains,
}) {
  final bottomColor = ColourUtils.parseColor(item.backgroundBottomColor);
  final border = BorderSide(color: bottomColor);

  Widget name = Text(
    item.userInfo.uname,
    maxLines: 1,
    overflow: .ellipsis,
    style: TextStyle(
      color: ColourUtils.parseColor(item.userInfo.nameColor),
    ),
  );
  if (item.medalInfo case final medal?) {
    try {
      name = Row(
        spacing: 5,
        children: [
          MedalWidget.fromMedalInfo(
            medal: medal,
            padding: MedalWidget.mediumPadding,
          ),
          Flexible(child: name),
        ],
      );
    } catch (e, s) {
      if (kDebugMode) {
        Utils.reportError(e, s);
      }
    }
  }

  Widget price = Text("￥${item.price}", style: TextStyle(color: bottomColor));
  Widget? remains_;
  if (remains != null) {
    remains_ = Obx(
      () => Text(
        remains.toString(),
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
    );
  } else {
    price = Row(
      crossAxisAlignment: .end,
      mainAxisAlignment: .spaceBetween,
      children: [
        price,
        Text(
          DateFormatUtils.format(
            item.startSime,
            format: DateFormatUtils.longFormatDs,
          ),
          style: TextStyle(color: bottomColor, fontSize: 13.5),
        ),
      ],
    );
  }

  Widget top = Container(
    decoration: BoxDecoration(
      borderRadius: const .vertical(top: .circular(8)),
      color: ColourUtils.parseColor(item.backgroundColor),
      border: Border(top: border, left: border, right: border),
      image: item.backgroundImage == null
          ? null
          : DecorationImage(
              alignment: .topRight,
              image: CachedNetworkImageProvider(
                ImageUtils.safeThumbnailUrl(item.backgroundImage),
              ),
            ),
    ),
    padding: const EdgeInsets.all(8),
    child: Row(
      spacing: 12,
      children: [
        _avatar(item.userInfo.face, item.userInfo.faceFrame),
        Expanded(
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            children: [name, price],
          ),
        ),
        ?remains_,
      ],
    ),
  );

  final Widget msg;

  final style = TextStyle(
    color: ColourUtils.parseColor(item.messageFontColor),
    // decoration: widget.persistentSC && item.deleted
    //     ? .lineThrough
    //     : null,
    // decorationThickness: 1.5,
    // decorationStyle: .double,
    // decorationColor: Colors.white,
  );

  if (showMenu != null) {
    void showMenu_(TapUpDetails e) => showMenu(e.globalPosition, item);
    top = GestureDetector(
      onTapUp: showMenu_,
      onSecondaryTapUp: PlatformUtils.isDesktop ? showMenu_ : null,
      child: top,
    );
    msg = TextSelectionTheme(
      data: TextSelectionThemeData(
        selectionColor: Color.lerp(bottomColor, Colors.black, .26),
        selectionHandleColor: Color.lerp(
          bottomColor,
          Colors.white,
          .26,
        ),
      ),
      child: SelectionText(
        item.message,
        contextMenuBuilder: scMenuBuilder,
        style: style,
      ),
    );
  } else {
    msg = Text(item.message, style: style);
  }

  return Column(
    mainAxisSize: .min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      top,
      Container(
        decoration: BoxDecoration(
          borderRadius: const .vertical(bottom: .circular(8)),
          color: bottomColor,
        ),
        padding: const .all(8),
        child: msg,
      ),
    ],
  );
}

Widget _avatar(String face, String? faceFrame) {
  const size = 45.0;
  final avatar = NetworkImgLayer(
    src: face,
    width: size,
    height: size,
    type: .avatar,
  );
  if (faceFrame != null && faceFrame.isNotEmpty) {
    const ratio = 1.16;
    const pendantSize = size * ratio;
    const offset = ((1 - ratio) * size) / 2;
    return Stack(
      clipBehavior: .none,
      alignment: .center,
      children: [
        avatar,
        Positioned(
          top: offset,
          child: NetworkImgLayer(
            type: .emote,
            width: pendantSize,
            height: pendantSize,
            src: faceFrame,
            getPlaceHolder: () => const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
  return avatar;
}

Future<void> _screenShot(BuildContext context, SuperChatItem item) async {
  final image = await Screenshot.screenshot(
    context,
    Material(
      type: .transparency,
      child: _build(item: item),
    ),
    constraints: const BoxConstraints(maxWidth: 400),
    pixelRatio: 3,
    future: Future.pause, // wait for asset async loaded
  );
  final bytes = await image.toByteData(format: .png);
  image.dispose();
  final picName =
      'Bili_SuperChat_${item.roomid}_${item.userInfo.uname}_￥${item.price}_${item.id}';
  ImageUtils.saveByteImg(
    bytes: bytes!.buffer.asUint8List(),
    fileName: picName,
  );
}
