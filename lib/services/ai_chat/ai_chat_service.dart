import 'dart:async';
import 'dart:convert';

import 'package:PiliPlus/services/logger.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;

/// AI 接口请求异常，toString 输出带实际请求地址的用户可读文案
class AiApiException implements Exception {
  final String url;
  final int? statusCode;
  final String detail;

  AiApiException({required this.url, this.statusCode, required this.detail});

  @override
  String toString() =>
      '请求 $url 出错'
      '${statusCode != null ? '（HTTP $statusCode）' : ''}'
      '：$detail';
}

class AiPromptTemplate {
  String name;
  String prompt;

  AiPromptTemplate({required this.name, required this.prompt});

  Map<String, dynamic> toJson() => {'name': name, 'prompt': prompt};

  factory AiPromptTemplate.fromJson(Map<String, dynamic> json) =>
      AiPromptTemplate(name: json['name'] ?? '', prompt: json['prompt'] ?? '');
}

/// 规范化流式增量：服务层负责协议字段提取与 `<think>` 解析，
/// 控制器只负责把两个增量追加到当前助手消息
class AiStreamDelta {
  const AiStreamDelta({this.contentDelta = '', this.reasoningDelta = ''});

  /// 回答正文增量
  final String contentDelta;

  /// 思考内容增量
  final String reasoningDelta;
}

/// 一次响应内思考内容的来源。以最先产生非空思考内容的来源为准，
/// 之后出现的另一种来源按未知/重复协议数据忽略
enum _ReasoningSource { field, thinkTag }

/// `<think>` / `</think>` 增量解析器。
///
/// 在一次 `streamChat` 请求内保持状态：开闭标签可能被拆在多个 chunk 中，
/// 不能对每个 chunk 独立做正则替换，尾部可能是标签前缀的文本必须暂存到
/// 下一个 chunk 再判断；流结束时未闭合的 `<think>` 视为思考内容。
class _ThinkTagParser {
  static const _openTag = '<think>';
  static const _closeTag = '</think>';

  String _buffer = '';
  bool _inThinking = false;

  /// 追加一个 SSE chunk，返回本次可下发的拆分结果
  ({String content, String reasoning}) add(String chunk) {
    if (chunk.isEmpty) return (content: '', reasoning: '');
    _buffer += chunk;
    return _drain(isEnd: false);
  }

  /// 流结束时冲刷暂存内容
  ({String content, String reasoning}) flush() => _drain(isEnd: true);

  ({String content, String reasoning}) _drain({required bool isEnd}) {
    final content = StringBuffer();
    final reasoning = StringBuffer();
    while (_buffer.isNotEmpty) {
      if (_inThinking) {
        final close = _buffer.indexOf(_closeTag);
        if (close >= 0) {
          reasoning.write(_buffer.substring(0, close));
          _buffer = _buffer.substring(close + _closeTag.length);
          _inThinking = false;
          continue;
        }
        final keep = isEnd ? 0 : _partialSuffix(_buffer, _closeTag);
        reasoning.write(
          keep == 0 ? _buffer : _buffer.substring(0, _buffer.length - keep),
        );
        _buffer = keep == 0 ? '' : _buffer.substring(_buffer.length - keep);
      } else {
        final open = _buffer.indexOf(_openTag);
        if (open >= 0) {
          content.write(_buffer.substring(0, open));
          _buffer = _buffer.substring(open + _openTag.length);
          _inThinking = true;
          continue;
        }
        final keep = isEnd ? 0 : _partialSuffix(_buffer, _openTag);
        content.write(
          keep == 0 ? _buffer : _buffer.substring(0, _buffer.length - keep),
        );
        _buffer = keep == 0 ? '' : _buffer.substring(_buffer.length - keep);
      }
      break;
    }
    return (content: content.toString(), reasoning: reasoning.toString());
  }

