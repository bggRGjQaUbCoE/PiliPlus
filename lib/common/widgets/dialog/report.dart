import 'package:PiliPlus/common/widgets/button/icon_button.dart';
import 'package:PiliPlus/common/widgets/radio_widget.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/utils/extension/string_ext.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:material_ui/material_ui.dart';

typedef ReasonCheck = bool Function(int? reasonType);

bool _kReportCheck(int? reasonType) => reasonType == 0;

typedef OnReport = Future<LoadingState> Function(
  int reasonType,
  String? reasonDesc,
  bool banUid,
);

Future<void> autoWrapReportDialog(
  BuildContext context,
  Map<String, Map<int, String>> options,
  OnReport onReport, {
  bool ban = true,
  String? reportUrl,
  ReasonCheck withContent = _kReportCheck,
  ReasonCheck contentRequired = _kReportCheck,
}) {
  int? reasonType;
  String? reasonDesc;
  bool banUid = false;
  late final key = GlobalKey<FormFieldState<String>>();

  bool isWithContent = withContent(reasonType);
  bool isContentRequired = contentRequired(reasonType);

  void updateReasonType(int? value) {
    reasonType = value;
    isWithContent = withContent(reasonType);
    isContentRequired = contentRequired(reasonType);
    if (isWithContent) {
      key.currentState?.clearError();
    }
  }

  Widget title = Text(L10n.current.report);
  if (reportUrl != null) {
    title = Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        title,
        iconButton(
          iconSize: 21,
          tooltip:
              L10n.current.commonWidgetsDialogReportAutoWrapReportDialogTooltip,
          onPressed: () =>
              Get.toNamed('/webview', parameters: {'url': reportUrl}),
          icon: const Icon(MdiIcons.web, size: 22),
        ),
      ],
    );
  }

  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: title,
      titlePadding: const .only(left: 22, top: 16, right: 22),
      contentPadding: const .symmetric(vertical: 5),
      actionsPadding: const .only(left: 16, right: 16, bottom: 10),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: AnimatedSize(
                duration: const Duration(milliseconds: 200),
                child: Builder(
                  builder: (context) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const .only(left: 22, right: 22, bottom: 5),
                        child: Text(
                          L10n
                              .current
                              .commonWidgetsDialogReportAutoWrapReportDialogChild,
                        ),
                      ),
                      RadioGroup(
                        onChanged: (value) {
                          updateReasonType(value);
                          (context as Element).markNeedsBuild();
                        },
                        groupValue: reasonType,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: options.entries.map((entry) {
                            return WrapRadioOptionsGroup<int>(
                              groupTitle: entry.key,
                              options: entry.value,
                            );
                          }).toList(),
                        ),
                      ),
                      if (isWithContent)
                        Padding(
                          padding: const .only(left: 22, top: 5, right: 22),
                          child: TextFormField(
                            key: key,
                            minLines: 2,
                            maxLines: 4,
                            initialValue: reasonDesc,
                            autofocus: isContentRequired,
                            decoration: InputDecoration(
                              labelText: L10n
                                  .current
                                  .commonWidgetsDialogReportAutoWrapReportDialogLabelText,
                              border: const OutlineInputBorder(),
                              contentPadding: const .all(10),
                              labelStyle: const TextStyle(fontSize: 14),
                              floatingLabelStyle: const TextStyle(fontSize: 14),
                            ),
                            onChanged: (value) => reasonDesc = value,
                            validator: (value) =>
                                isContentRequired && value.isNullOrEmpty
                                ? L10n
                                      .current
                                      .commonWidgetsDialogReportAutoWrapReportDialogValidator
                                : null,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (ban)
            Padding(
              padding: const EdgeInsets.only(left: 14, top: 6),
              child: CheckBoxText(
                text: L10n
                    .current
                    .commonWidgetsDialogReportAutoWrapReportDialogText,
                onChanged: (value) => banUid = value,
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: Get.back,
          child: Text(
            L10n.current.cancel,
            style: TextStyle(color: ColorScheme.of(context).outline),
          ),
        ),
        TextButton(
          onPressed: () async {
            if (reasonType == null ||
                (isContentRequired && key.currentState?.validate() != true)) {
              return;
            }
            SmartDialog.showLoading();
            try {
              final res = await onReport(
                reasonType!,
                isWithContent ? reasonDesc : null,
                banUid,
              );
              SmartDialog.dismiss();
              if (res.isSuccess) {
                Get.back();
                SmartDialog.showToast(
                  L10n
                      .current
                      .commonWidgetsDialogReportAutoWrapReportDialogOnPressed,
                );
              } else {
                res.toast();
              }
            } catch (e, s) {
              SmartDialog.dismiss();
              SmartDialog.showToast('提交失败：$e');
              Utils.reportError(e, s);
            }
          },
          child: Text(L10n.current.ok),
        ),
      ],
    ),
  );
}

class CheckBoxText extends StatefulWidget {
  final String text;
  final ValueChanged<bool> onChanged;
  final bool selected;

  const CheckBoxText({
    super.key,
    required this.text,
    required this.onChanged,
    this.selected = false,
  });

  @override
  State<CheckBoxText> createState() => _CheckBoxTextState();
}

