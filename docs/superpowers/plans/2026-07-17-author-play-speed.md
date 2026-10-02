# 作者专属倍速 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 在倍速设置页管理「作者 → 专属倍速」名单，UGC 视频按 `owner.mid` 以该倍速开播；未配置作者使用全局默认倍速；播放中手动改速仅本次有效。

**Architecture:** 抽出纯数据模型与解析函数（可单测）；经 Hive/`Pref` 持久化；在现有「倍速设置」页扩展名单管理（昵称搜索 + UID）；在 `PlPlayerController` 维护「当前视频 effective 默认倍速」，由 UGC intro 拿到 `owner.mid` 后注入，切集时重套。

**Tech Stack:** Flutter/Dart、GetX、Hive CE、`flutter_test`、现有 `SearchHttp` / `MemberHttp`

**Spec:** `docs/superpowers/specs/2026-07-17-author-play-speed-design.md`

## Global Constraints

- 每个作者各自一个倍速（`mid` 唯一）
- 管理入口仅设置页（扩展现有 `/playSpeedSet`）
- 添加方式：昵称搜索 + 直接 UID
- 生效范围：仅 UGC；非 UGC / mid 缺失 → 全局默认
- 手动改速：仅当前会话，不写 Pref / 不写作者名单
- 添加时倍速只能从当前 `Pref.speedList` 选择
- 名单中的 speed 按数值生效，不要求仍在 `speedList` 中
- 设置页改规则不要求热更新当前正在播放的会话
- 不改长按倍速语义
- 文案与交互使用简体中文

## File Map

| 文件 | 职责 |
| --- | --- |
| Create: `lib/models/common/video/author_play_speed.dart` | `AuthorPlaySpeed` 模型 + 纯解析函数 |
| Create: `test/models/common/video/author_play_speed_test.dart` | 模型与解析单测 |
| Modify: `lib/utils/storage_key.dart` | 新增 `VideoBoxKey.authorPlaySpeeds` |
| Modify: `lib/utils/storage_pref.dart` | 读写名单 + `playSpeedForAuthor` |
| Modify: `lib/pages/setting/pages/play_speed_set.dart` | 作者专属倍速 UI |
| Modify: `lib/plugin/pl_player/controller.dart` | effective 默认倍速与按作者应用 |
| Modify: `lib/pages/video/introduction/ugc/controller.dart` | intro 拿到 owner 后注入倍速 |
| Modify: `lib/pages/video/controller.dart` | 非 UGC / 本地文件回退全局默认（如需要） |

---

### Task 1: 模型与纯解析逻辑（TDD）

**Files:**
- Create: `lib/models/common/video/author_play_speed.dart`
- Create: `test/models/common/video/author_play_speed_test.dart`

**Interfaces:**
- Consumes: 无
- Produces:
  - `class AuthorPlaySpeed { final int mid; final String name; final double speed; ... }`
  - `AuthorPlaySpeed.fromJson(Map)` / `toJson()`
  - `Map<int, AuthorPlaySpeed> decodeAuthorPlaySpeeds(dynamic raw)`
  - `List<Map<String, dynamic>> encodeAuthorPlaySpeeds(Map<int, AuthorPlaySpeed> map)`
  - `double resolvePlaySpeedForAuthor({required int? mid, required Map<int, AuthorPlaySpeed> authorSpeeds, required double defaultSpeed})`

- [ ] **Step 1: 写失败测试**

