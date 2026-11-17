import 'dart:io' show Platform;

import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/utils/device_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:characters/characters.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/rendering.dart' show Rect;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:share_plus/share_plus.dart';

abstract final class ShareUtils {
  static bool? _isIpad;
  static Future<bool> get isIpad async {
    if (!Platform.isIOS) return false;
    return _isIpad ??= (await DeviceInfoPlugin().iosInfo).model
        .toLowerCase()
        .contains('ipad');
  }

  static Future<Rect?> get sharePositionOrigin async {
    if (await isIpad) {
      final screenSize = DeviceUtils.size;
      return Rect.fromLTRB(0, 0, screenSize.width, screenSize.height / 2);
    }
    return null;
  }

  static String dynamicText(DynamicItemModel item) {
    final url = '${HttpString.opusBaseUrl}/${item.idStr}';
    for (final entry in [item, item.orig]) {
      final module = entry?.modules.moduleDynamic;
      final major = module?.major;
      for (final value in [
        major?.opus?.title,
        entry?.modules.opusTitle,
        major?.archive?.title,
        major?.ugcSeason?.title,
        major?.pgc?.title,
        major?.courses?.title,
        major?.liveRcmd?.title,
        major?.common?.title,
        major?.music?.title,
        module?.desc?.text,
        major?.opus?.summary?.text,
        if (entry?.modules.moduleContent case final paragraphs?)
          for (final paragraph in paragraphs)
            (paragraph.text ?? paragraph.heading)?.nodes
                ?.map((node) => node.word?.words ?? '')
                .join(),
      ]) {
        if (value == null) continue;
        final summary = value.trim().replaceAll(RegExp(r'\s+'), ' ');
        if (summary.isEmpty) continue;
        final characters = summary.characters;
        final title = characters.length > 120
            ? '${characters.take(120)}…'
            : summary;
        return '$title\n$url';
      }
    }
    return url;
  }

  static Future<void> shareText(String text) async {
    if (PlatformUtils.isDesktop) {
      Utils.copyText(text);
      return;
    }
    try {
      await SharePlus.instance.share(
        ShareParams(text: text, sharePositionOrigin: await sharePositionOrigin),
      );
    } catch (e) {
      SmartDialog.showToast(e.toString());
    }
  }
}
