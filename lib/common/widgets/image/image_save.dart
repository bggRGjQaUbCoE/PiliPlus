import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/button/icon_button.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

void imageSaveDialog({
  required String? title,
  required String? cover,
  dynamic aid,
  String? bvid,
}) {
  final double imgWidth = Get.mediaQuery.size.shortestSide - 8 * 2;
  SmartDialog.show(
    animationType: SmartAnimationType.centerScale_otherSlide,
    builder: (context) {
      final theme = Theme.of(context);
      late final iconColor = theme.colorScheme.onSurfaceVariant;

      Widget iconBtn({
        String? tooltip,
        required IconData icon,
        required VoidCallback? onPressed,
      }) {
        return iconButton(
          context: context,
          onPressed: onPressed,
          iconSize: 20,
          icon: icon,
          bgColor: Colors.transparent,
          iconColor: iconColor,
        );
      }

      return Container(
        width: imgWidth,
        margin: const EdgeInsets.symmetric(horizontal: StyleString.safeSpace),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: StyleString.mdRadius,
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
                      color: Colors.black.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const IconButton(
                      style: ButtonStyle(
                        padding: WidgetStatePropertyAll(EdgeInsets.zero),
                      ),
                      onPressed: SmartDialog.dismiss,
                      icon: Icon(
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
                  if (title != null)
                    Expanded(
                      child: SelectableText(
                        title,
                        style: theme.textTheme.titleSmall,
                      ),
                    )
                  else
                    const Spacer(),
                  if (aid != null || bvid != null)
                    iconBtn(
                      tooltip: '稍后再看',
                      onPressed: () => {
                        SmartDialog.dismiss(),
                        UserHttp.toViewLater(aid: aid, bvid: bvid).then(
                          (res) => SmartDialog.showToast(res['msg']),
                        ),
                      },
                      icon: Icons.watch_later_outlined,
                    ),
                  if (cover?.isNotEmpty == true) ...[
                    iconBtn(
                      tooltip: '分享',
                      onPressed: () {
                        SmartDialog.dismiss();
                        ImageUtils.onShareImg(cover!);
                      },
                      icon: Icons.share,
                    ),
                    iconBtn(
                      tooltip: '保存封面图',
                      onPressed: () async {
                        bool saveStatus = await ImageUtils.downloadImg(
                          context,
                          [cover!],
                        );
                        if (saveStatus) {
                          SmartDialog.dismiss();
                        }
                      },
                      icon: Icons.download,
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
