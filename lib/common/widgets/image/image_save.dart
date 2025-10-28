import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/button/icon_button.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
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

      Widget iconBtn({
        String? tooltip,
        required Icon icon,
        required VoidCallback? onPressed,
      }) {
        return iconButton(
          icon: icon,
          iconSize: 20,
          tooltip: tooltip,
          onPressed: onPressed,
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
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: IconButton(
                      tooltip: '关闭',
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Colors.black.withValues(alpha: 0.3),
                        ),
                        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
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
                      icon: const Icon(Icons.watch_later_outlined),
                    ),
                  if (cover?.isNotEmpty == true) ...[
                    if (Utils.isMobile)
                      iconBtn(
                        tooltip: '分享',
                        onPressed: () {
                          SmartDialog.dismiss();
                          ImageUtils.onShareImg(cover!);
                        },
                        icon: const Icon(Icons.share),
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
                      icon: const Icon(Icons.download),
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