  /// [text] 末尾作为 [tag] 前缀（不含完整标签）的最长长度
  static int _partialSuffix(String text, String tag) {
    final max = text.length < tag.length - 1 ? text.length : tag.length - 1;
    for (var len = max; len > 0; len--) {
      if (text.endsWith(tag.substring(0, len))) return len;
    }
    return 0;
  }
}

class AiChatService {
  static Options _options({Duration? receiveTimeout}) {
    final apiKey = Pref.aiApiKey;
    return Options(
      headers: {
        'Content-Type': 'application/json',
        if (apiKey.isNotEmpty) 'Authorization': 'Bearer $apiKey',
      },
      receiveTimeout: receiveTimeout ?? const Duration(seconds: 60),
    );
  }

  /// 版本路径由用户填写，不自动拼接（各服务商版本段不同：
  /// /v1、/v1beta/openai、/api/v3 等），仅补全 /models、/chat/completions
  static String _baseUrl() {
    var url = Pref.aiApiUrl.trimRight();
    while (url.endsWith('/')) {
      url = url.substring(0, url.length - 1);
    }
    return url;
  }

  static String _snippet(String s, [int max = 300]) {
    s = s.trim();
    return s.length <= max ? s : '${s.substring(0, max)}…';
  }

  /// 提取错误响应的可读信息：优先 OpenAI 风格 error.message，否则返回原文
  static Future<String> _responseText(Response? response) async {
    dynamic data = response?.data;
    if (data is ResponseBody) {
      try {
        data = await utf8.decodeStream(data.stream);
      } catch (_) {
        return '';
      }
    }
    if (data is String) {
      try {
        data = jsonDecode(data);
      } catch (_) {
        return data;
      }
    }
    if (data is Map) {
      final err = data['error'];
      if (err is Map && err['message'] != null) {
        return err['message'].toString();
      }
      if (err != null) return err.toString();
      if (data['message'] != null) return data['message'].toString();
      return jsonEncode(data);
    }
    return data?.toString() ?? '';
  }

  /// 记录到错误日志（设置-关于-错误日志，受"启用日志"开关控制）后返回原异常
  static AiApiException _logged(AiApiException ex, [StackTrace? stackTrace]) {
    logger.e('AI 请求失败', error: ex, stackTrace: stackTrace);
    return ex;
  }

  /// 将 Dio 异常翻译为带实际请求地址的 [AiApiException]
  static Future<AiApiException> _requestError(String url, DioException e) async {
    String detail;
    if (e.type == DioExceptionType.badResponse) {
      detail = _snippet(await _responseText(e.response));
      if (detail.isEmpty) detail = '服务器返回错误';
    } else {
      detail = switch (e.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout =>
          '连接超时',
        DioExceptionType.badCertificate => '证书校验失败',
        DioExceptionType.cancel => '请求已取消',
        _ => '无法连接（${e.message ?? e.error ?? e.type.name}）',
      };
    }
    return _logged(
      AiApiException(
        url: url,
        statusCode: e.response?.statusCode,
        detail: detail,
      ),
      e.stackTrace,
    );
  }

