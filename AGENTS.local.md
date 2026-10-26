# AGENTS.local.md

## HDR 与播放路由约束

1. **HDR 必须真实输出，且使用硬解。** DV/HDR 播放必须实际激活 HDR 显示；回退到 SDR 或软解均不算通过。
2. **HDR 菜单由面板能力和用户偏好决定。**
   - 面板支持 HDR 且用户未关闭 HDR 时，HDR 档应可选。
   - 面板不支持 HDR 或用户关闭 HDR 时，选择 SDR 视频轨。
   - 面板没有 DV 直通能力不能据此禁用 DV；允许将 DV 转换为 PQ HDR 显示。
3. **App 不使用 HDR→SDR 色调映射。** SDR 输出直接选择 B 站提供的 SDR 轨。
4. **所有编码统一遵守载体路由表。**
5. **按设备能力判断，不按设备名称判断。** App 不写机型分支；设备专属实现放在 vendor 扩展层，库和规划器消费能力自报。
6. **底层播放能力封装进 media-kit。** media-kit 尽量保持接口与原始 media-kit 兼容，尽可能减少对 PiliPlus 代码的修改，保持从 PiliPlus 源仓库同步代码容易。

## Android 原生源码构建

- PiliPlus 的本地测试、修复验证 APK 必须使用 media-kit 标准入口，现场从当前本地依赖与 mpv 源码构建原生库，再构建 APK：

  ```bash
  set -o pipefail
  export PATH="$HOME/flutter-sdks/3.47.7/bin:$PATH"
  cd /Users/wuweiwei1/src/media-kit
  mkdir -p /tmp/piliplus-source-test
  ORG_GRADLE_PROJECT_dev=true tool/build-android-test.sh \
    --tag piliplus-source-test \
    --app-dir /Users/wuweiwei1/src/PiliPlus \
    2>&1 | tee /tmp/piliplus-source-test/build.log | tail -15
  ```

- 禁止直接运行 `flutter build apk` 并手工注入历史 JAR 来声称通过当前源码验证。尤其不可把 `mks-arm64-v8a-opaquealpha.jar`、发布 JAR 或其它预编译库当作本次源码构建产物。发布构建或发布链回归可按其明确范围使用发布库，但结果必须标记为发布构建/发布链验证，不计作当前源码构建验证。
- 入口默认使用项目要求的 JDK 17，临时配置由脚本管理，不修改全局 Flutter/JDK 设置。
- 不要绕过入口或覆盖它选择的原生 JAR、ABI split 参数；`MKS_SKIP_APK=1` 只生成原生库，不能作为 APK 交付或安装依据。默认 release + `dev=true` 输出 `/Users/wuweiwei1/src/PiliPlus/build/app/outputs/flutter-apk/piliplus-source-test-release.apk`，应用包名为 `com.example.piliplus.dev`；加入 `--debug` 会构建 debug variant，输出 arm64 APK `/Users/wuweiwei1/src/PiliPlus/build/app/outputs/flutter-apk/piliplus-source-test-debug.apk`，包名为 `com.example.piliplus.debug`。
- 测试 App（`com.example.piliplus.dev` / `.debug`）仅供本机测试使用：不需要备份、不需要恢复现场，测试完也不必卸载，保持测试后的原样即可。
- 只有入口输出 `=== VERIFIED` 且对应的 `piliplus-source-test-release.native-verification.json`（或 debug 同名结果单）状态为 `verified` 后，才安装该 APK。核对设备包名及设备 `base.apk` SHA-256 与候选 APK 一致。构建和库哈希核验不等同于设备播放、硬解、HDR 输出或画面验收；按具体任务另行验证并记录这些结果。
