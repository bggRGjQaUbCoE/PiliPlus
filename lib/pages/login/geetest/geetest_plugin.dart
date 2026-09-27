import 'dart:async' show Completer;
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gt3_flutter_plugin/gt3_flutter_plugin.dart';

abstract final class GeetestPlugin {
  static Future<Map<String, dynamic>?> geetest(String gt, String challenge) {
    final completer = Completer<Map<String, dynamic>?>();
    void complete([Map<String, dynamic>? result]) {
      if (!completer.isCompleted) {
        completer.complete(result);
      }
    }

    final registerData = Gt3RegisterData(
      challenge: challenge,
      gt: gt,
      success: true,
    );

    Gt3FlutterPlugin()
      ..addEventHandler(
        onShow: (Map<String, dynamic> message) {},
        onClose: (Map<String, dynamic> message) {
          SmartDialog.showToast('关闭验证');
          complete();
        },
        onResult: (Map<String, dynamic> message) {
          if (kDebugMode) debugPrint("Captcha result: $message");
          final String code = message["code"];
          if (code == "1") {
            // 发送 message["result"] 中的数据向 B 端的业务服务接口进行查询
            complete(Map<String, dynamic>.from(message['result']));
            return;
          } else {
            // 终端用户完成验证失败，自动重试 If the verification fails, it will be automatically retried.
            if (kDebugMode) debugPrint("Captcha result code : $code");
          }
          complete();
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
          complete();
        },
      )
      ..startCaptcha(registerData);

    return completer.future;
  }
}
