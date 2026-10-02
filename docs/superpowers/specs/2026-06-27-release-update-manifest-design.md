# 发布更新清单与版本判断重构设计

## 背景

当前客户端检查更新时，使用本地 `BuildConfig.buildTime` 与 GitHub release 的 `created_at` 进行比较。

这个判断存在结构性问题：

- 安装包构建时间天然早于 GitHub release 创建时间
- 用户即使已经安装当前最新 release，对应包内 `buildTime` 仍可能小于该 release 的创建时间
- 结果是客户端会误报“发现新版本”

当前上游实现也是同一思路，直接同步上游不能解决该问题。

## 目标

- 用稳定、可比较的版本标识替代 `buildTime` 作为更新判断依据
- 不依赖 GitHub release `created_at`、`published_at`
- 不依赖 release tag 的命名风格
- 不依赖 release 资产文件名作为唯一事实来源
- 保留现有 stable / pre-release 过滤逻辑
- 保留现有“跳过此版本”逻辑
- 兼容已有旧 release，避免上线后旧版本全部无法判断更新

## 非目标

- 不改动更新弹窗的主要交互和文案
- 不重做现有下载按钮与平台资产选择逻辑
- 不引入独立更新服务
- 不在本次改动中统一所有历史 release tag

## 方案选择

### 方案一：从 release 资产文件名提取远端 versionCode

优点：

- 客户端改动小
- 不需要修改发布流程

缺点：

- 强依赖文件名格式
- 文件名一旦调整就会失效
- 只能作为兼容回退，不适合作为长期协议

### 方案二：统一 release tag 规范并解析 tag_name

优点：

- 实现简单
- 客户端逻辑清晰

缺点：

- 依赖 tag 命名约定
- 历史 release 与未来 release 容易出现规则并存
- tag 更多是展示和发布标识，不适合承载完整更新协议

### 方案三：发布 manifest 资产并按 versionCode 比较

优点：

- 版本判断来源稳定
- 不依赖时间字段、tag 格式、文件名格式
- 仍可复用现有 GitHub releases API 和资产分发逻辑
- 可以为旧 release 提供兼容回退路径

缺点：

- 需要同时修改客户端和 CI 发布流程
- 检查更新时需要多一次小体积 JSON 请求

### 结论

采用方案三作为主方案，方案一作为旧 release 的兼容回退。

## 总体设计

### 核心思路

每次发布时，CI 额外生成一个固定命名的 `release-manifest.json` 并作为该 release 的 asset 上传。

客户端检查更新时：

1. 继续请求 GitHub releases 列表
2. 按现有规则筛选 stable / pre-release
3. 选定目标 release 后优先读取其 `release-manifest.json`
4. 用 `manifest.version_code` 与本地 `BuildConfig.versionCode` 比较
5. 若 manifest 不存在，则回退为从资产文件名中提取远端 `versionCode`
6. 若仍无法得到可比较版本号，则视为“无法确认更新”，不再用 `buildTime` 兜底

## 数据协议

### release-manifest.json

首版字段控制在最小必要集合：

```json
{
  "schema_version": 1,
  "version_name": "2.0.9",
  "version_code": 5461,
  "commit_hash": "da5fd1055...",
  "release_tag": "v2.0.9+1-20260618"
}
```

### 字段说明

- `schema_version`
  - manifest 协议版本
  - 便于以后扩展字段或调整解析规则
- `version_name`
  - 展示用途
  - 对应当前构建版本名
- `version_code`
  - 更新判断的唯一比较字段
  - 客户端仅比较这个整数
- `commit_hash`
  - 调试与追踪用途
- `release_tag`
  - 与 GitHub release tag 对齐
  - 供日志、跳过版本和问题排查使用

## 客户端设计

### 新增职责拆分

将 `lib/utils/update.dart` 中“选择 release”与“判断是否有更新”的逻辑拆分为纯函数层，便于测试：

- 选择目标 release
- 从 manifest 解析远端版本元数据
- 从旧资产文件名回退提取远端 `versionCode`
- 比较远端与本地版本号

### 更新判断规则

目标 release 选定后：

1. 若能成功获取并解析 manifest：
   - 当 `remote.version_code > local.versionCode` 时判定为有更新
   - 否则判定为已是最新版本
2. 若 manifest 不存在：
   - 尝试从资产文件名解析远端 `versionCode`
   - 解析成功后同样按整数比较
