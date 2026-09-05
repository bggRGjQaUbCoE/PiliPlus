import 'dart:io' show Platform;

import 'package:jnigen/jnigen.dart';

void main(List<String> args) async {
  final packageRoot = Platform.script.resolve('../');
  final generator = JniGenerator(
    input: Input(
      sourcePath: [packageRoot.resolve('android/app/src/main/java')],
      classes: [
        'com.example.piliplus.AndroidHelper',
        'java.lang.Runnable',
      ],
      androidSdk: AndroidSdk(
        addGradleDeps: true,
        androidExample: packageRoot,
      ),
    ),
    output: Output(
      dart: DartOutput(
        path: packageRoot.resolve('lib/utils/android/bindings.g.dart'),
        structure: .singleFile,
      ),
    ),
  );
  await generator.generate();
}
