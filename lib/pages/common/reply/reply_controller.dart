import 'dart:math' show ln2, log, max, min;

import 'package:PiliPlus/common/widgets/colored_box_transition.dart';
import 'package:PiliPlus/common/widgets/flutter/text_field/controller.dart';
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show MainListReply, ReplyInfo, SubjectControl, Mode, CursorReply;
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/reply.dart';
import 'package:PiliPlus/models/common/reply/reply_sort_type.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_mention/item.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/pages/common/publish/publish_route.dart';
import 'package:PiliPlus/pages/video/reply_new/view.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/reply_scheme_helper.dart';
import 'package:PiliPlus/utils/reply_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:collection/collection.dart';
import 'package:fixnum/fixnum.dart' show Int64;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

mixin MainReplyLocateMixin on ReplyLocateMixin<MainListReply> {
  final Map args = Get.arguments ?? const {};

  Int64? targetRootRpId; // highlight
  void clearTargetRootRpId() {
    args.remove(rootRpIdKey);
    targetRootRpId = null;
  }

  @override
  void onInit() {
    if (args[rootRpIdKey] case final int rpid) {
      rootRpId = Int64(rpid);
    }
    super.onInit();
  }

  @override
  bool customHandleResponse(bool isRefresh, Success<MainListReply> response) {
    final flag = super.customHandleResponse(isRefresh, response);
    if (isRefresh && rootRpId != null && args.containsKey(rootRpIdKey)) {
      final replies = response.response.replies;
      final rootReply = replies.firstWhereOrNull((e) => e.id == rootRpId);
      if (rootReply != null) {
        onAnimRootReply(rootReply);
      }
    }
    return flag;
  }

  void onAnimRootReply(ReplyInfo rootReply) {
    targetRootRpId = rootRpId;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => colorAnimController
          .forward(from: 0)
          .whenComplete(clearTargetRootRpId),
    );
  }
}

mixin ReplyLocateMixin<T>
    on ReplyController<T>, GetSingleTickerProviderStateMixin {
  AnimationController? _animController;
  bool get hasAnimController => _animController != null;
  AnimationController get colorAnimController =>
      _animController ??= AnimationController(
        duration: const Duration(milliseconds: 1000),
        vsync: this,
      );

  Animation<Color?>? _colorAnim;
  Animation<Color?> colorAnim(ColorScheme colorScheme) =>
      _colorAnim ??= colorAnimController.drive(
        ColorTween(
          begin: colorScheme.onInverseSurface,
          end: colorScheme.surface,
        ).chain(CurveTween(curve: const Interval(0.8, 1.0))),
      );

  Widget colorAnimWrapper(ColorScheme colorScheme, Widget child) =>
      ColoredBoxTransition(color: colorAnim(colorScheme), child: child);

  @override
  void didChangeDependencies(BuildContext context) {
    super.didChangeDependencies(context);
    _colorAnim = null;
  }

  @override
  void onClose() {
    _colorAnim = null;
    _animController?.dispose();
    _animController = null;
    super.onClose();
  }
}

abstract class ReplyController<R> extends CommonListController<R, ReplyInfo> {
  ReplyController({int count = -1}) : count = RxInt(count);

  int get oid;
  int get replyType;

  Int64? rootRpId;
  late final RxInt count;

  late final Rx<ReplySortType> sortType;
  late Mode mode;

  final savedReplies = <Object, List<RichTextItem>?>{};

  Int64? upMid;
  String? nextOffset;
  SubjectControl? subjectControl;
  late bool hasUpTop = false;

  @override
  bool get hasFooter => true;

  // comment antifraud
  late final _enableCommAntifraud = Pref.enableCommAntifraud;
  late final _biliSendCommAntifraud = Pref.biliSendCommAntifraud;
  bool get enableCommAntifraud =>
      _enableCommAntifraud || _biliSendCommAntifraud;
  dynamic get sourceId;

  ReplySortType get prefSortType => Pref.replySortType;

