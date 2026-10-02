# 应用内小窗（In-App PiP）实现方案

## 概述

本文档详细说明了 PiliPlus 应用内小窗功能的完整实现。该功能允许用户在应用内部通过浮动窗口观看视频或直播，并支持跨页面操作、控制器自动恢复，以及**应用内小窗到系统原生画中画（Native PiP）的平滑衔接**。

## 1. 架构设计

### 1.1 双服务架构
为了避免视频（长视频、剧集）与直播间状态冲突，系统采用了独立但互斥的双服务模式：
- **`PipOverlayService`**: 处理点播视频小窗。
- **`LivePipOverlayService`**: 处理直播小窗。

**互斥逻辑**：开启任一小窗服务前，会主动检查并销毁另一个服务的实例，确保全应用范围内仅存在一个 `OverlayEntry`。

### 1.2 核心技术栈
- **视图层**: `Overlay` & `OverlayEntry` 实现悬浮置顶。
- **状态管理**: GetX (`isNativePip` 响应式变量) 用于多端状态同步。
- **原生能力**: `floating` 插件用于触发系统画中画。
- **生命周期与离开监听**: 
  - `WidgetsBindingObserver` 用于感知应用返回前台恢复小窗。
  - **`onUserLeaveHint` (Android Native)** 用于精确判断用户离开意图并触发切换。

---

## 2. 系统画中画触发逻辑 (Native PiP Integration)

为了解决 Android 分屏或自由窗口（如 HyperOS）中焦点切换导致的误触发问题，系统采用了基于原生事件的触发机制。

### 2.1 触发机制：onUserLeaveHint (推荐方案)
不再依赖 Flutter 端的 `AppLifecycleState.inactive`（因为它会在失去焦点时触发），而是监听 Android 原生的 `onUserLeaveHint`：

1. **精确意图识别**: `onUserLeaveHint` 仅在用户主动按 Home 键或执行离屏手势时触发。
2. **UI 预备机制**: 
   - 监听到离开信号后，立即置 `isNativePip = true`。
   - 小窗 Overlay 利用 `Obx` 检测此变量并瞬间撑满全屏。
3. **主动申请**: 在 `sdkInt < 31` (即 `setAutoEnterEnabled` 不可用或失效) 的情况下，由 `PlPlayerController` 手动调用 `enterPip()`。

### 2.2 状态恢复
通过 `WidgetsBindingObserver` 监听 `AppLifecycleState.resumed`：
- 当应用切回前台（无论从 Native PiP 返回还是从后台切回）时，置 `isNativePip = false`，让 Overlay 缩回用户自定义的悬浮位置。

---

## 3. 控制器生命周期管理

### 3.1 核心问题：isClosed 不可靠

**根本原因**：GetX 在调用 `onClose()` **之前**就设置了 `isClosed = true`。

当用户进入小窗时：
1. 设置 `isEnteringPip = true`
2. 页面 pop → GetX 调用 `_onDelete()`
3. **`_onDelete()` 先设置 `_isClosed = true`，再调用 `onClose()`**
4. `onClose()` 检测到 `isEnteringPip=true`，提前返回
5. **结果**：资源未清理，但 `isClosed` 已永久为 `true`

从小窗恢复时，复用的 controller `isClosed` 仍是 `true`，所有依赖此标志的逻辑（如 `playerInit()` 检查）全部失效。

### 3.2 解决方案：两条路径分别处理

#### 路径 1: 恢复 (Restore) - 用户点击小窗返回视频页

```dart
// view.dart initState
final savedController = PipOverlayService.getSavedController<VideoDetailController>();
if (savedController != null) {
  videoDetailController = savedController;
  videoDetailController.isEnteringPip = false;       // 解除 onClose 保护
  videoDetailController.$reopenLifeCycle();          // 重置 _isClosed = false
  Get.put(savedController, tag: heroTag);
  
  PipOverlayService.stopPip(
    callOnClose: false,  // 不调用 onClose，保留所有资源
    immediate: true,
    targetContextKey: targetContextKey,
  );
}
```

**关键**：`$reopenLifeCycle()` 是在 GetX fork 中新增的方法，直接重置 `_isClosed = false`，使 controller 重新可用。

#### 路径 2: 丢弃 (Discard) - 小窗存在时打开新视频

