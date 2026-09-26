import 'package:PiliPlus/common/widgets/custom_tooltip.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/utils/extension/string_ext.dart';
import 'package:PiliPlus/utils/extension/theme_ext.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:material_ui/material_ui.dart';

bool enableEmoteTooltip = Pref.enableEmoteTooltip;

final TriggerMode_ kTriggerMode = PlatformUtils.isDesktop ? .mouse : .longPress;

Widget emoteTooltipBuilder({
  bool? enable,
  double size = 80.0,
  required TriggerMode_ triggerMode,
  required String? url,
  required String? emote,
  String? jumpUrl,
  required ColorScheme colorScheme,
  required Widget child,
}) {
  if (enable ?? enableEmoteTooltip) {
    return CustomTooltip(
      color: colorScheme.isDark
          ? colorScheme.surfaceContainerHigh
          : colorScheme.surface,
      shadow: Colors.black,
      triggerMode: triggerMode,
      jumpUrl: jumpUrl,
      overlayWidget: () {
        Widget overlay = NetworkImgLayer(
          src: url,
          type: .emote,
          width: size,
          height: size,
          fit: .contain,
        );
        if (emote != null) {
          overlay = Column(
            spacing: 8,
            mainAxisSize: .min,
            children: [
              overlay,
              Text.rich(
                TextSpan(
                  text: emote.emote,
                  children: jumpUrl != null && jumpUrl.isNotEmpty
                      ? [
                          WidgetSpan(
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              size: 14,
                              color: colorScheme.outline,
                            ),
                          ),
                        ]
                      : null,
                ),
                style: const TextStyle(fontSize: 12, height: 1),
              ),
            ],
          );
        }
        return Padding(padding: const .all(8.0), child: overlay);
      },
      child: child,
    );
  }
  return child;
}