  /// Fetch model list from {base}/models
  static Future<List<String>> fetchModels() async {
    final baseUrl = _baseUrl();
    if (baseUrl.isEmpty) throw Exception('请先配置 API 地址');
    final url = '$baseUrl/models';
    final Response res;
    try {
      res = await Dio().get(
        url,
        options: _options(receiveTimeout: const Duration(seconds: 30)),
      );
    } on DioException catch (e) {
      throw await _requestError(url, e);
    }
    final data = res.data;
    if (data is Map && data['data'] is List) {
      return (data['data'] as List)
          .map((e) => e['id']?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
    }
    throw _logged(AiApiException(
      url: url,
      statusCode: res.statusCode,
      detail: '响应不是模型列表，请检查接口地址与版本路径'
          '${data == null ? '' : '（${_snippet(data.toString(), 200)}）'}',
    ));
  }

  /// Stream chat completion from {base}/chat/completions
  ///
  /// 返回结构化增量流：`contentDelta` 为回答正文，`reasoningDelta` 为思考
  /// 内容（`reasoning_content` 字段或 `content` 中包裹的 `<think>`）
  static Stream<AiStreamDelta> streamChat({
    required List<Map<String, String>> messages,
    String? model,
    String? reasoningEffort,
  }) async* {
    final baseUrl = _baseUrl();
    if (baseUrl.isEmpty) throw Exception('请先配置 API 地址');
    final useModel = model ?? Pref.aiModel;
    if (useModel.isEmpty) throw Exception('请先选择模型');

    final url = '$baseUrl/chat/completions';
    final opts = _options(receiveTimeout: const Duration(minutes: 10))
      ..responseType = ResponseType.stream;
    final Response<ResponseBody> response;
    try {
      response = await Dio().post<ResponseBody>(
        url,
        data: jsonEncode({
          'model': useModel,
          'messages': messages,
          'stream': true,
          // 'default'（含旧值 'auto'）表示不干预服务商默认行为，不下发该字段
          if (reasoningEffort != null &&
              reasoningEffort.isNotEmpty &&
              reasoningEffort != 'default' &&
              reasoningEffort != 'auto')
            'reasoning_effort': reasoningEffort,
        }),
        options: opts,
      );
    } on DioException catch (e) {
      throw await _requestError(url, e);
    }

    final stream = response.data!.stream;

    // 记录是否出现过 SSE data 行：200 但响应不是 SSE（如填错地址时服务器
    // 返回 HTML 页面或完整 JSON）会静默产出空回复，需在流结束后报错
    var sawData = false;
    final nonSse = StringBuffer();
    final parser = _ThinkTagParser();
    _ReasoningSource? source;

    // 解析器记录本次响应第一个产生非空思考内容的来源，来源确定后只接受该来源，
    // 避免同一段内容被展示两次
    String? acceptReasoning(String text, _ReasoningSource from) {
      if (text.isEmpty) return null;
      if (source == null) {
        source = from;
      } else if (source != from) {
        return null;
      }
      return text;
    }

    await for (final line in stream
        .cast<List<int>>()
        .transform(utf8.decoder)
        .transform(const LineSplitter())) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;
      if (!trimmed.startsWith('data:')) {
        if (!sawData && nonSse.length < 300) nonSse.writeln(trimmed);
        continue;
      }
      sawData = true;
      final data = trimmed.replaceFirst('data:', '').trim();
      if (data == '[DONE]') {
        final split = parser.flush();
        final reasoning = acceptReasoning(
          split.reasoning,
          _ReasoningSource.thinkTag,
        );
        if (reasoning != null) {
          yield AiStreamDelta(reasoningDelta: reasoning);
        }
        if (split.content.isNotEmpty) {
          yield AiStreamDelta(contentDelta: split.content);
        }
        return;
      }
      if (data.isEmpty) continue;
      try {
        final json = jsonDecode(data) as Map<String, dynamic>;
        final choices = json['choices'] as List?;
        if (choices != null && choices.isNotEmpty) {
          final delta = choices[0]['delta'] as Map<String, dynamic>?;
          final content = delta?['content'] as String?;
          if (content != null && content.isNotEmpty) {
            // 思考标签必须剥离，不能混入正文
            final split = parser.add(content);
            final reasoning = acceptReasoning(
              split.reasoning,
              _ReasoningSource.thinkTag,
            );
            if (reasoning != null) {
              yield AiStreamDelta(reasoningDelta: reasoning);
            }
            if (split.content.isNotEmpty) {
              yield AiStreamDelta(contentDelta: split.content);
            }
          }
          final reasoningContent = delta?['reasoning_content'] as String?;
          if (reasoningContent != null) {
            final reasoning = acceptReasoning(
              reasoningContent,
              _ReasoningSource.field,
            );
            if (reasoning != null) {
              yield AiStreamDelta(reasoningDelta: reasoning);
            }
          }
        }
      } catch (e) {
        if (kDebugMode) debugPrint('SSE parse error: $e');
      }
    }

    // 没有 [DONE] 就断流时同样冲刷解析器暂存内容
    final split = parser.flush();
    final reasoning = acceptReasoning(
      split.reasoning,
      _ReasoningSource.thinkTag,
    );
    if (reasoning != null) {
      yield AiStreamDelta(reasoningDelta: reasoning);
    }
    if (split.content.isNotEmpty) {
      yield AiStreamDelta(contentDelta: split.content);
    }

    if (!sawData) {
      final contentType = response.headers.value(Headers.contentTypeHeader);
      throw _logged(AiApiException(
        url: url,
        statusCode: response.statusCode,
        detail: '未返回流式响应，请检查接口地址与版本路径'
            '${contentType == null ? '' : '（content-type: $contentType）'}'
            '${nonSse.isEmpty ? '' : '：${_snippet(nonSse.toString())}'}',
      ));
    }
  }

