import 'package:PiliPlus/common/widgets/list_tile.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/view_sliver_safe_area.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/login_devices/device.dart';
import 'package:PiliPlus/pages/login_devices/controller.dart';
import 'package:flutter/material.dart' hide ListTile;
import 'package:get/get.dart';

class LoginDevicesPage extends StatefulWidget {
  const LoginDevicesPage({super.key});

  @override
  State<LoginDevicesPage> createState() => LloginDevicesPageState();
}

class LloginDevicesPageState extends State<LoginDevicesPage> {
  final _controller = Get.put(LoginDevicesController());

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('登录设备')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: refreshIndicator(
            onRefresh: _controller.onRefresh,
            child: CustomScrollView(
              slivers: [
                ViewSliverSafeArea(
                  sliver: Obx(
                    () => _buildBody(
                      colorScheme,
                      _controller.loadingState.value,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    ColorScheme colorScheme,
    LoadingState<List<LoginDevice>?> loadingState,
  ) {
    late final divider = Divider(
      height: 1,
      color: colorScheme.outline.withValues(alpha: 0.1),
    );
    return switch (loadingState) {
      Loading() => const SliverToBoxAdapter(),
      Success<List<LoginDevice>?>(:var response) =>
        response?.isNotEmpty == true
            ? SliverList.separated(
                itemBuilder: (context, index) {
                  return _buildItem(colorScheme, response[index]);
                },
                itemCount: response!.length,
                separatorBuilder: (_, _) => divider,
              )
            : HttpError(onReload: _controller.onReload),
      Error(:var errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _controller.onReload,
      ),
    };
  }

  Widget _buildItem(ColorScheme colorScheme, LoginDevice item) {
    final style = TextStyle(fontSize: 13, color: colorScheme.outline);
    return ListTile(
      dense: true,
      title: Text(
        item.deviceName ?? '',
        style: const TextStyle(fontSize: 14),
      ),
      subtitle: Text(
        '${item.latestLoginAt} ${item.source}',
        style: style,
      ),
      trailing: item.isCurrentDevice == true
          ? Text('(本机)', style: style)
          : null,
    );
  }
}
