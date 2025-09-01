import 'package:PiliPlus/http/member.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

Future<void> showMemberReportDialog(
  BuildContext context, {
  required Object? name,
  required Object mid,
}) {
  final List<bool> reasonList = List.generate(3, (_) => false);
  final Set<int> reason = {};
  int? reasonV2;

  return showDialog(
    context: context,
    builder: (context) {
      final theme = Theme.of(context);
      return AlertDialog(
        clipBehavior: Clip.hardEdge,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        titleTextStyle: theme.textTheme.bodyMedium,
        title: Column(
          spacing: 4,
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
              const Text('举报内容（必选，可多选）'),
              ...List.generate(
                3,
                (index) => Builder(
                  builder: (context) => CheckboxListTile(
                    dense: true,
                    value: reasonList[index],
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (value) {
                      reasonList[index] = value!;
                      if (value) {
                        reason.add(index + 1);
                      } else {
                        reason.remove(index + 1);
                      }
                      (context as Element).markNeedsBuild();
                    },
                    title: Text(const ['头像违规', '昵称违规', '签名违规'][index]),
                  ),
                ),
              ),
              const Text('举报理由（单选，非必选）'),
              Builder(
                builder: (context) => RadioGroup<int>(
                  onChanged: (v) {
                    reasonV2 = v;
                    (context as Element).markNeedsBuild();
                  },
                  groupValue: reasonV2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      5,
                      (index) => RadioListTile<int>(
                        toggleable: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: const EdgeInsets.only(left: 4),
                        dense: true,
                        value: index,
                        title: Text(
                          const ['色情低俗', '不实信息', '违禁', '人身攻击', '赌博诈骗'][index],
                        ),
                      ),
                    ),
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