3. 若 manifest 和资产文件名都无法提供版本号：
   - 判定为无法确认更新
   - 手动检查时提示“无法解析远端版本信息”
   - 自动检查时静默退出

### 跳过版本逻辑

继续沿用“按版本跳过”的思路，但存储值统一为 `release_tag`：

- 如果自动检查且 `Pref.skipVersion == remote.releaseTag`，则静默忽略
- manifest 存在时优先使用 `manifest.release_tag`
- 无 manifest 时回退为 release 的 `tag_name`

这样可以保持与现有设置兼容，也避免直接用 `versionCode` 跳过导致不同渠道展示信息不一致。

### 预发布逻辑

保持现有逻辑不变：

- `Pref.preReleaseUpdate == false` 时仅看 `prerelease != true`
- `Pref.preReleaseUpdate == true` 时允许选择 pre-release

manifest 不承担渠道过滤职责，渠道过滤仍由 GitHub release 元数据决定。

### UI 展示

弹窗继续展示：

- GitHub release 的 `tag_name`
- GitHub release 的 `body`

不改现有下载按钮逻辑与资产筛选逻辑。

## CI / 发布流程设计

### manifest 生成方式

在现有预构建脚本基础上，增加生成 `release-manifest.json` 的逻辑。

文件内容来自当前构建事实：

- `version_name`：现有脚本解析出的版本名
- `version_code`：现有脚本生成的构建号
- `commit_hash`：当前 commit hash
- `release_tag`：
  - 对于单平台直接发布工作流，使用当前实际发布的 `release_tag`
  - 对于聚合发布工作流，使用最终创建 release 时的 tag

### 需要改动的发布链路

至少覆盖以下路径：

- Android 直接发布工作流
- iOS 直接发布工作流
- Windows 直接发布工作流
- Linux 直接发布工作流
- macOS 直接发布工作流
- `sync_upstream_build.yml` 聚合发布流程

### 实现要求

- `release-manifest.json` 文件名固定
- 每个 release 最多上传一份 manifest
- 聚合 release 的 manifest 必须与最终 release tag 一致

## 兼容策略

### 新 release

新发布版本都应包含 `release-manifest.json`，客户端走主路径判断。

### 旧 release

旧 release 没有 manifest，客户端走兼容回退：

- 从资产文件名提取 `+<number>` 作为远端 `versionCode`
- 适配 Android / iOS / Windows / Linux / macOS 现有常见命名

### 无法兼容的旧 release

如果某个旧 release：

- 没有 manifest
- 资产文件名也无法提取版本号

则该 release 不参与“确认有更新”的判断。客户端不得再次回退到 `buildTime` 逻辑。

## 测试设计

### 纯逻辑测试

新增针对更新比较逻辑的单元测试，至少覆盖：

- manifest 正常解析
- `remote.version_code > local.versionCode` 判定为有更新
- `remote.version_code == local.versionCode` 判定为无更新
- `remote.version_code < local.versionCode` 判定为无更新
- 旧资产文件名可正确提取远端 `versionCode`
- manifest 缺失时正确回退
- manifest 和资产都无法解析时返回“无法判断”

### 回归验证

手动或代码复核确认：

- 预发布过滤逻辑保持不变
- “跳过此版本”仍按 release 标识工作
- Android 最优资产选择逻辑不受影响
- 手动检查更新和自动检查更新的分支行为保持一致

## 风险与约束

### 风险

- 若某条发布工作流漏传 manifest，该 release 会走旧资产文件名回退
- 若未来资产命名规则变化，旧 release 回退能力会下降
- 聚合 release 与单平台 release 的 tag 来源不同，manifest 生成时必须使用最终发布 tag

### 约束

- 客户端不能假设 GitHub API 一定返回某个固定顺序外的额外字段
- 不能继续使用 `buildTime` 作为判断依据
- 不能把 tag 规则当作唯一事实来源

## 实施步骤

1. 为客户端更新判断抽出纯逻辑层并补失败测试
2. 实现 manifest 解析与旧资产文件名回退
3. 移除 `buildTime` 参与更新判断的路径
4. 调整发布脚本生成 `release-manifest.json`
5. 调整各发布工作流上传 manifest
6. 运行针对性测试与工作流配置复核

## 验收标准

- 安装当前最新 release 时，不再因为 release 创建时间晚于构建时间而误报更新
- 新发布版本包含固定命名的 `release-manifest.json`
- 客户端更新判断不再依赖 `buildTime`
- 对没有 manifest 的旧 release 仍有兼容能力
