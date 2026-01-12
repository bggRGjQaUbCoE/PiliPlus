import 'dart:async';
import 'dart:convert';

import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:dio/dio.dart';
import 'package:fixnum/fixnum.dart';

class AiSummaryService {
  static String? _baseUrl;
  static String? _apiKey;
  static String? _prompt;
  static String? _model;
  static int? _maxTokens;
  static String? _extraParams;

  static String get baseUrl =>
      _baseUrl ??
      GStorage.setting.get(SettingBoxKey.aiSummaryBaseUrl, defaultValue: '');

  static String get apiKey =>
      _apiKey ??
      GStorage.setting.get(SettingBoxKey.aiSummaryApiKey, defaultValue: '');

  static String get prompt =>
      _prompt ??
      GStorage.setting.get(SettingBoxKey.aiSummaryPrompt, defaultValue: '');

  static String get model =>
      _model ??
      GStorage.setting.get(SettingBoxKey.aiSummaryModel,
          defaultValue: 'deepseek-chat');

  static int get maxTokens =>
      _maxTokens ??
      GStorage.setting.get(SettingBoxKey.aiSummaryMaxTokens,
          defaultValue: 4000);

  static String get extraParams =>
      _extraParams ??
      GStorage.setting.get(SettingBoxKey.aiSummaryExtraParams, defaultValue: '');

  static set baseUrl(String value) {
    _baseUrl = value;
    GStorage.setting.put(SettingBoxKey.aiSummaryBaseUrl, value);
  }

  static set apiKey(String value) {
    _apiKey = value;
    GStorage.setting.put(SettingBoxKey.aiSummaryApiKey, value);
  }

  static set prompt(String value) {
    _prompt = value;
    GStorage.setting.put(SettingBoxKey.aiSummaryPrompt, value);
  }

  static set model(String value) {
    _model = value;
    GStorage.setting.put(SettingBoxKey.aiSummaryModel, value);
  }

  static set maxTokens(int value) {
    _maxTokens = value;
    GStorage.setting.put(SettingBoxKey.aiSummaryMaxTokens, value);
  }

  static set extraParams(String value) {
    _extraParams = value;
    GStorage.setting.put(SettingBoxKey.aiSummaryExtraParams, value);
  }

  static bool get isConfigured =>
      baseUrl.isNotEmpty && apiKey.isNotEmpty && apiKey.startsWith('sk-');

  /// Approximate token count (1 token ≈ 4 characters for English, ≈ 2 for Chinese)
  /// 
  /// This is a rough approximation and may not match actual tokenizer results,
  /// especially for mixed-language content. Uses 3 characters per token as a
  /// reasonable middle ground between English and Chinese text.
  static int estimateTokens(String text) {
    // Simple estimation: average between English (4 chars/token) and Chinese (2 chars/token)
    // Using 3 characters per token as a reasonable middle ground
    return (text.length / 3).ceil();
  }

  /// Parse extra parameters from JSON string
  /// Note: Critical parameters like 'model', 'messages', 'stream', and 'max_tokens'
  /// will be filtered out to prevent unexpected behavior
  /// 
  /// Accepts JSON with or without surrounding braces:
  /// - Valid: {"temperature": 1, "top_p": 0.9}
  /// - Valid: "temperature": 1, "top_p": 0.9
  /// 
  /// Returns empty map if parsing fails
  static Map<String, dynamic> parseExtraParams() {
    try {
      final params = extraParams.trim();
      if (params.isEmpty) return {};
      
      // Add braces if not present for convenience
      // This allows users to omit braces in the UI
      final jsonStr = params.startsWith('{') ? params : '{$params}';
      
      // Use proper JSON decoding
      final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
      
      // Remove critical parameters that should not be overridden
      decoded.remove('model');
      decoded.remove('messages');
      decoded.remove('stream');
      decoded.remove('max_tokens');
      
      return decoded;
    } catch (e) {
      // If JSON parsing fails, return empty map
      // The test connection will still work, just without extra params
      return {};
    }
  }

