import 'package:PiliPlus/utils/storage.dart';

abstract final class CdnDiagnosticsService {
  static const _prefix = 'cdnDiagnostic:';
  static int _sequence = 0;

  static Future<void> append(Map<String, dynamic> record) async {
    final now = DateTime.now().microsecondsSinceEpoch;
    final key = '$_prefix$now:${_sequence++}';
    try {
      await GStorage.video.put(key, record);
    } catch (_) {
      // Diagnostics must never interfere with the speed test itself.
    }
  }

  static List<Map<String, dynamic>> snapshot() {
    final records = <Map<String, dynamic>>[];
    for (final key in GStorage.video.keys) {
      if (key is! String || !key.startsWith(_prefix)) continue;
      final value = GStorage.video.get(key);
      if (value is Map) {
        records.add(
          value.map((key, value) => MapEntry(key.toString(), value)),
        );
      }
    }
    records.sort(
      (a, b) => ((b['recordedAtUs'] as num?) ?? 0).compareTo(
        (a['recordedAtUs'] as num?) ?? 0,
      ),
    );
    return records;
  }
}
