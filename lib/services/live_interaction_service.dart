// Public testing injection names deliberately differ from private fields.
// ignore_for_file: prefer_initializing_formals
import 'dart:async';
import 'dart:convert';

import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/retry_interceptor.dart';
import 'package:PiliPlus/models_new/live/interactions/live_interaction.dart';
import 'package:PiliPlus/models_new/live/interactions/live_interaction_parser.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:dio/dio.dart';
import 'package:hive_ce/hive.dart';

export 'package:PiliPlus/models_new/live/interactions/live_interaction.dart';

/// A login instance is stronger than a UID: logout/relogin invalidates approval.
class LiveInteractionAccount {
  final int uid;
  final bool loggedIn;
  final Object identity;
  final String csrf;
  const LiveInteractionAccount({
    required this.uid,
    required this.loggedIn,
    required this.identity,
    this.csrf = '',
  });
}

abstract interface class LiveInteractionTransport {
  Future<Map<String, dynamic>> get(
    String path,
    Map<String, dynamic> query,
    LiveInteractionAccount account,
    CancelToken token,
  );
  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body,
    LiveInteractionAccount account,
  );
}

/// The journal contains transaction identity/status, never login credentials.
abstract interface class LiveInteractionJournal {
  Future<Map<String, dynamic>?> read(String key);
  Future<void> write(String key, Map<String, dynamic> record);
}

class _HiveInteractionJournal implements LiveInteractionJournal {
  static Future<Box<dynamic>>? _box;
  Future<Box<dynamic>> get box =>
      _box ??= Hive.openBox<dynamic>('liveInteractionJournal');
  @override
  Future<Map<String, dynamic>?> read(String key) async {
    final value = (await box).get(key);
    return value is Map ? liveMap(value) : null;
  }

  @override
  Future<void> write(String key, Map<String, dynamic> record) async {
    final storage = await box;
    await storage.put(key, record);
    // Durable before issuing a write, including a process interruption.
    await storage.flush();
  }
}

class _RequestInteractionTransport implements LiveInteractionTransport {
  Dio? _client;
  Dio get client {
    Request();
    return _client ??= Request.dio.clone()
      ..interceptors.removeWhere(
        (i) => i is RetryInterceptor || i is LogInterceptor,
      );
  }

  Options _options(LiveInteractionAccount account) => Options(
    extra: {'account': account.identity},
    followRedirects: false,
    maxRedirects: 0,
    contentType: Headers.formUrlEncodedContentType,
    headers: {'referer': 'https://live.bilibili.com/'},
    sendTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
  );
  static const _origin = 'https://api.live.bilibili.com';
  @override
  Future<Map<String, dynamic>> get(
    String path,
    Map<String, dynamic> query,
    LiveInteractionAccount account,
    CancelToken token,
  ) async => liveMap(
    (await client.get<dynamic>(
      _origin + path,
      queryParameters: query,
      options: _options(account),
      cancelToken: token,
    )).data,
  );
  @override
  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body,
    LiveInteractionAccount account,
  ) async => liveMap(
    (await client.post<dynamic>(
      _origin + path,
      data: body,
      options: _options(account),
    )).data,
  );
  // Never close this clone: its adapter belongs to Request.dio.
}

/// Official live API integration. Current JS supplies protocol candidates;
/// account/write compatibility still requires controlled online acceptance.
class LiveInteractionService {
  final int roomId;
  final int anchorUid;
  final LiveInteractionTransport _transport;
  final LiveInteractionJournal _journal;
  final LiveInteractionAccount Function() _account;
  final DateTime Function() _now;
  static final Set<String> _writeLocks = {};
  static int _nonce = 0;
  final Set<String> _consumedConfirmations = {};
  CancelToken _reads = CancelToken();
  bool _disposed = false;
  int _generation = 0;
  int _approvalEpoch = 0;
  LiveActionResult? _lastAction;
  Object? _lastActionIdentity;
  int? _lastActionUid;

  LiveInteractionService({required this.roomId, required this.anchorUid})
    : _transport = _RequestInteractionTransport(),
      _journal = _HiveInteractionJournal(),
      _account = _currentAccount,
      _now = DateTime.now;

