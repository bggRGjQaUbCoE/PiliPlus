import 'dart:async';

import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// 视频标题/标签翻译服务。
/// 支持 OpenAI 兼容接口（DeepSeek、OpenAI、Moonshot 等）与 DeepL。
/// 通过 [version] 通知 UI 刷新已翻译的文本。
abstract final class TranslateService {
  /// 翻译版本号，新增翻译完成时自增，UI 据此刷新
  static final ValueNotifier<int> version = ValueNotifier(0);

  /// 内存缓存：原文 -> 译文
  static final Map<String, String> _cache = {};

  /// 持久化缓存的 key（存储于 localCache）
  static const String _cacheKey = 'translationCache';

  /// 正在翻译 / 排队中的文本，用于去重
  static final Set<String> _queue = {};

  /// 并发限制
  static int _running = 0;
  static const int _maxConcurrent = 3;
  static bool _loaded = false;

  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  static bool get enabled => Pref.translateEnable;
  static bool get isDeepL => Pref.translateProvider == 'deepl';

  /// 是否已配置可用
  static bool configured() {
    if (!enabled) return false;
    final base = Pref.translateApiBase.trim();
    final key = Pref.translateApiKey.trim();
    return base.isNotEmpty && key.isNotEmpty;
  }

  static void _ensureLoaded() {
    if (_loaded) return;
    _loaded = true;
    final cached = GStorage.localCache.get(_cacheKey);
    if (cached is Map) {
      _cache.addAll(
        cached.map((k, v) => MapEntry('$k', '$v')).cast<String, String>(),
      );
    }
  }

  static void _saveCache() {
    // 限制缓存条数，避免无限增长
    if (_cache.length > 3000) {
      final it = _cache.keys.iterator;
      var toRemove = _cache.length - 2000;
      while (it.moveNext() && toRemove > 0) {
        _cache.remove(it.current);
        toRemove--;
      }
    }
    GStorage.localCache.put(_cacheKey, _cache);
  }

  /// 判断是否需要翻译：包含拉丁字母，且不命中用户设定的「不用翻译的语言」
  static bool needsTranslate(String text) {
    if (text.isEmpty) return false;
    var hasLatin = false;
    var hasZh = false; // 简体/繁体中文
    var hasJa = false; // 日文假名
    var hasKo = false; // 韩文
    for (final code in text.runes) {
      if ((code >= 0x41 && code <= 0x5A) || (code >= 0x61 && code <= 0x7A)) {
        hasLatin = true;
      } else if ((code >= 0x3400 && code <= 0x4DBF) ||
          (code >= 0x4E00 && code <= 0x9FFF)) {
        hasZh = true;
      } else if ((code >= 0x3040 && code <= 0x30FF) ||
          (code >= 0x31F0 && code <= 0x31FF)) {
        hasJa = true;
      } else if ((code >= 0x1100 && code <= 0x11FF) ||
          (code >= 0xAC00 && code <= 0xD7A3)) {
        hasKo = true;
      }
    }
    if (!hasLatin) return false;
    final skip = Pref.translateSkipLangs;
    // 命中某个「不用翻译」的语言时跳过：按推荐流/详情页/标签传入的跳过集判断
    if (hasZh && skip.contains('zh')) return false;
    if (hasJa && skip.contains('ja')) return false;
    if (hasKo && skip.contains('ko')) return false;
    return true;
  }

  /// 供 UI 调用的同步入口：有译文返回译文，否则立即返回原文并触发异步翻译。
  /// [enabled] 用于按场景（推荐流/标签）开关门控。
  static String display(String text, {bool enabled = true}) {
    if (!enabled || !configured() || !needsTranslate(text)) return text;
    _ensureLoaded();
    final cached = _cache[text];
    if (cached != null) return cached;
    _enqueue(text);
    return text;
  }

  /// 当前是否已有译文（仅已缓存、不含排队中的）。
  /// 用于「显示原文」：若返回非空说明标题此刻确实被自动翻译了。
  static String? translatedIfAny(String text) {
    if (!configured() || !needsTranslate(text)) return null;
    _ensureLoaded();
    return _cache[text];
  }

  static void _enqueue(String text) {
    if (_queue.contains(text)) return;
    _queue.add(text);
    _pump();
  }

  static void _pump() {
    while (_running < _maxConcurrent && _queue.isNotEmpty) {
      final text = _queue.first;
      _queue.remove(text);
      _running++;
      unawaited(_runText(text));
    }
  }

  static Future<void> _runText(String text) async {
    try {
      final result = await _translate(text);
      if (result.isNotEmpty) {
        _cache[text] = result;
        _saveCache();
        version.value++;
      }
    } catch (e) {
      if (kDebugMode) debugPrint('翻译失败：$e');
    } finally {
      _running--;
      _pump();
    }
  }

  static Future<String> _translate(String text) {
    if (isDeepL) {
      return _translateDeepL(text);
    }
    return _translateOpenAI(text);
  }

  /// OpenAI 兼容接口：POST {base}/chat/completions
  static Future<String> _translateOpenAI(String text) async {
    final base = Pref.translateApiBase.trim();
    final endpoint = base.endsWith('chat/completions')
        ? base
        : '${base.replaceAll(RegExp(r'/+$'), '')}/chat/completions';
    final prompt = Pref.translateSystemPrompt.trim();
    final response = await _dio.post(
      endpoint,
      options: Options(
        headers: {
          'Authorization': 'Bearer ${Pref.translateApiKey.trim()}',
          'Content-Type': 'application/json',
        },
      ),
      data: {
        'model': Pref.translateModel.trim(),
        'temperature': 0.3,
        'messages': [
          {
            'role': 'system',
            'content': prompt.isEmpty
                ? '你是一个翻译助手。请把用户给出的视频标题或标签翻译成简体中文。'
                    '只输出翻译结果，不要解释、不要加引号、不要添加任何额外内容。'
                : prompt,
          },
          {'role': 'user', 'content': text},
        ],
      },
    );
    final data = response.data;
    return data?['choices']?[0]?['message']?['content']
            ?.toString()
            .trim() ??
        '';
  }

  /// DeepL：POST {base}/v2/translate
  static Future<String> _translateDeepL(String text) async {
    final base = Pref.translateApiBase.trim();
    final endpoint = base.endsWith('translate')
        ? base
        : '${base.replaceAll(RegExp(r'/+$'), '')}/v2/translate';
    final target = Pref.translateTargetLang.trim().isEmpty
        ? 'zh'
        : Pref.translateTargetLang.trim();
    final response = await _dio.post(
      endpoint,
      options: Options(
        headers: {
          'Authorization': 'DeepL-Auth-Key ${Pref.translateApiKey.trim()}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ),
      data: 'auth_key=${Uri.encodeQueryComponent(Pref.translateApiKey.trim())}'
          '&text=${Uri.encodeQueryComponent(text)}'
          '&target_lang=$target&source_lang=en',
    );
    return response.data?['translations']?[0]?['text']?.toString().trim() ?? '';
  }

  /// 手动翻译单个文本（详情页长按「翻译」入口用），不走缓存与队列
  static Future<String> translateOne(String text) async {
    if (!configured()) return '';
    try {
      return await _translate(text);
    } catch (e) {
      if (kDebugMode) debugPrint('翻译失败：$e');
      return '';
    }
  }

  /// 测试当前配置是否可用，返回测试句的译文
  static Future<String> testConfigured() async {
    const sample = 'Best action gameplay tips for beginners';
    if (!configured()) {
      return '';
    }
    return _translate(sample);
  }
}