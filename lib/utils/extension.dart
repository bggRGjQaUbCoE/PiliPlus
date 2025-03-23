import 'package:PiliPlus/common/widgets/interactiveviewer_gallery/hero_dialog_route.dart';
import 'package:PiliPlus/common/widgets/interactiveviewer_gallery/interactiveviewer_gallery.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension ImageExtension on num {
  int cacheSize(BuildContext context) {
    return (this * MediaQuery.of(context).devicePixelRatio).round();
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

  bool eq(List<T>? other) {
    if (this == null) {
      return other == null;
    }
    if (other == null || this!.length != other.length) {
      return false;
    }
    for (int index = 0; index < this!.length; index += 1) {
      if (this![index] != other[index]) {
        return false;
      }
    }
    return true;
  }

  bool ne(List<T>? other) => !eq(other);
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
    Navigator.of(this).push(
      HeroDialogRoute(
        builder: (context) => InteractiveviewerGallery(
          sources: imgList,
          initIndex: initialPage ?? 0,
          onPageChanged: (int pageIndex) {},
          onDismissed: onDismissed,
        ),
      ),
    );
  }
}

extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    final ids = <dynamic>{};
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }
}

extension ColorExtension on Color {
  Color darken([double amount = .5]) {
    assert(amount >= 0 && amount <= 1, 'Amount must be between 0 and 1');
    return Color.lerp(this, Colors.black, amount)!;
  }

  Color blend(Color color, [double fraction = 0.5]) {
    assert(fraction >= 0 && fraction <= 1, 'Fraction must be between 0 and 1');
    final blendedRed = (red * (1 - fraction) + color.red * fraction).toInt();
    final blendedGreen =
        (green * (1 - fraction) + color.green * fraction).toInt();
    final blendedBlue = (blue * (1 - fraction) + color.blue * fraction).toInt();
    final blendedAlpha =
        (alpha * (1 - fraction) + color.alpha * fraction).toInt();
    return Color.fromARGB(blendedAlpha, blendedRed, blendedGreen, blendedBlue);
  }
}

extension BrightnessExt on Brightness {
  Brightness get reverse =>
      this == Brightness.light ? Brightness.dark : Brightness.light;
}
