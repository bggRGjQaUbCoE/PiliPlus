import 'package:PiliPlus/services/live_interaction_service.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:material_ui/material_ui.dart';

/// Kept by the room page, so hiding UI never turns an uncertain write into a
/// new request. The service additionally journals pending writes across exits.
class LiveInteractionSession extends ChangeNotifier {
  LiveInteractionSession({required this.service, required this.isEnabled});

  final LiveInteractionService service;
  final ValueGetter<bool> isEnabled;
  LiveInteractionSnapshot? snapshot;
  LiveActionResult? result;
  String? error;
  bool loading = false;
  bool preparing = false;
  bool _disposed = false;
  int _readGeneration = 0;
  Object? _snapshotAccountIdentity;
  final _confirmationGenerations = Map<LiveGiftConfirmation, int>.identity();

  bool get blocked =>
      preparing ||
      result?.state == LiveActionState.submitting ||
      result?.state == LiveActionState.unknown;

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  void _clearChangedAccount(Object identity) {
    if (!_disposed && !identical(identity, service.accountIdentity)) {
      snapshot = null;
      result = null;
      error = null;
      _snapshotAccountIdentity = null;
    }
  }

  void hide({bool notify = true}) {
    ++_readGeneration;
    _confirmationGenerations.clear();
    service.invalidateApprovals();
    loading = false;
    // Submitted writes continue to settle; no cancellation/retry is claimed.
    if (notify) _notify();
  }

  Future<void> load() async {
    if (_disposed || !isEnabled() || loading) return;
    final identity = service.accountIdentity;
    if (_snapshotAccountIdentity case final previous?) {
      _clearChangedAccount(previous);
    }
    final generation = ++_readGeneration;
    loading = true;
    error = null;
    _notify();
    try {
      final next = await service.loadPanel();
      if (_disposed || generation != _readGeneration || !isEnabled()) return;
      if (!identical(identity, service.accountIdentity)) {
        _clearChangedAccount(identity);
        return;
      }
      snapshot = next;
      _snapshotAccountIdentity = identity;
      // lastAction is scoped by the service to the freshly loaded account.
      result = service.lastAction;
    } catch (e) {
      if (!_disposed && generation == _readGeneration) error = _errorText(e);
    } finally {
      if (!_disposed && generation == _readGeneration) {
        loading = false;
        _notify();
      }
    }
  }

  Future<LiveGiftConfirmation?> prepare(
    Future<LiveGiftConfirmation> Function() action,
  ) async {
    if (_disposed || !isEnabled() || blocked) return null;
    preparing = true;
    final identity = service.accountIdentity;
    final generation = _readGeneration;
    error = null;
    _notify();
    try {
      final confirmation = await action();
      if (!_disposed &&
          isEnabled() &&
          generation == _readGeneration &&
          identical(identity, service.accountIdentity)) {
        _confirmationGenerations[confirmation] = generation;
        return confirmation;
      }
      return null;
    } catch (e) {
      if (!_disposed && generation == _readGeneration) error = _errorText(e);
      return null;
    } finally {
      preparing = false;
      _clearChangedAccount(identity);
      _notify();
    }
  }

  Future<void> submit(LiveGiftConfirmation confirmation) async {
    final generation = _confirmationGenerations.remove(confirmation);
    if (_disposed || !isEnabled() || blocked || generation != _readGeneration) {
      return;
    }
    preparing = true; // Locks the button before the first asynchronous step.
    final identity = service.accountIdentity;
    error = null;
    _notify();
    try {
      final settled = await service.submitGift(confirmation);
      if (!_disposed && identical(identity, service.accountIdentity)) {
        result = settled;
      }
    } catch (e) {
      if (!_disposed && identical(identity, service.accountIdentity)) {
        error = _errorText(e);
        result = service.lastAction ?? result;
      }
    } finally {
      preparing = false;
      _clearChangedAccount(identity);
      _notify();
    }
    await load();
  }

  Future<void> reconcile() async {
    final pending = result;
    if (_disposed || preparing || pending == null || !isEnabled()) return;
    preparing = true;
    final identity = service.accountIdentity;
    _notify();
    try {
      final settled = await service.reconcile(pending);
      if (!_disposed && identical(identity, service.accountIdentity)) {
        result = settled;
      }
    } catch (e) {
      if (!_disposed && identical(identity, service.accountIdentity)) {
        error = _errorText(e);
      }
    } finally {
      preparing = false;
      _clearChangedAccount(identity);
      _notify();
    }
    await load();
  }

