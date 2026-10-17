# 哔哩哔哩「你不孤单，我们都在」危机干预卡片 — 逆向分析报告

## 1. 分析对象

| 项 | 值 |
|---|---|
| 文件 | `C:\Users\c\Downloads\哔哩哔哩_9.15.0.apk` |
| 版本 | 9.15.0 |
| 大小 | 210.2 MB / 25,554 个条目 |
| SHA-256 | `eee15fc57a64a419c2096177ecddc0c502981a0ffe3426b3f45cf71106fa8b97` |
| DEX | 33 个，解包后 285 MB |

工具环境限制：本机未配置 JADX / apktool，REA 的 Android provider 不可用。
因此采用「ZIP 结构清点 + DEX 字符串池解析 + resources.arsc 二进制解析 + 接口实测」的组合路线，
而非反编译到 Java 源码。

## 2. 核心结论

**卡片不是客户端硬编码，而是服务端在搜索接口响应里下发的 `tips` 模块。**

搜索 `跳楼` 时，`/x/web-interface/wbi/search/all/v2` 返回：

```json
{
  "result_type": "tips",
  "data": [
    {
      "id": 24,
      "title": "你不孤单，我们都在",
      "sub_title": "如果您需要帮助 请点击此处进入能量加油站",
      "has_bg_img": 1,
      "jump_url": "https://www.bilibili.com/blackboard/era/3ERAmwloghvazr00.html",
      "cover": "https://i0.hdslb.com/bfs/app/f1342cd72a4a042535cc8daa6c7e8c17eb8eb419.png"
    }
  ]
}
```

客户端只做通用渲染：标题、副标题、背景图、跳转地址全部来自响应体。
运营侧改文案 / 换图片 / 增加关键词都不需要发版。

## 3. 关键词实测矩阵

搜索接口 `search/all/v2`（`platform=pc`, `web_location=1430654`）：

| 关键词 | numResults | in_white_key | tips 卡片 |
|---|---|---|---|
| 自杀 | **5** | 0 | **无** |
| 跳楼 | 1000 | 1 | 有 |
| 自残 | 1000 | 0 | 有 |
| 割腕 | 1000 | 0 | 有 |
| 不想活 | 1000 | 0 | 有 |
| 想死 | 1000 | 0 | 有 |
| 轻生 | 1000 | 0 | 有 |
| 抑郁 | 1000 | 0 | 有 |
| 安乐死 | 1000 | 0 | 无 |
| 活不下去 | 1000 | 0 | 无 |
| 结束生命 | — | — | 触发风控（返回 `v_voucher`） |

### 「自杀」是服务端特例

`自杀` 的响应里 `tips` 为空数组，且 `numResults` 被压到 5（其余关键词均为 1000）。
即服务端对这个词做了结果压制，同时不下发卡片 —— 这对应参考截图 1 那个独立页面。

## 4. 全包字符串扫描（负面结论）

对全部 25,554 个文件做 UTF-8 / UTF-16LE 双编码扫描：

| 字符串 | 命中 |
|---|---|
| `能量加油站` | **无** |
| `你不孤单` | **无** |
| `82951332` | **无** |
| `3ERAmwloghvazr00` | **无** |
| `危机干预` | **无** |
| `全国24小时免费心理咨询` | `resources.arsc` × 2 |
| `blackboard/era` | 17 个文件（通用 blackboard URL 拼装器，与卡片无关） |

结论：APK 内只残留一处原生文案 `全国24小时免费心理咨询`（另有一份带 `%1$s`
占位符的变体，说明电话号码是运行时注入而非硬编码）。关键词列表、卡片文案、
热线号码都不在包内。

> 注意：DEX 里的 `suicide` 命中全部无关 —— `WebSuicide`（WebView 崩溃自恢复）、
> `bgMemSuicideEnable`（内存回收）、`dd_oom_suicide_interval`（决策引擎自杀阈值）、
> `GameWebSuicide`（游戏容器）。与心理危机干预没有任何关系。

## 5. 「能量加油站」页面

`jump_url` = `https://www.bilibili.com/blackboard/era/3ERAmwloghvazr00.html`

- 属于 B 站 `activity-plat` 的 `era` 类活动页
- 页面标题即「能量加油站」
- 页面 description：B站官方正能量暖心关怀栏目
- **页面内不含**热线号码与「复制号码」按钮 → 参考截图 1 的原生页面不是这个 H5

## 6. 落地到 PiliPlus

### 改动文件

| 文件 | 改动 |
|---|---|
| `lib/models/search/result.dart` | 新增 `SearchTip` 模型；`SearchVideoData` 增加 `searchTips` 字段；`fromSearchAll` 解析 `result_type == 'tips'` |
| `lib/pages/search_panel/all/controller.dart` | 新增 `searchTips` 状态；刷新/重置逻辑；高风险词本地兜底 |
| `lib/pages/search_panel/all/view.dart` | 在综合结果最顶部渲染提示卡片 |
| `lib/pages/search_panel/all/widgets/tip.dart` | 新建卡片组件 |

### 设计要点

