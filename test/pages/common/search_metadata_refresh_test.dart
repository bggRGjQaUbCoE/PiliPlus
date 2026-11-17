import 'package:PiliPlus/models/common/search/search_type.dart';
import 'package:PiliPlus/models/search/result.dart';
import 'package:PiliPlus/pages/search_panel/all/controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('a repeated refresh does not clear visible search user cards while a request is active', () async {
    final controller = SearchAllController(
      keyword: 'Flutter',
      searchType: SearchType.all,
      tag: 'isolated',
    );
    final cards = [SearchUser(mid: 2, uname: '保留内容')];
    controller
      ..searchUser = cards
      ..isLoading = true;
    await controller.onRefresh();
    expect(identical(controller.searchUser, cards), isTrue);
    expect(controller.searchUser!.single.uname, '保留内容');
    controller.onClose();
  });
}
