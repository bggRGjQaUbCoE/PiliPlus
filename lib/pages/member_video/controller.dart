import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/member.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/models/common/member/contribute_type.dart';
import 'package:PiliPlus/models/common/video/source_type.dart';
import 'package:PiliPlus/models_new/space/space_archive/data.dart';
import 'package:PiliPlus/models_new/space/space_archive/episodic_button.dart';
import 'package:PiliPlus/models_new/space/space_archive/item.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:get/get.dart';

class MemberVideoCtr
    extends CommonListController<SpaceArchiveData, SpaceArchiveItem>
    with ReloadMixin {
  MemberVideoCtr({
    required this.type,
    required this.mid,
    required this.seasonId,
    required this.seriesId,
    this.username,
    this.title,
  });

  ContributeType type;
  int? seasonId;
  int? seriesId;
  final int mid;
  late RxString order = 'pubdate'.obs;
  late RxString sort = 'desc'.obs;
  RxInt count = (-1).obs;
  int? next;
  Rx<EpisodicButton> episodicButton = EpisodicButton().obs;
  final String? username;
  final String? title;

  String? firstAid;
  String? lastAid;
  String? fromViewAid;
  RxBool isLocating = false.obs;
  bool isLoadPrevious = false;
  bool? hasPrev;

  @override
  Future<void> onRefresh() async {
    if (isLocating.value) {
      if (hasPrev == true) {
        isLoadPrevious = true;
        await queryData();
      }
    } else {
      isLoadPrevious = false;
      firstAid = null;
      lastAid = null;
      next = null;
      isEnd = false;
      page = 0;
      await queryData();
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (type == ContributeType.video) {
      fromViewAid = Get.parameters['from_view_aid'];
    }
    page = 0;
    queryData();
  }

  @override
  bool customHandleResponse(
    bool isRefresh,
    Success<SpaceArchiveData> response,
  ) {
    final data = response.response;
    episodicButton
      ..value = data.episodicButton ?? EpisodicButton()
      ..refresh();
    next = data.next;
    if (page == 0 || isLoadPrevious) {
      hasPrev = data.hasPrev;
    }
    if (page == 0 || !isLoadPrevious) {
      if ((type == ContributeType.video
              ? data.hasNext == false
              : data.next == 0) ||
          data.item.isNullOrEmpty) {
        isEnd = true;
      }
    }
    count.value = type == ContributeType.season
        ? (data.item?.length ?? -1)
        : (data.count ?? -1);
    if (page != 0 && loadingState.value.isSuccess) {
      data.item ??= <SpaceArchiveItem>[];
      if (isLoadPrevious) {
        data.item!.addAll(loadingState.value.data!);
      } else {
        data.item!.insertAll(0, loadingState.value.data!);
      }
    }
    firstAid = data.item?.firstOrNull?.param;
    lastAid = data.item?.lastOrNull?.param;
    loadingState.value = Success(data.item);
    return true;
  }

  @override
  Future<LoadingState<SpaceArchiveData>> customGetData() =>
      MemberHttp.spaceArchive(
        type: type,
        mid: mid,
        aid: type == ContributeType.video
            ? isLoadPrevious
                  ? firstAid
                  : lastAid
            : null,
        order: type == ContributeType.video ? order.value : null,
        sort: type == ContributeType.video
            ? isLoadPrevious
                  ? 'asc'
                  : null
            : sort.value,
        pn: type == ContributeType.charging ? page : null,
        next: next,
        seasonId: seasonId,
        seriesId: seriesId,
        includeCursor: isLocating.value && page == 0,
      );

  void queryBySort() {
    if (type == ContributeType.video) {
      isLocating.value = false;
      order.value = order.value == 'pubdate' ? 'click' : 'pubdate';
    } else {
      sort.value = sort.value == 'desc' ? 'asc' : 'desc';
    }
    onReload();
  }

  Future<void> toViewPlayAll() async {
    final episodicButton = this.episodicButton.value;
    if (episodicButton.text == '继续播放' &&
        episodicButton.uri?.isNotEmpty == true) {
      final params = Uri.parse(episodicButton.uri!).queryParameters;
      String? oid = params['oid'];
      if (oid != null) {
        var bvid = IdUtils.av2bv(int.parse(oid));
        var cid = await SearchHttp.ab2c(aid: oid, bvid: bvid);
        if (cid != null) {
          PageUtils.toVideoPage(
            aid: int.parse(oid),
            bvid: bvid,
            cid: cid,
            extraArguments: {
              'sourceType': SourceType.archive,
              'mediaId': seasonId ?? seriesId ?? mid,
              'oid': oid,
              'favTitle':
                  '$username: ${title ?? episodicButton.text ?? '播放全部'}',
              if (seriesId == null) 'count': count.value,
              if (seasonId != null || seriesId != null)
                'mediaType': params['page_type'],
              'desc': params['desc'] == '1',
              'sortField': params['sort_field'],
              'isContinuePlaying': true,
            },
          );
        }
      }
      return;
    }

    if (loadingState.value.isSuccess) {
      List<SpaceArchiveItem>? list = loadingState.value.data;

      if (list.isNullOrEmpty) return;

      for (SpaceArchiveItem element in list!) {
        if (element.cid == null) {
          continue;
        } else {
          bool desc = seasonId != null ? false : true;
          desc =
              (seasonId != null || seriesId != null) &&
                  (type == ContributeType.video
                      ? order.value == 'click'
                      : sort.value == 'asc')
              ? !desc
              : desc;
          PageUtils.toVideoPage(
            bvid: element.bvid,
            cid: element.cid!,
            cover: element.cover,
            title: element.title,
            extraArguments: {
              'sourceType': SourceType.archive,
              'mediaId': seasonId ?? seriesId ?? mid,
              'oid': IdUtils.bv2av(element.bvid!),
              'favTitle':
                  '$username: ${title ?? episodicButton.text ?? '播放全部'}',
              if (seriesId == null) 'count': count.value,
              if (seasonId != null || seriesId != null)
                'mediaType': Uri.parse(
                  episodicButton.uri!,
                ).queryParameters['page_type'],
              'desc': desc,
              if (type == ContributeType.video)
                'sortField': order.value == 'click' ? 2 : 1,
            },
          );
          break;
        }
      }
    }
  }

  @override
  Future<void> onReload() {
    reload = true;
    isLocating.value = false;
    return super.onReload();
  }
}
