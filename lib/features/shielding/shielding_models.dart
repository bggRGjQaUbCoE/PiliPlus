enum ShieldRuleType {
  keyword,
  userKeyword,
  uid,
  category,
  tag,
}

enum ShieldMatchMode {
  exact,
  regex,
  token,
}

enum ShieldScope {
  recommendation,
  comment,
  both,
}

enum ShieldAction {
  block,
  allow,
}

enum ShieldRuleSource {
  manual,
  quickAction,
  imported,
}

class ShieldRule {
  const ShieldRule({
    required this.id,
    required this.type,
    required this.matchMode,
    required this.scope,
    required this.action,
    required this.pattern,
    required this.updatedAt,
    this.enabled = true,
    this.source = ShieldRuleSource.manual,
  });

  final String id;
  final ShieldRuleType type;
  final ShieldMatchMode matchMode;
  final ShieldScope scope;
  final ShieldAction action;
  final String pattern;
  final bool enabled;
  final DateTime updatedAt;
  final ShieldRuleSource source;

  ShieldRule copyWith({
    String? id,
    ShieldRuleType? type,
    ShieldMatchMode? matchMode,
    ShieldScope? scope,
    ShieldAction? action,
    String? pattern,
    bool? enabled,
    DateTime? updatedAt,
    ShieldRuleSource? source,
  }) => ShieldRule(
    id: id ?? this.id,
    type: type ?? this.type,
    matchMode: matchMode ?? this.matchMode,
    scope: scope ?? this.scope,
    action: action ?? this.action,
    pattern: pattern ?? this.pattern,
    enabled: enabled ?? this.enabled,
    updatedAt: updatedAt ?? this.updatedAt,
    source: source ?? this.source,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'type': type.name,
    'match_mode': matchMode.name,
    'scope': scope.name,
    'action': action.name,
    'pattern': pattern,
    'enabled': enabled,
    'updated_at': updatedAt.millisecondsSinceEpoch,
    'source': source.name,
  };

  factory ShieldRule.fromJson(Map<String, Object?> json) => ShieldRule(
    id: json._string('id'),
    type: _enumByName(ShieldRuleType.values, json._string('type')),
    matchMode: _enumByName(
      ShieldMatchMode.values,
      json._string('match_mode'),
    ),
    scope: _enumByName(ShieldScope.values, json._string('scope')),
    action: _enumByName(ShieldAction.values, json._string('action')),
    pattern: json._string('pattern'),
    enabled: json['enabled'] as bool? ?? true,
    updatedAt: DateTime.fromMillisecondsSinceEpoch(
      json._int('updated_at'),
    ),
    source: _enumByName(
      ShieldRuleSource.values,
      json['source']?.toString() ?? ShieldRuleSource.manual.name,
    ),
  );
}

class ShieldRuleSet {
  ShieldRuleSet({
    List<ShieldRule> rules = const [],
    this.globalEnabled = true,
    this.recommendationEnabled = true,
    this.commentEnabled = true,
    this.version = 1,
    this.lastLoadedAt,
    this.loadErrors = const [],
  }) : rules = List.unmodifiable(rules);

  factory ShieldRuleSet.fromJson(Map<String, Object?> json) {
    final rawRules = json['rules'];
    return ShieldRuleSet(
      rules: rawRules is List
          ? rawRules
                .whereType<Map>()
                .map(
                  (rule) => ShieldRule.fromJson(
                    rule.cast<String, Object?>(),
                  ),
                )
                .toList()
          : const [],
      globalEnabled: json['global_enabled'] as bool? ?? true,
      recommendationEnabled: json['recommendation_enabled'] as bool? ?? true,
      commentEnabled: json['comment_enabled'] as bool? ?? true,
      version: json['version'] as int? ?? 1,
      lastLoadedAt: json['last_loaded_at'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json._int('last_loaded_at')),
    );
  }

  factory ShieldRuleSet.disabledWithError(Object error) => ShieldRuleSet(
    globalEnabled: false,
    rules: const [],
    loadErrors: [error.toString()],
  );

  static ShieldRuleSet tryFromJson(Map<String, Object?> json) {
    try {
      return ShieldRuleSet.fromJson(json);
    } catch (e) {
      return ShieldRuleSet.disabledWithError(e);
    }
  }

  final List<ShieldRule> rules;
  final bool globalEnabled;
  final bool recommendationEnabled;
  final bool commentEnabled;
  final int version;
  final DateTime? lastLoadedAt;
  final List<String> loadErrors;

  bool isScopeEnabled(ShieldScope scope) {
    if (!globalEnabled) return false;
    return switch (scope) {
      ShieldScope.recommendation => recommendationEnabled,
      ShieldScope.comment => commentEnabled,
      ShieldScope.both => recommendationEnabled || commentEnabled,
    };
  }

  ShieldRuleSet copyWith({
    List<ShieldRule>? rules,
    bool? globalEnabled,
    bool? recommendationEnabled,
    bool? commentEnabled,
    int? version,
    DateTime? lastLoadedAt,
    List<String>? loadErrors,
  }) => ShieldRuleSet(
    rules: rules ?? this.rules,
    globalEnabled: globalEnabled ?? this.globalEnabled,
    recommendationEnabled: recommendationEnabled ?? this.recommendationEnabled,
    commentEnabled: commentEnabled ?? this.commentEnabled,
    version: version ?? this.version,
    lastLoadedAt: lastLoadedAt ?? this.lastLoadedAt,
    loadErrors: loadErrors ?? this.loadErrors,
  );

  Map<String, Object?> toJson() => {
    'version': version,
    'global_enabled': globalEnabled,
    'recommendation_enabled': recommendationEnabled,
    'comment_enabled': commentEnabled,
    'last_loaded_at': lastLoadedAt?.millisecondsSinceEpoch,
    'rules': rules.map((rule) => rule.toJson()).toList(),
  };
}

class ShieldCandidate {
  const ShieldCandidate({
    required this.scope,
    this.title,
    this.body,
    this.uid,
    this.authorName,
    this.authorTokens = const [],
    this.category,
    this.tags = const [],
    this.tokens = const [],
  });

  final ShieldScope scope;
  final String? title;
  final String? body;
  final String? uid;
  final String? authorName;
  final List<String> authorTokens;
  final String? category;
  final List<String> tags;
  final List<String> tokens;
}

class ShieldMatchResult {
  const ShieldMatchResult({
    required this.visible,
    this.blockedBy,
    this.allowedBy,
    this.errors = const [],
  });

  static const visibleResult = ShieldMatchResult(visible: true);

  final bool visible;
  final ShieldRule? blockedBy;
  final ShieldRule? allowedBy;
  final List<ShieldMatchError> errors;
}

class ShieldMatchError {
  const ShieldMatchError({
    required this.rule,
    required this.message,
  });

  final ShieldRule rule;
  final String message;
}

T _enumByName<T extends Enum>(List<T> values, String name) =>
    values.firstWhere((value) => value.name == name);

extension _JsonRead on Map<String, Object?> {
  String _string(String key) {
    final value = this[key];
    if (value is String) return value;
    throw FormatException('Invalid shielding string field: $key');
  }

  int _int(String key) {
    final value = this[key];
    if (value is int) return value;
    throw FormatException('Invalid shielding int field: $key');
  }
}
