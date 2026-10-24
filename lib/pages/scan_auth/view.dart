import 'dart:io' show Platform;

import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/member.dart';
import 'package:PiliPlus/http/scan_auth.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// 扫码授权：扫描其它端的登录二维码，用本机已登录的账号确认登录
class ScanAuthPage extends StatefulWidget {
  const ScanAuthPage({super.key});

  @override
  State<ScanAuthPage> createState() => _ScanAuthPageState();
}

class _ScanAuthPageState extends State<ScanAuthPage> {
  /// mobile_scanner 只支持 android/ios/macos，其余平台只能粘贴内容
  static final bool _supportCamera = PlatformUtils.isMobile || Platform.isMacOS;

  late final MobileScannerController? _scanner = _supportCamera
      ? MobileScannerController(
          formats: const [BarcodeFormat.qrCode],
          detectionSpeed: DetectionSpeed.noDuplicates,
        )
      : null;
  final TextEditingController _textController = TextEditingController();
  final List<LoginAccount> _accounts = [];
  final Map<int, String> _names = {};
  LoginAccount? _selected;
  ScanQrType? _type;
  String? _key;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _accounts.addAll(Accounts.account.values);
    _selected = _firstUsable();
    for (final account in _accounts) {
      _loadName(account);
    }
  }

  @override
  void dispose() {
    _scanner?.dispose();
    _textController.dispose();
    super.dispose();
  }

  LoginAccount? _firstUsable() {
    for (final account in _accounts) {
      if (ScanAuth.unavailableReason(account) == null) {
        return account;
      }
    }
    return _accounts.isEmpty ? null : _accounts.first;
  }

  Future<void> _loadName(LoginAccount account) async {
    final res = await MemberHttp.memberCardInfo(mid: account.mid);
    final name = res.dataOrNull?.card?.name;
    if (!mounted || name == null || name.isEmpty) {
      return;
    }
    setState(() => _names[account.mid] = name);
  }

  void _apply(String raw) {
    final parsed = ScanAuth.parse(raw);
    if (parsed == null) {
      SmartDialog.showToast('无法识别，请确认是哔哩哔哩的登录二维码');
      return;
    }
    setState(() {
      _type = parsed.$1;
      _key = parsed.$2;
    });
    SmartDialog.showToast('已获取二维码');
  }

  Future<void> _confirm() async {
    final account = _selected;
    final key = _key;
    final type = _type;
    if (key == null || type == null) {
      SmartDialog.showToast('请先扫描或粘贴登录二维码');
      return;
    }
    if (account == null) {
      SmartDialog.showToast('没有可用的账号');
      return;
    }
    final reason = ScanAuth.unavailableReason(account);
    if (reason != null) {
      SmartDialog.showToast(reason);
      return;
    }
    setState(() => _submitting = true);
    final res = await ScanAuth.confirm(account: account, type: type, key: key);
    if (!mounted) {
      return;
    }
    setState(() => _submitting = false);
    switch (res) {
      case Success(:final response):
        SmartDialog.showToast('$response');
        Get.back();
      case Error(:final errMsg):
        SmartDialog.showToast(errMsg ?? '扫码授权失败');
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SimpleScaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: '关闭',
          icon: const Icon(Icons.close_outlined),
          onPressed: Get.back,
        ),
        title: const Text('扫码授权'),
      ),
      body: ListView(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 12,
          bottom: MediaQuery.viewPaddingOf(context).bottom + 24,
        ),
        children: [
          if (_supportCamera)
            _buildScanner(theme)
          else
            _buildNoCameraHint(theme),
          const SizedBox(height: 12),
          TextField(
            controller: _textController,
            minLines: 1,
            maxLines: 3,
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'\s')),
            ],
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.qr_code_2),
              border: const UnderlineInputBorder(),
              labelText: '二维码内容',
              hintText: '也可以粘贴二维码链接后点识别',
              suffixIcon: IconButton(
                tooltip: '识别',
                onPressed: () => _apply(_textController.text),
                icon: const Icon(Icons.input),
              ),
            ),
            onSubmitted: _apply,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text('授权账号', style: theme.textTheme.titleSmall),
              const Spacer(),
              if (_key != null)
                Text(
                  _type == ScanQrType.web ? '网页端' : 'TV 端',
                  style: theme.textTheme.bodySmall,
                ),
            ],
          ),
          const SizedBox(height: 4),
          if (_accounts.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text('没有已登录的账号', style: theme.textTheme.bodyMedium),
            )
          else
            ..._accounts.map(_buildAccountTile),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _submitting ? null : _confirm,
            child: _submitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('确认授权'),
          ),
        ],
      ),
    );
  }

  Widget _buildScanner(ThemeData theme) {
    final scanner = _scanner!;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          fit: StackFit.expand,
          children: [
            MobileScanner(
              controller: scanner,
              onDetect: (capture) {
                if (_key != null || capture.barcodes.isEmpty) {
                  return;
                }
                final raw = capture.barcodes.first.rawValue;
                if (raw != null && raw.isNotEmpty) {
                  _apply(raw);
                }
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: IconButton(
                  tooltip: '手电筒',
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  ),
                  onPressed: () => _scanner?.toggleTorch(),
                  icon: const Icon(Icons.flashlight_on_outlined),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoCameraHint(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.no_photography_outlined),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '当前平台不支持调用相机扫码，请粘贴二维码内容后点识别',
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountTile(LoginAccount account) {
    final reason = ScanAuth.unavailableReason(account);
    final selected = _selected == account;
    final name = _names[account.mid];
    return ListTile(
      contentPadding: EdgeInsets.zero,
      enabled: reason == null,
      onTap: reason == null ? () => setState(() => _selected = account) : null,
      leading: Icon(
        reason == null
            ? (selected ? Icons.check_circle : Icons.account_circle_outlined)
            : Icons.block,
      ),
      title: Text(name ?? 'UID ${account.mid}'),
      subtitle: Text(reason ?? 'UID ${account.mid}'),
      trailing: selected && reason == null
          ? Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.primary)
          : null,
    );
  }
}
