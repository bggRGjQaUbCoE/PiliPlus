import 'dart:io';

void main(Iterable<String> args) async {
  final pubspecFile = File('pubspec.yaml');
  final lines = await pubspecFile.readAsLines();

  final versionLineIndex = lines.indexWhere(
    (line) => line.trim().startsWith('version:'),
  );

  String versionName = lines[versionLineIndex]
      .split('+')[0]
      .replaceAll('version:', '')
      .trim();

  final commitHash = (await Process.run('git', [
    'rev-parse',
    'HEAD',
  ])).stdout.toString().trim();

  if (args.isNotEmpty) {
    versionName += '-${commitHash.substring(0, 9)}';
  }

  final versionCode = (await Process.run('git', [
    'rev-list',
    '--count',
    'HEAD',
  ])).stdout.toString().trim();

  lines[versionLineIndex] = 'version: $versionName+$versionCode';

  final buildTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  final content =
      '''
class BuildConfig {
  static const int versionCode = $versionCode;
  static const String versionName = '$versionName';

  static const int buildTime = $buildTime;
  static const String commitHash = '$commitHash';
}
''';

  pubspecFile.writeAsString(lines.join('\n'));
  File('lib/build_config.dart').writeAsString(content);
}
