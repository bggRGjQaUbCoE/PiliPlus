import 'dart:math';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/icon_button.dart';
import 'package:PiliPlus/common/widgets/network_img_layer.dart';
import 'package:PiliPlus/utils/download.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

void imageSaveDialog({
  required String? title,
  required String? cover,
}) {
  final double imgWidth = min(Get.width, Get.height) - 8 * 2;
  SmartDialog.show(
    animationType: SmartAnimationType.centerScale_otherSlide,
    builder: (context) {
      final theme = Theme.of(context);
      return Container(
        width: imgWidth,
        margin: const EdgeInsets.symmetric(horizontal: StyleString.safeSpace),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  onTap: SmartDialog.dismiss,
                  child: NetworkImgLayer(
                    width: imgWidth,
                    height: imgWidth / StyleString.aspectRatio,
                    src: cover,
                    quality: 100,
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all(EdgeInsets.zero),
                      ),
                      onPressed: SmartDialog.dismiss,
                      icon: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
              child: Row(
                children: [
                  Expanded(
                    child: SelectableText(
                      title ?? '',
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                  if (cover?.isNotEmpty == true) ...[
                    const SizedBox(width: 4),
                    iconButton(
                      context: context,
                      tooltip: '分享',
                      onPressed: () {
                        SmartDialog.dismiss();
                        DownloadUtils.onShareImg(cover!);
                      },
                      iconSize: 20,
                      icon: Icons.share,
                      bgColor: Colors.transparent,
                      iconColor: theme.colorScheme.onSurfaceVariant,
                    ),
                    iconButton(
                      context: context,
                      tooltip: '保存封面图',
                      onPressed: () async {
                        bool saveStatus = await DownloadUtils.downloadImg(
                          context,
                          [cover!],
                        );
                        if (saveStatus) {
                          SmartDialog.dismiss();
                        }
                      },
                      iconSize: 20,
                      icon: Icons.download,
                      bgColor: Colors.transparent,
                      iconColor: theme.colorScheme.onSurfaceVariant,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
