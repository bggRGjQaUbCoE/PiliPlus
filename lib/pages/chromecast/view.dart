import 'dart:async';

import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/common/widgets/view_sliver_safe_area.dart';
import 'package:PiliPlus/services/chromecast_service.dart';
import 'package:flutter_chrome_cast/discovery.dart';
import 'package:flutter_chrome_cast/entities.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class ChromecastPage extends StatefulWidget {
  const ChromecastPage({super.key});

  @override
  State<ChromecastPage> createState() => _ChromecastPageState();
}

class _ChromecastPageState extends State<ChromecastPage> {
  final _devices = <String, GoogleCastDevice>{};
  late final _url = Get.parameters['url']!;
  late final _title = Get.parameters['title'];
  StreamSubscription<List<GoogleCastDevice>>? _subscription;
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    _search();
  }

  Future<void> _search() async {
    if (_searching) return;
    _searching = true;
    _devices.clear();
    if (mounted) setState(() {});
    try {
      await ChromecastService.startDiscovery();
      final manager = GoogleCastDiscoveryManager.instance;
      _subscription ??= manager.devicesStream.listen((devices) {
        if (!mounted) return;
        setState(() {
          for (final device in devices) {
            _devices[device.deviceID] = device;
          }
        });
      });
      await Future<void>.delayed(const Duration(seconds: 15));
    } catch (e) {
      if (mounted) SmartDialog.showToast('Chromecast 搜索失败：$e');
    } finally {
      await ChromecastService.stopDiscovery();
      if (mounted) setState(() => _searching = false);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    ChromecastService.stopDiscovery();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleScaffold(
      appBar: AppBar(
        title: const Text('Chromecast'),
        actions: [
          IconButton(
            tooltip: '搜索',
            onPressed: _search,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          if (_searching) linearLoading,
          ViewSliverSafeArea(sliver: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (!_searching && _devices.isEmpty) {
      return HttpError(errMsg: '没有 Chromecast 设备', onReload: _search);
    }
    final devices = _devices.values.toList();
    return SliverList.builder(
      itemCount: devices.length,
      itemBuilder: (context, index) {
        final device = devices[index];
        return ListTile(
          leading: const Icon(Icons.cast),
          title: Text(device.friendlyName),
          subtitle: Text(device.modelName ?? 'Google Cast'),
          onTap: () async {
            try {
              SmartDialog.showLoading();
              await ChromecastService.cast(
                device: device,
                url: _url,
                title: _title,
              );
              SmartDialog.dismiss();
              SmartDialog.showToast('已开始 Chromecast 投屏');
            } catch (e) {
              SmartDialog.dismiss();
              SmartDialog.showToast('Chromecast 播放失败：$e');
            }
          },
        );
      },
    );
  }
}
