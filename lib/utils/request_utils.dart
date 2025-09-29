import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:PiliPlus/grpc/bilibili/im/type.pbenum.dart';
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo;
import 'package:PiliPlus/grpc/im.dart';
import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/member.dart';
import 'package:PiliPlus/http/msg.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/http/validate.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/models/login/model.dart';
import 'package:PiliPlus/pages/common/multi_select/base.dart';
import 'package:PiliPlus/pages/common/multi_select/multi_select_controller.dart';
import 'package:PiliPlus/pages/dynamics_tab/controller.dart';
import 'package:PiliPlus/pages/group_panel/view.dart';
import 'package:PiliPlus/pages/later/controller.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/context_ext.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:gt3_flutter_plugin/gt3_flutter_plugin.dart';

abstract class RequestUtils {
  static Future<void> syncHistoryStatus() async {
    final account = Accounts.history;
    if (!account.isLogin) {
      return;
    }
    var res = await UserHttp.historyStatus(account: account);
    if (res['status']) {
      GStorage.localCache.put(LocalCacheKey.historyPause, res['data']);
    }
  }

  // 1：小视频（已弃用）
  // 2：相簿
  // 3：纯文字
  // 4：直播（此类型不常用，见分享其他内容消息）
  // 5：视频
  // 6：专栏
  // 7：番剧（id 为 season_id）
  // 8：音乐
  // 9：国产动画（id 为 AV 号）
  // 10：图片
  // 11：动态
  // 16：番剧（id 为 epid）
  // 17：番剧
  // https://github.com/SocialSisterYi/bilibili-API-collect/tree/master/docs/message/private_msg_content.md
  static Future<void> pmShare({
    required int receiverId,
    required Map content,
    String? message,
  }) async {
    SmartDialog.showLoading();

    final ownerMid = Accounts.main.mid;
    final contentRes = await ImGrpc.sendMsg(
      senderUid: ownerMid,
      receiverId: receiverId,
      content: jsonEncode(content),
      msgType: content['source'] is String
          ? MsgType.EN_MSG_TYPE_COMMON_SHARE_CARD
          : MsgType.EN_MSG_TYPE_SHARE_V2,
    );

    if (contentRes.isSuccess) {
      if (message?.isNotEmpty == true) {
        var msgRes = await MsgHttp.sendMsg(
          senderUid: ownerMid,
          receiverId: receiverId,
          content: jsonEncode({"content": message}),
          msgType: 1,
        );
        Get.back();
        if (msgRes['status']) {
          SmartDialog.showToast('分享成功');
        } else {
          SmartDialog.showToast('内容分享成功，但消息分享失败: ${msgRes['msg']}');
        }
      } else {
        Get.back();
        SmartDialog.showToast('分享成功');
      }
    } else {
      SmartDialog.showToast('分享失败: ${(contentRes as Error).errMsg}');
    }
    SmartDialog.dismiss();
  }

