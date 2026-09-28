# 架构知识图谱

本目录是 [Understand-Anything](https://github.com/Egonex-AI/Understand-Anything) 为 PiliPlus 生成的**架构知识图谱**，是 [`docs/DEVELOPER_ROADMAP.md`](../DEVELOPER_ROADMAP.md) 的机器可读补充：路线图告诉你「怎么读代码」，图谱告诉你「谁依赖谁、谁调用谁、每个文件负责什么」。

图谱由 AI 分析源码生成，**全部摘要为中文**，可直接提交进仓库供团队共享与代码评审参考。

## 目录内容

| 文件 | 大小 | 用途 |
| --- | --- | --- |
| `knowledge-graph.json` | 160 KB | **主产物**：节点、边、架构分层、学习导览 |
| `fingerprints.json` | 228 KB | 每个文件的结构指纹，用于后续增量更新 |
| `meta.json` | 158 B | 分析时间、所绑定的 git commit、覆盖文件数 |
| `config.json` | 52 B | 分析配置（`outputLanguage: zh`） |
| `.understandignore` | 4 KB | 排除规则（默认全注释，按需放开） |

## 覆盖范围

分析的是**架构主干**，不是全量代码。选定理由：全项目 1317 个 Dart 文件、44.2 万行，其中 104 个生成文件就占了 58% 的行数（`*.pb.dart`、`*.g.dart` 等），全量分析噪声远大于收益。

| 指标 | 数值 |
| --- | --- |
| 分析文件 | **53**（50 个 Dart + 2 个配置 + 1 个文档），共 11,515 行 |
| 节点 | **193**（file 50 / class 66 / function 74 / config 2 / document 1） |
| 边 | **300**（contains 140 / depends_on 132 / calls 11 / inherits 6 / configures 5 / related 4 / documents 2） |
| 架构分层 | **10** |
| 学习导览 | **11** 步 |
| 中文摘要覆盖率 | 193 / 193（100%） |

**架构分层**（自下而上的依赖方向）：

```
项目配置与文档 → 通用基础 → 平台服务 → 存储与配置 → 账号与认证
              → gRPC 传输层 → HTTP 业务层 → 状态管理层 → 界面层 → 入口与启动
```

**学习导览**按依赖顺序编排，不是简单的目录罗列：

```
项目全貌 → 启动与路由 → 存储与配置 → 账号认证 → HTTP → gRPC
        → 业务接口 → 页面范式 → 视频播放链路 → 平台服务 → 通用基础
```

## 怎么查看

### 方式一：命令行直接读（无需任何依赖）

```bash
node -e '
const g = require("./docs/knowledge-graph/knowledge-graph.json");
g.layers.forEach((l, i) => console.log(`${i + 1}. ${l.name} — ${l.description}`));
console.log("---");
g.tour.forEach(s => console.log(`${s.order}. ${s.title}`));
'
```

查看某个文件的职责与依赖：

```bash
node -e '
const g = require("./docs/knowledge-graph/knowledge-graph.json");
const id = "file:lib/http/init.dart";
const n = g.nodes.find(x => x.id === id);
console.log(n.summary, "\n标签:", n.tags.join(" / "), "\n复杂度:", n.complexity);
g.edges.filter(e => e.source === id).forEach(e =>
  console.log("  ->", e.target, `(${e.type})`));
'
```

### 方式二：可视化看板

看板 CLI 只在项目根目录的 `.ua/` 或 `.understand-anything/` 下查找图谱，所以先把产物复制过去：

```bash
mkdir -p .ua && cp docs/knowledge-graph/*.json docs/knowledge-graph/.understandignore .ua/
npx https://github.com/Egonex-AI/Understand-Anything/releases/latest/download/understand-anything-viewer.tgz .
```

只需 Node ≥ 18，**不需要 LLM、不需要 API key**，数据全程在本机只读，并会打印一个带访问令牌的本地地址。

> `.ua/` 是本地工作目录，已在根 `.gitignore` 中排除，不会重复提交。

## 如何更新

图谱绑定在 `meta.json` / `knowledge-graph.json` 里记录的 git commit 上（本版本为 `4ed4167`）。代码变动后有两种刷新方式：

**增量更新（推荐）**——只重算结构指纹发生变化的文件：

```bash
# 在支持子代理的 Agent 会话中执行
/understand-anything -diff
```

**全量重新分析**：重新执行 `/understand-anything`，然后用新产物覆盖本目录。

改动较大的话，建议同步更新 [`docs/DEVELOPER_ROADMAP.md`](../DEVELOPER_ROADMAP.md)，避免两处描述不一致。

## 已知限制

**1. Dart 的依赖边是补算出来的。** Understand-Anything 官方的 `extract-import-map` 支持 13 种语言做确定性 import 解析，**Dart 不在其中且无 LLM 兜底**，实测返回 `filesWithImports=0, totalEdges=0`。本图谱没有伪造数据，而是自行解析 Dart 的 `import` 声明补出 **129 条真实内部依赖**，以 `depends_on` 形式写入。结构抽取（tree-sitter-dart）本身工作正常。

**2. 分析范围是人工挑选的。** 覆盖 53/1492 个文件（你可以在导览里看到具体是哪些）。这意味着本图谱能可靠回答「主干模块之间如何协作」，但**不能**用来回答「某个边角功能在哪实现」。

**3. 生成代码占比过高。** `lib/grpc/bilibili/**` 下的 protobuf 生成文件有 25.4 万行，已被排除。改动这些文件不会体现在图谱里。

**4. 摘要是 AI 生成的，可能有偏差。** 用作导航起点是可靠的，把它当权威文档请以源码为准。
