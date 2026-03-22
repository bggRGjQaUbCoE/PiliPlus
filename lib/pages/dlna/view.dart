import 'dart:async';

import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/common/widgets/view_sliver_safe_area.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/video/video_quality.dart';
import 'package:PiliPlus/models/video/play/url.dart';
import 'package:PiliPlus/utils/video_utils.dart';
import 'package:dlna_dart/dlna.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class DLNAPage extends StatefulWidget {
  const DLNAPage({super.key});

  @override
  State<DLNAPage> createState() => _DLNAPageState();
}

class _DLNAPageState extends State<DLNAPage> {
  final _searcher = DLNAManager();
  final Map<String, DLNADevice> _deviceList = {};
  late final _url = Get.parameters['url']!;
  late final _title = Get.parameters['title'];
  late final int? _cid = int.tryParse(Get.parameters['cid'] ?? '');
  late final int? _objectId = int.tryParse(Get.parameters['objectId'] ?? '');
  late final int? _playurlType = int.tryParse(
    Get.parameters['playurlType'] ?? '',
  );
  late final int? _initialQn = int.tryParse(Get.parameters['qn'] ?? '');

  Timer? _timer;
  bool _isSearching = false;
  DLNADevice? _lastDevice;
  String? _lastDeviceKey;

  @override
  void initState() {
    super.initState();
    _onSearch(isInit: true);
  }

  Future<void> _onSearch({bool isInit = false}) async {
    if (_isSearching) return;
    _isSearching = true;
    if (!isInit && mounted) {
      _lastDevice = null;
      _deviceList.clear();
      setState(() {});
    }
    final deviceManager = await _searcher.start();
    if (!mounted) {
      return;
    }
    _timer = Timer(const Duration(seconds: 20), _searcher.stop);
    await for (final deviceList in deviceManager.devices.stream) {
      if (mounted) {
        _deviceList.addAll(deviceList);
        setState(() {});
      }
    }
    if (mounted) {
      setState(() {
        _isSearching = false;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    _searcher.stop();
    _lastDevice = null;
    _lastDeviceKey = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('投屏'),
        actions: [
          IconButton(
            tooltip: '搜索',
            onPressed: _onSearch,
            icon: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          if (_isSearching) linearLoading,
          ViewSliverSafeArea(sliver: _buildBody(colorScheme)),
        ],
      ),
    );
  }

  Widget _buildBody(ColorScheme colorScheme) {
    if (!_isSearching && _deviceList.isEmpty) {
      return HttpError(
        errMsg: '没有设备',
        onReload: _onSearch,
      );
    }
    if (_deviceList.isNotEmpty) {
      final keys = _deviceList.keys.toList();
      return SliverList.builder(
        itemCount: keys.length,
        itemBuilder: (context, index) {
          final key = keys[index];
          final device = _deviceList[key]!;
          final isCurr = key == _lastDeviceKey;
          return ListTile(
            title: Text(
              device.info.friendlyName,
              style: isCurr ? TextStyle(color: colorScheme.primary) : null,
            ),
            subtitle: Text(key),
            onTap: () async {
              if (isCurr) return;
              _lastDevice?.pause();
              _lastDevice = device;
              _lastDeviceKey = key;
              setState(() {});

              await _showQualityDialog(device);
            },
          );
        },
      );
    }
    return const SliverToBoxAdapter();
  }

  Future<void> _showQualityDialog(DLNADevice device) async {
    if (_cid == null || _objectId == null || _playurlType == null) {
      await device.setUrl(_url, title: _title ?? '');
      await device.play();
      return;
    }

    SmartDialog.showLoading();
    final res = await VideoHttp.tvPlayUrl(
      cid: _cid!,
      objectId: _objectId!,
      playurlType: _playurlType!,
      qn: _initialQn ?? 80,
    );
    SmartDialog.dismiss();

    if (res case Success(:final response)) {
      final acceptQuality = response.acceptQuality;
      final acceptDesc = response.acceptDesc;

      if (acceptQuality == null || acceptQuality.isEmpty) {
        await device.setUrl(_url, title: _title ?? '');
        await device.play();
        return;
      }

      final initialQa = _initialQn ?? 80;
      final theme = Theme.of(context);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('选择清晰度'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: acceptQuality.length,
              itemBuilder: (context, index) {
                final quality = acceptQuality[index];
                final desc =
                    acceptDesc?[index] ?? VideoQuality.fromCode(quality).desc;
                final isCurrent = quality == initialQa;
                return ListTile(
                  title: Text(desc),
                  trailing: isCurrent
                      ? Icon(Icons.check, color: theme.colorScheme.primary)
                      : null,
                  onTap: () async {
                    Navigator.of(context).pop();
                    SmartDialog.showLoading();
                    final newRes = await VideoHttp.tvPlayUrl(
                      cid: _cid!,
                      objectId: _objectId!,
                      playurlType: _playurlType!,
                      qn: quality,
                    );
                    SmartDialog.dismiss();

                    if (newRes case Success(:final response)) {
                      final first = response.durl?.firstOrNull;
                      if (first == null || first.playUrls.isEmpty) {
                        SmartDialog.showToast('不支持该清晰度');
                        return;
                      }
                      final url = VideoUtils.getCdnUrl(first.playUrls);
                      await device.setUrl(url, title: _title ?? '');
                      await device.play();
                      SmartDialog.showToast('已投屏：${desc}');
                    } else {
                      newRes.toast();
                    }
                  },
                );
              },
            ),
          ),
        ),
      );
    } else {
      await device.setUrl(_url, title: _title ?? '');
      await device.play();
    }
  }
}
