import 'dart:io' show Platform;

import 'package:jnigen/jnigen.dart';

void main(List<String> args) {
  final packageRoot = Platform.script.resolve('../');
  generateJniBindings(
    Config(
      outputConfig: OutputConfig(
        dartConfig: DartCodeOutputConfig(
          path: packageRoot.resolve('lib/utils/android/bindings.g.dart'),
          structure: .singleFile,
        ),
      ),
      androidSdkConfig: AndroidSdkConfig(addGradleDeps: true),
      sourcePath: [packageRoot.resolve('android/app/src/main/java')],
      classes: [
        'com.example.piliplus.AndroidHelper',
        'java.lang.Runnable',
      ],
    ),
  );
}