  static Future<void> actionRelationMod({
    required BuildContext context,
    required dynamic mid,
    required bool isFollow,
    required ValueChanged<int>? callback,
    Map? followStatus,
  }) async {
    if (mid == null) {
      return;
    }
    feedBack();
    if (!isFollow) {
      var res = await VideoHttp.relationMod(
        mid: mid,
        act: 1,
        reSrc: 11,
      );
      SmartDialog.showToast(res['status'] ? "关注成功" : res['msg']);
      if (res['status']) {
        callback?.call(2);
      }
    } else {
      if (followStatus?['tag'] == null) {
        Map<String, dynamic> result = await UserHttp.hasFollow(mid);
        if (result['status']) {
          followStatus = result['data'];
        } else {
          SmartDialog.showToast(result['msg']);
          return;
        }
      }

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) {
            bool isSpecialFollowed = followStatus!['special'] == 1;
            String text = isSpecialFollowed ? '移除特别关注' : '加入特别关注';
            return AlertDialog(
              clipBehavior: Clip.hardEdge,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    dense: true,
                    onTap: () async {
                      Get.back();
                      final res = await MemberHttp.specialAction(
                        fid: mid,
                        isAdd: !isSpecialFollowed,
                      );
                      if (res['status']) {
                        SmartDialog.showToast('$text成功');
                        callback?.call(isSpecialFollowed ? 2 : -10);
                      } else {
                        SmartDialog.showToast(res['msg']);
                      }
                    },
                    title: Text(
                      text,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  ListTile(
                    dense: true,
                    onTap: () async {
                      Get.back();
                      var result = await showModalBottomSheet<Set<int>>(
                        context: context,
                        useSafeArea: true,
                        isScrollControlled: true,
                        sheetAnimationStyle: const AnimationStyle(
                          curve: Curves.ease,
                        ),
                        constraints: BoxConstraints(
                          maxWidth: min(640, context.mediaQueryShortestSide),
                        ),
                        builder: (BuildContext context) {
                          return DraggableScrollableSheet(
                            minChildSize: 0,
                            maxChildSize: 1,
                            initialChildSize: 0.7,
                            snap: true,
                            expand: false,
                            snapSizes: const [0.7],
                            builder:
                                (
                                  BuildContext context,
                                  ScrollController scrollController,
                                ) {
                                  return GroupPanel(
                                    mid: mid,
                                    tags: followStatus!['tag'],
                                    scrollController: scrollController,
                                  );
                                },
                          );
                        },
                      );
                      followStatus!['tag'] = result?.toList();
                      if (result != null) {
                        callback?.call(result.contains(-10) ? -10 : 2);
                      }
                    },
                    title: const Text(
                      '设置分组',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  ListTile(
                    dense: true,
                    onTap: () async {
                      Get.back();
                      var res = await VideoHttp.relationMod(
                        mid: mid,
                        act: 2,
                        reSrc: 11,
                      );
                      SmartDialog.showToast(
                        res['status'] ? "取消关注成功" : res['msg'],
                      );
                      if (res['status']) {
                        callback?.call(0);
                      }
                    },
                    title: const Text(
                      '取消关注',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    }
  }

  static ReplyInfo replyCast(Map res) {
    Map? emote = res['content']['emote'];
    emote?.forEach((key, value) {
      value['size'] = value['meta']['size'];
    });
    return ReplyInfo.create()..mergeFromProto3Json(
      res
        ..['content'].remove('members')
        ..['id'] = res['rpid']
        ..['member']['name'] = res['member']['uname']
        ..['member']['face'] = res['member']['avatar']
        ..['member']['level'] = res['member']['level_info']['current_level']
        ..['member']['vipStatus'] = res['member']['vip']['vipStatus']
        ..['member']['vipType'] = res['member']['vip']['vipType']
        ..['member']['officialVerifyType'] =
            res['member']['official_verify']['type']
        ..['content']['emotes'] = emote,
      ignoreUnknownFields: true,
    );
  }

  // static Future<dynamic> getWwebid(mid) async {
  //   try {
  //     var response = await Request().get(
  //       '${HttpString.spaceBaseUrl}/$mid/dynamic',
  //       options: Options(
  //         extra: {'account': AnonymousAccount()},
  //       ),
  //     );
  //     dom.Document document = html_parser.parse(response.data);
  //     dom.Element? scriptElement =
  //         document.querySelector('script#__RENDER_DATA__');
  //     return jsonDecode(
  //         Uri.decodeComponent(scriptElement?.text ?? ''))['access_id'];
  //   } catch (e) {
  //     if (kDebugMode) debugPrint('failed to get wwebid: $e');
  //     return null;
  //   }
  // }

  static Future<void> insertCreatedDyn(dynamic id) async {
    try {
      if (id != null) {
        await Future.delayed(const Duration(milliseconds: 450));
        var res = await DynamicsHttp.dynamicDetail(id: id);
        if (res.isSuccess) {
          final ctr = Get.find<DynamicsTabController>(tag: 'all');
          if (ctr.loadingState.value.isSuccess) {
            List<DynamicItemModel>? list = ctr.loadingState.value.data;
            if (list != null) {
              list.insert(0, res.data);
              ctr.loadingState.refresh();
              return;
            }
          }
          ctr.loadingState.value = Success([res.data]);
        }
      }
    } catch (e) {
      if (kDebugMode) debugPrint('create dyn $e');
    }
  }

  static Future<void> checkCreatedDyn({
    dynamic id,
    String? dynText,
    bool isManual = false,
  }) async {
    if (isManual || Pref.enableCreateDynAntifraud) {
      try {
        if (id != null) {
          if (!isManual) {
            await Future.delayed(const Duration(seconds: 5));
          }
          var res = await DynamicsHttp.dynamicDetail(id: id, clearCookie: true);
          Get.dialog(
            barrierDismissible: isManual,
            AlertDialog(
              title: const Text('动态检查结果'),
              content: SelectableText(
                '${res.isSuccess ? '无账号状态下找到了你的动态，动态正常！' : '你的动态被shadow ban（仅自己可见）！'}${dynText != null ? ' \n\n动态内容: $dynText' : ''}',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                    Utils.copyText('https://www.bilibili.com/opus/$id');
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
      } catch (e) {
        if (kDebugMode) debugPrint('check dyn error: $e');
      }
    }
  }

  // 动态点赞
  static Future<void> onLikeDynamic(
    DynamicItemModel item,
    VoidCallback onSuccess,
  ) async {
    feedBack();
    String dynamicId = item.idStr!;
    // 1 已点赞 2 不喜欢 0 未操作
    DynamicStat? like = item.modules.moduleStat?.like;
    int count = like?.count ?? 0;
    bool status = like?.status ?? false;
    int up = status ? 2 : 1;
    var res = await DynamicsHttp.thumbDynamic(dynamicId: dynamicId, up: up);
    if (res['status']) {
      SmartDialog.showToast(!status ? '点赞成功' : '取消赞');
      if (up == 1) {
        like
          ?..count = count + 1
          ..status = true;
      } else {
        like
          ?..count = count - 1
          ..status = false;
      }
      onSuccess();
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  static void onCopyOrMove<R, T extends MultiSelectData>({
    required BuildContext context,
    required bool isCopy,
    required MultiSelectController<R, T> ctr,
    required dynamic mediaId,
    required dynamic mid,
  }) {
    FavHttp.allFavFolders(mid).then((res) {
      if (context.mounted && res.dataOrNull?.list?.isNotEmpty == true) {
        final list = res.data.list!;
        int? checkedId;
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('${isCopy ? '复制' : '移动'}到'),
              contentPadding: const EdgeInsets.only(top: 5),
              content: SingleChildScrollView(
                child: RadioGroup(
                  onChanged: (value) {
                    checkedId = value;
                    (context as Element).markNeedsBuild();
                  },
                  groupValue: checkedId,
                  child: Column(
                    children: list.map((item) {
                      return RadioListTile<int>(
                        dense: true,
                        title: Text(item.title),
                        value: item.id,
                      );
                    }).toList(),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: Get.back,
                  child: Text(
                    '取消',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (checkedId != null) {
                      Set removeList = ctr.allChecked.toSet();
                      SmartDialog.showLoading();
                      FavHttp.copyOrMoveFav(
                        isCopy: isCopy,
                        isFav: ctr is! LaterController,
                        srcMediaId: mediaId,
                        tarMediaId: checkedId,
                        resources: removeList
                            .map(
                              (item) => ctr is LaterController
                                  ? item.aid
                                  : '${item.id}:${item.type}',
                            )
                            .join(','),
                        mid: isCopy ? mid : null,
                      ).then((res) {
                        if (res.isSuccess) {
                          ctr.handleSelect(checked: false);
                          if (!isCopy) {
                            ctr.loadingState
                              ..value.data!.removeWhere(removeList.contains)
                              ..refresh();
                          }
                          SmartDialog.dismiss();
                          SmartDialog.showToast('${isCopy ? '复制' : '移动'}成功');
                          Get.back();
                        } else {
                          SmartDialog.dismiss();
                          res.toast();
                        }
                      });
                    }
                  },
                  child: const Text('确认'),
                ),
              ],
            );
          },
        );
      } else {
        res.toast();
      }
    });
  }

  static Future<void> validate(
    String vVoucher,
    ValueChanged<String> onSuccess,
  ) async {
    final res = await ValidateHttp.gaiaVgateRegister(vVoucher);
    if (!res['status']) {
      SmartDialog.showToast("${res['msg']}");
      return;
    }

    if (res['data'] == null) {
      SmartDialog.showToast("null data");
      return;
    }

    CaptchaDataModel captchaData = CaptchaDataModel();

    String? geeGt = res['data']?['geetest']?['gt'];
    String? geeChallenge = res['data']?['geetest']?['challenge'];
    captchaData.token = res['data']?['token'];

    bool isGeeArgumentValid() {
      return geeGt?.isNotEmpty == true &&
          geeChallenge?.isNotEmpty == true &&
          captchaData.token?.isNotEmpty == true;
    }

    if (!isGeeArgumentValid()) {
      SmartDialog.showToast("参数为空");
      return;
    }

    var registerData = Gt3RegisterData(
      challenge: geeChallenge,
      gt: geeGt,
      success: true,
    );

    Gt3FlutterPlugin()
      ..addEventHandler(
        onClose: (Map<String, dynamic> message) {
          SmartDialog.showToast('关闭验证');
        },
        onResult: (Map<String, dynamic> message) async {
          if (kDebugMode) debugPrint("Captcha result: $message");
          String code = message["code"];
          if (code == "1") {
            // 发送 message["result"] 中的数据向 B 端的业务服务接口进行查询
            SmartDialog.showToast('验证成功');
            captchaData
              ..validate = message['result']?['geetest_validate']
              ..seccode = message['result']?['geetest_seccode'];
            String? challenge = message['result']?['geetest_challenge'];
            final res = await ValidateHttp.gaiaVgateValidate(
              challenge: challenge,
              seccode: captchaData.seccode,
              token: captchaData.token,
              validate: captchaData.validate,
            );
            if (res['status']) {
              if (res['data']?['is_valid'] == 1) {
                final griskId = res['data']?['grisk_id'];
                if (griskId != null) {
                  onSuccess(griskId);
                }
              } else {
                SmartDialog.showToast('invalid');
              }
            } else {
              SmartDialog.showToast(res['msg']);
            }
          } else {
            // 终端用户完成验证失败，自动重试 If the verification fails, it will be automatically retried.
            if (kDebugMode) debugPrint("Captcha result code : $code");
          }
        },
        onError: (Map<String, dynamic> message) {
          SmartDialog.showToast("Captcha onError: $message");
          String code = message["code"];
          // 处理验证中返回的错误 Handling errors returned in verification
          if (Platform.isAndroid) {
            // Android 平台
            if (code == "-2") {
              // Dart 调用异常 Call exception
            } else if (code == "-1") {
              // Gt3RegisterData 参数不合法 Parameter is invalid
            } else if (code == "201") {
              // 网络无法访问 Network inaccessible
            } else if (code == "202") {
              // Json 解析错误 Analysis error
            } else if (code == "204") {
              // WebView 加载超时，请检查是否混淆极验 SDK   Load timed out
            } else if (code == "204_1") {
              // WebView 加载前端页面错误，请查看日志 Error loading front-end page, please check the log
            } else if (code == "204_2") {
              // WebView 加载 SSLError
            } else if (code == "206") {
              // gettype 接口错误或返回为 null   API error or return null
            } else if (code == "207") {
              // getphp 接口错误或返回为 null    API error or return null
            } else if (code == "208") {
              // ajax 接口错误或返回为 null      API error or return null
            } else {
              // 更多错误码参考开发文档  More error codes refer to the development document
              // https://docs.geetest.com/sensebot/apirefer/errorcode/android
            }
          }

          if (Platform.isIOS) {
            // iOS 平台
            if (code == "-1009") {
              // 网络无法访问 Network inaccessible
            } else if (code == "-1004") {
              // 无法查找到 HOST  Unable to find HOST
            } else if (code == "-1002") {
              // 非法的 URL  Illegal URL
            } else if (code == "-1001") {
              // 网络超时 Network timeout
            } else if (code == "-999") {
              // 请求被意外中断, 一般由用户进行取消操作导致 The interrupted request was usually caused by the user cancelling the operation
            } else if (code == "-21") {
              // 使用了重复的 challenge   Duplicate challenges are used
              // 检查获取 challenge 是否进行了缓存  Check if the fetch challenge is cached
            } else if (code == "-20") {
              // 尝试过多, 重新引导用户触发验证即可 Try too many times, lead the user to request verification again
            } else if (code == "-10") {
              // 预判断时被封禁, 不会再进行图形验证 Banned during pre-judgment, and no more image captcha verification
            } else if (code == "-2") {
              // Dart 调用异常 Call exception
            } else if (code == "-1") {
              // Gt3RegisterData 参数不合法  Parameter is invalid
            } else {
              // 更多错误码参考开发文档 More error codes refer to the development document
              // https://docs.geetest.com/sensebot/apirefer/errorcode/ios
            }
          }
        },
      )
      ..startCaptcha(registerData);
  }
}
