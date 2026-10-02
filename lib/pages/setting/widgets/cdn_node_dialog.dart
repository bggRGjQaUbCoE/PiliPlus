import 'package:PiliPlus/common/widgets/flutter/popup_menu.dart';
import 'package:PiliPlus/common/widgets/loading_widget/m3e_loading_indicator.dart';
import 'package:PiliPlus/models/video/play/url.dart';
import 'package:PiliPlus/pages/setting/widgets/cdn_select_dialog.dart';
import 'package:PiliPlus/utils/cdn_node_store.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/video_utils.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

/// 二级对话框：按地区浏览 CDN 节点，返回选中的 host
class CdnNodeDialog extends StatefulWidget {
  const CdnNodeDialog({
    super.key,
    this.sample,
    this.isLive = false,
  });

  final BaseItem? sample;
  final bool isLive;

  @override
  State<CdnNodeDialog> createState() => _CdnNodeDialogState();
}

class _CdnNodeDialogState extends State<CdnNodeDialog> {
  late final Future<Map<String, List<String>>> _future = CdnNodeStore.load();
  String? _region;
  CdnSpeedTester? _tester;
  final Map<String, ValueNotifier<String?>> _speedResults = {};
  bool _refreshing = false;

  String? get _currentHost {
    if (widget.isLive) {
      final url = VideoUtils.liveCdnUrl;
      final host = url == null ? null : Uri.tryParse(url)?.host;
      return host == null || host.isEmpty ? null : host;
    }
    return VideoUtils.customCDNUrl;
  }

  @override
  void dispose() {
    _tester?.dispose();
    for (final notifier in _speedResults.values) {
      notifier.dispose();
    }
    super.dispose();
  }

  String _initRegion(Map<String, List<String>> nodes) {
    if (_currentHost case final host?) {
      if (CdnNodeStore.regionOf(host) case final region?) {
        return region;
      }
    }
    final saved = GStorage.localCache.get(LocalCacheKey.cdnNodeRegion);
    if (saved is String && nodes.containsKey(saved)) {
      return saved;
    }
    return CdnNodeStore.sortedRegions(nodes).first;
  }

  void _selectRegion(String region) {
    setState(() => _region = region);
    GStorage.localCache.put(LocalCacheKey.cdnNodeRegion, region);
  }

  Future<void> _testNode(String host) async {
    final notifier = _speedResults[host]!;
    if (notifier.value == '') {
      return;
    }
    notifier.value = '';
    String result;
    try {
      final tester = _tester ??= CdnSpeedTester(sample: widget.sample);
      final sample = await tester.getSample();
      final url = VideoUtils.getCdnUrl(sample.playUrls, customHost: host);
      result = await tester.measure(url);
    } catch (e) {
      result = '测速失败';
    }
    if (mounted) {
      notifier.value = result;
    }
  }

  Future<void> _refresh() async {
    setState(() => _refreshing = true);
    final error = await CdnNodeStore.refresh();
    if (!mounted) {
      return;
    }
    setState(() => _refreshing = false);
    SmartDialog.showToast(error ?? '节点列表已更新');
  }

  String _formatTime(DateTime time) {
    String pad(int value) => value.toString().padLeft(2, '0');
    return '${time.year}-${pad(time.month)}-${pad(time.day)} '
        '${pad(time.hour)}:${pad(time.minute)}';
  }

  Widget _buildTrailing(String host) {
    final notifier = _speedResults.putIfAbsent(
      host,
      () => ValueNotifier<String?>(null),
    );
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (context, value, _) {
        if (value == null) {
          return IconButton(
            tooltip: '测速',
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.speed),
            onPressed: () => _testNode(host),
          );
        }
        if (value.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(8),
            child: M3ELoadingIndicator(size: Size.square(20)),
          );
        }
        return GestureDetector(
          onTap: () => _testNode(host),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 96),
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 11),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHint(BuildContext context, String text) {
    final colorScheme = ColorScheme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 14,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    final textTheme = TextTheme.of(context);
    return AlertDialog(
      clipBehavior: Clip.hardEdge,
      title: Text(widget.isLive ? '选择直播节点' : '选择节点'),
      constraints: const BoxConstraints.tightFor(width: 320),
      contentPadding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      content: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox(
              height: 120,
              child: Center(child: M3ELoadingIndicator()),
            );
          }
          final nodes = CdnNodeStore.nodesOrNull ?? snapshot.data;
          if (nodes == null) {
            return const SizedBox(
              height: 80,
              child: Center(child: Text('节点列表加载失败')),
            );
          }
          final regions = CdnNodeStore.sortedRegions(nodes);
          var region = _region ??= _initRegion(nodes);
          if (!nodes.containsKey(region)) {
            region = _region = regions.first;
          }
          final hosts = nodes[region]!;
          final currentHost = _currentHost;
          final updateTime = CdnNodeStore.updateTime;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    StaticPopupMenuButton<String>(
                      initialValue: region,
                      onSelected: _selectRegion,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      padding: const EdgeInsets.fromLTRB(8, 6, 4, 6),
                      itemBuilder: (context) => [
                        for (final item in regions)
                          PopupMenuItem(
                            value: item,
                            child: Text(item),
                          ),
                      ],
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(region, style: textTheme.labelLarge),
                          const Icon(Icons.arrow_drop_down, size: 20),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${hosts.length} 个节点',
                      style: textTheme.bodySmall!.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              if (widget.isLive)
                _buildHint(context, '列表节点对直播的有效性未经验证，无法观看请清除设置')
              else if (region == '外建')
                _buildHint(context, '该分组多为直播节点，点播大概率无效'),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: hosts.length,
                  itemBuilder: (context, index) {
                    final host = hosts[index];
                    return M3eOptionItem(
                      selected: host == currentHost,
                      selectionControl: true,
                      title: Text(CdnNodeStore.nodeTitleOf(host)),
                      subtitle: Text(
                        host,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: widget.isLive ? null : _buildTrailing(host),
                      onTap: () => Navigator.pop(context, host),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        updateTime == null
                            ? '内置快照，可在线更新'
                            : '更新于 ${_formatTime(updateTime)}',
                        style: textTheme.bodySmall!.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    if (_refreshing)
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: M3ELoadingIndicator(size: Size.square(18)),
                      )
                    else
                      TextButton(
                        onPressed: _refresh,
                        child: const Text('更新列表'),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
