// Pure-Dart build tool for pre-build steps: SDK/patch application, version
// metadata generation, and disposable SDK-copy isolation.
//
// Design principle (mirrors upstream #1510 discussion): never try to export
// environment variables from Dart (impossible); version/metadata is written to
// files (pili_release.json) and read via --dart-define-from-file, and optional
// CI hints are appended to $GITHUB_ENV *file*, which the Actions runner reads.
//
// OOP layout — domain concepts are encapsulated into classes; the task
// subcommands are thin orchestrators on top:
//
//   Runner         process execution + [success]/Error logging
//   FlutterSdk     SDK root resolution + git ops (reset/cherry-pick/revert/apply)
//   PubCache       pub cache root + hosted/<registry>/ package find/delete
//   PatchesMatrix  declarative matrix in patches.json (keys/file/meta/hash);
//                  each patch carries a `target` (sdk|pub|project) so
//                  distribution is data-driven, no group names are hardcoded
//
// Stateless design: no `.patch_state.json` state machine. `apply-patches` runs
// on a git-clean tree (CI), optionally onto a disposable SDK copy (`--sdk-copy`)
// for local debugging isolation, so nothing ever needs to remember what was
// applied or be restored in place.
//
// Entry:
//
//   dart run lib/scripts/pre_build.dart apply-patches  --platform linux
//   dart run lib/scripts/pre_build.dart apply-patches  --platform linux --sdk-copy [--force]
//   dart run lib/scripts/pre_build.dart gen-build-info --platform linux [--tag vX] [--ci]
//
// Patch matrix: lib/scripts/patches.json (declarative source of truth).

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data' show BytesBuilder;

const String _patchJson = 'lib/scripts/patches.json';
const String _piliReleaseJson = 'pili_release.json';

/// Absolute path of this git repo root (parent of lib/scripts).
final String projectRoot = Directory.current.absolute.path;

// ---------------------------------------------------------------------------
// misc top-level helpers
// ---------------------------------------------------------------------------

// Portably resolve a symlink (or plain path) to its absolute target using
// Dart's built-in FileSystemEntity, avoiding the platform-specific `realpath`
// binary (absent by default on Windows).
String? _realpath(String p) {
  try {
    final resolved = File(p).resolveSymbolicLinksSync();
    if (resolved.isNotEmpty) return resolved;
  } catch (_) {}
  return null;
}

// ---------------------------------------------------------------------------
// Runner: subprocess execution with uniform diagnostics
// ---------------------------------------------------------------------------

/// Executes external commands and reports `[success]` / `Error:` lines to stderr.
class Runner {
  final String logTo;
  Runner({this.logTo = 'stderr'});

  IOSink get _out => logTo == 'stdout' ? stdout : stderr;

  void success(String msg) => _out.writeln('[success] $msg applied');
  void info(String msg) => _out.writeln(msg);
  void warnLine(String msg) => _out.writeln('Warning: $msg');
  Never error(String msg) {
    _out.writeln('Error: $msg');
    exit(1);
  }

  Future<ProcessResult> run(String cwd, List<String> cmd) {
    return Process.run(
      cmd.first,
      cmd.sublist(1),
      workingDirectory: cwd,
      stdoutEncoding: utf8,
      stderrEncoding: utf8,
    );
  }

  ProcessResult runSync(String cwd, List<String> cmd) {
    return Process.runSync(
      cmd.first,
      cmd.sublist(1),
      workingDirectory: cwd,
      stdoutEncoding: utf8,
      stderrEncoding: utf8,
    );
  }
}

// ---------------------------------------------------------------------------
// FlutterSdk: locate SDK + git operations against it
// ---------------------------------------------------------------------------

final Runner _r = Runner();

class FlutterSdk {
  final String root;
  FlutterSdk._(this.root);

  static FlutterSdk resolve() {
    final env = Platform.environment['FLUTTER_ROOT'];
    if (env != null && env.isNotEmpty) return FlutterSdk._(env);
    // Resolve `flutter` from PATH (covers FVM via `.fvm/flutter_sdk/bin` and
    // bare global installs alike).
    final which = Process.runSync(
      Platform.isWindows ? 'where.exe' : 'which',
      ['flutter'],
    );
    if (which.exitCode == 0) {
      final line = (which.stdout as String).trim().split('\n').first.trim();
      if (line.isNotEmpty) {
        final flutterBin = File(line);
        // flutter binary lives at <sdk>/bin/flutter — resolve SDK root.
        final sdkRoot = flutterBin.parent.parent.path;
        if (Directory(sdkRoot).existsSync()) return FlutterSdk._(sdkRoot);
      }
    }
    throw StateError(
      'cannot locate Flutter SDK (no FLUTTER_ROOT and `flutter` not in PATH)',
    );
  }

