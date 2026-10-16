import 'package:PiliPlus/utils/windows/taskbar_helper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _channel = MethodChannel('com.example.piliplus/taskbar');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  final calls = <MethodCall>[];
  final ownerA = Object();
  final ownerB = Object();

  Future<void> click() => messenger.handlePlatformMessage(
    _channel.name,
    _channel.codec.encodeMethodCall(const MethodCall('onPlayPause')),
    (_) {},
  );

  setUpAll(WindowsTaskbarHelper.init);

  setUp(() {
    calls.clear();
    messenger.setMockMethodCallHandler(_channel, (call) async {
      calls.add(call);
      return null;
    });
  });

  tearDown(() {
    WindowsTaskbarHelper.hide(ownerA);
    WindowsTaskbarHelper.hide(ownerB);
    messenger.setMockMethodCallHandler(_channel, null);
  });

  test('update sends playing state only when it changes', () {
    WindowsTaskbarHelper.update(ownerA, playing: true, onToggle: () {});
    WindowsTaskbarHelper.update(ownerA, playing: true, onToggle: () {});
    WindowsTaskbarHelper.update(ownerA, playing: false, onToggle: () {});

    expect(calls.map((e) => (e.method, e.arguments)), [
      ('update', true),
      ('update', false),
    ]);
  });

  test('hide only takes effect for the current owner', () {
    WindowsTaskbarHelper.update(ownerA, playing: true, onToggle: () {});
    WindowsTaskbarHelper.update(ownerB, playing: false, onToggle: () {});
    WindowsTaskbarHelper.hide(ownerA);
    expect(calls.map((e) => e.method), ['update', 'update']);

    WindowsTaskbarHelper.hide(ownerB);
    expect(calls.last.method, 'hide');
  });

  test('update after hide shows the button again', () {
    WindowsTaskbarHelper.update(ownerA, playing: true, onToggle: () {});
    WindowsTaskbarHelper.hide(ownerA);
    WindowsTaskbarHelper.update(ownerA, playing: true, onToggle: () {});

    expect(calls.map((e) => (e.method, e.arguments)), [
      ('update', true),
      ('hide', null),
      ('update', true),
    ]);
  });

  test('click calls the current owner and nothing after hide', () async {
    var toggledA = 0;
    var toggledB = 0;
    WindowsTaskbarHelper.update(
      ownerA,
      playing: true,
      onToggle: () => toggledA++,
    );
    WindowsTaskbarHelper.update(
      ownerB,
      playing: true,
      onToggle: () => toggledB++,
    );

    await click();
    expect((toggledA, toggledB), (0, 1));

    WindowsTaskbarHelper.hide(ownerB);
    await click();
    expect((toggledA, toggledB), (0, 1));
  });
}