  @override
  void onInit() {
    super.onInit();
    var cacheSortType = prefSortType;
    if (cacheSortType == .classic && !supportsClassic) {
      cacheSortType = .hot;
    }
    sortType = cacheSortType.obs;
    mode = cacheSortType == .hot ? Mode.MAIN_LIST_HOT : Mode.MAIN_LIST_TIME;
  }

  // ---- 经典: a few hot replies first, then all replies by time ----

  /// Only the top level comment list offers the classic layout.
  bool get supportsClassic => this is ReplyController<MainListReply>;

  bool get isClassic => sortType.value == ReplySortType.classic;

  /// Upper bound of hot replies shown before "更多热门评论" (setting).
  late final int classicHotCount = Pref.classicHotReplyCount;

  /// Hot replies shown for a comment area of [total] comments, at most
  /// [cap]: none while everything fits on one page, then one more each time
  /// the area doubles (1 from 20 comments, 2 from 40, 3 from 80, ...).
  static int classicHotCountFor(int total, int cap) {
    if (total < 20 || cap <= 0) return 0;
    return min(cap, max(1, (log(total / 10) / ln2 + 1e-9).floor()));
  }

  /// Hot replies shown before "更多热门评论" in this area.
  int get classicHotLimit => classicHotCountFor(count.value, classicHotCount);

  /// Loaded hot replies worth showing: a reply nobody liked is not hot.
  List<ReplyInfo> get classicHotCandidates =>
      classicHot.where((e) => e.like > Int64.ZERO).toList();

  /// Hot replies currently shown in the head (reads reactive state).
  List<ReplyInfo> get classicHotShown {
    if (!isClassic) return const [];
    final limit = classicHotLimit;
    if (limit == 0) return const [];
    final hot = classicHotCandidates;
    return classicHotExpanded.value ? hot : hot.take(limit).toList();
  }

  /// Indices of the by-time list to show in the classic layout, leaving out
  /// replies already shown in the head; null shows the whole list.
  List<int>? classicListIndices(List<ReplyInfo> list) {
    if (!isClassic) return null;
    final ids = {
      for (final e in classicHotShown) e.id,
      ?classicUpTop.value?.id,
    };
    if (ids.isEmpty) return null;
    return [
      for (var i = 0; i < list.length; i++)
        if (!ids.contains(list[i].id)) i,
    ];
  }

  final classicHot = RxList<ReplyInfo>();
  final classicUpTop = Rxn<ReplyInfo>();
  final classicHotExpanded = false.obs;
  final classicHotLoading = false.obs;
  bool classicHotEnd = true;
  String? _classicHotOffset;

  void _clearClassic() {
    classicHot.clear();
    classicUpTop.value = null;
    classicHotExpanded.value = false;
    classicHotEnd = true;
    _classicHotOffset = null;
  }

  /// Requests a page of hot replies without touching the paging state of the
  /// main (by time) list.
  Future<MainListReply?> _fetchHotPage(String? offset) async {
    final savedMode = mode;
    final savedOffset = nextOffset;
    mode = Mode.MAIN_LIST_HOT;
    nextOffset = offset;
    try {
      final res = await customGetData();
      if (res case Success(:final response)) {
        final data = response as MainListReply;
        _removeIntro(data);
        final next = data.paginationReply.nextOffset;
        classicHotEnd = data.cursor.isEnd || next.isEmpty || next == offset;
        _classicHotOffset = next;
        return data;
      }
      return null;
    } finally {
      mode = savedMode;
      nextOffset = savedOffset;
    }
  }

  @override
  Future<void> queryData([bool isRefresh = true]) async {
    if (isRefresh && !isLoading) {
      if (isClassic) {
        isLoading = true;
        final data = await _fetchHotPage(null);
        isLoading = false;
        classicHotExpanded.value = false;
        classicHot.assignAll(data?.replies ?? const []);
      } else {
        _clearClassic();
      }
    }
    return super.queryData(isRefresh);
  }

