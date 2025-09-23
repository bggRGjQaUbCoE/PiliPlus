import 'dart:async';
import 'dart:io';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/button/icon_button.dart';
import 'package:PiliPlus/common/widgets/radio_widget.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/login.dart';
import 'package:PiliPlus/models/common/account_type.dart';
import 'package:PiliPlus/models/login/model.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:gt3_flutter_plugin/gt3_flutter_plugin.dart';

class LoginPageController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final TextEditingController telTextController = TextEditingController();
  final TextEditingController usernameTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController smsCodeTextController = TextEditingController();
  final TextEditingController cookieTextController = TextEditingController();

  late final RxMap<String, dynamic> codeInfo = RxMap<String, dynamic>({});

  late final TabController tabController;

  late final Gt3FlutterPlugin captcha = Gt3FlutterPlugin();

  late final CaptchaDataModel captchaData = CaptchaDataModel();
  late final RxInt qrCodeLeftTime = 180.obs;
  late final RxString statusQRCode = ''.obs;

  late final List<Map<String, dynamic>> internationalDialingPrefix =
      Constants.internationalDialingPrefix;
  late Map<String, dynamic> selectedCountryCodeId =
      internationalDialingPrefix.first;
  late String captchaKey = '';
  late final RxInt smsSendCooldown = 0.obs;
  late int smsSendTimestamp = 0;

  // 定时器
  Timer? qrCodeTimer;
  Timer? smsSendCooldownTimer;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 4, vsync: this)
      ..addListener(_handleTabChange);
  }

  @override
  void onClose() {
    tabController
      ..removeListener(_handleTabChange)
      ..dispose();
    qrCodeTimer?.cancel();
    smsSendCooldownTimer?.cancel();
    telTextController.dispose();
    usernameTextController.dispose();
    passwordTextController.dispose();
    smsCodeTextController.dispose();
    cookieTextController.dispose();
    super.onClose();
  }

  void refreshQRCode() {
    LoginHttp.getHDcode().then((res) {
      if (res['status']) {
        qrCodeTimer?.cancel();
        codeInfo.addAll(res);
        qrCodeTimer = Timer.periodic(const Duration(milliseconds: 1000), (t) {
          qrCodeLeftTime.value = 180 - t.tick;
          if (qrCodeLeftTime <= 0) {
            t.cancel();
            statusQRCode.value = '二维码已过期，请刷新';
            qrCodeLeftTime.value = 0;
            return;
          }

          LoginHttp.codePoll(codeInfo['data']['auth_code']).then((value) async {
            if (value['status']) {
              t.cancel();
              statusQRCode.value = '扫码成功';
              await setAccount(
                value['data'],
                value['data']['cookie_info']['cookies'],
              );
              Get.back();
            } else if (value['code'] == 86038) {
              t.cancel();
              qrCodeLeftTime.value = 0;
            } else {
              statusQRCode.value = value['msg'];
            }
          });
        });
      } else {
        SmartDialog.showToast(res['msg']);
      }
    });
  }

  void _handleTabChange() {
    if (tabController.index == 2) {
      if (qrCodeTimer == null || qrCodeTimer!.isActive == false) {
        refreshQRCode();
      }
    }
  }

  // 申请极验验证码
  void getCaptcha(String? geeGt, String? geeChallenge, VoidCallback onSuccess) {
    var registerData = Gt3RegisterData(
      challenge: geeChallenge,
      gt: geeGt,
      success: true,
    );

    captcha
      ..addEventHandler(
        onShow: (Map<String, dynamic> message) {},
        onClose: (Map<String, dynamic> message) {
          SmartDialog.showToast('关闭验证');
        },
        onResult: (Map<String, dynamic> message) {
          if (kDebugMode) debugPrint("Captcha result: $message");
          String code = message["code"];
          if (code == "1") {
            // 发送 message["result"] 中的数据向 B 端的业务服务接口进行查询
            SmartDialog.showToast('验证成功');
            captchaData
              ..validate = message['result']['geetest_validate']
              ..seccode = message['result']['geetest_seccode']
              ..geetest = GeetestData(
                challenge: message['result']['geetest_challenge'],
                gt: geeGt,
              );
            onSuccess();
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

  // cookie登录
  Future<void> loginByCookie() async {
    if (cookieTextController.text.isEmpty) {
      SmartDialog.showToast('cookie不能为空');
      return;
    }
    try {
      var result = await Request().get(
        "/x/member/web/account",
        options: Options(
          headers: {
            "cookie": cookieTextController.text,
          },
          extra: {'account': AnonymousAccount()},
        ),
      );
      if (result.data['code'] == 0) {
        try {
          await LoginAccount(
            BiliCookieJar.fromJson(
              Map.fromEntries(
                cookieTextController.text.split(';').map((item) {
                  final list = item.split('=');
                  return MapEntry(list.first, list.skip(1).join());
                }),
              ),
            ),
            null,
            null,
          ).onChange();
          if (!Accounts.main.isLogin) await switchAccountDialog(Get.context!);
          SmartDialog.showToast('登录成功');
          Get.back();
        } catch (e) {
          SmartDialog.showToast("登录失败: $e");
        }
      } else {
        SmartDialog.showToast("哔哩哔哩登录已失效，请重新登录");
      }
    } catch (e) {
      SmartDialog.showToast("获取哔哩哔哩用户信息失败，可前往账号管理重试");
    }
  }

  // app端密码登录
  Future<void> loginByPassword() async {
    String username = usernameTextController.text;
    String password = passwordTextController.text;
    if (username.isEmpty || password.isEmpty) {
      SmartDialog.showToast('用户名或密码不能为空');
      return;
    }
    // if ((passwordFormKey.currentState as FormState).validate()) {
    var webKeyRes = await LoginHttp.getWebKey();
    if (!webKeyRes['status']) {
      SmartDialog.showToast(webKeyRes['msg']);
      return;
    }
    String salt = webKeyRes['data']['hash'];
    String key = webKeyRes['data']['key'];
    var res = await LoginHttp.loginByPwd(
      username: username,
      password: password,
      key: key,
      salt: salt,
      geeValidate: captchaData.validate,
      geeSeccode: captchaData.seccode,
      geeChallenge: captchaData.geetest?.challenge,
      recaptchaToken: captchaData.token,
    );
    if (res['status']) {
      var data = res['data'];
      if (data == null) {
        SmartDialog.showToast('登录异常，接口未返回数据：${res["msg"]}');
        return;
      }
      if (data['status'] == 2) {
        SmartDialog.showToast(data['message']);
        if (!Utils.isMobile) {
          return;
        }
        // return;
        //{"code":0,"message":"0","ttl":1,"data":{"status":2,"message":"本次登录环境存在风险, 需使用手机号进行验证或绑定","url":"https://passport.bilibili.com/h5-app/passport/risk/verify?tmp_token=9e785433940891dfa78f033fb7928181&request_id=e5a6d6480df04097870be56c6e60f7ef&source=risk","token_info":null,"cookie_info":null,"sso":null,"is_new":false,"is_tourist":false}}
        String url = data['url']!;
        Uri currentUri = Uri.parse(url);
        var safeCenterRes = await LoginHttp.safeCenterGetInfo(
          tmpCode: currentUri.queryParameters['tmp_token']!,
        );
        //{"code":0,"message":"0","ttl":1,"data":{"account_info":{"hide_tel":"111*****111","hide_mail":"aaa*****aaaa.aaa","bind_mail":true,"bind_tel":true,"tel_verify":true,"mail_verify":true,"unneeded_check":false,"bind_safe_question":false,"mid":1111111},"member_info":{"nickname":"xxxxxxx","face":"https://i0.hdslb.com/bfs/face/xxxxxxx.jpg","realname_status":false},"sns_info":{"bind_google":false,"bind_fb":false,"bind_apple":false,"bind_qq":true,"bind_weibo":true,"bind_wechat":false},"account_safe":{"score":80}}}
        if (!safeCenterRes['status']) {
          SmartDialog.showToast(
            "获取安全验证信息失败，请尝试其它登录方式\n"
            "(${safeCenterRes['code']}) ${safeCenterRes['msg']}",
          );
          return;
        }
        Map<String, String> accountInfo = {
          "hindTel": safeCenterRes['data']['account_info']!["hide_tel"],
          "hindMail": safeCenterRes['data']['account_info']!["hide_mail"],
        };
        if (!safeCenterRes['data']['account_info']!['tel_verify']) {
          SmartDialog.showToast("当前账号未支持手机号验证，请尝试其它登录方式");
          return;
        }

        TextEditingController textFieldController = TextEditingController();
        String captchaKey = '';
        Get.dialog(
          AlertDialog(
            titlePadding: const EdgeInsets.only(
              left: 16,
              top: 18,
              right: 16,
              bottom: 12,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            actionsPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            title: const Text(
              "本次登录需要验证您的手机号",
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  accountInfo['hindTel'] ?? '未能获取手机号',
                  style: const TextStyle(fontSize: 18),
                ),
                // 带有清空按钮的输入框
                TextField(
                  style: const TextStyle(fontSize: 15),
                  controller: textFieldController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: "请输入短信验证码",
                    hintStyle: const TextStyle(fontSize: 15),
                    suffixIcon: iconButton(
                      context: Get.context!,
                      icon: Icons.clear,
                      size: 32,
                      bgColor: Colors.transparent,
                      onPressed: textFieldController.clear,
                    ),
                    suffixIconConstraints: const BoxConstraints(
                      maxHeight: 32,
                      maxWidth: 32,
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("发送验证码"),
                onPressed: () async {
                  var preCaptureRes = await LoginHttp.preCapture();
                  if (!preCaptureRes['status'] ||
                      preCaptureRes['data'] == null) {
                    SmartDialog.showToast(
                      "获取验证码失败，请尝试其它登录方式\n"
                      "(${preCaptureRes['code']}) ${preCaptureRes['msg']} ${preCaptureRes['data']}",
                    );
                  }
                  String? geeGt = preCaptureRes['data']['gee_gt'];
                  String? geeChallenge = preCaptureRes['data']['gee_challenge'];
                  captchaData.token = preCaptureRes['data']['recaptcha_token'];
                  if (!isGeeArgumentValid(geeGt, geeChallenge)) {
                    SmartDialog.showToast(
                      "获取极验参数为空，请尝试其它登录方式\n"
                      "(${preCaptureRes['code']}) ${preCaptureRes['msg']} ${preCaptureRes['data']}",
                    );
                    return;
                  }

                  getCaptcha(
                    geeGt,
                    geeChallenge,
                    () async {
                      var safeCenterSendSmsCodeRes =
                          await LoginHttp.safeCenterSmsCode(
                            tmpCode: currentUri.queryParameters['tmp_token']!,
                            geeChallenge: geeChallenge,
                            geeSeccode: captchaData.seccode,
                            geeValidate: captchaData.validate,
                            recaptchaToken: captchaData.token,
                            refererUrl: url,
                          );
                      if (!safeCenterSendSmsCodeRes['status']) {
                        SmartDialog.showToast(
                          "发送短信验证码失败，请尝试其它登录方式\n"
                          "(${safeCenterSendSmsCodeRes['code']}) ${safeCenterSendSmsCodeRes['msg']}",
                        );
                        return;
                      }
                      SmartDialog.showToast("短信验证码已发送，请查收");
                      captchaKey =
                          safeCenterSendSmsCodeRes['data']['captcha_key'];
                    },
                  );
                },
              ),
              TextButton(
                onPressed: Get.back,
                child: Text(
                  "取消",
                  style: TextStyle(color: Get.theme.colorScheme.outline),
                ),
              ),
              TextButton(
                onPressed: () async {
                  String? code = textFieldController.text;
                  if (code.isEmpty) {
                    SmartDialog.showToast("请输入短信验证码");
                    return;
                  }
                  var safeCenterSmsVerifyRes =
                      await LoginHttp.safeCenterSmsVerify(
                        code: code,
                        tmpCode: currentUri.queryParameters['tmp_token']!,
                        requestId: currentUri.queryParameters['request_id']!,
                        source: currentUri.queryParameters['source']!,
                        captchaKey: captchaKey,
                        refererUrl: url,
                      );
                  if (!safeCenterSmsVerifyRes['status']) {
                    SmartDialog.showToast(
                      "验证短信验证码失败，请尝试其它登录方式\n"
                      "(${safeCenterSmsVerifyRes['code']}) ${safeCenterSmsVerifyRes['msg']}",
                    );
                    return;
                  }
                  SmartDialog.showToast("验证成功，正在登录");
                  var oauth2AccessTokenRes = await LoginHttp.oauth2AccessToken(
                    code: safeCenterSmsVerifyRes['data']['code'],
                  );
                  if (!oauth2AccessTokenRes['status']) {
                    SmartDialog.showToast(
                      "登录失败，请尝试其它登录方式\n"
                      "(${oauth2AccessTokenRes['code']}) ${oauth2AccessTokenRes['msg']}",
                    );
                    return;
                  }
                  var data = oauth2AccessTokenRes['data'];
                  if (data['token_info'] == null ||
                      data['cookie_info'] == null) {
                    SmartDialog.showToast(
                      '登录异常，接口未返回身份信息，可能是因为账号风控，请尝试其它登录方式。\n${oauth2AccessTokenRes["msg"]}，\n $data',
                    );
                    return;
                  }
                  SmartDialog.showToast('正在保存身份信息');
                  await setAccount(
                    data['token_info'],
                    data['cookie_info']['cookies'],
                  );
                  Get
                    ..back()
                    ..back();
                },
                child: const Text("确认"),
              ),
            ],
          ),
        ).whenComplete(textFieldController.dispose);

        return;
      }
      if (data['token_info'] == null || data['cookie_info'] == null) {
        SmartDialog.showToast(
          '登录异常，接口未返回身份信息，可能是因为账号风控，请尝试其它登录方式。\n${res["msg"]}，\n $data',
        );
        return;
      }
      SmartDialog.showToast('正在保存身份信息');
      await setAccount(data['token_info'], data['cookie_info']['cookies']);
      Get.back();
    } else {
      // handle login result
      switch (res['code']) {
        case 0:
          // login success
          break;
        case -105 when (Utils.isMobile):
          String captureUrl = res['data']['url'];
          Uri captureUri = Uri.parse(captureUrl);
          captchaData.token = captureUri.queryParameters['recaptcha_token']!;
          String geeGt = captureUri.queryParameters['gee_gt']!;
          String geeChallenge = captureUri.queryParameters['gee_challenge']!;

          getCaptcha(geeGt, geeChallenge, loginByPassword);
          break;
        default:
          SmartDialog.showToast(res['msg']);
          // login failed
          break;
      }
    }
    // }
  }

  // 短信验证码登录
  Future<void> loginBySmsCode() async {
    if (telTextController.text.isEmpty) {
      SmartDialog.showToast('手机号不能为空');
      return;
    }
    if (captchaKey.isEmpty) {
      SmartDialog.showToast('请先点击获取验证码');
      return;
    }
    if (smsCodeTextController.text.isEmpty) {
      SmartDialog.showToast('验证码不能为空');
      return;
    }
    if (DateTime.now().millisecondsSinceEpoch - smsSendTimestamp >
        1000 * 60 * 5) {
      SmartDialog.showToast('验证码已过期，请重新获取');
      return;
    }
    var webKeyRes = await LoginHttp.getWebKey();
    if (!webKeyRes['status']) {
      SmartDialog.showToast(webKeyRes['msg']);
      return;
    }
    String key = webKeyRes['data']['key'];
    var res = await LoginHttp.loginBySms(
      tel: telTextController.text,
      code: smsCodeTextController.text,
      captchaKey: captchaKey,
      cid: selectedCountryCodeId['country_id'],
      key: key,
    );
    if (res['status']) {
      SmartDialog.showToast('登录成功');
      var data = res['data'];
      await setAccount(data['token_info'], data['cookie_info']['cookies']);
      Get.back();
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  // app端验证码
  Future<void> sendSmsCode() async {
    if (telTextController.text.isEmpty) {
      SmartDialog.showToast('手机号不能为空');
      return;
    }
    // String? guestId;
    // var webKeyRes = await LoginHttp.getWebKey();
    // if (!webKeyRes['status']) {
    //   SmartDialog.showToast(webKeyRes['msg']);
    // } else {
    //   String key = webKeyRes['data']['key'];
    //   var guestIdRes = await LoginHttp.getGuestId(key);
    //   if (!guestIdRes['status']) {
    //     SmartDialog.showToast(guestIdRes['msg']);
    //   } else {
    //     guestId = guestIdRes['data']['guest_id'];
    //   }
    // }
    // var preCaptureRes = await LoginHttp.preCapture();
    // if (!preCaptureRes['status']) {
    //   SmartDialog.showToast("获取验证码失败，请尝试其它登录方式\n"
    //       "(${preCaptureRes['code']}) ${preCaptureRes['msg']}");
    //   return;
    // }
    // String geeGt = preCaptureRes['data']['gee_gt']!;
    // String geeChallenge = preCaptureRes['data']['gee_challenge'];
    // captchaData.token = preCaptureRes['data']['recaptcha_token']!;

    // getCaptcha(geeGt, geeChallenge, () async {

    // var safeCenterSendSmsCodeRes =
    // await LoginHttp.safeCenterSmsCode(
    //   tmpCode: currentUri.queryParameters['tmp_token']!,
    //   geeChallenge: geeChallenge,
    //   geeSeccode: captchaData.seccode!,
    //   geeValidate: captchaData.validate!,
    //   recaptchaToken: captchaData.token!,
    //   refererUrl: url,
    // );
    // if (!safeCenterSendSmsCodeRes['status']) {
    //   SmartDialog.showToast("发送短信验证码失败，请尝试其它登录方式\n"
    //       "(${safeCenterSendSmsCodeRes['code']}) ${safeCenterSendSmsCodeRes['msg']}");
    //   return;
    // }
    // SmartDialog.showToast("短信验证码已发送，请查收");
    // captchaKey = safeCenterSendSmsCodeRes['data']['captcha_key'];

    var res = await LoginHttp.sendSmsCode(
      tel: telTextController.text,
      cid: selectedCountryCodeId['country_id'],
      // deviceTouristId: guestId,
      geeValidate: captchaData.validate,
      geeSeccode: captchaData.seccode,
      geeChallenge: captchaData.geetest?.challenge,
      recaptchaToken: captchaData.token,
    );
    if (res['status']) {
      SmartDialog.showToast('发送成功');
      smsSendTimestamp = DateTime.now().millisecondsSinceEpoch;
      smsSendCooldown.value = 60;
      captchaKey = res['data']['captcha_key'];
      smsSendCooldownTimer = Timer.periodic(const Duration(seconds: 1), (
        timer,
      ) {
        smsSendCooldown.value = 60 - timer.tick;
        if (smsSendCooldown <= 0) {
          smsSendCooldownTimer?.cancel();
          smsSendCooldown.value = 0;
        }
      });
    } else {
      // handle login result
      switch (res['code']) {
        case 0:
        case -105:
          String? captureUrl = res['data']?['recaptcha_url'];
          String? geeGt;
          String? geeChallenge;
          if (captureUrl != null && captureUrl.isNotEmpty) {
            Uri captureUri = Uri.parse(captureUrl);
            captchaData.token = captureUri.queryParameters['recaptcha_token'];
            geeGt = captureUri.queryParameters['gee_gt'];
            geeChallenge = captureUri.queryParameters['gee_challenge'];
          }

          if (!isGeeArgumentValid(geeGt, geeChallenge)) {
            if (kDebugMode) {
              debugPrint(
                '验证信息错误：${res["msg"]}\n返回内容：${res["data"]}，尝试另一个验证码接口',
              );
            }
            var preCaptureRes = await LoginHttp.preCapture();
            if (!preCaptureRes['status'] || preCaptureRes['data'] == null) {
              SmartDialog.showToast(
                "获取验证码失败，请尝试其它登录方式\n"
                "(${preCaptureRes['code']}) ${preCaptureRes['msg']} ${preCaptureRes['data']}",
              );
              return;
            }
            geeGt = preCaptureRes['data']['gee_gt'];
            geeChallenge = preCaptureRes['data']['gee_challenge'];
            captchaData.token = preCaptureRes['data']['recaptcha_token'];
          }

          if (!isGeeArgumentValid(geeGt, geeChallenge)) {
            SmartDialog.showToast("获取验证码失败，请尝试其它登录方式\n");
            return;
          }

          getCaptcha(geeGt, geeChallenge, sendSmsCode);
          break;
        default:
          SmartDialog.showToast(res['msg']);
          break;
      }
    }
  }

  bool isGeeArgumentValid(String? geeGt, String? geeChallenge) {
    return geeGt?.isNotEmpty == true &&
        geeChallenge?.isNotEmpty == true &&
        captchaData.token?.isNotEmpty == true;
  }

  Future<void> setAccount(Map tokenInfo, List cookieInfo) async {
    final account = LoginAccount(
      BiliCookieJar.fromList(cookieInfo),
      tokenInfo['access_token'],
      tokenInfo['refresh_token'],
    );
    await Future.wait([account.onChange(), AnonymousAccount().delete()]);
    for (int i = 0; i < AccountType.values.length; i++) {
      if (Accounts.accountMode[i].mid == account.mid) {
        Accounts.accountMode[i] = account;
      }
    }
    if (Accounts.main.isLogin) {
      SmartDialog.showToast('登录成功');
    } else {
      SmartDialog.showToast('登录成功, 请先设置账号模式');
      await switchAccountDialog(Get.context!);
    }
  }

  static Future<void>? switchAccountDialog(BuildContext context) {
    if (Accounts.account.isEmpty) {
      SmartDialog.showToast('请先登录');
      return Get.toNamed('/loginPage');
    }
    final selectAccount = List.of(Accounts.accountMode);
    final options = {
      AnonymousAccount(): '0',
      ...Accounts.account.toMap().map(
        (k, v) => MapEntry(v, k as String),
      ),
    };
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择账号mid, 为0时使用匿名'),
        titlePadding: const EdgeInsets.only(left: 22, top: 16, right: 22),
        contentPadding: const EdgeInsets.symmetric(vertical: 5),
        actionsPadding: const EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 10,
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: AccountType.values
                .map(
                  (e) => Builder(
                    builder: (context) => RadioGroup(
                      groupValue: selectAccount[e.index],
                      onChanged: (v) {
                        selectAccount[e.index] = v!;
                        (context as Element).markNeedsBuild();
                      },
                      child: WrapRadioOptionsGroup<Account>(
                        groupTitle: e.title,
                        options: options,
                      ),
                    ),
                  ),
                )
                .toList(),
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
              for (var (i, v) in selectAccount.indexed) {
                if (v != Accounts.accountMode[i]) {
                  Accounts.set(AccountType.values[i], v);
                }
              }
              Get.back();
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}
