import 'dart:async';

import 'package:PiliPlus/common/skeleton/msg_feed_top.dart';
import 'package:PiliPlus/common/sliver_single_child_delegate.dart';
import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/dialog/export_import.dart';
import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:PiliPlus/common/widgets/view_sliver_safe_area.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/member.dart';
import 'package:PiliPlus/models/common/enum_with_label.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models/member/info.dart';
import 'package:PiliPlus/models_new/blacklist/list.dart';
import 'package:PiliPlus/pages/blacklist/controller.dart';
import 'package:PiliPlus/services/local_blacklist_cleanup_service.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

enum _BlockType implements EnumWithLabel {
  local('本地'),
  online('在线');

  @override
  final String label;

  _BlockType(this.label);
}

class BlackListPage extends StatefulWidget {
  const BlackListPage({super.key});

  @override
  State<BlackListPage> createState() => _BlackListPageState();
}

class _BlackListPageState extends State<BlackListPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _blackListController = Get.put(BlackListController());
  late EdgeInsets padding;

  /// 缓存 UID 名片请求，避免列表滚动时重复访问成员接口。
  final Map<int, Future<MemberInfoModel?>> _memberInfoRequests = {};

  /// 手动清理的运行状态与已检查数量，用于绘制百分比进度。
  bool _isCleaningBlacklist = false;
  int _cleanupChecked = 0;
  int _cleanupTotal = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _BlockType.values.length,
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    padding = MediaQuery.viewPaddingOf(context);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<MemberInfoModel?> _loadMemberInfo(int mid) =>
      _memberInfoRequests.putIfAbsent(mid, () async {
        try {
          final result = await MemberHttp.memberInfo(mid: mid);
          if (result is Success<MemberInfoModel>) return result.response;
        } catch (_) {
          // 名片接口失败时仍显示 UID 和本地记录，不影响黑名单操作。
        }
        return null;
      });

  @override
  Widget build(BuildContext context) {
    return SimpleScaffold(
      appBar: AppBar(title: const Text('黑名单管理')),
      body: Column(
        children: [
          Obx(
            () => TabBar(
              controller: _tabController,
              tabs: _BlockType.values
                  .map(
                    (type) => Tab(
                      text:
                          '${type.label} (${switch (type) {
                            _BlockType.local => _blackListController.localBlackMids.length + GlobalData().localDanmakuMidHashes.length,
                            _BlockType.online => _blackListController.onlineCount.value,
                          }})',
                    ),
                  )
                  .toList(),
            ),
          ),
          Expanded(
            child: tabBarView(
              controller: _tabController,
              children: _BlockType.values
                  .map(
                    (e) => switch (e) {
                      _BlockType.local => _local,
                      _BlockType.online => _online,
                    },
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget get _online {
    return refreshIndicator(
      onRefresh: _blackListController.onRefresh,
      child: CustomScrollView(
        key: const PageStorageKey(_BlockType.online),
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          ViewSliverSafeArea(
            sliver: Obx(
              () => _buildBody(_blackListController.loadingState.value),
            ),
          ),
        ],
      ),
    );
  }

  void _onAddMid(String mid) {
    if (mid.isEmpty) return;
    int intMid;
    try {
      intMid = int.parse(mid);
    } catch (e) {
      SmartDialog.showToast(e.toString());
      return;
    }
    if (_blackListController.localBlackMids.contains(intMid)) {
      SmartDialog.showToast('该用户已在本地黑名单中');
      return;
    }
    Pref.setBlackMid(intMid);
    SmartDialog.showToast('屏蔽成功');
    setState(() {});
  }

  void _showAddMidDialog() {
    var text = '';
    showConfirmDialog(
      context: context,
      title: const Text('屏蔽用户'),
      content: TextField(
        autofocus: true,
        textInputAction: .done,
        keyboardType: .number,
        onChanged: (value) => text = value,
        onSubmitted: (value) {
          Get.back();
          _onAddMid(value);
        },
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          labelText: 'UID',
          border: OutlineInputBorder(),
        ),
      ),
      onConfirm: () => _onAddMid(text),
    );
  }

  void _showImportExportDialog() {
    showImportExportDialog<dynamic>(
      context,
      title: '黑名单',
      localFileName: () => 'blackMids',
      onExport: _exportLocalBlacklist,
      onImport: _importLocalBlacklist,
    );
  }

  /// 导出本地 UID、弹幕作者哈希及能够确认的添加时间。
  String _exportLocalBlacklist() => Utils.jsonEncoder.convert({
    'local': _blackListController.localBlackMids.reversed.toList(),
    'localAddedAt': Pref.localBlackMidAddedAt,
    'danmakuHashes': GlobalData().localDanmakuMidHashes.reversed.toList(),
    'danmakuHashAddedAt': Pref.localDanmakuMidHashAddedAt,
  });

  /// 兼容旧 UID 列表与新版对象，并只恢复文件中明确记录的时间。
  void _importLocalBlacklist(Object? data) {
    final localMids = <int>[];
    final danmakuHashes = <String>[];
    Map<String, int> midAddedAt = {};
    Map<String, int> hashAddedAt = {};

    if (data is List) {
      localMids.addAll(data.map((value) => int.parse(value.toString())));
    } else if (data is Map) {
      final mids = data['local'] ?? data['mids'];
      if (mids is List) {
        localMids.addAll(mids.map((value) => int.parse(value.toString())));
      }
      final hashes = data['danmakuHashes'];
      if (hashes is List) {
        danmakuHashes.addAll(hashes.map((value) => value.toString()));
      }
      midAddedAt = Pref.parseBlacklistTimestamps(data['localAddedAt']);
      hashAddedAt = Pref.parseBlacklistTimestamps(
        data['danmakuHashAddedAt'],
      );
    } else {
      throw const FormatException('黑名单数据格式不正确');
    }

    final addedMids = <int>{};
    // 导出列表按新到旧排列，导入时反向追加以保留原始顺序。
    for (final mid in localMids.reversed) {
      if (GlobalData().localBlackMids.contains(mid)) continue;
      Pref.setBlackMid(mid);
      addedMids.add(mid);
    }

    final addedHashes = <String>{};
    for (final hash in danmakuHashes.reversed) {
      if (GlobalData().localDanmakuMidHashes.contains(hash)) continue;
      Pref.addLocalDanmakuMidHash(hash);
      addedHashes.add(hash);
    }

    final localTimes = Pref.localBlackMidAddedAt;
    final importedMids = localMids.toSet();
    final restoredMidTimes = <int>{};
    for (final entry in midAddedAt.entries) {
      final mid = int.tryParse(entry.key);
      if (mid == null || !importedMids.contains(mid)) continue;
      localTimes[mid.toString()] = entry.value;
      restoredMidTimes.add(mid);
    }
    for (final mid in addedMids.difference(restoredMidTimes)) {
      localTimes.remove(mid.toString());
    }
    Pref.localBlackMidAddedAt = localTimes;

    final hashTimes = Pref.localDanmakuMidHashAddedAt;
    final restoredHashTimes = <String>{};
    for (final hash in danmakuHashes.toSet()) {
      if (hashAddedAt[hash] case final timestamp?) {
        hashTimes[hash] = timestamp;
        restoredHashTimes.add(hash);
      }
    }
    for (final hash in addedHashes.difference(restoredHashTimes)) {
      hashTimes.remove(hash);
    }
    Pref.localDanmakuMidHashAddedAt = hashTimes;
    setState(() {});
  }

  /// 展示已检查 UID 数量与百分比，不阻塞页面交互。
  Widget _buildCleanupProgress() {
    final progress = _cleanupTotal == 0
        ? 1.0
        : (_cleanupChecked / _cleanupTotal).clamp(0.0, 1.0).toDouble();
    final percent = (progress * 100).floor();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          LinearProgressIndicator(value: progress),
          const SizedBox(height: 6),
          Text('已检查 $_cleanupChecked / $_cleanupTotal（$percent%）'),
        ],
      ),
    );
  }

  Widget _buildMemberAvatar(String? face) {
    return NetworkImgLayer(
      width: 45,
      height: 45,
      type: ImageType.avatar,
      src: face,
    );
  }

  Widget _buildMemberName(int mid, String? name) {
    final displayName = name?.trim();
    return Text(
      displayName?.isNotEmpty == true ? displayName! : 'UID: $mid',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontSize: 14),
    );
  }

  String _formatAddedAt(int? timestamp) {
    if (timestamp == null) return '未知（旧记录未保存时间）';
    return DateFormatUtils.format(
      timestamp,
      format: DateFormatUtils.longFormatDs,
    );
  }

  Widget _buildLocalMidSubtitle(int mid, int? addedAt) {
    final color = Theme.of(context).colorScheme.outline;

    return Column(
      crossAxisAlignment: .start,
      mainAxisSize: .min,
      children: [
        Text('UID: $mid', maxLines: 1, overflow: TextOverflow.ellipsis),
        Text(
          '添加时间：${_formatAddedAt(addedAt)}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: color),
        ),
      ],
    );
  }

  /// 加载成员资料并展示头像、昵称、UID 与本地添加时间。
  Widget _buildLocalBlacklistItem(int mid, int? addedAt) {
    return FutureBuilder<MemberInfoModel?>(
      future: _loadMemberInfo(mid),
      builder: (context, snapshot) {
        final member = snapshot.data;
        final name = member?.name?.trim();
        return ListTile(
          visualDensity: .standard,
          onTap: () => Get.toNamed('/member?mid=$mid'),
          leading: _buildMemberAvatar(member?.face),
          title: _buildMemberName(mid, name),
          subtitle: _buildLocalMidSubtitle(mid, addedAt),
          isThreeLine: true,
          dense: true,
          trailing: TextButton(
            onPressed: () => showConfirmDialog(
              context: context,
              title: const Text('确定移除该用户？'),
              onConfirm: () => Pref.removeBlackMid(mid),
            ),
            child: const Text('移除'),
          ),
        );
      },
    );
  }

  Widget get _local {
    return ScaffoldLayout(
      fab: Padding(
        padding: .only(
          right: kFloatingActionButtonMargin + padding.right,
          bottom: kFloatingActionButtonMargin + padding.bottom,
        ),
        child: Column(
          spacing: kFloatingActionButtonMargin,
          mainAxisSize: .min,
          children: [
            FloatingActionButton(
              tooltip: '导入/导出',
              onPressed: _showImportExportDialog,
              child: const Icon(Icons.swap_vert, size: 26),
            ),
            FloatingActionButton(
              tooltip: '添加',
              onPressed: _showAddMidDialog,
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        key: const PageStorageKey(_BlockType.local),
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          ViewSliverSafeArea(
            bottom: 180,
            sliver: SliverPadding(
              padding: const .fromLTRB(12, 12, 12, 0),
              sliver: Obx(() {
                final localDanmakuHashes = GlobalData().localDanmakuMidHashes;
                final localAddedAt = Pref.localBlackMidAddedAt;
                final hashAddedAt = Pref.localDanmakuMidHashAddedAt;
                return SliverMainAxisGroup(
                  slivers: [
                    SliverToBoxAdapter(
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        leading: const Icon(Icons.person_search_outlined),
                        title: const Text('手动检查并清理已注销用户'),
                        subtitle: const Text(
                          '仅检查 B 站返回 -404 的账号；启动时不会自动执行',
                        ),
                        onTap: _isCleaningBlacklist
                            ? null
                            : () => unawaited(_cleanDeletedBlacklist()),
                      ),
                    ),
                    SliverList.builder(
                      itemCount:
                          _blackListController.localBlackMids.length +
                          (_isCleaningBlacklist ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (_isCleaningBlacklist && index == 0) {
                          return _buildCleanupProgress();
                        }
                        final itemIndex =
                            index - (_isCleaningBlacklist ? 1 : 0);
                        final mids = _blackListController.localBlackMids;
                        // 按插入顺序保存的数据倒序展示，让最新屏蔽项排在最前。
                        final mid = mids[mids.length - itemIndex - 1];
                        return _buildLocalBlacklistItem(
                          mid,
                          localAddedAt[mid.toString()],
                        );
                      },
                    ),
                    if (localDanmakuHashes.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(4, 16, 4, 6),
                          child: Text(
                            '自动屏蔽的弹幕作者 (${localDanmakuHashes.length})',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.outline,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      SliverList.builder(
                        itemCount: localDanmakuHashes.length,
                        itemBuilder: (context, index) {
                          final hash =
                              localDanmakuHashes[localDanmakuHashes.length -
                                  index -
                                  1];
                          return ListTile(
                            dense: true,
                            leading: const CircleAvatar(
                              radius: 22,
                              child: Icon(Icons.subtitles_off_outlined),
                            ),
                            title: Text(
                              '弹幕作者标识：$hash',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14),
                            ),
                            isThreeLine: true,
                            subtitle: Column(
                              crossAxisAlignment: .start,
                              mainAxisSize: .min,
                              children: [
                                Text(
                                  '添加时间：${_formatAddedAt(hashAddedAt[hash])}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outline,
                                  ),
                                ),
                                Text(
                                  'B站弹幕未提供 UID，仅在本机屏蔽该作者的弹幕',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outline,
                                  ),
                                ),
                              ],
                            ),
                            trailing: TextButton(
                              onPressed: () => showConfirmDialog(
                                context: context,
                                title: const Text('确定移除该弹幕屏蔽？'),
                                onConfirm: () =>
                                    Pref.removeLocalDanmakuMidHash(hash),
                              ),
                              child: const Text('移除'),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  /// 手动顺序检查本地 UID，并显示服务端查询进度。
  Future<void> _cleanDeletedBlacklist() async {
    if (_isCleaningBlacklist) return;

    setState(() {
      _isCleaningBlacklist = true;
      _cleanupChecked = 0;
      _cleanupTotal = _blackListController.localBlackMids.length;
    });

    try {
      final removedCount =
          await LocalBlacklistCleanupService.cleanDeletedLocalMids(
            onProgress: (checked, total) {
              if (!mounted) return;

              final oldPercent = _cleanupTotal == 0
                  ? 100
                  : _cleanupChecked * 100 ~/ _cleanupTotal;
              final newPercent = total == 0 ? 100 : checked * 100 ~/ total;
              if (oldPercent == newPercent && checked != total) return;

              setState(() {
                _cleanupChecked = checked;
                _cleanupTotal = total;
              });
            },
          );

      if (!mounted) return;
      switch (removedCount) {
        case null:
          SmartDialog.showToast('正在检查，请稍后再试');
        case 0:
          SmartDialog.showToast('未发现 B 站判定为不存在的账号');
        case final count:
          SmartDialog.showToast('已清理 $count 个不存在的账号');
      }
    } catch (error) {
      if (mounted) SmartDialog.showToast('检查异常，部分清理可能已完成：$error');
    } finally {
      if (mounted) setState(() => _isCleaningBlacklist = false);
    }
  }

  Widget _buildBody(LoadingState<List<BlackListItem>?> loadingState) {
    late final style = TextStyle(color: Theme.of(context).colorScheme.outline);
    return switch (loadingState) {
      Loading() => const SliverPrototypeExtentList(
        prototypeItem: MsgFeedTopSkeleton(),
        delegate: SliverSingleChildDelegate(
          count: 12,
          child: MsgFeedTopSkeleton(),
        ),
      ),
      Success(:final response) =>
        response != null && response.isNotEmpty
            ? SliverList.builder(
                itemCount: response.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index == response.length - 1) {
                    _blackListController.onLoadMore();
                  }
                  final item = response[index];
                  return ListTile(
                    visualDensity: .standard,
                    onTap: () => Get.toNamed('/member?mid=${item.mid}'),
                    leading: NetworkImgLayer(
                      width: 45,
                      height: 45,
                      type: ImageType.avatar,
                      src: item.face,
                    ),
                    title: Text(
                      item.uname!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                    subtitle: Text(
                      '添加时间: ${DateFormatUtils.format(item.mtime, format: DateFormatUtils.longFormatDs)}',
                      maxLines: 1,
                      style: style,
                      overflow: TextOverflow.ellipsis,
                    ),
                    dense: true,
                    trailing: TextButton(
                      onPressed: () async {
                        final removed = await _blackListController.onRemove(
                          context,
                          index,
                          item.uname,
                          item.mid,
                        );
                        if (mounted && removed) {
                          if (_blackListController.onlineBlackMids.remove(
                            item.mid,
                          )) {
                            if (!_blackListController.localBlackMids.contains(
                              item.mid,
                            )) {
                              GlobalData().blackMids.remove(item.mid);
                            }
                            setState(() {});
                          }
                        }
                      },
                      child: const Text('移除'),
                    ),
                  );
                },
              )
            : HttpError(onReload: _blackListController.onReload),
      Error(:final errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _blackListController.onReload,
      ),
    };
  }
}
