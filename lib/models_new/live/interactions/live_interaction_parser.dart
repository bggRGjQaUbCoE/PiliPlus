import 'package:PiliPlus/models_new/live/interactions/live_interaction.dart';

abstract final class LiveInteractionParser {
  static Map<int, Map<String, dynamic>> giftConfigs(Map<String, dynamic> data) {
    final config = liveMap(data['gift_config']);
    final base = liveMap(config['base_config']);
    final configs = <int, Map<String, dynamic>>{};
    for (final item in liveMaps(base['list'])) {
      final id = liveInt(item['id']);
      if (id != null && id > 0) configs[id] = item;
    }
    for (final item in liveMaps(config['room_config'])) {
      final id = liveInt(item['id']);
      if (id != null && id > 0) {
        configs[id] = {...?configs[id], ...item};
      }
    }
    return configs;
  }

  static LiveGift gift(
    Map<String, dynamic> config, {
    Map<String, dynamic> entry = const {},
    int roomId = 0,
    int anchorUid = 0,
    int maxQuantity = 1,
    int? offeredPrice,
  }) {
    final id = liveInt(config['id'] ?? config['gift_id']) ?? 0;
    final price = offeredPrice ?? liveInt(config['price']);
    final coin = config['coin_type']?.toString() ?? '';
    final scene = liveMap(entry['gift_scene']);
    final special = liveMap(entry['special']);
    String? reason;
    if (id <= 0 ||
        price == null ||
        price < 0 ||
        !{'gold', 'silver'}.contains(coin)) {
      reason = '官方价格或币种信息不完整';
    } else if (maxQuantity <= 0) {
      reason = '官方当前数量限制未允许投喂';
    } else if (_knownBlindBox(config) || _knownBlindBox(entry)) {
      // Current official catalogues label known blind boxes as gift_type 6 /
      // gift_attrs [6], even with draw=0 and default_gift/send_gift scenes.
      reason = '盲盒礼物的规则与结果尚未接入，请使用官方专用流程';
    } else if (liveInt(special['is_use']) == 0) {
      reason = special['tips']?.toString() ?? '当前礼物不可投喂';
    } else if ((liveInt(config['bind_roomid']) ?? 0) > 0 &&
        liveInt(config['bind_roomid']) != roomId) {
      reason = '礼物仅限指定房间';
    } else if ((liveInt(config['bind_ruid']) ?? 0) > 0 &&
        liveInt(config['bind_ruid']) != anchorUid) {
      reason = '礼物仅限指定主播';
    } else if ((liveInt(config['privilege_required']) ?? 0) > 0) {
      reason = '需要特殊权限；本版尚未核验该权限';
    } else if ((liveInt(config['draw']) ?? 0) != 0 ||
        (scene['pay_type'] != null && scene['pay_type'] != 'send_gift')) {
      reason = '活动/抽奖礼物需使用官方专用流程';
    }
    final limit = liveInt(config['max_send_limit']);
    final max = limit != null && limit > 0 && limit < maxQuantity
        ? limit
        : maxQuantity;
    return LiveGift(
      id: id,
      name: config['name']?.toString() ?? '礼物 $id',
      price: price ?? 0,
      priceKnown:
          price != null && price >= 0 && {'gold', 'silver'}.contains(coin),
      coinType: coin,
      imageUrl: config['img_basic']?.toString() ?? '',
      description: [
        config['desc'],
        config['rule'],
      ].whereType<String>().where((s) => s.isNotEmpty).join('\n'),
      maxQuantity: max > 0 ? max : 1,
      sendable: reason == null,
      unavailableReason: reason,
    );
  }

  static bool _knownBlindBox(Map<String, dynamic> value) =>
      liveInt(value['gift_type']) == 6 ||
      (value['gift_attrs'] is List &&
          (value['gift_attrs'] as List).any((item) => liveInt(item) == 6));

