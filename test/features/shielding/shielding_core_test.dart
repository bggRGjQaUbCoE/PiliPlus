import 'package:PiliPlus/features/shielding/shielding.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ShieldMatcher', () {
    test('keyword exact block matches literal text contained in title', () {
      final result = ShieldMatcher.match(
        const ShieldCandidate(
          scope: ShieldScope.recommendation,
          title: '猫咪睡觉合集',
        ),
        ShieldRuleSet(
          rules: [
            _rule(
              type: ShieldRuleType.keyword,
              pattern: '睡觉',
              scope: ShieldScope.recommendation,
            ),
          ],
        ),
      );

      expect(result.visible, isFalse);
      expect(result.blockedBy?.pattern, '睡觉');
    });

    test('keyword exact is case-insensitive literal contains, not regex', () {
      final rules = ShieldRuleSet(
        rules: [
          _rule(type: ShieldRuleType.keyword, pattern: 'cat.*dog'),
        ],
      );

      expect(
        ShieldMatcher.match(
          const ShieldCandidate(
            scope: ShieldScope.recommendation,
            title: 'prefix CAT.*DOG suffix',
          ),
          rules,
        ).visible,
        isFalse,
      );
      expect(
        ShieldMatcher.match(
          const ShieldCandidate(
            scope: ShieldScope.recommendation,
            title: 'cat and dog',
          ),
          rules,
        ).visible,
        isTrue,
      );
    });

    test(
      'uid category and tag exact rules use equality instead of contains',
      () {
        final rules = ShieldRuleSet(
          rules: [
            _rule(type: ShieldRuleType.uid, pattern: '42'),
            _rule(type: ShieldRuleType.category, pattern: '游戏'),
            _rule(type: ShieldRuleType.tag, pattern: '攻略'),
          ],
        );

        expect(
          ShieldMatcher.match(
            const ShieldCandidate(scope: ShieldScope.comment, uid: '142'),
            rules,
          ).visible,
          isTrue,
        );
        expect(
          ShieldMatcher.match(
            const ShieldCandidate(
              scope: ShieldScope.recommendation,
              category: '单机游戏',
            ),
            rules,
          ).visible,
          isTrue,
        );
        expect(
          ShieldMatcher.match(
            const ShieldCandidate(
              scope: ShieldScope.recommendation,
              tags: ['攻略合集'],
            ),
            rules,
          ).visible,
          isTrue,
        );
      },
    );

    test('matches comment body, uid, category, and tag fields', () {
      final rules = ShieldRuleSet(
        rules: [
          _rule(type: ShieldRuleType.keyword, pattern: '剧透'),
          _rule(type: ShieldRuleType.uid, pattern: '42'),
          _rule(type: ShieldRuleType.category, pattern: '游戏'),
          _rule(type: ShieldRuleType.tag, pattern: '攻略'),
        ],
      );

      expect(
        ShieldMatcher.match(
          const ShieldCandidate(
            scope: ShieldScope.comment,
            body: '剧透',
          ),
          rules,
        ).visible,
        isFalse,
      );
      expect(
        ShieldMatcher.match(
          const ShieldCandidate(scope: ShieldScope.comment, uid: '42'),
          rules,
        ).visible,
        isFalse,
      );
      expect(
        ShieldMatcher.match(
          const ShieldCandidate(
            scope: ShieldScope.recommendation,
            category: '游戏',
          ),
          rules,
        ).visible,
        isFalse,
      );
      expect(
        ShieldMatcher.match(
          const ShieldCandidate(
            scope: ShieldScope.recommendation,
            tags: ['攻略'],
          ),
          rules,
        ).visible,
        isFalse,
      );
    });

    test('regex block records invalid regex without blocking other rules', () {
      final result = ShieldMatcher.match(
        const ShieldCandidate(
          scope: ShieldScope.recommendation,
          title: '安全内容',
        ),
        ShieldRuleSet(
          rules: [
            _rule(mode: ShieldMatchMode.regex, pattern: '['),
            _rule(pattern: '安全内容'),
          ],
        ),
      );

      expect(result.visible, isFalse);
      expect(result.errors, hasLength(1));
      expect(result.errors.single.rule.pattern, '[');
    });

    test('token mode matches manual tokens without external services', () {
      final result = ShieldMatcher.match(
        const ShieldCandidate(
          scope: ShieldScope.recommendation,
          tokens: ['美食', '探店'],
        ),
        ShieldRuleSet(
          rules: [
            _rule(mode: ShieldMatchMode.token, pattern: '探店'),
          ],
        ),
      );

      expect(result.visible, isFalse);
    });

    test('generic keyword rules do not match UP names', () {
      final result = ShieldMatcher.match(
        const ShieldCandidate(
          scope: ShieldScope.recommendation,
          title: '正常标题',
          authorName: '测试UP',
        ),
        ShieldRuleSet(
          rules: [
            _rule(type: ShieldRuleType.keyword, pattern: '测试UP'),
          ],
        ),
      );

      expect(result.visible, isTrue);
    });

    test(
      'user keyword regex blocks Chinese substring in recommendation author',
      () {
        final result = ShieldMatcher.match(
          const ShieldCandidate(
            scope: ShieldScope.recommendation,
            authorName: 'xx说电影',
          ),
          ShieldRuleSet(
            rules: [
              _rule(
                type: ShieldRuleType.userKeyword,
                mode: ShieldMatchMode.regex,
                scope: ShieldScope.recommendation,
                pattern: '电影',
              ),
            ],
          ),
        );

        expect(result.visible, isFalse);
        expect(result.blockedBy?.pattern, '电影');
      },
    );

    test('user keyword token rules match split UP name tokens only', () {
      final rules = ShieldRuleSet(
        rules: [
          _rule(
            type: ShieldRuleType.userKeyword,
            mode: ShieldMatchMode.token,
            pattern: '测试',
          ),
        ],
      );

      expect(
        ShieldMatcher.match(
          const ShieldCandidate(
            scope: ShieldScope.recommendation,
            title: '标题里有测试',
            authorName: '普通UP',
          ),
          rules,
        ).visible,
        isTrue,
      );
      expect(
        ShieldMatcher.match(
          const ShieldCandidate(
            scope: ShieldScope.recommendation,
            title: '正常标题',
            authorName: '测试 UP',
          ),
          rules,
        ).visible,
        isFalse,
      );
    });

    test(
      'converted user keyword regex rules match UP name token boundaries',
      () {
        final rules = ShieldRuleSet(
          rules: [
            _rule(
              type: ShieldRuleType.userKeyword,
              mode: ShieldMatchMode.regex,
              pattern: shieldTokenPatternRegex('测试'),
            ),
          ],
        );

        expect(
          ShieldMatcher.match(
            const ShieldCandidate(
              scope: ShieldScope.recommendation,
              authorName: '普通UP',
            ),
            rules,
          ).visible,
          isTrue,
        );
        expect(
          ShieldMatcher.match(
            const ShieldCandidate(
              scope: ShieldScope.recommendation,
              authorName: '测试 UP',
            ),
            rules,
          ).visible,
          isFalse,
        );
        expect(
          ShieldMatcher.match(
            const ShieldCandidate(
              scope: ShieldScope.recommendation,
              authorName: '测试员',
            ),
            rules,
          ).visible,
          isTrue,
        );
      },
    );

    test('reason keyword rules match only recommendation reason', () {
      final rules = ShieldRuleSet(
        rules: [
          _rule(
            type: ShieldRuleType.reasonKeyword,
            pattern: '相似内容',
            scope: ShieldScope.recommendation,
          ),
        ],
      );

      expect(
        ShieldMatcher.match(
          const ShieldCandidate(
            scope: ShieldScope.recommendation,
            reason: '因为你看过相似内容',
          ),
          rules,
        ).visible,
        isFalse,
      );
      expect(
        ShieldMatcher.match(
          const ShieldCandidate(
            scope: ShieldScope.recommendation,
            title: '标题里有相似内容',
            authorName: '相似内容UP',
          ),
          rules,
        ).visible,
        isTrue,
      );
      expect(
        ShieldMatcher.match(
          const ShieldCandidate(
            scope: ShieldScope.comment,
            body: '评论里有相似内容',
          ),
          rules,
        ).visible,
        isTrue,
      );
    });

    test('reason keyword token rules use reason tokens only', () {
      final rules = ShieldRuleSet(
        rules: [
          _rule(
            type: ShieldRuleType.reasonKeyword,
            mode: ShieldMatchMode.token,
            pattern: '相似内容',
            scope: ShieldScope.recommendation,
          ),
        ],
      );

      expect(
        ShieldMatcher.match(
          const ShieldCandidate(
            scope: ShieldScope.recommendation,
            title: '标题里有相似内容',
            tokens: ['标题里有相似内容'],
          ),
          rules,
        ).visible,
        isTrue,
      );
      expect(
        ShieldMatcher.match(
          const ShieldCandidate(
            scope: ShieldScope.recommendation,
            reason: '因为 相似内容',
            tokens: ['标题'],
          ),
          rules,
        ).visible,
        isFalse,
      );
    });

    test('allow rule wins over same type block rule', () {
      final result = ShieldMatcher.match(
        const ShieldCandidate(
          scope: ShieldScope.recommendation,
          title: '音乐现场完整版',
        ),
        ShieldRuleSet(
          rules: [
            _rule(pattern: '音乐现场完整版'),
            _rule(
              pattern: '音乐现场完整版',
              action: ShieldAction.allow,
            ),
          ],
        ),
      );

      expect(result.visible, isTrue);
      expect(result.allowedBy?.action, ShieldAction.allow);
      expect(result.blockedBy?.action, ShieldAction.block);
    });

    test(
      'disabled rules, scope mismatch, and global switch bypass matching',
      () {
        final disabled = ShieldRuleSet(
          rules: [
            _rule(pattern: '猫咪睡觉合集', enabled: false),
          ],
        );
        final scopeMismatch = ShieldRuleSet(
          rules: [
            _rule(pattern: '猫咪睡觉合集', scope: ShieldScope.comment),
          ],
        );
        final globallyDisabled = ShieldRuleSet(
          globalEnabled: false,
          rules: [_rule(pattern: '猫咪睡觉合集')],
        );
        const candidate = ShieldCandidate(
          scope: ShieldScope.recommendation,
          title: '猫咪睡觉合集',
        );

        expect(ShieldMatcher.match(candidate, disabled).visible, isTrue);
        expect(ShieldMatcher.match(candidate, scopeMismatch).visible, isTrue);
        expect(
          ShieldMatcher.match(candidate, globallyDisabled).visible,
          isTrue,
        );
      },
    );
  });
}

ShieldRule _rule({
  ShieldRuleType type = ShieldRuleType.keyword,
  ShieldMatchMode mode = ShieldMatchMode.exact,
  ShieldScope scope = ShieldScope.both,
  ShieldAction action = ShieldAction.block,
  required String pattern,
  bool enabled = true,
}) => ShieldRule(
  id: 'rule-$type-$mode-$scope-$action-$pattern',
  type: type,
  matchMode: mode,
  scope: scope,
  action: action,
  pattern: pattern,
  enabled: enabled,
  updatedAt: DateTime.fromMillisecondsSinceEpoch(1),
);