```dart
import 'package:PiliPlus/models/common/video/author_play_speed.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthorPlaySpeed', () {
    test('round-trips through json map list', () {
      final original = {
        123: const AuthorPlaySpeed(mid: 123, name: 'Alice', speed: 1.5),
        456: const AuthorPlaySpeed(mid: 456, name: 'UID:456', speed: 2.0),
      };

      final encoded = encodeAuthorPlaySpeeds(original);
      final decoded = decodeAuthorPlaySpeeds(encoded);

      expect(decoded.length, 2);
      expect(decoded[123]?.name, 'Alice');
      expect(decoded[123]?.speed, 1.5);
      expect(decoded[456]?.speed, 2.0);
    });

    test('decode tolerates string mid keys and partial maps', () {
      final decoded = decodeAuthorPlaySpeeds([
        {'mid': '789', 'name': 'Bob', 'speed': 1.25},
        {'mid': 'bad', 'name': 'x', 'speed': 1.0},
        {'name': 'missing mid', 'speed': 1.0},
      ]);

      expect(decoded.keys, [789]);
      expect(decoded[789]?.name, 'Bob');
      expect(decoded[789]?.speed, 1.25);
    });

    test('resolvePlaySpeedForAuthor prefers author speed then default', () {
      final map = {
        1: const AuthorPlaySpeed(mid: 1, name: 'A', speed: 1.5),
      };

      expect(
        resolvePlaySpeedForAuthor(
          mid: 1,
          authorSpeeds: map,
          defaultSpeed: 1.0,
        ),
        1.5,
      );
      expect(
        resolvePlaySpeedForAuthor(
          mid: 2,
          authorSpeeds: map,
          defaultSpeed: 1.0,
        ),
        1.0,
      );
      expect(
        resolvePlaySpeedForAuthor(
          mid: null,
          authorSpeeds: map,
          defaultSpeed: 1.0,
        ),
        1.0,
      );
    });
  });
}
```

- [ ] **Step 2: 运行测试确认失败**

Run: `flutter test test/models/common/video/author_play_speed_test.dart`

Expected: FAIL（库/文件不存在）

- [ ] **Step 3: 写最小实现**

```dart
// lib/models/common/video/author_play_speed.dart
class AuthorPlaySpeed {
  const AuthorPlaySpeed({
    required this.mid,
    required this.name,
    required this.speed,
  });

  final int mid;
  final String name;
  final double speed;

  factory AuthorPlaySpeed.fromJson(Map json) {
    final midRaw = json['mid'];
    final mid = midRaw is int ? midRaw : int.tryParse(midRaw?.toString() ?? '');
    if (mid == null) {
      throw FormatException('invalid mid: $midRaw');
    }
    final speedRaw = json['speed'];
    final speed = speedRaw is num
        ? speedRaw.toDouble()
        : double.tryParse(speedRaw?.toString() ?? '') ?? 1.0;
    final name = (json['name'] as String?)?.trim();
    return AuthorPlaySpeed(
      mid: mid,
      name: (name == null || name.isEmpty) ? 'UID:$mid' : name,
      speed: speed,
    );
  }

  Map<String, dynamic> toJson() => {
        'mid': mid,
        'name': name,
        'speed': speed,
      };

  AuthorPlaySpeed copyWith({String? name, double? speed}) {
    return AuthorPlaySpeed(
      mid: mid,
      name: name ?? this.name,
      speed: speed ?? this.speed,
    );
  }
}

Map<int, AuthorPlaySpeed> decodeAuthorPlaySpeeds(dynamic raw) {
  final result = <int, AuthorPlaySpeed>{};
  if (raw is! List) return result;
  for (final item in raw) {
    if (item is! Map) continue;
    try {
      final entry = AuthorPlaySpeed.fromJson(item);
      result[entry.mid] = entry;
    } catch (_) {}
  }
  return result;
}

List<Map<String, dynamic>> encodeAuthorPlaySpeeds(
  Map<int, AuthorPlaySpeed> map,
) {
  return map.values.map((e) => e.toJson()).toList(growable: false);
}

double resolvePlaySpeedForAuthor({
  required int? mid,
  required Map<int, AuthorPlaySpeed> authorSpeeds,
  required double defaultSpeed,
}) {
  if (mid == null) return defaultSpeed;
  return authorSpeeds[mid]?.speed ?? defaultSpeed;
}
```

- [ ] **Step 4: 运行测试确认通过**

Run: `flutter test test/models/common/video/author_play_speed_test.dart`

Expected: All tests passed

- [ ] **Step 5: Commit**

```bash
git add lib/models/common/video/author_play_speed.dart \
  test/models/common/video/author_play_speed_test.dart
git commit -m "$(cat <<'EOF'
feat(play-speed): 添加作者专属倍速模型与解析

抽出可单测的 AuthorPlaySpeed 编解码与 effective 倍速解析。
EOF
)"
```

---

### Task 2: 存储 key 与 Pref API

**Files:**
- Modify: `lib/utils/storage_key.dart`（`VideoBoxKey` 段）
- Modify: `lib/utils/storage_pref.dart`（紧挨 `playSpeedDefault` / `speedList`）