1. **服务端优先**：只要有 `tips` 就原样渲染，与官方行为一致，日后运营调整自动生效。
2. **本地兜底**：`自杀` 等服务端不下发卡片的词，由 `_crisisKeywords` 列表补齐同一张卡片，
   避免高风险场景下求助入口完全消失。列表可随时增删，不影响服务端内容。
3. **跳转**：走 `PiliScheme.routePushFromUrl`，与仓库内 `SearchActivityItem` 一致，
   站内/站外地址都能正确处理。

### 未验证项

本机没有 Flutter SDK（`flutter` / `dart` 均不在 PATH），所以**没有做编译验证**。
代码按仓库现有写法逐处人工核对过（构造器签名、`NetworkImgLayer` 的
`cacheSize` 约束、`CachedNetworkImage` 的 `placeholder`/`errorBuilder` 通配符参数等）。
首次编译前建议跑一次 `flutter analyze`。

## 7. 待确认

1. 参考截图 1 的原生页面（含「复制号码」按钮）触发链路未定位成功。
   服务端对 `自杀` 的响应里没有任何指向它的字段，且 APK 内无关键词表。
   推测该页由 App 端其他接口或更上层的风控策略驱动，需要 App 接口抓包才能确认。
2. 兜底卡片里的热线 `010-82951332` 来自参考截图与官方公示，
   **不是**从 APK 中提取的（APK 内确实没有这个号码）。
3. 若希望完全复刻截图 1 的整页样式（大标题 + 独立「复制号码」按钮），
   需要新增一个 Flutter 页面，可作为下一步。

---

# 第二阶段：整页复刻 + 人工咨询入口

## 8. 整页关怀卡片

新增 `lib/utils/crisis_helper.dart` 与
`lib/pages/search_panel/all/widgets/crisis_card.dart`，用于复刻截图 1：

- 大标题「你不孤单，我们都在」
- 提示「如果需要帮助，请拨打全国24小时免费心理咨询热线」
- 「全国24小时免费心理咨询」+ 热线号码
- 粉色圆角「复制号码」按钮 → 调用 `Utils.copyText`（真实写入剪贴板 + toast）
- 底部两个文字入口：「进入能量加油站」「人工咨询」
- 背景使用纯代码渐变（白 → 浅粉 → 浅蓝），不依赖外部图片

### 两层卡片的分工

| 场景 | 判定 | 表现 |
|---|---|---|
| 服务端下发 `tips`（如 跳楼） | `searchTips != null` | 小卡片 + 正常搜索结果 |
| 服务端静默压制（如 自杀） | `searchTips == null && CrisisHelper.isCrisis(keyword)` | 整页卡片 + **屏蔽搜索结果** |

### 屏蔽视频的实现

- 卡片挂在 `buildHeader()`，即使结果为空也能展示（`buildList` 在空结果时不会被调用）
- `buildList` 在高危词下返回空 sliver，视频及其他模块全部不渲染
- 同时把结果数量角标置为 `-1`（不展示）

## 9. 「人工咨询」入口评估

### 官方实现

能量加油站 H5（`3ERAmwloghvazr00.html`）里的「客服-按钮」是一个 `EvaLinkButton`，
位于页面 `left=101, top=943`，跳转地址：

```
bilibili://link/customer/chat?shop_id=0&shop_father_id=0&situation=10&gid=164&skill_group_id=164
```

这是 B 站 App 内建的客服会话深链，带 `situation`（会话场景）、`gid` 与
`skill_group_id`（技能组路由）。页面里**没有** http(s) 降级地址。

### 结论：原生入口无法直接移植，但可以降级

| 方案 | 可行性 | 说明 |
|---|---|---|
| 直接转发 `bilibili://link/customer/chat` | ⚠️ 部分可用 | 只有装了 B 站官方 App 的设备才会被接管；PiliPlus 自身没有该路由，纯 Flutter 端无法实现 IM 会话 |
| 自建客服会话 | ❌ 不可行 | 依赖官方账号态、客服后端与技能组路由，属于闭源私有协议 |
| 打开官方 Web 客服中心 | ✅ 已采用 | `https://www.bilibili.com/v/customer-service`（实测 HTTP 200，标题「客服中心」），功能等价但需登录 |

实现上，「人工咨询」按钮走 `PiliScheme.routePushFromUrl(CrisisHelper.customerServiceUrl)`，
由客户端内置 WebView 打开官方客服中心。

若后续想进一步贴近原生体验，可以在打开前先尝试 `url_launcher` 唤起官方 App
（`bilibili://` schema），失败再回落 Web —— 但会引入「跳出当前 App」的体验问题，
默认未开启。

## 10. 本阶段改动文件

| 文件 | 改动 |
|---|---|
| `lib/utils/crisis_helper.dart` | 新建：热线号、能量加油站、客服中心地址、高危词判定 |
| `lib/pages/search_panel/all/widgets/crisis_card.dart` | 新建：整页关怀卡片 |
| `lib/pages/search_panel/all/controller.dart` | 新增 `isCrisis`；改用 `CrisisHelper`；高危词隐藏数量角标 |
| `lib/pages/search_panel/all/view.dart` | `buildHeader` 渲染整页卡片；`buildList` 屏蔽结果 |

仍然没有编译验证（本机无 Flutter SDK），首次构建前请先 `flutter analyze`。

