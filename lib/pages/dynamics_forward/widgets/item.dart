import 'package:PiliPlus/common/widgets/flutter/list_tile.dart';
import 'package:PiliPlus/common/widgets/gesture/tap_gesture_recognizer.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/pendant_avatar.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_forward/item.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart' hide ListTile;

class DynForwardItemWidget extends StatelessWidget {
  const DynForwardItemWidget({
    super.key,
    required this.item,
  });

  final DynForwardItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = item.user;
    final mid = user?.mid;
    final openUser = mid == null ? null : () => Get.toNamed('/member?mid=$mid');
    final dynamicId = item.idStr;
    final openDynamic = dynamicId?.isNotEmpty == true
        ? () => PageUtils.pushDynFromId(id: dynamicId)
        : null;
    final pubTime = item.pubTime?.isNotEmpty == true
        ? item.pubTime
        : user?.pubTime;

    Widget userName = Text(
      user?.name ?? '未知用户',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: theme.colorScheme.primary,
        fontSize: 14,
      ),
    );
    if (openUser != null) {
      userName = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: openUser,
        child: userName,
      );
    }

    final description = _buildDescription(theme);
    return ListTile(
      dense: true,
      safeArea: false,
      visualDensity: .standard,
      titleAlignment: .top,
      onTap: openDynamic,
      leading: PendantAvatar(
        user?.face,
        size: 36,
        badgeSize: 14,
        vipStatus: user?.vip?.status,
        officialType: user?.officialVerify?.type,
        pendantImage: user?.pendant?.image,
        onTap: openUser,
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: userName),
          if (pubTime?.isNotEmpty == true) ...[
            const SizedBox(width: 8),
            Text(
              pubTime!,
              style: TextStyle(
                color: theme.colorScheme.outline,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
      subtitle: description == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(top: 4),
              child: description,
            ),
    );
  }

  Widget? _buildDescription(ThemeData theme) {
    final desc = item.desc;
    final nodes = desc?.richTextNodes;
    if (nodes == null || nodes.isEmpty) {
      final text = desc?.text;
      return text?.isNotEmpty == true
          ? Text(
              text!,
              style: TextStyle(
                fontSize: 15,
                height: 1.55,
                color: theme.colorScheme.onSurface,
              ),
            )
          : null;
    }

    final spans = <InlineSpan>[];
    for (final node in nodes) {
      final text = node.origText ?? node.text ?? '';
      switch (node.type) {
        case 'RICH_TEXT_NODE_TYPE_EMOJI':
          final emoji = node.emoji;
          final url = emoji?.url;
          if (url?.isNotEmpty == true) {
            spans.add(
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                rawText: text,
                child: NetworkImgLayer(
                  src: url,
                  type: .emote,
                  width: 20,
                  height: 20,
                ),
              ),
            );
          } else if (text.isNotEmpty) {
            spans.add(TextSpan(text: text));
          }
          break;
        case 'RICH_TEXT_NODE_TYPE_AT':
          spans.add(
            TextSpan(
              text: text,
              style: TextStyle(color: theme.colorScheme.primary),
              recognizer: node.rid?.isNotEmpty == true
                  ? (NoDeadlineTapGestureRecognizer()
                      ..onTap = () => Get.toNamed('/member?mid=${node.rid}'))
                  : null,
            ),
          );
          break;
        case 'RICH_TEXT_NODE_TYPE_TOPIC':
          final canOpenTopic =
              text.length > 2 && text.startsWith('#') && text.endsWith('#');
          spans.add(
            TextSpan(
              text: text,
              style: TextStyle(color: theme.colorScheme.primary),
              recognizer: canOpenTopic
                  ? (NoDeadlineTapGestureRecognizer()
                      ..onTap = () => Get.toNamed(
                        '/searchResult',
                        parameters: {
                          'keyword': text.substring(1, text.length - 1),
                        },
                      ))
                  : null,
            ),
          );
          break;
        case 'RICH_TEXT_NODE_TYPE_WEB':
          spans.add(
            TextSpan(
              text: node.text ?? text,
              style: TextStyle(color: theme.colorScheme.primary),
              recognizer: node.jumpUrl?.isNotEmpty == true
                  ? (NoDeadlineTapGestureRecognizer()
                      ..onTap = () => PageUtils.handleWebview(node.jumpUrl!))
                  : null,
            ),
          );
          break;
        default:
          spans.add(
            TextSpan(
              text: node.text ?? text,
              style: node.jumpUrl?.isNotEmpty == true
                  ? TextStyle(color: theme.colorScheme.primary)
                  : null,
              recognizer: node.jumpUrl?.isNotEmpty == true
                  ? (NoDeadlineTapGestureRecognizer()
                      ..onTap = () => PageUtils.handleWebview(node.jumpUrl!))
                  : null,
            ),
          );
      }
    }

    if (spans.isEmpty) return null;

    return Text.rich(
      TextSpan(children: spans),
      style: TextStyle(
        fontSize: 15,
        height: 1.55,
        color: theme.colorScheme.onSurface,
      ),
      maxLines: 8,
      overflow: TextOverflow.ellipsis,
    );
  }
}
