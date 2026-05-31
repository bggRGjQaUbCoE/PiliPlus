import 'package:PiliPlus/utils/recommend_filter.dart';

import 'shielding_models.dart';

// =============================================================================
// ShieldMigrationCandidate — 旧过滤 → 新规则 的候选分析
// =============================================================================
//
// 遵守共同边界「只产候选分析，不得标 green」：
// - 每个 candidate 的 suggestedRule 始终为 null 或带 source=imported
// - applied / dismissed 默认均为 false，由用户/治理工人决策
// - toBeApplied() 封装「审核通过后创建」逻辑，不在此模块自动执行

/// 迁移可行性等级
enum MigrationFeasibility {
  /// 可直接映射为一条 ShieldRule（keyword regex, uid, 等）
  direct,

  /// 需要人工调整（如数值阈值得转为多条规则）
  partial,

  /// 无法映射到 ShieldRule 体系（如播放量阈值）
  unsupported,
}

/// 迁移候选分析结果
///
/// 每个分析项对应一条旧过滤设置，给出是否可迁移、建议规则、风险说明。
class ShieldMigrationCandidate {
  const ShieldMigrationCandidate({
    required this.oldSettingKey,
    required this.oldSettingValue,
    required this.feasibility,
    this.description,
    this.suggestedRule,
    this.notes,
    this.confidence,
  });

  /// 旧过滤设置的标识键（如 'banWordForRecommend'）
  final String oldSettingKey;

  /// 旧过滤设置的当前值（字符串化）
  final String oldSettingValue;

  /// 迁移可行性
  final MigrationFeasibility feasibility;

  /// 人类可读的说明
  final String? description;

  /// 建议的新规则（null = 无法直接映射）
  final ShieldRule? suggestedRule;

  /// 分析备注 / 风险提示
  final String? notes;

  /// 置信度 0.0–1.0
  final double? confidence;

  /// 标记为「可应用」— 只返回规则副本，不写入存储
  ShieldRule? toBeApplied() {
    if (feasibility == MigrationFeasibility.unsupported) return null;
    return suggestedRule;
  }
}

/// 旧过滤分析的汇总报告
class ShieldMigrationReport {
  const ShieldMigrationReport({
    required this.candidates,
    this.analyzedAt,
  });

  final List<ShieldMigrationCandidate> candidates;
  final DateTime? analyzedAt;

  int get directCount =>
      candidates.where((c) => c.feasibility == MigrationFeasibility.direct).length;

  int get partialCount =>
      candidates.where((c) => c.feasibility == MigrationFeasibility.partial).length;

  int get unsupportedCount =>
      candidates.where((c) => c.feasibility == MigrationFeasibility.unsupported).length;
}

// =============================================================================
// RecommendFilterAnalyzer — 分析 RecommendFilter 静态配置
// =============================================================================

abstract final class RecommendFilterAnalyzer {
  /// 分析当前 RecommendFilter 的静态字段，生成迁移候选分析报告
  static ShieldMigrationReport analyze() {
    final candidates = <ShieldMigrationCandidate>[];
    final now = DateTime.now();

    candidates.addAll(_analyzeBanWords(now));
    candidates.addAll(_analyzeDuration(now));
    candidates.addAll(_analyzePlayAndLike(now));
    candidates.add(_analyzeExemptFollowed());
    candidates.addAll(_analyzeTags());

    return ShieldMigrationReport(
      candidates: candidates,
      analyzedAt: now,
    );
  }

