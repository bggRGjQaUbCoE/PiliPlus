import 'dart:math';

import 'package:PiliPlus/common/widgets/http_error.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/search/search_trending/trending_list.dart';
import 'package:PiliPlus/pages/search_trending/controller.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SearchTrendingPage extends StatefulWidget {
  const SearchTrendingPage({super.key});

  @override
  State<SearchTrendingPage> createState() => _SearchTrendingPageState();
}

class _SearchTrendingPageState extends State<SearchTrendingPage> {
  final _controller = Get.put(
    SearchTrendingController(),
    tag: Get.parameters['tag'],
  );

  late double _offset;
  final RxDouble _scrollRatio = 0.0.obs;

  @override
  void initState() {
    super.initState();
    _controller.scrollController.addListener(listener);
  }

  @override
  void dispose() {
    _controller.scrollController.removeListener(listener);
    super.dispose();
  }

  void listener() {
    if (_controller.scrollController.hasClients) {
      _scrollRatio.value = clampDouble(
        _controller.scrollController.position.pixels / _offset,
        0.0,
        1.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      final width = constraints.maxWidth > constraints.maxHeight
          ? min(640.0, maxWidth * 0.6)
          : maxWidth;
      _offset = width * 528 / 1125 - 56 - Get.mediaQuery.padding.top;
      listener();
      final removePadding = maxWidth > width;
      return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Obx(
            () {
              final flag = removePadding || _scrollRatio.value >= 0.5;
              return AppBar(
                title: Opacity(
                  opacity: _scrollRatio.value,
                  child: Text(
                    'B站热搜',
                    style: TextStyle(
                      color: flag ? null : Colors.white,
                    ),
                  ),
                ),
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .surface
                    .withOpacity(_scrollRatio.value),
                foregroundColor: flag ? null : Colors.white,
                systemOverlayStyle: flag
                    ? null
                    : SystemUiOverlayStyle(
                        statusBarBrightness: Brightness.dark,
                        statusBarIconBrightness: Brightness.light,
                      ),
                bottom: _scrollRatio.value == 1
                    ? PreferredSize(
                        preferredSize: Size.fromHeight(1),
                        child: Divider(
                          height: 1,
                          color: Theme.of(context)
                              .colorScheme
                              .outline
                              .withOpacity(0.1),
                        ),
                      )
                    : null,
              );
            },
          ),
        ),
        body: Center(
          child: SizedBox(
            width: width,
            child: MediaQuery.removePadding(
              context: context,
              removeLeft: removePadding,
              removeRight: removePadding,
              child: refreshIndicator(
                onRefresh: () async {
                  await _controller.onRefresh();
                },
                child: CustomScrollView(
                  controller: _controller.scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: CachedNetworkImage(
                        fit: BoxFit.fitWidth,
                        fadeInDuration: const Duration(milliseconds: 120),
                        fadeOutDuration: const Duration(milliseconds: 120),
                        imageUrl:
                            'https://activity.hdslb.com/blackboard/activity59158/img/hot_banner.fbb081df.png',
                        placeholder: (context, url) {
                          return AspectRatio(
                            aspectRatio: 1125 / 528,
                            child: Image.asset('assets/images/loading.png'),
                          );
                        },
                      ),
                    ),
                    Obx(() => _buildBody(_controller.loadingState.value)),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildBody(LoadingState<List<SearchKeywordList>?> loadingState) {
    return switch (loadingState) {
      Loading() => SliverToBoxAdapter(child: LinearProgressIndicator()),
      Success() => loadingState.response?.isNotEmpty == true
          ? SliverPadding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.paddingOf(context).bottom + 100),
              sliver: SliverList.separated(
                itemCount: loadingState.response!.length,
                itemBuilder: (context, index) {
                  final item = loadingState.response![index];
                  return ListTile(
                    dense: true,
                    onTap: () {
                      Get.toNamed(
                        '/searchResult',
                        parameters: {
                          'keyword': item.keyword!,
                        },
                      );
                    },
                    leading: index < _controller.topCount
                        ? Icon(
                            size: 17,
                            Icons.vertical_align_top_outlined,
                            color: const Color(0xFFd1403e),
                          )
                        : Text(
                            '${index + 1 - _controller.topCount}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: switch (index - _controller.topCount) {
                                0 => const Color(0xFFfdad13),
                                1 => const Color(0xFF8aace1),
                                2 => const Color(0xFFdfa777),
                                _ => Theme.of(context).colorScheme.outline,
                              },
                              fontSize: 17,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                    title: Row(
                      children: [
                        Flexible(
                          child: Text(
                            item.keyword!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            strutStyle: StrutStyle(height: 1, leading: 0),
                            style: TextStyle(height: 1, fontSize: 15),
                          ),
                        ),
                        if (item.icon?.isNotEmpty == true) ...[
                          const SizedBox(width: 4),
                          CachedNetworkImage(
                            imageUrl: Utils.thumbnailImgUrl(item.icon!),
                            height: 16,
                          ),
                        ] else if (item.showLiveIcon == true) ...[
                          const SizedBox(width: 4),
                          Image.asset(
                            'assets/images/live/live.gif',
                            width: 51,
                            height: 16,
                          ),
                        ],
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  indent: 48,
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                ),
              ),
            )
          : HttpError(
              onReload: _controller.onReload,
            ),
      Error() => HttpError(
          errMsg: loadingState.errMsg,
          onReload: _controller.onReload,
        ),
    };
  }
}
