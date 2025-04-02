import 'dart:io';

import 'package:PiliPlus/utils/utils.dart';
import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:PiliPlus/plugin/pl_player/index.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LiveHeaderControl extends StatelessWidget implements PreferredSizeWidget {
  const LiveHeaderControl({
    required this.plPlayerController,
    this.floating,
    super.key,
  });

  final Floating? floating;
  final PlPlayerController plPlayerController;

  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      primary: false,
      automaticallyImplyLeading: false,
      titleSpacing: 14,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Obx(
            () => IconButton(
              onPressed: plPlayerController.setOnlyPlayAudio,
              icon: Icon(
                size: 18,
                plPlayerController.onlyPlayAudio.value
                    ? MdiIcons.musicCircle
                    : MdiIcons.musicCircleOutline,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10),
          if (Platform.isAndroid) ...[
            SizedBox(
              width: 34,
              height: 34,
              child: IconButton(
                tooltip: '画中画',
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(EdgeInsets.zero),
                ),
                onPressed: () async {
                  try {
                    if ((await floating?.isPipAvailable) == true) {
                      plPlayerController.hiddenControls(false);
                      floating!.enable(const EnableManual());
                    }
                  } catch (_) {}
                },
                icon: const Icon(
                  Icons.picture_in_picture_outlined,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
          IconButton(
            onPressed: () => Utils.scheduleExit(
              context,
              plPlayerController.isFullScreen.value,
              true,
            ),
            icon: Icon(
              size: 18,
              Icons.schedule,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
