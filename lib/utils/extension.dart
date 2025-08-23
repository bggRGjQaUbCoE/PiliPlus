import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/grpc/bilibili/app/im/v1.pbenum.dart'
    show IMSettingType, ThreeDotItemType;
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
    return (this! * MediaQuery.devicePixelRatioOf(context)).round();
  }
}

extension IntExt on int? {
  int? operator +(int other) => this == null ? null : this! + other;
  int? operator -(int other) => this == null ? null : this! - other;
}

extension ScrollControllerExt on ScrollController {
  void animToTop() {
    if (!hasClients) return;
    if (offset >= Get.mediaQuery.size.height * 7) {
      jumpTo(0);
    } else {
      animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
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

extension MapExt<K, V> on Map<K, V> {
  Map<RK, RV> fromCast<RK, RV>() {
    return Map<RK, RV>.from(this);
  }
}

extension NonNullListExt<T> on List<T> {
  List<R> fromCast<R>() {
    return List<R>.from(this);
  }
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

  bool removeFirstWhere(bool Function(T) test) {
    if (this == null) return false;
    final index = this!.indexWhere(test);
    if (index != -1) {
      this!.removeAt(index);
      return true;
    }
    return false;
  }
}

final _regExp = RegExp("^(http:)?//", caseSensitive: false);

extension StringExt on String? {
  String get http2https => this?.replaceFirst(_regExp, "https://") ?? '';

  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

extension ColorSchemeExt on ColorScheme {
  Color get vipColor =>
      brightness.isLight ? const Color(0xFFFF6699) : const Color(0xFFD44E7D);

  Color get freeColor =>
      brightness.isLight ? const Color(0xFFFF7F24) : const Color(0xFFD66011);
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
  Brightness get reverse => isLight ? Brightness.dark : Brightness.light;

  bool get isLight => this == Brightness.light;

  bool get isDark => this == Brightness.dark;
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
  Icon get icon => switch (this) {
    ThreeDotItemType.THREE_DOT_ITEM_TYPE_MSG_SETTING => const Icon(
      Icons.settings,
      size: 20,
    ),
    ThreeDotItemType.THREE_DOT_ITEM_TYPE_READ_ALL => const Icon(
      Icons.cleaning_services,
      size: 20,
    ),
    ThreeDotItemType.THREE_DOT_ITEM_TYPE_CLEAR_LIST => const Icon(
      Icons.delete_forever_outlined,
      size: 20,
    ),
    ThreeDotItemType.THREE_DOT_ITEM_TYPE_UP_HELPER => const Icon(
      Icons.live_tv,
      size: 20,
    ),
    ThreeDotItemType.THREE_DOT_ITEM_TYPE_CONTACTS => const Icon(
      Icons.account_box_outlined,
      size: 20,
    ),
    ThreeDotItemType.THREE_DOT_ITEM_TYPE_FANS_GROUP_HELPER => const Icon(
      Icons.notifications_none,
      size: 20,
    ),
    _ => const Icon(MdiIcons.circleMedium, size: 20),
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
        Get.to(
          const WhisperSettingsPage(
            imSettingType: IMSettingType.SETTING_TYPE_NEED_ALL,
          ),
        );
      case ThreeDotItemType.THREE_DOT_ITEM_TYPE_UP_HELPER:
        Get.toNamed(
          '/whisperDetail',
          arguments: {
            'talkerId': 844424930131966,
            'name': 'UP主小助手',
            'face':
                'https://message.biliimg.com/bfs/im/489a63efadfb202366c2f88853d2217b5ddc7a13.png',
          },
        );
      case ThreeDotItemType.THREE_DOT_ITEM_TYPE_CONTACTS:
        Get.to(const ContactPage(isFromSelect: false));
      default:
        SmartDialog.showToast('TODO: $name');
    }
  }
}