  /// 标题关键词过滤 → keyword+regex 规则候选
  ///
  /// RecommendFilter.rcmdRegExp 是一个 RegExp，其 pattern 来自
  /// SettingBoxKey.banWordForRecommend 的字符串。
  static List<ShieldMigrationCandidate> _analyzeBanWords(DateTime now) {
    final pattern = RecommendFilter.rcmdRegExp.pattern;
    if (pattern.isEmpty) {
      return [
        const ShieldMigrationCandidate(
          oldSettingKey: 'banWordForRecommend',
          oldSettingValue: '(empty)',
          feasibility: MigrationFeasibility.direct,
          description: '标题关键词过滤未启用',
          notes: '无迁移动作。如果未来启用，每条关键词可独立迁移为 keyword+exact 规则。',
          confidence: 0.0,
        ),
      ];
    }

    // 检查旧正则是否为简单的竖线分隔关键词（bilibili 常见格式 "word1|word2|word3"）
    final isSimplePipeSep = RegExp(r'^[a-zA-Z0-9\u4e00-\u9fff]+(\|[a-zA-Z0-9\u4e00-\u9fff]+)*$')
        .hasMatch(pattern);

    if (isSimplePipeSep) {
      // 可拆分为多条 keyword+exact 规则 ← 更精确、可独立管理
      final words = pattern.split('|').where((w) => w.trim().isNotEmpty);
      return words.map((word) {
        return ShieldMigrationCandidate(
          oldSettingKey: 'banWordForRecommend',
          oldSettingValue: pattern,
          feasibility: MigrationFeasibility.direct,
          description: '标题关键词「$word」',
          suggestedRule: ShieldRule(
            id: 'migration-banWord-$word-${now.millisecondsSinceEpoch}',
            type: ShieldRuleType.keyword,
            matchMode: ShieldMatchMode.exact,
            scope: ShieldScope.recommendation,
            action: ShieldAction.block,
            pattern: word.trim(),
            enabled: true,
            updatedAt: now,
            source: ShieldRuleSource.imported,
          ),
          notes: '从旧 banWordForRecommend 正则拆分。'
              '如旧正则含特殊字符（非纯 | 分隔），建议保留为单条 regex 规则。',
          confidence: 0.9,
        );
      }).toList();
    }

    // 复杂正则 → 保留为单条 regex 规则候选
    return [
      ShieldMigrationCandidate(
        oldSettingKey: 'banWordForRecommend',
        oldSettingValue: pattern,
        feasibility: MigrationFeasibility.direct,
        description: '标题关键词过滤（复杂正则）',
        suggestedRule: ShieldRule(
          id: 'migration-banWord-regex-${now.millisecondsSinceEpoch}',
          type: ShieldRuleType.keyword,
          matchMode: ShieldMatchMode.regex,
          scope: ShieldScope.recommendation,
          action: ShieldAction.block,
          pattern: pattern,
          enabled: true,
          updatedAt: now,
          source: ShieldRuleSource.imported,
        ),
        notes: '旧配置为正则表达式。ShieldRule 的 regex 模式直接兼容。'
            '建议验证正则是否仍有效。',
        confidence: 0.85,
      ),
    ];
  }

  /// 视频时长过滤 → 无直接映射，给出分析备注
  static List<ShieldMigrationCandidate> _analyzeDuration(DateTime now) {
    final minDuration = RecommendFilter.minDurationForRcmd;
    if (minDuration <= 0) {
      return [
        const ShieldMigrationCandidate(
          oldSettingKey: 'minDurationForRcmd',
          oldSettingValue: '0',
          feasibility: MigrationFeasibility.direct,
          description: '视频时长过滤未启用',
          notes: '无迁移动作。',
          confidence: 0.0,
        ),
      ];
    }

    return [
      ShieldMigrationCandidate(
        oldSettingKey: 'minDurationForRcmd',
        oldSettingValue: minDuration.toString(),
        feasibility: MigrationFeasibility.unsupported,
        description: '视频时长 ≥ ${minDuration}s',
        notes: 'ShieldRule 体系不支持数值阈值过滤（≤ N 秒屏蔽）。'
            '此功能保留在 RecommendFilter 中，暂不迁移。',
        confidence: 1.0,
      ),
    ];
  }

