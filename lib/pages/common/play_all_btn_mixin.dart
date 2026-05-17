import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';

mixin PlayAllBtnMixin {
  late double dx = 0;
  late final RxBool isPlayAll = Pref.enablePlayAll.obs;

  void setIsPlayAll(bool isPlayAll) {
    if (this.isPlayAll.value == isPlayAll) return;
    this.isPlayAll.value = isPlayAll;
    GStorage.setting.put(SettingBoxKey.enablePlayAll, isPlayAll);
  }

  Widget playAllBtn(VoidCallback onPlayAll) {
    return AnimatedSlide(
      offset: isPlayAll.value ? Offset.zero : const Offset(0.75, 0),
      duration: const Duration(milliseconds: 120),
      child: GestureDetector(
        onHorizontalDragDown: (details) => dx = details.localPosition.dx,
        onHorizontalDragStart: (details) => setIsPlayAll(
          details.localPosition.dx < dx,
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            if (isPlayAll.value) {
              onPlayAll();
            } else {
              setIsPlayAll(true);
            }
          },
          label: const Text('播放全部'),
          icon: const Icon(Icons.playlist_play),
        ),
      ),
    );
  }
}
