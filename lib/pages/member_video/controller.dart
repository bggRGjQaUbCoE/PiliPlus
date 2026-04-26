import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/member.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/models/common/member/archive_order_type_app.dart';
import 'package:PiliPlus/models/common/member/archive_sort_type_app.dart';
import 'package:PiliPlus/models/common/member/contribute_type.dart';
import 'package:PiliPlus/models/common/video/source_type.dart';
import 'package:PiliPlus/models_new/space/space_archive/data.dart';
import 'package:PiliPlus/models_new/space/space_archive/episodic_button.dart';
import 'package:PiliPlus/models_new/space/space_archive/item.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/utils/extension/iterable_ext.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
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
  }) : isVideo = type == .video;

  final ContributeType type;
  final bool isVideo;
  int? seasonId;
  int? seriesId;
  final int mid;
  late ArchiveOrderTypeApp order = .pubdate;
  late ArchiveSortTypeApp sort = .desc;
  int? count;
  int? next;
  EpisodicButton? episodicButton;
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
    if (isVideo) {
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
    episodicButton = data.episodicButton;
    next = data.next;
    if (page == 0 || isLoadPrevious) {
      hasPrev = data.hasPrev;
    }
    if (page == 0 || !isLoadPrevious) {
      if ((isVideo ? data.hasNext == false : data.next == 0) ||
          data.item.isNullOrEmpty) {
        isEnd = true;
      }
    }
    count = type == .season ? data.item?.length : data.count;
    if (page != 0) {
      if (loadingState.value case Success(:final response)) {
        data.item ??= <SpaceArchiveItem>[];
        if (isLoadPrevious) {
          data.item!.addAll(response!);
        } else {
          data.item!.insertAll(0, response!);
        }
      }
    }
    firstAid = data.item?.firstOrNull?.param;
    lastAid = data.item?.lastOrNull?.param;
    isLoadPrevious = false;
    loadingState.value = Success(data.item);
    return true;
  }

  @override
  Future<LoadingState<SpaceArchiveData>> customGetData() =>
      MemberHttp.spaceArchive(
        type: type,
        mid: mid,
        aid: isVideo
            ? isLoadPrevious
                  ? firstAid
                  : lastAid
            : null,
        order: isVideo ? order : null,
        sort: isVideo
            ? isLoadPrevious
                  ? .asc
                  : null
            : sort,
        pn: type == .charging ? page : null,
        next: next,
        seasonId: seasonId,
        seriesId: seriesId,
        includeCursor: isLocating.value && page == 0,
      );

  void queryBySort() {
    if (isLoading) return;
    if (isVideo) {
      isLocating.value = false;
      order = order == .pubdate ? .click : .pubdate;
    } else {
      sort = sort == .desc ? .asc : .desc;
    }
    onReload();
  }

  Future<void> toViewPlayAll() async {
    final episodicButton = this.episodicButton!;
    if (episodicButton.text == '继续播放' &&
        episodicButton.uri?.isNotEmpty == true) {
      final params = Uri.parse(episodicButton.uri!).queryParameters;
      String? oid = params['oid'];
      if (oid != null) {
        final bvid = IdUtils.av2bv(int.parse(oid));
        final res = await SearchHttp.ab2cWithDimension(aid: oid, bvid: bvid);
        final cid = res?.cid;
        if (cid != null) {
          PageUtils.toVideoPage(
            aid: int.parse(oid),
            bvid: bvid,
            cid: cid,
            dimension: res!.dimension,
            extraArguments: {
              'sourceType': SourceType.archive,
              'mediaId': seasonId ?? seriesId ?? mid,
              'oid': oid,
              'favTitle':
                  '$username: ${title ?? episodicButton.text ?? '播放全部'}',
              if (seriesId == null) 'count': ?count,
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

    if (loadingState.value case Success(:final response)) {
      if (response == null || response.isEmpty) return;

      for (SpaceArchiveItem element in response) {
        if (element.cid == null) {
          continue;
        } else {
          bool desc = seasonId != null ? false : true;
          desc =
              (seasonId != null || seriesId != null) &&
                  (isVideo ? order == .click : sort == .asc)
              ? !desc
              : desc;
          bool isVertical = false;
          if (element.uri case final uri?) {
            isVertical = Utils.getDimensionFromUri(uri);
          }
          PageUtils.toVideoPage(
            bvid: element.bvid,
            cid: element.cid!,
            cover: element.cover,
            title: element.title,
            isVertical: isVertical,
            extraArguments: {
              'sourceType': SourceType.archive,
              'mediaId': seasonId ?? seriesId ?? mid,
              'oid': IdUtils.bv2av(element.bvid!),
              'favTitle':
                  '$username: ${title ?? episodicButton.text ?? '播放全部'}',
              if (seriesId == null) 'count': ?count,
              if (seasonId != null || seriesId != null)
                'mediaType': Uri.parse(
                  episodicButton.uri!,
                ).queryParameters['page_type'],
              'desc': desc,
              if (isVideo) 'sortField': order == .click ? 2 : 1,
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
