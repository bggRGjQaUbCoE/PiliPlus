enum DanmakuAssistantKind {
  absolute('绝对屏蔽'),
  gentle('温和屏蔽'),
  dateStamp('日期打卡'),
  timeStamp('时间打卡'),
  peopleCount('人数刷屏'),
  shortCheckIn('短打卡');

  const DanmakuAssistantKind(this.label);

  final String label;
}

class DanmakuAssistantMatch {
  const DanmakuAssistantMatch({
    required this.kind,
    required this.reason,
    this.rule,
  });

  final DanmakuAssistantKind kind;
  final String reason;
  final String? rule;
}

class DanmakuAssistantRecord {
  const DanmakuAssistantRecord({
    required this.content,
    required this.progress,
    this.match,
  });

  final String content;
  final int progress;
  final DanmakuAssistantMatch? match;
}

class DanmakuAssistantConfig {
  const DanmakuAssistantConfig({
    required this.absoluteRules,
    required this.gentleRules,
    required this.blockDateStamps,
    required this.blockTimeStamps,
    required this.blockPeopleCounts,
    required this.blockShortCheckIns,
  });

  factory DanmakuAssistantConfig.defaults() => const DanmakuAssistantConfig(
    absoluteRules: [],
    gentleRules: [],
    blockDateStamps: false,
    blockTimeStamps: false,
    blockPeopleCounts: false,
    blockShortCheckIns: false,
  );

  factory DanmakuAssistantConfig.fromStorage(dynamic raw) {
    if (raw is! Map) {
      return DanmakuAssistantConfig.defaults();
    }

    List<String> readRules(String key, List<String> fallback) {
      final value = raw[key];
      if (value is! Iterable) return fallback;
      return value
          .whereType<String>()
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toSet()
          .toList(growable: false);
    }

    bool readBool(String key, bool fallback) {
      final value = raw[key];
      return value is bool ? value : fallback;
    }

    final defaults = DanmakuAssistantConfig.defaults();
    return DanmakuAssistantConfig(
      absoluteRules: readRules('absoluteRules', defaults.absoluteRules),
      gentleRules: readRules('gentleRules', defaults.gentleRules),
      blockDateStamps: readBool(
        'blockDateStamps',
        defaults.blockDateStamps,
      ),
      blockTimeStamps: readBool(
        'blockTimeStamps',
        defaults.blockTimeStamps,
      ),
      blockPeopleCounts: readBool(
        'blockPeopleCounts',
        defaults.blockPeopleCounts,
      ),
      blockShortCheckIns: readBool(
        'blockShortCheckIns',
        defaults.blockShortCheckIns,
      ),
    );
  }

  final List<String> absoluteRules;
  final List<String> gentleRules;
  final bool blockDateStamps;
  final bool blockTimeStamps;
  final bool blockPeopleCounts;
  final bool blockShortCheckIns;

  static final RegExp _dateStamp = RegExp(
    r'^(?:(?:20\d{2}\s*[年./-]\s*)?\d{1,2}\s*(?:月|[./-])\s*\d{1,2}\s*(?:日|号)?|20\d{2}\s*(?:年|[./-])\s*\d{1,2}\s*月?)(?:\s*(?:[01]?\d|2[0-3])\s*(?:[:时点]\s*[0-5]?\d\s*分?)?)?(?:\s+\d{1,7}\s*人)?(?:\s*(?:前来)?(?:打卡|签到|留名|考古|探访古迹|到此一游))?$',
    caseSensitive: false,
  );
  static final RegExp _timeStamp = RegExp(
    r'^(?:[01]?\d|2[0-3])\s*(?::|时|点)\s*[0-5]\d\s*分?(?:\s+\d{1,7}\s*人)?(?:\s*(?:打卡|签到|留名))?$',
    caseSensitive: false,
  );
  static final RegExp _peopleCount = RegExp(
    r'^\d{1,7}\s*人(?:\s*(?:打卡|签到|留名))?$',
    caseSensitive: false,
  );
  static final RegExp _shortCheckIn = RegExp(
    r'^(?:(?:20\d{2})\s*年?\s*)?(?:前来)?(?:打卡|签到|留名|考古|探访古迹|到此一游)$',
    caseSensitive: false,
  );

  DanmakuAssistantMatch? match(String content) {
    final normalized = content.trim();
    if (normalized.isEmpty) return null;

    for (final rule in absoluteRules) {
      final normalizedRule = rule.trim();
      if (normalizedRule.isNotEmpty && normalized.contains(normalizedRule)) {
        return DanmakuAssistantMatch(
          kind: DanmakuAssistantKind.absolute,
          reason: '绝对屏蔽：包含“$rule”',
          rule: rule,
        );
      }
    }

    for (final rule in gentleRules) {
      final normalizedRule = rule.trim();
      if (normalizedRule.isNotEmpty && normalized == normalizedRule) {
        return DanmakuAssistantMatch(
          kind: DanmakuAssistantKind.gentle,
          reason: '温和屏蔽：整条等于“$rule”',
          rule: rule,
        );
      }
    }

    if (blockDateStamps && _dateStamp.hasMatch(normalized)) {
      return const DanmakuAssistantMatch(
        kind: DanmakuAssistantKind.dateStamp,
        reason: '日期/日期打卡格式',
      );
    }
    if (blockTimeStamps && _timeStamp.hasMatch(normalized)) {
      return const DanmakuAssistantMatch(
        kind: DanmakuAssistantKind.timeStamp,
        reason: '时间打卡格式',
      );
    }
    if (blockPeopleCounts && _peopleCount.hasMatch(normalized)) {
      return const DanmakuAssistantMatch(
        kind: DanmakuAssistantKind.peopleCount,
        reason: '纯人数刷屏格式',
      );
    }
    if (blockShortCheckIns && _shortCheckIn.hasMatch(normalized)) {
      return const DanmakuAssistantMatch(
        kind: DanmakuAssistantKind.shortCheckIn,
        reason: '短打卡/考古格式',
      );
    }
    return null;
  }

  DanmakuAssistantConfig copyWith({
    List<String>? absoluteRules,
    List<String>? gentleRules,
    bool? blockDateStamps,
    bool? blockTimeStamps,
    bool? blockPeopleCounts,
    bool? blockShortCheckIns,
  }) => DanmakuAssistantConfig(
    absoluteRules: absoluteRules ?? this.absoluteRules,
    gentleRules: gentleRules ?? this.gentleRules,
    blockDateStamps: blockDateStamps ?? this.blockDateStamps,
    blockTimeStamps: blockTimeStamps ?? this.blockTimeStamps,
    blockPeopleCounts: blockPeopleCounts ?? this.blockPeopleCounts,
    blockShortCheckIns: blockShortCheckIns ?? this.blockShortCheckIns,
  );

  Map<String, Object> toStorage() => {
    'version': 1,
    'absoluteRules': absoluteRules,
    'gentleRules': gentleRules,
    'blockDateStamps': blockDateStamps,
    'blockTimeStamps': blockTimeStamps,
    'blockPeopleCounts': blockPeopleCounts,
    'blockShortCheckIns': blockShortCheckIns,
  };
}