class _CheckBoxTextState extends State<CheckBoxText> {
  late bool _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    return InkWell(
      onTap: () {
        setState(() {
          _selected = !_selected;
          widget.onChanged(_selected);
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              size: 22,
              _selected
                  ? Icons.check_box_outlined
                  : Icons.check_box_outline_blank,
              color: _selected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
            Text(
              ' ${widget.text}',
              style: TextStyle(color: _selected ? colorScheme.primary : null),
            ),
          ],
        ),
      ),
    );
  }
}

abstract final class ReportOptions {
  // from https://s1.hdslb.com/bfs/seed/jinkela/comment-h5/static/js/605.chunks.js
  static Map<String, Map<int, String>> get commentReport => {
    L10n.current.reportOptionsCommentReportText16: {
      9: L10n.current.reportOptionsCommentReportText8,
      2: L10n.current.reportOptionsCommentReportText,
      10: L10n.current.reportOptionsCommentReportText2,
      12: L10n.current.reportOptionsCommentReportText9,
      23: L10n.current.reportOptionsCommentReportText17,
    },
    L10n.current.reportOptionsCommentReportText20: {
      19: L10n.current.reportOptionsCommentReportText10,
      22: L10n.current.reportOptionsCommentReportText21,
      20: L10n.current.reportOptionsCommentReportText22,
    },
    L10n.current.reportOptionsCommentReportText18: {
      7: L10n.current.reportOptionsCommentReportText11,
      15: L10n.current.reportOptionsCommentReportText12,
    },
    L10n.current.reportOptionsCommentReportText19: {
      1: L10n.current.reportOptionsCommentReportText13,
      4: L10n.current.reportOptionsCommentReportText3,
      5: L10n.current.reportOptionsCommentReportText4,
      3: L10n.current.reportOptionsCommentReportText5,
      8: L10n.current.reportOptionsCommentReportText15,
      18: L10n.current.reportOptionsCommentReportText14,
      17: L10n.current.reportOptionsCommentReportText23,
    },
    L10n.current.reportOptionsCommentReportText6: {
      0: L10n.current.reportOptionsCommentReportText7,
    },
  };
  static bool withContentReply(int? reasonType) => reasonType != null;
  static bool contentRequiredReply(int? reasonType) =>
      reasonType == 0 || reasonType == 22;

  static Map<String, Map<int, String>> get dynamicReport => {
    '': {
      4: L10n.current.reportOptionsCommentReportText13,
      8: L10n.current.reportOptionsCommentReportText3,
      1: L10n.current.reportOptionsCommentReportText,
      5: L10n.current.reportOptionsCommentReportText11,
      3: L10n.current.reportOptionsDynamicReportText,
      9: L10n.current.reportOptionsCommentReportText10,
      10: L10n.current.reportOptionsCommentReportText22,
      12: L10n.current.reportOptionsDynamicReportText2,
      13: L10n.current.reportOptionsCommentReportText17,
      0: L10n.current.reportOptionsCommentReportText7,
    },
  };

  static Map<String, Map<int, String>> get danmakuReport => {
    '': {
      1: L10n.current.reportOptionsDanmakuReportText2,
      2: L10n.current.reportOptionsDanmakuReportText3,
      3: L10n.current.reportOptionsCommentReportText9,
      4: L10n.current.reportOptionsCommentReportText11,
      5: L10n.current.reportOptionsCommentReportText12,
      6: L10n.current.reportOptionsCommentReportText13,
      7: L10n.current.reportOptionsCommentReportText3,
      8: L10n.current.reportOptionsCommentReportText4,
      9: L10n.current.reportOptionsDanmakuReportText4,
      10: L10n.current.reportOptionsDanmakuReportText5,
      12: L10n.current.reportOptionsCommentReportText23,
      13: L10n.current.reportOptionsCommentReportText17,
      11: L10n.current.reportOptionsDanmakuReportText,
    },
  };
  static bool danmakuReportCheck(int? reasonType) => reasonType == 11;

  static Map<String, Map<int, String>> get liveDanmakuReport => {
    '': {
      1: L10n.current.reportOptionsCommentReportText8,
      2: L10n.current.reportOptionsLiveDanmakuReportText,
      3: L10n.current.reportOptionsCommentReportText13,
      4: L10n.current.reportOptionsLiveDanmakuReportText2,
      5: L10n.current.reportOptionsLiveDanmakuReportText3,
      6: L10n.current.reportOptionsCommentReportText23,
      0: L10n.current.reportOptionsCommentReportText6,
    },
  };
  static bool liveDanmakuReportCheck(int? _) => false;

  static Map<String, Map<int, String>> get imMsgReport => {
    '': {
      1: L10n.current.reportOptionsDanmakuReportText3,
      2: L10n.current.reportOptionsLiveDanmakuReportText3,
      3: L10n.current.reportOptionsImMsgReportText2,
      4: L10n.current.reportOptionsImMsgReportText3,
      5: L10n.current.reportOptionsCommentReportText11,
      6: L10n.current.reportOptionsImMsgReportText,
      0: L10n.current.reportOptionsImMsgReportText4,
    },
  };
}