  LiveInteractionService.testing({
    required this.roomId,
    required this.anchorUid,
    required LiveInteractionTransport transport,
    required LiveInteractionJournal journal,
    required LiveInteractionAccount Function() account,
    DateTime Function()? now,
  }) : _transport = transport,
       _journal = journal,
       _account = account,
       _now = now ?? DateTime.now;

  static LiveInteractionAccount _currentAccount() {
    final account = Accounts.main;
    return LiveInteractionAccount(
      uid: account.isLogin ? account.mid : 0,
      loggedIn: account.isLogin,
      identity: account,
      csrf: account.isLogin ? account.csrf : '',
    );
  }

  bool get isLoggedIn => _account().loggedIn;
  Object get accountIdentity => _account().identity;
  LiveActionResult? get lastAction {
    final current = _account();
    return current.uid == _lastActionUid &&
            identical(current.identity, _lastActionIdentity)
        ? _lastAction
        : null;
  }

  void _updateVisible(LiveActionResult result, int uid) {
    final current = _account();
    final owner =
        result.accountIdentity ?? result.confirmation?.accountIdentity;
    if (current.uid != uid ||
        (owner != null && !identical(owner, current.identity))) {
      return;
    }
    _lastAction = result;
    _lastActionUid = uid;
    _lastActionIdentity = current.identity;
  }

  String _key(int uid) => '$uid:$roomId:$anchorUid';
  String _operationId() => '${_now().microsecondsSinceEpoch}-${++_nonce}';

  void _guard(LiveInteractionAccount account, {bool login = true}) {
    if (_disposed) throw const LiveInteractionException('互动面板已关闭');
    final current = _account();
    if (!identical(account.identity, current.identity) ||
        account.uid != current.uid) {
      throw const LiveInteractionException('账号已变化，请重新确认');
    }
    if (login &&
        (!current.loggedIn || current.uid <= 0 || current.csrf.isEmpty)) {
      throw const LiveInteractionException('请先登录有效账号');
    }
    if (roomId <= 0 || anchorUid <= 0) {
      throw const LiveInteractionException('房间或主播信息尚未就绪');
    }
  }

  Map<String, dynamic> _data(Map<String, dynamic> response) {
    final code = liveInt(response['code']);
    if (code != 0) {
      throw LiveInteractionException(
        response['message']?.toString() ??
            '官方接口未返回有效结果${code == null ? '' : '（$code）'}',
      );
    }
    if (response['data'] is! Map) {
      throw const LiveInteractionException('官方响应缺少数据，不能判断为空或成功');
    }
    return liveMap(response['data']);
  }

  Future<Map<String, dynamic>> _get(
    String path,
    Map<String, dynamic> query,
    LiveInteractionAccount account,
  ) async {
    _guard(account, login: false);
    final data = _data(await _transport.get(path, query, account, _reads));
    _guard(account, login: false);
    return data;
  }

  static const _catalogPath = '/xlive/web-room/v1/giftPanel/roomGiftList';
  static const _bagPath = '/xlive/web-room/v1/gift/bag_list';
  static const _medalsPath = '/xlive/app-ucenter/v1/fansMedal/panel';
  static const _activatedPath =
      '/xlive/app-ucenter/v1/fansMedal/GetActivatedMedalInfo';
  static const _relationPath =
      '/xlive/guard-interface/v1/guard/GuardActiveWithFansClub';
  static const _guardActivePath =
      '/xlive/general-interface/v1/guard/GuardActive';
  static const _userPath = '/xlive/web-room/v1/index/getInfoByUser';
  static const _superChatConfigPath = '/av/v1/SuperChat/config';
  Map<String, dynamic> get _roomQuery => {
    'room_id': roomId,
    'ruid': anchorUid,
    'platform': 'pc',
  };

  Future<LiveSuperChatConfig> loadSuperChatConfig({
    required int parentAreaId,
    required int areaId,
  }) async {
    final account = _account();
    _guard(account);
    if (parentAreaId <= 0 || areaId <= 0) {
      throw const LiveInteractionException('直播分区信息尚未加载，不能查询当前 SC 档位');
    }
    final data = await _get(_superChatConfigPath, {
      'room_id': roomId,
      'ruid': anchorUid,
      'parent_area_id': parentAreaId,
      'area_id': areaId,
    }, account);
    return LiveInteractionParser.superChatConfig(data);
  }

