import 'package:PiliPlus/common/widgets/radio_widget.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

void autoWrapReportDialog(
  BuildContext context,
  Map<String, Map<int, String>> options,
  Future<Map> Function(int, String?, bool) onSuccess,
) {
  int? reasonType;
  String? reasonDesc;
  bool banUid = false;
  late final key = GlobalKey<FormState>();
  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: const Text('举报'),
          titlePadding: const EdgeInsets.only(left: 22, top: 16, right: 22),
          contentPadding: const EdgeInsets.symmetric(vertical: 5),
          actionsPadding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 10),
          content: Form(
            key: key,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(
                              left: 22,
                              right: 22,
                              bottom: 5,
                            ),
                            child: Text('请选择举报的理由：'),
                          ),
                          ...options.entries.map(
                            (entry) => WrapRadioOptionsGroup<int>(
                              groupTitle: entry.key,
                              options: entry.value,
                              selectedValue: reasonType,
                              onChanged: (value) =>
                                  setState(() => reasonType = value),
                            ),
                          ),
                          if (reasonType == 0)
                            ReasonField(
                                onChanged: (value) => reasonDesc = value),
                        ],
                      ),
                    ),
                  ),
                ),
                BanUserCheckbox(onChanged: (value) => banUid = value),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: Get.back,
              child: Text(
                '取消',
                style: TextStyle(color: Theme.of(context).colorScheme.outline),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (reasonType == null ||
                    (reasonType == 0 && key.currentState?.validate() != true)) {
                  return;
                }
                SmartDialog.showLoading();
                try {
                  final data = await onSuccess(reasonType!, reasonDesc, banUid);
                  SmartDialog.dismiss();
                  if (data['code'] == 0) {
                    Get.back();
                    SmartDialog.showToast('举报成功');
                  } else {
                    SmartDialog.showToast(data['message']);
                  }
                } catch (e) {
                  SmartDialog.dismiss();
                  SmartDialog.showToast('提交失败：$e');
                }
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    ),
  );
}

class ReasonField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  String? _validator(String? value) => value.isNullOrEmpty ? '理由不能为空' : null;

  const ReasonField({super.key, required this.onChanged});

  @override
  State<ReasonField> createState() => _ReasonFieldState();
}

class _ReasonFieldState extends State<ReasonField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 22, top: 5, right: 22),
      child: TextFormField(
        controller: _controller,
        autofocus: true,
        minLines: 4,
        maxLines: 4,
        decoration: const InputDecoration(
          labelText: '为帮助审核人员更快处理，请补充问题类型和出现位置等详细信息',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.all(10),
        ),
        onChanged: (value) {
          widget.onChanged(value);
        },
        validator: widget._validator,
      ),
    );
  }
}

class BanUserCheckbox extends StatefulWidget {
  final ValueChanged<bool> onChanged;

  const BanUserCheckbox({super.key, required this.onChanged});

  @override
  State<BanUserCheckbox> createState() => _BanUserCheckboxState();
}

class _BanUserCheckboxState extends State<BanUserCheckbox> {
  bool _banUid = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => _banUid = !_banUid);
        widget.onChanged(_banUid);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 18, top: 10),
        child: Row(
          children: [
            Icon(
              size: 22,
              _banUid
                  ? Icons.check_box_outlined
                  : Icons.check_box_outline_blank,
              color: _banUid
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            Text(
              ' 拉黑该用户',
              style: TextStyle(
                color: _banUid ? Theme.of(context).colorScheme.primary : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportOptions {
  // from https://s1.hdslb.com/bfs/seed/jinkela/comment-h5/static/js/605.chunks.js
  static Map<String, Map<int, String>> get commentReport => {
        '违反法律法规': {9: '违法违规', 2: '色情', 10: '低俗', 12: '赌博诈骗', 23: '违法信息外链'},
        '谣言类不实信息': {19: '涉政谣言', 22: '虚假不实信息', 20: '涉社会事件谣言'},
        '侵犯个人权益': {7: '人身攻击', 15: '侵犯隐私'},
        '有害社区环境': {
          1: '垃圾广告',
          4: '引战',
          5: '剧透',
          3: '刷屏',
          8: '视频不相关',
          18: '违规抽奖',
          17: '青少年不良信息',
        },
        '其他': {0: '其他'},
      };

  static Map<String, Map<int, String>> get dynamicReport => {
        '': {
          4: '垃圾广告',
          8: '引战',
          1: '色情',
          5: '人身攻击',
          3: '违法信息',
          9: '涉政谣言',
          10: '涉社会事件谣言',
          12: '虚假不实信息',
          13: '违法信息外链',
          0: '其他',
        },
      };
}
