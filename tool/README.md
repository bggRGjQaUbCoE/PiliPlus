# Tooling

Regenerate Android JNI bindings:

```powershell
dart run tool/jnigen.dart
```

Verify a new Android Release APK against the persisted application, version,
ABI, and signing baseline:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tool/verify_release.ps1 `
  -ApkPath build/app/outputs/flutter-apk/pili++-<version>-<versionCode>-universal-release.apk
```

The default command rejects a `versionCode` that has already been delivered.
`-AllowAlreadyDelivered` is only for auditing an existing release artifact; it
must not be used to authorize a new delivery.
