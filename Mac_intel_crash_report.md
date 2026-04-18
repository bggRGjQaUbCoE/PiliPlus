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
建议开发者检查 Xcode 16 构建设置：
* 确认 **Minimum Deployment Target**（最低部署目标）在 Intel 分支下是否被意外提升。
* 建议在编译 Intel 架构包时开启 **Static Linking for Swift Standard Libraries**（静态链接 Swift 标准库）。
* 检查是否在 `x86_64` 分支中引入了仅限 Apple Silicon (ARM) 环境支持的 Swift 6 新 API 类名。

---
