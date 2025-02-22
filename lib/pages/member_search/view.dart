import 'package:PiliPlus/pages/member_search/search_archive.dart';
import 'package:PiliPlus/pages/member_search/search_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';
import 'package:PiliPlus/common/widgets/spring_physics.dart';

class MemberSearchPage extends StatefulWidget {
  const MemberSearchPage({super.key});

  @override
  State<MemberSearchPage> createState() => _MemberSearchPageState();
}

class _MemberSearchPageState extends State<MemberSearchPage> {
  final _memberSearchCtr = Get.put(MemberSearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: '搜索',
            onPressed: _memberSearchCtr.submit,
            icon: const Icon(Icons.search, size: 22),
          ),
          const SizedBox(width: 10)
        ],
        title: TextField(
          autofocus: true,
          focusNode: _memberSearchCtr.searchFocusNode,
          controller: _memberSearchCtr.textEditingController,
          textInputAction: TextInputAction.search,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: '搜索',
            border: InputBorder.none,
            suffixIcon: IconButton(
              tooltip: '清空',
              icon: const Icon(Icons.clear, size: 22),
              onPressed: _memberSearchCtr.onClear,
            ),
          ),
          onSubmitted: (value) => _memberSearchCtr.submit(),
          onChanged: (value) {
            if (value.isEmpty) {
              _memberSearchCtr.hasData.value = false;
            }
          },
        ),
      ),
      body: Obx(
        () => _memberSearchCtr.hasData.value
            ? Column(
                children: [
                  Obx(
                    () => TabBar(
                      controller: _memberSearchCtr.tabController,
                      tabs: [
                        Tab(
                            text:
                                '视频 ${_memberSearchCtr.archiveCount.value != -1 ? '${_memberSearchCtr.archiveCount.value}' : ''}'),
                        Tab(
                            text:
                                '动态 ${_memberSearchCtr.dynamicCount.value != -1 ? '${_memberSearchCtr.dynamicCount.value}' : ''}'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      physics: customTabBarViewScrollPhysics,
                      controller: _memberSearchCtr.tabController,
                      children: [
                        SearchArchive(ctr: _memberSearchCtr),
                        SearchDynamic(ctr: _memberSearchCtr),
                      ],
                    ),
                  ),
                ],
              )
            : FractionallySizedBox(
                heightFactor: 0.5,
                widthFactor: 1.0,
                child: Center(
                  child: Text('搜索「${_memberSearchCtr.uname.value}」的动态、视频'),
                ),
              ),
      ),
    );
  }
}
