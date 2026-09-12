import 'package:PiliPlus/http/scan_login.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// 扫码授权登录：用当前主账号（TV / HD 端凭证）扫描 B 站 Web / TV 登录二维码完成授权。
class ScanLoginController {
  final MobileScannerController scannerController = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  bool _handling = false;

  void dispose() {
    scannerController.dispose();
  }

  /// 取当前主账号：必须已登录且持有 access_key 才能代为授权
  /// （Cookie 方式登录没有 access_key，无法签名授权）
  static LoginAccount? get account {
    final main = Accounts.main;
    if (main is LoginAccount && (main.accessKey?.isNotEmpty ?? false)) {
      return main;
    }
    return null;
  }

  static bool get canScan => account != null;

  void onDetect(BarcodeCapture capture) {
    if (_handling) return;
    final raw = capture.barcodes.isEmpty
        ? null
        : capture.barcodes.first.rawValue;
    if (raw == null || raw.isEmpty) return;
    _handling = true;
    _handle(raw).whenComplete(() => _handling = false);
  }

  Future<void> _handle(String raw) async {
    final authCode = _extract(raw, 'auth_code');
    final qrcodeKey = _extract(raw, 'qrcode_key');
    if (authCode == null && qrcodeKey == null) {
      SmartDialog.showToast('未识别到 B 站登录二维码');
      return;
    }

    final current = account;
    if (current == null) {
      SmartDialog.showToast('请先用 TV 端 / HD 端扫码登录主账号');
      return;
    }
    final accessKey = current.accessKey!;
    final csrf = current.csrf;

    if (authCode != null) {
      await _confirmTv(accessKey, authCode, csrf);
    } else if (qrcodeKey != null) {
      await _confirmWeb(accessKey, qrcodeKey, csrf);
    }
  }

  static String? _extract(String raw, String name) {
    final uri = Uri.tryParse(raw);
    if (uri != null && uri.hasQuery) {
      final value = uri.queryParameters[name];
      if (value != null && value.isNotEmpty) return value;
    }
    final match = RegExp('$name=([0-9a-zA-Z]+)').firstMatch(raw);
    return match?.group(1);
  }

  /// TV 端授权：确认后由 TV 端自行轮询领取登录态
  Future<void> _confirmTv(
    String accessKey,
    String authCode,
    String csrf,
  ) async {
    SmartDialog.showLoading(msg: '正在授权 TV 登录…');
    final res = await ScanLoginHttp.tvConfirm(
      accessKey: accessKey,
      authCode: authCode,
      csrf: csrf,
    );
    SmartDialog.dismiss();
    if (res['status'] == true) {
      SmartDialog.showToast('TV 扫码授权成功');
      Get.back();
    } else {
      SmartDialog.showToast('授权失败：${res['msg']}（${res['code']}）');
    }
  }

  /// Web 端授权：check → scene → confirm，Web 端自行轮询领取登录态
  Future<void> _confirmWeb(
    String accessKey,
    String qrcodeKey,
    String csrf,
  ) async {
    SmartDialog.showLoading(msg: '正在授权网页登录…');
    final check = await ScanLoginHttp.webQrcodeCheck(
      accessKey: accessKey,
      csrf: csrf,
      qrcodeKey: qrcodeKey,
    );
    if (check['code'] != 0) {
      SmartDialog.dismiss();
      SmartDialog.showToast('扫码确认失败：${check['msg']}（${check['code']}）');
      return;
    }
    final scene = await ScanLoginHttp.webQrcodeScene(
      accessKey: accessKey,
      csrf: csrf,
      qrcodeKey: qrcodeKey,
    );
    if (scene['code'] != 0) {
      SmartDialog.dismiss();
      SmartDialog.showToast('扫码确认失败：${scene['msg']}（${scene['code']}）');
      return;
    }
    final data = scene['data'] as Map?;
    final confirm = await ScanLoginHttp.webQrcodeConfirm(
      accessKey: accessKey,
      csrf: csrf,
      qrcodeKey: qrcodeKey,
      transient: data?['transient'] == true ? 'true' : 'false',
    );
    SmartDialog.dismiss();
    if (confirm['code'] == 0) {
      SmartDialog.showToast('网页扫码授权成功');
      Get.back();
    } else {
      SmartDialog.showToast('确认失败：${confirm['msg']}（${confirm['code']}）');
    }
  }
}
