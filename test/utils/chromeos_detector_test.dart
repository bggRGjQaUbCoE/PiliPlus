import 'package:PiliPlus/utils/chromeos_detector.dart';
import 'package:flutter_test/flutter_test.dart';

/// 普通 Android 手机
const _phoneFingerprint = 'google/husky/husky:14/AP1A/123:user/release-keys';
const _phoneProduct = 'husky';
const _phoneDevice = 'husky';
const _phoneBrand = 'google';
const _phoneManufacturer = 'Google';

bool _detect({
  String fingerprint = _phoneFingerprint,
  String product = _phoneProduct,
  String device = _phoneDevice,
  String brand = _phoneBrand,
  String manufacturer = _phoneManufacturer,
  List<String> systemFeatures = const [],
}) {
  return ChromeOSDetector.isChromeOS(
    fingerprint: fingerprint,
    product: product,
    device: device,
    brand: brand,
    manufacturer: manufacturer,
    systemFeatures: systemFeatures,
  );
}

void main() {
  group('ChromeOSDetector 强信号', () {
    test('cros_device_management 特性命中', () {
      expect(
        _detect(
          systemFeatures: const [
            'android.hardware.camera',
            'com.google.android.feature.cros_device_management',
          ],
        ),
        isTrue,
      );
    });

    test('ARC 容器 feature 命中（实测 ChromeOS ARCVM 上报项）', () {
      expect(
        _detect(
          systemFeatures: const [
            'android.hardware.camera',
            'org.chromium.arc',
            'org.chromium.arc.device_management',
            'org.chromium.bertha',
          ],
        ),
        isTrue,
      );
    });

    test('chromebook 硬件类型命中', () {
      expect(
        _detect(systemFeatures: const ['android.hardware.type.chromebook']),
        isTrue,
      );
    });

    test('cheets 设备代号命中', () {
      expect(
        _detect(
          fingerprint: 'chromium/cheets/cheets:13/16298:user/release-keys',
          product: 'cheets',
          device: 'cheets',
        ),
        isTrue,
      );
    });

    test('arcvm 设备代号命中', () {
      expect(
        _detect(
          product: 'arcvm',
          device: 'arcvm',
        ),
        isTrue,
      );
    });

    test('特性名大小写不敏感', () {
      expect(
        _detect(
          systemFeatures: const [
            'com.google.android.feature.CROS_device_management',
          ],
        ),
        isTrue,
      );
    });
  });

  group('ChromeOSDetector 真机样本', () {
    test('kukui_cheets (ChromeOS ARCVM, Android 13) 判定为 ChromeOS', () {
      // 取自实机 adb shell getprop
      expect(
        _detect(
          fingerprint:
              'google/kukui/kukui_cheets:13/R156-16836.19.0/16564639:user/release-keys',
          product: 'bertha_arm64',
          device: 'kukui_cheets',
          brand: 'google',
          manufacturer: 'Google',
          systemFeatures: const [
            'org.chromium.arc',
            'org.chromium.arc.device_management',
            'org.chromium.bertha',
          ],
        ),
        isTrue,
      );
    });

    test('kukui_cheets 仅靠 device 代号也能判定', () {
      // 不提供任何 feature 时仍应判定为 ChromeOS
      expect(
        _detect(
          fingerprint:
              'google/kukui/kukui_cheets:13/R156-16836.19.0/16564639:user/release-keys',
          product: 'bertha_arm64',
          device: 'kukui_cheets',
          brand: 'google',
          manufacturer: 'Google',
        ),
        isTrue,
      );
    });
  });

  group('ChromeOSDetector 弱信号', () {
    test('仅有 chromium 品牌时不判定为 ChromeOS', () {
      // 定制 ROM / 模拟器可能同样上报 chromium 品牌，
      // 单凭品牌判定会让普通设备永久失去主动转屏能力
      expect(
        _detect(
          brand: 'chromium',
          manufacturer: 'chromium',
        ),
        isFalse,
      );
    });

    test('仅有 cros 设备代号时不判定为 ChromeOS', () {
      expect(
        _detect(
          fingerprint: 'google/cros/cros:14/user/release-keys',
          product: 'cros',
          device: 'cros',
        ),
        isFalse,
      );
    });

    test('cros 设备代号与 chromium 品牌同时命中时判定为 ChromeOS', () {
      expect(
        _detect(
          fingerprint: 'chromium/cros/cros:13/user/release-keys',
          product: 'cros',
          device: 'cros',
          brand: 'chromium',
          manufacturer: 'chromium',
        ),
        isTrue,
      );
    });
  });

  group('ChromeOSDetector 负例', () {
    test('普通手机不判定为 ChromeOS', () {
      expect(_detect(), isFalse);
    });

    test('厂商定制 ROM 不判定为 ChromeOS', () {
      expect(
        _detect(
          fingerprint: 'MIUI/Android/hyperos:14/1.0.0/RKQ1',
          product: 'hyperos',
          device: 'cupertino',
          brand: 'Xiaomi',
          manufacturer: 'Xiaomi',
        ),
        isFalse,
      );
    });

    test('三星等厂商设备不判定为 ChromeOS', () {
      expect(
        _detect(
          fingerprint: 'samsung/sm-s911B/sm-s911B:14/UP1A/231005:user/release-keys',
          product: 'o1sxxx',
          device: 'o1s',
          brand: 'samsung',
          manufacturer: 'samsung',
        ),
        isFalse,
      );
    });
  });
}