  /// "更多热门评论": expand the loaded hot replies, then load more pages.
  Future<void> onClassicHotMore() async {
    if (!classicHotExpanded.value) {
      classicHotExpanded.value = true;
      if (classicHotCandidates.length > classicHotLimit || classicHotEnd) {
        return;
      }
    }
    if (classicHotEnd || classicHotLoading.value) return;
    classicHotLoading.value = true;
    final data = await _fetchHotPage(_classicHotOffset);
    classicHotLoading.value = false;
    if (data != null && isClassic) {
      final ids = {for (final e in classicHot) e.id};
      classicHot.addAll(data.replies.where((e) => ids.add(e.id)));
    }
  }

  void onClassicHotCollapse() => classicHotExpanded.value = false;

  /// Removes a reply shown in the classic head (pinned or hot).
  void onRemoveClassic(ReplyInfo item, int? subIndex) {
    if (subIndex == null) {
      if (identical(classicUpTop.value, item)) {
        classicUpTop.value = null;
      } else {
        classicHot.remove(item);
      }
    } else {
      item
        ..count -= 1
        ..replies.removeAt(subIndex);
      classicHot.refresh();
      classicUpTop.refresh();
    }
    count.value -= 1;
  }

  @override
  bool get endIfNullOrEmpty => false;

  @override
  void checkIsEnd(int length) {
    final count = this.count.value;
    if (count != -1 && length >= count) {
      isEnd = true;
    }
  }

  late final _filterIntro = Pref.filterIntro;
  String? intro;
  @pragma('vm:prefer-inline')
  void _removeIntro(MainListReply data) {
    final intro = this.intro;
    if (intro != null &&
        intro.isNotEmpty &&
        _filterIntro &&
        data.replies.isNotEmpty) {
      data.replies.removeWhere((i) => i.content.message.trim() == intro);
    }
  }

  @override
  bool customHandleResponse(bool isRefresh, Success<R> response) {
    final data = response.response as MainListReply;
    count.value = data.subjectControl.count.toInt();
    if (isRefresh) {
      handleSubjectControl(data.subjectControl);
      if (isClassic) {
        // the pinned reply leads the classic head, above the hot replies
        hasUpTop = false;
        classicUpTop.value = data.hasUpTop() ? data.upTop : null;
      } else if (hasUpTop = data.hasUpTop()) {
        data.replies.insert(0, data.upTop);
      }
      if (subjectControl?.title == ReplySortType.select.desc) {
        sortType.value = .select;
      }
    }

    handlePagination(
      cursor: data.cursor,
      offset: data.paginationReply.nextOffset,
    );

    _removeIntro(data);

    return false;
  }

  void handlePagination({required CursorReply cursor, required String offset}) {
    if (cursor.isEnd || offset.isEmpty || nextOffset == offset) isEnd = true;
    nextOffset = offset;
  }

  void handleSubjectControl(SubjectControl control) {
    subjectControl = control;
    upMid = control.upMid;
  }

  @override
  Future<void> onRefresh() {
    nextOffset = null;
    subjectControl = null;
    return super.onRefresh();
  }

  // 排序搜索评论
  void queryBySort() {
    if (isLoading) return;
    switch (sortType.value) {
      case ReplySortType.time:
        sortType.value = ReplySortType.hot;
        mode = Mode.MAIN_LIST_HOT;
        break;
      case ReplySortType.hot:
        sortType.value = supportsClassic
            ? ReplySortType.classic
            : ReplySortType.time;
        mode = Mode.MAIN_LIST_TIME;
        break;
      case ReplySortType.classic:
        sortType.value = ReplySortType.time;
        mode = Mode.MAIN_LIST_TIME;
        break;
      case ReplySortType.select:
        return;
    }
    feedBack();
    onReload();
  }

  (bool inputDisable, String? hint) get replyHint {
    String? hint;
    bool inputDisable = false;
    try {
      if (subjectControl case final subjectControl?) {
        inputDisable = subjectControl.inputDisable;
        if (subjectControl.hasRootText()) {
          final rootText = subjectControl.rootText;
          if (inputDisable) {
            SmartDialog.showToast(rootText);
          }
          if (rootText.contains('可发') || rootText.contains('可见')) {
            hint = rootText;
          }
        }
      }
    } catch (_) {}
    return (inputDisable, hint);
  }

