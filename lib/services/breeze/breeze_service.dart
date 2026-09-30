// Ported from BiliBreeze (https://github.com/PosvdM/bili-breeze) background.js.
// No relay server, registration, telemetry or remote configuration.
import 'dart:async';
import 'dart:io';

import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/member.dart';
import 'package:PiliPlus/services/breeze/breeze_rules.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:hive_ce/hive.dart';

abstract final class BreezeKey {
  // Behavior and lists live in the settings box, so they are exported with it.
  static const String enabled = 'breezeEnabled',
      dynamics = 'breezeDynamics',
      pinned = 'breezePinned',
      foldCategories = 'breezeFoldCategories',
      foldIncidental = 'breezeFoldIncidental',
      adThreshold = 'breezeAdThreshold',
      cautiousThreshold = 'breezeCautiousThreshold',
      autoCautious = 'breezeAutoCautious',
      ratioWindow = 'breezeRatioWindow',
      ratioThreshold = 'breezeRatioThreshold',
      whitelist = 'breezeWhitelist',
      enhancedList = 'breezeEnhancedList',
      autoCautionExcluded = 'breezeAutoCautionExcluded',
      provider = 'breezeProvider',
      apiUrl = 'breezeApiUrl',
      apiModel = 'breezeApiModel',
      apiProtocol = 'breezeApiProtocol',
      rulesPrompt = 'breezeRulesPrompt';

  /// Pre-release extra prompt appended to the built-in rules; migrated.
  static const String _legacyCustomPrompt = 'breezeCustomPrompt';

  /// Kept in its own box, never exported with the settings.
  static const String apiKey = 'apiKey';

  static const _serviceKeys = {
    provider,
    apiUrl,
    apiModel,
    apiProtocol,
    rulesPrompt,
  };
  static const _scopeKeys = {enabled, dynamics, pinned};
  static const _authorKeys = {enhancedList, autoCautionExcluded};
}

sealed class BreezeEvent {
  const BreezeEvent();
}

/// Everything needs checking again.
class BreezeSettingsChanged extends BreezeEvent {
  const BreezeSettingsChanged();
}

/// Only items of this author need their policy applied again.
class BreezeAuthorChanged extends BreezeEvent {
  final String uid;
  const BreezeAuthorChanged(this.uid);
}

class BreezeCancelled implements Exception {
  const BreezeCancelled();
}

/// The default [HttpOverrides] behavior, without the app's global changes.
class _StrictHttpOverrides extends HttpOverrides {}

abstract final class BreezeService {
  static const _cacheTtl = Duration(days: 30);
  static const _cacheLimit = 5000;
  static const _historyLimit = 5000;
  static const _listLimit = 500;

  static late final Box<dynamic> _secret;
  static late final Box<dynamic> _cache;
  static late final Box<dynamic> _history;

  static final _events = StreamController<BreezeEvent>.broadcast();
  static Stream<BreezeEvent> get events => _events.stream;

  static final _pending = <String, Future<BreezeResult>>{};
  static int _revision = 0;
  static int _cooldown = 0;
  static int _active = 0;
  static const _maxActive = 3;
  static final _waiting = <Completer<void>>[];
  static Future<void> _historyWrites = Future.value();

  static BreezeConfig? _config;

  /// Opens BiliBreeze's own boxes. Must not read [GStorage.setting]: it is
  /// opened in parallel and may not be ready yet.
  static Future<void> init() async {
    await Future.wait([
      Hive.openBox('breeze').then((res) => _secret = res),
      Hive.openBox(
        'breezeCache',
        compactionStrategy: (entries, deletedEntries) => deletedEntries > 50,
      ).then((res) => _cache = res),
      Hive.openBox(
        'breezeHistory',
        compactionStrategy: (entries, deletedEntries) => deletedEntries > 50,
      ).then((res) => _history = res),
    ]);
    final now = DateTime.now().millisecondsSinceEpoch;
    final expired = _cache.keys.where((k) {
      final e = _cache.get(k);
      return e is! Map || (e['expires'] as int? ?? 0) <= now;
    }).toList();
    if (expired.isNotEmpty) await _cache.deleteAll(expired);
  }

