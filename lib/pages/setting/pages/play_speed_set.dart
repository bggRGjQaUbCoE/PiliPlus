import 'dart:math';

import 'package:PiliPlus/common/widgets/flutter/list_tile.dart';
import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/common/widgets/view_safe_area.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/member.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/models/common/search/search_type.dart';
import 'package:PiliPlus/models/common/video/author_play_speed.dart';
import 'package:PiliPlus/models/search/result.dart';
import 'package:PiliPlus/pages/setting/widgets/switch_item.dart';
import 'package:PiliPlus/utils/extension/context_ext.dart';
import 'package:PiliPlus/utils/filtering_text.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive_ce/hive.dart';
import 'package:material_ui/material_ui.dart' hide ListTile;

class PlaySpeedPage extends StatefulWidget {
  const PlaySpeedPage({super.key});

  @override
  State<PlaySpeedPage> createState() => _PlaySpeedPageState();
}

class _PlaySpeedPageState extends State<PlaySpeedPage> {
  late double playSpeedDefault = Pref.playSpeedDefault;
  late double longPressSpeedDefault = Pref.longPressSpeedDefault;
  late List<double> speedList = Pref.speedList;
  late bool enableAutoLongPressSpeed = Pref.enableAutoLongPressSpeed;
  late Map<int, AuthorPlaySpeed> authorPlaySpeeds = Pref.authorPlaySpeeds;
  List<({int id, String title, Icon icon})> sheetMenu = [
    (
      id: 1,
      title: '设置为默认倍速',
      icon: const Icon(
        Icons.speed,
        size: 21,
      ),
    ),
    (
      id: 2,
      title: '设置为默认长按倍速',
      icon: const Icon(
        Icons.speed_sharp,
        size: 21,
      ),
    ),
    (
      id: -1,
      title: '删除该项',
      icon: const Icon(
        Icons.delete_outline,
        size: 21,
      ),
    ),
  ];

  Box video = GStorage.video;

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

  Future<void> _saveAuthorSpeed({
    required int mid,
    required String name,
  }) async {
    var resolvedName = name;
    final existing = authorPlaySpeeds[mid];
    if (existing != null) {
      SmartDialog.showToast('该作者已存在，将更新倍速');
      if (existing.name.isNotEmpty) {
        resolvedName = existing.name;
      }
    }

    await _pickSpeed(
      title: '选择 $resolvedName 的倍速',
      initial: existing?.speed ?? playSpeedDefault,
      onPicked: (speed) {
        final next = Map<int, AuthorPlaySpeed>.from(authorPlaySpeeds);
        next[mid] = AuthorPlaySpeed(
          mid: mid,
          name: resolvedName,
          speed: speed,
        );
        _persistAuthorSpeeds(next);
        SmartDialog.showToast('已保存');
      },
    );
  }