```dart
// pip_overlay_service.dart stopPip()
if (shouldResetState && _savedController is VideoDetailController) {
  final ctrl = _savedController as VideoDetailController;
  ctrl.isEnteringPip = false;  // 解除 onClose 保护
  ctrl.onClose();              // 执行完整清理
}
```

**完整清理内容**：
- `cancelBlockListener()` - 取消 SponsorBlock 监听器
- `_dmTrendTaskId++` - 取消高能进度条加载
- `cid.close()` - 关闭 cid 流
- 保存本地播放进度
- `dispose()` 所有 controller: `introScrollCtr`、`tabCtr`、`animController`
- 清空字幕数据

### 3.3 isEnteringPip 的语义

`isEnteringPip` 不是"正在小窗"的状态标志，而是"延迟 onClose 直到 PiP 结局确定"的控制标志：

- **设为 true**: 进入小窗前，告诉 `onClose()` 跳过清理
- **清除时机**:
  - 恢复路径: 恢复时设为 `false`，然后调用 `$reopenLifeCycle()`
  - 丢弃路径: 设为 `false`，然后补调 `onClose()` 完成清理

### 3.4 移除 playerInit() 中的 isClosed 检查

**之前的代码**：
```dart
if (isClosed) return;  // ❌ 阻断从小窗恢复的 controller
```

**修改后**：直接移除此检查。理由：
1. 从小窗恢复的 controller `isClosed=true` 但仍需正常工作
2. 如果 controller 真的被销毁，GetX 会自动清理，不会执行到 `playerInit()`
3. 这个检查阻断了所有后续操作（分段进度条、高能进度条、SponsorBlock 自动跳过）

---

## 4. 状态管理与控制器持久化

### 4.1 防止 GC（垃圾回收）
通过 Service 中的 `static dynamic _savedController` 保持**强引用**，直到小窗被正式关闭。

### 4.2 控制器恢复与 UI 刷新
从小窗返回全屏页时：
1. **注入引用**: 重新 `Get.put` 暂存的控制器。
2. **强制重绘**: 
   - `setState(() {})`
   - `controller.update()`
   - `rxVariable.refresh()`

---

## 5. 源码级改动要点

### 5.1 触发权收拢 (`lib/plugin/pl_player/controller.dart`)
所有的 Native 切换逻辑现在统一在 `PlPlayerController` 的 MethodChannel 回调中处理，不再分散在各个 UI Service 中。

### 5.2 比例校正与占位 (`lib/services/pip_overlay_service.dart`)
小窗 Widget 使用响应式布局响应 `isNativePip`：
```dart
return Obx(() {
  final bool isNative = PipOverlayService.isNativePip;
  return Positioned(
    left: isNative ? 0 : _left!,
    top: isNative ? 0 : _top!,
    child: Container(
      width: isNative ? screenSize.width : _width,
      height: isNative ? screenSize.height : _height,
      // ...
    ),
  );
});
```

### 5.3 GetX Fork 修改 (`D:\Code\SomeRepo\getx\lib\get_instance\src\lifecycle.dart`)
新增 `$reopenLifeCycle()` 方法：
```dart
/// Marks a closed controller as active again, so it can be reused after
/// being removed from the dependency store (e.g. restored from a
/// picture-in-picture overlay). Only call this when [onClose] skipped
/// resource disposal and the instance is re-registered via `Get.put`.
void $reopenLifeCycle() {
  _isClosed = false;
}
```

---

## 6. 已知边缘情况与防护

1. **连续快速切换视频**: `stopPip` 可能在 `onClose` 执行期间被调用多次
   - 当前防护: `if (!isInPipMode && _overlayEntry == null) return;`

2. **播放器被外部销毁**: `playerInit()` 开头检查 `videoPlayerController == null`
   - 处理: 重新获取单例 `PlPlayerController.getInstance()`

3. **SponsorBlock 数据污染**: 旧 controller 的监听器在新视频中触发跳过
   - 修复: 丢弃路径中通过完整 `onClose()` 清理 `_blockListener`

---

**文档更新日期**: 2026-06-12  
**版本**: 2.2 (Fix: isClosed 不可靠导致的分段/高能进度条/SponsorBlock 失效)  
**维护**: 核心开发组