  Future<String> head() async =>
      ((await _r.run(root, ['git', 'rev-parse', 'HEAD'])).stdout as String)
          .trim();

  Future<void> configureIdentity() async {
    await _r.run(root, ['git', 'config', 'user.name', 'ci']);
    await _r.run(root, ['git', 'config', 'user.email', 'example@example.com']);
  }

  Future<void> resetHard({String? to}) async {
    final args = to == null
        ? ['git', 'reset', '--hard', 'HEAD']
        : ['git', 'reset', '--hard', to];
    final r = await _r.run(root, args);
    if (r.exitCode != 0) {
      _r.error('git reset --hard failed\n${r.stderr}');
    }
    _r.info('SDK working tree reset to ${to ?? 'HEAD'}');
  }

  Future<void> applyPatch(
    String patchAbs, {
    String label = '',
    bool reverse = false,
  }) async {
    final args = <String>['git', 'apply'];
    if (reverse) args.add('-R');
    args.add(patchAbs);
    final r = await _r.run(root, args);
    if (r.exitCode == 0) {
      _r.success(label);
    } else {
      _r.error('failed to $label apply $patchAbs\n${r.stderr}');
    }
  }

  /// Cherry-pick the given hash out of the SDK history. On failure the working
  /// tree is restored to HEAD.
  Future<void> cherryPick(String hash, [String label = '']) async {
    await _r.run(root, ['git', 'stash']);
    final cp = await _r.run(root, ['git', 'cherry-pick', hash, '--no-edit']);
    if (cp.exitCode == 0) {
      await _r.run(root, ['git', 'reset', '--soft', 'HEAD~1']);
      _r.info('cherry-pick ${hash.substring(0, 9)} ($label) applied');
      await _r.run(root, ['git', 'stash', 'pop']);
    } else {
      await _r.run(root, ['git', 'reset', '--hard', 'HEAD']);
      await _r.run(root, ['git', 'stash', 'pop']);
      _r.error(
        'cherry-pick ${hash.substring(0, 9)} ($label) failed\n${cp.stderr}',
      );
    }
  }

  /// git-revert the given hash, then squashed so only the revert changes remain.
  Future<void> revert(String hash, [String label = '']) async {
    await _r.run(root, ['git', 'stash']);
    final rv = await _r.run(root, ['git', 'revert', hash, '--no-edit']);
    if (rv.exitCode == 0) {
      await _r.run(root, ['git', 'reset', '--soft', 'HEAD~1']);
      _r.info('revert ${hash.substring(0, 9)} ($label) applied');
      await _r.run(root, ['git', 'stash', 'pop']);
    } else {
      await _r.run(root, ['git', 'reset', '--hard', 'HEAD']);
      await _r.run(root, ['git', 'stash', 'pop']);
      _r.error('revert ${hash.substring(0, 9)} ($label) failed\n${rv.stderr}');
    }
  }
}

// ---------------------------------------------------------------------------
// PubCache: cache root + hosted/<registry>/ package lookup/delete
// ---------------------------------------------------------------------------

class PubCache {
  final String root;
  PubCache._(this.root);

  static PubCache resolve(String platform) {
    final env = Platform.environment['PUB_CACHE'];
    if (env != null && env.isNotEmpty) return PubCache._(env);
    if (platform == 'windows') {
      final la = Platform.environment['LOCALAPPDATA'];
      if (la != null && la.isNotEmpty) return PubCache._('$la/Pub/Cache');
      return PubCache._(
        '${Platform.environment['HOME'] ?? ''}/AppData/Local/Pub/Cache',
      );
    }
    return PubCache._('${Platform.environment['HOME'] ?? ''}/.pub-cache');
  }

  Directory _hosted() => Directory('$root/hosted');

  Iterable<Directory> _registries() {
    final hosted = _hosted();
    if (!hosted.existsSync()) return const [];
    return hosted.listSync(followLinks: false).whereType<Directory>();
  }

