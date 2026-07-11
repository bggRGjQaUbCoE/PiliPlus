import 'dart:io';
import 'dart:typed_data';

import 'package:PiliPlus/services/app_font_archive_extractor.dart';
import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('extracts the selected font and license entries', () {
    final directory = Directory.systemTemp.createTempSync(
      'piliplus-font-test-',
    );
    addTearDown(() => directory.deleteSync(recursive: true));

    final fontBytes = Uint8List.fromList([1, 2, 3, 4]);
    final licenseBytes = Uint8List.fromList([5, 6, 7]);
    final archive = Archive()
      ..addFile(ArchiveFile('fonts/font.ttf', fontBytes.length, fontBytes))
      ..addFile(
        ArchiveFile('fonts/LICENSE.txt', licenseBytes.length, licenseBytes),
      );
    final archivePath = '${directory.path}/font.zip';
    File(archivePath).writeAsBytesSync(ZipEncoder().encode(archive));

    final fontPath = '${directory.path}/font.ttf';
    final licensePath = '${directory.path}/LICENSE.txt';
    AppFontArchiveExtractor.extract({
      'archivePath': archivePath,
      'entryName': 'fonts/font.ttf',
      'outputPath': fontPath,
      'licenseEntryName': 'fonts/LICENSE.txt',
      'licenseOutputPath': licensePath,
    });

    expect(File(fontPath).readAsBytesSync(), fontBytes);
    expect(File(licensePath).readAsBytesSync(), licenseBytes);
  });

  test('rejects an archive without the requested font', () {
    final directory = Directory.systemTemp.createTempSync(
      'piliplus-font-test-',
    );
    addTearDown(() => directory.deleteSync(recursive: true));

    final archivePath = '${directory.path}/font.zip';
    File(archivePath).writeAsBytesSync(ZipEncoder().encode(Archive()));

    expect(
      () => AppFontArchiveExtractor.extract({
        'archivePath': archivePath,
        'entryName': 'missing.ttf',
        'outputPath': '${directory.path}/font.ttf',
        'licenseEntryName': null,
        'licenseOutputPath': null,
      }),
      throwsStateError,
    );
  });
}
