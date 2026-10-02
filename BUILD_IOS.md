# iOS 构建说明（PiliNara fork）

本 fork 不升级到 Xcode 26 / iOS 26 SDK，本机构建环境长期保持 Xcode 16.4 / iOS 18.5 SDK。上游面向 iOS 26 的改动，凡在本环境编译不过的，一律用**版本钉死 + 隔离 patch** 处理，不破坏仓库代码对 iOS 26 SDK 的兼容。

本文档记录：①本机构建前置环境；②为什么不能直接 `flutter build ios`；③可复现的构建步骤；④安装包说明；⑤如何防止 PR 破坏可构建状态。

---

## 一、本机构建前置环境

| 项 | 要求 | 说明 |
|---|---|---|
| Flutter | **3.47.0**（经 fvm 管理） | `pubspec.yaml` 要求 `flutter: 3.47.0`，Dart `>=3.12.0`。`.fvm` 里旧写的 3.41.9 已不满足，实际用 fvm 的 3.47.0 |
| Xcode | **16.4**（iOS 18.5 SDK） | 不升级到 26。这是本 fork 的硬约束 |
| CocoaPods | 1.17.0 | 本地已有即可 |
| macOS | darwin-arm64 | Apple Silicon |

> fvm 已缓存 3.47.0：`/Users/tune/fvm/versions/3.47.0`。第一次若缺失，用 `fvm install 3.47.0` 下载，**不要用 `flutter upgrade`**——那会动 SDK 工作区，让已应用的 patch 失效。

---

## 二、为什么不能直接 `flutter build ios`

直接构建会在 3 个点失败，都来自上游面向 iOS 26 / 新版插件的改动。本 fork 的策略是**版本钉死 + 隔离 patch**，可复现、可进仓库：

1. **插件用了 iOS 26 专属 API**（本机 iOS 18.5 SDK 编译期就过不了，`@available` 救不了编译期 selector）：
   - `device_info_plus` 的 `NSProcessInfo.isiOSAppOnVision`（iOS 26.1）
   - 项目自己的 `ios/Runner/SceneDelegate.swift` 的 `UIWindowScene.WindowingControlStyle`（iOS 26）

   > `connectivity_plus` 的 `NWPath.isUltraConstrained` 也是 iOS 26 API，但本 fork 已把 `connectivity_plus` 钉到 `7.0.0`（该版本无此 API），无需任何隔离。

2. **`device_info_plus` 的版本与 `win32` 冲突**：项目直接依赖 `win32: ^6.3.0`。`device_info_plus` 12.x 声明 `win32: ^5.x`，且其 `device_info_plus_windows.dart` 用的是 win32 5.x 的旧 API（`wReserved`、`PWSTR` 等），与 win32 6.x 不兼容——iOS 构建时 kernel 仍会编译这个 windows dart 文件（`device_info_plus` 用 `dart.library.js_interop` 做条件导入，iOS 上非 web，会选中 `device_info_plus_windows.dart`），导致 Dart 编译失败。`device_info_plus` 13.0.0 才把 `win32` 升到 `^6.0.0` 并适配新 API，所以必须用 13.0.0。

3. **`file_picker` 的 `^` 会自动升级到 breaking 版本**：`pubspec.yaml` 写 `^12.0.0-beta.7`，`pub get` 会升到 `12.0.0`（API 大改），项目代码用的是 beta.7 的旧 API。必须精确钉 `12.0.0-beta.7`。

4. **Flutter SDK 要打 patch**：`lib/scripts/patch.ps1` 给 Flutter 本体打 20+ 补丁暴露内部 API，业务代码依赖它们。patch 脚本是 PowerShell，本机无 `pwsh`。

> 注意：**Flutter 的 “Development Team” 报错是误诊**。`diagnoseXcodeBuildFailure` 只在 xcodebuild 真正失败后才调用，它会在没识别出具体编译错误时兜底打印 Development Team 提示。真正原因永远是上面的编译错误——修好编译，Development Team 提示自然消失，`--no-codesign` 已经自动注入了 `CODE_SIGNING_ALLOWED=NO`，**不需要改 `project.pbxproj` 的签名设置**。

---

## 三、构建步骤

### Step 1 — 切到 fvm 3.47.0，装依赖

```bash
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
export PUB_HOSTED_URL=https://pub.flutter-io.cn
fvm use 3.47.0
fvm flutter pub get
```

> 下载走 flutter-io.cn 镜像。`flutter` 启动时那条 `fetch --tags` 的 SSL 报错是版本更新检查，非致命，可忽略。