  Future<LiveInteractionSnapshot> loadPanel() async {
    final account = _account();
    _guard(account, login: false);
    final generation = ++_generation;
    final errors = <String, String>{};
    Future<Map<String, dynamic>> fetch(
      String label,
      String path,
      Map<String, dynamic> query,
    ) async {
      try {
        return await _get(path, query, account);
      } catch (e) {
        errors[label] = _safeMessage(e);
        return const {};
      }
    }

    final data = await Future.wait([
      fetch('礼物', _catalogPath, {..._roomQuery, 'source': 'live', 'build': 0}),
      if (account.loggedIn) ...[
        fetch('背包', _bagPath, {
          'room_id': roomId,
          'mobi_app': 'web',
          't': _now().millisecondsSinceEpoch,
        }),
        fetch('勋章', _medalsPath, {
          'target_id': anchorUid,
          'page': 1,
          'page_size': 50,
        }),
        fetch('灯牌', _activatedPath, {
          'target_id': anchorUid,
          'room_id': roomId,
          'platform': 'pc',
          'scene': 'club',
        }),
        fetch('粉丝团', _relationPath, _roomQuery),
        fetch('余额', _userPath, {'room_id': roomId, 'not_mock_enter_effect': 1}),
        fetch('大航海身份', _guardActivePath, {
          'ruid': anchorUid,
          'platform': 'pc',
        }),
      ],
    ]);
    _guard(account, login: false);
    if (generation != _generation) {
      throw const LiveInteractionException('已有较新的面板请求');
    }
    final catalog = data.first;
    final wallet = account.loggedIn
        ? liveMap(data[5]['wallet'])
        : const <String, dynamic>{};
    await restorePending();
    _guard(account, login: false);
    return LiveInteractionSnapshot(
      roomId: roomId,
      anchorUid: anchorUid,
      accountUid: account.uid,
      loggedIn: account.loggedIn,
      gifts: LiveInteractionParser.gifts(catalog, roomId, anchorUid),
      bag: account.loggedIn
          ? LiveInteractionParser.bag(data[1], roomId, anchorUid, _now())
          : const [],
      medals: account.loggedIn
          ? LiveInteractionParser.medals(data[2])
          : const [],
      fanStatus:
          account.loggedIn &&
              (!errors.containsKey('灯牌') || !errors.containsKey('粉丝团'))
          ? LiveInteractionParser.fanStatus(
              data[3],
              data[4],
              LiveInteractionParser.giftConfigs(catalog),
              roomId,
              anchorUid,
            )
          : null,
      wallet: wallet.isNotEmpty
          ? LiveWallet(
              gold: liveInt(wallet['gold']),
              silver: liveInt(wallet['silver']),
            )
          : null,
      guardStatus: account.loggedIn && !errors.containsKey('大航海身份')
          ? LiveInteractionParser.guardStatus(data[6])
          : null,
      errors: Map.unmodifiable(errors),
    );
  }

  Future<LiveGiftConfirmation> prepareGift(
    LiveGift gift,
    int quantity, {
    LiveBagItem? bagItem,
    LiveGiftPurpose purpose = LiveGiftPurpose.gift,
  }) async {
    final account = _account();
    _guard(account);
    if (purpose != LiveGiftPurpose.gift) return prepareFanAction(purpose);
    final snapshot = await loadPanel();
    _guard(account);
    LiveGift? fresh;
    LiveBagItem? freshBag;
    if (bagItem != null) {
      freshBag = snapshot.bag
          .where((i) => i.bagId == bagItem.bagId && i.giftId == gift.id)
          .firstOrNull;
      fresh = freshBag?.gift;
      if (freshBag == null ||
          !freshBag.available ||
          quantity > freshBag.quantity) {
        throw const LiveInteractionException('背包库存或有效期已变化，请刷新');
      }
    } else {
      fresh = snapshot.gifts.where((i) => i.id == gift.id).firstOrNull;
    }
    if (fresh == null || !fresh.sendable) {
      throw LiveInteractionException(
        fresh?.unavailableReason ?? '礼物已下架或当前房间不可用',
      );
    }
    _quantity(fresh, quantity);
    _balance(snapshot.wallet, fresh, quantity, freshBag);
    await _ensureNoPending(account);
    return _confirmation(fresh, quantity, account, purpose, freshBag);
  }