  Future<void> medal(Future<LiveActionResult> Function() action) async {
    if (_disposed || !isEnabled() || blocked) return;
    preparing = true;
    final identity = service.accountIdentity;
    _notify();
    try {
      final settled = await action();
      if (!_disposed && identical(identity, service.accountIdentity)) {
        result = settled;
      }
    } catch (e) {
      if (!_disposed && identical(identity, service.accountIdentity)) {
        error = _errorText(e);
      }
    } finally {
      preparing = false;
      _clearChangedAccount(identity);
      _notify();
    }
    await load();
  }

  @override
  void dispose() {
    _disposed = true;
    ++_readGeneration;
    service.dispose();
    super.dispose();
  }
}

String _errorText(Object error) => error is LiveInteractionException
    ? error.toString()
    : '请求未完成，请刷新状态。已提交操作请先只读核对，不要重复发送。';

class LiveInteractionPanel extends StatefulWidget {
  const LiveInteractionPanel({
    super.key,
    required this.session,
    required this.anchorName,
    required this.onLogin,
    required this.onRecharge,
    required this.onOpenGuard,
    this.initialTab = 0,
    this.quickGift,
    this.quickQuantity = 1,
  });

  final LiveInteractionSession session;
  final String anchorName;
  final VoidCallback onLogin;
  final Future<void> Function() onRecharge;
  final Future<void> Function() onOpenGuard;
  final int initialTab;
  final LiveGift? quickGift;
  final int quickQuantity;

  @override
  State<LiveInteractionPanel> createState() => _LiveInteractionPanelState();
}

class _LiveInteractionPanelState extends State<LiveInteractionPanel> {
  late int _tab = widget.initialTab.clamp(0, 3).toInt();
  final _quantity = TextEditingController(text: '1');
  ModalRoute<dynamic>? _confirmationRoute;

