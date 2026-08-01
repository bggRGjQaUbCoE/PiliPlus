#!/usr/bin/env dart
// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';

const appName = 'piliplus';

final picks = <String>[
  // TODO: remove https://github.com/flutter/flutter/issues/185052
  'beb2ad17004a1b118ff2bd09f55cee23198f6652',
];

final reverts = <String>[];

final patches = <String>[
  // TODO: remove https://github.com/flutter/flutter/issues/90223
  'lib/scripts/modal_barrier.patch',

  // https://github.com/bggRGjQaUbCoE/PiliPlus/issues/2106
  // use TouchGestureRecognizer on all platforms
  'lib/scripts/text_selection.patch',

  // TODO: remove https://github.com/flutter/flutter/issues/182466
  'lib/scripts/mouse_cursor.patch',

  // https://github.com/bggRGjQaUbCoE/PiliPlus/issues/2107
  'lib/scripts/image_anim.patch',

  // remove _scheduleRebuild
  'lib/scripts/layout_builder.patch',

  // https://github.com/bggRGjQaUbCoE/PiliPlus/issues/2308
  'lib/scripts/navigation_drawer.patch',

  // apply text color to icon color
  'lib/scripts/popup_menu.patch',

  // remove Hero effect
  'lib/scripts/fab.patch',

  // TODO: remove https://github.com/flutter/flutter/issues/124078
  'lib/scripts/null_safety_for_selectable_region.patch',

  // https://github.com/flutter/flutter/issues/139890
  // https://github.com/flutter/flutter/issues/174689
  // separator support / clamp handle offset / widgetspan selection support
  // clear selection when tapping outside / free selection (single text)
  // clamp dragging selection behavior on Android
  // show selection menu on desktop if secondary tap inside text
  'lib/scripts/selectable_region.patch',

  // https://github.com/flutter/flutter/issues/132047
  // https://github.com/flutter/flutter/issues/174689
  'lib/scripts/editable_text.patch',

  // set selectAllOnFocus to false by default
  'lib/scripts/text_field.patch',

  // notify userScrollDirection only if position is actually changing
  'lib/scripts/scroll_position.patch',

  // expose _shouldIgnorePointer
  'lib/scripts/scrollable.patch',

  // fix nested scrollable gesture
  // custom `HorizontalDragGestureRecognizer` support
  'lib/scripts/scrollable_gesture.patch',

  // expose
  'lib/scripts/draggable_scrollable_sheet.patch',

  // expose
  'lib/scripts/scaffold.patch',

  // expose
  "lib/scripts/text.patch",
];

void addPlatformPatch(String platform) {
  switch (platform) {
    case 'android':
      patches.addAll(const [
        // set gestureSettings
        'lib/scripts/bottom_sheet_android.patch',
        // https://github.com/bggRGjQaUbCoE/PiliPlus/issues/1662
        // handle bottom scroll event
        'lib/scripts/scroll_view.patch',
        // https://github.com/bggRGjQaUbCoE/PiliPlus/issues/1947
        'lib/scripts/navigator.patch',
      ]);
      break;
    case 'ios':
      patches.addAll(const [
        // https://github.com/bggRGjQaUbCoE/PiliPlus/issues/1662
        'lib/scripts/scroll_view.patch',
        // https://github.com/bggRGjQaUbCoE/PiliPlus/issues/1906
        'lib/scripts/bottom_sheet_ios_flutter.patch',
        // https://github.com/bggRGjQaUbCoE/PiliPlus/issues/1947
        'lib/scripts/navigator.patch',
      ]);
      break;
    case 'linux':
    case 'macos':
    case 'windows':
      break;
  }
}

