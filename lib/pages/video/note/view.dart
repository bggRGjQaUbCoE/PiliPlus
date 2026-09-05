import 'dart:io' show Platform;

import 'package:PiliPlus/common/skeleton/video_reply.dart';
import 'package:PiliPlus/common/sliver_single_child_delegate.dart';
import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/scaffold/mini_scaffold.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models_new/video/video_note_list/list.dart';
import 'package:PiliPlus/pages/common/slide/common_slide_page.dart';
import 'package:PiliPlus/pages/video/note/controller.dart';
import 'package:PiliPlus/pages/webview/view.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/bili_utils.dart';
import 'package:PiliPlus/utils/extension/theme_ext.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart' as dww;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class NoteListPage extends CommonSlidePage {
  const NoteListPage({
    super.key,
    super.enableSlide,
    required this.heroTag,
    required this.oid,
    required this.isStein,
    required this.title,
  });

  final String? heroTag;
  final int oid;
  final bool isStein;
  final String? title;

  @override
  State<NoteListPage> createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage>
    with SingleTickerProviderStateMixin, CommonSlideMixin {
  static dww.Webview? _activeNoteWebview;
  static bool _isOpeningNote = false;
  static Object? _dwwOwner;

  void _closeLinuxWebview({bool close = false}) {
    if (close) _activeNoteWebview?.close();
    _activeNoteWebview = null;
    _isOpeningNote = false;
    _dwwOwner = null;
  }

  late final NoteListPageCtr _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(
      NoteListPageCtr(oid: widget.oid),
      tag: widget.heroTag,
    );
  }

  @override
  void dispose() {
    Get.delete<NoteListPageCtr>(tag: widget.heroTag);
    if (_dwwOwner == this) {
      _closeLinuxWebview(close: true);
    }
    super.dispose();
  }

  @override
  Widget buildPage(ThemeData theme) {
    return Material(
      child: MiniScaffold(
        body: Column(
          children: [
            Container(
              height: 45,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.1),
                  ),
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                    child: Obx(() {
                      final count = _controller.count.value;
                      return Text(
                        '笔记${count == -1 ? '' : '($count)'}',
                        style: const TextStyle(fontSize: 16),
                      );
                    }),
                  ),
                  IconButton(
                    tooltip: '关闭',
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: Get.back,
                  ),
                  const SizedBox(width: 2),
                ],
              ),
            ),
            Expanded(child: enableSlide ? slideList(theme) : buildList(theme)),
          ],
        ),
      ),
    );
  }

  late Key _key;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = PrimaryScrollController.of(context);
    _key = ValueKey(controller.hashCode);
  }

  @override
  Widget buildList(ThemeData theme) {
    final child = refreshIndicator(
      onRefresh: _controller.onRefresh,
      child: CustomScrollView(
        key: _key,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const .only(bottom: 100),
            sliver: Obx(
              () => _buildBody(theme, _controller.loadingState.value),
            ),
          ),
        ],
      ),
    );
    if (!Accounts.main.isLogin) {
      return child;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: child),
        Container(
          padding: EdgeInsets.only(
            left: 12,
            right: 12,
            top: 6,
            bottom: MediaQuery.viewPaddingOf(context).bottom + 6,
          ),
          decoration: BoxDecoration(
            color: theme.hoverColor,
            border: Border(
              top: BorderSide(
                width: 0.5,
                color: theme.colorScheme.outline.withValues(alpha: 0.1),
              ),
            ),
          ),
          child: Builder(
            builder: (context) => FilledButton.tonal(
              style: FilledButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
              ),
              onPressed: _onTakeNote,
              child: const Text('开始记笔记'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(
    ThemeData theme,
    LoadingState<List<VideoNoteItemModel>?> loadingState,
  ) {
    switch (loadingState) {
      case Loading():
        return const SliverPrototypeExtentList(
          prototypeItem: VideoReplySkeleton(),
          delegate: SliverSingleChildDelegate(
            count: 8,
            child: VideoReplySkeleton(),
          ),
        );
      case Success(:final response):
        if (response != null && response.isNotEmpty) {
          final divider = Divider(
            height: 1,
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
          );
          return SliverList.separated(
            itemBuilder: (context, index) {
              if (index == response.length - 1) {
                _controller.onLoadMore();
              }
              return _itemWidget(theme, response[index]);
            },
            itemCount: response.length,
            separatorBuilder: (context, index) => divider,
          );
        }
        return HttpError(onReload: _controller.onReload);
      case Error(:final errMsg):
        return HttpError(
          errMsg: errMsg,
          onReload: _controller.onReload,
        );
    }
  }

  Widget _itemWidget(ThemeData theme, VideoNoteItemModel item) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => Get.toNamed(
          '/articlePage',
          parameters: {
            'id': item.cvid!.toString(),
            'type': 'read',
          },
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Get.toNamed('/member?mid=${item.author!.mid}'),
                child: NetworkImgLayer(
                  height: 34,
                  width: 34,
                  src: item.author!.face,
                  type: ImageType.avatar,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () =>
                          Get.toNamed('/member?mid=${item.author!.mid}'),
                      child: Row(
                        children: [
                          Text(
                            item.author!.name!,
                            style: TextStyle(
                              color:
                                  item.author?.vipInfo?.status != null &&
                                      item.author!.vipInfo!.status > 0 &&
                                      item.author!.vipInfo!.type == 2
                                  ? theme.colorScheme.vipColor
                                  : theme.colorScheme.outline,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 6),
                          BiliUtils.levelPicture(
                            item.author!.level!,
                            isSeniorMember: item.author!.isSeniorMember == 1,
                            height: 11,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (item.pubtime != null)
                      Text(
                        item.pubtime!,
                        style: TextStyle(
                          color: theme.colorScheme.outline,
                          fontSize: 12,
                        ),
                      ),
                    if (item.summary != null) ...[
                      const SizedBox(height: 5),
                      Text(
                        item.summary!,
                        style: TextStyle(
                          height: 1.75,
                          fontSize: theme.textTheme.bodyMedium!.fontSize,
                        ),
                      ),
                      Text(
                        '查看全部',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          height: 1.75,
                          fontSize: theme.textTheme.bodyMedium!.fontSize,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onTakeNoteLinux(String url) async {
    if (_activeNoteWebview != null) {
      await _activeNoteWebview?.bringToForeground();
      SmartDialog.showToast('已置顶笔记窗口');
      return;
    }
    if (_isOpeningNote) return;
    _isOpeningNote = true;
    SmartDialog.showToast('已在新窗口打开');
    try {
      var webview = await WebviewPage.openLinux(
        oid: widget.oid,
        title: widget.title,
        url: url,
        onClose: _closeLinuxWebview,
      );
      if (mounted) {
        _activeNoteWebview = webview;
        _dwwOwner = this;
      } else {
        webview?.close();
        webview = null;
      }
    } finally {
      _isOpeningNote = false;
    }
  }

  void _onTakeNote() {
    final url =
        'https://www.bilibili.com/h5/note-app?oid=${widget.oid}&pagefrom=ugcvideo&is_stein_gate=${widget.isStein ? 1 : 0}';
    if (Platform.isLinux) {
      _onTakeNoteLinux(url);
      return;
    }
    MiniScaffold.of(context).showBottomSheet(
      constraints: const BoxConstraints(),
      (context) => WebviewPage(oid: widget.oid, title: widget.title, url: url),
    );
  }
}