  // Keeps the meaning of an extra prompt from earlier test builds. Runs on
  // the first settings read, so it never races the settings box opening.
  static String _rulesPrompt(Box<dynamic> s) {
    final old = s.get(BreezeKey._legacyCustomPrompt);
    if (old is! String) {
      return normalizeBreezePrompt(s.get(BreezeKey.rulesPrompt));
    }
    var prompt = s.get(BreezeKey.rulesPrompt);
    if (old.trim().isNotEmpty && prompt == null) {
      prompt = normalizeBreezePrompt(
        '$breezeDefaultPrompt\n用户补充规则（与上文冲突时以此为准）：${old.trim()}',
      );
      s.put(BreezeKey.rulesPrompt, prompt);
    }
    s.delete(BreezeKey._legacyCustomPrompt);
    return normalizeBreezePrompt(prompt);
  }

  static List<Box<dynamic>> get boxes => [_secret, _cache, _history];

  static BreezeConfig get config => _config ??= _read();

  static List<BreezeAuthor> _authors(String key) =>
      ((GStorage.setting.get(key) as List?) ?? const [])
          .map(BreezeAuthor.fromJson)
          .nonNulls
          .toList();

  static BreezeConfig _read() {
    const d = BreezeConfig();
    final s = GStorage.setting;
    final providerIndex = s.get(BreezeKey.provider, defaultValue: 0) as int;
    final protocolIndex = s.get(BreezeKey.apiProtocol, defaultValue: 0) as int;
    return BreezeConfig(
      enabled: s.get(BreezeKey.enabled, defaultValue: d.enabled),
      dynamics: s.get(BreezeKey.dynamics, defaultValue: d.dynamics),
      pinned: s.get(BreezeKey.pinned, defaultValue: d.pinned),
      foldCategories:
          ((s.get(BreezeKey.foldCategories) as List?) ?? d.foldCategories)
              .whereType<String>()
              .where(breezeCategories.contains)
              .toList(),
      foldIncidental: s.get(
        BreezeKey.foldIncidental,
        defaultValue: d.foldIncidental,
      ),
      adThreshold: BreezeConfig.clampInt(
        s.get(BreezeKey.adThreshold),
        1,
        100,
        d.adThreshold,
      ),
      cautiousThreshold: BreezeConfig.clampInt(
        s.get(BreezeKey.cautiousThreshold),
        1,
        100,
        d.cautiousThreshold,
      ),
      autoCautious: s.get(BreezeKey.autoCautious, defaultValue: d.autoCautious),
      ratioWindow: BreezeConfig.clampInt(
        s.get(BreezeKey.ratioWindow),
        2,
        100,
        d.ratioWindow,
      ),
      ratioThreshold: BreezeConfig.clampInt(
        s.get(BreezeKey.ratioThreshold),
        1,
        100,
        d.ratioThreshold,
      ),
      whitelist: _authors(BreezeKey.whitelist),
      enhancedList: _authors(BreezeKey.enhancedList),
      autoCautionExcluded:
          ((s.get(BreezeKey.autoCautionExcluded) as List?) ?? const [])
              .map((e) => e.toString())
              .toList(),
      apiKey: _secret.get(BreezeKey.apiKey, defaultValue: '') as String,
      provider: BreezeProvider.values[providerIndex.clamp(0, 1)],
      apiUrl: s.get(BreezeKey.apiUrl, defaultValue: ''),
      apiModel: s.get(BreezeKey.apiModel, defaultValue: ''),
      apiProtocol: BreezeProtocol.values[protocolIndex.clamp(0, 1)],
      rulesPrompt: _rulesPrompt(s),
    );
  }

  /// Call after writing settings; notifies rendered items like the
  /// extension's storage.onChanged listener.
  static void onChanged(Iterable<String> keys, {Set<String>? authors}) {
    _config = null;
    final changed = keys.toSet();
    if (changed.every(BreezeKey._authorKeys.contains)) {
      if (authors == null) {
        _events.add(const BreezeSettingsChanged());
      } else {
        for (final uid in authors) {
          _events.add(BreezeAuthorChanged(uid));
        }
      }
      return;
    }
    if (changed.any(
      (k) =>
          k == BreezeKey.apiKey ||
          BreezeKey._serviceKeys.contains(k) ||
          BreezeKey._scopeKeys.contains(k),
    )) {
      _revision++;
      _pending.clear();
    }
    _cooldown = 0;
    _events.add(const BreezeSettingsChanged());
  }