void main(List<String> args) async {
  final String workspace;
  final String platform;

  File? cacheHashFile;
  int? hash;

  if (Platform.environment['GITHUB_WORKSPACE'] case final space?
      when (space.isNotEmpty)) {
    workspace = space;
    platform = args[0];

    runGit(const ['config', '--global', 'user.name', 'ci']);
    runGit(const ['config', '--global', 'user.email', 'example@example.com']);

    if (platform == 'ios') {
      runGit(
        const [
          'apply',
          // https://github.com/bggRGjQaUbCoE/PiliPlus/issues/1906
          'lib/scripts/bottom_sheet_ios_piliplus.patch',
          'lib/scripts/geetest_ios.patch',
        ],
        workingDirectory: workspace,
      );
    }

    Directory.current = Platform.environment['FLUTTER_ROOT']!;

    addPlatformPatch(platform);
  } else {
    workspace = File(
      Platform.script.toFilePath(),
    ).parent.parent.parent.absolute.path;

    Directory root = File(Platform.resolvedExecutable).parent;
    while (!FileSystemEntity.isDirectorySync(
      '${root.path}${Platform.pathSeparator}.git',
    )) {
      root = root.parent;
    }
    Directory.current = root;

    hash = await computeHashUnordered(
      patches.map((p) => '$workspace${Platform.pathSeparator}$p'),
    );

    cacheHashFile = File('.${appName}_patch_cache');
    if (cacheHashFile.existsSync()) {
      final cacheHash = cacheHashFile
          .readAsBytesSync()
          .buffer
          .asByteData()
          .getUint32(0);
      if (cacheHash == hash) {
        print('cache hit');
        return;
      }
    }

    // final devices = Process.runSync('flutter', const [
    //   'devices',
    //   '--machine',
    // ]);
    // if (devices.exitCode == 0) {
    //   final List devs = jsonDecode(devices.stdout);
    //   String localPlatform = Platform.operatingSystem;
    //   for (final device in devs) {
    //     if (args[0] == device['id']) {
    //       final String platform = device['targetPlatform'];
    //       localPlatform = platform.replaceFirst(RegExp(r'-.*'), '');
    //       if (localPlatform == 'darwin') localPlatform = 'macos';
    //       break;
    //     }
    //   }
    //   platform = localPlatform;
    // } else {
    //   throw devices.stderr;
    // }
  }

  runGit(const ['reset', '--hard', 'HEAD']);
  runGit(const ['clean', '-fd']);

  try {
    if (picks.isNotEmpty) {
      runGit(['cherry-pick', '-n', ...picks]);
      print('cherry-pick applied: ${picks.join(",")}');
    }

    if (reverts.isNotEmpty) {
      runGit(['revert', '-n', ...reverts]);
      print('revert applied: ${reverts.join(",")}');
    }

    if (patches.isNotEmpty) {
      runGit([
        'apply',
        ...patches.map((p) => '$workspace${Platform.pathSeparator}$p'),
      ]);
      print('Patches applied successfully: \n${patches.join("\n")}');
    }

    if (cacheHashFile != null) {
      cacheHashFile.writeAsBytesSync(
        (ByteData(4)..setUint32(0, hash!)).buffer.asUint8List(),
      );
    }
  } catch (_) {
    runGit(const ['reset', '--hard', 'HEAD'], check: false);
    runGit(const ['clean', '-fd'], check: false);
    rethrow;
  }
}

ProcessResult runGit(
  List<String> args, {
  String? workingDirectory,
  bool check = true,
}) {
  final res = Process.runSync('git', args, workingDirectory: workingDirectory);
  if (check && res.exitCode != 0) throw StateError(res.stderr.toString());
  return res;
}

abstract final class FNV1a32 {
  static const int offsetBasis = 0x811c9dc5;
  static const int _prime = 0x01000193;

  static int addBytes(int hash, List<int> bytes) {
    for (int i = 0; i < bytes.length; i++) {
      hash ^= bytes[i];
      hash = (hash * _prime) & 0xFFFFFFFF;
    }
    return hash;
  }
}

Future<int> computeHashUnordered(Iterable<String> filePaths) async {
  final futures = filePaths.map(
    (path) => File(path).openRead().fold(FNV1a32.offsetBasis, FNV1a32.addBytes),
  );

  final fileHashes = await Future.wait(futures)
    ..sort();

  int hash = FNV1a32.offsetBasis;
  for (final h in fileHashes) {
    hash = FNV1a32.addBytes(
      hash,
      (ByteData(4)..setInt32(0, h)).buffer.asUint8List(),
    );
  }
  return hash.toUnsigned(32);
}
