import 'dart:typed_data';

import 'package:PiliPlus/pages/webdav/webdav.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const target = '/backups/settings.json';

  test('failed upload preserves the previous backup', () async {
    final files = <String, List<int>>{
      target: 'previous backup'.codeUnits,
    };

    await expectLater(
      replaceWebDavFile(
        path: target,
        data: Uint8List.fromList('new backup'.codeUnits),
        write: (path, data) {
          files[path] = data.sublist(0, 3);
          return Future<void>.error(
            StateError('simulated upload failure'),
          );
        },
        rename: (oldPath, newPath, overwrite) {
          files[newPath] = files.remove(oldPath)!;
          return Future<void>.value();
        },
        remove: (path) {
          files.remove(path);
          return Future<void>.value();
        },
      ),
      throwsStateError,
    );

    expect(files[target], 'previous backup'.codeUnits);
    expect(files.keys, [target]);
  });

  test('successful upload replaces through a temporary path', () async {
    final files = <String, List<int>>{
      target: 'previous backup'.codeUnits,
    };
    final events = <String>[];
    final replacement = Uint8List.fromList('new backup'.codeUnits);

    await replaceWebDavFile(
      path: target,
      data: replacement,
      write: (path, data) {
        events.add('write:$path');
        files[path] = data;
        return Future<void>.value();
      },
      rename: (oldPath, newPath, overwrite) {
        events.add('rename:$oldPath->$newPath:$overwrite');
        files[newPath] = files.remove(oldPath)!;
        return Future<void>.value();
      },
      remove: (path) {
        events.add('remove:$path');
        files.remove(path);
        return Future<void>.value();
      },
    );

    expect(files[target], replacement);
    expect(files.keys, [target]);
    expect(events.first, startsWith('write:$target.'));
    expect(events[1], startsWith('rename:$target.'));
    expect(events[1], endsWith('->$target:true'));
  });
}
