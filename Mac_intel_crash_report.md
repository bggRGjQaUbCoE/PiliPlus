(该RP仅反馈bug，请勿合并)

开发者您好：

抱歉打扰，因仓库未开启 Issues 分区，观察到其他用户通过 PR 反馈问题，故通过此渠道反馈一个关于 v2.0.4 版本在 Intel 架构 Mac 上的严重启动崩溃 Bug。

包含了通过 otool 和 codesign 深入排查后的日志和分析，希望能帮助您在后续版本中修复。

---

# 【Bug 反馈】v2.0.4 在 Intel 架构 Mac 上无法启动 | 隔离属性移除后报 Symbol not found 错误

## 1. 环境信息
* **设备型号：** MacBook Pro 13,3 (2016款, Intel Skylake i7)
* **操作系统：** macOS 15.7.5 (Sequoia, 通过 OpenCore Legacy Patcher 引导)
* **应用版本：** 2.0.4 (4859) —— **现象：无法运行**
* **对比版本：** 2.0.1 (4775) —— **现象：正常运行**


## 2. 问题描述与排查细节
1. **初始症状：** 安装 v2.0.4 后直接运行，Dock 栏图标持续跳动且无法进入程序，系统未弹出任何错误提示。
2. **强制运行尝试：** 为了排查权限问题，手动执行了 `sudo xattr -r -d com.apple.quarantine /Applications/PiliPlus.app` 移除隔离属性。
3. **结果：** 移除隔离属性后再次运行，应用立即闪退并触发“意外退出”报告。报错信息明确指向 `dyld` 阶段的动态库链接错误。


## 3. 崩溃日志关键摘要 (移除隔离属性后生成)
```text
Termination Reason:    Namespace DYLD, Code 0 
symbol not found in flat namespace '_OBJC_CLASS_$__TtC5swift11Application'

Thread 0 Crashed:
0   dyld    0x7ff802cb1502 __abort_with_payload + 10
1   dyld    0x7ff802cd29f7 abort_with_payload_wrapper_internal + 82
```

## 4. 技术分析
* **核心故障：** 报错的 `_TtC5swift11Application` 符号缺失，说明 v2.0.4 的 `x86_64` 分支在调用 Swift 6 核心库时，无法在当前环境（Intel Skylake 架构）中完成符号链接。
* **库状态检查：** 通过 `otool -L` 检查发现 `/usr/lib/swift/libswiftCore.dylib` 的兼容版本显示为 `0.0.0`，存在链接失效。
* **回归确认：** **v2.0.1 版本在同一设备环境下无需任何手动干预即可正常运行**，证明该问题是 v2.0.4 引入的针对 Intel 架构的构建兼容性退化。


## 5. 修复建议
通过对源码的初步审计，建议开发者针对 Intel (x86_64) 分支进行以下调整，以解决 OCLP 环境下的链接断层：

* 强制嵌入运行时库： 在 project.pbxproj 中明确开启 ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES = YES;。目前该配置缺失（默认为 NO），导致应用强制依赖系统 Shared Cache，而在 OCLP 驱动的旧款 Intel 设备上，系统库可能无法提供 Swift 6 所需的全部符号。
* 强化 Podfile 约束： 建议在 macos/Podfile 的 post_install 钩子中增加强制对齐脚本。防止第三方插件（如视频引擎）因默认配置较高或未开启嵌入，导致整体包链接失败。
* 体积优化建议： 若担心安装包体积，可仅针对 x86_64 架构开启嵌入，或提供专门的 Intel 兼容版 Release。

---
