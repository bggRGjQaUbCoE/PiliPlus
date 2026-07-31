class StorageVolume {
  final String path;
  final String name;
  final bool isRemovable;
  final int totalBytes;
  final int availableBytes;

  const StorageVolume({
    required this.path,
    required this.name,
    required this.isRemovable,
    required this.totalBytes,
    required this.availableBytes,
  });

  factory StorageVolume.fromMap(Map<dynamic, dynamic> m) => StorageVolume(
        path: m['path'] as String,
        name: m['name'] as String,
        isRemovable: m['isRemovable'] as bool,
        totalBytes: m['totalBytes'] as int,
        availableBytes: m['availableBytes'] as int,
      );

  String get availableLabel => '${formatBytes(availableBytes)} / ${formatBytes(totalBytes)}';
}

String formatBytes(int bytes) {
  if (bytes <= 0) return '0 B';
  const units = ['B', 'KB', 'MB', 'GB', 'TB'];
  var size = bytes.toDouble();
  var i = 0;
  while (size >= 1024 && i < units.length - 1) {
    size /= 1024;
    i++;
  }
  return i == 0 ? '${size.toInt()} ${units[i]}' : '${size.toStringAsFixed(1)} ${units[i]}';
}
