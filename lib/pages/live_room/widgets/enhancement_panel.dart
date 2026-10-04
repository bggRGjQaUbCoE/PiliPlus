import 'package:PiliPlus/models_new/live/live_danmaku/danmaku_msg.dart';
import 'package:PiliPlus/pages/live_room/controller.dart';
import 'package:PiliPlus/pages/live_room/contribution_rank/view.dart';
import 'package:PiliPlus/pages/live_room/superchat/superchat_panel.dart';
import 'package:PiliPlus/pages/live_room/widgets/chat_panel.dart';
import 'package:PiliPlus/pages/live_room/widgets/interaction_focus_boundary.dart';
import 'package:PiliPlus/pages/live_room/widgets/interaction_panel.dart';
import 'package:PiliPlus/services/live_interaction_service.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

/// Owns UI tabs only. The room's player and message subscription stay outside.
class LiveEnhancementPanel extends StatefulWidget {
  const LiveEnhancementPanel({
    super.key,
    required this.controller,
    required this.inputBuilder,
    required this.onMention,
  });

  final LiveRoomController controller;
  final Widget Function() inputBuilder;
  final ValueChanged<DanmakuMsg> onMention;

  @override
  State<LiveEnhancementPanel> createState() => LiveEnhancementPanelState();
}

class LiveEnhancementPanelState extends State<LiveEnhancementPanel>
    with SingleTickerProviderStateMixin {
  late final _tabs = TabController(length: 4, vsync: this);
  int _index = 0;

  void showChat() => _tabs.animateTo(0);

  @override
  void initState() {
    super.initState();
    _tabs.addListener(_onTab);
  }

  void _onTab() {
    if (_index != _tabs.index) setState(() => _index = _tabs.index);
  }

  @override
  void dispose() {
    _tabs.removeListener(_onTab);
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    return LiveInteractionFocusBoundary(
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            Obx(
              () => Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 4, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '弹幕连接：${controller.messageConnectionState.value.label}',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                    IconButton(
                      tooltip: '重新连接弹幕',
                      onPressed: controller.retryLiveMessages,
                      icon: const Icon(Icons.sync, size: 18),
                    ),
                  ],
                ),
              ),
            ),
            TabBar(
              controller: _tabs,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              tabs: const [
                Tab(text: '聊天'),
                Tab(text: 'SC'),
                Tab(text: '榜单'),
                Tab(text: '房间'),
              ],
            ),
            Expanded(
              child: switch (_index) {
                0 => LiveRoomChatPanel(
                  liveRoomController: controller,
                  isPP: false,
                  onMention: widget.onMention,
                ),
                1 =>
                  controller.showSuperChat
                      ? Column(
                          children: [
                            Obx(
                              () => controller.superChatCapacityReached.value
                                  ? const Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Text('SC 记录达到本房间会话上限，请离开后重新进入。'),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            Expanded(
                              child: SuperChatPanel(controller: controller),
                            ),
                          ],
                        )
                      : const Center(child: Text('SC 接收展示已在设置中关闭')),
                2 => Obx(() {
                  final ruid = controller.ruid;
                  // roomInfoH5 makes the anchor resolution reactive.
                  final resolvedUid =
                      controller.roomInfoH5.value?.roomInfo?.uid;
                  final anchor = ruid ?? resolvedUid;
                  return anchor == null
                      ? const Center(child: Text('主播信息尚未加载'))
                      : ContributionRankPanel(
                          ruid: anchor,
                          roomId: controller.roomId,
                        );
                }),
                _ => _RoomInformation(controller: controller),
              },
            ),
            if (_index == 0) widget.inputBuilder(),
          ],
        ),
      ),
    );
  }
}

/// The compact gift entry remains at the right edge. Expanding the strip only
/// reads the room's catalogue; a gift still goes through the existing guarded
/// confirmation flow in [LiveInteractionPanel].
class LiveGiftActionBar extends StatefulWidget {
  const LiveGiftActionBar({
    super.key,
    required this.session,
    required this.onFullMenu,
    required this.onQuickGift,
  });

  final LiveInteractionSession? session;
  final VoidCallback onFullMenu;
  final void Function(LiveGift gift, int quantity) onQuickGift;

  @override
  State<LiveGiftActionBar> createState() => _LiveGiftActionBarState();
}

class _LiveGiftActionBarState extends State<LiveGiftActionBar> {
  bool _expanded = false;
  int? _selectedGiftId;
  int _selectedQuantity = 1;