  Future<LiveGiftConfirmation> prepareFanAction(LiveGiftPurpose purpose) async {
    if (purpose == LiveGiftPurpose.gift) {
      throw const LiveInteractionException('请选择要投喂的礼物');
    }
    final account = _account();
    _guard(account);
    final snapshot = await loadPanel();
    _guard(account);
    final status = snapshot.fanStatus;
    if (purpose == LiveGiftPurpose.joinFanClub && status?.joined != false) {
      throw LiveInteractionException(
        status?.joined == true ? '已加入该粉丝团' : '无法确认当前入团状态',
      );
    }
    if (purpose == LiveGiftPurpose.lightMedal &&
        (status?.joined != true || status?.isLighted != false)) {
      throw const LiveInteractionException('需已加入粉丝团，且服务端确认灯牌未点亮');
    }
    final gift = purpose == LiveGiftPurpose.joinFanClub
        ? status?.joinGift
        : status?.lightGift;
    if (gift == null || !gift.sendable) {
      throw LiveInteractionException(
        gift?.unavailableReason ?? '官方当前入团/点亮礼物或价格不可用',
      );
    }
    _balance(snapshot.wallet, gift, 1, null);
    await _ensureNoPending(account);
    return _confirmation(gift, 1, account, purpose, null);
  }

  LiveGiftConfirmation _confirmation(
    LiveGift gift,
    int quantity,
    LiveInteractionAccount account,
    LiveGiftPurpose purpose,
    LiveBagItem? bag,
  ) => LiveGiftConfirmation(
    gift: gift,
    quantity: quantity,
    purpose: purpose,
    accountUid: account.uid,
    roomId: roomId,
    anchorUid: anchorUid,
    accountIdentity: account.identity,
    approvalEpoch: _approvalEpoch,
    bagItem: bag,
    expiresAt: _now().add(const Duration(seconds: 45)),
    operationId: _operationId(),
  );

  void _quantity(LiveGift gift, int quantity) {
    if (quantity < 1 || quantity > gift.maxQuantity || quantity > 5000) {
      throw const LiveInteractionException('数量超过当前官方允许范围');
    }
  }

  void _balance(
    LiveWallet? wallet,
    LiveGift gift,
    int quantity,
    LiveBagItem? bag,
  ) {
    if (bag != null) return;
    final balance = gift.coinType == 'gold' ? wallet?.gold : wallet?.silver;
    if (balance == null) throw const LiveInteractionException('无法取得当前余额，请稍后刷新');
    if (balance < gift.price * quantity) {
      throw LiveInteractionException('${gift.coinLabel}余额不足，请在官方渠道充值');
    }
  }

  Future<void> _ensureNoPending(LiveInteractionAccount account) async {
    final pending = await restorePending();
    _guard(account);
    if (_writeLocks.contains(_key(account.uid)) ||
        pending?.state == LiveActionState.submitting ||
        pending?.state == LiveActionState.unknown) {
      throw const LiveInteractionException('此房间已有未确认操作；请先只读核对，勿重复投喂');
    }
  }