**Interfaces:**
- Consumes: `AuthorPlaySpeed`, `decodeAuthorPlaySpeeds`, `encodeAuthorPlaySpeeds`, `resolvePlaySpeedForAuthor`
- Produces:
  - `VideoBoxKey.authorPlaySpeeds`
  - `Pref.authorPlaySpeeds` getter/setter → `Map<int, AuthorPlaySpeed>`
  - `Pref.playSpeedForAuthor(int? mid)` → `double`
  - `Pref.upsertAuthorPlaySpeed(AuthorPlaySpeed entry)`
  - `Pref.removeAuthorPlaySpeed(int mid)`

- [ ] **Step 1: 扩展 `VideoBoxKey`**

在 `lib/utils/storage_key.dart` 的 `VideoBoxKey` 中追加：

```dart
abstract final class VideoBoxKey {
  static const String playRepeat = 'playRepeat',
      playSpeedDefault = 'playSpeedDefault',
      longPressSpeedDefault = 'longPressSpeedDefault',
      speedsList = 'speedsList',
      authorPlaySpeeds = 'authorPlaySpeeds',
      cacheVideoFit = 'cacheVideoFit';
}
```

- [ ] **Step 2: 在 `Pref` 增加读写**

在 `lib/utils/storage_pref.dart` 中，靠近 `playSpeedDefault` 处添加（保持文件现有 import 风格，补上 `author_play_speed.dart` import）：

```dart
static Map<int, AuthorPlaySpeed> get authorPlaySpeeds =>
    decodeAuthorPlaySpeeds(_video.get(VideoBoxKey.authorPlaySpeeds));

static set authorPlaySpeeds(Map<int, AuthorPlaySpeed> value) {
  _video.put(VideoBoxKey.authorPlaySpeeds, encodeAuthorPlaySpeeds(value));
}

static double playSpeedForAuthor(int? mid) {
  return resolvePlaySpeedForAuthor(
    mid: mid,
    authorSpeeds: authorPlaySpeeds,
    defaultSpeed: playSpeedDefault,
  );
}

static void upsertAuthorPlaySpeed(AuthorPlaySpeed entry) {
  final map = Map<int, AuthorPlaySpeed>.from(authorPlaySpeeds);
  map[entry.mid] = entry;
  authorPlaySpeeds = map;
}

static void removeAuthorPlaySpeed(int mid) {
  final map = Map<int, AuthorPlaySpeed>.from(authorPlaySpeeds);
  if (map.remove(mid) != null) {
    authorPlaySpeeds = map;
  }
}
```

- [ ] **Step 3: 静态分析相关文件**

Run: `dart analyze lib/utils/storage_key.dart lib/utils/storage_pref.dart lib/models/common/video/author_play_speed.dart`

Expected: No issues

- [ ] **Step 4: Commit**

```bash
git add lib/utils/storage_key.dart lib/utils/storage_pref.dart
git commit -m "$(cat <<'EOF'
feat(play-speed): 持久化作者专属倍速名单

通过 VideoBoxKey/Pref 读写 Hive，并提供按 mid 解析 effective 默认倍速。
EOF
)"
```

---

### Task 3: 倍速设置页 — 名单列表 / UID 添加 / 编辑 / 删除

**Files:**
- Modify: `lib/pages/setting/pages/play_speed_set.dart`

**Interfaces:**
- Consumes: `Pref.authorPlaySpeeds`, `Pref.upsertAuthorPlaySpeed`, `Pref.removeAuthorPlaySpeed`, `Pref.speedList`, `AuthorPlaySpeed`
- Produces: 设置页「作者专属倍速」区块（本 Task 先完成 UID 路径；搜索在 Task 4）

- [ ] **Step 1: 在 `_PlaySpeedPageState` 增加本地状态**

```dart
late Map<int, AuthorPlaySpeed> authorPlaySpeeds = Pref.authorPlaySpeeds;
```

并加 helper：

