import 'package:PiliPlus/plugin/pl_player/models/mpv_speed_shortcut.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  MpvSpeedShortcutMachine createMachine() {
    return MpvSpeedShortcutMachine(kTarget: 2.0, lTarget: 3.0);
  }

  void latch(
    MpvSpeedShortcutMachine machine,
    MpvSpeedSlot slot, {
    double currentSpeed = 1.0,
  }) {
    machine.keyDown(
      slot,
      currentSpeed: currentSpeed,
      timeStamp: Duration.zero,
    );
    machine.keyUp(
      slot,
      timeStamp: const Duration(milliseconds: 100),
    );
  }

  test('K applies 2.00x and release at 249ms latches', () {
    final machine = createMachine();

    final down = machine.keyDown(
      MpvSpeedSlot.k,
      currentSpeed: 1.0,
      timeStamp: Duration.zero,
    );
    final up = machine.keyUp(
      MpvSpeedSlot.k,
      timeStamp: const Duration(milliseconds: 249),
    );

    expect(down.playbackSpeed, 2.0);
    expect(up.playbackSpeed, isNull);
    expect(machine.isLatched, isTrue);
  });

  test('release at 250ms restores the original speed', () {
    final machine = createMachine();

    machine.keyDown(
      MpvSpeedSlot.l,
      currentSpeed: 1.25,
      timeStamp: Duration.zero,
    );
    final up = machine.keyUp(
      MpvSpeedSlot.l,
      timeStamp: const Duration(milliseconds: 250),
    );

    expect(up.playbackSpeed, 1.25);
    expect(machine.isLatched, isFalse);
  });

  test('pressing the latched slot again restores the original speed', () {
    final machine = createMachine();
    latch(machine, MpvSpeedSlot.k, currentSpeed: 1.25);

    final down = machine.keyDown(
      MpvSpeedSlot.k,
      currentSpeed: 2.0,
      timeStamp: const Duration(seconds: 1),
    );
    final up = machine.keyUp(
      MpvSpeedSlot.k,
      timeStamp: const Duration(milliseconds: 1100),
    );

    expect(down.playbackSpeed, 1.25);
    expect(up.playbackSpeed, isNull);
    expect(machine.isLatched, isFalse);
  });

  test('switching from K to L preserves the original restore speed', () {
    final machine = createMachine();
    latch(machine, MpvSpeedSlot.k, currentSpeed: 1.25);

    final down = machine.keyDown(
      MpvSpeedSlot.l,
      currentSpeed: 2.0,
      timeStamp: const Duration(seconds: 1),
    );
    machine.keyUp(
      MpvSpeedSlot.l,
      timeStamp: const Duration(milliseconds: 1100),
    );
    final restore = machine.keyDown(
      MpvSpeedSlot.l,
      currentSpeed: 3.0,
      timeStamp: const Duration(seconds: 2),
    );

    expect(down.playbackSpeed, 3.0);
    expect(restore.playbackSpeed, 1.25);
  });

  test('active K adjustment applies and persists only the K target', () {
    final machine = createMachine();
    latch(machine, MpvSpeedSlot.k);

    final action = machine.adjust(currentSpeed: 2.0, deltaTenths: 1);

    expect(action.playbackSpeed, 2.1);
    expect(action.persistSlot, MpvSpeedSlot.k);
    expect(action.persistTarget, 2.1);
  });

  test('active L adjustment applies and persists only the L target', () {
    final machine = createMachine();
    latch(machine, MpvSpeedSlot.l);

    final action = machine.adjust(currentSpeed: 3.0, deltaTenths: -1);

    expect(action.playbackSpeed, 2.9);
    expect(action.persistSlot, MpvSpeedSlot.l);
    expect(action.persistTarget, 2.9);
  });

  test('idle adjustment does not persist a target', () {
    final machine = createMachine();

    final action = machine.adjust(currentSpeed: 1.0, deltaTenths: 1);

    expect(action.playbackSpeed, 1.1);
    expect(action.persistSlot, isNull);
    expect(action.persistTarget, isNull);
  });

  test('repeat key-down is ignored without restarting hold duration', () {
    final machine = createMachine();
    machine.keyDown(
      MpvSpeedSlot.k,
      currentSpeed: 1.0,
      timeStamp: Duration.zero,
    );

    final repeat = machine.keyDown(
      MpvSpeedSlot.k,
      currentSpeed: 2.0,
      timeStamp: const Duration(milliseconds: 200),
      repeat: true,
    );
    final up = machine.keyUp(
      MpvSpeedSlot.k,
      timeStamp: const Duration(milliseconds: 250),
    );

    expect(repeat.handled, isFalse);
    expect(up.playbackSpeed, 1.0);
  });

  test('mismatched key-up is ignored', () {
    final machine = createMachine();
    machine.keyDown(
      MpvSpeedSlot.k,
      currentSpeed: 1.0,
      timeStamp: Duration.zero,
    );

    final action = machine.keyUp(
      MpvSpeedSlot.l,
      timeStamp: const Duration(milliseconds: 100),
    );

    expect(action.handled, isFalse);
  });

  test('releaseAll restores a held speed and clears state', () {
    final machine = createMachine();
    machine.keyDown(
      MpvSpeedSlot.l,
      currentSpeed: 1.5,
      timeStamp: Duration.zero,
    );

    final action = machine.releaseAll();

    expect(action.playbackSpeed, 1.5);
    expect(machine.isLatched, isFalse);
  });

  test('releaseAll restores a latched speed and clears state', () {
    final machine = createMachine();
    latch(machine, MpvSpeedSlot.k, currentSpeed: 1.5);

    final action = machine.releaseAll();

    expect(action.playbackSpeed, 1.5);
    expect(machine.isLatched, isFalse);
  });

  test('decimal steps do not accumulate floating-point drift', () {
    final machine = createMachine();
    var speed = 1.0;

    for (var index = 0; index < 10; index += 1) {
      speed = machine
          .adjust(currentSpeed: speed, deltaTenths: 1)
          .playbackSpeed!;
    }

    expect(speed, 2.0);
  });

  test('speed never drops below 0.10x', () {
    final machine = createMachine();

    final action = machine.adjust(currentSpeed: 0.1, deltaTenths: -1);

    expect(action.playbackSpeed, 0.1);
  });
}