  /// 播放量 / 点赞率过滤 → 无直接映射
  static List<ShieldMigrationCandidate> _analyzePlayAndLike(DateTime now) {
    final candidates = <ShieldMigrationCandidate>[];

    final minPlay = RecommendFilter.minPlayForRcmd;
    candidates.add(
      minPlay > 0
          ? ShieldMigrationCandidate(
              oldSettingKey: 'minPlayForRcmd',
              oldSettingValue: minPlay.toString(),
              feasibility: MigrationFeasibility.unsupported,
              description: '播放量 ≥ $minPlay',
              notes: '数值阈值，无法映射到 ShieldRule。保留在 RecommendFilter。',
              confidence: 1.0,
            )
          : const ShieldMigrationCandidate(
              oldSettingKey: 'minPlayForRcmd',
              oldSettingValue: '0',
              feasibility: MigrationFeasibility.direct,
              description: '播放量过滤未启用',
              notes: '无迁移动作。',
              confidence: 0.0,
            ),
    );

    final minLikeRatio = RecommendFilter.minLikeRatioForRecommend;
    candidates.add(
      minLikeRatio > 0
          ? ShieldMigrationCandidate(
              oldSettingKey: 'minLikeRatioForRecommend',
              oldSettingValue: minLikeRatio.toString(),
              feasibility: MigrationFeasibility.unsupported,
              description: '点赞率 ≥ $minLikeRatio%',
              notes: '百分比阈值，无法映射到 ShieldRule。保留在 RecommendFilter。',
              confidence: 1.0,
            )
          : const ShieldMigrationCandidate(
              oldSettingKey: 'minLikeRatioForRecommend',
              oldSettingValue: '0',
              feasibility: MigrationFeasibility.direct,
              description: '点赞率过滤未启用',
              notes: '无迁移动作。',
              confidence: 0.0,
            ),
    );

    // exemptFilterForFollowed — 旧豁免标记
    final exempt = RecommendFilter.exemptFilterForFollowed;
    candidates.add(
      ShieldMigrationCandidate(
        oldSettingKey: 'exemptFilterForFollowed',
        oldSettingValue: exempt.toString(),
        feasibility: MigrationFeasibility.partial,
        description: '已关注UP豁免推荐过滤 = $exempt',
        notes: exempt
            ? '旧过滤跳过已关注UP。ShieldRule 体系暂不支持「已关注豁免」语义。'
                '如需要，可在 recommendation 过滤流程中额外检查 isFollowed。'
            : '未启用。',
        confidence: exempt ? 0.6 : 0.0,
      ),
    );

    return candidates;
  }

  /// applyFilterToRelatedVideos — 旧开关
  static ShieldMigrationCandidate _analyzeExemptFollowed() {
    final apply = RecommendFilter.applyFilterToRelatedVideos;
    return ShieldMigrationCandidate(
      oldSettingKey: 'applyFilterToRelatedVideos',
      oldSettingValue: apply.toString(),
      feasibility: MigrationFeasibility.partial,
      description: '过滤器也应用于相关视频 = $apply',
      notes: apply
          ? '此开关仅控制旧 RecommendFilter 是否在相关视频上运行。'
              'Phase 1 新屏蔽总是对相关视频生效（不受此开关影响），无需迁移。'
          : '未启用。',
      confidence: 0.9,
    );
  }

  /// 标签过滤 → 来自旧 RecommendFilter（无直接 tag 设置），
  /// 但 ShieldRuleType.tag 已就绪，可手动添加 tag 规则。
  /// 此处分析旧配置中是否暗示了 tag 屏蔽需求。
  static List<ShieldMigrationCandidate> _analyzeTags() {
    // RecommendFilter 没有 tag 过滤，但 banWordForRecommend 的某些词
    // 可能是 tag 关键词。我们不做猜测，仅报告 tag 能力已就绪。
    return [
      const ShieldMigrationCandidate(
        oldSettingKey: 'tag',
        oldSettingValue: '(not configured)',
        feasibility: MigrationFeasibility.direct,
        description: '标签屏蔽能力',
        suggestedRule: null, // 没有旧数据可映射
        notes: 'ShieldRuleType.tag 已就绪。'
            '旧 RecommendFilter 无 tag 设置，无需迁移。'
            '用户可通过 quickAction 或 manual 添加 tag 规则。',
        confidence: 1.0,
      ),
    ];
  }
}
