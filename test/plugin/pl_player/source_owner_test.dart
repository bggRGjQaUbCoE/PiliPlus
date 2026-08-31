import 'dart:async';

import 'package:PiliPlus/plugin/pl_player/models/source_owner.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('latest owner prevents an older operation from committing', () async {
    final coordinator = PlayerSourceCoordinator();
    final firstOwner = Object();
    final secondOwner = Object();
    final firstStarted = Completer<void>();
    final unblockFirst = Completer<void>();
    final commits = <String>[];
    coordinator
      ..register(firstOwner)
      ..register(secondOwner);

    final first = coordinator.run(firstOwner, (isCurrent) async {
      firstStarted.complete();
      await unblockFirst.future;
      if (isCurrent()) commits.add('first');
    });
    await firstStarted.future;
    final second = coordinator.run(secondOwner, (isCurrent) async {
      if (isCurrent()) commits.add('second');
    });

    unblockFirst.complete();
    await Future.wait([first, second]);

    expect(commits, ['second']);
  });

  test('released owners cannot start or finish source operations', () async {
    final coordinator = PlayerSourceCoordinator();
    final owner = Object();
    final started = Completer<void>();
    final unblock = Completer<void>();
    var commits = 0;
    coordinator.register(owner);

    final operation = coordinator.run(owner, (isCurrent) async {
      started.complete();
      await unblock.future;
      if (isCurrent()) commits += 1;
    });
    await started.future;
    expect(coordinator.release(owner), isTrue);
    unblock.complete();
    await operation;
    await coordinator.run(owner, (_) async => commits += 1);

    expect(commits, 0);
    expect(coordinator.hasOwners, isFalse);
  });

  test('releasing an inactive owner keeps the active owner current', () async {
    final coordinator = PlayerSourceCoordinator();
    final firstOwner = Object();
    final secondOwner = Object();
    var secondCommitted = false;
    coordinator
      ..register(firstOwner)
      ..register(secondOwner);

    final operation = coordinator.run(secondOwner, (isCurrent) async {
      expect(coordinator.release(firstOwner), isTrue);
      secondCommitted = isCurrent();
    });
    await operation;

    expect(secondCommitted, isTrue);
    expect(coordinator.isActive(secondOwner), isTrue);
  });

  test('a failed operation does not block the next owner', () async {
    final coordinator = PlayerSourceCoordinator();
    final firstOwner = Object();
    final secondOwner = Object();
    var secondCommitted = false;
    coordinator
      ..register(firstOwner)
      ..register(secondOwner);

    await expectLater(
      coordinator.run(firstOwner, (_) async => throw StateError('failed')),
      throwsStateError,
    );
    await coordinator.run(secondOwner, (isCurrent) async {
      secondCommitted = isCurrent();
    });

    expect(secondCommitted, isTrue);
  });
}
