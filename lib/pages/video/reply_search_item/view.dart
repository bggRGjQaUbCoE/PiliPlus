import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:PiliPlus/common/widgets/view_safe_area.dart';
import 'package:PiliPlus/models/common/reply/reply_search_type.dart';
import 'package:PiliPlus/pages/video/reply_search_item/child/view.dart';
import 'package:PiliPlus/pages/video/reply_search_item/controller.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReplySearchPage extends StatefulWidget {
  const ReplySearchPage({
    super.key,
    required this.type,
    required this.oid,
  });

  final int type;
  final int oid;

  @override
  State<ReplySearchPage> createState() => _ReplySearchPageState();
}

class _ReplySearchPageState extends State<ReplySearchPage> {
  late final _controller = Get.put(
    ReplySearchController(widget.type, widget.oid),
    tag: Utils.generateRandomString(8),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: '搜索',
            onPressed: _controller.submit,
            icon: const Icon(Icons.search, size: 22),
          ),
          const SizedBox(width: 10),
        ],
        title: TextField(
          autofocus: true,
          focusNode: _controller.focusNode,
          controller: _controller.editingController,
          textInputAction: TextInputAction.search,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: '搜索',
            border: InputBorder.none,
            suffixIcon: IconButton(
              tooltip: '清空',
              icon: const Icon(Icons.clear, size: 22),
              onPressed: _controller.onClear,
            ),
          ),
          onSubmitted: (value) => _controller.submit(),
        ),
      ),
      body: ViewSafeArea(
        child: Column(
          children: [
            TabBar(
              controller: _controller.tabController,
              tabs: const [
                Tab(text: '视频'),
                Tab(text: '专栏'),
              ],
              onTap: (index) {
                if (!_controller.tabController.indexIsChanging) {
                  if (index == 0) {
                    _controller.videoCtr.animateToTop();
                  } else {
                    _controller.articleCtr.animateToTop();
                  }
                }
              },
            ),
            Expanded(
              child: tabBarView(
                controller: _controller.tabController,
                children: [
                  ReplySearchChildPage(
                    controller: _controller.videoCtr,
                    searchType: ReplySearchType.video,
                  ),
                  ReplySearchChildPage(
                    controller: _controller.articleCtr,
                    searchType: ReplySearchType.article,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
