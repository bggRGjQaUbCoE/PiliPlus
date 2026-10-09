import 'dart:io';
import 'dart:math' show min;

import 'package:PiliPlus/models/common/video/cdn_type.dart';
import 'package:PiliPlus/utils/video_utils.dart';

const _mainlandServices = [
  CDNService.ali,
  CDNService.alib,
  CDNService.cos,
  CDNService.cosb,
  CDNService.hw,
  CDNService.hwb,
  CDNService.hw_08c,
  CDNService.hw_08h,
];

const _overseasServices = [
  CDNService.aliov,
  CDNService.cosov,
  CDNService.hwov,
  CDNService.hk_bcache,
];

final _mainlandHosts = {
  for (final e in CDNService.values)
    if (e.host != null && !isOverseasService(e)) e.host!,
};

bool isOverseasService(CDNService service) =>
    service == CDNService.akamai || _overseasServices.contains(service);

String _hostOf(String url) => Uri.tryParse(url)?.host.toLowerCase() ?? '';

/// 去掉节点后的签名地址
String _addressOf(String url) {
  final uri = Uri.tryParse(url);
  return uri == null ? '' : '${uri.path}?${uri.query}';
}

/// 带 HTTP 状态码的下载失败，用于区分节点拒绝（4xx）与节点不可达
class CdnHttpException extends HttpException {
  final int status;

  const CdnHttpException(this.status, super.message, {super.uri});
}

/// 节点封禁表，一个视频的所有清晰度与音频共用
///
/// 两次未返回任何字节即封禁。HTTP 4xx 表示节点拒绝了该签名地址，
/// 按成功记录判责：能服务其它地址的节点拒绝了某地址，封该地址；
/// 其它节点能服务的地址被某节点拒绝，封该节点；两者都未知则不计。
class CdnBanList {
  static const _limit = 2;
  final _emptyReplies = <String, int>{};
  final _goodNodes = <String>{};
  final _goodAddresses = <String>{};
  var _banned = <String>{};

  void _judge() {
    final strikes = <String, int>{};
    for (final entry in _emptyReplies.entries) {
      final parts = entry.key.split('\n');
      final node = parts[0];
      final address = parts[1];
      final refused = parts[2].isNotEmpty;
      final String blamed;
      if (!refused) {
        blamed = 'node:$node';
      } else if (_goodNodes.contains(node)) {
        blamed = _goodAddresses.contains(address)
            ? 'pair:$node $address'
            : 'address:$address';
      } else if (_goodAddresses.contains(address)) {
        blamed = 'node:$node';
      } else {
        continue;
      }
      strikes[blamed] = (strikes[blamed] ?? 0) + entry.value;
    }
    _banned = {
      for (final e in strikes.entries)
        if (e.value >= _limit) e.key,
    };
  }

  void record(String url, int receivedBytes, Object? error) {
    if (receivedBytes > 0) return;
    final node = _hostOf(url);
    if (node.isEmpty) return;
    final status = error is CdnHttpException ? error.status : 0;
    final refused = status >= 400 && status < 500 ? 'refused' : '';
    final key = '$node\n${_addressOf(url)}\n$refused';
    _emptyReplies[key] = (_emptyReplies[key] ?? 0) + 1;
    _judge();
  }

  void success(String url) {
    final node = _hostOf(url);
    final address = _addressOf(url);
    if (node.isEmpty ||
        (_goodNodes.contains(node) && _goodAddresses.contains(address))) {
      return;
    }
    _goodNodes.add(node);
    _goodAddresses.add(address);
    _judge();
  }

  bool allows(String url) =>
      !_banned.contains('node:${_hostOf(url)}') &&
      !_banned.contains('address:${_addressOf(url)}') &&
      !_banned.contains('pair:${_hostOf(url)} ${_addressOf(url)}');

  void reset() {
    _emptyReplies.clear();
    _goodNodes.clear();
    _goodAddresses.clear();
    _banned = {};
  }
}

class _Health {
  int failures = 0;
  int blockedUntil = 0;
  int lastSuccessAt = 0;
  double bps = 0;
}

/// 一路媒体流的候选节点与健康度
class CdnResolver {
  final List<String> _urls;
  final CdnBanList bans;
  final bool overseas;
  final _health = <String, _Health>{};
  int _cursor = 0;
  int _mediaRangeCount = 0;
  int _rangeCursor = 0;