```dart
void _persistAuthorSpeeds(Map<int, AuthorPlaySpeed> next) {
  Pref.authorPlaySpeeds = next;
  setState(() => authorPlaySpeeds = next);
}

Future<void> _pickSpeed({
  required String title,
  required double initial,
  required ValueChanged<double> onPicked,
}) async {
  if (speedList.isEmpty) {
    SmartDialog.showToast('请先在倍速列表中添加倍速');
    return;
  }
  double selected = speedList.contains(initial) ? initial : speedList.first;
  final res = await showDialog<double>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: StatefulBuilder(
          builder: (context, setLocal) {
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: speedList
                  .map(
                    (s) => ChoiceChip(
                      label: Text(s.toString()),
                      selected: selected == s,
                      onSelected: (_) => setLocal(() => selected = s),
                    ),
                  )
                  .toList(),
            );
          },
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('取消')),
          TextButton(
            onPressed: () => Get.back(result: selected),
            child: const Text('确定'),
          ),
        ],
      );
    },
  );
  if (res != null) onPicked(res);
}
```

- [ ] **Step 2: 实现「仅 UID 添加」对话框（搜索占位入口留给 Task 4）**

```dart
Future<void> onAddAuthorSpeed() async {
  final uidCtrl = TextEditingController();
  String name = '';
  try {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('添加作者专属倍速'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: uidCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: FilteringText.digitsOnly,
                decoration: const InputDecoration(
                  labelText: '用户 UID',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                ),
              ),
              // Task 4 会在此处插入搜索框与结果列表
            ],
          ),
          actions: [
            TextButton(onPressed: Get.back, child: const Text('取消')),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('下一步'),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;

    final mid = int.tryParse(uidCtrl.text.trim());
    if (mid == null || mid <= 0) {
      SmartDialog.showToast('请输入有效 UID');
      return;
    }

    // 尽量解析昵称；失败则 UID:mid
    name = 'UID:$mid';
    try {
      final res = await MemberHttp.memberCardInfo(mid: mid);
      if (res case Success(:final response)) {
        final n = response.card?.name?.trim();
        if (n != null && n.isNotEmpty) name = n;
      }
    } catch (_) {}

    final existing = authorPlaySpeeds[mid];
    if (existing != null) {
      SmartDialog.showToast('该作者已存在，将更新倍速');
      name = existing.name.isNotEmpty ? existing.name : name;
    }

    await _pickSpeed(
      title: '选择 $name 的倍速',
      initial: existing?.speed ?? playSpeedDefault,
      onPicked: (speed) {
        final next = Map<int, AuthorPlaySpeed>.from(authorPlaySpeeds);
        next[mid] = AuthorPlaySpeed(mid: mid, name: name, speed: speed);
        _persistAuthorSpeeds(next);
        SmartDialog.showToast('已保存');
      },
    );
  } finally {
    uidCtrl.dispose();
  }
}
```

注意：
- 项目里数字过滤可能是 `FilteringTextInputFormatter.digitsOnly` 或 `FilteringText.digitsOnly`——**以 `play_speed_set.dart` / 邻近文件现有用法为准**
- 补齐 import：`member.dart`、`author_play_speed.dart`、`loading_state.dart` 等

- [ ] **Step 3: 在 `build` 的 `ListView` 中、倍速列表区块之后追加 UI**

```dart
Padding(
  padding: const EdgeInsets.only(left: 14, right: 14, top: 12, bottom: 6),
  child: Row(
    children: [
      Text('作者专属倍速', style: theme.textTheme.titleMedium),
      const SizedBox(width: 12),
      TextButton(onPressed: onAddAuthorSpeed, child: const Text('添加')),
    ],
  ),
),
Padding(
  padding: const EdgeInsets.only(left: 14, right: 14, bottom: 8),
  child: Text(
    '指定 UP 主的视频以专属倍速开播；未列出的作者使用上方默认倍速。播放中手动改速仅本次有效。',
    style: TextStyle(color: theme.colorScheme.outline, fontSize: 12),
  ),
),
if (authorPlaySpeeds.isEmpty)
  const ListTile(title: Text('尚未添加作者，点击添加'))
else
  ...authorPlaySpeeds.values.map((item) {
    return ListTile(
      title: Text(item.name),
      subtitle: Text('UID: ${item.mid}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${item.speed}x'),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              final next = Map<int, AuthorPlaySpeed>.from(authorPlaySpeeds)
                ..remove(item.mid);
              _persistAuthorSpeeds(next);
            },
          ),
        ],
      ),
      onTap: () => _pickSpeed(
        title: '修改 ${item.name} 的倍速',
        initial: item.speed,
        onPicked: (speed) {
          final next = Map<int, AuthorPlaySpeed>.from(authorPlaySpeeds);
          next[item.mid] = item.copyWith(speed: speed);
          _persistAuthorSpeeds(next);
        },
      ),
    );
  }),
```

