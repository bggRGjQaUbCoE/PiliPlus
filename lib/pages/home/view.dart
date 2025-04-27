import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/models/common/dynamic_badge_mode.dart';
import 'package:PiliPlus/pages/main/index.dart';
import 'package:PiliPlus/pages/mine/controller.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/common/widgets/network_img_layer.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import './controller.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:stream_transform/stream_transform.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final HomeController _homeController = Get.put(HomeController());
  final MainController _mainController = Get.put(MainController());

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(toolbarHeight: 0),
      body: Column(
        children: [
          if (!_homeController.useSideBar &&
              context.orientation == Orientation.portrait)
            customAppBar,
          if (_homeController.tabs.length > 1)
            Material(
              color: Theme.of(context).colorScheme.surface,
              child: Container(
                height: 42,
                padding: const EdgeInsets.only(top: 4),
                child: TabBar(
                  controller: _homeController.tabController,
                  tabs: [
                    for (var i in _homeController.tabs) Tab(text: i['label'])
                  ],
                  isScrollable: true,
                  dividerColor: Colors.transparent,
                  dividerHeight: 0,
                  enableFeedback: true,
                  splashBorderRadius: StyleString.mdRadius,
                  tabAlignment: TabAlignment.center,
                  onTap: (value) {
                    feedBack();
                    if (_homeController.tabController.indexIsChanging.not) {
                      _homeController.animateToTop();
                    }
                  },
                ),
              ),
            )
          else
            const SizedBox(height: 6),
          Expanded(
            child: tabBarView(
              controller: _homeController.tabController,
              children:
                  _homeController.tabs.map<Widget>((e) => e['page']).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget get searchBarAndUser {
    return Row(
      children: [
        searchBar,
        const SizedBox(width: 4),
        Obx(
          () => _homeController.isLogin.value
              ? msgBadge(_mainController)
              : const SizedBox.shrink(),
        ),
        const SizedBox(width: 8),
        Semantics(
          label: "我的",
          child: Obx(
            () => _homeController.isLogin.value
                ? Stack(
                    clipBehavior: Clip.none,
                    children: [
                      NetworkImgLayer(
                        type: 'avatar',
                        width: 34,
                        height: 34,
                        src: _homeController.userFace.value,
                      ),
                      Positioned.fill(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () =>
                                _homeController.showUserInfoDialog(context),
                            splashColor: Theme.of(context)
                                .colorScheme
                                .primaryContainer
                                .withOpacity(0.3),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(50),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: -6,
                        bottom: -6,
                        child: Obx(() => MineController.anonymity.value
                            ? IgnorePointer(
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    size: 16,
                                    MdiIcons.incognito,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink()),
                      ),
                    ],
                  )
                : DefaultUser(
                    onPressed: () =>
                        _homeController.showUserInfoDialog(context),
                  ),
          ),
        ),
      ],
    );
  }

  Widget get customAppBar {
    return StreamBuilder(
      stream: _homeController.hideSearchBar
          ? _mainController.navSearchStreamDebounce
              ? _homeController.searchBarStream?.stream
                  .distinct()
                  .throttle(const Duration(milliseconds: 500))
              : _homeController.searchBarStream?.stream.distinct()
          : null,
      initialData: true,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return AnimatedOpacity(
          opacity: snapshot.data ? 1 : 0,
          duration: const Duration(milliseconds: 300),
          child: AnimatedContainer(
            curve: Curves.easeInOutCubicEmphasized,
            duration: const Duration(milliseconds: 500),
            height: snapshot.data ? 52 : 0,
            padding: const EdgeInsets.fromLTRB(14, 6, 14, 0),
            child: searchBarAndUser,
          ),
        );
      },
    );
  }

  Widget get searchBar {
    return Expanded(
      child: Container(
        height: 44,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Material(
          color: Theme.of(context)
              .colorScheme
              .onSecondaryContainer
              .withOpacity(0.05),
          child: InkWell(
            splashColor:
                Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
            onTap: () => Get.toNamed(
              '/search',
              parameters: {
                if (_homeController.enableSearchWord)
                  'hintText': _homeController.defaultSearch.value,
              },
            ),
            child: Row(
              children: [
                const SizedBox(width: 14),
                Icon(
                  Icons.search_outlined,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  semanticLabel: '搜索',
                ),
                const SizedBox(width: 10),
                if (_homeController.enableSearchWord) ...[
                  Expanded(
                    child: Obx(
                      () => Text(
                        _homeController.defaultSearch.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.outline),
                      ),
                    ),
                  ),
                  const SizedBox(width: 2),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DefaultUser extends StatelessWidget {
  const DefaultUser({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      height: 38,
      child: IconButton(
        tooltip: '默认用户头像',
        style: ButtonStyle(
          padding: WidgetStateProperty.all(EdgeInsets.zero),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            return Theme.of(context).colorScheme.onInverseSurface;
          }),
        ),
        onPressed: onPressed,
        icon: Icon(
          Icons.person_rounded,
          size: 22,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

Widget msgBadge(MainController mainController) {
  void toWhisper() {
    mainController.msgUnReadCount.value = '';
    mainController.lastCheckUnreadAt = DateTime.now().millisecondsSinceEpoch;
    Get.toNamed('/whisper');
  }

  return GestureDetector(
    onTap: toWhisper,
    child: Badge(
      isLabelVisible: mainController.msgBadgeMode != DynamicBadgeMode.hidden &&
          mainController.msgUnReadCount.value.isNotEmpty,
      alignment: mainController.msgBadgeMode == DynamicBadgeMode.number
          ? Alignment(0, -0.5)
          : Alignment(0.5, -0.5),
      label: mainController.msgBadgeMode == DynamicBadgeMode.number &&
              mainController.msgUnReadCount.value.isNotEmpty
          ? Text(mainController.msgUnReadCount.value.toString())
          : null,
      child: IconButton(
        tooltip: '消息',
        onPressed: toWhisper,
        icon: const Icon(
          Icons.notifications_none,
        ),
      ),
    ),
  );
}
