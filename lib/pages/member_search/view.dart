import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:PiliPlus/common/widgets/view_safe_area.dart';
import 'package:PiliPlus/models/common/member/search_type.dart';
import 'package:PiliPlus/pages/member_search/child/view.dart';
import 'package:PiliPlus/pages/member_search/controller.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemberSearchPage extends StatefulWidget {
  const MemberSearchPage({super.key});

  @override
  State<MemberSearchPage> createState() => _MemberSearchPageState();
}

class _MemberSearchPageState extends State<MemberSearchPage> {
  final _controller = Get.put(
    MemberSearchController(),
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
          onChanged: (value) {
            if (value.isEmpty) {
              _controller.hasData.value = false;
            }
          },
        ),
      ),
      body: ViewSafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Obx(() {
              return Opacity(
                opacity: _controller.hasData.value ? 1 : 0,
                child: Column(
                  children: [
                    TabBar(
                      controller: _controller.tabController,
                      tabs: [
                        Obx(
                          () => Tab(
                            text:
                                '视频 ${_controller.counts[0] != -1 ? _controller.counts[0] : ''}',
                          ),
                        ),
                        Obx(
                          () => Tab(
                            text:
                                '动态 ${_controller.counts[1] != -1 ? _controller.counts[1] : ''}',
                          ),
                        ),
                      ],
                      onTap: (index) {
                        if (!_controller.tabController.indexIsChanging) {
                          if (index == 0) {
                            _controller.arcCtr.animateToTop();
                          } else {
                            _controller.dynCtr.animateToTop();
                          }
                        }
                      },
                    ),
                    Expanded(
                      child: tabBarView(
                        controller: _controller.tabController,
                        children: [
                          MemberSearchChildPage(
                            controller: _controller.arcCtr,
                            searchType: MemberSearchType.archive,
                          ),
                          MemberSearchChildPage(
                            controller: _controller.dynCtr,
                            searchType: MemberSearchType.dynamic,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
            Obx(
              () => _controller.hasData.value
                  ? const SizedBox.shrink()
                  : Align(
                      alignment: const Alignment(0, -0.5),
                      child: Text(
                        '搜索「${_controller.uname}」的动态、视频',
                        textAlign: TextAlign.center,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