### Step 2 — 确认三个依赖已钉死（仓库 `pubspec.yaml` 已固定，正常无需手动改）

```yaml
connectivity_plus: 7.0.0          # 精确版本，无 iOS 26 API
device_info_plus: 13.0.0          # win32 ^6.0.0，与项目 win32 ^6.3.0 兼容
file_picker: 12.0.0-beta.7        # 精确版本，避免 ^ 升到 breaking 的 12.0.0
win32: ^6.3.0                     # 项目直接依赖，device_info_plus 13.0.0 也用 ^6
```

> **不要给 `win32` 加 `dependency_overrides`**。13.0.0 本就要求 `win32 ^6.0.0`，与项目 `win32 ^6.3.0` 自然一致，加 override 反而多余。
>
> `pubspec.yaml` 里这三个精确版本是本 fork 可构建的红线，见第五节防护清单。

### Step 3 — 一键应用所有 patch

```bash
bash lib/scripts/patch.sh ios
```

`patch.sh` 做三件事（全部幂等，重复运行安全）：

1. **仓库内 patch**（iOS 必需，改 PiliPlus 业务源码）：`bottom_sheet_ios_piliplus.patch`、`geetest_ios.patch`（后者会新增 `gt3_flutter_plugin` 依赖 + `lib/pages/login/geetest/geetest_plugin.dart`）。
2. **Flutter SDK 本体 patch**（20+ 个，与 `patch.ps1` 的 iOS 集合一致）：`modal_barrier`…`navigator` 等。用 `git apply` 应用到 fvm 的 3.47.0 工作区。
3. **pub-cache 插件 iOS 26 隔离 patch**：`device_info_ios26_isolate.patch`，用 `patch` 命令应用到 `~/.pub-cache/.../device_info_plus-13.0.0/`，注释掉 `FPPDeviceInfoPlusPlugin.m` 里的 `@available(iOS 26.1)` 块，固定 `isiOSAppOnVision=NO`。

> 前置：已 `flutter pub get`（脚本依赖 `ios/Flutter/Generated.xcconfig` 定位 Flutter SDK，依赖 pub-cache 里已有 `device_info_plus-13.0.0`）。
>
> **还原**：仓库 patch 用 `git checkout -- <文件>`；SDK patch 用 `git -C /Users/tune/fvm/versions/3.47.0 reset --hard`；pub-cache 隔离用 `rm -rf ~/.pub-cache/hosted/*/device_info_plus-13.0.0 && flutter pub get` 重拉。

### Step 4 — 仓库内的 SceneDelegate 改动（构建必需，已在仓库内）

`ios/Runner/SceneDelegate.swift` 用 `#if compiler(>=6.2)` 包裹 iOS 26 API：

```swift
import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
  #if compiler(>=6.2)
  @available(iOS 26.0, *)
  override func preferredWindowingControlStyle(
    for windowScene: UIWindowScene
  ) -> UIWindowScene.WindowingControlStyle {
    return .minimal
  }
  #endif
}
```

`compiler(>=6.2)` 在本机 Swift 6.1.2 为 false（跳过，本地能编译）；在 Xcode 26 的 Swift 6.2+ 为 true（保留上游行为）。两边都不破坏。

### Step 5 — 生成 pili_release.json 并构建

```bash
# pili_release.json 提供运行时 dart-define。本机无 pwsh 跑不了 lib/scripts/build.ps1，手动生成等价文件：
cat > pili_release.json <<EOF
{"pili.name":"2.1.0-$(git rev-parse --short HEAD)","pili.code":$(git rev-list --count HEAD),"pili.hash":"$(git rev-parse HEAD)","pili.time":$(date +%s)}
EOF

rm -rf build/ios
fvm flutter build ios --release --no-codesign --dart-define-from-file=pili_release.json
```

成功标志：`✓ Built build/ios/iphoneos/Runner.app`。

### Step 6 — 打包成 IPA

```bash
# 给 framework 逐个 ad-hoc 签名（AltSign/Sideloadly 重签需要）
find build/ios/iphoneos/Runner.app/Frameworks -type d -name "*.framework" \
  -exec codesign --force --sign - --preserve-metadata=identifier,entitlements {} \;

rm -rf /tmp/Payload && mkdir -p /tmp/Payload
cp -R build/ios/iphoneos/Runner.app /tmp/Payload/
ditto -c -k --sequesterRsrc --keepParent /tmp/Payload build/PiliNara_ios_unsigned.ipa
```