  // --- Template CRUD ---

  static final List<AiPromptTemplate> defaultTemplates = [
    AiPromptTemplate(
      name: '概貌总结',
      prompt: '请对这个视频内容进行概貌总结。考虑到视频可能较长，请避免过度省略。\n'
          '要求：\n'
          '1. 【核心主旨】用 1-2 句话精准概括视频的核心价值与主题。\n'
          '2. 【高光时刻】列出 3-5 个最具争议、最有趣或最重要的核心观点。\n'
          '3. 【时间线速览】按时间顺序，提供一个简明的目录式大纲，每个条目必须以时间戳 `[mm:ss]` 开头。\n'
          '4. 结构必须极其清晰，便于用户在 10 秒内判断是否值得观看全片。',
    ),
    AiPromptTemplate(
      name: '详细分析',
      prompt: '请对这个视频进行极具深度的拆解分析。请克服长文本的省略倾向，尽可能保留具体细节、案例和逻辑推演。\n'
          '要求：\n'
          '1. 【结构脉络】根据视频的话题转换，将其划分为几个清晰的章节，每个章节必须标明时间跨度（如 `[01:00] - [15:30]`）。\n'
          '2. 【深度提取】在每个章节下，详细阐述其核心观点、使用的论据（如有案例请务必写出）。\n'
          '3. 【内在逻辑】分析各章节之间的关联，说明主讲人是如何一步步推导结论的。\n'
          '4. 【精粹总结】在末尾给出该视频的最终结论或可执行的启示。\n'
          '注意：全程必须高频使用 `[mm:ss]` 时间戳进行锚定，以便我随时点击溯源。',
    ),
  ];

  static List<AiPromptTemplate> getTemplates() {
    final raw = Pref.aiPromptTemplates;
    if (raw.isEmpty) return defaultTemplates;
    try {
      final list = jsonDecode(raw) as List;
      var templates = list
          .map((e) => AiPromptTemplate.fromJson(e as Map<String, dynamic>))
          .toList();
      var changed = false;
      // Remove deprecated templates
      final beforeRemove = templates.length;
      templates.removeWhere((t) => t.name == '准备问答');
      if (templates.length != beforeRemove) changed = true;
      // Sync default templates: add missing, update changed content
      final defaultMap = {for (final t in defaultTemplates) t.name: t};
      for (var i = 0; i < templates.length; i++) {
        final defaultT = defaultMap[templates[i].name];
        if (defaultT != null && templates[i].prompt != defaultT.prompt) {
          templates[i] = defaultT;
          changed = true;
        }
      }
      final existingNames = templates.map((e) => e.name).toSet();
      for (final t in defaultTemplates) {
        if (!existingNames.contains(t.name)) {
          templates.add(t);
          changed = true;
        }
      }
      if (changed) saveTemplates(templates);
      return templates;
    } catch (_) {
      return defaultTemplates;
    }
  }

  static void saveTemplates(List<AiPromptTemplate> templates) {
    Pref.aiPromptTemplates = jsonEncode(templates.map((e) => e.toJson()).toList());
  }
}