  /// Latest matching directory under the pub cache, searching every
  /// `hosted/<registry>/` subdir (e.g. `pub.dev` or China mirror
  /// `pub.flutter-io.cn`). Returns null when absent.
  Directory? findPackage(String prefix) {
    Directory? best;
    for (final reg in _registries()) {
      for (final d in reg.listSync(followLinks: false).whereType<Directory>()) {
        final name = d.path.split('/').last;
        if (name.startsWith(prefix) &&
            (best == null || d.path.compareTo(best.path) > 0)) {
          if (d.existsSync()) best = d;
        }
      }
    }
    return best;
  }

  /// Delete every cached copy of [prefixes] across all hosted registries, so
  /// the next `flutter pub get` re-downloads a pristine copy.
  void deletePackages(List<String> prefixes) {
    for (final reg in _registries()) {
      for (final d in reg.listSync(followLinks: false).whereType<Directory>()) {
        final name = d.path.split('/').last;
        if (prefixes.any(name.startsWith)) {
          d.deleteSync(recursive: true);
          _r.info('Removed cached $name: ${d.path}');
        }
      }
    }
  }
}

// ---------------------------------------------------------------------------
// PatchesMatrix: declarative matrix in patches.json
// ---------------------------------------------------------------------------

class PatchesMatrix {
  final Map<String, dynamic> data;

  PatchesMatrix._(this.data);

  static PatchesMatrix load() => PatchesMatrix._(
    jsonDecode(File('$projectRoot/$_patchJson').readAsStringSync())
        as Map<String, dynamic>,
  );

  Map<String, dynamic> meta(String id) =>
      (data['patches'][id] as Map<String, dynamic>?) ?? {};

  String fileFor(String id) => meta(id)['file'] as String? ?? '';

  String hashFor(String id) => meta(id)['hash'] as String? ?? id;

  String? issueFor(String id) => meta(id)['issue_link'] as String?;

  /// Distribution target: `sdk`, `pub` or `project` (data-driven, replaces
  /// hardcoded group names so new groups need no script change).
  String targetFor(String id) => meta(id)['target'] as String? ?? 'sdk';

  /// Target pub package (e.g. `material_ui`) for a `pub` patch.
  String packageFor(String id) => meta(id)['package'] as String? ?? '';

  /// Every patch key selected for [platform], merging `common` first and then
  /// every platform group (any group name) in order, de-duplicated. This is
  /// the single aggregation point for all of the SDK / pub / project patches;
  /// downstream code filters by [targetFor].
  List<String> allKeysFor(String platform) {
    final out = <String>[];
    final common = data['platform']['common'];
    void addFrom(dynamic node) {
      if (node == null) return;
      if (node is List) {
        for (final v in node) {
          out.add(v as String);
        }
        return;
      }
      if (node is Map) {
        for (final v in node.values) {
          if (v is List) {
            for (final e in v) {
              out.add(e as String);
            }
          }
        }
      }
    }

    addFrom(common);
    final pl = data['platform'][platform];
    if (pl is Map) addFrom(pl);
    final seen = <String>{};
    return out.where(seen.add).toList();
  }

  /// Keys of the given kind for [platform], merging `common` first.
  List<String> keysFor(String platform, {required String kind}) {
    final out = <String>[];
    final common = data['platform']['common'];
    if (common != null && common[kind] != null) {
      out.addAll((common[kind] as List).cast<String>());
    }
    final pl = data['platform'][platform];
    if (pl != null && pl[kind] != null) {
      out.addAll((pl[kind] as List).cast<String>());
    }
    return out;
  }

  String? engineVersionKey(String platform) =>
      data['platform']?[platform]?['engine_version']?['key'];
}

// ---------------------------------------------------------------------------
// Patch application primitives (normalize CRLF, byte compare)
// ---------------------------------------------------------------------------

/// Normalize CRLF -> LF so `git apply` works on files from a Windows checkout.
Future<void> normalizePatch(File f) async {
  if (!f.existsSync()) return;
  final bytes = f.readAsBytesSync();
  final out = BytesBuilder();
  for (var i = 0; i < bytes.length; i++) {
    if (bytes[i] == 13 && i + 1 < bytes.length && bytes[i + 1] == 10) {
      // drop \r, keep \n
    } else {
      out.addByte(bytes[i]);
    }
  }
  final replaced = out.takeBytes();
  if (!_bytesEqual(bytes, replaced)) {
    f.writeAsBytesSync(replaced, flush: true);
  }
}

