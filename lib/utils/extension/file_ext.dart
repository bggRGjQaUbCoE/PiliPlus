import 'dart:io';

extension FileSystemEntityExt on FileSystemEntity {
  Future<void> tryDel({bool recursive = false}) async {
    try {
      await delete(recursive: recursive);
    } catch (_) {}
  }
}

extension DirectoryExt on Directory {
  Future<bool> lengthGte(int length) async {
    int count = 0;
    await for (var _ in list()) {
      if (++count == length) return true;
    }
    return false;
  }
}
