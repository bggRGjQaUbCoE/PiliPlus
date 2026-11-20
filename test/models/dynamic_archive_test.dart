import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a dynamic archive without bvid or epid keeps a fallback id', () {
    final archive = DynamicArchiveModel.fromJson({'title': 'archive'});

    expect(archive.bvid, ' ');
  });

  test('epid supplies the fallback id when bvid is absent', () {
    final archive = DynamicArchiveModel.fromJson({'epid': 42});

    expect(archive.bvid, '42');
  });
}
