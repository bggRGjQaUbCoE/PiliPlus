import 'dart:async';

import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/login.dart';
import 'package:PiliPlus/pages_tv/common/tv_focus_wrapper.dart';
import 'package:PiliPlus/pages_tv/common/tv_page.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/models/common/account_type.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/login_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class TVLoginPage extends StatefulWidget {
  const TVLoginPage({super.key});

  @override
  State<TVLoginPage> createState() => _TVLoginPageState();
}

class _TVLoginPageState extends State<TVLoginPage> {
  final _codeState =
      Rx<LoadingState<({String authCode, String url})>>(LoadingState.loading());
  final _status = ''.obs;
  final _leftTime = 180.obs;
  Timer? _pollTimer;
  Timer? _countdownTimer;
  bool _isPolling = false;

  @override
  void initState() {
    super.initState();
    _refreshQRCode();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _refreshQRCode() async {
    _codeState.value = LoadingState.loading();
    final res = await LoginHttp.getHDcode();
    _codeState.value = res;
    if (res case Success(:final response)) {
      _leftTime.value = 180;
      _status.value = '';
      _pollTimer?.cancel();
      _countdownTimer?.cancel();

      _countdownTimer =
          Timer.periodic(const Duration(seconds: 1), (timer) {
        final left = 180 - timer.tick;
        if (left <= 0) {
          timer.cancel();
          _pollTimer?.cancel();
          _status.value = '二维码已过期，请刷新';
          _leftTime.value = 0;
          return;
        }
        _leftTime.value = left;
      });

      _pollTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
        if (_isPolling) return;
        if (_leftTime.value <= 0) {
          timer.cancel();
          return;
        }
        _isPolling = true;
        try {
          final poll = await LoginHttp.codePoll(response.authCode);
          if (poll['status'] == true) {
            timer.cancel();
            _countdownTimer?.cancel();
            _status.value = '登录成功';
            final data = poll['data'];
            final account = LoginAccount(
              BiliCookieJar.fromList(data['cookie_info']['cookies']),
              data['token_info']['access_token'],
              data['token_info']['refresh_token'],
            );
            await Future.wait(
                [account.onChange(), AnonymousAccount().delete()]);
            for (int i = 0; i < AccountType.values.length; i++) {
              if (Accounts.accountMode[i].mid == account.mid) {
                Accounts.accountMode[i] = account;
              }
            }
            if (!Accounts.main.isLogin) {
              Accounts.accountMode[AccountType.main.index] = account;
            }
            Request.setCookie();
            await LoginUtils.onLoginMain();
            Get.offAllNamed('/');
          } else if (poll['code'] == 86038) {
            timer.cancel();
            _countdownTimer?.cancel();
            _status.value = '二维码已过期';
            _leftTime.value = 0;
          } else if (poll['code'] == 86090) {
            _status.value = '已扫码，请确认';
          }
        } finally {
          _isPolling = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TVPage(
      child: Scaffold(
        appBar: AppBar(title: const Text('登录')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '使用哔哩哔哩手机客户端扫码登录',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              Obx(() {
                final state = _codeState.value;
                return switch (state) {
                  Loading() => const SizedBox(
                      width: 240,
                      height: 240,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  Success(:final response) => Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SizedBox(
                            width: 220,
                            height: 220,
                            child: PrettyQrView.data(
                              data: response.url,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Obx(() => Text(
                              _status.value.isNotEmpty
                                  ? _status.value
                                  : '剩余 ${_leftTime.value} 秒',
                              style: theme.textTheme.bodyLarge,
                            )),
                      ],
                    ),
                  Error(:final errMsg) => Column(
                      children: [
                        Text(errMsg ?? '获取二维码失败'),
                        const SizedBox(height: 12),
                        TVFocusWrapper(
                          autoFocus: true,
                          onSelect: _refreshQRCode,
                          child: const Padding(
                            padding: EdgeInsets.all(12),
                            child: Text('重新获取'),
                          ),
                        ),
                      ],
                    ),
                };
              }),
              const SizedBox(height: 24),
              TVFocusWrapper(
                autoFocus: true,
                onSelect: _refreshQRCode,
                borderRadius: 24,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    '刷新二维码',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