  /// Call after the settings box was replaced (reset, import, WebDAV):
  /// drops the cached configuration, invalidates requests in flight and
  /// asks rendered items to check again.
  static void reload() {
    _invalidate();
    _events.add(const BreezeSettingsChanged());
  }

  // Tasks capture [_revision] when they start and check it right before each
  // write, so nothing started earlier is written afterwards.
  static void _invalidate() {
    _config = null;
    _revision++;
    _pending.clear();
    _cooldown = 0;
  }

  static int _replacing = 0;

  /// Runs [change], which replaces stored data (reset, import, WebDAV). Work
  /// started before it is invalidated at once, no detection starts while it
  /// runs, and rendered items check again when it is done.
  static Future<T> replaceData<T>(Future<T> Function() change) async {
    _replacing++;
    _invalidate();
    try {
      return await change();
    } finally {
      _replacing--;
      reload();
    }
  }

  /// Deletes the API key, cache and records, as part of resetting all data.
  static Future<void> clear() =>
      replaceData(() => Future.wait([for (final box in boxes) box.clear()]));

  static Future<void> put(String key, Object? value) async {
    await GStorage.setting.put(key, value);
    onChanged([key]);
  }

  static Future<void> saveApi({
    required String apiKey,
    required BreezeProvider provider,
    required String apiUrl,
    required String apiModel,
    required BreezeProtocol apiProtocol,
  }) async {
    var url = apiUrl.trim();
    if (provider == BreezeProvider.custom) {
      url = validateCustomEndpoint(url);
      if (apiModel.trim().isEmpty) {
        throw const BreezeException('请填写模型名称');
      }
    }
    await Future.wait([
      _secret.put(BreezeKey.apiKey, apiKey.trim()),
      GStorage.setting.putAll({
        BreezeKey.provider: provider.index,
        BreezeKey.apiUrl: url,
        BreezeKey.apiModel: apiModel.trim(),
        BreezeKey.apiProtocol: apiProtocol.index,
      }),
    ]);
    onChanged([BreezeKey.apiKey, ...BreezeKey._serviceKeys]);
  }

  static Future<void> clearApiKey() async {
    await _secret.delete(BreezeKey.apiKey);
    onChanged([BreezeKey.apiKey]);
  }

  // ---- author lists ----

  static bool inList(String key, String uid) =>
      (key == BreezeKey.whitelist ? config.whitelist : config.enhancedList).any(
        (e) => e.uid == uid,
      );

  static Future<T> _serialized<T>(Future<T> Function() task) {
    final next = _historyWrites.then((_) => task());
    _historyWrites = next.then<void>((_) {}, onError: (_) {});
    return next;
  }

  /// Adds or removes an author. Removing from the cautious list stops the
  /// auto mode from adding them back.
  static Future<void> setListed(
    String key,
    String uid, {
    required bool add,
    String name = '',
  }) => _serialized(() async {
    final entries = _authors(key)..removeWhere((e) => e.uid == uid);
    if (add) {
      entries.add(
        BreezeAuthor(uid: uid, name: name.trim(), source: 'manual'),
      );
    }
    final patch = <String, dynamic>{
      key: entries
          .skip(entries.length > _listLimit ? entries.length - _listLimit : 0)
          .map((e) => e.toJson())
          .toList(),
    };
    if (key == BreezeKey.enhancedList) {
      final excluded = config.autoCautionExcluded.toSet();
      add ? excluded.remove(uid) : excluded.add(uid);
      patch[BreezeKey.autoCautionExcluded] = excluded.toList();
    }
    await GStorage.setting.putAll(patch);
    onChanged(patch.keys, authors: key == BreezeKey.whitelist ? null : {uid});
  });

