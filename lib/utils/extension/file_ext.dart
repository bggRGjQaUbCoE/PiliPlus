import 'dart:io' show FileSystemEntity, Directory;

extension FileSystemEntityExt on FileSystemEntity {
  Future<void> tryDel({bool recursive = false}) =>
      delete(recursive: recursive).catchError((_) => this);
}

extension DirectoryExt on Directory {
  Future<bool> lengthGte(int length) async {
    int count = 0;
    await for (final _ in list()) {
      if (++count == length) return true;
    }
    return false;
  }
}
