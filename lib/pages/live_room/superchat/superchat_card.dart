import 'dart:async';

import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models_new/live/live_superchat/item.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuperChatCard extends StatefulWidget {
  const SuperChatCard({
    super.key,
    required this.item,
    required this.onRemove,
  });

  final SuperChatItem item;
  final VoidCallback onRemove;

  @override
  State<SuperChatCard> createState() => _SuperChatCardState();
}

class _SuperChatCardState extends State<SuperChatCard> {
  Timer? _timer;
  RxInt? _remains;

  @override
  void initState() {
    super.initState();
    if (widget.item.expired) {
      _remove();
      return;
    }
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final offset = widget.item.endTime - now;
    if (offset > 0) {
      _remains = offset.obs;
      _timer = Timer.periodic(const Duration(seconds: 1), _callback);
    } else {
      _remove();
    }
  }

  void _remove() {
    Future.delayed(const Duration(seconds: 1), _onRemove);
  }

  void _onRemove() {
    widget
      ..item.expired = true
      ..onRemove();
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

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final bottomColor = Utils.parseColor(item.backgroundBottomColor);
    final border = BorderSide(color: bottomColor);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            color: Utils.parseColor(item.backgroundColor),
            border: Border(top: border, left: border, right: border),
          ),
          padding: const EdgeInsets.all(8),
          child: Row(
            spacing: 12,
            children: [
              GestureDetector(
                onTap: () => Get.toNamed('/member?mid=${item.uid}'),
                child: NetworkImgLayer(
                  src: item.userInfo.face,
                  width: 45,
                  height: 45,
                  type: ImageType.avatar,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.userInfo.uname,
                      style: TextStyle(
                        color: Utils.parseColor(item.userInfo.nameColor),
                      ),
                    ),
                    Text(
                      "￥${item.price}",
                      style: TextStyle(
                        color: Utils.parseColor(item.backgroundPriceColor),
                      ),
                    ),
                  ],
                ),
              ),
              if (_remains != null)
                Obx(
                  () => Text(
                    _remains.toString(),
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(8),
            ),
            color: bottomColor,
          ),
          padding: const EdgeInsets.all(8),
          child: SelectableText(
            item.message,
            style: TextStyle(color: Utils.parseColor(item.messageFontColor)),
          ),
        ),
      ],
    );
  }
}
