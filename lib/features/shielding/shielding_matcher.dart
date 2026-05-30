import 'shielding_models.dart';

abstract final class ShieldMatcher {
  static ShieldMatchResult match(
    ShieldCandidate candidate,
    ShieldRuleSet ruleSet,
  ) {
    if (!ruleSet.isScopeEnabled(candidate.scope)) {
      return ShieldMatchResult.visibleResult;
    }

    final errors = <ShieldMatchError>[];
    ShieldRule? allowedBy;
    ShieldRule? blockedBy;

    for (final rule in ruleSet.rules) {
      if (!rule.enabled || !_scopeMatches(rule.scope, candidate.scope)) {
        continue;
      }

      bool matched;
      try {
        matched = _matches(rule, candidate);
      } catch (e) {
        errors.add(ShieldMatchError(rule: rule, message: e.toString()));
        continue;
      }
      if (!matched) continue;

      if (rule.action == ShieldAction.allow) {
        allowedBy ??= rule;
      } else {
        blockedBy ??= rule;
      }
    }

    if (allowedBy != null) {
      return ShieldMatchResult(
        visible: true,
        allowedBy: allowedBy,
        blockedBy: blockedBy,
        errors: errors,
      );
    }

    return ShieldMatchResult(
      visible: blockedBy == null,
      blockedBy: blockedBy,
      errors: errors,
    );
  }

  static bool _scopeMatches(ShieldScope ruleScope, ShieldScope candidateScope) =>
      ruleScope == ShieldScope.both || ruleScope == candidateScope;

  static bool _matches(ShieldRule rule, ShieldCandidate candidate) {
    return switch (rule.matchMode) {
      ShieldMatchMode.exact => _exactMatches(rule, candidate),
      ShieldMatchMode.regex => _matchValues(rule, candidate).any(
        RegExp(rule.pattern, caseSensitive: false).hasMatch,
      ),
      ShieldMatchMode.token => candidate.tokens.any(
        (token) => token.toLowerCase() == rule.pattern.toLowerCase(),
      ),
    };
  }

  static bool _exactMatches(ShieldRule rule, ShieldCandidate candidate) {
    final pattern = rule.pattern.toLowerCase();
    final values = _matchValues(
      rule,
      candidate,
    ).map((value) => value.toLowerCase());
    if (rule.type == ShieldRuleType.keyword) {
      return values.any((value) => value.contains(pattern));
    }
    return values.any((value) => value == pattern);
  }

  static Iterable<String> _matchValues(
    ShieldRule rule,
    ShieldCandidate candidate,
  ) =>
      _valuesForRule(
        rule.type,
        candidate,
      ).where((value) => value.trim().isNotEmpty);

  static Iterable<String> _valuesForRule(
    ShieldRuleType type,
    ShieldCandidate candidate,
  ) sync* {
    switch (type) {
      case ShieldRuleType.keyword:
        yield ifNullEmpty(candidate.title);
        yield ifNullEmpty(candidate.body);
        yield ifNullEmpty(candidate.authorName);
      case ShieldRuleType.uid:
        yield ifNullEmpty(candidate.uid);
      case ShieldRuleType.category:
        yield ifNullEmpty(candidate.category);
      case ShieldRuleType.tag:
        yield* candidate.tags;
    }
  }
}

String ifNullEmpty(String? value) => value ?? '';
