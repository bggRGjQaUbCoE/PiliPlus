// Ported from BiliBreeze (https://github.com/PosvdM/bili-breeze) background.js.
// Pure logic without Flutter dependencies, so it can be unit tested.
import 'dart:convert';
import 'dart:math' show max, min;

import 'package:PiliPlus/services/breeze/breeze_prompts.dart';
import 'package:crypto/crypto.dart';

export 'package:PiliPlus/services/breeze/breeze_prompts.dart';

const breezeJevApi = 'https://api.typesafe.ai/v1/systemone';
const breezeCategories = ['ad', 'giveaway', 'recruitment', 'event'];
const breezeCategoryLabels = {
  'ad': '广告',
  'giveaway': '抽奖',
  'recruitment': '招聘',
  'event': '活动宣传',
  'organic': '普通内容',
};

enum BreezeKind { dynamic, pinned }

enum BreezeProvider { jev, custom }

enum BreezeProtocol { openai, jev }

class BreezeAuthor {
  final String uid;
  final String name;

  /// `manual` or `auto`
  final String source;
  final int? addedAt;
  final BreezeSample? sample;

  const BreezeAuthor({
    required this.uid,
    this.name = '',
    this.source = 'manual',
    this.addedAt,
    this.sample,
  });

  bool get isAuto => source == 'auto';

  BreezeAuthor copyWith({String? name}) => BreezeAuthor(
    uid: uid,
    name: name ?? this.name,
    source: source,
    addedAt: addedAt,
    sample: sample,
  );

  static BreezeAuthor? fromJson(Object? json) {
    if (json is! Map) return null;
    final uid = json['uid']?.toString() ?? '';
    if (!RegExp(r'^[0-9]+$').hasMatch(uid)) return null;
    return BreezeAuthor(
      uid: uid,
      name: json['name']?.toString() ?? '',
      source: json['source'] == 'auto' ? 'auto' : 'manual',
      addedAt: json['addedAt'] is int ? json['addedAt'] : null,
      sample: BreezeSample.fromJson(json['sample']),
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'name': name,
    'source': source,
    'addedAt': ?addedAt,
    'sample': ?sample?.toJson(),
  };
}

class BreezeSample {
  final int total;
  final int ads;

  const BreezeSample({required this.total, required this.ads});

  static BreezeSample? fromJson(Object? json) {
    if (json is! Map || json['total'] is! int || json['ads'] is! int) {
      return null;
    }
    return BreezeSample(total: json['total'], ads: json['ads']);
  }

  Map<String, dynamic> toJson() => {'total': total, 'ads': ads};
}

class BreezeConfig {
  final bool enabled;
  final bool dynamics;
  final bool pinned;
  final List<String> foldCategories;
  final bool foldIncidental;
  final int adThreshold;
  final int cautiousThreshold;
  final bool autoCautious;
  final int ratioWindow;
  final int ratioThreshold;
  final List<BreezeAuthor> whitelist;
  final List<BreezeAuthor> enhancedList;
  final List<String> autoCautionExcluded;
  final String apiKey;
  final BreezeProvider provider;
  final String apiUrl;
  final String apiModel;
  final BreezeProtocol apiProtocol;

  /// Edited classification rules; empty means [breezeDefaultPrompt].
  final String rulesPrompt;

  const BreezeConfig({
    this.enabled = true,
    this.dynamics = true,
    this.pinned = true,
    this.foldCategories = const ['ad', 'giveaway'],
    this.foldIncidental = false,
    this.adThreshold = 70,
    this.cautiousThreshold = 90,
    this.autoCautious = true,
    this.ratioWindow = 10,
    this.ratioThreshold = 40,
    this.whitelist = const [],
    this.enhancedList = const [],
    this.autoCautionExcluded = const [],
    this.apiKey = '',
    this.provider = BreezeProvider.jev,
    this.apiUrl = '',
    this.apiModel = '',
    this.apiProtocol = BreezeProtocol.openai,
    this.rulesPrompt = '',
  });

