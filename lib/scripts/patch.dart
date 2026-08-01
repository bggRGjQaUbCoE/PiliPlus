#!/usr/bin/env dart

// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';

const appName = 'piliplus';

final picks = <String>[];
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

  // expose
  "lib/scripts/text_painter.patch",

  "lib/scripts/sliver.patch",

  "lib/scripts/refresh_indicator.patch",
];

final materialPatches = <String>[
  'lib/scripts/material/modal_barrier_material.patch',
  'lib/scripts/material/navigation_drawer.patch',
  'lib/scripts/material/popup_menu.patch',
  'lib/scripts/material/fab.patch',
  'lib/scripts/material/text_field.patch',
  'lib/scripts/material/scaffold.patch',
  'lib/scripts/material/refresh_indicator.patch',
  'lib/scripts/material/tabs.patch',
];

final cupertinoPatches = <String>[];

final patchesMap = {
  'material_ui': materialPatches,
  'cupertino_ui': cupertinoPatches,
};

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
      materialPatches.add('lib/scripts/material/bottom_sheet_android.patch');
    case 'ios':
      patches.addAll(const [
        // https://github.com/bggRGjQaUbCoE/PiliPlus/issues/1662
        'lib/scripts/scroll_view.patch',
        // https://github.com/bggRGjQaUbCoE/PiliPlus/issues/1906
        'lib/scripts/bottom_sheet_ios_flutter.patch',
        // https://github.com/bggRGjQaUbCoE/PiliPlus/issues/1947
        'lib/scripts/navigator.patch',
      ]);
      materialPatches.add(
        'lib/scripts/material/bottom_sheet_ios_flutter_material.patch',
      );
      cupertinoPatches.add(
        'lib/scripts/cupertino/bottom_sheet_ios_flutter.patch',
      );
  }
}

String getPubCacheDir() {
  if (Platform.isWindows) {
    final localAppData = Platform.environment['LOCALAPPDATA'];
    if (localAppData == null || localAppData.isEmpty) {
      throw const FileSystemException(
        'LOCALAPPDATA environment variable is not set',
      );
    }
    return '$localAppData${Platform.pathSeparator}Pub${Platform.pathSeparator}Cache';
  } else {
    final home =
        Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
    if (home == null || home.isEmpty) {
      throw const FileSystemException('HOME environment variable is not set');
    }
    return '$home${Platform.pathSeparator}.pub-cache';
  }
}

void findiDir(
  String workspace,
  String pubCacheDir,
  Map<String, Directory?> packages,
) {
  final pubDev = Directory(
    '$pubCacheDir${Platform.pathSeparator}hosted${Platform.pathSeparator}pub.dev',
  );
  if (!pubDev.existsSync()) return;

  final lines = File('$workspace${Platform.pathSeparator}pubspec.lock')
      .readAsLinesSync();

  String? currentPackage;
  int count = 0;
  for (final line in lines) {
    if (line.isEmpty) continue;
    final trimmed = line.trimLeft();

    if (line.length - trimmed.length == 2) {
      final package = trimmed.substring(0, trimmed.length - 1);
      if (packages.containsKey(package)) {
        currentPackage = package;
      } else {
        currentPackage = null;
      }
      continue;
    }

    if (currentPackage != null) {
      if (trimmed.startsWith('version:')) {
        final version = trimmed
            .substring('version:'.length)
            .trim()
            .replaceAll('"', '')
            .replaceAll("'", '');

        final dir = Directory(
          '${pubDev.path}${Platform.pathSeparator}$currentPackage-$version',
        );

        if (dir.existsSync()) packages[currentPackage] = dir;

        if (++count == packages.length) break;
      }
    }
  }
}

Future<void> checkCache(
  String workspace,
  List<String> patches,
  void Function(String, List<String>) callback, {
  bool reset = true,
}) async {
  final hash = await computeHashUnordered(
    patches.map((p) => '$workspace${Platform.pathSeparator}$p'),
  );

  final cacheHashFile = File('.${appName}_patch_cache');
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

  if (reset) {
    runGit(const ['reset', '--hard', 'HEAD']);
    runGit(const ['clean', '-fd']);
  }

  try {
    callback(workspace, patches);
    cacheHashFile.writeAsBytesSync(
      (ByteData(4)..setUint32(0, hash)).buffer.asUint8List(),
    );
  } catch (_) {
    if (reset) {
      runGit(const ['reset', '--hard', 'HEAD'], check: false);
      runGit(const ['clean', '-fd'], check: false);
    }
    rethrow;
  }
}

void applyFlutter(String workspace, List<String>? _) {
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
}

void applyPub(String workspace, List<String> patches) {
  if (patches.isEmpty) return;
  runGit([
    'apply',
    ...patches.map((p) => '$workspace${Platform.pathSeparator}$p'),
  ]);
  print(
    'Pub Patches applied successfully: \n${patches.join("\n")}',
  );
}

void main(List<String> args) async {
  final String workspace;

  final packages = <String, Directory?>{
    for (final i in patchesMap.keys) i: null,
  };

  if (Platform.environment['GITHUB_WORKSPACE'] case final space?
      when (space.isNotEmpty)) {
    workspace = space;

    final pubGet = args.elementAtOrNull(2) == 'true'
        ? null
        : Process.run(
            'flutter',
            const ['pub', 'get'],
            workingDirectory: workspace,
            runInShell: Platform.isWindows,
          );

    final platform = args[0];

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

    addPlatformPatch(platform);

    if (args.elementAtOrNull(1) != 'true') {
      Directory.current = Platform.environment['FLUTTER_ROOT']!;
      applyFlutter(workspace, null);
    }

    if (pubGet != null) {
      if ((await pubGet).exitCode != 0) {
        throw StateError('pub get failed');
      }

      findiDir(workspace, Platform.environment['PUB_CACHE']!, packages);

      for (var i in patchesMap.entries) {
        if (i.value.isEmpty) continue;
        Directory.current = packages[i.key]!;
        applyPub(workspace, i.value);
      }
    }
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
    await checkCache(workspace, patches, applyFlutter);

    findiDir(workspace, getPubCacheDir(), packages);

    for (var i in patchesMap.entries) {
      if (i.value.isEmpty) continue;
      print('try apply ${i.key}');
      Directory.current = packages[i.key]!;
      await checkCache(workspace, i.value, applyPub, reset: false);
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
}

ProcessResult runGit(
  List<String> args, {
  String? workingDirectory,
  bool check = true,
}) {
  final res = Process.runSync('git', args, workingDirectory: workingDirectory);
  if (check && res.exitCode != 0) {
    throw StateError('exitCode: ${res.exitCode}, errMsg=${res.stderr}');
  }
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
