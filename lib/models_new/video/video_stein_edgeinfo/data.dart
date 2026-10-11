import 'package:PiliPlus/models_new/video/video_stein_edgeinfo/edges.dart';
import 'package:PiliPlus/models_new/video/video_stein_edgeinfo/hidden_var.dart';
import 'package:PiliPlus/models_new/video/video_stein_edgeinfo/preload.dart';
import 'package:PiliPlus/models_new/video/video_stein_edgeinfo/story_item.dart';

/// 根节点：/x/stein/edgeinfo_v2 的 `data` 对象。
class EdgeInfoData {
  /// 视频模块（分P）标题
  String? title;

  /// 当前模块 id
  int? edgeId;

  /// 进度回溯信息（未登录仅有起始模块）
  List<StoryItem>? storyList;

  /// 当前模块信息
  Edges? edges;

  /// 预加载的分P
  Preload? preload;

  /// 变量列表（无变量时服务端可能不下发此项）
  List<HiddenVar>? hiddenVars;

  /// 是否为结束模块
  bool isLeaf;

  /// 禁止记录选择
  bool noTutorial;

  /// 禁止进度回溯
  bool noBacktracking;

  /// 禁止结尾评分
  bool noEvaluation;

  /// 原始 JSON（诊断用）
  final Map<String, dynamic>? raw;

  EdgeInfoData({
    this.title,
    this.edgeId,
    this.storyList,
    this.edges,
    this.preload,
    this.hiddenVars,
    this.isLeaf = false,
    this.noTutorial = false,
    this.noBacktracking = false,
    this.noEvaluation = false,
    this.raw,
  });

  /// 当前模块（分P）cid：优先取 story_list 中 is_current 项。
  int? get currentCid {
    for (final StoryItem item in storyList ?? const <StoryItem>[]) {
      if (item.isCurrent) {
        return item.cid;
      }
    }
    return null;
  }

  static bool _flag(dynamic v) => v is num ? v != 0 : false;

  factory EdgeInfoData.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return EdgeInfoData();
    }
    return EdgeInfoData(
      title: json['title'] is String ? json['title'] as String : null,
      edgeId: _asInt(json['edge_id']),
      storyList: _list(json['story_list'], StoryItem.fromJson),
      edges: json['edges'] is Map<String, dynamic>
          ? Edges.fromJson(json['edges'])
          : null,
      preload: json['preload'] is Map<String, dynamic>
          ? Preload.fromJson(json['preload'])
          : null,
      hiddenVars: _list(
        json['hidden_vars'],
        HiddenVar.fromJson,
      )?.where((HiddenVar v) => v.key.isNotEmpty).toList(),
      isLeaf: _flag(json['is_leaf']),
      noTutorial: _flag(json['no_tutorial']),
      noBacktracking: _flag(json['no_backtracking']),
      noEvaluation: _flag(json['no_evaluation']),
      raw: json,
    );
  }

  static int? _asInt(dynamic v) {
    if (v is int) {
      return v;
    }
    if (v is num) {
      return v.toInt();
    }
    if (v is String) {
      return int.tryParse(v) ?? double.tryParse(v)?.toInt();
    }
    return null;
  }

  static List<T>? _list<T>(dynamic list, T Function(dynamic) parse) {
    if (list is! List) {
      return null;
    }
    final List<T> result = <T>[];
    for (final dynamic item in list) {
      // 单个异常元素不导致整组失效。
      try {
        result.add(parse(item));
      } catch (_) {}
    }
    return result;
  }
}