  static int clampInt(Object? value, int lo, int hi, int fallback) {
    final n = value is num ? value : num.tryParse(value?.toString() ?? '');
    if (n == null || !n.isFinite) return fallback;
    return min(hi, max(lo, n.round()));
  }

  bool get configured => apiKey.trim().isNotEmpty;

  bool kindEnabled(BreezeKind kind) =>
      enabled && (kind == BreezeKind.dynamic ? dynamics : pinned);
}

/// Content collected from the page, before sanitizing.
class BreezeRaw {
  final BreezeKind kind;
  final String text;
  final String? originalText;
  final String? forwardedText;
  final String title;
  final List<String> links;
  final String author;
  final String authorId;
  final String itemId;
  final String url;

  const BreezeRaw({
    required this.kind,
    required this.text,
    this.originalText,
    this.forwardedText,
    this.title = '',
    this.links = const [],
    this.author = '',
    this.authorId = '',
    this.itemId = '',
    this.url = '',
  });

  /// Identifies a rendered item; a change means it must be classified again.
  String get identity =>
      jsonEncode([kind.name, itemId, authorId, author, sanitize(this)]);
}

String _cut(String? value, int length) {
  final s = value ?? '';
  return s.length > length ? s.substring(0, length) : s;
}

/// The only fields sent to the API. Key order matches the extension, so
/// cache keys stay stable.
Map<String, dynamic> sanitize(BreezeRaw raw) => {
  'platform': 'bilibili',
  'kind': raw.kind.name,
  // Context for official and self-published works; the UID stays local.
  'author': _cut(raw.author.trim(), 80),
  'text': _cut(raw.text, 8000),
  if (raw.originalText != null || raw.forwardedText != null) ...{
    'originalText': _cut(raw.originalText, 8000),
    'forwardedText': _cut(raw.forwardedText, 8000),
  },
  'title': _cut(raw.title, 300),
  'links': raw.links.take(12).map((e) => _cut(e, 500)).toList(),
};

String sha256Hex(Object? value) =>
    sha256.convert(utf8.encode(jsonEncode(value))).toString();

String breezeCacheKey(Map<String, dynamic> state, BreezeConfig config) {
  // Store only a digest, result and expiry, never the source text or API key.
  final service = config.provider == BreezeProvider.custom
      ? [config.apiUrl, config.apiProtocol.name, config.apiModel]
      : [breezeJevApi, 'jev', 'jev-latest'];
  // Rule revisions invalidate old decisions; custom rules also have separate keys.
  return sha256Hex([
    breezeClassificationVersion,
    service,
    state,
    if (config.rulesPrompt.isNotEmpty) config.rulesPrompt,
  ]);
}

bool _validAuthorId(String id) => RegExp(r'^\d+$').hasMatch(id);

String historyId(BreezeRaw raw) {
  final author = _cut(raw.author.isEmpty ? '未知 UP 主' : raw.author, 80);
  final authorId = _validAuthorId(raw.authorId) ? _cut(raw.authorId, 30) : '';
  final identity = [
    raw.kind.name,
    authorId.isNotEmpty ? authorId : author,
    raw.itemId.isNotEmpty
        ? _cut(raw.itemId, 300)
        : [raw.kind == BreezeKind.pinned ? raw.url : '', sanitize(raw)],
  ];
  return sha256Hex(identity);
}

final _noGiveaway = RegExp(r'(?:不|没有|取消|并非|不是)抽奖');
final _giveawayAction = RegExp(r'转发|评论|关注|参与|奖品|送出|开奖');
final _giveawayDraw = RegExp(
  r'(?:转发|评论|关注)[\s\S]{0,60}(?:抽取|抽出|随机抽|抽[0-9一二三四五六七八九十百]+[位名人])',
);
final _giveawayPrize = RegExp(
  r'(?:抽取|抽出|随机抽)[\s\S]{0,30}(?:位|名)[\s\S]{0,30}(?:送|奖|获得)',
);

/// Requires an explicit lottery mechanism, not simply an opportunity or a prize.
bool isGiveaway(String text) {
  final t = text.replaceAll(RegExp(r'\s+'), '');
  if (_noGiveaway.hasMatch(t) && !t.contains('互动抽奖')) return false;
  if (t.contains('互动抽奖')) return true;
  return t.contains('抽奖') && _giveawayAction.hasMatch(t) ||
      _giveawayDraw.hasMatch(t) ||
      _giveawayPrize.hasMatch(t);
}

class BreezeResult {
  double prob;
  double recruitment;
  double event;
  List<String> categories;

