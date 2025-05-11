import 'dart:convert';
import 'dart:io';

import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show MainListReply, ReplyInfo, SubjectControl, Mode;
import 'package:PiliPlus/grpc/bilibili/pagination.pb.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/reply.dart';
import 'package:PiliPlus/models/common/reply/reply_sort_type.dart';
import 'package:PiliPlus/models/common/reply/reply_type.dart';
import 'package:PiliPlus/models/video/reply/data.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/pages/video/reply_new/view.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/dialog/dialog_route.dart';

abstract class ReplyController<R> extends CommonListController<R, ReplyInfo> {
  RxInt count = (-1).obs;

  Rx<ReplySortType> sortType = ReplySortType.time.obs;

  late final savedReplies = {};

  late final bool isLogin = Accounts.main.isLogin;

  Int64? upMid;
  Int64? cursorNext;
  FeedPaginationReply? paginationReply;
  late Rx<Mode> mode = Mode.MAIN_LIST_HOT.obs;
  late bool hasUpTop = false;

  @override
  bool? get hasFooter => true;

  late final antiGoodsReply = GStorage.antiGoodsReply;

  // comment antifraud
  late final _enableCommAntifraud = GStorage.enableCommAntifraud;
  late final _biliSendCommAntifraud = GStorage.biliSendCommAntifraud;
  bool get enableCommAntifraud =>
      _enableCommAntifraud || _biliSendCommAntifraud;
  dynamic get sourceId;

  @override
  void onInit() {
    super.onInit();
    int defaultReplySortIndex = GStorage.setting
        .get(SettingBoxKey.replySortType, defaultValue: 1) as int;
    if (defaultReplySortIndex == 2) {
      GStorage.setting.put(SettingBoxKey.replySortType, 0);
      defaultReplySortIndex = 0;
    }
    sortType.value = ReplySortType.values[defaultReplySortIndex];
    if (sortType.value == ReplySortType.time) {
      mode.value = Mode.MAIN_LIST_TIME;
    }
  }

  @override
  void checkIsEnd(int length) {
    if (count.value != -1 && length >= count.value) {
      isEnd = true;
    }
  }

  @override
  bool customHandleResponse(bool isRefresh, Success response) {
    MainListReply data = response.response;
    cursorNext = data.cursor.next;
    paginationReply = data.paginationReply;
    count.value = data.subjectControl.count.toInt();
    if (isRefresh) {
      upMid ??= data.subjectControl.upMid;
      hasUpTop = data.hasUpTop();
      if (data.hasUpTop()) {
        data.replies.insert(0, data.upTop);
      }
    }
    isEnd = data.cursor.isEnd;
    return false;
  }

  @override
  Future<void> onRefresh() {
    cursorNext = null;
    paginationReply = null;
    return super.onRefresh();
  }

  // 排序搜索评论
  void queryBySort() {
    EasyThrottle.throttle('queryBySort', const Duration(seconds: 1), () {
      feedBack();
      switch (sortType.value) {
        case ReplySortType.time:
          sortType.value = ReplySortType.like;
          mode.value = Mode.MAIN_LIST_HOT;
          break;
        case ReplySortType.like:
          sortType.value = ReplySortType.time;
          mode.value = Mode.MAIN_LIST_TIME;
          break;
      }
      onReload();
    });
  }