  Future<void> _chooseQuantity(LiveGift gift) async {
    final maximum = gift.maxQuantity;
    if (maximum < 1) return;
    var entered = '${_selectedQuantity.clamp(1, maximum)}';
    final selected = await showDialog<int>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('选择礼物数量'),
        content: TextFormField(
          initialValue: entered,
          onChanged: (value) => entered = value,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: '数量',
            helperText: '1–$maximum',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              final count = int.tryParse(entered.trim());
              if (count != null && count >= 1 && count <= maximum) {
                Navigator.pop(dialogContext, count);
              }
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
    if (mounted && selected != null) {
      setState(() {
        _selectedGiftId = gift.id;
        _selectedQuantity = selected;
      });
    }
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    if (_expanded) widget.session?.load();
  }

  @override
  Widget build(BuildContext context) {
    final session = widget.session;
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: SizedBox(
        height: 96,
        child: Row(
          children: [
            if (_expanded)
              Expanded(
                child: Row(
                  children: [
                    IconButton(
                      tooltip: '展开完整礼物菜单',
                      onPressed: widget.onFullMenu,
                      icon: const Icon(Icons.keyboard_arrow_up),
                    ),
                    Expanded(
                      child: session == null
                          ? const Center(child: Text('主播信息加载中'))
                          : AnimatedBuilder(
                              animation: session,
                              builder: (context, _) {
                                final gifts =
                                    session.snapshot?.gifts ??
                                    const <LiveGift>[];
                                if (gifts.isEmpty) {
                                  return Center(
                                    child: Text(
                                      session.loading
                                          ? '礼物加载中'
                                          : '暂无可用礼物，请打开完整菜单',
                                    ),
                                  );
                                }
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: gifts.length,
                                  itemBuilder: (context, index) {
                                    final gift = gifts[index];
                                    final selectedId =
                                        gifts.any(
                                          (item) => item.id == _selectedGiftId,
                                        )
                                        ? _selectedGiftId
                                        : gifts.first.id;
                                    final selected = gift.id == selectedId;
                                    final selectedQuantity =
                                        _selectedGiftId == gift.id &&
                                            gift.maxQuantity > 0
                                        ? _selectedQuantity.clamp(
                                            1,
                                            gift.maxQuantity,
                                          )
                                        : 1;
                                    return InkWell(
                                      onTap: () => setState(() {
                                        _selectedGiftId = gift.id;
                                        _selectedQuantity = 1;
                                      }),
                                      child: Container(
                                        width: 90,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: selected
                                              ? Theme.of(context)
                                                    .colorScheme
                                                    .primaryContainer
                                              : null,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            gift.imageUrl.isEmpty
                                                ? const Icon(
                                                    Icons.card_giftcard,
                                                    size: 26,
                                                  )
                                                : Image.network(
                                                    gift.imageUrl,
                                                    width: 26,
                                                    height: 26,
                                                    errorBuilder: (_, _, _) =>
                                                        const Icon(
                                                          Icons.card_giftcard,
                                                          size: 26,
                                                        ),
                                                  ),
                                            Text(
                                              gift.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              gift.priceKnown
                                                  ? '${gift.displayPrice} ${gift.coinLabel}'
                                                  : '价格未知',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall,
                                            ),
                                            if (selected)
                                              SizedBox(
                                                height: 28,
                                                child: Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () =>
                                                          _chooseQuantity(gift),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 3,
                                                            ),
                                                        child: Text(
                                                          '×$selectedQuantity',
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: TextButton(
                                                        style: TextButton.styleFrom(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          minimumSize:
                                                              Size.zero,
                                                          tapTargetSize:
                                                              MaterialTapTargetSize
                                                                  .shrinkWrap,
                                                        ),
                                                        onPressed:
                                                            gift.sendable &&
                                                                !session.blocked
                                                            ? () => widget
                                                                  .onQuickGift(
                                                                    gift,
                                                                    selectedQuantity,
                                                                  )
                                                            : null,
                                                        child: const Text('投喂'),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              )
            else
              const Spacer(),
            IconButton(
              tooltip: _expanded ? '收起礼物快捷条' : '向左展开礼物快捷条',
              onPressed: _toggle,
              icon: Icon(_expanded ? Icons.chevron_right : Icons.chevron_left),
            ),
            SizedBox(
              width: 56,
              child: Tooltip(
                message: '礼物',
                child: InkWell(
                  onTap: _expanded ? widget.onFullMenu : _toggle,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.card_giftcard, size: 22),
                      Text('礼物', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Narrow/fullscreen UI deliberately omits a second chat/SC instance. Those
/// lists own room scroll controllers and remain in the original room shell.
class LiveEnhancementDrawer extends StatelessWidget {
  const LiveEnhancementDrawer({
    super.key,
    required this.controller,
    required this.interactions,
    required this.onShowRank,
    required this.title,
  });
  final LiveRoomController controller;
  final Widget interactions;
  final VoidCallback onShowRank;
  final String title;

  @override
  Widget build(BuildContext context) => LiveInteractionFocusBoundary(
    child: Material(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 12),
              Expanded(child: Text(title)),
              TextButton(onPressed: onShowRank, child: const Text('榜单')),
              IconButton(
                tooltip: '关闭面板',
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          Expanded(child: interactions),
        ],
      ),
    ),
  );
}

class _RoomInformation extends StatelessWidget {
  const _RoomInformation({required this.controller});
  final LiveRoomController controller;

  @override
  Widget build(BuildContext context) => Obx(() {
    final info = controller.roomInfoH5.value;
    final anchor = info?.anchorInfo?.baseInfo?.uname;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          info?.roomInfo?.title ?? '房间信息加载中',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Text('主播：${anchor ?? "尚未加载"}'),
        const SizedBox(height: 8),
        SelectableText('房间：${controller.roomId}'),
        const SizedBox(height: 8),
        controller.watchedWidget,
        const SizedBox(height: 8),
        controller.timeWidget,
        const SizedBox(height: 16),
        const Text('此版本暂不支持房间公告和特殊活动。'),
      ],
    );
  });
}
