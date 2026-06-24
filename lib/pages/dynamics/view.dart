import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/dynamic/dynamics_type.dart';
import 'package:PiliPlus/models/dynamics/up.dart';
import 'package:PiliPlus/pages/dynamics/controller.dart';
import 'package:PiliPlus/pages/dynamics/widgets/up_panel.dart';
import 'package:PiliPlus/pages/dynamics_create/view.dart';
import 'package:PiliPlus/pages/dynamics_tab/controller.dart';
import 'package:PiliPlus/pages/dynamics_tab/view.dart';
import 'package:flutter/material.dart' hide DraggableScrollableSheet;
import 'package:get/get.dart';

class DynamicsPage extends StatefulWidget {
  const DynamicsPage({super.key});

  @override
  State<DynamicsPage> createState() => _DynamicsPageState();
}

class _DynamicsPageState extends State<DynamicsPage>
    with AutomaticKeepAliveClientMixin {
  late ColorScheme colorScheme;
  late final DynamicsController _outerController;
  late final DynamicsTabController _innerController;

  @override
  void initState() {
    super.initState();
    _outerController = Get.put(DynamicsController());
    _innerController = Get.put(DynamicsTabController());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    colorScheme = ColorScheme.of(context);
  }

  Widget _createDynamicBtn() => SizedBox(
    width: 34,
    height: 34,
    child: IconButton(
      tooltip: '发布动态',
      style: ButtonStyle(
        padding: const WidgetStatePropertyAll(.zero),
        backgroundColor: WidgetStatePropertyAll(
          colorScheme.secondaryContainer,
        ),
      ),
      onPressed: () => CreateDynPanel.onCreateDyn(context),
      icon: Icon(
        Icons.add,
        size: 18,
        color: colorScheme.onSecondaryContainer,
      ),
    ),
  );

  Widget upPanelPart({bool isTop = false}) {
    return Material(
      type: .transparency,
      child: SizedBox(
        width: isTop ? null : 64,
        height: isTop ? 76 : null,
        child: NotificationListener<ScrollEndNotification>(
          onNotification: (notification) {
            final metrics = notification.metrics;
            if (metrics.pixels >= metrics.maxScrollExtent - 300 &&
                !_outerController.isEnd) {
              _outerController.onLoadMore();
            }
            return false;
          },
          child: Obx(() => _buildUpPanel(_outerController.loadingState.value)),
        ),
      ),
    );
  }

  Widget _buildUpPanel(LoadingState<FollowUpModel> upState) {
    return switch (upState) {
      Loading() => const SizedBox.shrink(),
      Success<FollowUpModel>(:final response) => UpPanel(
        controller: _outerController,
        upData: response,
      ),
      Error() => Center(
        child: IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _outerController.onReload,
        ),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final tab = _buildTab();
    Widget child = DynamicsTabPage(controller: _innerController);

    switch (_outerController.upPanelPosition) {
      case .top:
        return Column(
          children: [
            tab,
            upPanelPart(isTop: true),
            Expanded(child: child),
          ],
        );
      case .leftFixed:
        child = Row(
          children: [
            upPanelPart(),
            Expanded(child: child),
          ],
        );
      case .rightFixed:
        child = Row(
          children: [
            Expanded(child: child),
            upPanelPart(),
          ],
        );
    }

    return Column(
      children: [
        tab,
        Expanded(child: child),
      ],
    );
  }

  Widget _buildTab() {
    return Row(
      children: [
        Expanded(
          child: Obx(
            () {
              final dynamicsType = _innerController.dynamicsType.value;
              return Row(
                children: DynamicsTabType.values.map((e) {
                  final isCurr = e == dynamicsType;
                  return InkWell(
                    onTap: e == .up && !isCurr
                        ? null
                        : () {
                            if (isCurr) {
                              _outerController.animateToTop();
                              return;
                            }
                            if (dynamicsType == .up) {
                              _innerController.hostMid = -1;
                              _outerController.loadingState.refresh();
                            }
                            _innerController
                              ..dynamicsType.value = e
                              ..onReload();
                          },
                    child: DecoratedBox(
                      decoration: isCurr
                          ? BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 2.0,
                                  color: colorScheme.primary,
                                ),
                              ),
                            )
                          : const BoxDecoration(),
                      child: Container(
                        height: 46,
                        alignment: .center,
                        padding: const .symmetric(horizontal: 16),
                        child: Text(
                          e.label,
                          style: isCurr
                              ? TextStyle(
                                  fontSize: 13,
                                  color: colorScheme.primary,
                                )
                              : const TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
        _createDynamicBtn(),
        const SizedBox(width: 16),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
