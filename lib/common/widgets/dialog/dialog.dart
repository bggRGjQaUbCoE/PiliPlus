import 'package:flutter/material.dart';
import 'package:PiliPlus/utils/nav.dart';

Future<bool> showConfirmDialog({
  required BuildContext context,
  required Widget title,
  Widget? content,
  // @Deprecated('use `bool result = await showConfirmDialog()` instead')
  VoidCallback? onConfirm,
}) async {
  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: title,
          content: content,
          actions: [
            TextButton(
              onPressed: () => Nav.back(),
              child: Text(
                '取消',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Nav.back(true);
                onConfirm?.call();
              },
              child: const Text('确认'),
            ),
          ],
        ),
      ) ??
      false;
}

void showPgcFollowDialog({
  required BuildContext context,
  required String type,
  required int followStatus,
  required ValueChanged<int> onUpdateStatus,
}) {
  Widget statusItem({
    required bool enabled,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      dense: true,
      enabled: enabled,
      title: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text(
          '标记为 $text',
          style: const TextStyle(fontSize: 14),
        ),
      ),
      trailing: !enabled ? const Icon(size: 22, Icons.check) : null,
      onTap: onTap,
    );
  }

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      clipBehavior: Clip.hardEdge,
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...const [
            (followStatus: 3, title: '看过'),
            (followStatus: 2, title: '在看'),
            (followStatus: 1, title: '想看'),
          ].map(
            (item) => statusItem(
              enabled: followStatus != item.followStatus,
              text: item.title,
              onTap: () {
                Nav.back();
                onUpdateStatus(item.followStatus);
              },
            ),
          ),
          ListTile(
            dense: true,
            title: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                '取消$type',
                style: const TextStyle(fontSize: 14),
              ),
            ),
            onTap: () {
              Nav.back();
              onUpdateStatus(-1);
            },
          ),
        ],
      ),
    ),
  );
}