  Future<void> onAddAuthorSpeed() async {
    final keywordCtrl = TextEditingController();
    final uidCtrl = TextEditingController();
    try {
      final result = await showDialog<({int mid, String name})>(
        context: context,
        builder: (context) {
          var searching = false;
          var uidSubmitting = false;
          var results = <SearchUserItemModel>[];
          return StatefulBuilder(
            builder: (context, setLocal) {
              Future<void> doSearch() async {
                final keyword = keywordCtrl.text.trim();
                if (keyword.isEmpty) {
                  SmartDialog.showToast('请输入搜索关键词');
                  return;
                }
                if (searching) return;
                setLocal(() {
                  searching = true;
                  results = <SearchUserItemModel>[];
                });
                try {
                  final res = await SearchHttp.searchByType<SearchUserData>(
                    searchType: SearchType.bili_user,
                    keyword: keyword,
                    page: 1,
                    onSuccess: (_) {},
                  );
                  if (!context.mounted) return;
                  if (res case Success(:final response)) {
                    setLocal(() {
                      results = response.list ?? <SearchUserItemModel>[];
                      searching = false;
                    });
                    if (results.isEmpty) {
                      SmartDialog.showToast('未找到相关用户，可改用 UID 添加');
                    }
                  } else {
                    setLocal(() => searching = false);
                    SmartDialog.showToast('搜索失败，可改用 UID 添加');
                  }
                } catch (_) {
                  if (!context.mounted) return;
                  setLocal(() => searching = false);
                  SmartDialog.showToast('搜索失败，可改用 UID 添加');
                }
              }

              Future<void> onNextByUid() async {
                if (uidSubmitting) return;
                final mid = int.tryParse(uidCtrl.text.trim());
                if (mid == null || mid <= 0) {
                  SmartDialog.showToast('请输入有效 UID');
                  return;
                }
                setLocal(() => uidSubmitting = true);
                var name = 'UID:$mid';
                try {
                  final res = await MemberHttp.memberCardInfo(mid: mid);
                  if (res case Success(:final response)) {
                    final n = response.card?.name?.trim();
                    if (n != null && n.isNotEmpty) name = n;
                  }
                } catch (_) {}
                if (!context.mounted) return;
                Get.back(result: (mid: mid, name: name));
              }

              return AlertDialog(
                title: const Text('添加作者专属倍速'),
                content: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: keywordCtrl,
                        textInputAction: TextInputAction.search,
                        decoration: const InputDecoration(
                          labelText: '搜索昵称',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                        ),
                        onSubmitted: (_) => doSearch(),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: searching ? null : doSearch,
                          child: const Text('搜索'),
                        ),
                      ),
                      if (searching) const LinearProgressIndicator(),
                      if (results.isNotEmpty)
                        SizedBox(
                          height: 180,
                          child: ListView.builder(
                            itemCount: results.length,
                            itemBuilder: (_, i) {
                              final u = results[i];
                              final mid = u.mid;
                              final uname = u.uname?.trim();
                              final title = (uname != null && uname.isNotEmpty)
                                  ? uname
                                  : 'UID:${mid ?? ''}';
                              return ListTile(
                                title: Text(title),
                                subtitle: Text('UID: ${mid ?? '-'}'),
                                onTap: mid == null || mid <= 0
                                    ? null
                                    : () {
                                        Get.back(
                                          result: (mid: mid, name: title),
                                        );
                                      },
                              );
                            },
                          ),
                        ),
                      const Divider(),
                      TextField(
                        controller: uidCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                          labelText: '用户 UID',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(onPressed: Get.back, child: const Text('取消')),
                  TextButton(
                    onPressed: uidSubmitting ? null : onNextByUid,
                    child: const Text('下一步'),
                  ),
                ],
              );
            },
          );
        },
      );
      if (result == null) return;
      await _saveAuthorSpeed(mid: result.mid, name: result.name);
    } finally {
      keywordCtrl.dispose();
      uidCtrl.dispose();
    }
  }

  // 添加自定义倍速
  void onAddSpeed() {
    String initialValue = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('添加倍速'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            TextFormField(
              autofocus: true,
              initialValue: initialValue,
              keyboardType: const .numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: '自定义倍速',
                border: OutlineInputBorder(borderRadius: .all(.circular(6))),
              ),
              onChanged: (value) => initialValue = value,
              inputFormatters: FilteringText.decimal,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text(
              '取消',
              style: TextStyle(color: Theme.of(context).colorScheme.outline),
            ),
          ),
          TextButton(
            onPressed: () {
              try {
                final val = double.parse(initialValue);
                if (speedList.contains(val)) {
                  SmartDialog.showToast('该倍速已存在');
                } else {
                  Get.back();
                  speedList
                    ..add(val)
                    ..sort();
                  video.put(VideoBoxKey.speedsList, speedList);
                  setState(() {});
                }
              } catch (e) {
                SmartDialog.showToast(e.toString());
              }
            },
            child: const Text('确认'),
          ),
        ],
      ),
    );
  }

  // 设定倍速弹窗
  void showBottomSheet(ThemeData theme, int index) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      clipBehavior: Clip.hardEdge,
      constraints: BoxConstraints(
        maxWidth: min(640, context.mediaQueryShortestSide),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            ...sheetMenu.map(
              (item) => ListTile(
                enabled: enableAutoLongPressSpeed && item.id == 2
                    ? false
                    : true,
                onTap: () {
                  Get.back();
                  menuAction(index, item.id);
                },
                minLeadingWidth: 0,
                iconColor: theme.colorScheme.onSurface,
                leading: item.icon,
                title: Text(
                  item.title,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
            SizedBox(height: 25 + MediaQuery.viewPaddingOf(context).bottom),
          ],
        );
      },
    );
  }

  //
  void menuAction(int index, int id) {
    double speed = speedList[index];
    // 设置
    if (id == 1) {
      // 设置默认倍速
      playSpeedDefault = speed;
      video.put(VideoBoxKey.playSpeedDefault, playSpeedDefault);
    } else if (id == 2) {
      // 设置默认长按倍速
      longPressSpeedDefault = speed;
      video.put(VideoBoxKey.longPressSpeedDefault, longPressSpeedDefault);
    } else if (id == -1) {
      if ([
        1.0,
        playSpeedDefault,
        longPressSpeedDefault,
      ].contains(speed)) {
        SmartDialog.showToast('不支持删除默认倍速');
        return;
      }
      speedList.removeAt(index);
      video.put(VideoBoxKey.speedsList, speedList);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SimpleScaffold(
      appBar: AppBar(
        title: const Text('倍速设置'),
        actions: [
          TextButton(
            onPressed: () async {
              await video.delete(VideoBoxKey.speedsList);
              speedList = Pref.speedList;
              setState(() {});
            },
            child: const Text('重置'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: ViewSafeArea(
        child: ListView(
          padding: .only(
            bottom: MediaQuery.viewPaddingOf(context).bottom + 100,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 14,
                right: 14,
                top: 6,
                bottom: 0,
              ),
              child: Text(
                '点击下方按钮设置默认（长按）倍速',
                style: TextStyle(color: theme.colorScheme.outline),
              ),
            ),
            ListTile(
              title: const Text('默认倍速'),
              subtitle: Text(playSpeedDefault.toString()),
            ),
            SetSwitchItem(
              title: '动态长按倍速',
              subtitle: '根据默认倍速长按时自动双倍',
              setKey: SettingBoxKey.enableAutoLongPressSpeed,
              defaultVal: enableAutoLongPressSpeed,
              onChanged: (val) =>
                  setState(() => enableAutoLongPressSpeed = val),
            ),
            if (!enableAutoLongPressSpeed)
              ListTile(
                title: const Text('默认长按倍速'),
                subtitle: Text(longPressSpeedDefault.toString()),
              ),
            Padding(
              padding: const EdgeInsets.only(
                left: 14,
                right: 14,
                bottom: 10,
                top: 20,
              ),
              child: Row(
                children: [
                  Text(
                    '倍速列表',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: onAddSpeed,
                    child: const Text('添加'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 18,
                right: 18,
                bottom: 30,
              ),
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: 8,
                runSpacing: 2,
                children: List.generate(
                  speedList.length,
                  (index) => FilledButton.tonal(
                    style: FilledButton.styleFrom(tapTargetSize: .padded),
                    onPressed: () => showBottomSheet(theme, index),
                    child: Text(speedList[index].toString()),
                  ),
                ),
              ),
            ),
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
          ],
        ),
      ),
    );
  }
}
