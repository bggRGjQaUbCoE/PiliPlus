import 'dart:io' show Platform;

import 'package:PiliPlus/common/widgets/selection_text.dart';
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo;
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/reply.dart';
import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/models/common/reply/reply_sort_type.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/android/android_helper.dart';
import 'package:PiliPlus/utils/extension/iterable_ext.dart';
import 'package:PiliPlus/utils/extension/theme_ext.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/theme_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

abstract final class ReplyUtils {
  static void onCheckReply({
    required ReplyInfo replyInfo,
    required bool biliSendCommAntifraud,
    required sourceId,
    required bool isManual,
  }) {
    try {
      _checkReply(
        oid: replyInfo.oid.toInt(),
        type: replyInfo.type.toInt(),
        id: replyInfo.id.toInt(),
        message: replyInfo.content.message,
        //
        root: replyInfo.root.toInt(),
        parent: replyInfo.parent.toInt(),
        ctime: replyInfo.ctime.toInt(),
        pictures: replyInfo.content.pictures
            .map((item) => item.toProto3Json())
            .toList(),
        mid: replyInfo.mid.toInt(),
        //
        isManual: isManual,
        biliSendCommAntifraud: biliSendCommAntifraud,
        sourceId: sourceId,
      );
    } catch (e) {
      SmartDialog.showToast(e.toString());
    }
  }

  // ref https://github.com/freedom-introvert/biliSendCommAntifraud
  static Future<void> _checkReply({
    required int oid,
    required int type,
    required int id,
    required String message,
    required int root,
    required int parent,
    required int ctime,
    required List pictures,
    required int mid,
    bool isManual = false,
    required bool biliSendCommAntifraud,
    required sourceId,
  }) async {
    // biliSendCommAntifraud
    if (Platform.isAndroid && biliSendCommAntifraud) {
      try {
        final cookieString = Accounts.main.cookieJar
            .toJson()
            .entries
            .map((i) => '${i.key}=${i.value}')
            .join(';');
        PiliAndroidHelper.biliSendCommAntifraud(
          0,
          oid,
          type,
          id,
          root,
          parent,
          ctime,
          message,
          pictures,
          sourceId,
          mid,
          cookieString,
        );
      } catch (e) {
        if (kDebugMode) debugPrint('biliSendCommAntifraud: $e');
      }
      return;
    }

    // CommAntifraud
    if (!isManual) {
      await Future.pause(const Duration(seconds: 8));
    }
    void showReplyCheckResult(String message, {bool isBan = false}) {
      showDialog(
        context: Get.context!,
        barrierDismissible: isManual,
        builder: (context) {
          final colorScheme = ColorScheme.of(context);
          final color = isBan ? colorScheme.error : colorScheme.primary;
          final actions = [
            if (isBan)
              TextButton(
                onPressed: () {
                  Get.back();
                  String? uri;
                  switch (type) {
                    case 1:
                      uri = IdUtils.av2bv(oid);
                    case 17:
                      uri = 'https://www.bilibili.com/opus/$oid';
                  }
                  if (uri != null) {
                    Utils.copyText(uri);
                  }
                  Get.toNamed(
                    '/webview',
                    parameters: {
                      'url':
                          'https://www.bilibili.com/h5/comment/appeal?${ThemeUtils.themeUrl(colorScheme.isDark)}',
                    },
                  );
                },
                child: Text(L10n.current.actionsShowReplyCheckResultChild),
              ),
            if (!isManual)
              TextButton(
                onPressed: Get.back,
                child: Text(
                  L10n.current.close,
                  style: TextStyle(color: colorScheme.outline),
                ),
              ),
          ];
          return AlertDialog(
            title: Text.rich(
              TextSpan(
                children: [
                  WidgetSpan(
                    alignment: .middle,
                    child: isBan
                        ? Icon(
                            size: 22,
                            color: color,
                            Icons.highlight_off_outlined,
                          )
                        : Icon(
                            size: 22,
                            color: color,
                            Icons.check_circle_outline_rounded,
                          ),
                  ),
                  TextSpan(
                    text: L10n.current.replyUtilsShowReplyCheckResultText,
                    style: TextStyle(color: color),
                  ),
                ],
              ),
            ),
            content: SelectionText(message),
            actions: actions.isEmpty ? null : actions,
          );
        },
      );
    }

    // root reply
    if (root == 0) {
      // no cookie check
      final res = await ReplyHttp.replyList(
        isLogin: false,
        oid: oid,
        nextOffset: '',
        type: type,
        sort: ReplySortType.time.index,
        page: 1,
      );

      if (res case Error(:final errMsg)) {
        SmartDialog.showToast('获取评论主列表时发生错误：$errMsg');
        return;
      } else if (res case Success(:final response)) {
        final index =
            response.replies?.indexWhere((item) => item.rpid == id) ?? -1;
        if (index != -1) {
          // found
          showReplyCheckResult(
            L10n.current.replyUtilsCheckReplyText4(message),
          );
        } else {
          // not found

          // cookie check
          final res1 = await ReplyHttp.replyReplyList(
            isLogin: true,
            oid: oid,
            root: id,
            pageNum: 1,
            type: type,
          );

          if (res1 is Error) {
            // not found
            showReplyCheckResult(
              L10n.current.replyUtilsCheckReplyText2(message),
              isBan: true,
            );
          } else {
            // found

            // no cookie check
            final res2 = await ReplyHttp.replyReplyList(
              isLogin: false,
              oid: oid,
              root: id,
              pageNum: 1,
              type: type,
              isCheck: true,
            );

            if (res2 is Error) {
              // not found
              showReplyCheckResult(
                res2.errMsg?.startsWith('12022') == true
                    ? L10n.current.replyUtilsCheckReplyText5(
                        message,
                      )
                    : L10n.current.replyUtilsCheckReplyText3(
                        res2.errMsg.toString(),
                        message,
                      ),
                isBan: true,
              );
            } else {
              // found
              showReplyCheckResult(
                isManual
                    ? L10n.current.replyUtilsCheckReplyText4(
                        message,
                      )
                    : L10n.current.replyUtilsCheckReplyText6(
                        oid,
                        id,
                        type,
                        message,
                      ),
              );
            }
          }
        }
      }
    } else {
      for (int i = 1; ; i++) {
        final res3 = await ReplyHttp.replyReplyList(
          isLogin: false,
          oid: oid,
          root: root,
          pageNum: i,
          type: type,
          isCheck: true,
        );
        if (res3 is Error) {
          break;
        } else {
          final data = res3.data;
          if (data.replies.isNullOrEmpty) {
            break;
          }
          int index = data.replies!.indexWhere((item) => item.rpid == id);
          if (index == -1) {
            // not found
          } else {
            // found
            showReplyCheckResult(
              L10n.current.replyUtilsCheckReplyText4(message),
            );
            return;
          }
        }
      }

      for (int i = 1; ; i++) {
        final res4 = await ReplyHttp.replyReplyList(
          isLogin: true,
          oid: oid,
          root: root,
          pageNum: i,
          type: type,
          isCheck: true,
        );
        if (res4 is Error) {
          break;
        } else {
          final data = res4.data;
          if (data.replies.isNullOrEmpty) {
            break;
          }
          int index = data.replies!.indexWhere((item) => item.rpid == id);
          if (index == -1) {
            // not found
          } else {
            // found
            showReplyCheckResult(
              L10n.current.replyUtilsCheckReplyText5(message),
              isBan: true,
            );
            return;
          }
        }
      }

      showReplyCheckResult(
        L10n.current.replyUtilsCheckReplyText(message),
        isBan: true,
      );
    }
  }
}
