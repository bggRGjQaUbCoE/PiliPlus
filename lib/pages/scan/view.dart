import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/common/widgets/route_aware_mixin.dart';
import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/pages/scan/login.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage>
    with RouteAware, RouteAwareMixin, WidgetsBindingObserver {
  final _controller = MobileScannerController(
    autoStart: false,
    formats: const [BarcodeFormat.qrCode],
    detectionTimeoutMs: 500,
    cameraResolution: const Size(1280, 720),
  );
  bool _busy = false;
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller.start();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _resumeCamera() async {
    if (mounted &&
        _visible &&
        !_busy &&
        _controller.value.hasCameraPermission &&
        !_controller.value.isStarting) {
      await _controller.start();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _resumeCamera();
    } else if (state == AppLifecycleState.inactive) {
      _controller.stop();
    }
  }

  @override
  void didPushNext() {
    _visible = false;
    _controller.stop();
  }

  @override
  void didPopNext() {
    _visible = true;
    _resumeCamera();
  }

  Future<void> _handleCode(String text) async {
    if (_busy) return;
    _busy = true;
    await _controller.stop();
    try {
      final uri = Uri.tryParse(text.trim());
      final key = uri?.queryParameters['qrcode_key'];
      final isLogin =
          uri != null &&
          (uri.scheme == 'https' || uri.scheme == 'http') &&
          const {
            'account.bilibili.com',
            'app.bilibili.com',
            'passport.bilibili.com',
          }.contains(uri.host) &&
          const {
            '/h5/account-h5/auth/scan-web',
            '/qrcode/h5/login',
          }.contains(uri.path);
      if (isLogin && key != null && key.isNotEmpty) {
        if (!Accounts.main.isLogin) {
          await Get.toNamed('/loginPage');
        }
        if (!mounted || !Accounts.main.isLogin) return;
        final authorized = await Get.to<bool>(
          () => ScanLoginPage(qrcodeKey: key, account: Accounts.main),
        );
        if (authorized == true && mounted) {
          _visible = false;
          Get.back();
        }
      } else if (uri != null &&
          const {'http', 'https', 'bilibili'}.contains(uri.scheme)) {
        await PiliScheme.routePush(uri);
      } else {
        if (!mounted) return;
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('扫码结果'),
            content: SingleChildScrollView(child: SelectableText(text)),
            actions: [
              TextButton(onPressed: Get.back, child: const Text('关闭')),
              TextButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: text));
                  SmartDialog.showToast('已复制');
                  Get.back();
                },
                child: const Text('复制'),
              ),
            ],
          ),
        );
      }
    } finally {
      _busy = false;
      await _resumeCamera();
    }
  }

  Future<void> _pickImage() async {
    if (_busy) return;
    _busy = true;
    await _controller.stop();
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null || !mounted) return;
      final capture = await _controller.analyzeImage(
        image.path,
        formats: _controller.formats,
      );
      final text = capture?.barcodes.firstOrNull?.rawValue;
      if (!mounted) return;
      if (text == null) {
        SmartDialog.showToast('未识别到二维码');
      } else {
        _busy = false;
        await _handleCode(text);
      }
    } on MobileScannerBarcodeException {
      SmartDialog.showToast('未识别到二维码');
    } on PlatformException catch (e) {
      SmartDialog.showToast(e.message ?? '无法读取图片');
    } finally {
      _busy = false;
      await _resumeCamera();
    }
  }

  Widget _buildCameraError(
    BuildContext context,
    MobileScannerException error,
  ) {
    return ColoredBox(
      color: ColorScheme.of(context).surface,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              error.errorCode == MobileScannerErrorCode.permissionDenied
                  ? '请在系统设置中允许相机权限'
                  : '无法打开相机',
            ),
            TextButton(
              onPressed: _controller.value.isStarting
                  ? null
                  : _controller.start,
              child: const Text('重试'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SimpleScaffold(
      appBar: AppBar(title: const Text('扫一扫')),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: _controller,
              placeholderBuilder: (_) => m3eLoading,
              errorBuilder: _buildCameraError,
              onDetect: (capture) {
                final text = capture.barcodes.firstOrNull?.rawValue;
                if (text != null) _handleCode(text);
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('相册'),
                  ),
                  ValueListenableBuilder<MobileScannerState>(
                    valueListenable: _controller,
                    builder: (context, value, child) => TextButton.icon(
                      onPressed:
                          value.isRunning &&
                              value.torchState != TorchState.unavailable
                          ? _controller.toggleTorch
                          : null,
                      icon: Icon(
                        value.torchState == TorchState.on
                            ? Icons.flashlight_off_outlined
                            : Icons.flashlight_on_outlined,
                      ),
                      label: const Text('闪光灯'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
