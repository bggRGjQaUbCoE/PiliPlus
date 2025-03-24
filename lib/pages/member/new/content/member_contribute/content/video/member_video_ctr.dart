import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/member.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/models/space_archive/data.dart';
import 'package:PiliPlus/models/space_archive/episodic_button.dart';
import 'package:PiliPlus/models/space_archive/item.dart';
import 'package:PiliPlus/pages/common/common_controller.dart';
import 'package:PiliPlus/pages/member/new/content/member_contribute/member_contribute.dart'
    show ContributeType;
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class MemberVideoCtr extends CommonController {
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
  String? aid;
  late RxString order = 'pubdate'.obs;
  late RxString sort = 'desc'.obs;
  RxInt count = (-1).obs;
  int? next;
  Rx<EpisodicButton> episodicButton = EpisodicButton().obs;
  final String? username;
  final String? title;

  @override
  Future onRefresh() async {
    aid = null;
    next = null;
    currentPage = 0;
    isEnd = false;
    await queryData();
  }

  @override
  void onInit() {
    super.onInit();
    currentPage = 0;
    queryData();
  }

  @override
  bool customHandleResponse(Success response) {
    Data data = response.response;
    episodicButton.value = data.episodicButton ?? EpisodicButton();
    episodicButton.refresh();
    next = data.next;
    aid = data.item?.lastOrNull?.param;
    if ((type == ContributeType.video
            ? data.hasNext == false
            : data.next == 0) ||
        data.item.isNullOrEmpty) {
      isEnd = true;
    }
    count.value = type == ContributeType.season
        ? (data.item?.length ?? -1)
        : (data.count ?? -1);
    if (currentPage != 0 && loadingState.value is Success) {
      data.item ??= <Item>[];
      data.item!.insertAll(0, (loadingState.value as Success).response);
    }
    loadingState.value = LoadingState.success(data.item);
    return true;
  }

  @override
  Future<LoadingState> customGetData() => MemberHttp.spaceArchive(
        type: type,
        mid: mid,
        aid: type == ContributeType.video ? aid : null,
        order: type == ContributeType.video ? order.value : null,
        sort: type == ContributeType.video ? null : sort.value,
        pn: type == ContributeType.charging ? currentPage : null,
        next: next,
        seasonId: seasonId,
        seriesId: seriesId,
      );

  queryBySort() {
    if (type == ContributeType.video) {
      order.value = order.value == 'pubdate' ? 'click' : 'pubdate';
    } else {
      sort.value = sort.value == 'desc' ? 'asc' : 'desc';
    }
    onReload();
  }

  void toViewPlayAll() async {
    if (loadingState.value is Success) {
      List<Item> list = (loadingState.value as Success).response;

      if (episodicButton.value.text == '继续播放') {
        dynamic oid = RegExp(r'oid=([\d]+)')
            .firstMatch('${episodicButton.value.uri}')
            ?.group(1);
        dynamic bvid = IdUtils.av2bv(int.tryParse(oid) ?? 0);
        dynamic cid = await SearchHttp.ab2c(aid: oid, bvid: bvid);
        Utils.toViewPage(
          'bvid=$bvid&cid=$cid',
          arguments: {
            'heroTag': Utils.makeHeroTag(oid),
            'sourceType': 'archive',
            'mediaId': seasonId ?? seriesId ?? mid,
            'oid': oid,
            'favTitle':
                '$username: ${title ?? episodicButton.value.text ?? '播放全部'}',
            if (seriesId == null) 'count': count.value,
            if (seasonId != null || seriesId != null)
              'mediaType': RegExp(r'page_type=([\d]+)')
                  .firstMatch('${episodicButton.value.uri}')
                  ?.group(1),
            'desc': RegExp(r'desc=([\d]+)')
                    .firstMatch('${episodicButton.value.uri}')
                    ?.group(1) ==
                '1',
            'sortField': RegExp(r'sort_field=([\d]+)')
                .firstMatch('${episodicButton.value.uri}')
                ?.group(1),
            'isContinuePlaying': true,
          },
        );
        return;
      }

      for (Item element in list) {
        if (element.cid == null) {
          continue;
        } else {
          if (element.bvid != list.first.bvid) {
            SmartDialog.showToast('已跳过不支持播放的视频');
          }
          bool desc = seasonId != null ? false : true;
          desc = (seasonId != null || seriesId != null) &&
                  (type == ContributeType.video
                      ? order.value == 'click'
                      : sort.value == 'asc')
              ? desc.not
              : desc;
          Utils.toViewPage(
            'bvid=${element.bvid}&cid=${element.cid}',
            arguments: {
              'videoItem': element,
              'heroTag': Utils.makeHeroTag(element.bvid),
              'sourceType': 'archive',
              'mediaId': seasonId ?? seriesId ?? mid,
              'oid': IdUtils.bv2av(element.bvid!),
              'favTitle':
                  '$username: ${title ?? episodicButton.value.text ?? '播放全部'}',
              if (seriesId == null) 'count': count.value,
              if (seasonId != null || seriesId != null)
                'mediaType': RegExp(r'page_type=([\d]+)')
                    .firstMatch('${episodicButton.value.uri}')
                    ?.group(1),
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
}
