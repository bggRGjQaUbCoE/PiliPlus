# PiliPlus1 原始提交历史迁移

## Current State

2026-10-21 后续仓库改名：已按用户授权将旧仓改为 `Goodwu/PiliPlus.old`（ID `R_kgDOVH5pww`），原PiliPlus1改为 `Goodwu/PiliPlus`（ID `R_kgDOVR4zZw`）。新仓main与goodwu-dev-rebased SHA未变。本地origin已指向新仓，old保留旧仓；独立迁移克隆的两remote也已同步改正。

本地切换已完成：用户确认另一任务已暂停后，保存快照及stash -u，切到 `goodwu-dev-rebased@9c77d6e97` 并跟踪新仓origin同名分支，再stash apply恢复。8个tracked文件与预计算三方合并逐字节一致，8个untracked SHA256一致，无冲突；其中3个已有文件自动适配新上游变化（包含PlayOwner Type?）。快照与stash保留，业务修改未commit/push。旧仓镜像workflow使用github.repository和本仓GITHUB_TOKEN，不会因名称复用改写新仓。

用户最新明确：从旧仓 `feature/ohos` 迁移我们的原始提交到**新分支**，再 Rebase 到最新 `Goodwu/PiliPlus1/main`。迁移阶段仅推新分支 `goodwu-dev-rebased`；用户随后授权评估并删除无必要的两个旧分支，现已完成删除。原仓脏改动保留，迁移在独立克隆 `/Users/wuweiwei1/src/PiliPlus1-rebase-20261021` 进行。

- 已完成 Rebase：源 `55509baa617087ae3c280ea30d141e68b69e6248`，新基线 `a5665fbe3492d1eb09a2e22ca8ae1fea4f07a255`，旧共同祖先 `849c56b035ac8acf1b4fd677c2c94debe161da8e`。
- 候选分支 `goodwu-dev-rebased@9c77d6e97f82f8ec24eac849bb3428cd966fa5fa`，保留13个原始提交作者、时间及标题；目标27个更新保留。
- 删除前的两个旧分支均为 `fcd7197185cd3ca88da0f3298074f1b711d23a53`，含15个文件迁移提交；候选与其文件树均为 `3939c9de46a842e682d9492c2a77daa38c40e32e`，内容完全一致。
- 已完成：仅创建并推送远端 `goodwu-dev-rebased@9c77d6e97`。迁移推送后两个旧分支当时未动；随后按用户新授权原子删除两个冗余分支。最终main仍a5665fbe3，新分支仍9c77d6e97，两旧远端ref已不存在。独立克隆tracked clean。

## Findings

- 临时克隆删除评估：`~/src/PiliPlus1-rebase-20261021`无dirty或未跟踪文件、无未推送提交，约411M。原.git/migration-20261021下6份备份/映射/核验材料已复制至主工作区.git/migration-20261021-retained，逐文件SHA256一致且bundle在主仓验证通过。临时目录已无必须保留的独有成果，当前尚未删除；检测到一个长期bash终端cwd位于目录中，删除前应先退出该目录。

- 独立收尾审核通过：repo身份与HEAD/upstream正确；16个文件快照与stash逐字节一致；排除本轮两份记录更新后，业务/环境文件符合预计算恢复与新上游差异，无未合并文件，index空。只验证Git迁移与保全，不代表EOF业务运行验收。

- 改名/本地切换收尾：当前origin=https://github.com/Goodwu/PiliPlus.git（原PiliPlus1），old=https://github.com/Goodwu/PiliPlus.old.git。GitHub repo ID分别R_kgDOVR4zZw、R_kgDOVH5pww。保留本地feature/ohos旧历史和old跟踪。
- 本地快照：`.git/migration-20261021-local-switch/snapshot-5j3qtxzo/`（manifest/working-files.tar/working.patch/index.patch/expected）。stash SHA记录在`.git/migration-20261021-local-switch/restoration-stash.txt`，已apply，未drop。
- 暂停后实际保护范围为8个tracked和8个untracked文件（较预审核增加了EOF业务路径，按实际快照完整处理）；旧/新基线不同的三个文件预先用git merge-file计算expected，恢复后逐字节一致。任务与本归档随后仅追加本轮交付状态。本轮没有重跑EOF业务测试、构建或设备验收。