  CdnResolver({
    required String selected,
    required Iterable<String> playUrls,
    required this.bans,
    required this.overseas,
  }) : _urls = _buildUrls(selected, playUrls, overseas);

  /// 用户选择的 CDN 优先，其次是清单里符合当前区域的原始地址，
  /// 最后是把原始地址换到各镜像节点得到的地址
  static List<String> _buildUrls(
    String selected,
    Iterable<String> playUrls,
    bool overseas,
  ) {
    final urls = <String>{selected};
    for (final url in playUrls) {
      final mainland = _mainlandHosts.contains(_hostOf(url));
      if (overseas ? !mainland : mainland) urls.add(url);
    }
    for (final service in overseas ? _overseasServices : _mainlandServices) {
      final url = VideoUtils.getCdnUrl(playUrls, defaultCDNService: service);
      if (_hostOf(url) == service.host) urls.add(url);
    }
    return urls.toList();
  }

  _Health _healthOf(String url) => _health.putIfAbsent(url, _Health.new);

  int get _now => DateTime.now().millisecondsSinceEpoch;

  bool allows(String url) => bans.allows(url);

  /// 未封禁的地址；若全部被封则照常使用
  List<String> urls() {
    final allowed = _urls.where(bans.allows).toList();
    return allowed.isEmpty ? List.of(_urls) : allowed;
  }

  List<String> _unblocked(Iterable<String> list) {
    final now = _now;
    return list.where((e) => _healthOf(e).blockedUntil <= now).toList();
  }

  int _bySpeed(String a, String b) {
    final ah = _healthOf(a);
    final bh = _healthOf(b);
    final cmp = (bh.lastSuccessAt > 0 ? 1 : 0) - (ah.lastSuccessAt > 0 ? 1 : 0);
    return cmp != 0 ? cmp : bh.bps.compareTo(ah.bps);
  }

  /// 轮转后的全部候选，第 [pieceIndex] 块从不同节点开始
  List<String> ordered(int pieceIndex) {
    final candidates = urls();
    var pool = _unblocked(candidates);
    if (pool.isEmpty) pool = candidates;
    if (pool.isEmpty) return [];
    final offset = (_cursor + pieceIndex) % pool.length;
    _cursor = (_cursor + 1) % pool.length;
    return [...pool.skip(offset), ...pool.take(offset)];
  }

  /// 一个分段优先使用的节点：首段用全部节点摸底，之后按速度取前三并轮转
  List<String> rangeCandidates() {
    final pool = _unblocked(urls())..sort(_bySpeed);
    if (pool.isEmpty) return urls();
    final width = min(_mediaRangeCount == 0 ? pool.length : 3, pool.length);
    final List<String> selected;
    final warmupRanges = overseas ? 4 : 1;
    if (_mediaRangeCount < warmupRanges) {
      selected = pool.take(width).toList();
      _rangeCursor = width % pool.length;
    } else {
      final offset = _rangeCursor % pool.length;
      selected = [
        ...pool.skip(offset),
        ...pool.take(offset),
      ].take(width).toList();
      _rangeCursor = (_rangeCursor + width) % pool.length;
    }
    _mediaRangeCount++;
    return selected;
  }

  /// 元数据（初始化段、索引）的候选：清单原始地址优先，最多 8 个
  List<String> startupCandidates(Iterable<String> playUrls) {
    final all = {...playUrls, ..._urls}.toList();
    final allowed = all.where(bans.allows).toList();
    return _unblocked(allowed.isEmpty ? all : allowed).take(8).toList();
  }

  /// 救援候选：按成功记录与速度排序的全部可用节点
  List<String> rescueCandidates() => _unblocked(urls())..sort(_bySpeed);

  void success(String url, double bps) {
    bans.success(url);
    final health = _healthOf(url);
    health
      ..failures = 0
      ..blockedUntil = 0
      ..lastSuccessAt = _now
      ..bps = health.bps > 0 ? health.bps * 0.65 + bps * 0.35 : bps;
  }

  void failure(String url, Object? error, int receivedBytes) {
    bans.record(url, receivedBytes, error);
    final health = _healthOf(url);
    final failures = health.failures + 1;
    health
      ..failures = failures
      ..blockedUntil = _now + min(60000, 3000 * (1 << min(failures, 4)));
  }
}