bool _bytesEqual(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

// ---------------------------------------------------------------------------
// Shared application primitives (reused by apply-patches in-place and copy)
// ---------------------------------------------------------------------------

/// Apply every `target == "project"` patch for [platform] to the project repo.
void applyProjectPatches(String platform, PatchesMatrix matrix) {
  for (final id in matrix.allKeysFor(platform)) {
    if (matrix.targetFor(id) != 'project') continue;
    final file = matrix.fileFor(id);
    final abs = '$projectRoot/lib/scripts/$file';
    final issue = matrix.issueFor(id);
    final r = _r.runSync(projectRoot, ['git', 'apply', abs]);
    if (r.exitCode == 0) {
      _r.info('$file applied to project${issue != null ? ' ($issue)' : ''}');
    } else {
      _r.error(
        'failed to apply $file to project${issue != null ? ' ($issue)' : ''}\n${r.stderr}',
      );
    }
  }
}

/// Apply every `target == "sdk"` patch for [platform] onto [sdk], plus the
/// pick/revert commits and the optional engine-version rewrite. Assumes a
/// pristine SDK HEAD (CI or a fresh copy).
Future<void> applySdkPatches(
  String platform,
  PatchesMatrix matrix,
  FlutterSdk sdk,
) async {
  for (final id in matrix.keysFor(platform, kind: 'picks')) {
    await sdk.cherryPick(matrix.hashFor(id), id);
  }
  for (final id in matrix.keysFor(platform, kind: 'reverts')) {
    await sdk.revert(matrix.hashFor(id), id);
  }
  for (final id in matrix.allKeysFor(platform)) {
    if (matrix.targetFor(id) != 'sdk') continue;
    final file = matrix.fileFor(id);
    final issue = matrix.issueFor(id) ?? '';
    final abs = '$projectRoot/lib/scripts/$file';
    await sdk.applyPatch(abs, label: '$file -> Flutter SDK $issue');
  }

  // engine version (optional; empty in current main)
  final engineKey = matrix.engineVersionKey(platform);
  if (engineKey != null && engineKey.toString().isNotEmpty) {
    final ev = File('${sdk.root}/bin/internal/engine.version');
    if (ev.existsSync()) ev.writeAsStringSync(engineKey.toString());
    Directory('${sdk.root}/bin/cache').deleteSync(recursive: true);
    await _r.run(sdk.root, ['flutter', '--version']);
  }
}

// ---------------------------------------------------------------------------
// Task: apply-patches
// ---------------------------------------------------------------------------

Future<void> applyPatches(Map<String, String> opts) async {
  final platform = opts['platform'] ?? (opts['--platform'] ?? '');
  if (platform.isEmpty) _r.error('--platform is required');
  final sdkCopyMode =
      opts.containsKey('sdk-copy') || opts.containsKey('--sdk-copy');
  final force = opts.containsKey('force') || opts.containsKey('--force');
  final ci = opts.containsKey('ci');

  final matrix = PatchesMatrix.load();

  final mode = sdkCopyMode ? 'sdk-copy' : 'direct';
  _r.info(
    '== apply-patches [platform=$platform mode=$mode'
    '${ci ? ' ci' : ''}${force ? ' force' : ''}]',
  );

  // Optionally route the whole apply onto a disposable SDK copy instead of the
  // resolved SDK (CI builds patch in place; local debugging isolates via copy).
  final copyRoot = sdkCopyMode ? await _prepareSdkCopy(platform, force) : null;
  final sdk = copyRoot != null ? FlutterSdk._(copyRoot) : FlutterSdk.resolve();

  // project-level patches (applied before entering Flutter SDK)
  applyProjectPatches(platform, matrix);

  // enter the SDK on a clean tree (stateless: SDK HEAD must be pristine)
  await sdk.configureIdentity();
  await sdk.resetHard();
  await applySdkPatches(platform, matrix, sdk);
  await applyPubPatches(platform, matrix);

  if (copyRoot != null) {
    final tag = copyRoot.split(Platform.pathSeparator).last;
    // Point the project at the patched copy.
    await _r.run(projectRoot, [
      'fvm',
      'use',
      '--skip-pub-get',
      '--skip-setup',
      '--force',
      tag,
    ]);

    // Warm up the copy: renew excluded bin/cache + record the copy as SDK in
    // the *project's* package_config.json (run from project root using the
    // copy's flutter binary) so the analysis server / launch are self-consistent.
    final w = await _r.run(projectRoot, [
      '$copyRoot/bin/flutter',
      'pub',
      'get',
    ]);
    if (w.exitCode != 0) {
      _r.warnLine('flutter pub get on SDK copy failed (retry on first run)');
    }

    File('$copyRoot/.sdk-copy-ok').createSync(recursive: true);
    _r.info('SDK copy prepared: $tag');
    stdout.writeln(tag);
  }

  final keys = matrix.allKeysFor(platform);
  _r.info(
    '== apply-patches done: ${keys.length} patches '
    '(${keys.where((k) => matrix.targetFor(k) == 'sdk').length} sdk, '
    '${keys.where((k) => matrix.targetFor(k) == 'pub').length} pub, '
    '${keys.where((k) => matrix.targetFor(k) == 'project').length} project) ==',
  );
}

// ---------------------------------------------------------------------------
// material / cupertino pub-cache patches (dynamic, package-driven)
// ---------------------------------------------------------------------------

/// Apply every `target == "pub"` patch for [platform]. Packages are resolved
/// dynamically from each patch's `package` field in patches.json (e.g.
/// `material_ui`, `cupertino_ui`), so arbitrary pub packages are handled
/// without hardcoding any package name or group. Every affected package is
/// re-downloaded clean via `flutter pub get` before patching, guaranteeing a
/// pristine checkout (conflict-free reapply and symmetric restore). Returns
/// the distinct packages patched, one per entry.
Future<List<String>> applyPubPatches(
  String platform,
  PatchesMatrix matrix,
) async {
  // Group patch keys by package, preserving first-seen order; skip anything
  // whose target is not "pub" (so adding a new group needs no script change).
  final keysByPackage = <String, List<String>>{};
  final packageOrder = <String>[];
  for (final id in matrix.allKeysFor(platform)) {
    if (matrix.targetFor(id) != 'pub') continue;
    final pkg = matrix.packageFor(id);
    if (pkg.isEmpty) continue;
    keysByPackage
        .putIfAbsent(pkg, () {
          packageOrder.add(pkg);
          return <String>[];
        })
        .add(id);
  }
  if (packageOrder.isEmpty) return const [];

  final cache = PubCache.resolve(platform);
  final applied = <String>[];

  for (final pkg in packageOrder) {
    // Re-download a pristine copy of the package before patching.
    final existing = cache.findPackage('$pkg-');
    if (existing != null) {
      existing.deleteSync(recursive: true);
      _r.info('Removed cached $pkg: ${existing.path}');
    }
    final rc = await _r.run(projectRoot, ['flutter', 'pub', 'get']);
    if (rc.exitCode != 0 && rc.exitCode != 1) {
      _r.error('flutter pub get failed\n${rc.stderr}');
    }
    final pkgDir = cache.findPackage('$pkg-');
    if (pkgDir == null) {
      _r.error('$pkg package not found in pub cache');
    }
    for (final id in keysByPackage[pkg]!) {
      final file = matrix.fileFor(id);
      final abs = '$projectRoot/lib/scripts/$file';
      await normalizePatch(File(abs));
      await _r.run(pkgDir.path, ['git', 'apply', abs]);
      _r.success('$file -> $pkg');
    }
    applied.add(pkg);
  }

  return applied;
}

// ---------------------------------------------------------------------------
// Task: gen-build-info (writes files, does NOT export env vars)
// ---------------------------------------------------------------------------

/// Resolve the most recent numeric git tag (e.g. `2.1.2.3`), skipping shallow
/// clones where tag history is unavailable.
String? _resolveLastTag() {
  if (File('$projectRoot/.git/shallow').existsSync()) {
    _r.warnLine('shallow clone detected, skipping tag-based versioning');
    return null;
  }
  final r = Process.runSync('git', [
    'describe',
    '--tags',
    '--abbrev=0',
    '--match',
    '[0-9]*',
  ], workingDirectory: projectRoot);
  if (r.exitCode == 0) {
    final t = (r.stdout as String).trim();
    if (t.isNotEmpty) return t;
  }
  return null;
}

/// Write pili_release.json (name/code/hash/time) resolved from --tag, the most
/// recent numeric tag, or the pubspec version fallback. Never exports env vars;
/// optional CI hints are appended to the `$GITHUB_ENV` *file*.
Future<void> genBuildInfo(Map<String, String> opts) async {
  final platform = opts['platform'] ?? '';
  final ci = opts.containsKey('ci');
  final tag = opts['tag'] ?? '';

  final p = projectRoot;
  final count =
      ((await _r.run(p, ['git', 'rev-list', '--count', 'HEAD'])).stdout
              as String)
          .trim();
  final head =
      ((await _r.run(p, ['git', 'rev-parse', 'HEAD'])).stdout as String).trim();

  String versionName, baseVersion;
  if (tag.isNotEmpty) {
    versionName = tag;
    baseVersion = tag;
  } else {
    final lastTag = _resolveLastTag();
    if (lastTag != null) {
      baseVersion = lastTag;
      versionName = lastTag;
    } else {
      final pubspec = File('$p/pubspec.yaml');
      if (pubspec.existsSync()) {
        final m = RegExp(r'^\s*version:\s*([0-9.]+)').firstMatch(
          pubspec
              .readAsStringSync()
              .split('\n')
              .firstWhere(
                (l) => RegExp(r'^\s*version:').hasMatch(l),
                orElse: () => '',
              ),
        );
        final mv = m?.group(1);
        if (mv == null) {
          _r.error('Prebuild Error: version not found');
        } else {
          versionName = mv;
          baseVersion = mv;
          // android builds embed the short commit hash in the version name
          // so installed app metadata stays distinguishable.
          if (platform == 'android') {
            versionName = '$mv-${head.substring(0, 9)}';
          }
        }
      } else {
        _r.error('Prebuild Error: version not found');
      }
    }
  }

  if (ci && platform != 'linux') {
    final parts = baseVersion.split('.');
    var pubspecVer = '${parts[0]}.${parts[1]}.${parts[2]}';
    // normalize a 4-segment version (2.0.7.2) to a valid semver pre-release
    // suffix (2.0.7-2).
    if (parts.length > 3 && parts[3].isNotEmpty) {
      pubspecVer = '$pubspecVer-${parts[3]}';
    }
    _patchPubspecVersion(p, pubspecVer, count);
  }

  final buildTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  final rel = {
    'pili.name': versionName,
    'pili.code': count,
    'pili.hash': head,
    'pili.time': buildTime,
  };
  File('$p/$_piliReleaseJson').writeAsStringSync(
    const JsonEncoder.withIndent(' ').convert(rel),
    flush: true,
  );
  _r.info(
    '== gen-build-info: wrote $_piliReleaseJson '
    'name=$versionName code=$count hash=${head.substring(0, 9)} '
    'time=$buildTime ==',
  );

  final gEnv = Platform.environment['GITHUB_ENV'];
  if (gEnv != null && gEnv.isNotEmpty) {
    final f = File(gEnv);
    final s = StringBuffer()
      ..writeln('version=$versionName+$count')
      ..writeln('version_name=$versionName')
      ..writeln('version_code=$count')
      ..writeln('base_version=$baseVersion');
    f.writeAsStringSync(s.toString(), mode: FileMode.append, flush: true);
  }
}

void _patchPubspecVersion(String p, String ver, String code) {
  final path = '$p/pubspec.yaml';
  final f = File(path);
  if (!f.existsSync()) return;
  final lines = f.readAsLinesSync();
  final out = <String>[];
  var found = false;
  for (final l in lines) {
    if (!found && RegExp(r'^\s*version:\s*[0-9.]+').hasMatch(l)) {
      out.add('version: $ver+$code');
      found = true;
    } else {
      out.add(l);
    }
  }
  if (found) f.writeAsStringSync('${out.join('\n')}\n', flush: true);
}

// ---------------------------------------------------------------------------
// SDK-copy helper (isolated, disposable SDK for local debugging)
// ---------------------------------------------------------------------------

/// Deterministic short hash over every patch input, mirroring the bash version:
/// `git log -1 --format=%H -- <patch paths>`. Any patch/patches.json change
/// yields a fresh copy tag (the tag then embeds this 12-char prefix).
Future<String> _patchesHeadHash() async {
  final r = await _r.run(projectRoot, [
    'git',
    'log',
    '-1',
    '--format=%H',
    '--',
    'lib/scripts/patches.json',
    'lib/scripts/*.patch',
    'lib/scripts/material/*.patch',
    'lib/scripts/cupertino/*.patch',
  ]);
  if (r.exitCode != 0 || (r.stdout as String).trim().isEmpty) {
    _r.error('cannot compute patches head hash');
  }
  return (r.stdout as String).trim();
}

/// Resolve the pristine FVM-managed SDK (source for the copy) from `.fvmrc`.
/// `fvm use` rewrites `.fvmrc.flutter` to a tagged copy name (e.g.
/// `3.47.2-piliplus-linux-p19ff2f8d487d`); strip that suffix to recover the
/// original base version, which never changes.
String? _resolveBaseSdk() {
  final fvmrc = File('$projectRoot/.fvmrc');
  if (!fvmrc.existsSync()) return null;
  final m = RegExp(
    r'^\s*"flutter"\s*:\s*"([^"]+)"',
    multiLine: true,
  ).firstMatch(fvmrc.readAsStringSync());
  if (m == null) return null;
  final re = RegExp(r'(^.*)-piliplus-[^-]+-p[0-9a-f]+$');
  final pinned = re.firstMatch(m.group(1)!)?.group(1) ?? m.group(1)!;
  // On Windows, prefer USERPROFILE (always a native path) over HOME which
  // may be a POSIX path (e.g. /c/Users/...) when invoked from Git Bash or
  // MSYS2.
  String? fvmHome;
  final explicit = Platform.environment['FVM_HOME'];
  if (explicit != null && explicit.isNotEmpty) {
    fvmHome = explicit;
  } else if (Platform.isWindows) {
    final up = Platform.environment['USERPROFILE'];
    if (up != null && up.isNotEmpty) fvmHome = '$up/fvm';
  } else {
    final home = Platform.environment['HOME'];
    if (home != null && home.isNotEmpty) fvmHome = '$home/fvm';
  }
  return '$fvmHome/versions/$pinned';
}

/// Recursively delete a directory tree using Dart's FileSystemEntity, replacing
/// the platform-specific `rm -rf` (absent on default Windows shells).
void _rmTree(String path) {
  final dir = Directory(path);
  if (!dir.existsSync()) return;
  try {
    dir.deleteSync(recursive: true);
  } catch (e) {
    _r.error('failed to remove $path: $e');
  }
}

/// Recursively copy `src` into `dest` with Dart's FileSystemEntity, skipping
/// the `bin/cache` subtree (rebuilt on first run). Replaces the
/// platform-specific `rsync -a --exclude bin/cache`, keeping sdk-copy usable
/// on Windows where neither rsync nor rm are guaranteed on the default shell.
void _copyTree(Directory src, Directory dest) {
  if (!src.existsSync()) return;
  dest.createSync(recursive: true);
  for (final entry in src.listSync(followLinks: false)) {
    final name = entry.path.split(Platform.pathSeparator).last;
    if (name.isEmpty) continue;
    if (name == 'cache' && entry is Directory) {
      final parentName = entry.parent.path.split(Platform.pathSeparator).last;
      if (parentName == 'bin') continue;
    }
    final target = Directory('${dest.path}${Platform.pathSeparator}$name');
    if (entry is Directory) {
      _copyTree(entry, target);
    } else if (entry is File) {
      if (!target.parent.existsSync()) {
        target.parent.createSync(recursive: true);
      }
      entry.copySync(target.path);
    } else if (entry is Link) {
      if (!target.existsSync()) target.createSync(recursive: true);
    }
  }
}

/// Prepare (or reuse) a disposable SDK copy and return its root, or null when
/// `--sdk-copy` was not requested. Mirrors the bash `sdk-copy.sh`: copies the
/// pristine FVM SDK minus `bin/cache`; a ready marker short-circuits to `fvm
/// use` without re-patching. Patching itself happens in the shared
/// `applyPatches` flow so both modes reuse one code path.
Future<String?> _prepareSdkCopy(String platform, bool force) async {
  final src = _resolveBaseSdk();
  if (src == null || !Directory(src).existsSync()) {
    _r.error(
      'cannot resolve pristine SDK from .fvmrc (run `fvm install <ver>` first)',
    );
  }
  final srcName = src.split(Platform.pathSeparator).last;
  final fvmVersions = src.substring(0, src.length - srcName.length - 1);

  final patchHash = await _patchesHeadHash();
  final tag = '$srcName-piliplus-$platform-p${patchHash.substring(0, 12)}';
  final dest = '$fvmVersions/$tag';
  final marker = File('$dest/.sdk-copy-ok');

  // Reuse an already-prepared copy.
  if (!force && Directory(dest).existsSync() && marker.existsSync()) {
    _r.info('SDK copy already prepared: $tag');
    await _r.run(projectRoot, [
      'fvm',
      'use',
      '--skip-pub-get',
      '--skip-setup',
      '--force',
      tag,
    ]);
    stdout.writeln(tag);
    return dest;
  }

  // (Re)create copy. Rebuild when: recreating from scratch (`--force`), or
  // the copy is a broken/interrupted prior run (exists but no marker → partial
  // patches, no fvm switch).
  if (force || !Directory(dest).existsSync() || !marker.existsSync()) {
    _r.info('Creating SDK copy: $dest (from $src)');
    if (Directory(dest).existsSync()) _rmTree(dest);
    _copyTree(Directory(src), Directory(dest));
    _r.info('SDK copied: $dest');
  }

  return dest;
}

// ---------------------------------------------------------------------------
// CLI dispatch
// ---------------------------------------------------------------------------

const String _usage = '''
Usage: dart run lib/scripts/pre_build.dart <subcommand> [options]

Subcommands:
  apply-patches    Apply the SDK/pub patches of --platform (optionally in an
                   isolated SDK copy) and refresh the project pub cache.
  gen-build-info   Write pili_release.json with version/code/hash/timestamp.
  help             Show this help.

Run '<subcommand> --help' for subcommand-specific options.''';

const String _usageApplyPatches = '''
Usage: dart run lib/scripts/pre_build.dart apply-patches [options]

Options:
  --platform <android|ios|linux|macos|windows>
                         Target SDK to patch.
  --sdk-copy             Patch a disposable SDK copy (default: patch in place).
  --force                Rebuild the SDK copy even if it already exists.
  --ci                   Non-interactive mode (confirmations auto-approve).
  --help, -h             Show this help.''';

const String _usageGenBuildInfo = '''
Usage: dart run lib/scripts/pre_build.dart gen-build-info [options]

Options:
  --platform <android|ios|linux|macos|windows>
                         Platform key embedded in pili_release.json.
  --tag <version>        Use an explicit version instead of the latest git tag.
  --ci                   Skip prompts / CI-friendly output.
  --help, -h             Show this help.''';

const Map<String, Set<String>> _flagSpec = {
  'apply-patches': {'platform', 'sdk-copy', 'force', 'ci'},
  'gen-build-info': {'platform', 'tag', 'ci'},
};

const Map<String, Set<String>> _valueFlags = {
  'apply-patches': {'platform'},
  'gen-build-info': {'platform', 'tag'},
};

Map<String, String> _parseFlags(String sub, List<String> rest) {
  final spec = _flagSpec[sub]!;
  final opts = <String, String>{};
  for (var i = 0; i < rest.length; i++) {
    final a = rest[i];
    if (!a.startsWith('--')) {
      _r.error('unexpected argument: $a\n${_usageFor(sub)}');
    }
    final body = a.substring(2);
    if (!spec.contains(body)) {
      _r.error('unknown option: $a\n${_usageFor(sub)}');
    }
    if (_valueFlags[sub]!.contains(body)) {
      if (i + 1 >= rest.length || rest[i + 1].startsWith('--')) {
        _r.error('option $a requires a value\n${_usageFor(sub)}');
      }
      opts[body] = rest[++i];
    } else {
      opts[body] = 'true';
    }
  }
  return opts;
}

String _usageFor(String sub) => switch (sub) {
  'apply-patches' => _usageApplyPatches,
  'gen-build-info' => _usageGenBuildInfo,
  _ => _usage,
};

Future<void> main(List<String> args) async {
  if (args.isEmpty || args.first == 'help' || args.first == '--help') {
    _r.info(_usage);
    exit(0);
  }

  final sub = args.first;
  if (sub != 'apply-patches' && sub != 'gen-build-info') {
    _r.error('unknown subcommand: $sub\n$_usage');
  }

  final rest = args.sublist(1);
  if (rest.contains('--help') || rest.contains('-h')) {
    _r.info(_usageFor(sub));
    exit(0);
  }

  final opts = _parseFlags(sub, rest);
  switch (sub) {
    case 'apply-patches':
      if (rest.isEmpty) {
        _r.error('missing required options\n${_usageFor(sub)}');
      }
      await applyPatches(opts);
    case 'gen-build-info':
      await genBuildInfo(opts);
  }
}
