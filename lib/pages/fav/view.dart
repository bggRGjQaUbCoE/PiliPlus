import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:PiliPlus/common/widgets/view_safe_area.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/fav_type.dart';
import 'package:PiliPlus/models_new/fav/fav_folder/list.dart';
import 'package:PiliPlus/pages/fav/article/controller.dart';
import 'package:PiliPlus/pages/fav/cheese/controller.dart';
import 'package:PiliPlus/pages/fav/topic/controller.dart';
import 'package:PiliPlus/pages/fav/video/controller.dart';
import 'package:PiliPlus/pages/fav_folder_sort/view.dart';
import 'package:PiliPlus/utils/extension/scroll_controller_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class FavPage extends StatefulWidget {
  const FavPage({super.key});

  @override
  State<FavPage> createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final FavController _favController = Get.put(FavController());
  late final RxBool _showVideoFavMenu;

  void listener() {
    _showVideoFavMenu.value = _tabController.index == 0;
  }

  @override
  void initState() {
    super.initState();
    int initialIndex = Get.arguments is int ? Get.arguments as int : 0;
    _showVideoFavMenu = (initialIndex == 0).obs;
    _tabController = TabController(
      length: FavTabType.values.length,
      vsync: this,
      initialIndex: initialIndex,
    );
    _tabController.addListener(listener);
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(listener)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('我的收藏'),
        actions: [
          Obx(
            () => _showVideoFavMenu.value
                ? IconButton(
                    onPressed: () => Get.toNamed('/createFav')?.then(
                      (data) {
                        if (data != null) {
                          List<FavFolderInfo>? list =
                              _favController.loadingState.value.isSuccess
                              ? _favController.loadingState.value.data
                              : null;
                          if (list != null && list.isNotEmpty) {
                            list.insert(1, data);
                            _favController.loadingState.refresh();
                          } else {
                            _favController.loadingState.value = Success([data]);
                          }
                        }
                      },
                    ),
                    icon: const Icon(Icons.add),
                    tooltip: '新建收藏夹',
                  )
                : const SizedBox.shrink(),
          ),
          Obx(
            () => _showVideoFavMenu.value
                ? IconButton(
                    onPressed: () {
                      if (_favController.loadingState.value.isSuccess) {
                        if (!_favController.isEnd) {
                          SmartDialog.showToast('加载全部收藏夹再排序');
                          return;
                        }
                        Get.to(
                          FavFolderSortPage(favController: _favController),
                        );
                      }
                    },
                    icon: const Icon(Icons.sort),
                    tooltip: '收藏夹排序',
                  )
                : const SizedBox.shrink(),
          ),
          Obx(
            () => _showVideoFavMenu.value
                ? IconButton(
                    onPressed: () {
                      if (_favController.loadingState.value.isSuccess) {
                        try {
                          final item =
                              _favController.loadingState.value.data!.first;
                          Get.toNamed(
                            '/favSearch',
                            arguments: {
                              'type': 1,
                              'mediaId': item.id,
                              'title': item.title,
                              'count': item.mediaCount,
                              'isOwner': true,
                            },
                          );
                        } catch (_) {}
                      }
                    },
                    icon: const Icon(Icons.search_outlined),
                    tooltip: '搜索',
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(width: 6),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: FavTabType.values.map((item) => Tab(text: item.title)).toList(),
          onTap: (index) {
            try {
              if (!_tabController.indexIsChanging) {
                switch (FavTabType.values[index]) {
                  case FavTabType.video:
                    _favController.scrollController.animToTop();
                  case FavTabType.article:
                    Get.find<FavArticleController>().scrollController
                        .animToTop();
                  case FavTabType.topic:
                    Get.find<FavTopicController>().scrollController.animToTop();
                  case FavTabType.cheese:
                    Get.find<FavCheeseController>().scrollController
                        .animToTop();
                  default:
                }
              }
            } catch (_) {}
          },
        ),
      ),
      body: ViewSafeArea(
        child: tabBarView(
          controller: _tabController,
          children: FavTabType.values.map((item) => item.page).toList(),
        ),
      ),
    );
  }
}