  Future<LiveActionResult> submitGift(LiveGiftConfirmation confirmation) async {
    final account = _account();
    try {
      _guard(account);
      if (!identical(account.identity, confirmation.accountIdentity) ||
          account.uid != confirmation.accountUid ||
          roomId != confirmation.roomId ||
          anchorUid != confirmation.anchorUid ||
          confirmation.approvalEpoch != _approvalEpoch ||
          !_now().isBefore(confirmation.expiresAt)) {
        throw const LiveInteractionException('确认已失效，请重新选择并确认');
      }
      if (_consumedConfirmations.contains(confirmation.operationId)) {
        throw const LiveInteractionException('该确认已提交，不能重复投喂');
      }
      await _ensureNoPending(account);
      if (_lastAction?.operationId == confirmation.operationId ||
          _consumedConfirmations.contains(confirmation.operationId)) {
        throw const LiveInteractionException('该确认已经处理，不能重复投喂');
      }
      final fresh = confirmation.purpose == LiveGiftPurpose.gift
          ? await prepareGift(
              confirmation.gift,
              confirmation.quantity,
              bagItem: confirmation.bagItem,
            )
          : await prepareFanAction(confirmation.purpose);
      _guard(account);
      if (!_now().isBefore(confirmation.expiresAt) ||
          confirmation.approvalEpoch != _approvalEpoch ||
          _consumedConfirmations.contains(confirmation.operationId)) {
        throw const LiveInteractionException('确认已失效或已被处理，请重新选择');
      }
      if (fresh.gift.id != confirmation.gift.id ||
          fresh.gift.price != confirmation.gift.price ||
          fresh.gift.coinType != confirmation.gift.coinType ||
          fresh.bagItem?.bagId != confirmation.bagItem?.bagId) {
        throw const LiveInteractionException('官方价格、礼物或库存已变化，请重新确认');
      }
      if (!_writeLocks.add(_key(account.uid))) {
        throw const LiveInteractionException('正在提交其他操作，请等待');
      }
    } catch (e) {
      return LiveActionResult(
        state: LiveActionState.notSubmitted,
        message: _safeMessage(e),
        operationId: confirmation.operationId,
        confirmation: confirmation,
      );
    }

    var issued = false;
    String? knownReceipt;
    try {
      final submitting = LiveActionResult(
        state: LiveActionState.submitting,
        message: '已确认，正在提交一次投喂',
        operationId: confirmation.operationId,
        confirmation: confirmation,
      );
      await _save(submitting, account.uid);
      _guard(account);
      if (!_now().isBefore(confirmation.expiresAt) ||
          confirmation.approvalEpoch != _approvalEpoch ||
          _consumedConfirmations.contains(confirmation.operationId)) {
        throw const LiveInteractionException('确认已失效或已被处理，请重新选择');
      }
      _consumedConfirmations.add(confirmation.operationId);
      final body = giftBody(confirmation, account.csrf);
      final path = confirmation.bagItem != null
          ? '/xlive/revenue/v2/gift/sendBagMultiUser'
          : confirmation.gift.coinType == 'gold'
          ? '/xlive/revenue/v2/gift/sendGoldMultiUser'
          : '/xlive/revenue/v2/gift/sendSilverMultiUser';
      issued = true;
      final response = await _transport.post(path, body, account);
      final code = liveInt(response['code']);
      if (code != null && code != 0) {
        return await _finish(
          LiveActionResult(
            state: LiveActionState.failed,
            message: response['message']?.toString() ?? '官方拒绝投喂（$code）',
            operationId: confirmation.operationId,
            confirmation: confirmation,
          ),
          account.uid,
        );
      }
      final receipt = code == 0
          ? LiveInteractionParser.giftReceipt(
              liveMap(response['data']),
              confirmation,
            )
          : null;
      knownReceipt = receipt;
      final needsFanConfirmation =
          receipt != null && confirmation.purpose != LiveGiftPurpose.gift;
      final result = LiveActionResult(
        state: receipt == null || needsFanConfirmation
            ? LiveActionState.unknown
            : LiveActionState.succeeded,
        message: needsFanConfirmation
            ? '官方已确认投喂；入团/点亮状态尚待读取确认'
            : receipt == null
            ? '已提交，但缺少匹配的官方投喂回执；请勿重发'
            : '官方已确认投喂，回执：$receipt',
        operationId: confirmation.operationId,
        confirmation: confirmation,
        receiptId: receipt,
      );
      final saved = await _finish(result, account.uid);
      if (needsFanConfirmation) {
        try {
          return await reconcile(saved);
        } catch (_) {
          return saved;
        }
      }
      return saved;
    } catch (e) {
      final result = LiveActionResult(
        state: issued ? LiveActionState.unknown : LiveActionState.notSubmitted,
        message: issued ? '提交结果未知，请只读核对，勿重复投喂' : _safeMessage(e),
        operationId: confirmation.operationId,
        confirmation: confirmation,
        receiptId: knownReceipt,
      );
      return await _finish(result, account.uid);
    } finally {
      _writeLocks.remove(_key(account.uid));
    }
  }

