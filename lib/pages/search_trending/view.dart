import 'dart:math';

import 'package:PiliPlus/common/widgets/list_tile.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/search/search_trending/list.dart';
import 'package:PiliPlus/pages/search_trending/controller.dart';
import 'package:PiliPlus/utils/context_ext.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide ListTile;
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:get/get.dart' hide ContextExtensionss;

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
    final theme = Theme.of(context);
    final padding = MediaQuery.viewPaddingOf(context);
    final size = context.mediaQuerySize;
    final maxWidth = size.width - padding.horizontal;
    final width = size.isPortrait ? maxWidth : min(640.0, maxWidth * 0.6);
    final height = width * 528 / 1125;
    _offset = height - 56 - padding.top;
    listener();
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Obx(
          () {
            final scrollRatio = _scrollRatio.value;
            final flag = maxWidth > width || scrollRatio >= 0.5;
            return AppBar(
              title: Opacity(
                opacity: scrollRatio,
                child: Text(
                  'bilibili热搜',
                  style: TextStyle(
                    color: flag ? null : Colors.white,
                  ),
                ),
              ),
              backgroundColor: theme.colorScheme.surface.withValues(
                alpha: scrollRatio,
              ),
              foregroundColor: flag ? null : Colors.white,
              systemOverlayStyle: flag
                  ? null
                  : const SystemUiOverlayStyle(
                      statusBarBrightness: Brightness.dark,
                      statusBarIconBrightness: Brightness.light,
                    ),
              shape: scrollRatio == 1
                  ? Border(
                      bottom: BorderSide(
                        color: theme.colorScheme.outline.withValues(
                          alpha: 0.1,
                        ),
                      ),
                    )
                  : null,
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: padding.left,
          right: padding.right,
        ),
        child: Center(
          child: SizedBox(
            width: width,
            child: refreshIndicator(
              onRefresh: _controller.onRefresh,
              child: CustomScrollView(
                controller: _controller.scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Image.asset(
                      width: width,
                      height: height,
                      'assets/images/trending_banner.png',
                      filterQuality: FilterQuality.low,
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(bottom: padding.bottom + 100),
                    sliver: Obx(
                      () => _buildBody(theme, _controller.loadingState.value),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    ThemeData theme,
    LoadingState<List<SearchTrendingItemModel>?> loadingState,
  ) {
    late final divider = Divider(
      height: 1,
      indent: 48,
      color: theme.colorScheme.outline.withValues(alpha: 0.1),
    );
    return switch (loadingState) {
      Loading() => linearLoading,
      Success(:var response) =>
        response?.isNotEmpty == true
            ? SliverList.separated(
                itemCount: response!.length,
                itemBuilder: (context, index) {
                  final item = response[index];
                  return ListTile(
                    dense: true,
                    onTap: () => Get.toNamed(
                      '/searchResult',
                      parameters: {
                        'keyword': item.keyword!,
                      },
                    ),
                    leading: index < _controller.topCount
                        ? const Icon(
                            size: 17,
                            Icons.vertical_align_top_outlined,
                            color: Color(0xFFd1403e),
                          )
                        : Text(
                            '${index + 1 - _controller.topCount}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: switch (index - _controller.topCount) {
                                0 => const Color(0xFFfdad13),
                                1 => const Color(0xFF8aace1),
                                2 => const Color(0xFFdfa777),
                                _ => theme.colorScheme.outline,
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
                            strutStyle: const StrutStyle(height: 1, leading: 0),
                            style: const TextStyle(height: 1, fontSize: 15),
                          ),
                        ),
                        if (item.icon?.isNotEmpty == true) ...[
                          const SizedBox(width: 4),
                          CachedNetworkImage(
                            imageUrl: ImageUtils.thumbnailUrl(item.icon!),
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
                separatorBuilder: (context, index) => divider,
              )
            : HttpError(onReload: _controller.onReload),
      Error(:var errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _controller.onReload,
      ),
    };
  }
}
