import 'package:PiliPlus/http/member.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

const _reason = ['头像违规', '昵称违规', '签名违规'];

const _reasonV2 = ['色情低俗', '不实信息', '违禁', '人身攻击', '赌博诈骗', '违规引流外链'];

Future<void> showMemberReportDialog(
  BuildContext context, {
  required Object? name,
  required Object mid,
}) {
  final Set<int> reason = {};
  int? reasonV2;

  return showDialog(
    context: context,
    builder: (context) {
      final theme = Theme.of(context);
      return AlertDialog(
        clipBehavior: Clip.hardEdge,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        titleTextStyle: theme.textTheme.bodyMedium,
        title: Column(
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '举报: $name',
              style: const TextStyle(fontSize: 18),
            ),
            Text('uid: $mid'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 18),
                child: Text('举报内容（必选，可多选）'),
              ),
              ...List.generate(
                3,
                (index) => Builder(
                  builder: (context) {
                    final checked = reason.contains(index + 1);
                    return ListTile(
                      dense: true,
                      minTileHeight: 40,
                      onTap: () {
                        if (!checked) {
                          reason.add(index + 1);
                        } else {
                          reason.remove(index + 1);
                        }
                        (context as Element).markNeedsBuild();
                      },
                      title: Row(
                        spacing: 8,
                        children: [
                          checked
                              ? Icon(
                                  size: 22,
                                  Icons.check_box,
                                  color: theme.colorScheme.primary,
                                )
                              : Icon(
                                  size: 22,
                                  Icons.check_box_outline_blank,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                          Expanded(
                            child: Text(
                              _reason[index],
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 18),
                child: Text('举报理由（单选，非必选）'),
              ),
              Builder(
                builder: (context) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    _reasonV2.length,
                    (index) {
                      final checked = index == reasonV2;
                      return ListTile(
                        dense: true,
                        minTileHeight: 40,
                        onTap: () {
                          if (checked) {
                            reasonV2 = null;
                          } else {
                            reasonV2 = index;
                          }
                          (context as Element).markNeedsBuild();
                        },
                        title: Row(
                          spacing: 8,
                          children: [
                            checked
                                ? Icon(
                                    size: 22,
                                    Icons.radio_button_checked,
                                    color: theme.colorScheme.primary,
                                  )
                                : Icon(
                                    size: 22,
                                    Icons.radio_button_off,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                            Expanded(
                              child: Text(
                                _reasonV2[index],
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text(
              '取消',
              style: TextStyle(color: theme.colorScheme.outline),
            ),
          ),
          TextButton(
            onPressed: () async {
              if (reason.isEmpty) {
                SmartDialog.showToast('至少选择一项作为举报内容');
              } else {
                Get.back();
                var result = await MemberHttp.reportMember(
                  mid,
                  reason: reason.join(','),
                  reasonV2: reasonV2 != null ? reasonV2! + 1 : null,
                );
                if (result['msg'] is String && result['msg'].isNotEmpty) {
                  SmartDialog.showToast(result['msg']);
                } else {
                  SmartDialog.showToast('举报失败');
                }
              }
            },
            child: const Text('确定'),
          ),
        ],
      );
    },
  );
}