  /// Exact regular-room fields derived from current official sender.
  static Map<String, dynamic> giftBody(
    LiveGiftConfirmation confirmation,
    String csrf,
  ) => {
    'uid': confirmation.accountUid,
    'gift_id': confirmation.gift.id,
    'ruid': confirmation.anchorUid,
    'send_ruid': confirmation.anchorUid,
    'gift_num': confirmation.quantity,
    'coin_type': confirmation.gift.coinType,
    if (confirmation.bagItem != null) 'bag_id': confirmation.bagItem!.bagId,
    'platform': 'pc',
    'biz_code': 'Live',
    'biz_id': confirmation.roomId,
    'price': confirmation.bagItem == null ? confirmation.gift.price : 0,
    'receive_users': jsonEncode([
      {'uid': confirmation.anchorUid},
    ]),
    'statistics': jsonEncode({
      'platform': 5,
      'pc_client': 'pcWeb',
      'appId': 100,
    }),
    'live_statistics': jsonEncode({'pc_client': 'pcWeb', 'source_event': 0}),
    'web_location': '444.8',
    'csrf': csrf,
    'csrf_token': csrf,
  };

  Future<LiveActionResult> wearMedal(
    LiveMedal medal, {
    required Object expectedAccountIdentity,
  }) => _medalAction(medal.medalId, true, expectedAccountIdentity);
  Future<LiveActionResult> takeOffMedal({
    required Object expectedAccountIdentity,
  }) => _medalAction(null, false, expectedAccountIdentity);

  Future<LiveActionResult> _medalAction(
    int? medalId,
    bool wear,
    Object expectedAccountIdentity,
  ) async {
    final operation = _operationId();
    final account = _account();
    final approvalEpoch = _approvalEpoch;
    var issued = false;
    var locked = false;
    try {
      _guard(account);
      if (!identical(account.identity, expectedAccountIdentity)) {
        throw const LiveInteractionException('账号已变化，请重新确认勋章操作');
      }
      await _ensureNoPending(account);
      final snapshot = await loadPanel();
      _guard(account);
      if (approvalEpoch != _approvalEpoch) {
        throw const LiveInteractionException('未提交的勋章确认已撤销');
      }
      if (snapshot.errors.containsKey('勋章')) {
        throw const LiveInteractionException('无法核验当前勋章状态');
      }
      if (wear &&
          !snapshot.medals.any(
            (m) => m.medalId == medalId && m.targetUid == anchorUid,
          )) {
        throw const LiveInteractionException('勋章不属于当前主播，或已不可用');
      }
      if (!wear && !snapshot.medals.any((m) => m.wearing)) {
        return LiveActionResult(
          state: LiveActionState.succeeded,
          message: '当前未佩戴勋章',
          operationId: operation,
          accountIdentity: account.identity,
        );
      }
      locked = _writeLocks.add(_key(account.uid));
      if (!locked) throw const LiveInteractionException('正在提交其他操作');
      final submitting = LiveActionResult(
        state: LiveActionState.submitting,
        message: wear ? '正在佩戴勋章' : '正在摘下勋章',
        operationId: operation,
        medalId: medalId,
        medalWearing: wear,
        accountIdentity: account.identity,
      );
      await _save(submitting, account.uid);
      _guard(account);
      if (approvalEpoch != _approvalEpoch) {
        throw const LiveInteractionException('未提交的勋章确认已撤销');
      }
      issued = true;
      final response = await _transport.post(
        wear
            ? '/xlive/app-ucenter/v1/fansMedal/wear'
            : '/xlive/app-ucenter/v1/fansMedal/take_off',
        {
          if (wear) 'medal_id': medalId,
          'target_id': anchorUid,
          'csrf': account.csrf,
          'csrf_token': account.csrf,
        },
        account,
      );
      final code = liveInt(response['code']);
      if (code != null && code != 0) {
        return await _finish(
          submitting.copyWith(
            state: LiveActionState.failed,
            message: response['message']?.toString() ?? '官方拒绝勋章操作（$code）',
          ),
          account.uid,
        );
      }
      return await reconcile(
        await _finish(
          submitting.copyWith(
            state: LiveActionState.unknown,
            message: '已提交勋章操作，正在读取官方佩戴状态',
          ),
          account.uid,
        ),
      );
    } catch (e) {
      final result = LiveActionResult(
        state: issued ? LiveActionState.unknown : LiveActionState.notSubmitted,
        message: issued ? '勋章操作结果未知，请读取官方状态' : _safeMessage(e),
        operationId: operation,
        medalId: medalId,
        medalWearing: wear,
        accountIdentity: account.identity,
      );
      return locked ? await _finish(result, account.uid) : result;
    } finally {
      if (locked) _writeLocks.remove(_key(account.uid));
    }
  }