  static Future<void> renameListed(String key, String uid, String name) =>
      _serialized(() async {
        final entries = _authors(key);
        final index = entries.indexWhere((e) => e.uid == uid);
        // Do not resurrect an entry removed while its name was loading.
        if (index == -1) return;
        entries[index] = entries[index].copyWith(name: name);
        await GStorage.setting.put(
          key,
          entries.map((e) => e.toJson()).toList(),
        );
        _config = null;
      });

  /// Looks up a user's name by UID, falling back to local records.
  static Future<String> lookupName(String uid) async {
    final res = await MemberHttp.memberCardInfo(mid: int.parse(uid));
    if (res case Success(:final response)) {
      final name = response.card?.name;
      if (name != null && name.isNotEmpty) return name;
    }
    for (final r in _history.values) {
      if (r is Map && r['authorId'] == uid) return r['author'] as String;
    }
    throw const BreezeException('B站查询暂不可用或未找到用户，请稍后重试');
  }

  // ---- detection ----

  static Dio? _dio;

  // Separate from Request.dio: no bilibili cookies or account headers, and
  // certificates are always verified since the request carries the API key.
  static Dio get _client => _dio ??=
      Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 25),
            receiveTimeout: const Duration(seconds: 25),
            sendTimeout: const Duration(seconds: 25),
            followRedirects: false,
            validateStatus: (_) => true,
            responseType: ResponseType.json,
          ),
        )
        ..httpClientAdapter = IOHttpClientAdapter(
          createHttpClient: createHttpClient,
        );

  /// The app's [HttpOverrides.global] accepts any certificate in debug
  /// builds or with 忽略证书错误; this client carries the API key, so it
  /// bypasses the overrides and always verifies certificates.
  @visibleForTesting
  static HttpClient createHttpClient() {
    final client =
        HttpOverrides.runWithHttpOverrides(
            HttpClient.new,
            _StrictHttpOverrides(),
          )
          ..idleTimeout = const Duration(seconds: 15)
          ..badCertificateCallback = (cert, host, port) => false;
    if (Pref.enableSystemProxy) {
      final host = Pref.systemProxyHost;
      final port = int.tryParse(Pref.systemProxyPort);
      if (host.isNotEmpty && port != null) {
        client.findProxy = (_) => 'PROXY $host:$port';
      }
    }
    return client;
  }

  static Future<BreezeResult> _call(
    Map<String, dynamic> state,
    BreezeConfig config,
  ) async {
    final request = buildRequest(state, config);
    try {
      final response = await _client.post(
        request.endpoint,
        data: request.payload,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${config.apiKey.trim()}',
          },
        ),
      );
      if (statusError(response.statusCode ?? 0) case final error?) {
        throw error;
      }
      return parseResponse(response.data, request);
    } on DioException catch (e) {
      throw switch (e.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout ||
        DioExceptionType.transformTimeout => const BreezeException(
          'API 请求超时，请检查网络后重试',
          pause: true,
        ),
        DioExceptionType.badResponse ||
        DioExceptionType.badCertificate ||
        DioExceptionType.connectionError ||
        DioExceptionType.unknown => const BreezeException(
          '无法连接 API，请检查网络或代理',
          pause: true,
        ),
        DioExceptionType.cancel => const BreezeCancelled(),
      };
    }
  }

  /// Sends a harmless sample to check the API settings.
  static Future<void> test() {
    final c = config;
    if (!c.configured) throw const BreezeException('请先保存 API Key');
    return _call(
      sanitize(
        const BreezeRaw(
          kind: BreezeKind.pinned,
          text: '补充说明：视频第三分钟口误，正确年份是2024年。',
        ),
      ),
      c,
    );
  }

  static Future<void> _acquire(
    bool Function()? cancelled, {
    required bool prefetch,
  }) async {
    if (_active < _maxActive) {
      _active++;
      return;
    }
    // Prefetching leaves room in the queue for items already on screen.
    if (_waiting.length >= (prefetch ? 20 : 30)) {
      throw const BreezeException('待检测内容较多，请稍后重试', transient: true);
    }
    final completer = Completer<void>();
    _waiting.add(completer);
    await completer.future;
    if (cancelled?.call() ?? false) {
      _release();
      throw const BreezeCancelled();
    }
  }

  static void _release() {
    if (_waiting.isNotEmpty) {
      _waiting.removeAt(0).complete();
    } else {
      _active--;
    }
  }

  static BreezeResult? _cached(String key) {
    final entry = _cache.get(key);
    if (entry is! Map ||
        (entry['expires'] as int? ?? 0) <=
            DateTime.now().millisecondsSinceEpoch) {
      return null;
    }
    return BreezeResult.fromJson(entry['result']);
  }

  static Future<void> _store(String key, BreezeResult result) async {
    await _cache.put(key, {
      'result': result.toJson(),
      'expires': DateTime.now().add(_cacheTtl).millisecondsSinceEpoch,
    });
    if (_cache.length > _cacheLimit) {
      final keys = _cache.keys.toList()
        ..sort(
          (a, b) => ((_cache.get(a) as Map?)?['expires'] as int? ?? 0)
              .compareTo((_cache.get(b) as Map?)?['expires'] as int? ?? 0),
        );
      await _cache.deleteAll(keys.take(_cache.length - _cacheLimit));
    }
  }

  static Future<BreezeResult> _detect(
    BreezeRaw raw,
    bool Function()? cancelled, {
    bool prefetch = false,
  }) async {
    final state = sanitize(raw);
    // Capture before reading settings, so a change during the read is detected.
    final rev = _revision;
    final s = config;
    if (!s.kindEnabled(raw.kind)) {
      throw const BreezeException('此类检测已关闭');
    }
    if (localDecision(raw, state, s) case final local?) return local;
    if (!s.configured) throw const BreezeException('请先填写 API Key');
    if ((state['text'] as String).trim().isEmpty) {
      throw const BreezeException('没有可检测的文字');
    }
    final key = breezeCacheKey(state, s);
    if (_cached(key) case final cached?) return cached;
    if (_pending[key] case final pending?) {
      try {
        return (await pending).copy();
      } on BreezeCancelled {
        // Whoever started it went away; this caller still needs the result.
        if (cancelled?.call() ?? false) rethrow;
        if (identical(_pending[key], pending)) _pending.remove(key);
        return _detect(raw, cancelled, prefetch: prefetch);
      }
    }
    final request = () async {
      await _acquire(cancelled, prefetch: prefetch);
      try {
        if (rev != _revision) throw const BreezeException('设置已变更，请重试');
        if (DateTime.now().millisecondsSinceEpoch < _cooldown) {
          throw const BreezeException('接口暂不可用，已暂停请求一分钟', transient: true);
        }
        final result = await _call(state, s);
        if (rev != _revision) throw const BreezeException('设置已变更，请重试');
        await _store(key, result);
        return result;
      } on BreezeException catch (e) {
        if (rev == _revision && e.pause) {
          _cooldown = DateTime.now().millisecondsSinceEpoch + 60000;
        }
        rethrow;
      } finally {
        _release();
      }
    }();
    _pending[key] = request;
    try {
      return (await request).copy();
    } finally {
      if (identical(_pending[key], request)) _pending.remove(key);
    }
  }

  /// The result available without waiting: a local rule or a cached answer,
  /// with the current author policy applied. Lets items render folded
  /// right away instead of collapsing on screen.
  static BreezeResult? peek(BreezeRaw raw) {
    final s = config;
    if (!s.kindEnabled(raw.kind) || !s.configured) return null;
    final state = sanitize(raw);
    final result =
        localDecision(raw, state, s) ?? _cached(breezeCacheKey(state, s));
    if (result == null) return null;
    return applyPolicy(result, raw, s, _history.values.whereType<Map>());
  }

  /// Classifies loaded items before they scroll into view, so they are
  /// already folded when they appear, as the extension does off screen.
  static void prefetch(Iterable<BreezeRaw?> Function() items, BreezeKind kind) {
    final s = config;
    if (!s.kindEnabled(kind) || !s.configured) return;
    for (final raw in items()) {
      if (raw != null) {
        detect(raw, prefetch: true).ignore();
      }
    }
  }

  /// Classifies an item and applies the author policy.
  static Future<BreezeResult> detect(
    BreezeRaw raw, {
    bool Function()? cancelled,
    bool prefetch = false,
  }) async {
    if (_replacing > 0) {
      throw const BreezeException('设置已变更，请重试', transient: true);
    }
    final rev = _revision;
    final result = await _detect(raw, cancelled, prefetch: prefetch);
    // logDetection applies the author policy against the updated history.
    await _logDetection(raw, result, rev);
    if (rev != _revision) throw const BreezeException('设置已变更，请重试');
    return result;
  }

  static Future<void> _logDetection(
    BreezeRaw raw,
    BreezeResult result,
    int rev,
  ) {
    final author = raw.author.isEmpty
        ? '未知 UP 主'
        : raw.author.substring(0, raw.author.length.clamp(0, 80));
    final authorId = RegExp(r'^\d+$').hasMatch(raw.authorId)
        ? raw.authorId
        : '';
    final id = historyId(raw);
    return _serialized(() async {
      // Queued before a reset or import: skip. Checked again right before
      // each write, with no await in between.
      if (rev != _revision) return;
      final now = DateTime.now().millisecondsSinceEpoch;
      final old = _history.get(id) as Map?;
      final record = <String, dynamic>{
        'classificationVersion': breezeClassificationVersion,
        'id': id,
        'author': author,
        'authorId': authorId,
        'url': raw.url,
        'type': raw.kind.name,
        'giveawayType': result.giveawayType,
        'prob': result.prob,
        'rule': result.rule ?? 'category',
        'preview': raw.text.substring(0, raw.text.length.clamp(0, 160)),
        'firstSeen': old?['firstSeen'] ?? now,
        'lastSeen': now,
      };
      final rows = {
        for (final e in _history.values)
          if (e is Map) e['id']: e,
      }..[id] = record;
      var s = config;
      final qualifies = authorRatio(rows.values, authorId, s);
      final listed = s.enhancedList.any((v) => v.uid == authorId);
      // Only API-classified items may trigger it; whitelisted authors are
      // never auto-added.
      if (qualifies != null && !listed && result.rule == null) {
        if (rev != _revision) return;
        await GStorage.setting.put(BreezeKey.enhancedList, [
          ...s.enhancedList.map((e) => e.toJson()),
          BreezeAuthor(
            uid: authorId,
            name: author,
            source: 'auto',
            addedAt: now,
            sample: qualifies,
          ).toJson(),
        ]);
        onChanged([BreezeKey.enhancedList], authors: {authorId});
        await debugAfterAutoCaution?.call();
        s = config;
      }
      applyPolicy(result, raw, s, rows.values);
      record.addAll({
        'action': result.fold ? '折叠' : '放行',
        'kind': result.kind,
        'categories': result.categories,
        'enhanced': result.enhanced,
        'adThreshold': result.adThreshold,
        'autoCautious': result.autoCautious?.toJson(),
        'cautionStatus': result.cautionStatus,
        'cautionSample': result.cautionSample,
      });
      if (rev != _revision) return;
      await _history.put(id, record);
      if (_history.length > _historyLimit) {
        final sorted = _history.values.whereType<Map>().toList()
          ..sort(
            (a, b) => (a['lastSeen'] as int? ?? 0).compareTo(
              b['lastSeen'] as int? ?? 0,
            ),
          );
        await _history.deleteAll(
          sorted.take(_history.length - _historyLimit).map((e) => e['id']),
        );
      }
    });
  }

  static List<Map> get history =>
      _history.values.whereType<Map>().toList()..sort(
        (a, b) =>
            (b['lastSeen'] as int? ?? 0).compareTo(a['lastSeen'] as int? ?? 0),
      );

  static Stream<BoxEvent> watchHistory() => _history.watch();

  /// Awaited inside a record task after its settings write, so tests can
  /// reset data while the task is paused there.
  @visibleForTesting
  static Future<void> Function()? debugAfterAutoCaution;

  /// Holds the record queue until [gate] completes.
  @visibleForTesting
  static void debugHoldWrites(Future<void> gate) => _serialized(() => gate);
}
