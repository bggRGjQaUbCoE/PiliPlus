import 'dart:async' show unawaited;
import 'dart:io' show Platform;

import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/common/widgets/view_insets_safe_area.dart';
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

class _ScanAuthPageState extends State<ScanAuthPage>
    with WidgetsBindingObserver {
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
  // LoginAccount 的 ==/hashCode 读 mid（late final，缺 cookie 会抛），用身份比较
  final Map<LoginAccount, String> _names = Map.identity();
  LoginAccount? _selected;
  ScanQrType? _type;
  String? _key;
  bool _submitting = false;

  /// 相机是否处于扫描态。扫到二维码后置 false，由「重新扫描」重置
  bool _scanning = true;

  @override
  void initState() {
    super.initState();
    // 传入 controller 时 MobileScanner 不注册生命周期观察者，需自行处理
    WidgetsBinding.instance.addObserver(this);
    _accounts.addAll(Accounts.account.values);
    _selected = _firstUsable();
    for (final account in _accounts) {
      _loadName(account);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scanner?.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == .resumed) {
      // 扫到二维码后 _scanning 为 false，回前台不重启相机
      if (_scanning) unawaited(_safeStart());
    } else {
      unawaited(_safeStop());
    }
  }

  Future<void> _safeStart() async {
    try {
      await _scanner?.start();
    } catch (_) {
      // 相机被占用等错误由 MobileScanner 的 errorBuilder 呈现
    }
  }

  Future<void> _safeStop() async {
    try {
      await _scanner?.stop();
    } catch (_) {
      // stop 失败无需处理，退到后台相机本就不可用
    }
  }

  /// mid 是 late final，登录态异常（缺 DedeUserID cookie）时会抛，这里兜成 null
  static int? _midOf(LoginAccount account) {
    try {
      return account.mid;
    } catch (_) {
      return null;
    }
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
    final mid = _midOf(account);
    if (mid == null) {
      return;
    }
    final res = await MemberHttp.memberCardInfo(mid: mid);
    final name = res.dataOrNull?.card?.name;
    if (!mounted || name == null || name.isEmpty) {
      return;
    }
    setState(() => _names[account] = name);
  }

  void _apply(String raw) {
    final parsed = ScanAuth.parse(raw);
    if (parsed == null) {
      SmartDialog.showToast('无法识别，请确认是哔哩哔哩的登录二维码');
      return;
    }
    setState(() {
      // 裸 key 没有类型线索时保留用户已选（或让用户手动选）
      if (parsed.$1 != null) {
        _type = parsed.$1;
      }
      _key = parsed.$2;
      _scanning = false;
    });
    // 已拿到内容，停掉相机省电并避免同一帧重复触发
    unawaited(_safeStop());
    SmartDialog.showToast('已获取二维码');
  }

  void _rescan() {
    // 置回扫描态会重新挂载 MobileScanner，其 autoStart 会自行恢复相机
    setState(() {
      _scanning = true;
      _key = null;
    });
  }

  Future<void> _confirm() async {
    final account = _selected;
    final key = _key;
    final type = _type;
    if (key == null) {
      SmartDialog.showToast('请先扫描或粘贴登录二维码');
      return;
    }
    if (type == null) {
      SmartDialog.showToast('请选择二维码类型：网页端或 TV 端');
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
      // code == -1 时 Request.post 已经 toast 过网络错误，不再重复弹
      case Error(:final errMsg, :final code):
        if (code != -1) {
          SmartDialog.showToast(errMsg ?? '扫码授权失败');
        }
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
      // SimpleScaffold 不处理键盘 inset，套既有组件避免输入框被遮挡
      body: ViewInsetsSafeArea(
        child: ListView(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: MediaQuery.viewPaddingOf(context).bottom + 24,
          ),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                    _type == null
                        ? '请选择类型'
                        : (_type == ScanQrType.web ? '网页端' : 'TV 端'),
                    style: theme.textTheme.bodySmall,
                  ),
              ],
            ),
            if (_key != null) ...[
              Wrap(
                spacing: 8,
                children: [
                  for (final type in ScanQrType.values)
                    ChoiceChip(
                      label: Text(type == ScanQrType.web ? '网页端' : 'TV 端'),
                      selected: _type == type,
                      onSelected: (_) => setState(() => _type = type),
                    ),
                ],
              ),
            ],
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
      ),
    );
  }

  Widget _buildScanner(ThemeData theme) {
    final scanner = _scanner!;
    // 扫到内容后相机已停，给一个明确的重新扫描入口（检测流不会自己恢复）
    if (!_scanning) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            const Icon(Icons.qr_code_scanner, size: 32),
            const SizedBox(height: 8),
            Text('已读取二维码', style: theme.textTheme.bodyMedium),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _rescan,
              icon: const Icon(Icons.refresh),
              label: const Text('重新扫描'),
            ),
          ],
        ),
      );
    }
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
                if (!_scanning || capture.barcodes.isEmpty) {
                  return;
                }
                final raw = capture.barcodes.first.rawValue;
                if (raw != null && raw.isNotEmpty) {
                  _apply(raw);
                }
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ValueListenableBuilder<MobileScannerState>(
                  valueListenable: scanner,
                  builder: (context, state, child) {
                    if (state.torchState == TorchState.unavailable) {
                      return child!;
                    }
                    final on = state.torchState == TorchState.on;
                    return IconButton(
                      tooltip: on ? '关闭手电筒' : '手电筒',
                      style: IconButton.styleFrom(
                        backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      ),
                      onPressed: _toggleTorch,
                      icon: Icon(
                        on
                            ? Icons.flashlight_on
                            : Icons.flashlight_off_outlined,
                      ),
                    );
                  },
                  child: const SizedBox.shrink(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleTorch() async {
    try {
      await _scanner?.toggleTorch();
    } catch (_) {
      // 相机未初始化或已释放时 toggleTorch 会抛，忽略即可
    }
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
    final name = _names[account];
    // mid 是 late final，登录态异常时取不到，用占位文案避免整页崩溃
    final mid = _midOf(account);
    final midText = mid == null ? 'UID 未知' : 'UID $mid';
    return ListTile(
      contentPadding: EdgeInsets.zero,
      enabled: reason == null,
      onTap: reason == null ? () => setState(() => _selected = account) : null,
      leading: Icon(
        reason == null
            ? (selected ? Icons.check_circle : Icons.account_circle_outlined)
            : Icons.block,
      ),
      title: Text(name ?? midText),
      subtitle: Text(reason ?? midText),
      trailing: selected && reason == null
          ? Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.primary)
          : null,
    );
  }
}
