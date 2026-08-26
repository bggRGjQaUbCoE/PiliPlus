import 'package:PiliPlus/utils/storage.dart';

typedef CdnDiagnosticGroup = ({
  int runStartedAtUs,
  int recordedAtUs,
  List<Map<String, dynamic>> records,
});

abstract final class CdnDiagnosticsService {
  // Manual CDN diagnostics are intentionally append-only with no age/count/size
  // pruning. Records live until the user explicitly deletes test groups or
  // clears app data/storage.
  static const _prefix = 'cdnDiagnostic:';
  static int _sequence = 0;

  static Future<void> append(Map<String, dynamic> record) async {
    final now = DateTime.now().microsecondsSinceEpoch;
    final key = '$_prefix$now:${_sequence++}';
    try {
      await GStorage.video.put(key, record);
    } catch (_) {
      // 诊断记录失败绝不能反过来影响测速本身。
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

  static List<CdnDiagnosticGroup> groupedSnapshot() {
    final grouped = <int, List<Map<String, dynamic>>>{};
    for (final record in snapshot()) {
      final run = (record['testRunStartedAtUs'] as num?)?.toInt() ??
          (record['recordedAtUs'] as num?)?.toInt() ??
          0;
      (grouped[run] ??= []).add(record);
    }
    final groups = <CdnDiagnosticGroup>[
      for (final entry in grouped.entries)
        (
          runStartedAtUs: entry.key,
          recordedAtUs: entry.value
              .map((record) => (record['recordedAtUs'] as num?)?.toInt() ?? 0)
              .fold(0, (a, b) => a > b ? a : b),
          records: entry.value,
        ),
    ];
    groups.sort((a, b) => b.runStartedAtUs.compareTo(a.runStartedAtUs));
    return groups;
  }

  static Future<void> deleteRuns(Set<int> runStartedAtUs) async {
    if (runStartedAtUs.isEmpty) return;
    final keys = <dynamic>[];
    for (final key in GStorage.video.keys) {
      if (key is! String || !key.startsWith(_prefix)) continue;
      final value = GStorage.video.get(key);
      if (value is! Map) continue;
      final run = (value['testRunStartedAtUs'] as num?)?.toInt() ??
          (value['recordedAtUs'] as num?)?.toInt() ??
          0;
      if (runStartedAtUs.contains(run)) keys.add(key);
    }
    if (keys.isNotEmpty) await GStorage.video.deleteAll(keys);
  }
}
