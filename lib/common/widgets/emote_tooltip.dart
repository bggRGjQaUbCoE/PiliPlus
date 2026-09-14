import 'package:PiliPlus/common/widgets/custom_tooltip.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/utils/extension/string_ext.dart';
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
    final bg = colorScheme.surface;

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

    return CustomTooltip(
      triggerMode: triggerMode,
      jumpUrl: jumpUrl,
      indicator: () => Triangle(color: bg, size: const Size(14, 8)),
      overlayWidget: () => Container(
        padding: const .all(8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: const .all(.circular(8)),
          border: const Border.fromBorderSide(BorderSide(color: borderColor)),
        ),
        child: overlay,
      ),
      child: child,
    );
  }
  return child;
}