  /// Test API connection and configuration
  static Future<(bool, String)> testConnection() async {
    if (!isConfigured) {
      return (false, '请先配置 API Base URL 和 API Key');
    }

    try {
      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      final requestData = <String, dynamic>{
        'model': model,
        'messages': [
          {'role': 'user', 'content': 'Hello'},
        ],
      };

      // Add extra parameters first
      final extra = parseExtraParams();
      requestData.addAll(extra);
      
      // Set max_tokens last to ensure it cannot be overridden
      requestData['max_tokens'] = 10;

      final response = await dio.post(
        '$baseUrl/chat/completions',
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
        ),
        data: requestData,
      );

      if (response.statusCode == 200) {
        return (true, '连接成功');
      } else {
        return (false, '连接失败: ${response.statusCode}');
      }
    } catch (e) {
      return (false, '连接失败: $e');
    }
  }

  /// Fetch all sub-replies for a given reply
  static Future<List<Map<String, dynamic>>> fetchAllSubReplies({
    required int type,
    required Int64 oid,
    required Int64 rootRpid,
    required Function(double) onProgress,
  }) async {
    final List<Map<String, dynamic>> allData = [];
    int page = 1;
    const int pageSize = 20;
    int totalCount = 0;

    while (true) {
      try {
        final response = await Request().get(
          'https://api.bilibili.com/x/v2/reply/reply',
          queryParameters: {
            'type': type,
            'oid': oid.toInt(),
            'root': rootRpid.toInt(),
            'ps': pageSize,
            'pn': page,
          },
        );

        if (response.data['code'] != 0) {
          break;
        }

        final data = response.data['data'];

        // First page: extract root comment
        if (page == 1 && data['root'] != null) {
          final root = data['root'];
          allData.add({
            'user': '【楼主】${root['member']['uname']}',
            'content': root['content']['message']
                .toString()
                .replaceAll('\n', ' ')
                .trim(),
            'likes': root['like'],
          });
          totalCount = data['page']['count'] + 1;
        }

        if (data['replies'] == null || (data['replies'] as List).isEmpty) {
          break;
        }

        final replies = data['replies'] as List;
        for (final r in replies) {
          final content = r['content']['message']
              .toString()
              .replaceAll('\n', ' ')
              .trim();
          if (content.isEmpty) continue;

          allData.add({
            'user': r['member']['uname'],
            'content': content,
            'likes': r['like'],
          });
        }

        // Update progress (0-90%)
        if (totalCount > 0) {
          final progress = (allData.length / totalCount * 0.9).clamp(0.0, 0.9);
          onProgress(progress);
        }

        if (page == 1 && data['page'] != null) {
          totalCount = data['page']['count'] + 1;
        }

        if (allData.length >= totalCount) {
          break;
        }

        page++;
        await Future.delayed(const Duration(milliseconds: 500));
      } catch (e) {
        break;
      }
    }

    return allData;
  }

  /// Convert replies to CSV format
  static String repliesToCsv(List<Map<String, dynamic>> replies) {
    final buffer = StringBuffer();
    buffer.writeln('user,content,likes');

    for (final reply in replies) {
      final user = _escapeCsvField(reply['user'].toString());
      final content = _escapeCsvField(reply['content'].toString());
      final likes = reply['likes'].toString();
      buffer.writeln('$user,$content,$likes');
    }

    return buffer.toString();
  }

  static String _escapeCsvField(String field) {
    if (field.contains(',') || field.contains('"') || field.contains('\n')) {
      return '"${field.replaceAll('"', '""')}"';
    }
    return field;
  }

  /// Send summary request to AI API
  static Future<(bool, String)> summarizeReplies(
    String csvData,
    Function(double) onProgress,
  ) async {
    if (!isConfigured) {
      return (false, '请先配置 API Base URL 和 API Key');
    }

    try {
      onProgress(0.9); // Start AI processing phase

      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
        ),
      );
      
      // Build the full prompt with data
      final fullPrompt = '$prompt\n数据内容：\n$csvData';

      final requestData = <String, dynamic>{
        'model': model,
        'messages': [
          {'role': 'user', 'content': fullPrompt},
        ],
        'stream': false,
      };

      // Add extra parameters first
      final extra = parseExtraParams();
      requestData.addAll(extra);
      
      // Note: We don't set max_tokens here as the truncation is handled
      // by the _truncateRepliesToTokenLimit method before this call

      final response = await dio.post(
        '$baseUrl/chat/completions',
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
        ),
        data: requestData,
      );

      onProgress(1.0); // Complete

      if (response.statusCode == 200) {
        final result = response.data['choices'][0]['message']['content'];
        return (true, result.toString());
      } else {
        return (false, '请求失败: ${response.statusCode}');
      }
    } catch (e) {
      return (false, '请求失败: $e');
    }
  }

  /// Complete summary workflow
  static Future<(bool, String)> summarizeReply({
    required int type,
    required Int64 oid,
    required Int64 rootRpid,
    required Function(double) onProgress,
  }) async {
    try {
      // Step 1: Fetch replies (0-90%)
      final replies = await fetchAllSubReplies(
        type: type,
        oid: oid,
        rootRpid: rootRpid,
        onProgress: onProgress,
      );

      if (replies.isEmpty) {
        return (false, '没有获取到回复数据');
      }

      // Step 2: Truncate replies to fit within token limit
      final truncatedReplies = _truncateRepliesToTokenLimit(replies);

      // Step 3: Convert to CSV
      final csvData = repliesToCsv(truncatedReplies);

      // Step 4: Send to AI (90-100%)
      final (success, result) = await summarizeReplies(csvData, onProgress);

      return (success, result);
    } catch (e) {
      return (false, '总结失败: $e');
    }
  }

  /// Truncate replies to fit within token limit
  /// Removes replies from the end to stay within maxTokens
  static List<Map<String, dynamic>> _truncateRepliesToTokenLimit(
      List<Map<String, dynamic>> replies) {
    if (replies.isEmpty) return replies;

    // Always keep the first reply (root comment)
    if (replies.length == 1) return replies;

    // Calculate base prompt tokens (without CSV data)
    final basePromptTokens = estimateTokens(prompt);
    final csvHeaderTokens = estimateTokens('user,content,likes\n');
    
    // Reserve some tokens for the response
    const responseReserve = 500;
    final availableTokens = maxTokens - basePromptTokens - csvHeaderTokens - responseReserve;

    if (availableTokens <= 0) {
      // If no space, return only the root comment
      return [replies.first];
    }

    int currentTokens = 0;
    int lastValidIndex = 0;

    // Calculate how many replies we can include
    for (int i = 0; i < replies.length; i++) {
      final reply = replies[i];
      final user = _escapeCsvField(reply['user'].toString());
      final content = _escapeCsvField(reply['content'].toString());
      final likes = reply['likes'].toString();
      
      // Estimate CSV line with proper escaping: "user,content,likes\n"
      final csvLine = '$user,$content,$likes\n';
      final lineTokens = estimateTokens(csvLine);
      
      if (currentTokens + lineTokens <= availableTokens) {
        currentTokens += lineTokens;
        lastValidIndex = i;
      } else {
        // Can't fit this reply, stop here
        break;
      }
    }

    // Return replies up to and including lastValidIndex
    // This ensures we don't send incomplete replies
    return replies.sublist(0, lastValidIndex + 1);
  }
}