  @override
  void initState() {
    super.initState();
    _quantity.text = '${widget.quickQuantity}';
    widget.session.addListener(_cancelDisabledConfirmation);
    if (widget.session.snapshot == null) widget.session.load();
    if (widget.quickGift case final gift?) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _gift(gift);
      });
    }
  }

  @override
  void dispose() {
    widget.session.removeListener(_cancelDisabledConfirmation);
    widget.session.hide(notify: false);
    final route = _confirmationRoute;
    if (route != null && route.isActive) route.navigator?.removeRoute(route);
    _quantity.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant LiveInteractionPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.session == widget.session) return;
    oldWidget.session.removeListener(_cancelDisabledConfirmation);
    oldWidget.session.hide(notify: false);
    final route = _confirmationRoute;
    _confirmationRoute = null;
    if (route != null && route.isActive) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => route.navigator?.removeRoute(route),
      );
    }
    widget.session.addListener(_cancelDisabledConfirmation);
    final current = widget.session;
    if (current.snapshot == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.session == current) current.load();
      });
    }
  }

  void _cancelDisabledConfirmation() {
    final route = _confirmationRoute;
    if (!widget.session.isEnabled() && route != null) {
      _confirmationRoute = null;
      if (route.isActive) route.navigator?.removeRoute(route);
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: widget.session,
    builder: (context, _) {
      final session = widget.session;
      final data = session.snapshot;
      return NestedScrollView(
        headerSliverBuilder: (_, _) => [
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 4, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '接收主播：${widget.anchorName}\n房间 ${session.service.roomId}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        tooltip: '只读刷新目录和状态',
                        onPressed: session.loading ? null : session.load,
                        icon: const Icon(Icons.refresh),
                      ),
                    ],
                  ),
                ),
                if (session.loading || session.preparing)
                  const LinearProgressIndicator(),
                if (session.error case final error?)
                  _Notice(error, isError: true),
                if (session.result case final result?) _result(result),
                if (data != null && !data.loggedIn)
                  ListTile(
                    title: const Text('登录后可查看背包、粉丝状态并送礼'),
                    trailing: TextButton(
                      onPressed: widget.onLogin,
                      child: const Text('登录'),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      for (final entry
                          in (_tab < 2
                              ? const [(0, '礼物'), (1, '背包')]
                              : const [(2, '粉丝团'), (3, '大航海')]))
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(entry.$2),
                            selected: _tab == entry.$1,
                            onSelected: (_) => setState(() => _tab = entry.$1),
                          ),
                        ),
                    ],
                  ),
                ),
                if (_tab < 2)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _quantity,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                              labelText: '数量',
                              helperText: '提交前重新核对商品和金额',
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          onPressed: data?.loggedIn == true
                              ? () async {
                                  await widget.onRecharge();
                                  if (mounted) widget.session.load();
                                }
                              : null,
                          icon: const Icon(Icons.battery_charging_full),
                          label: const Text('充值'),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
        body: data == null
            ? Center(
                child: Text(session.loading ? '正在读取官方状态' : '状态未加载，请刷新'),
              )
            : switch (_tab) {
                0 => _gifts(data),
                1 => _bag(data),
                2 => _fans(data),
                _ => _guard(data),
              },
      );
    },
  );

  Widget _result(LiveActionResult result) {
    final label = switch (result.state) {
      LiveActionState.notSubmitted => '未提交',
      LiveActionState.submitting => '提交中',
      LiveActionState.succeeded => '服务端已确认',
      LiveActionState.failed => '未完成',
      LiveActionState.unknown => '结果未知，请勿重复发送',
    };
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(result.message),
            if (result.receiptId case final receipt?) Text('回执：$receipt'),
            if (result.state == LiveActionState.unknown)
              TextButton.icon(
                onPressed: widget.session.preparing
                    ? null
                    : widget.session.reconcile,
                icon: const Icon(Icons.fact_check_outlined),
                label: const Text('只读核对，不重复提交'),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _errors(LiveInteractionSnapshot data) => data.errors.entries
      .map((e) => _Notice('${e.key}：${e.value}', isError: true))
      .toList();

  Widget _gifts(LiveInteractionSnapshot data) => CustomScrollView(
    slivers: [
      SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (data.wallet case final wallet?)
              _Notice(
                '官方余额：电池 ${wallet.gold == null ? "未知" : liveBatteryAmount(wallet.gold!)}；银瓜子 ${wallet.silver ?? "未知"}。币种以商品当前价格为准。',
              ),
            const _Notice(
              '充值在官方页面办理。若页面要求登录，请返回 PiliPlus 刷新登录后重试；返回后不能凭页面关闭判断充值成功。',
            ),
            ..._errors(data),
            if (data.gifts.isEmpty) const _Notice('本房间没有可用礼物目录，不能提交送礼。'),
          ],
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(10, 4, 10, 16),
        sliver: SliverLayoutBuilder(
          builder: (context, constraints) => SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 145,
              mainAxisExtent: 166,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final gift = data.gifts[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Column(
                      children: [
                        Expanded(
                          child: gift.imageUrl.isEmpty
                              ? const Icon(Icons.card_giftcard, size: 42)
                              : Image.network(
                                  gift.imageUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, _, _) =>
                                      const Icon(Icons.card_giftcard, size: 42),
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
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        SizedBox(
                          height: 32,
                          child: TextButton(
                            onPressed:
                                data.loggedIn &&
                                    gift.sendable &&
                                    !widget.session.blocked
                                ? () => _gift(gift)
                                : null,
                            child: const Text('投喂'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: data.gifts.length,
            ),
          ),
        ),
      ),
    ],
  );

  Widget _bag(LiveInteractionSnapshot data) => CustomScrollView(
    slivers: [
      SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._errors(data),
            if (!data.loggedIn)
              const _Notice('请先登录。')
            else if (data.bag.isEmpty)
              const _Notice('背包暂无礼物；读取异常时会单独显示，不能视为库存为零。'),
          ],
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(10, 4, 10, 16),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 145,
            mainAxisExtent: 170,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final item = data.bag[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Column(
                    children: [
                      Expanded(
                        child: item.gift.imageUrl.isEmpty
                            ? const Icon(Icons.inventory_2_outlined, size: 42)
                            : Image.network(
                                item.gift.imageUrl,
                                fit: BoxFit.contain,
                                errorBuilder: (_, _, _) => const Icon(
                                  Icons.inventory_2_outlined,
                                  size: 42,
                                ),
                              ),
                      ),
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '库存 ${item.quantity}',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      Text(
                        item.expiresAt == null
                            ? '有效期未知'
                            : '至 ${item.expiresAt!.toLocal().toString().split(' ').first}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      SizedBox(
                        height: 32,
                        child: TextButton(
                          onPressed:
                              item.available &&
                                  data.loggedIn &&
                                  !widget.session.blocked
                              ? () => _gift(item.gift, bag: item)
                              : null,
                          child: const Text('赠送'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            childCount: data.bag.length,
          ),
        ),
      ),
    ],
  );

  Widget _fans(LiveInteractionSnapshot data) {
    final status = data.fanStatus;
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
      children: [
        ..._errors(data),
        if (status == null) ...[
          Card(
            child: ListTile(
              leading: const Icon(Icons.workspace_premium_outlined),
              title: Text('${widget.anchorName}的粉丝团'),
              subtitle: Text(
                data.loggedIn
                    ? '成员与灯牌状态暂未取得，请稍后只读刷新。'
                    : '访客可浏览此面板；成员等级、勋章与灯牌状态登录后读取。',
              ),
            ),
          ),
          const _Notice('粉丝团和灯牌状态未取得，不能推断为未加入或未点亮。'),
        ] else ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.anchorName}的${status.name.isEmpty ? "粉丝团" : status.name}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '粉丝团：${_state(status.joined, "已加入", "未加入")}  ·  灯牌：${_state(status.isLighted, "已点亮", "未点亮")}',
                  ),
                  Text(
                    '勋章 Lv.${status.level ?? "未知"}  ·  亲密度 ${status.intimacy ?? "未知"} / ${status.nextIntimacy ?? "未知"}',
                  ),
                  if (status.intimacy != null &&
                      status.nextIntimacy != null &&
                      status.nextIntimacy! > 0) ...[
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: (status.intimacy! / status.nextIntimacy!).clamp(
                        0.0,
                        1.0,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (status.joined != true)
            _fanButton(
              '加入粉丝团',
              LiveGiftPurpose.joinFanClub,
              status.joinGift,
              data.loggedIn && status.joined == false,
            ),
          if (status.joined == true && status.isLighted != true)
            _fanButton(
              '点亮灯牌',
              LiveGiftPurpose.lightMedal,
              status.lightGift,
              data.loggedIn && status.isLighted == false,
            ),
          const SizedBox(height: 12),
          Text('亲密度任务', style: Theme.of(context).textTheme.titleMedium),
          if (status.tasks.isEmpty) const _Notice('当前没有可展示的任务；每日规则以官方页面为准。'),
          for (final task in status.tasks)
            Card(
              child: ListTile(
                dense: true,
                leading: const Icon(Icons.favorite_border),
                title: Text(task.name),
                subtitle: Text(task.description),
                trailing: Text(_state(task.completed, '已完成', '待完成')),
              ),
            ),
        ],
        const SizedBox(height: 12),
        Text('勋章佩戴与摘下', style: Theme.of(context).textTheme.titleMedium),
        if (data.medals.isEmpty) const _Notice('未取得可佩戴勋章。'),
        for (final medal in data.medals)
          Card(
            child: ListTile(
              title: Text('${medal.name} · Lv.${medal.level}'),
              subtitle: Text(
                '${medal.wearing ? "佩戴中" : "未佩戴"}；'
                '灯牌：${_state(medal.isLighted, "亮", "未点亮")}\n'
                '主播 UID：${medal.targetUid}'
                '${medal.targetUid == widget.session.service.anchorUid ? "" : "\n属于其他主播，本面板仅办理当前直播间勋章"}',
              ),
              trailing: TextButton(
                onPressed:
                    data.loggedIn &&
                        !widget.session.blocked &&
                        medal.targetUid == widget.session.service.anchorUid
                    ? () => _medal(medal)
                    : null,
                child: Text(medal.wearing ? '摘下' : '佩戴'),
              ),
            ),
          ),
      ],
    );
  }

  Widget _guard(LiveInteractionSnapshot data) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      Text('大航海', style: Theme.of(context).textTheme.headlineSmall),
      const SizedBox(height: 12),
      if (data.guardStatus case final status?) ...[
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '大航海只读响应（字段含义待登录核实）',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text('身份状态码：${status.activeState ?? "未提供"}'),
                for (final tier in status.tiers)
                  Text(
                    '${tier.label}（档位代码 ${tier.type}）· 状态码 ${tier.status ?? "未提供"}'
                    '${tier.expiresAt == null ? "" : " · 到期字段 ${tier.expiresAt!.toLocal().toString().split(" ").first}"}',
                  ),
                const Text('这些只读字段不能证明本次付款或开通成功。'),
              ],
            ),
          ),
        ),
      ] else
        const _Notice('大航海身份尚未取得；返回官方页面后可只读刷新，但不能凭页面关闭判断开通成功。'),
      const Text('舰长、提督、总督的档位、权益、期限和最终价格以当前主播的哔哩哔哩官方页面为准。'),
      const SizedBox(height: 16),
      const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('付款前请在官方页面核对主播、档位、期限、金额及连续包月条款。返回此页只会刷新身份状态，不视为支付成功。'),
        ),
      ),
      const SizedBox(height: 12),
      FilledButton.icon(
        onPressed: data.loggedIn
            ? () async {
                await widget.onOpenGuard();
                if (mounted) widget.session.load();
              }
            : null,
        icon: const Icon(Icons.sailing_outlined),
        label: const Text('在应用内打开官方大航海'),
      ),
      if (!data.loggedIn)
        const _Notice('请先在 PiliPlus 登录。')
      else
        const _Notice('若官方页面仍要求登录，请返回 PiliPlus 刷新登录后重试。'),
    ],
  );

  String _state(bool? value, String yes, String no) => value == null
      ? '未知'
      : value
      ? yes
      : no;

  Widget _fanButton(
    String label,
    LiveGiftPurpose purpose,
    LiveGift? gift,
    bool available,
  ) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          gift == null
              ? '当前入团 / 点亮规则未取得，暂不能办理。'
              : '按当前官方规则赠送 ${gift.name} × 1，价格会在确认前重新读取。',
        ),
        FilledButton(
          onPressed: available && gift != null && !widget.session.blocked
              ? () => _fanAction(purpose)
              : null,
          child: Text(label),
        ),
      ],
    ),
  );

  Future<void> _gift(LiveGift gift, {LiveBagItem? bag}) async {
    final count = int.tryParse(_quantity.text);
    if (count == null ||
        count < 1 ||
        count > gift.maxQuantity ||
        (bag != null && count > bag.quantity)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '请输入有效数量（1–${bag == null ? gift.maxQuantity : bag.quantity}）。',
          ),
        ),
      );
      return;
    }
    final confirmation = await widget.session.prepare(
      () => widget.session.service.prepareGift(gift, count, bagItem: bag),
    );
    if (confirmation != null && mounted) await _confirmGift(confirmation);
  }

  Future<void> _fanAction(LiveGiftPurpose purpose) async {
    final confirmation = await widget.session.prepare(
      () => widget.session.service.prepareFanAction(purpose),
    );
    if (confirmation != null && mounted) await _confirmGift(confirmation);
  }

  Future<void> _confirmGift(LiveGiftConfirmation confirmation) async {
    final action = switch (confirmation.purpose) {
      LiveGiftPurpose.gift => '送礼',
      LiveGiftPurpose.joinFanClub => '赠礼并加入粉丝团',
      LiveGiftPurpose.lightMedal => '赠礼并点亮灯牌',
    };
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        _confirmationRoute = ModalRoute.of(dialogContext);
        return AlertDialog(
          title: Text('确认$action'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('主播：${widget.anchorName}'),
                Text(
                  '房间：${confirmation.roomId}；主播 UID：${confirmation.anchorUid}',
                ),
                Text('付款账号 UID：${confirmation.accountUid}'),
                Text('礼物：${confirmation.gift.name} × ${confirmation.quantity}'),
                Text(
                  confirmation.bagItem != null
                      ? '使用背包库存，不消耗瓜子'
                      : '合计：${confirmation.displayTotalPrice} ${confirmation.coinLabel}',
                ),
                const SizedBox(height: 12),
                const Text('点击确认后向官方提交一次。超时或断线会保留未知结果，只读核对不会重复扣款。'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('确认提交'),
            ),
          ],
        );
      },
    );
    _confirmationRoute = null;
    if (confirmed == true && mounted && widget.session.isEnabled()) {
      await widget.session.submit(confirmation);
    }
  }

  Future<void> _medal(LiveMedal medal) async {
    final identity = widget.session.service.accountIdentity;
    final expiresAt = DateTime.now().add(const Duration(seconds: 45));
    final action = medal.wearing ? '摘下' : '佩戴';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        _confirmationRoute = ModalRoute.of(dialogContext);
        return AlertDialog(
          title: Text('确认$action勋章'),
          content: Text(
            '${medal.name} · Lv.${medal.level}\n主播 UID：${medal.targetUid}\n此操作不等于加入粉丝团或点亮灯牌。',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('确认'),
            ),
          ],
        );
      },
    );
    _confirmationRoute = null;
    if (confirmed == true && mounted && widget.session.isEnabled()) {
      if (DateTime.now().isAfter(expiresAt)) return;
      await widget.session.medal(
        () => medal.wearing
            ? widget.session.service.takeOffMedal(
                expectedAccountIdentity: identity,
              )
            : widget.session.service.wearMedal(
                medal,
                expectedAccountIdentity: identity,
              ),
      );
    }
  }
}

class _Notice extends StatelessWidget {
  const _Notice(this.message, {this.isError = false});
  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Text(
      message,
      style: TextStyle(
        color: isError ? Theme.of(context).colorScheme.error : null,
        fontSize: 12,
      ),
    ),
  );
}