  static List<LiveGift> gifts(
    Map<String, dynamic> data,
    int roomId,
    int anchorUid,
  ) {
    final configs = giftConfigs(data);
    final giftData = liveMap(data['gift_data']);
    final room = liveMap(giftData['room_gift_list']);
    final max = liveInt(giftData['max_send_gift']) ?? 0;
    final discounts = <int, int>{
      for (final item in liveMaps(giftData['discount_gift_list']))
        if (liveInt(item['gift_id']) case final int id)
          if (liveInt(item['discount_price']) case final int price)
            if (price > 0) id: price,
    };
    final seen = <int>{};
    return [
      for (final key in ['gold_list', 'silver_list'])
        for (final entry in liveMaps(room[key]))
          if (liveInt(entry['gift_id'] ?? entry['id']) case final int id)
            if (seen.add(id))
              gift(
                configs[id] ?? {'id': id},
                entry: entry,
                roomId: roomId,
                anchorUid: anchorUid,
                maxQuantity: max,
                offeredPrice: discounts[id],
              ),
    ];
  }

  static List<LiveBagItem> bag(
    Map<String, dynamic> data,
    int roomId,
    int anchorUid,
    DateTime now,
  ) {
    final configs = <int, Map<String, dynamic>>{
      for (final config in liveMaps(data['gift_config']))
        if (liveInt(config['id']) case final int id) id: config,
    };
    return [
      for (final entry in liveMaps(data['list']))
        ?_bag(entry, configs, roomId, anchorUid, now),
    ];
  }

  static LiveBagItem? _bag(
    Map<String, dynamic> entry,
    Map<int, Map<String, dynamic>> configs,
    int roomId,
    int anchorUid,
    DateTime now,
  ) {
    // Type 1 is a gift; other types include title renewal cards.
    if (liveInt(entry['type']) != 1) return null;
    final id = liveInt(entry['gift_id']) ?? 0;
    final bagId = liveInt(entry['bag_id']) ?? 0;
    final count = liveInt(entry['gift_num']) ?? 0;
    final expire = liveInt(entry['expire_at']);
    final expires = expire != null && expire > 0
        ? DateTime.fromMillisecondsSinceEpoch(expire * 1000)
        : null;
    final config = configs[id] ?? entry;
    final value = gift(
      {...config, 'id': id},
      entry: entry,
      roomId: roomId,
      anchorUid: anchorUid,
      maxQuantity: count,
    );
    return LiveBagItem(
      bagId: bagId,
      giftId: id,
      name: value.name,
      quantity: count,
      gift: value,
      expiresAt: expires,
      available:
          bagId > 0 &&
          count > 0 &&
          value.sendable &&
          expire != null &&
          expire >= 0 &&
          (expires == null || expires.isAfter(now)),
    );
  }

  static List<LiveMedal> medals(Map<String, dynamic> data) => [
    for (final entry in [
      ...liveMaps(data['list']),
      ...liveMaps(data['special_list']),
    ])
      if (liveMap(entry['medal'] ?? entry['medal_info'] ?? entry)
          case final info)
        if (liveInt(info['medal_id']) case final int id)
          LiveMedal(
            medalId: id,
            targetUid: liveInt(info['target_id'] ?? info['target_uid']) ?? 0,
            name: info['medal_name']?.toString() ?? '',
            level: liveInt(info['level']) ?? 0,
            wearing: liveBool(info['wearing_status']) == true,
            isLighted: liveBool(info['is_lighted']),
          ),
  ];