  void onReply(
    BuildContext context, {
    dynamic oid,
    dynamic replyItem,
    int index = 0,
    ReplyType? replyType,
  }) {
    String? hint;
    try {
      if (loadingState.value is Success) {
        SubjectControl subjectControl =
            (loadingState.value as Success).response.subjectControl;
        if (subjectControl.hasSwitcherType() &&
            subjectControl.switcherType != 1 &&
            subjectControl.hasRootText()) {
          hint = subjectControl.rootText;
        }
      }
    } catch (_) {}
    dynamic key = oid ?? replyItem.oid + replyItem.id;
    Navigator.of(context)
        .push(
      GetDialogRoute(
        pageBuilder: (buildContext, animation, secondaryAnimation) {
          return ReplyPage(
            oid: oid ?? replyItem.oid.toInt(),
            root: oid != null ? 0 : replyItem.id.toInt(),
            parent: oid != null ? 0 : replyItem.id.toInt(),
            replyType: replyItem != null
                ? ReplyType.values[replyItem.type.toInt()]
                : replyType,
            replyItem: replyItem,
            initialValue: savedReplies[key],
            onSave: (reply) {
              savedReplies[key] = reply;
            },
            hint: hint,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.linear;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    )
        .then(
      (res) {
        if (res != null) {
          savedReplies[key] = null;
          ReplyInfo replyInfo = RequestUtils.replyCast(res);
          if (loadingState.value is Success) {
            List<ReplyInfo>? list = (loadingState.value as Success).response;
            if (list == null) {
              loadingState.value = Success([replyInfo]);
            } else {
              if (oid != null) {
                list.insert(hasUpTop ? 1 : 0, replyInfo);
              } else {
                list[index].replies.add(replyInfo);
              }
              loadingState.refresh();
            }
          } else {
            loadingState.value = Success([replyInfo]);
          }
          count.value += 1;

          // check reply
          if (enableCommAntifraud && context.mounted) {
            checkReply(
              context: context,
              oid: oid ?? replyItem.oid.toInt(),
              rpid: replyItem?.id.toInt(),
              replyType: replyItem?.type.toInt() ??
                  replyType?.index ??
                  ReplyType.video.index,
              replyId: replyInfo.id.toInt(),
              message: replyInfo.content.message,
              //
              root: replyInfo.root.toInt(),
              parent: replyInfo.parent.toInt(),
              ctime: replyInfo.ctime.toInt(),
              pictures: replyInfo.content.pictures
                  .map((item) => item.toProto3Json())
                  .toList(),
              mid: replyInfo.mid.toInt(),
            );
          }
        }
      },
    );
  }

  void onRemove(int index, int? subIndex) {
    List<ReplyInfo> list = (loadingState.value as Success).response;
    if (subIndex == null) {
      list.removeAt(index);
    } else {
      list[index].replies.removeAt(subIndex);
    }
    count.value -= 1;
    loadingState.refresh();
  }

  void onCheckReply(context, item) {
    try {
      checkReply(
        context: context,
        oid: item.oid.toInt(),
        rpid: item.hasRoot() ? item.root.toInt() : null,
        replyType: item.type.toInt(),
        replyId: item.id.toInt(),
        message: item.content.message,
        //
        root: item.root.toInt(),
        parent: item.parent.toInt(),
        ctime: item.ctime.toInt(),
        pictures:
            item.content.pictures.map((item) => item.toProto3Json()).toList(),
        mid: item.mid.toInt(),
        //
        isManual: true,
      );
    } catch (e) {
      SmartDialog.showToast(e.toString());
    }
  }

  // ref https://github.com/freedom-introvert/biliSendCommAntifraud
  Future<void> checkReply({
    required BuildContext context,
    required int oid,
    required int? rpid,
    required int replyType,
    required int replyId,
    required String message,
    dynamic root,
    dynamic parent,
    dynamic ctime,
    List? pictures,
    dynamic mid,
    bool isManual = false,
  }) async {
    // biliSendCommAntifraud
    if (Platform.isAndroid && _biliSendCommAntifraud) {
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
            'type': replyType,
            'rpid': replyId,
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
        debugPrint('biliSendCommAntifraud: $e');
      }
      return;
    }

    // CommAntifraud
    if (isManual.not) {
      await Future.delayed(const Duration(seconds: 5));
    }
    void showReplyCheckResult(String message) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('评论检查结果'),
          content: SelectableText(message),
        ),
      );
    }

