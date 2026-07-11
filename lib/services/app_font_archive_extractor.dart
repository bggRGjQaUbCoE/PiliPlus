import 'package:archive/archive_io.dart';

abstract final class AppFontArchiveExtractor {
  static void extract(Map<String, String?> args) {
    final input = InputFileStream(args['archivePath']!);
    try {
      final archive = ZipDecoder().decodeStream(input);

      void extractEntry(String entryName, String outputPath) {
        final entry = archive.findFile(entryName);
        if (entry == null || !entry.isFile) {
          throw StateError('压缩包中缺少所需文件');
        }
        final output = OutputFileStream(outputPath);
        try {
          entry.writeContent(output);
        } finally {
          output.closeSync();
        }
      }

      extractEntry(args['entryName']!, args['outputPath']!);
      final licenseEntryName = args['licenseEntryName'];
      if (licenseEntryName != null) {
        extractEntry(licenseEntryName, args['licenseOutputPath']!);
      }
    } finally {
      input.closeSync();
    }
  }
}