产物：`build/PiliNara_ios_unsigned.ipa`（约 25M）。

---

## 四、安装包说明

| 项 | 值 |
|---|---|
| 路径 | `build/PiliNara_ios_unsigned.ipa` |
| 大小 | ~25M |
| 架构 | arm64（真机，非模拟器） |
| 最低系统 | iOS 15.0 |
| Bundle ID | `com.example.pilinara` |
| 版本 | `CFBundleShortVersionString=2.1.0`，`CFBundleVersion=1` |
| 签名状态 | **未签名** + frameworks 已 ad-hoc 签 |

### 用前须知

1. **未签名，不能直接装**。装真机必须用 AltSign / Sideloadly / 巨魔商店 / 自签证书重签。重签时 Bundle ID 会被改成你证书对应的 ID。
2. **版本号是 `2.1.0+1`，不是 CI 的 `2.1.0-<commit>+<count>`**。因为本机无 `pwsh` 跑不了 `build.ps1`（它会把 commit hash 写进 `pubspec.yaml` version）。运行时 `dart-define` 的 `pili.*` 仍是对应当前 commit 的，应用内“关于”显示以 dart-define 为准。要完全对齐 CI 版本号，手动把 `pubspec.yaml` 的 `version:` 改成 `2.1.0-<commit>+<count>` 再构建。
3. **iOS 26 相关功能不可用**：`device_info` 的 vision 检测、`SceneDelegate` 的窗口控制样式——本构建已隔离这些，对非 iOS 26 设备无影响（本来就用不到）。
4. **frameworks 已 ad-hoc 签**，但 app 主体未签，仍需整体重签才能安装。
5. 本构建来自本地隔离改动，**与 CI 产物不是逐字节相同**（SDK patch 完整度、版本号差异），但功能等价。

---

## 五、如何防止 PR 破坏当前可构建状态

本 fork 的可构建状态依赖一组**仓库内不变量**。任何 PR 若触碰下面任一项，就会让本机构建失败。防护分三层：

### 第 1 层：不可变约束（PR 评审红线）

合入前必须人工/CI 拒绝以下改动：

| 红线 | 检查点 | 破坏后果 |
|---|---|---|
| `pubspec.yaml` 里 `file_picker` 改成 `^` 或升级 | `file_picker: 12.0.0-beta.7` 必须精确 | 编译失败（API 不兼容 12.0.0） |
| `pubspec.yaml` 里 `connectivity_plus` 改成 `^` 或升级 | `connectivity_plus: 7.0.0` 必须精确 | 7.x+ 引入 `isUltraConstrained`（iOS 26 API），编译失败 |
| `pubspec.yaml` 里 `device_info_plus` 改成 `^` 或降到 12.x | `device_info_plus: 13.0.0` 必须精确 | 12.x 与项目 `win32 ^6` 冲突（Dart 编译失败）；13.1+ 的 `.m` 有 iOS 26 API |
| `pubspec.yaml` 的 `flutter: 3.47.0` 被升级 | 锁 3.47.0 | SDK patch 全部失效 |
| 给 `win32` 加 `dependency_overrides` | 不应有 | 13.0.0 自然要 `win32 ^6`，override 多余且可能引入歧义 |
| `lib/scripts/patch.ps1` / `lib/scripts/*.patch` 被删或改 | SDK patch 依赖它们 | Dart 编译失败 |
| `lib/scripts/patch.sh` 被删或改 | 本机一键构建依赖它 | 手动逐个 apply，易漏 |
| `lib/scripts/device_info_ios26_isolate.patch` 被删 | pub-cache 隔离依赖它 | `.m` 编译失败 |
| `ios/Runner/SceneDelegate.swift` 去掉 `#if compiler(>=6.2)` 包裹 | 必须保留条件编译 | 本地编译失败 |
| 新增依赖用了 iOS 26 专属 API | 编译期检查 | 编译失败，需新增对应隔离 patch |

### 第 2 层：CI 守护（`.github/workflows`）

本 fork 已有 `sync_upstream_build.yml`。**关键：上游构建跑在 macOS 26（Xcode 26），本机构建跑在 Xcode 16.4，两边环境不同，CI 通过 ≠ 本机通过**。因此：

