import 'dart:async' show FutureOr;
import 'dart:io' show File;

import 'package:PiliPlus/utils/extension/file_ext.dart';

typedef TemporaryFileDelete = FutureOr<void> Function(String path);

Future<T> withTemporaryFileCleanup<T>({
  required String path,
  required FutureOr<T> Function() action,
  TemporaryFileDelete? delete,
}) async {
  try {
    return await action();
  } finally {
    await (delete ?? _deleteTemporaryFile)(path);
  }
}

Future<void> _deleteTemporaryFile(String path) => File(path).tryDel();