  /// `primary`, `incidental` or `uncertain`; null without a giveaway.
  String? giveawayType;
  String kind;

  /// `whitelist` or `local` when decided without the API.
  String? rule;
  bool fold;
  bool enhanced = false;
  int? adThreshold;
  BreezeSample? autoCautious;
  String? cautionStatus;
  Map<String, int>? cautionSample;

  BreezeResult({
    required this.prob,
    this.recruitment = 0,
    this.event = 0,
    List<String>? categories,
    this.giveawayType,
    this.kind = 'organic',
    this.rule,
    this.fold = false,
  }) : categories = categories ?? [];

  BreezeResult copy() => BreezeResult.fromJson(toJson())!;

  static bool validProb(Object? n) =>
      n is num && n.isFinite && n >= 0 && n <= 1;

  static BreezeResult? fromJson(Object? json) {
    if (json is! Map || !validProb(json['prob'])) return null;
    final kind = json['kind'];
    if (kind is! String || !breezeCategoryLabels.containsKey(kind)) {
      return null;
    }
    return BreezeResult(
      prob: (json['prob'] as num).toDouble(),
      recruitment: (json['recruitment'] as num?)?.toDouble() ?? 0,
      event: (json['event'] as num?)?.toDouble() ?? 0,
      categories: (json['categories'] as List?)?.whereType<String>().toList(),
      giveawayType: json['giveawayType'] as String?,
      kind: kind,
      rule: json['rule'] as String?,
      fold: json['fold'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
    'prob': prob,
    'recruitment': recruitment,
    'event': event,
    'categories': categories,
    'giveawayType': ?giveawayType,
    'kind': kind,
    'rule': ?rule,
    'fold': fold,
  };
}

class BreezeException implements Exception {
  final String message;

  /// Service-wide failures pause all requests; a malformed answer does not.
  final bool pause;

  /// Temporary failure, worth checking again later.
  final bool transient;

  const BreezeException(
    this.message, {
    this.pause = false,
    this.transient = false,
  });

  bool get retry => pause || transient;

  @override
  String toString() => message;
}

/// Validates a custom endpoint; returns the normalized URL.
String validateCustomEndpoint(String value) {
  final url = Uri.tryParse(value.trim());
  if (url == null || !url.hasScheme || url.host.isEmpty) {
    throw const BreezeException('请输入完整的 HTTPS API 地址');
  }
  if (url.scheme != 'https' ||
      url.userInfo.isNotEmpty ||
      url.hasFragment ||
      url.hasQuery) {
    throw const BreezeException('API 地址须为 HTTPS，不能包含账号、查询参数或片段');
  }
  return url.toString();
}

class BreezeRequest {
  final String endpoint;
  final Map<String, dynamic> payload;
  final bool openai;
  final bool lottery;

  const BreezeRequest(this.endpoint, this.payload, this.openai, this.lottery);
}

BreezeRequest buildRequest(Map<String, dynamic> state, BreezeConfig config) {
  final custom = config.provider == BreezeProvider.custom;
  var endpoint = breezeJevApi;
  if (custom) {
    endpoint = validateCustomEndpoint(config.apiUrl);
    if (config.apiModel.trim().isEmpty) {
      throw const BreezeException('请填写模型名称');
    }
  }
  final openai = custom && config.apiProtocol == BreezeProtocol.openai;
  final lottery = isGiveaway(state['text'] as String);
  final payload = buildClassificationPayload(
    state,
    rulesPrompt: config.rulesPrompt,
    openai: openai,
    model: custom ? config.apiModel.trim() : 'jev-latest',
    lottery: lottery,
  );
  return BreezeRequest(endpoint, payload, openai, lottery);
}

/// Maps an HTTP status to the error shown to the user; null when OK.
BreezeException? statusError(int status) {
  if (status == 401 || status == 403) {
    return const BreezeException('API Key 无效或权限不足，请检查设置', pause: true);
  }
  if (status == 429) {
    return const BreezeException('API 请求限流或额度不足，请稍后重试', pause: true);
  }
  if (status >= 500) {
    return BreezeException('API 服务暂不可用（HTTP $status）', pause: true);
  }
  if (status < 200 || status >= 300) {
    return BreezeException('API 请求失败（HTTP $status）');
  }
  return null;
}

final _fenceStart = RegExp(r'^```(?:json)?\s*', caseSensitive: false);
final _fenceEnd = RegExp(r'\s*```$');

BreezeResult parseResponse(Object? data, BreezeRequest request) {
  Object? get(Object? map, List<String> path) {
    for (final key in path) {
      if (map is! Map) return null;
      map = map[key];
    }
    return map;
  }

  final Object? prob, recruitment, eventValue, primary, incidental;
  if (request.openai) {
    Object? parsed;
    try {
      final choices = get(data, ['choices']);
      final content = choices is List && choices.isNotEmpty
          ? get(choices.first, ['message', 'content'])
          : null;
      parsed = jsonDecode(
        (content?.toString() ?? '')
            .trim()
            .replaceFirst(_fenceStart, '')
            .replaceFirst(_fenceEnd, ''),
      );
    } catch (_) {
      throw const BreezeException('API 返回内容不是有效 JSON，未进行标注或折叠');
    }
    prob = get(parsed, ['ad_prob']);
    recruitment = get(parsed, ['recruitment_prob']);
    eventValue = get(parsed, ['event_prob']);
    primary = get(parsed, ['giveaway_primary_prob']);
    incidental = get(parsed, ['giveaway_incidental_prob']);
  } else {
    prob = get(data, ['answers', 'is_ad', 'noul']);
    recruitment = get(data, ['answers', 'is_recruitment', 'noul']);
    eventValue = get(data, ['answers', 'is_event', 'noul']);
    primary = get(data, ['answers', 'giveaway_primary', 'noul']);
    incidental = get(data, ['answers', 'giveaway_incidental', 'noul']);
  }
  if (!BreezeResult.validProb(prob) || !BreezeResult.validProb(recruitment)) {
    throw const BreezeException('API 概率格式异常，未折叠内容');
  }
  final adProb = (prob as num).toDouble();
  final recruitmentProb = (recruitment as num).toDouble();
  final event = BreezeResult.validProb(eventValue)
      ? (eventValue as num).toDouble()
      : 0.0;
  final categories = <String>[
    if (adProb >= 0.6) 'ad',
    if (recruitmentProb >= 0.6) 'recruitment',
  ];
  final lottery = request.lottery;
  String? giveawayType;
  if (lottery) {
    if (BreezeResult.validProb(primary) && BreezeResult.validProb(incidental)) {
      final p = (primary as num).toDouble();
      final i = (incidental as num).toDouble();
      giveawayType = p >= .8 && i < .8
          ? 'primary'
          : i >= .8 && p < .8
          ? 'incidental'
          : 'uncertain';
    } else {
      giveawayType = 'uncertain';
    }
    if (giveawayType != 'uncertain') categories.add('giveaway');
  }
  return BreezeResult(
    prob: adProb,
    recruitment: recruitmentProb,
    event: event,
    categories: categories,
    giveawayType: giveawayType,
    kind: categories.firstOrNull ?? 'organic',
  );
}

/// Recent API-classified dynamics of an author, newest first.
List<Map> authorSample(Iterable<Map> history, String uid, BreezeConfig c) {
  final rows =
      history
          .where(
            (r) =>
                r['authorId'] == uid &&
                r['type'] == 'dynamic' &&
                r['rule'] == 'category' &&
                r['classificationVersion'] == breezeClassificationVersion &&
                BreezeResult.validProb(r['prob']),
          )
          .toList()
        ..sort((a, b) {
          final t = ((b['firstSeen'] as int?) ?? 0).compareTo(
            (a['firstSeen'] as int?) ?? 0,
          );
          return t != 0 ? t : '${b['id']}'.compareTo('${a['id']}');
        });
  return rows.take(c.ratioWindow).toList();
}

int _countAds(List<Map> rows, BreezeConfig c) =>
    rows.where((r) => (r['prob'] as num) >= c.adThreshold / 100).length;

BreezeSample? authorRatio(Iterable<Map> history, String uid, BreezeConfig c) {
  if (!c.autoCautious ||
      c.autoCautionExcluded.contains(uid) ||
      !_validAuthorId(uid)) {
    return null;
  }
  final rows = authorSample(history, uid, c);
  final ads = _countAds(rows, c);
  return rows.length == c.ratioWindow &&
          ads / rows.length >= c.ratioThreshold / 100
      ? BreezeSample(total: rows.length, ads: ads)
      : null;
}

BreezeResult applyPolicy(
  BreezeResult result,
  BreezeRaw raw,
  BreezeConfig config,
  Iterable<Map> history,
) {
  if (result.rule != null) return result;
  final categories = result.categories
      .where((k) => k != 'ad' && k != 'event')
      .toList();
  if (result.prob >= config.adThreshold / 100) categories.insert(0, 'ad');
  if (result.event >= .7) categories.add('event');
  result.categories = categories.toSet().toList();
  final uid = raw.authorId;
  final listed = config.enhancedList.where((v) => v.uid == uid);
  final manual = listed.isNotEmpty;
  result.autoCautious = listed.where((v) => v.isAuto).firstOrNull?.sample;
  final sample = authorSample(history, uid, config);
  result.cautionStatus = uid.isEmpty
      ? 'missing_uid'
      : result.autoCautious != null
      ? 'active'
      : !config.autoCautious
      ? 'disabled'
      : sample.length < config.ratioWindow
      ? 'collecting'
      : 'inactive';
  result.cautionSample = {
    'total': sample.length,
    'required': config.ratioWindow,
    'ads': _countAds(sample, config),
    'trigger': config.ratioThreshold,
  };
  result.enhanced = manual || result.autoCautious != null;
  final threshold = result.enhanced
      ? max(config.adThreshold, config.cautiousThreshold)
      : config.adThreshold;
  result.adThreshold = threshold;
  final matched = result.categories.where(
    (k) =>
        config.foldCategories.contains(k) &&
        (k != 'ad' || result.prob >= threshold / 100) &&
        (k != 'giveaway' ||
            result.giveawayType == 'primary' ||
            result.giveawayType == 'incidental' && config.foldIncidental),
  );
  result.fold = matched.isNotEmpty;
  result.kind =
      matched.firstOrNull ?? result.categories.firstOrNull ?? 'organic';
  return result;
}

/// Decides without the API when possible; null means the API is needed.
BreezeResult? localDecision(
  BreezeRaw raw,
  Map<String, dynamic> state,
  BreezeConfig config,
) {
  if (config.whitelist.any((v) => v.uid == raw.authorId)) {
    return BreezeResult(prob: 1, rule: 'whitelist');
  }
  final needsGiveaway =
      isGiveaway(state['text'] as String) &&
      config.foldCategories.contains('giveaway');
  if (needsGiveaway && !config.configured) {
    return BreezeResult(prob: 0, rule: 'local', giveawayType: 'uncertain');
  }
  if (!needsGiveaway &&
      !config.foldCategories.any(
        (k) => k == 'ad' || k == 'recruitment' || k == 'event',
      )) {
    return BreezeResult(prob: 0, rule: 'local');
  }
  return null;
}

String foldLabel(BreezeRaw raw, BreezeResult data) {
  final confidence = data.kind == 'ad'
      ? ' · ${(data.prob * 100).round()}%'
      : '';
  final label = data.kind == 'giveaway' && data.giveawayType == 'incidental'
      ? '附带抽奖'
      : breezeCategoryLabels[data.kind];
  final author = raw.author.isEmpty ? '未知 UP 主' : raw.author;
  return '$author · $label$confidence';
}
