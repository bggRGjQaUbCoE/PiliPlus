import 'dart:convert';

import 'package:PiliPlus/http/browser_ua.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;

/// CDN 节点列表（数据源自 CCB 项目，assets 快照保底，可手动刷新）。
/// 结构与上游 cdn.json 一致：{ "地区": ["host", ...] }
abstract final class CdnNodeStore {
  // 上游 region.json 的固定顺序，未知地区排在末尾
  static const regionOrder = [
    '北京',
    '上海',
    '广东',
    '深圳',
    '福建',
    '河北',
    '黑省',
    '河南',
    '湖北',
    '湖南',
    '江苏',
    '江西',
    '辽宁',
    '内蒙',
    '山东',
    '山西',
    '陕西',
    '四川',
    '重庆',
    '天津',
    '新疆',
    '浙江',
    '外建',
    '香港',
    '海外',
  ];

  static const _sources = [
    'https://cdn.jsdelivr.net/gh/Kanda-Akihito-Kun/ccb@main/data/cdn.json',
    'https://gh-proxy.com/https://raw.githubusercontent.com/Kanda-Akihito-Kun/ccb/main/data/cdn.json',
    'https://raw.githubusercontent.com/Kanda-Akihito-Kun/ccb/main/data/cdn.json',
  ];

  static Map<String, List<String>>? _nodes;
  static Future<Map<String, List<String>>>? _loading;

  static Map<String, List<String>>? get nodesOrNull => _nodes;

  static DateTime? get updateTime {
    final ts = GStorage.localCache.get(LocalCacheKey.cdnNodeListTime);
    return ts is int ? DateTime.fromMillisecondsSinceEpoch(ts) : null;
  }

  static Future<Map<String, List<String>>> load() => _loading ??= _load();

  static Future<Map<String, List<String>>> _load() async {
    final cached = GStorage.localCache.get(LocalCacheKey.cdnNodeList);
    if (cached is String) {
      try {
        final parsed = parseNodes(jsonDecode(cached));
        if (parsed != null) {
          return _nodes = parsed;
        }
      } catch (_) {}
    }
    final raw = await rootBundle.loadString('assets/cdn_nodes.json');
    return _nodes = parseNodes(jsonDecode(raw))!;
  }

  /// 多源回退拉取最新列表，校验通过才落缓存。返回 null 表示成功，否则为错误提示
  static Future<String?> refresh() async {
    // 拉取的是 GitHub 数据，不走带 B 站拦截器的 Request 单例
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        responseType: ResponseType.plain,
        headers: {'user-agent': BrowserUa.pc},
      ),
    );
    try {
      for (final url in _sources) {
        try {
          final res = await dio.get(url);
          final parsed = parseNodes(jsonDecode(res.data as String));
          if (parsed == null) {
            continue;
          }
          _nodes = parsed;
          await GStorage.localCache.put(
            LocalCacheKey.cdnNodeList,
            jsonEncode(parsed),
          );
          await GStorage.localCache.put(
            LocalCacheKey.cdnNodeListTime,
            DateTime.now().millisecondsSinceEpoch,
          );
          return null;
        } catch (_) {
          continue;
        }
      }
      return '更新失败，请检查网络后重试';
    } finally {
      dio.close(force: true);
    }
  }

  /// 解析并校验节点数据，非法条目丢弃；无有效数据返回 null
  static Map<String, List<String>>? parseNodes(dynamic json) {
    if (json is! Map) {
      return null;
    }
    final out = <String, List<String>>{};
    for (final entry in json.entries) {
      final region = entry.key;
      final value = entry.value;
      if (region is! String || region.isEmpty || value is! List) {
        continue;
      }
      final hosts = [
        for (final host in value)
          if (host is String && isValidNodeHost(host)) host,
      ];
      if (hosts.isNotEmpty) {
        out[region] = hosts;
      }
    }
    return out.isEmpty ? null : out;
  }

  static final _hostRegex = RegExp(r'^[\w-]+(?:\.[\w-]+)+$');

  // 远程数据只信任 B 站系媒体域，防上游列表被投毒后重定向流量
  static const _allowedSuffixes = [
    '.bilivideo.com',
    '.bilivideo.cn',
    '.akamaized.net',
  ];

  static bool isValidNodeHost(String host) {
    if (!_hostRegex.hasMatch(host)) {
      return false;
    }
    final lower = host.toLowerCase();
    return _allowedSuffixes.any(lower.endsWith);
  }

  static List<String> sortedRegions(Map<String, List<String>> nodes) {
    int order(String region) {
      final index = regionOrder.indexOf(region);
      return index == -1 ? regionOrder.length : index;
    }

    return nodes.keys.toList()..sort((a, b) => order(a).compareTo(order(b)));
  }

  static String? ispOf(String host) {
    if (host.contains('bcache')) return 'B站自建';
    if (host.contains('gotcha')) return '外建';
    if (host.contains('-ct-')) return '电信';
    if (host.contains('-cu-')) return '联通';
    if (host.contains('-cm-')) return '移动';
    if (host.contains('-cc-')) return '长城宽带';
    if (host.contains('-fx-')) return '方正宽带';
    if (host.contains('-gd-')) return '鹏博士';
    if (host.contains('-se-')) return '世纪互联';
    if (host.contains('-wasu-')) return '华数';
    return null;
  }

  /// 节点短标签，如 cn-sh-ct-01-01.bilivideo.com → 电信 01-01
  static String nodeTitleOf(String host) {
    final label = host.split('.').first;
    final isp = ispOf(host);
    if (isp == null) {
      return label;
    }
    final numbers = RegExp(r'(\d+(?:-\d+)*)$').firstMatch(label)?.group(1);
    return numbers == null ? '$isp $label' : '$isp $numbers';
  }

  /// 反查列表标注，如 上海·电信 01-01；列表未加载或不在列表中返回 null
  static String? labelOf(String host) {
    final nodes = _nodes;
    if (nodes == null) {
      load();
      return null;
    }
    for (final entry in nodes.entries) {
      if (entry.value.contains(host)) {
        return '${entry.key}·${nodeTitleOf(host)}';
      }
    }
    return null;
  }

  /// 该 host 所在地区，用于打开选择器时预选
  static String? regionOf(String host) {
    final nodes = _nodes;
    if (nodes == null) {
      return null;
    }
    for (final entry in nodes.entries) {
      if (entry.value.contains(host)) {
        return entry.key;
      }
    }
    return null;
  }
}
