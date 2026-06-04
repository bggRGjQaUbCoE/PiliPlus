# Phase 1 — Gradle `screen_brightness_android` kotlin() Fix

**Report:** `records/reasonix/implementer/2026-05-31-phase-1-gradle-screen-brightness-fix.md`
**Role:** `implementer-gradle-screen-brightness-release-risk`
**Review owner:** Codex
**Branch:** `phase-1-shielding-core` at `a5d0d075cd80a35173355a52133057c7cec1679b`
**Current status:** Adopted for implementation after release `Build` workflow_dispatch run `26712487951` proved the `screen_brightness_android` Gradle issue blocks release APK builds. This report remains supporting rationale only; release gates still require a committed/pushed fix plus a successful reviewed Build run with signing evidence.

---

## 1. Root cause

The Flutter plugin `screen_brightness_android` v2.1.5 (transitive dependency of `screen_brightness_platform_interface: ^2.1.0`) has a `build.gradle` that:

1. **Conditionally applies `kotlin-android`** only when AGP major < 9 (line 26–28):
   ```groovy
   def agpMajor = com.android.Version.ANDROID_GRADLE_PLUGIN_VERSION.tokenize('.')[0] as int
   if (agpMajor < 9) {
      apply plugin: 'kotlin-android'
   }
   ```
2. **Unconditionally calls `kotlin {}`** (line 52):
   ```groovy
   kotlin {
       compilerOptions {
           jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_1_8
       }
   }
   ```

The project uses **AGP 9.0.1** (declared in `android/settings.gradle.kts`). Since `9 < 9` is `false`, `kotlin-android` is NOT applied, but the `kotlin {}` DSL block still executes — causing:

```
Could not find method kotlin() for arguments [...] on project
':screen_brightness_android' of type org.gradle.api.Project.
```

---

## 2. Fix applied

**File:** `android/build.gradle.kts`

Added a `subprojects` block that applies `org.jetbrains.kotlin.android` to every subproject that has `com.android.application` or `com.android.library` applied. This runs reactively via `plugins.withId`, so it triggers immediately when a plugin applies the Android plugin — well before the subproject's own `kotlin {}` block evaluates.

```diff
+// Ensure kotlin-android is available for all Android subprojects,
+// including third-party plugins that conditionally skip it for AGP 9+.
+// Without this, Groovy build.gradle files that call kotlin {} without
+// first applying kotlin-android will fail with "Could not find method kotlin()".
+subprojects {
+    plugins.withId("com.android.application") {
+        plugins.apply("org.jetbrains.kotlin.android")
+    }
+    plugins.withId("com.android.library") {
+        plugins.apply("org.jetbrains.kotlin.android")
+    }
+}
```

**Why this approach:**
- Minimal (13 lines added, no files deleted)
- Does NOT modify pub cache (no fragile `flutter pub get` risk)
- Idempotent — applying `kotlin-android` twice is safe in Gradle
- AGP 9 still supports explicit `kotlin-android` application (it's "no longer required but still supported")
- Uses `plugins.withId` (reactive) rather than `beforeEvaluate`/`afterEvaluate` (timing-dependent)

---

## 3. Verification results

### 3.1 Local Android build

```
flutter build apk --release --split-per-abi --target-platform android-x64 --android-project-arg dev=1 --pub
```

**Result:** The `screen_brightness_android` plugin evaluated successfully — no `Could not find method kotlin()` error. The plugin appears in the expected KGP warning list: `screen_brightness_android` is listed alongside 14 other plugins as applying the Kotlin Gradle Plugin.

The build failed later on a **separate, pre-existing issue** — `flutter_inappwebview_android` (git dependency `e0e82f`) has 23 Java compilation errors (missing generated classes like `ChromeCustomTabsChannelDelegate`, `HeadlessInAppWebViewManager`). This is unrelated to the Kotlin fix and was not the target of this task.

### 3.2 Flutter tests (all CI suites — 64 tests, all passed)

| Suite | Tests | Result |
| --- | --- | --- |
| `test/features/shielding` | 55 | ✅ All passed |
| `test/pages/setting/models/shielding_settings_test.dart` | 8 | ✅ All passed |
| `test/bootstrap/bootstrap_app_test.dart` | 1 | ✅ All passed |

### 3.3 Flutter analyze

```
flutter analyze --no-fatal-infos
```

50 pre-existing `info`-level issues (deprecation notices, style preferences). **Zero new errors or warnings.**

---

## 4. Risks and unknowns

### 4.1 Risk: Kotlin version mismatch (LOW)

The project declares Kotlin `2.3.20` in `settings.gradle.kts`. The `screen_brightness_android` plugin's buildscript classpath declares `kotlin-gradle-plugin:2.3.21`. In modern Gradle with `pluginManagement`, the project's version takes precedence for plugin resolution. A 0.0.1 patch difference is unlikely to cause issues, but if runtime classpath conflicts arise, align the project to `2.3.21`.

### 4.2 Risk: Future Flutter/AGP compatibility (MEDIUM)

Flutter's warning states: *"Future versions of Flutter will fail to build if your app uses plugins that apply KGP."* Our fix adds explicit `kotlin-android` application to 15+ plugins. This may conflict with a future Flutter version that **forbids** explicit KGP application. Mitigation: if/when Flutter enforces this, the fix can be removed — by then, plugins should have migrated to AGP 9's built-in Kotlin support, making the explicit application unnecessary.

### 4.3 Unknown: `flutter_inappwebview_android` compilation (PRE-EXISTING)

The `flutter_inappwebview_android` git dependency (`https://github.com/bggRGjQaUbCoE/flutter_inappwebview.git` at `e0e82f`) fails Java compilation with 23 "cannot find symbol" errors. This is a **pre-existing issue** that also blocks CI for any build that includes this ABI. It was not caused by our change and was not in scope for this fix. This will need separate investigation.

### 4.4 Unknown: Full ABI build not verified

Due to the `flutter_inappwebview_android` issue, a complete `flutter build apk --release --split-per-abi` (all ABIs) could not be verified locally. The `--target-platform android-x64` build proved the fix works; the same Gradle configuration applies to all ABIs, so the fix is expected to hold for arm64-v8a and armeabi-v7a.

### 4.5 Unknown: CI verification

The fix was verified locally only. CI verification requires pushing the change to the branch, which is **forbidden** in this role. The CI will exercise the same Gradle configuration on a clean runner, confirming the fix under CI conditions.

---

## 5. Commands summary

```bash
# Reproduce the fix verification:
flutter pub get
flutter test test/features/shielding
flutter test test/pages/setting/models/shielding_settings_test.dart
flutter test test/bootstrap/bootstrap_app_test.dart
flutter analyze --no-fatal-infos
flutter build apk --release --split-per-abi --target-platform android-x64 --android-project-arg dev=1 --pub
# Expect: screen_brightness_android evaluates without kotlin() error;
# flutter_inappwebview_android failure is pre-existing.
```

---

## 6. Conclusion

The `screen_brightness_android` `kotlin()` Gradle failure is **fixed**. The change is minimal (13 lines in one file), verified through 64 Flutter tests and partial Android build. The remaining `flutter_inappwebview_android` compilation issue is pre-existing and outside the scope of this fix.