- [ ] **Step 4: 本地手测（UID 路径）**

Run: 启动 App → 播放设置 → 倍速设置

验收：
1. 用已知 UID 添加作者并选 1.5x，列表显示昵称/UID 与 1.5x
2. 点行可改倍速
3. 删除后列表消失
4. 重复添加同一 UID 提示更新

- [ ] **Step 5: Commit**

```bash
git add lib/pages/setting/pages/play_speed_set.dart
git commit -m "$(cat <<'EOF'
feat(play-speed): 倍速设置页支持作者专属倍速管理

支持 UID 添加、修改倍速与删除规则，名单持久化到本地。
EOF
)"
```

---

### Task 4: 添加流程接入昵称搜索

**Files:**
- Modify: `lib/pages/setting/pages/play_speed_set.dart`

**Interfaces:**
- Consumes: `SearchHttp.searchByType`, `SearchType.bili_user`, `SearchUserData` / `SearchUserItemModel`
- Produces: 添加对话框内搜索框 + 结果点选，再进入选倍速

- [ ] **Step 1: 把添加对话框升级为「搜索 + UID」同页**

将 `onAddAuthorSpeed` 的 dialog content 改为 `StatefulBuilder`，包含：

```dart
// 伪结构 — 实现时写完整可编译代码
TextField(
  // 搜索关键词
  decoration: InputDecoration(labelText: '搜索昵称'),
  onSubmitted: (_) => doSearch(),
),
TextButton(onPressed: doSearch, child: Text('搜索')),
if (searching) LinearProgressIndicator(),
if (results.isNotEmpty)
  SizedBox(
    height: 180,
    child: ListView.builder(
      itemCount: results.length,
      itemBuilder: (_, i) {
        final u = results[i];
        return ListTile(
          title: Text(u.uname ?? 'UID:${u.mid}'),
          subtitle: Text('UID: ${u.mid}'),
          onTap: () {
            // 关闭外层 dialog 前，把 mid/name 带回
            selectedMid = u.mid;
            selectedName = u.uname ?? 'UID:${u.mid}';
            Get.back(result: true);
          },
        );
      },
    ),
  ),
const Divider(),
TextField(controller: uidCtrl, /* UID 输入 */),
```

搜索调用模式（对齐现有 `SearchHttp.searchByType`）：

```dart
final res = await SearchHttp.searchByType<SearchUserData>(
  searchType: SearchType.bili_user,
  keyword: keyword,
  page: 1,
  onSuccess: (_) {},
);
if (res case Success(:final response)) {
  results = response.list ?? <SearchUserItemModel>[];
} else {
  SmartDialog.showToast('搜索失败，可改用 UID 添加');
}
```

**签名以 `lib/http/search.dart` 当前定义为准**；若泛型/参数名有出入，按源码修正，不要臆造 API。

- [ ] **Step 2: 统一选中后的保存路径**

无论搜索点选还是 UID「下一步」：
1. 得到 `mid` + `name`
2. 已存在则 toast「将更新倍速」
3. `_pickSpeed` → `upsert` 名单

UID 路径仍保留 `MemberHttp.memberCardInfo` 解析昵称。

- [ ] **Step 3: 手测搜索路径**

验收：
1. 输入昵称关键词能出结果并点选
2. 搜索失败时 toast，UID 仍可用
3. 选人后选倍速可保存

- [ ] **Step 4: Commit**

```bash
git add lib/pages/setting/pages/play_speed_set.dart
git commit -m "$(cat <<'EOF'
feat(play-speed): 作者专属倍速支持昵称搜索添加

添加对话框同时支持用户搜索点选与 UID 输入。
EOF
)"
```

---

### Task 5: 播放器 effective 默认倍速

**Files:**
- Modify: `lib/plugin/pl_player/controller.dart`

**Interfaces:**
- Consumes: `Pref.playSpeedForAuthor`, `Pref.playSpeedDefault`
- Produces:
  - `int? _authorMidForSpeed`
  - `void applyAuthorDefaultSpeed(int? mid, {bool force = true})`
  - 更新 `setDefaultSpeed` / `resetTempSettings` 使用当前 effective `playSpeedDefault`

