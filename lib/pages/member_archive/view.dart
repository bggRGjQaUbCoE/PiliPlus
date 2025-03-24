import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/common/widgets/video_card_h.dart';
import 'package:PiliPlus/utils/utils.dart';
import '../../common/constants.dart';
import '../../common/widgets/http_error.dart';
import '../../utils/grid.dart';
import 'controller.dart';

class MemberArchivePage extends StatefulWidget {
  const MemberArchivePage({super.key});

  @override
  State<MemberArchivePage> createState() => _MemberArchivePageState();
}

class _MemberArchivePageState extends State<MemberArchivePage> {
  late MemberArchiveController _memberArchivesController;
  late Future _futureBuilderFuture;
  late int mid;

  @override
  void dispose() {
    _memberArchivesController.scrollController.removeListener(listener);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    mid = int.parse(Get.parameters['mid']!);
    final String heroTag = Utils.makeHeroTag(mid);
    _memberArchivesController =
        Get.put(MemberArchiveController(), tag: heroTag);
    _futureBuilderFuture = _memberArchivesController.getMemberArchive('init');
    _memberArchivesController.scrollController.addListener(listener);
  }

  void listener() {
    if (_memberArchivesController.scrollController.position.pixels >=
        _memberArchivesController.scrollController.position.maxScrollExtent -
            200) {
      EasyThrottle.throttle(
          'member_archives', const Duration(milliseconds: 500), () {
        _memberArchivesController.onLoad();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ta的投稿'),
        actions: [
          Obx(
            () => TextButton.icon(
              icon: const Icon(Icons.sort, size: 20),
              onPressed: _memberArchivesController.toggleSort,
              label: Text(_memberArchivesController.currentOrder['label']!),
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _memberArchivesController.scrollController,
        slivers: [
          SliverPadding(
            padding:
                const EdgeInsets.symmetric(horizontal: StyleString.safeSpace),
            sliver: FutureBuilder(
              future: _futureBuilderFuture,
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data != null) {
                    // TODO: refactor
                    if (snapshot.data is! Map) {
                      return HttpError(
                        callback: () => setState(() {
                          _futureBuilderFuture = _memberArchivesController
                              .getMemberArchive('init');
                        }),
                      );
                    }
                    Map data = snapshot.data as Map;
                    final list = _memberArchivesController.archivesList;
                    if (data['status']) {
                      return Obx(
                        () => list.isNotEmpty
                            ? SliverGrid(
                                gridDelegate:
                                    SliverGridDelegateWithExtentAndRatio(
                                  mainAxisSpacing: StyleString.safeSpace,
                                  crossAxisSpacing: StyleString.safeSpace,
                                  maxCrossAxisExtent: Grid.mediumCardWidth * 2,
                                  childAspectRatio:
                                      StyleString.aspectRatio * 2.4,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, index) {
                                    return VideoCardH(
                                      videoItem: list[index],
                                      showOwner: false,
                                      showPubdate: true,
                                    );
                                  },
                                  childCount: list.length,
                                ),
                              )
                            : const SliverToBoxAdapter(),
                      );
                    } else {
                      return HttpError(
                        errMsg: snapshot.data['msg'],
                        callback: () {},
                      );
                    }
                  } else {
                    return HttpError(
                      errMsg: "投稿页出现错误",
                      callback: () {},
                    );
                  }
                } else {
                  return const SliverToBoxAdapter();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
