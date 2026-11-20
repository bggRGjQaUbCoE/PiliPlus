import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/member.dart';
import 'package:PiliPlus/models/common/member/contribute_type.dart';
import 'package:PiliPlus/models_new/space/space_archive/data.dart';
import 'package:PiliPlus/models_new/space/space_archive/item.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';

class MemberComicController
    extends CommonListController<SpaceArchiveData, SpaceArchiveItem> {
  MemberComicController(this.mid);

  final int mid;

  int? count;

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  void checkIsEnd(int length) {
    if (count != null && length >= count!) {
      isEnd = true;
    }
  }

  @override
  List<SpaceArchiveItem>? getDataList(SpaceArchiveData response) {
    count = response.count;
    return response.item;
  }

  @override
  Future<LoadingState<SpaceArchiveData>> customGetData() =>
      MemberHttp.spaceArchive(
        type: ContributeType.comic,
        mid: mid,
        pn: page,
      );
}