- [ ] **Step 1: 在倍速相关字段旁增加作者 mid 缓存**

现有：

```dart
double playSpeedDefault = Pref.playSpeedDefault;
```

改为保持该字段为 **当前视频 effective 默认**，并增加：

```dart
int? _authorMidForSpeed;

/// 按作者更新当前视频的默认倍速。
/// [force] 为 true 时立即 setPlaybackSpeed；为 false 时只更新 playSpeedDefault 基准。
Future<void> applyAuthorDefaultSpeed(int? mid, {bool force = true}) async {
  _authorMidForSpeed = mid;
  final next = Pref.playSpeedForAuthor(mid);
  playSpeedDefault = next;
  if (force) {
    await setPlaybackSpeed(next);
  }
}

void resetAuthorDefaultSpeedToGlobal({bool force = false}) {
  _authorMidForSpeed = null;
  playSpeedDefault = Pref.playSpeedDefault;
  if (force) {
    unawaited(setPlaybackSpeed(playSpeedDefault));
  }
}
```

- [ ] **Step 2: 修正 `setDefaultSpeed`**

现有实现已写 `_playbackSpeed` 与 `playSpeedDefault` 字段，确认它使用的是字段而非再次读全局 Pref：

```dart
Future<void> setDefaultSpeed() async {
  await _videoPlayerController?.setRate(playSpeedDefault);
  _playbackSpeed.value = playSpeedDefault;
}
```

若有任何 `Pref.playSpeedDefault` 直读导致作者规则被绕过，改为使用字段 `playSpeedDefault`。

- [ ] **Step 3: 修正 `resetTempSettings`**

将：

```dart
if (_playbackSpeed.value != playSpeedDefault) {
  unawaited(setPlaybackSpeed(playSpeedDefault));
}
```

保持逻辑，但确保此处 `playSpeedDefault` 已是当前作者 effective 值。  
在 `setDataSource` 进入非 UGC / live 时调用 `resetAuthorDefaultSpeedToGlobal()`（不要 force 抢在 open 前误设；与 `_initializePlayer` 配合）。

推荐在 `setDataSource` 中、`this.isLive = isLive` / `_videoType = ...` 赋值后：

```dart
if (isLive || (_videoType != VideoType.ugc)) {
  // 非 UGC：回到全局默认基准；真正 setRate 仍由 _initializePlayer 处理
  resetAuthorDefaultSpeedToGlobal(force: false);
}
```

UGC 的 mid 注入由 Task 6 负责（intro 到达后 `applyAuthorDefaultSpeed`）。

- [ ] **Step 4: 分析播放器文件**

Run: `dart analyze lib/plugin/pl_player/controller.dart`

Expected: No issues

- [ ] **Step 5: Commit**

```bash
git add lib/plugin/pl_player/controller.dart
git commit -m "$(cat <<'EOF'
feat(player): 支持按作者应用 effective 默认倍速

维护当前视频默认倍速基准，非 UGC 回退全局默认。
EOF
)"
```

---

### Task 6: UGC 注入 owner.mid 并在切集时重套

**Files:**
- Modify: `lib/pages/video/introduction/ugc/controller.dart`
- Modify: `lib/pages/video/controller.dart`（仅当切集/开播路径需要补调用时）

**Interfaces:**
- Consumes: `PlPlayerController.applyAuthorDefaultSpeed`, `videoDetail.owner?.mid`
- Produces: UGC 详情加载成功后、分 P/合集切换时应用作者倍速

- [ ] **Step 1: 在 `queryVideoIntro` 成功写入 `videoDetail` 后应用倍速**

在 `videoDetail.value = response;` 之后：

```dart
final authorMid = response.owner?.mid;
final player = videoDetailCtr.plPlayerController;
unawaited(player.applyAuthorDefaultSpeed(authorMid));
```

若 `videoDetailCtr.plPlayerController` 访问方式不同，使用该文件现有获取播放器实例的写法（例如通过 `videoDetailCtr` 已有字段），**不要新建全局单例绕路**。

- [ ] **Step 2: 切集时重套**

找到 UGC `onChangeEpisode` / 换 cid 成功后会再次 `playerInit` 的路径。在换集完成后、或 `playerInit` 前后调用：

```dart
unawaited(
  plPlayerController.applyAuthorDefaultSpeed(
    // 同稿件作者不变
    Get.find<UgcIntroController>(tag: heroTag).videoDetail.value.owner?.mid,
  ),
);
```

