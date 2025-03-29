import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showConfirmDialog({
  required BuildContext context,
  required String title,
  String? content,
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: content == null ? null : Text(content),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text(
              '取消',
              style: TextStyle(color: Theme.of(context).colorScheme.outline),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              onConfirm();
            },
            child: Text('确认'),
          ),
        ],
      );
    },
  );
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
                ...[
                  {'followStatus': 3, 'title': '看过'},
                  {'followStatus': 2, 'title': '在看'},
                  {'followStatus': 1, 'title': '想看'},
                ].map(
                  (Map item) => statusItem(
                    enabled: followStatus != item['followStatus'],
                    text: item['title'],
                    onTap: () {
                      Get.back();
                      onUpdateStatus(item['followStatus']);
                    },
                  ),
                ),
                ListTile(
                  dense: true,
                  title: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      '取消$type',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  onTap: () {
                    Get.back();
                    onUpdateStatus(-1);
                  },
                )
              ],
            ),
          ));
}
