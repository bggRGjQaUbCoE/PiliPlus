import 'dart:convert' show jsonEncode;
import 'dart:io' show Platform;

import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo;
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/reply.dart';
import 'package:PiliPlus/models/common/reply/reply_sort_type.dart';
import 'package:PiliPlus/models_new/reply/data.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class ReplyUtils {
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
    dynamic root,
    dynamic parent,
    dynamic ctime,
    List? pictures,
    dynamic mid,
    bool isManual = false,
    required bool biliSendCommAntifraud,
    required sourceId,
  }) async {
    // biliSendCommAntifraud
    if (Platform.isAndroid && biliSendCommAntifraud) {
      try {
        final String cookieString = Accounts.main.cookieJar
            .toJson()
            .entries
            .map((i) => '${i.key}=${i.value}')
            .join(';');
        Utils.channel.invokeMethod(
          'biliSendCommAntifraud',
          {
            'action': 0,
            'oid': oid,
            'type': type,
            'rpid': id,
            'root': root,
            'parent': parent,
            'ctime': ctime,
            'comment_text': message,
            if (pictures?.isNotEmpty == true) 'pictures': jsonEncode(pictures),
            'source_id': '$sourceId',
            'uid': mid,
            'cookies': [cookieString],
          },
        );
      } catch (e) {
        if (kDebugMode) debugPrint('biliSendCommAntifraud: $e');
      }
      return;
    }

    // CommAntifraud
    if (!isManual) {
      await Future.delayed(const Duration(seconds: 8));
    }
    void showReplyCheckResult(String message, {bool isBan = false}) {
      Get.dialog(
        barrierDismissible: isManual,
        AlertDialog(
          title: const Text('评论检查结果'),
          content: SelectableText(message),
          actions: [
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
                        'https://www.bilibili.com/h5/comment/appeal?native.theme=2&night=${Get.isDarkMode ? 1 : 0}',
                  },
                );
              },
              child: const Text('申诉'),
            ),
            TextButton(
              onPressed: Get.back,
              child: const Text('关闭'),
            ),
          ],
        ),
      );
    }

    // root reply
    if (root == 0) {
      // no cookie check
      var res = await ReplyHttp.replyList(
        isLogin: false,
        oid: oid,
        nextOffset: '',
        type: type,
        sort: ReplySortType.time.index,
        page: 1,
      );

      if (res is Error) {
        SmartDialog.showToast('获取评论主列表时发生错误：${res.errMsg}');
        return;
      } else if (res.isSuccess) {
        ReplyData replies = res.data;
        int index =
            replies.replies?.indexWhere((item) => item.rpid == id) ?? -1;
        if (index != -1) {
          // found
          showReplyCheckResult('无账号状态下找到了你的评论，评论正常！\n\n你的评论：$message');
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
            showReplyCheckResult('无法找到你的评论。\n\n你的评论：$message', isBan: true);
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
                    ? '你的评论被shadow ban（仅自己可见）！\n\n你的评论: $message'
                    : '评论不可见(${res2.errMsg}): $message',
                isBan: true,
              );
            } else {
              // found
              showReplyCheckResult(
                isManual
                    ? '无账号状态下找到了你的评论，评论正常！\n\n你的评论：$message'
                    : '''
你评论状态有点可疑，虽然无账号翻找评论区获取不到你的评论，但是无账号可通过
https://api.bilibili.com/x/v2/reply/reply?oid=$oid&pn=1&ps=20&root=$id&type=$type
获取你的评论，疑似评论区被戒严或者这是你的视频。

你的评论：$message''',
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
          int index = data.replies?.indexWhere((item) => item.rpid == id) ?? -1;
          if (index == -1) {
            // not found
          } else {
            // found
            showReplyCheckResult('无账号状态下找到了你的评论，评论正常！\n\n你的评论：$message');
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
          int index = data.replies?.indexWhere((item) => item.rpid == id) ?? -1;
          if (index == -1) {
            // not found
          } else {
            // found
            showReplyCheckResult(
              '你的评论被shadow ban（仅自己可见）！\n\n你的评论: $message',
              isBan: true,
            );
            return;
          }
        }
      }

      showReplyCheckResult('评论不可见: $message', isBan: true);
    }
  }
}
