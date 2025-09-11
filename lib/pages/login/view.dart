import 'dart:ui';

import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:PiliPlus/pages/login/controller.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:pretty_qr_code/pretty_qr_code.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginPageController _loginPageCtr = Get.put(LoginPageController());
  // 二维码生成时间
  bool showPassword = false;
  GlobalKey globalKey = GlobalKey();

  Widget loginByQRCode(ThemeData theme) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text('使用 bilibili 官方 App 扫码登录'),
        const SizedBox(height: 20),
        Obx(
          () => Text(
            '剩余有效时间: ${_loginPageCtr.qrCodeLeftTime} 秒',
            style: TextStyle(
              fontFeatures: const [FontFeature.tabularFigures()],
              color: theme.colorScheme.primaryFixedDim,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: _loginPageCtr.refreshQRCode,
              icon: const Icon(Icons.refresh),
              label: const Text('刷新二维码'),
            ),
            TextButton.icon(
              onPressed: () async {
                SmartDialog.showLoading(msg: '正在生成截图');
                RenderRepaintBoundary boundary =
                    globalKey.currentContext!.findRenderObject()!
                        as RenderRepaintBoundary;
                var image = await boundary.toImage(pixelRatio: 3);
                ByteData? byteData = await image.toByteData(
                  format: ImageByteFormat.png,
                );
                Uint8List pngBytes = byteData!.buffer.asUint8List();
                SmartDialog.dismiss();
                String picName = "PiliPlus_loginQRCode_${ImageUtils.time}";
                ImageUtils.saveByteImg(bytes: pngBytes, fileName: picName);
              },
              icon: const Icon(Icons.save),
              label: const Text('保存至相册'),
            ),
          ],
        ),
        RepaintBoundary(
          key: globalKey,
          child: Obx(() {
            if (_loginPageCtr.codeInfo['data']?['url'] == null) {
              return Container(
                height: 200,
                width: 200,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  semanticsLabel: '二维码加载中',
                ),
              );
            }
            return Container(
              width: 200,
              height: 200,
              color: Colors.white,
              padding: const EdgeInsets.all(8),
              child: PrettyQrView.data(
                data: _loginPageCtr.codeInfo['data']!['url']!,
                decoration: const PrettyQrDecoration(
                  shape: PrettyQrSquaresSymbol(
                    color: Colors.black87,
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 10),
        Obx(
          () => Text(
            _loginPageCtr.statusQRCode.value,
            style: TextStyle(color: theme.colorScheme.secondaryFixedDim),
          ),
        ),
        Obx(
          () => GestureDetector(
            onTap: () => Utils.copyText(
              _loginPageCtr.codeInfo['data']?['url'] ?? '',
              toastText: '已复制到剪贴板，可粘贴至已登录的app私信处发送，然后点击已发送的链接打开',
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                _loginPageCtr.codeInfo['data']?['url'] ?? "",
                style: theme.textTheme.labelSmall!.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '请务必在 PiliPlus 开源仓库等可信渠道下载安装。',
            style: theme.textTheme.labelSmall!.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ),
      ],
    );
  }

  Widget loginByCookie(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),
        const Text('使用Cookie登录'),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '使用App端Api实现的功能将不可用',
            style: theme.textTheme.labelMedium!.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextField(
            minLines: 1,
            maxLines: 10,
            controller: _loginPageCtr.cookieTextController,
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s"))],
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.cookie_outlined),
              border: const UnderlineInputBorder(),
              labelText: 'Cookie',
              suffixIcon: IconButton(
                onPressed: _loginPageCtr.cookieTextController.clear,
                icon: const Icon(Icons.clear),
              ),
            ),
          ),
        ),
        OutlinedButton.icon(
          onPressed: _loginPageCtr.loginByCookie,
          icon: const Icon(Icons.login),
          label: const Text('登录'),
        ),
      ],
    );
  }

  Widget loginByPassword(ThemeData theme) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text('使用账号密码登录'),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextField(
            controller: _loginPageCtr.usernameTextController,
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s"))],
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.account_box),
              border: const UnderlineInputBorder(),
              labelText: '账号',
              hintText: '邮箱/手机号',
              suffixIcon: IconButton(
                onPressed: _loginPageCtr.usernameTextController.clear,
                icon: const Icon(Icons.clear),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextField(
            obscureText: !showPassword,
            keyboardType: TextInputType.visiblePassword,
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s"))],
            controller: _loginPageCtr.passwordTextController,
            autofillHints: const [AutofillHints.password],
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.password),
              border: const UnderlineInputBorder(),
              labelText: '密码',
              suffixIcon: IconButton(
                onPressed: _loginPageCtr.passwordTextController.clear,
                icon: const Icon(Icons.clear),
              ),
            ),
          ),
        ),
        Row(
          children: [
            const SizedBox(width: 10),
            Checkbox(
              value: showPassword,
              onChanged: (value) {
                setState(() {
                  showPassword = value!;
                });
              },
            ),
            const Text('显示密码'),
            const Spacer(),
            TextButton(
              onPressed: () {
                //https://passport.bilibili.com/h5-app/passport/login/findPassword
                //https://passport.bilibili.com/passport/findPassword
                showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      clipBehavior: Clip.hardEdge,
                      title: const Text('忘记密码？'),
                      contentPadding: const EdgeInsets.fromLTRB(
                        0.0,
                        2.0,
                        0.0,
                        16.0,
                      ),
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(25, 0, 25, 10),
                          child: Text("试试扫码、手机号登录，或选择"),
                        ),
                        ListTile(
                          title: const Text(
                            '找回密码（手机版）',
                          ),
                          leading: const Icon(Icons.smartphone_outlined),
                          subtitle: const Text(
                            'https://passport.bilibili.com/h5-app/passport/login/findPassword',
                          ),
                          dense: false,
                          onTap: () => Get
                            ..back()
                            ..toNamed(
                              '/webview',
                              parameters: {
                                'url':
                                    'https://passport.bilibili.com/h5-app/passport/login/findPassword',
                                'type': 'url',
                                'pageTitle': '忘记密码',
                              },
                            ),
                        ),
                        ListTile(
                          title: const Text(
                            '找回密码（电脑版）',
                          ),
                          leading: const Icon(Icons.desktop_windows_outlined),
                          subtitle: const Text(
                            'https://passport.bilibili.com/pc/passport/findPassword',
                          ),
                          dense: false,
                          onTap: () => Get
                            ..back()
                            ..toNamed(
                              '/webview',
                              parameters: {
                                'url':
                                    'https://passport.bilibili.com/pc/passport/findPassword',
                                'type': 'url',
                                'pageTitle': '忘记密码',
                                'uaType': 'pc',
                              },
                            ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('忘记密码'),
            ),
            const SizedBox(width: 20),
          ],
        ),
        OutlinedButton.icon(
          onPressed: _loginPageCtr.loginByPassword,
          icon: const Icon(Icons.login),
          label: const Text('登录'),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '根据 bilibili 官方登录接口规范，密码将在本地加盐、加密后传输。\n'
            '盐与公钥均由官方提供；以 RSA/ECB/PKCS1Padding 方式加密。\n'
            '账号密码仅用于该登录接口，不予保存；本地仅存储登录凭证。\n'
            '请务必在 PiliPlus 开源仓库等可信渠道下载安装。',
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall!.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ),
      ],
    );
  }

  Widget loginBySmS(ThemeData theme) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text('使用手机短信验证码登录'),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: DecoratedBox(
            decoration: UnderlineTabIndicator(
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                Builder(
                  builder: (context) {
                    return PopupMenuButton<Map<String, dynamic>>(
                      padding: EdgeInsets.zero,
                      tooltip:
                          '选择国际冠码，'
                          '当前为${_loginPageCtr.selectedCountryCodeId['cname']}，'
                          '+${_loginPageCtr.selectedCountryCodeId['country_id']}',
                      onSelected: (Map<String, dynamic> type) {},
                      initialValue: _loginPageCtr.selectedCountryCodeId,
                      itemBuilder: (_) => _loginPageCtr
                          .internationalDialingPrefix
                          .map((Map<String, dynamic> item) {
                            return PopupMenuItem<Map<String, dynamic>>(
                              onTap: () {
                                _loginPageCtr.selectedCountryCodeId = item;
                                (context as Element).markNeedsBuild();
                              },
                              value: item,
                              child: Row(
                                children: [
                                  Text(item['cname']),
                                  const Spacer(),
                                  Text("+${item['country_id']}"),
                                ],
                              ),
                            );
                          })
                          .toList(),
                      child: Row(
                        children: [
                          Icon(
                            Icons.phone,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "+${_loginPageCtr.selectedCountryCodeId['country_id']}",
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(width: 6),
                SizedBox(
                  height: 24,
                  child: VerticalDivider(
                    color: theme.colorScheme.outline.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: TextField(
                    controller: _loginPageCtr.telTextController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: '手机号',
                      suffixIcon: IconButton(
                        onPressed: _loginPageCtr.telTextController.clear,
                        icon: const Icon(Icons.clear),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: DecoratedBox(
            decoration: UnderlineTabIndicator(
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _loginPageCtr.smsCodeTextController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.sms_outlined),
                      border: InputBorder.none,
                      labelText: '验证码',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                Obx(
                  () => TextButton.icon(
                    onPressed: _loginPageCtr.smsSendCooldown > 0
                        ? null
                        : _loginPageCtr.sendSmsCode,
                    icon: const Icon(Icons.send),
                    label: Text(
                      _loginPageCtr.smsSendCooldown > 0
                          ? '等待${_loginPageCtr.smsSendCooldown}秒'
                          : '获取验证码',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: _loginPageCtr.loginBySmsCode,
          icon: const Icon(Icons.login),
          label: const Text('登录'),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '手机号仅用于 bilibili 官方发送验证码与登录接口，不予保存；\n'
            '本地仅存储登录凭证。\n'
            '请务必在 PiliPlus 开源仓库等可信渠道下载安装。',
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall!.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ),
      ],
    );
  }

  late EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    padding =
        MediaQuery.viewPaddingOf(context).copyWith(top: 0) +
        const EdgeInsets.only(bottom: 25);
    final isLandscape = !MediaQuery.sizeOf(context).isPortrait;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: '关闭',
          icon: const Icon(Icons.close_outlined),
          onPressed: Get.back,
        ),
        title: Row(
          children: [
            const Text('登录'),
            if (isLandscape)
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TabBar(
                    isScrollable: true,
                    dividerHeight: 0,
                    tabs: const [
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [Icon(Icons.password), Text(' 密码')],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [Icon(Icons.sms_outlined), Text(' 短信')],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [Icon(Icons.qr_code), Text(' 扫码')],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.cookie_outlined),
                            Text(' Cookie'),
                          ],
                        ),
                      ),
                    ],
                    controller: _loginPageCtr.tabController,
                  ),
                ),
              ),
          ],
        ),
        bottom: !isLandscape
            ? TabBar(
                tabs: const [
                  Tab(icon: Icon(Icons.password), text: '密码'),
                  Tab(icon: Icon(Icons.sms_outlined), text: '短信'),
                  Tab(icon: Icon(Icons.qr_code), text: '扫码'),
                  Tab(icon: Icon(Icons.cookie_outlined), text: 'Cookie'),
                ],
                controller: _loginPageCtr.tabController,
              )
            : null,
      ),
      body: NotificationListener<ScrollStartNotification>(
        onNotification: (notification) {
          if (notification.metrics.axis == Axis.horizontal) {
            FocusScope.of(context).unfocus();
          }
          return false;
        },
        child: tabBarView(
          controller: _loginPageCtr.tabController,
          children: [
            tabViewOuter(loginByPassword(theme)),
            tabViewOuter(loginBySmS(theme)),
            tabViewOuter(loginByQRCode(theme)),
            tabViewOuter(loginByCookie(theme)),
          ],
        ),
      ),
    );
  }

  Widget tabViewOuter(Widget child) {
    return SingleChildScrollView(
      padding: padding,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: child,
        ),
      ),
    );
  }
}
