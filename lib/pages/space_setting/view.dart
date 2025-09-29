import 'dart:math';

import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/space_setting/privacy.dart';
import 'package:PiliPlus/pages/space_setting/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SpaceSettingPage extends StatefulWidget {
  const SpaceSettingPage({super.key});

  @override
  State<SpaceSettingPage> createState() => _SpaceSettingPageState();
}

class _SpaceSettingPageState extends State<SpaceSettingPage> {
  final _controller = Get.put(SpaceSettingController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('空间设置')),
      body: Obx(() => _buildBody(theme, _controller.loadingState.value)),
    );
  }

  @override
  void dispose() {
    _controller.onMod();
    super.dispose();
  }

  Widget _buildBody(ThemeData theme, LoadingState<Privacy?> loadingState) {
    return switch (loadingState) {
      Loading() => const SizedBox.shrink(),
      Success<Privacy?>(:var response) =>
        response == null
            ? scrollErrorWidget(onReload: _controller.onReload)
            : Builder(
                builder: (context) {
                  final padding = MediaQuery.viewPaddingOf(context);
                  final divider = Divider(
                    height: 1,
                    indent: max(16, padding.left),
                    color: theme.colorScheme.outline.withValues(alpha: 0.1),
                  );
                  final dividerL = SliverToBoxAdapter(
                    child: Divider(
                      height: 12,
                      thickness: 12,
                      color: theme.colorScheme.outline.withValues(alpha: 0.1),
                    ),
                  );
                  return CustomScrollView(
                    slivers: [
                      dividerL,
                      SliverList.separated(
                        itemCount: response.list1.length,
                        itemBuilder: (context, index) {
                          return _item(response.list1[index]);
                        },
                        separatorBuilder: (context, index) => divider,
                      ),
                      dividerL,
                      SliverList.separated(
                        itemCount: response.list2.length,
                        itemBuilder: (context, index) {
                          return _item(response.list2[index]);
                        },
                        separatorBuilder: (context, index) => divider,
                      ),
                      dividerL,
                      SliverList.separated(
                        itemCount: response.list3.length,
                        itemBuilder: (context, index) {
                          return _item(response.list3[index]);
                        },
                        separatorBuilder: (context, index) => divider,
                      ),
                      dividerL,
                      SliverToBoxAdapter(
                        child: SizedBox(height: padding.bottom + 100),
                      ),
                    ],
                  );
                },
              ),
      Error(:var errMsg) => scrollErrorWidget(
        errMsg: errMsg,
        onReload: _controller.onReload,
      ),
    };
  }

  Widget _item(SpaceSettingModel item) {
    return Builder(
      builder: (context) {
        void onChanged([bool? value]) {
          _controller.hasMod ??= true;

          value ??= !item.boolVal;
          item.value = item.isReverse
              ? value
                    ? 0
                    : 1
              : value
              ? 1
              : 0;
          (context as Element).markNeedsBuild();
        }

        return ListTile(
          dense: true,
          onTap: onChanged,
          title: Text(
            item.name,
            style: const TextStyle(fontSize: 14),
          ),
          trailing: Transform.scale(
            alignment: Alignment.centerRight,
            scale: 0.8,
            child: Switch(
              value: item.boolVal,
              onChanged: onChanged,
            ),
          ),
        );
      },
    );
  }
}