- 后续清理（用户明确授权）：两旧分支tree与新分支完全相同；默认分支main，无PR，无ruleset/分支保护，仓内各远端分支未发现旧分支名依赖。V2独立复核通过后，用两个旧SHA的精确lease原子删除远端 goodwu-dev 和 goodwu-dev-file-migration，实时复查均已不存在。
- 旧15个文件迁移提交与原始13提交历史不同，故删除前保留bundle：`/Users/wuweiwei1/src/PiliPlus/.git/migration-20261021-retained/file-migration-backup.bundle`，git bundle verify通过，两个ref均为fcd719718，前置提交a5665fbe3由保留的新分支可达。SHA256：`d2d30a10bbf07fe65d0f77af08dccfabec434ae73c4f4c0406d578ab35541473`。本地对象可读取为commit。恢复时可从bundle fetch旧ref后重新push，无需重新生成文件迁移提交。

- 用户更正：不在goodwu-dev与备份之间迁移，也不替换goodwu-dev。此前Lead将最终操作理解为替换正式分支，已撤销此计划；实际Git操作始终只是从old/feature/ohos建新分支并rebase，未对任何远端分支写入。

- 2026-10-21：实时核对源仓本地和远端 feature/ohos一致，无漏掉的本地提交。
- 唯一冲突在 pubspec.lock 的 media_kit_video 项：保留原提交 path `../media-kit/media_kit_video`，匹配 pubspec_overrides.yaml。range-diff 其余12提交完全一致；该提交仅上下文及被替换的旧依赖ref不同。
- 原仓已有EOF调查归档修改、未跟踪环境文件均未修改。新任务记录单独留原仓待审，不额外加入13个迁移提交。
- 验证日志：`/tmp/piliplus1-migration-20261021/`。完整OHOS HAP及设备播放未在本轮重验，不能将历史迁移等同产品端到端验收。

## Validation and Delivery

- 历史审核V2通过：13个提交的作者、作者时间和消息保留，目标27个上游提交全部保留。`git fsck --no-reflogs`通过；提交映射与range-diff已保留于主工作区 `.git/migration-20261021-retained/`。
- Flutter 3.47.7/Dart3.13.5：12/12测试通过；Android arm64 Release bundle编译exit0。验证类型为kernel及资源构建，不是APK、完整OHOS HAP或设备运行验收。
- OHOS Python单测：`TMPDIR=/private/tmp` 下54/54通过；默认macOS临时目录/var符号链接导致13项失败，改用规范目录后通过。
- Flutter analyze：71 issues（13 error、1 warning、57 info）；全部error在tool/ohos（官方SDK无TargetPlatform.ohos等），lib无error。未宣称全量分析通过。
- OHOS check-source仍拒绝6个已有业务文件变更，继承的仅新增契约与当前tree不符。OHOS CI硬编码检出旧仓且触发分支仍为feature/ohos，未在本轮修复，也未宣称新仓OHOS CI可用。
- 隔离环境准备：pub get未修改锁；material_ui-1.8.0副本按当前patch.ps1 Android流程应用9个补丁，只调整ignored package_config的rootUri，共享SDK/pub-cache未修改。pub get生成的两xcconfig修改已保存patch并定向恢复。
- media-kit为相邻当前源码工作区 `98c611a343`，其既有dirty real.dart未改；本轮未构建/下载native libmpv。
- 交付：`https://github.com/Goodwu/PiliPlus1/tree/goodwu-dev-rebased`。本轮没有force push，没有创建PR，没有修改源仓分支或两个既有目标分支。

## Archive Metadata

- date: 2026-10-21
- source: Goodwu/PiliPlus feature/ohos
- target: Goodwu/PiliPlus1 goodwu-dev-rebased