若 `playerInit` 统一出口更干净，可在 `VideoDetailController.playerInit` 末尾：

```dart
if (isUgc) {
  try {
    final mid = Get.find<UgcIntroController>(tag: heroTag)
        .videoDetail
        .value
        .owner
        ?.mid;
    await plPlayerController.applyAuthorDefaultSpeed(mid);
  } catch (_) {
    // intro 尚未就绪时忽略；queryVideoIntro 成功后会再套一次
  }
} else {
  plPlayerController.resetAuthorDefaultSpeedToGlobal(force: false);
  // rate 由当前 playSpeedDefault / _initializePlayer 处理
}
```

**以减少重复、避免竞态为准**：允许 intro 与 playerInit 各调用一次 `applyAuthorDefaultSpeed`（幂等：相同 mid/speed 时 `setPlaybackSpeed` 早退）。

- [ ] **Step 3: 手测播放路径**

验收（对应 spec）：
1. 设置作者 A=1.5x、默认 1.0x → 打开 A 的 UGC → 开播 1.5x
2. 打开未配置作者 B → 1.0x
3. A 的视频内手动改 2.0x → 仅本次；退出再进仍 1.5x
4. A 的多 P 切换 → 回到 1.5x（重套 effective）
5. 打开番剧 → 仍为全局默认，不受作者名单影响
6. 删除 A 后再打开 A → 全局默认

- [ ] **Step 4: Commit**

```bash
git add lib/pages/video/introduction/ugc/controller.dart \
  lib/pages/video/controller.dart \
  lib/plugin/pl_player/controller.dart
git commit -m "$(cat <<'EOF'
feat(play-speed): UGC 按作者应用专属开播倍速

在 intro 与切集路径注入 owner.mid，手动改速仍仅会话有效。
EOF
)"
```

---

### Task 7: 回归与收尾

**Files:**
- 无必须代码改动；若手测发现文案/空态问题可小修 `play_speed_set.dart`

- [ ] **Step 1: 跑单测**

Run: `flutter test test/models/common/video/author_play_speed_test.dart`

Expected: All tests passed

- [ ] **Step 2: 分析改动面**

Run:

```bash
dart analyze \
  lib/models/common/video/author_play_speed.dart \
  lib/utils/storage_key.dart \
  lib/utils/storage_pref.dart \
  lib/pages/setting/pages/play_speed_set.dart \
  lib/plugin/pl_player/controller.dart \
  lib/pages/video/introduction/ugc/controller.dart \
  lib/pages/video/controller.dart
```

Expected: No issues

- [ ] **Step 3: 对照 spec 验收清单**

- [ ] 设置页搜索添加
- [ ] 设置页 UID 添加（解析失败显示 `UID:<mid>`）
- [ ] 修改 / 删除规则
- [ ] 专属 / 默认 / 手动改速 / 非 UGC 行为符合 spec
- [ ] 长按倍速未回归
- [ ] 倍速列表增删仍正常

- [ ] **Step 4: 如有小修则提交**

```bash
git add -A
git commit -m "$(cat <<'EOF'
fix(play-speed): 作者专属倍速手测问题修复
EOF
)"
```

无改动则跳过。

---

## Spec Coverage Check

| Spec 要求 | Task |
| --- | --- |
| 每作者独立倍速模型 | Task 1–2 |
| Hive 持久化 / Pref API | Task 2 |
| 扩展倍速设置页列表 | Task 3 |
| UID 添加 + 解析昵称 | Task 3 |
| 昵称搜索添加 | Task 4 |
| 从 speedList 选倍速 | Task 3 |
| UGC 按 mid 开播 | Task 5–6 |
| 手动改速仅会话 | Task 5（不写 Pref） |
| 切集重套 effective | Task 6 |
| 非 UGC 不生效 | Task 5–6 |
| 验收清单 | Task 7 |

## Placeholder / Consistency Notes

- 所有公开方法名以本计划 **Interfaces** 为准：`applyAuthorDefaultSpeed`、`playSpeedForAuthor`、`AuthorPlaySpeed`
- `SearchHttp.searchByType` / `FilteringText*` 以实现时源码签名为准
- 不在本计划实现播放页快捷添加、PGC/音频/直播、云同步
