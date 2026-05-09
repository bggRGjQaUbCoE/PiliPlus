import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/fav_order_type.dart';
import 'package:PiliPlus/models/common/video/source_type.dart';
import 'package:PiliPlus/models_new/fav/fav_detail/data.dart';
import 'package:PiliPlus/models_new/fav/fav_detail/media.dart';
import 'package:PiliPlus/models_new/video/video_detail/data.dart';
import 'package:PiliPlus/models_new/video/video_detail/page.dart' show Part;
import 'package:PiliPlus/pages/common/multi_select/base.dart';
import 'package:PiliPlus/pages/common/search/common_search_controller.dart';
import 'package:PiliPlus/pages/fav_detail/controller.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:collection/collection.dart';
import 'package:get/get.dart';

class FavSearchController
    extends CommonSearchController<FavDetailData, FavDetailItemModel>
    with
        CommonMultiSelectMixin<FavDetailItemModel>,
        DeleteItemMixin,
        BaseFavController {
  late int type;
  @override
  late int mediaId;
  @override
  late bool isOwner;
  late dynamic count;
  late dynamic title;

  late final enablePlayAll = Pref.enablePlayAll;

  @override
  void onInit() {
    final args = Get.arguments;
    type = args['type'];
    mediaId = args['mediaId'];
    isOwner = args['isOwner'];
    count = args['count'];
    title = args['title'];
    super.onInit();
  }

  final Rx<FavOrderType> order = FavOrderType.mtime.obs;

  @override
  Future<LoadingState<FavDetailData>> customGetData() =>
      FavHttp.userFavFolderDetail(
        pn: page,
        ps: 20,
        mediaId: mediaId,
        keyword: editController.text,
        type: type,
        order: order.value,
      );

  @override
  List<FavDetailItemModel>? getDataList(FavDetailData response) {
    if (response.hasMore == false) {
      isEnd = true;
    }
    return response.medias;
  }

  @override
  Future<void> onViewFav(FavDetailItemModel item, int? index) async {
    final cid = item.ugc!.firstCid!;
    Part? part;
    VideoDetailData? videoIntro;
    final res = await VideoHttp.videoIntro(bvid: item.bvid!);
    if (res case Success(:final response)) {
      videoIntro = response;
      part = response.pages?.firstWhereOrNull((e) => e.cid == cid);
    }
    PageUtils.toVideoPage(
      bvid: item.bvid,
      cid: item.ugc!.firstCid!,
      cover: item.cover,
      title: item.title,
      dimension: part?.dimension,
      extraArguments: enablePlayAll
          ? {
              'videoIntro': videoIntro,
              'sourceType': SourceType.fav,
              'mediaId': mediaId,
              'oid': item.id,
              'favTitle': title,
              'count': count,
              'desc': true,
              'isContinuePlaying': true,
            }
          : {'videoIntro': videoIntro},
    );
  }
}
