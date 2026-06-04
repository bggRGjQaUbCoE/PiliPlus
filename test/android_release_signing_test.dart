import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('release signing cannot fall back to debug signing', () {
    final gradle = File('android/app/build.gradle.kts').readAsStringSync();

    expect(gradle, contains('Release signing is required'));
    expect(gradle, isNot(contains('config ?: signingConfigs["debug"]')));
    expect(
      gradle,
      contains('if (isDevBuild) signingConfigs["debug"] else config'),
    );
  });

  test('workflow fails without signing secrets and uploads fingerprints', () {
    final workflow = File('.github/workflows/build.yml').readAsStringSync();

    expect(workflow, contains('Release signing secrets are required'));
    expect(workflow, contains('exit 1'));
    expect(workflow, contains('apksigner'));
    expect(workflow, contains('Android_signing_evidence'));
    expect(workflow, contains('Cover-install verification requires'));
  });
}