- CI 的 ios 构建只能证明「上游在 Xcode 26 下可构建」，**不能**作为本 fork 可构建的依据。
- 若要 CI 守护本机可构建性，需新增一个 **runs-on: macos-14（Xcode 16 / iOS 18.5）的构建 job**，复刻本文档 Step 1–6，作为 PR 检查门禁。建议命名为 `ios-legacy`，仅在 PR 触发时跑。
- 在 PR 模板/CONTRIBUTING 里写明：iOS 相关改动需通过 `ios-legacy` 检查（即旧 SDK 可构建）。

> 这是防止上游/外部 PR 破坏本机构建的**最有效手段**：把“旧 SDK 可构建”变成 CI 硬门禁，PR 不通过就不让合。

### 第 3 层：上游同步纪律

`sync_upstream_build.yml` 每天拉 `upstream/main`。上游会持续引入 iOS 26 改动，需要：

1. **每次上游同步后，先在本机验证 Step 1–6 仍能构建**，再合入 main。
2. 上游若新增 iOS 26 API 依赖（新插件/新 SceneDelegate 方法），同步前先在本地补对应隔离 patch（`lib/scripts/<name>_ios26_isolate.patch` + 在 `patch.sh` 第 3 段加 `apply_pub`），验证通过再合。
3. **`file_picker` / `connectivity_plus` / `device_info_plus` 若上游升到更高版本，同步时必须手动压回本文档第二节钉死的精确版本**，否则一同步就编译失败。
4. 上游若改 `patch.ps1` / patch 文件，同步后重跑 Step 3，确认 SDK patch 仍能 apply（patch 针对的 Flutter 源码若被上游更新，可能需要重新对齐 patch）。

### 防护清单速查（PR 合入前过一遍）

- [ ] `pubspec.yaml`: `file_picker: 12.0.0-beta.7`（精确，无 `^`）
- [ ] `pubspec.yaml`: `connectivity_plus: 7.0.0`（精确，无 `^`）
- [ ] `pubspec.yaml`: `device_info_plus: 13.0.0`（精确，无 `^`，不是 12.x 或 13.1+）
- [ ] `pubspec.yaml`: `flutter: 3.47.0` 未升级
- [ ] `pubspec.yaml`: 无 `win32` 的 `dependency_overrides`
- [ ] `ios/Runner/SceneDelegate.swift`: iOS 26 API 仍在 `#if compiler(>=6.2)` 内
- [ ] 无新增 iOS 26 专属 API（或有对应 `lib/scripts/*_ios26_isolate.patch` + `patch.sh` 已纳入）
- [ ] `lib/scripts/*.patch`、`patch.sh`、`device_info_ios26_isolate.patch` 未被删改
- [ ] （建议）`ios-legacy` CI job 通过

---

## 附：本地改动清单（构建引入）

| 文件 | 改动 | 回滚 |
|---|---|---|
| `pubspec.yaml` | 钉 `file_picker`/`connectivity_plus`/`device_info_plus` 精确版本 + `gt3_flutter_plugin` 依赖 | `git checkout -- pubspec.yaml` |
| `pubspec.lock` | pub get 重解析 | `git checkout -- pubspec.lock` |
| `ios/Podfile` | platform 14→15（Flutter 自动改） | `git checkout -- ios/Podfile` |
| `ios/Podfile.lock` | pod install 更新 | `git checkout -- ios/Podfile.lock` |
| `ios/Runner.xcodeproj/project.pbxproj` | `IPHONEOS_DEPLOYMENT_TARGET` 14→15（Flutter 自动改，无签名绕过改动） | `git checkout -- ios/Runner.xcodeproj/project.pbxproj` |
| `ios/Runner/SceneDelegate.swift` | `#if compiler(>=6.2)` 包裹 | 仓库改动，保留 |
| `lib/.../common_slide_page.dart`、`geetest_webview_dialog.dart`、新增 `geetest_plugin.dart` | 应用 `bottom_sheet_ios_piliplus` / `geetest_ios` patch | `git checkout` / `rm` |
| `lib/scripts/patch.sh`、`lib/scripts/device_info_ios26_isolate.patch` | 本机一键构建脚本 + pub-cache 隔离 patch | 仓库改动，保留 |
| `~/.pub-cache` 内 `device_info_plus-13.0.0` 源码 | 应用 `device_info_ios26_isolate.patch` | `rm -rf ~/.pub-cache/hosted/*/device_info_plus-13.0.0 && flutter pub get` 重拉 |
| `/Users/tune/fvm/versions/3.47.0` 工作区 | ~42 文件 dirty（SDK patch） | `git -C <sdk> reset --hard` 还原，需重打 |
