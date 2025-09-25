import 'dart:io';

void main() async {
  if (Platform.isWindows || Platform.isLinux) {
    updateVersion();
  }

  final buildTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  String commitHash = '';
  try {
    final result = await Process.run('git', ['rev-parse', 'HEAD']);
    commitHash = result.stdout.toString().trim();
  } catch (_) {}
  final content =
      '''
class BuildConfig {
  static const int buildTime = $buildTime;
  static const String commitHash = '$commitHash';
}
''';
  final file = File('lib/build_config.dart');
  await file.writeAsString(content);
}

Future<void> updateVersion() async {
  final file = File('pubspec.yaml');
  final lines = await file.readAsLines();

  final versionLineIndex = lines.indexWhere(
    (line) => line.trim().startsWith('version:'),
  );
  if (versionLineIndex == -1) {
    exit(1);
  }

  final versionName = lines[versionLineIndex]
      .split('+')[0]
      .replaceAll('version:', '')
      .trim();
  final commitCount = await Process.run('git', [
    'rev-list',
    '--count',
    'HEAD',
  ]);
  final buildNumber = commitCount.stdout.toString().trim();

  lines[versionLineIndex] = 'version: $versionName+$buildNumber';
  await file.writeAsString(lines.join('\n'));
}