  void onReply(
    ReplyInfo? replyItem, {
    int? oid,
    int? replyType,
    MentionItem? mentionItem,
  }) {
    if (loadingState.value case Error(:final errMsg, :final code)) {
      if (errMsg != null && (code == 12061 || code == 12002)) {
        SmartDialog.showToast(errMsg);
        return;
      }
    }

    assert(replyItem != null || (oid != null && replyType != null));

    final (bool inputDisable, String? hint) = replyHint;
    if (inputDisable) {
      return;
    }

    final key = oid ?? replyItem!.oid + replyItem.id;
    Get.key.currentState!
        .push(
          PublishRoute(
            pageBuilder: (buildContext, animation, secondaryAnimation) {
              return ReplyPage(
                hint: hint,
                oid: oid ?? replyItem!.oid.toInt(),
                root: oid != null ? 0 : replyItem!.id.toInt(),
                parent: oid != null ? 0 : replyItem!.id.toInt(),
                replyType: replyItem?.type.toInt() ?? replyType!,
                replyItem: replyItem,
                mentionItem: mentionItem,
                items: savedReplies[key],

                /// hd api deprecated
                // canUploadPic: canUploadPic,
                onSave: (reply) {
                  if (reply.isEmpty) {
                    savedReplies.remove(key);
                  } else {
                    savedReplies[key] = reply.toList();
                  }
                },
              );
            },
            settings: RouteSettings(arguments: Get.arguments),
          ),
        )
        .then(
          (replyInfo) {
            if (replyInfo is ReplyInfo) {
              savedReplies.remove(key);
              if (loadingState.value case Success(:final response)) {
                if (response == null) {
                  loadingState.value = Success([replyInfo]);
                } else {
                  if (oid != null) {
                    response.insert(hasUpTop ? 1 : 0, replyInfo);
                  } else {
                    replyItem!
                      ..count += 1
                      ..replies.add(replyInfo);
                  }
                  loadingState.refresh();
                }
              } else {
                loadingState.value = Success([replyInfo]);
              }
              count.value += 1;

              // check reply
              if (enableCommAntifraud) {
                onCheckReply(replyInfo, isManual: false);
              }
            }
          },
        );
  }

  void onRemove(int index, ReplyInfo item, int? subIndex) {
    if (subIndex == null) {
      loadingState.value.data!.removeAt(index);
    } else {
      item
        ..count -= 1
        ..replies.removeAt(subIndex);
    }
    count.value -= 1;
    loadingState.refresh();
  }

  void onCheckReply(ReplyInfo replyInfo, {bool isManual = true}) {
    ReplyUtils.onCheckReply(
      replyInfo: replyInfo,
      biliSendCommAntifraud: _biliSendCommAntifraud,
      sourceId: sourceId,
      isManual: isManual,
    );
  }

  Future<void> onToggleTop(
    ReplyInfo item,
    int index,
    oid,
    int type,
  ) async {
    bool isUpTop = item.replyControl.isUpTop;
    final res = await ReplyHttp.replyTop(
      oid: oid,
      type: type,
      rpid: item.id,
      isUpTop: isUpTop,
    );
    if (res.isSuccess) {
      item.replyControl.isUpTop = !isUpTop;
      if (isClassic) {
        // the pinned reply lives in the classic head, not in the list
        if (!isUpTop) {
          classicUpTop.value?.replyControl.isUpTop = false;
          classicUpTop.value = item;
        } else if (identical(classicUpTop.value, item)) {
          classicUpTop.value = null;
        }
        classicUpTop.refresh();
      } else if (!isUpTop && index != 0) {
        final list = loadingState.value.data!;
        list
          ..first.replyControl.isUpTop = false
          ..insert(0, list.removeAt(index));
      }
      loadingState.refresh();
      SmartDialog.showToast('${isUpTop ? '取消' : ''}置顶成功');
    } else {
      res.toast();
    }
  }

  @override
  void onClose() {
    savedReplies.clear();
    super.onClose();
  }
}