  static LiveFanStatus fanStatus(
    Map<String, dynamic> activated,
    Map<String, dynamic> relation,
    Map<int, Map<String, dynamic>> configs,
    int roomId,
    int anchorUid,
  ) {
    final club = liveMap(relation['fans_club_info']);
    final level = liveInt(activated['level'] ?? club['level']);
    LiveGift? ruleGift(Object? value, String discountKey) {
      final raw = liveMap(value);
      final discount = liveMap(raw[discountKey]);
      final use = (liveInt(discount['gift_id']) ?? 0) > 0 ? discount : raw;
      final id = liveInt(use['gift_id']);
      final price = liveInt(use['discount_price'] ?? use['price']);
      if (id == null || id <= 0 || price == null || price < 0) return null;
      return gift(
        {
          ...?configs[id],
          'id': id,
          'coin_type': 'gold',
          if (!configs.containsKey(id)) 'name': '粉丝团礼物 $id',
        },
        roomId: roomId,
        anchorUid: anchorUid,
        maxQuantity: 1,
        offeredPrice: price,
      );
    }

    return LiveFanStatus(
      joined: level == null ? null : level > 0,
      level: level,
      name: activated['medal_name']?.toString() ?? '',
      isLighted: liveBool(activated['is_lighted']),
      intimacy: liveInt(activated['intimacy']),
      nextIntimacy: liveInt(activated['next_intimacy']),
      joinGift: ruleGift(club['fans_club_gift'], 'discount_info'),
      lightGift: ruleGift(
        activated['fans_club_gift_info'],
        'gift_discount_info',
      ),
      tasks: [
        for (final task in liveMaps(activated['task_info']))
          LiveFanTask(
            name: (task['task_name'] ?? task['name'])?.toString() ?? '',
            description: (task['task_desc'] ?? task['desc'])?.toString() ?? '',
            jumpType: task['jump_type']?.toString() ?? '',
            completed: liveBool(task['is_complete'] ?? task['is_completed']),
          ),
      ],
    );
  }

  static LiveGuardStatus? guardStatus(Map<String, dynamic> data) {
    final active = liveInt(data['is_active']);
    if (active == null && data['guards_info'] is! List) return null;
    DateTime? expiry(Object? value) {
      final seconds = liveInt(value);
      return seconds != null && seconds > 0
          ? DateTime.fromMillisecondsSinceEpoch(seconds * 1000)
          : null;
    }

    return LiveGuardStatus(
      activeState: active,
      tiers: [
        for (final entry in liveMaps(data['guards_info']))
          if (liveInt(entry['guard_type']) case final int type)
            LiveGuardTier(
              type: type,
              status: liveInt(entry['guard_status']),
              expiresAt: expiry(entry['expired_time']),
            ),
      ],
    );
  }

  static LiveSuperChatConfig superChatConfig(Map<String, dynamic> data) =>
      LiveSuperChatConfig(
        title: data['title']?.toString() ?? '',
        message: data['msg']?.toString() ?? '',
        tiers: [
          for (final entry in liveMaps(data['price_configs']))
            if (liveInt(entry['id']) case final int id)
              if (liveInt(entry['price']) case final int price)
                if (id > 0 && price > 0)
                  LiveSuperChatTier(
                    id: id,
                    price: price,
                    maxLength: liveInt(entry['limit']),
                    visibleSeconds: liveInt(entry['second']),
                  ),
        ],
      );

  /// Code 0 alone is insufficient: identify sender, exact gift and recipient.
  static String? giftReceipt(
    Map<String, dynamic> data,
    LiveGiftConfirmation confirmation,
  ) {
    if (liveInt(data['uid']) != confirmation.accountUid) return null;
    final list = liveMaps(data['gift_list']);
    if (list.length != 1) return null;
    final item = list.single;
    final receiver = liveMap(item['receive_user_info']);
    final receiverInfo = liveMap(item['receiver_uinfo']);
    if (liveInt(item['gift_id']) != confirmation.gift.id ||
        liveInt(item['gift_num']) != confirmation.quantity ||
        liveInt(receiverInfo['uid'] ?? receiver['uid'] ?? receiver['ruid']) !=
            confirmation.anchorUid) {
      return null;
    }
    final wallet = liveMap(liveMap(item['extra'])['wallet']);
    final receipt = (wallet['order_id'] ?? item['tid'])?.toString();
    return receipt != null && receipt.isNotEmpty && receipt != '0'
        ? receipt
        : null;
  }
}