  /// Read only. Balance/inventory/medal changes do not prove a gift receipt.
  Future<LiveActionResult> reconcile(LiveActionResult result) async {
    final account = _account();
    _guard(account);
    final saved = await restorePending();
    if (saved?.operationId != result.operationId ||
        (result.confirmation?.accountUid != null &&
            result.confirmation!.accountUid != account.uid)) {
      throw const LiveInteractionException('操作不属于当前房间账号');
    }
    final snapshot = await loadPanel();
    _guard(account);
    if (result.medalWearing case final wear?) {
      final known = !snapshot.errors.containsKey('勋章');
      final matches = wear
          ? snapshot.medals.any((m) => m.medalId == result.medalId && m.wearing)
          : !snapshot.medals.any((m) => m.wearing);
      return _finish(
        result.copyWith(
          state: known && matches
              ? LiveActionState.succeeded
              : LiveActionState.unknown,
          message: known && matches ? '官方勋章佩戴状态已确认' : '勋章状态尚未确认；未重新提交',
        ),
        account.uid,
      );
    }
    final purpose = result.confirmation?.purpose;
    final fan = snapshot.fanStatus;
    final targetReached = purpose == LiveGiftPurpose.joinFanClub
        ? fan?.joined == true
        : purpose == LiveGiftPurpose.lightMedal
        ? fan?.isLighted == true
        : false;
    final receiptConfirmed = result.receiptId != null;
    final message = receiptConfirmed && targetReached
        ? '官方已确认本次投喂及${purpose == LiveGiftPurpose.joinFanClub ? '入团' : '灯牌点亮'}状态'
        : receiptConfirmed
        ? '官方已确认投喂；入团/点亮状态尚未确认，请只读刷新，勿重发'
        : targetReached
        ? '官方粉丝状态已更新；缺少本次投喂唯一回执，送礼结果仍未知，勿重发'
        : '已刷新官方余额、背包和粉丝状态；这些变化不能证明本次投喂，结果仍未知，勿重发';
    return _finish(
      result.copyWith(
        state: receiptConfirmed && targetReached
            ? LiveActionState.succeeded
            : LiveActionState.unknown,
        message: message,
        fanStatus: fan,
      ),
      account.uid,
    );
  }

  Future<LiveActionResult?> restorePending() async {
    final account = _account();
    if (!account.loggedIn) return _lastAction = null;
    final data = await _journal.read(_key(account.uid));
    _guard(account);
    if (data == null) return _lastAction = null;
    final result = _decode(data);
    if (result.state == LiveActionState.submitting) {
      // Never restart a write after reopening or process interruption.
      final unknown = result.copyWith(
        state: LiveActionState.unknown,
        message: '上次提交未收到最终回执；请只读核对，勿重发',
      );
      if (!_writeLocks.contains(_key(account.uid))) {
        await _save(unknown, account.uid);
      }
      final restored = _writeLocks.contains(_key(account.uid))
          ? result
          : unknown;
      _updateVisible(restored, account.uid);
      return restored;
    }
    _updateVisible(result, account.uid);
    return result;
  }

  Future<void> _save(LiveActionResult result, int uid) async {
    await _journal.write(_key(uid), _encode(result));
    _updateVisible(result, uid);
  }