    if (context.mounted.not) return;
    // root reply
    if (rpid == null) {
      // no cookie check
      dynamic res = await ReplyHttp.replyList(
        isLogin: false,
        oid: oid,
        nextOffset: '',
        type: replyType,
        sort: ReplySortType.time.index,
        page: 1,
        enableFilter: false,
        antiGoodsReply: false,
      );
      if (context.mounted.not) return;
      if (res is Error) {
        SmartDialog.showToast('获取评论主列表时发生错误：${res.errMsg}');
        return;
      } else if (res is Success) {
        ReplyData replies = res.response;
        int index =
            replies.replies?.indexWhere((item) => item.rpid == replyId) ?? -1;
        if (index != -1) {
          // found
          if (context.mounted) {
            showReplyCheckResult(
              '无账号状态下找到了你的评论，评论正常！\n\n你的评论：$message',
            );
          }
        } else {
          // not found
          if (context.mounted.not) return;
          // cookie check
          final res1 = await ReplyHttp.replyReplyList(
            isLogin: isLogin,
            oid: oid,
            root: rpid ?? replyId,
            pageNum: 1,
            type: replyType,
            filterBanWord: false,
            antiGoodsReply: false,
          );
          if (context.mounted.not) return;
          if (res1 is Error) {
            // not found
            if (context.mounted) {
              showReplyCheckResult(
                '无法找到你的评论。\n\n你的评论：$message',
              );
            }
          } else {
            // found
            if (context.mounted.not) return;
            // no cookie check
            final res2 = await ReplyHttp.replyReplyList(
              isLogin: false,
              oid: oid,
              root: rpid ?? replyId,
              pageNum: 1,
              type: replyType,
              filterBanWord: false,
              isCheck: true,
              antiGoodsReply: false,
            );
            if (context.mounted.not) return;
            if (res2 is Error) {
              // not found
              if (context.mounted) {
                showReplyCheckResult(
                  res2.errMsg?.startsWith('12022') == true
                      ? '你的评论被shadow ban（仅自己可见）！\n\n你的评论: $message'
                      : '评论不可见(${res2.errMsg}): $message',
                );
              }
            } else {
              // found
              if (context.mounted) {
                showReplyCheckResult(isManual
                    ? '无账号状态下找到了你的评论，评论正常！\n\n你的评论：$message'
                    : '''
你评论状态有点可疑，虽然无账号翻找评论区获取不到你的评论，但是无账号可通过
https://api.bilibili.com/x/v2/reply/reply?oid=$oid&pn=1&ps=20&root=${rpid ?? replyId}&type=$replyType
获取你的评论，疑似评论区被戒严或者这是你的视频。

你的评论：$message''');
              }
            }
          }
        }
      }
    } else {
      for (int i = 1;; i++) {
        if (context.mounted.not) return;
        final res3 = await ReplyHttp.replyReplyList(
          isLogin: false,
          oid: oid,
          root: rpid,
          pageNum: i,
          type: replyType,
          filterBanWord: false,
          isCheck: true,
          antiGoodsReply: false,
        );
        if (res3 is Error) {
          break;
        } else {
          final data = res3.data;
          if (data.replies.isNullOrEmpty) {
            break;
          }
          int index =
              data.replies?.indexWhere((item) => item.rpid == replyId) ?? -1;
          if (index == -1) {
            // not found
          } else {
            // found
            if (context.mounted) {
              showReplyCheckResult(
                '无账号状态下找到了你的评论，评论正常！\n\n你的评论：$message',
              );
            }
            return;
          }
        }
      }

      for (int i = 1;; i++) {
        if (context.mounted.not) return;
        final res4 = await ReplyHttp.replyReplyList(
          isLogin: true,
          oid: oid,
          root: rpid,
          pageNum: i,
          type: replyType,
          filterBanWord: false,
          isCheck: true,
          antiGoodsReply: false,
        );
        if (res4 is Error) {
          break;
        } else {
          final data = res4.data;
          if (data.replies.isNullOrEmpty) {
            break;
          }
          int index =
              data.replies?.indexWhere((item) => item.rpid == replyId) ?? -1;
          if (index == -1) {
            // not found
          } else {
            // found
            if (context.mounted) {
              showReplyCheckResult(
                '你的评论被shadow ban（仅自己可见）！\n\n你的评论: $message',
              );
            }
            return;
          }
        }
      }

      if (context.mounted) {
        showReplyCheckResult(
          '评论不可见: $message',
        );
      }
    }
  }

  Future<void> onToggleTop(index, oid, int type, bool isUpTop, int rpid) async {
    final res = await ReplyHttp.replyTop(
      oid: oid,
      type: type,
      rpid: rpid,
      isUpTop: isUpTop,
    );
    if (res['status']) {
      List<ReplyInfo> list = (loadingState.value as Success).response;
      list[index].replyControl.isUpTop = !isUpTop;
      if (!isUpTop && index != 0) {
        list[0].replyControl.isUpTop = false;
        final item = list.removeAt(index);
        list.insert(0, item);
      }
      loadingState.refresh();
      SmartDialog.showToast('${isUpTop ? '取消' : ''}置顶成功');
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }
}
