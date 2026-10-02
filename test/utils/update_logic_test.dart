import 'package:PiliPlus/utils/update.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Update logic', () {
    test('parses manifest version info', () {
      final result = Update.parseReleaseManifest({
        'schema_version': 1,
        'version_name': '2.0.9',
        'version_code': 5461,
        'commit_hash': 'abc',
        'release_tag': 'v2.0.9+1-20260618',
      });

      expect(result?.versionCode, 5461);
      expect(result?.releaseTag, 'v2.0.9+1-20260618');
    });

    test('extracts version code from legacy asset names', () {
      final versionCode = Update.extractVersionCodeFromAssets([
        {'name': 'PiliNara_android_2.0.9-da5fd1055+5461_arm64-v8a.apk'},
      ]);

      expect(versionCode, 5461);
    });

    test('detects update only when remote version code is greater', () {
      expect(
        Update.shouldNotifyUpdate(localVersionCode: 5461, remoteVersionCode: 5462),
        isTrue,
      );
      expect(
        Update.shouldNotifyUpdate(localVersionCode: 5461, remoteVersionCode: 5461),
        isFalse,
      );
      expect(
        Update.shouldNotifyUpdate(localVersionCode: 5462, remoteVersionCode: 5461),
        isFalse,
      );
    });

    test('falls back to asset version code when manifest is unavailable', () {
      final release = {
        'tag_name': 'v2.0.9+1-20260618',
        'assets': [
          {'name': 'PiliNara_android_2.0.9-da5fd1055+5461_arm64-v8a.apk'},
        ],
      };

      final info = Update.resolveRemoteVersionInfo(
        release,
        manifest: null,
      );

      expect(info?.versionCode, 5461);
      expect(info?.releaseTag, 'v2.0.9+1-20260618');
    });

    test('prefers manifest version info over legacy asset names', () {
      final info = Update.resolveRemoteVersionInfo(
        {
          'tag_name': 'v2.0.9+1-20260618',
          'assets': [
            {'name': 'PiliNara_android_2.0.9-da5fd1055+5461_arm64-v8a.apk'},
          ],
        },
        manifest: {
          'schema_version': 1,
          'version_name': '2.0.9',
          'version_code': 5462,
          'commit_hash': 'abc',
          'release_tag': 'v2.0.9+1-20260619',
        },
      );

      expect(info?.versionCode, 5462);
      expect(info?.releaseTag, 'v2.0.9+1-20260619');
    });

    test('returns null when neither manifest nor assets provide a version', () {
      final info = Update.resolveRemoteVersionInfo(
        {
          'tag_name': 'v2.0.9+1-20260618',
          'assets': [
            {'name': 'PiliNara_windows_2.0.9_x64_portable.zip'},
          ],
        },
        manifest: null,
      );

      expect(info, isNull);
    });
  });
}