  Future<LiveActionResult> _finish(LiveActionResult result, int uid) async {
    var settled = result;
    try {
      await _save(result, uid);
    } catch (_) {
      // If a write was issued, the durable "submitting" record still blocks
      // an automatic replay after restart. Keep the visible result cautious.
      if (result.state == LiveActionState.succeeded ||
          result.state == LiveActionState.unknown) {
        settled = result.copyWith(
          state: LiveActionState.unknown,
          message: '${result.message}；本地回执保存失败，请勿重发',
        );
      }
    }
    _updateVisible(settled, uid);
    return settled;
  }

  Map<String, dynamic> _encode(LiveActionResult result) {
    final c = result.confirmation;
    return {
      'schema': 1,
      'state': result.state.name,
      'message': result.message,
      'operation_id': result.operationId,
      'receipt_id': result.receiptId,
      'updated_at': _now().toUtc().toIso8601String(),
      'medal_id': result.medalId,
      'medal_wearing': result.medalWearing,
      if (c != null)
        'confirmation': {
          'account_uid': c.accountUid,
          'room_id': c.roomId,
          'anchor_uid': c.anchorUid,
          'gift_id': c.gift.id,
          'gift_name': c.gift.name,
          'price': c.gift.price,
          'coin_type': c.gift.coinType,
          'quantity': c.quantity,
          'bag_id': c.bagItem?.bagId,
          'purpose': c.purpose.name,
          'expires_at': c.expiresAt.toUtc().toIso8601String(),
        },
    };
  }

  LiveActionResult _decode(Map<String, dynamic> data) {
    final c = liveMap(data['confirmation']);
    final restoredGift = LiveGift(
      id: liveInt(c['gift_id']) ?? 0,
      name: c['gift_name']?.toString() ?? '',
      price: liveInt(c['price']) ?? 0,
      priceKnown: liveInt(c['price']) != null,
      coinType: c['coin_type']?.toString() ?? '',
    );
    final bagId = liveInt(c['bag_id']);
    final operation = data['operation_id']?.toString() ?? 'unknown-record';
    final state =
        LiveActionState.values
            .where((s) => s.name == data['state'])
            .firstOrNull ??
        LiveActionState.unknown;
    return LiveActionResult(
      state: state,
      message: data['message']?.toString() ?? '上次操作结果未知',
      operationId: operation,
      receiptId: data['receipt_id']?.toString(),
      medalId: liveInt(data['medal_id']),
      medalWearing: liveBool(data['medal_wearing']),
      confirmation: c.isEmpty
          ? null
          : LiveGiftConfirmation(
              gift: restoredGift,
              bagItem: bagId != null && bagId > 0
                  ? LiveBagItem(
                      bagId: bagId,
                      giftId: restoredGift.id,
                      name: restoredGift.name,
                      quantity: liveInt(c['quantity']) ?? 0,
                      gift: restoredGift,
                      available: false,
                    )
                  : null,
              quantity: liveInt(c['quantity']) ?? 0,
              purpose:
                  LiveGiftPurpose.values
                      .where((p) => p.name == c['purpose'])
                      .firstOrNull ??
                  LiveGiftPurpose.gift,
              accountUid: liveInt(c['account_uid']) ?? 0,
              roomId: liveInt(c['room_id']) ?? 0,
              anchorUid: liveInt(c['anchor_uid']) ?? 0,
              expiresAt:
                  DateTime.tryParse(c['expires_at']?.toString() ?? '') ??
                  DateTime(1970),
              operationId: operation,
            ),
    );
  }

  static String _safeMessage(Object error) => error is LiveInteractionException
      ? error.message
      : error is DioException
      ? (error.type == DioExceptionType.cancel ? '读取已取消' : '连接官方接口失败，请稍后重试读取')
      : '无法核验官方当前信息，请刷新';

  void dispose() {
    _disposed = true;
    invalidateApprovals();
    // Issued writes are not cancelled/replayed; their journal persists.
  }

  void invalidateApprovals() {
    ++_approvalEpoch;
    ++_generation;
    _reads.cancel('unsubmitted approval revoked');
    _reads = CancelToken();
    // Issued writes have no read CancelToken and continue to settle the journal.
  }
}
