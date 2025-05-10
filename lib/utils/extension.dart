import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/interactiveviewer_gallery/hero_dialog_route.dart';
import 'package:PiliPlus/common/widgets/interactiveviewer_gallery/interactiveviewer_gallery.dart';
import 'package:PiliPlus/grpc/bilibili/app/im/v1.pbenum.dart'
    show IMSettingType, ThreeDotItemType;
import 'package:PiliPlus/models/common/image_preview_type.dart';
import 'package:PiliPlus/pages/common/common_whisper_controller.dart';
import 'package:PiliPlus/pages/contact/view.dart';
import 'package:PiliPlus/pages/whisper_settings/view.dart';
import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

extension ImageExtension on num? {
  int? cacheSize(BuildContext context) {
    if (this == null || this == 0) {
      return null;
    }
    return (this! * MediaQuery.of(context).devicePixelRatio).round();
  }
}

extension ScrollControllerExt on ScrollController {
  void animToTop() {
    if (!hasClients) return;
    if (offset >= MediaQuery.of(Get.context!).size.height * 7) {
      jumpTo(0);
    } else {
      animateTo(0,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  void jumpToTop() {
    if (!hasClients) return;
    jumpTo(0);
  }
}

extension IterableExt<T> on Iterable<T>? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

extension ListExt<T> on List<T>? {
  T? getOrNull(int index) {
    if (isNullOrEmpty) {
      return null;
    }
    if (index < 0 || index >= this!.length) {
      return null;
    }
    return this![index];
  }

  T getOrElse(int index, {required T Function() orElse}) {
    return getOrNull(index) ?? orElse();
  }
}

final _regExp = RegExp("^(http:)?//", caseSensitive: false);

extension StringExt on String? {
  String get http2https => this?.replaceFirst(_regExp, "https://") ?? '';

  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

extension BoolExt on bool {
  bool get not => !this;
}

extension BuildContextExt on BuildContext {
  Color get vipColor {
    return Theme.of(this).brightness == Brightness.light
        ? const Color(0xFFFF6699)
        : const Color(0xFFD44E7D);
  }

  void imageView({
    int? initialPage,
    required List<SourceModel> imgList,
    ValueChanged<int>? onDismissed,
  }) {
    bool isMemberPage = Get.currentRoute.startsWith('/member?');
    Navigator.of(this).push(
      HeroDialogRoute(
        builder: (context) => InteractiveviewerGallery(
          sources: imgList,
          initIndex: initialPage ?? 0,
          onPageChanged: (int pageIndex) {},
          onDismissed: onDismissed,
          setStatusBar: !isMemberPage,
        ),
      ),
    );
  }
}

extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    final ids = <Id>{};
    return (inplace ? this : List<E>.from(this))
      ..retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
  }
}

extension ColorExtension on Color {
  Color darken([double amount = .5]) {
    assert(amount >= 0 && amount <= 1, 'Amount must be between 0 and 1');
    return Color.lerp(this, Colors.black, amount)!;
  }
}

extension BrightnessExt on Brightness {
  Brightness get reverse =>
      this == Brightness.light ? Brightness.dark : Brightness.light;
}

extension RationalExt on Rational {
  /// Checks whether given [Rational] instance fits into Android requirements
  /// or not.
  ///
  /// Android docs specified boundaries as inclusive.
  bool get fitsInAndroidRequirements {
    final aspectRatio = numerator / denominator;
    const min = 1 / 2.39;
    const max = 2.39;
    return (min <= aspectRatio) && (aspectRatio <= max);
  }
}

extension ThreeDotItemTypeExt on ThreeDotItemType {
  IconData get icon => switch (this) {
        ThreeDotItemType.THREE_DOT_ITEM_TYPE_MSG_SETTING => Icons.settings,
        ThreeDotItemType.THREE_DOT_ITEM_TYPE_READ_ALL =>
          Icons.cleaning_services,
        ThreeDotItemType.THREE_DOT_ITEM_TYPE_CLEAR_LIST =>
          Icons.delete_forever_outlined,
        ThreeDotItemType.THREE_DOT_ITEM_TYPE_UP_HELPER => Icons.live_tv,
        ThreeDotItemType.THREE_DOT_ITEM_TYPE_CONTACTS =>
          Icons.account_box_outlined,
        ThreeDotItemType.THREE_DOT_ITEM_TYPE_FANS_GROUP_HELPER =>
          Icons.notifications_none,
        _ => MdiIcons.circleMedium,
      };

  void action({
    required BuildContext context,
    required CommonWhisperController controller,
  }) {
    switch (this) {
      case ThreeDotItemType.THREE_DOT_ITEM_TYPE_READ_ALL:
        showConfirmDialog(
          context: context,
          title: '一键已读',
          content: '是否清除全部新消息提醒？',
          onConfirm: controller.onClearUnread,
        );
      case ThreeDotItemType.THREE_DOT_ITEM_TYPE_CLEAR_LIST:
        showConfirmDialog(
          context: context,
          title: '清空列表',
          content: '清空后所有消息将被删除，无法恢复',
          onConfirm: controller.onDeleteList,
        );
      case ThreeDotItemType.THREE_DOT_ITEM_TYPE_MSG_SETTING:
        Get.to(const WhisperSettingsPage(
          imSettingType: IMSettingType.SETTING_TYPE_NEED_ALL,
        ));
      case ThreeDotItemType.THREE_DOT_ITEM_TYPE_UP_HELPER:
        Get.toNamed(
          '/whisperDetail',
          parameters: {
            'talkerId': '844424930131966',
            'name': 'UP主小助手',
            'face':
                'https://message.biliimg.com/bfs/im/489a63efadfb202366c2f88853d2217b5ddc7a13.png',
          },
        );
      case ThreeDotItemType.THREE_DOT_ITEM_TYPE_CONTACTS:
        Get.to(const ContactPage(isFromSelct: false));
      default:
        SmartDialog.showToast(name);
    }
  }
}
