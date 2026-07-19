import 'dart:async';

import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/widgets/triple_mixin.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/async_operation_guard.dart';
import 'package:PiliPlus/utils/identity_key.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:flutter_test/flutter_test.dart';

class _ReplyTarget {
  int likeCount = 0;
}

void main() {
  test(
    'rapid reply reactions issue one mutation and one count delta',
    () async {
      final response = Completer<void>();
      final guard = AsyncOperationGuard();
      var requestCount = 0;
      final firstTarget = _ReplyTarget();
      final replacementTarget = _ReplyTarget();
      var currentTarget = firstTarget;

      Future<void> likeReply() async {
        final target = currentTarget;
        requestCount += 1;
        await response.future;
        target.likeCount += 1;
      }

      final firstTap = guard.run(likeReply);
      currentTarget = replacementTarget;
      final secondTap = guard.run(likeReply);

      expect(requestCount, 1);
      expect(guard.isProcessing, isTrue);

      response.complete();
      await Future.wait([firstTap, secondTap]);

      expect(requestCount, 1);
      expect(firstTarget.likeCount, 1);
      expect(replacementTarget.likeCount, 0);
      expect(guard.isProcessing, isFalse);
    },
  );

  test('early return and failure both release the operation gate', () async {
    final guard = AsyncOperationGuard();
    var requestCount = 0;

    await guard.run(() {
      requestCount += 1;
    });
    expect(requestCount, 1);
    expect(guard.isProcessing, isFalse);

    await expectLater(
      guard.run(() {
        requestCount += 1;
        return Future<void>.error(StateError('request failed'));
      }),
      throwsStateError,
    );
    expect(requestCount, 2);
    expect(guard.isProcessing, isFalse);

    await guard.run(() {
      requestCount += 1;
    });

    expect(requestCount, 3);
    expect(guard.isProcessing, isFalse);
  });

  test(
    'keyed guard serializes only operations for the same resource',
    () async {
      final firstResponse = Completer<void>();
      final guard = AsyncKeyedOperationGuard<String>();
      final events = <String>[];

      final first = guard.run('dynamic-1', () async {
        events.add('first:start');
        await firstResponse.future;
        events.add('first:end');
      });
      final duplicate = guard.run('dynamic-1', () {
        events.add('duplicate');
      });
      final other = guard.run('dynamic-2', () {
        events.add('other');
      });

      await Future.wait([duplicate, other]);
      expect(events, ['first:start', 'other']);

      firstResponse.complete();
      await first;
      await guard.run('dynamic-1', () {
        events.add('after');
      });

      expect(events, ['first:start', 'other', 'first:end', 'after']);
      expect(guard.trackedKeyCount, 0);
    },
  );

  test('keyed guard releases failed operations before retry', () async {
    final guard = AsyncKeyedOperationGuard<String>();

    await expectLater(
      guard.run('dynamic-1', () => throw StateError('request failed')),
      throwsStateError,
    );
    expect(guard.trackedKeyCount, 0);

    var retried = false;
    await guard.run('dynamic-1', () {
      retried = true;
    });

    expect(retried, isTrue);
    expect(guard.trackedKeyCount, 0);
  });

  test(
    'serial guard queues distinct actions but deduplicates the same action',
    () async {
      final likeResponse = Completer<void>();
      final guard = AsyncKeyedSerialOperationGuard<String, String>();
      final events = <String>[];

      final like = guard.run('video-1', 'like', () async {
        events.add('like:start');
        await likeResponse.future;
        events.add('like:end');
      });
      final coin = guard.run('video-1', 'coin', () {
        events.add('coin');
      });
      final duplicateCoin = guard.run('video-1', 'coin', () {
        events.add('duplicate-coin');
      });
      final otherResource = guard.run('video-2', 'coin', () {
        events.add('other:coin');
      });

      await Future.wait([duplicateCoin, otherResource]);
      expect(events, ['like:start', 'other:coin']);

      likeResponse.complete();
      await Future.wait([like, coin]);

      expect(events, ['like:start', 'other:coin', 'like:end', 'coin']);
      expect(guard.trackedResourceCount, 0);
    },
  );

  test(
    'same-mid account replacements have independent action queues',
    () async {
      final originalAccount = _account('10001');
      final replacementAccount = _account('10001');
      final originalResource = ('video-1', IdentityKey(originalAccount));
      final replacementResource = ('video-1', IdentityKey(replacementAccount));
      final originalResponse = Completer<void>();
      final events = <String>[];
      final guard = AsyncKeyedSerialOperationGuard<Object, ResourceAction>();

      final original = guard.run(
        originalResource,
        ResourceAction.like,
        () async {
          events.add('original:start');
          await originalResponse.future;
          events.add('original:end');
        },
      );
      final replacement = guard.run(
        replacementResource,
        ResourceAction.like,
        () => events.add('replacement'),
      );

      await replacement;
      expect(events, ['original:start', 'replacement']);

      originalResponse.complete();
      await original;
      expect(events, ['original:start', 'replacement', 'original:end']);
    },
  );

  test('media action snapshots expire after an account or media switch', () {
    final firstAccount = _account('10001');
    final secondAccount = _account('10001');
    final snapshot = (
      key: ('video-a', IdentityKey(firstAccount)),
      account: firstAccount,
    );

    expect(
      matchesActionResource(
        snapshot,
        currentKey: ('video-a', IdentityKey(firstAccount)),
        currentAccount: firstAccount,
      ),
      isTrue,
    );
    expect(
      matchesActionResource(
        snapshot,
        currentKey: ('video-b', IdentityKey(firstAccount)),
        currentAccount: firstAccount,
      ),
      isFalse,
    );
    expect(
      matchesActionResource(
        snapshot,
        currentKey: ('video-a', IdentityKey(secondAccount)),
        currentAccount: secondAccount,
      ),
      isFalse,
    );
    expect(
      ('video-a', IdentityKey(secondAccount)),
      isNot(('video-a', IdentityKey(firstAccount))),
    );
  });

  test('dynamic like operation keys are isolated by account', () {
    final firstAccount = _account('10001');
    final secondAccount = _account('10002');
    final sameMidReplacement = _account('10001');
    final firstModel = DynamicItemModel.fromJson({'id_str': 'dynamic-1'});
    final replacementModel = DynamicItemModel.fromJson({
      'id_str': 'dynamic-1',
    });

    final firstKey = RequestUtils.dynamicLikeOperationKey(
      firstAccount,
      firstModel,
    );
    final replacementKey = RequestUtils.dynamicLikeOperationKey(
      firstAccount,
      replacementModel,
    );
    final otherAccountKey = RequestUtils.dynamicLikeOperationKey(
      secondAccount,
      replacementModel,
    );
    final replacementAccountKey = RequestUtils.dynamicLikeOperationKey(
      sameMidReplacement,
      replacementModel,
    );

    expect(replacementKey, firstKey);
    expect(otherAccountKey, isNot(firstKey));
    expect(replacementAccountKey, isNot(firstKey));
  });
}

LoginAccount _account(String mid) => LoginAccount(
  BiliCookieJar.fromList([
    {'name': 'DedeUserID', 'value': mid},
    {'name': 'bili_jct', 'value': 'csrf-$mid'},
  ]),
  null,
  null,
);
