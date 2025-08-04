import 'package:PiliPlus/common/widgets/appbar/appbar.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/common_search_controller.dart';
import 'package:PiliPlus/pages/common/multi_select_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class CommonSearchPage extends StatefulWidget {
  const CommonSearchPage({super.key});
}

abstract class CommonSearchPageState<S extends CommonSearchPage, R, T>
    extends State<S> {
  CommonSearchController<R, T> get controller;

  List<Widget>? get extraActions => null;

  List<Widget>? get multiSelectChildren => null;

  @override
  Widget build(BuildContext context) {
    if (controller case MultiSelectBase multiCtr) {
      return Obx(() {
        final enableMultiSelect = multiCtr.enableMultiSelect.value;
        return PopScope(
          canPop: !enableMultiSelect,
          onPopInvokedWithResult: (didPop, result) {
            if (enableMultiSelect) {
              multiCtr.handleSelect();
            }
          },
          child: _build(true),
        );
      });
    }
    return _build(false);
  }

  Widget _build(bool multiSelect) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildBar(multiSelect),
      body: SafeArea(
        top: false,
        bottom: false,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: controller.scrollController,
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.paddingOf(context).bottom + 80,
              ),
              sliver: Obx(() => _buildBody(controller.loadingState.value)),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildBar(bool multiSelect) {
    final AppBar bar = AppBar(
      actions: [
        IconButton(
          tooltip: '搜索',
          onPressed: controller.onRefresh,
          icon: const Icon(Icons.search_outlined, size: 22),
        ),
        ...?extraActions,
        const SizedBox(width: 10),
      ],
      title: TextField(
        autofocus: true,
        focusNode: controller.focusNode,
        controller: controller.editController,
        textInputAction: TextInputAction.search,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: '搜索',
          border: InputBorder.none,
          suffixIcon: IconButton(
            tooltip: '清空',
            icon: const Icon(Icons.clear, size: 22),
            onPressed: () => controller
              ..loadingState.value = LoadingState.loading()
              ..onClear()
              ..focusNode.requestFocus(),
          ),
        ),
        onSubmitted: (value) => controller.onRefresh(),
      ),
    );
    if (multiSelect) {
      return MultiSelectAppBarWidget(
        ctr: controller as MultiSelectBase,
        children: multiSelectChildren,
        child: bar,
      );
    }
    return bar;
  }

  Widget _buildBody(LoadingState<List<T>?> loadingState) {
    return switch (loadingState) {
      Loading() => const HttpError(),
      Success(:var response) =>
        response?.isNotEmpty == true
            ? buildList(response!)
            : HttpError(
                onReload: controller.onReload,
              ),
      Error(:var errMsg) => HttpError(
        errMsg: errMsg,
        onReload: controller.onReload,
      ),
    };
  }

  Widget buildList(List<T> list);
}
