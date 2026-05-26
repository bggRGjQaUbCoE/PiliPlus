import 'dart:async';

import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/common/widgets/view_sliver_safe_area.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/services/cast/cast_media_payload.dart';
import 'package:PiliPlus/services/cast/cast_remote_state.dart';
import 'package:PiliPlus/services/cast/google_cast_service.dart';
import 'package:PiliPlus/services/cast/receiver_device_order.dart';
import 'package:dlna_dart/dlna.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chrome_cast/flutter_chrome_cast.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class DLNAPage extends StatefulWidget {
  const DLNAPage({super.key});

  @override
  State<DLNAPage> createState() => _DLNAPageState();
}

class _DLNAPageState extends State<DLNAPage> {
  static DLNADevice? _activeDlnaDevice;
  static String? _activeDlnaDeviceKey;

  static void _pauseDlnaBestEffort(DLNADevice? device) {
    if (device == null) return;
    unawaited(device.pause().catchError((_) => ''));
  }

  final _searcher = DLNAManager();
  final _googleCast = GoogleCastService.instance;
  final Map<String, DLNADevice> _deviceList = {};
  late final String? _url = Get.parameters['url'];
  late final String? _title = Get.parameters['title'];

  Timer? _timer;
  StreamSubscription<CastRemoteState>? _castStateSub;
  bool _isSearching = false;
  bool _isGoogleCastSearching = false;
  DLNADevice? _lastDevice = _activeDlnaDevice;
  String? _lastDeviceKey = _activeDlnaDeviceKey;
  String? _lastGoogleCastDeviceId;
  int _receiverSwitchGeneration = 0;

  @override
  void initState() {
    super.initState();
    _syncGoogleCastSelection(_googleCast.state, notify: false);
    _castStateSub = _googleCast.stateStream.listen(_syncGoogleCastSelection);
    unawaited(_onSearch(isInit: true));
    unawaited(_startGoogleCastDiscovery());
  }

  void _onRefresh() {
    _receiverSwitchGeneration++;
    unawaited(_startGoogleCastDiscovery(restart: true));
    unawaited(_onSearch());
  }

  Future<void> _startGoogleCastDiscovery({bool restart = false}) async {
    if (!_googleCast.isSupported || _isGoogleCastSearching) return;
    _isGoogleCastSearching = true;
    if (mounted) setState(() {});
    try {
      final initialized = await _googleCast.initialize();
      if (!mounted || !initialized) return;
      if (restart) {
        await _googleCast.stopDiscovery();
      }
      await _googleCast.startDiscovery();
    } catch (_) {
      SmartDialog.showToast('搜索 Chromecast 失败');
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleCastSearching = false;
        });
      }
    }
  }

  Future<void> _onSearch({bool isInit = false}) async {
    if (_isSearching) return;
    _isSearching = true;
    if (!isInit && mounted) {
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
    unawaited(_googleCast.stopDiscovery());
    unawaited(_castStateSub?.cancel());
    _castStateSub = null;
    _lastDevice = null;
    _lastDeviceKey = null;
    _lastGoogleCastDeviceId = null;
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
            onPressed: _onRefresh,
            icon: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          if (_isSearching || _isGoogleCastSearching) linearLoading,
          ViewSliverSafeArea(sliver: _buildBody(colorScheme)),
        ],
      ),
    );
  }

  Widget _buildBody(ColorScheme colorScheme) {
    return StreamBuilder<List<GoogleCastDevice>>(
      stream: _googleCast.devicesStream,
      initialData: _googleCast.devices,
      builder: (context, snapshot) {
        final castDevices = _dedupeCastDevices(snapshot.data);
        final dlnaDevices = _dlnaDevicesForDisplay();
        if (!_isSearching &&
            !_isGoogleCastSearching &&
            dlnaDevices.isEmpty &&
            castDevices.isEmpty) {
          return HttpError(
            errMsg: '没有设备',
            onReload: _onRefresh,
          );
        }

        return SliverList(
          delegate: SliverChildListDelegate(
            [
              if (_googleCast.isSupported) ...[
                _sectionHeader('Google Cast'),
                if (castDevices.isEmpty)
                  _emptyTile(_isGoogleCastSearching ? '搜索中' : '未发现设备')
                else
                  for (final device in castDevices)
                    _googleCastTile(colorScheme, device),
              ],
              _sectionHeader('DLNA'),
              if (dlnaDevices.isEmpty)
                _emptyTile(_isSearching ? '搜索中' : '未发现设备')
              else
                for (final entry in dlnaDevices.entries)
                  _dlnaTile(colorScheme, entry.key, entry.value),
            ],
          ),
        );
      },
    );
  }

  List<GoogleCastDevice> _dedupeCastDevices(
    List<GoogleCastDevice>? devices,
  ) {
    if (!_googleCast.isSupported) {
      return const <GoogleCastDevice>[];
    }
    final active = _googleCast.currentDevice ?? _syntheticCastDevice();
    return preserveDiscoveredOrderWithActive(
      discovered: devices ?? const <GoogleCastDevice>[],
      active: active,
      keyOf: (d) => d.deviceID,
    );
  }

  GoogleCastDevice? _syntheticCastDevice() {
    final state = _googleCast.state;
    final deviceId = state.deviceId;
    if (state.connection != CastConnectionState.connected || deviceId == null) {
      return null;
    }

    return GoogleCastDevice(
      deviceID: deviceId,
      friendlyName: state.deviceName ?? 'Chromecast',
      modelName: null,
      statusText: '已连接',
      deviceVersion: '',
      isOnLocalNetwork: true,
      category: '',
      uniqueID: deviceId,
    );
  }

  Map<String, DLNADevice> _dlnaDevicesForDisplay() {
    final activeKey = _lastDeviceKey ?? _activeDlnaDeviceKey;
    final activeDevice = _lastDevice ?? _activeDlnaDevice;
    return preserveDiscoveredMapOrderWithActive(
      _deviceList,
      activeKey: activeKey,
      active: activeDevice,
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }

  Widget _emptyTile(String text) {
    return ListTile(
      enabled: false,
      dense: true,
      title: Text(text),
    );
  }

  Widget _googleCastTile(ColorScheme colorScheme, GoogleCastDevice device) {
    final isCurr = device.deviceID == _currentGoogleCastDeviceId;
    final subtitle = [
      if (isCurr) '已连接，点击取消',
      if (device.modelName?.isNotEmpty == true) device.modelName!,
      if (device.statusText?.isNotEmpty == true) device.statusText!,
    ].join(' · ');

    return ListTile(
      leading: const Icon(Icons.cast),
      title: Text(
        device.friendlyName,
        style: isCurr ? TextStyle(color: colorScheme.primary) : null,
      ),
      subtitle: subtitle.isEmpty ? null : Text(subtitle),
      trailing: isCurr ? const Icon(Icons.stop_circle_outlined) : null,
      onTap: () async {
        if (isCurr) {
          await _disconnectGoogleCast();
          return;
        }
        await _connectGoogleCast(device);
      },
    );
  }

  Widget _dlnaTile(ColorScheme colorScheme, String key, DLNADevice device) {
    final isCurr = key == _currentDlnaDeviceKey;
    return ListTile(
      leading: const Icon(Icons.connected_tv),
      title: Text(
        device.info.friendlyName,
        style: isCurr ? TextStyle(color: colorScheme.primary) : null,
      ),
      subtitle: Text(isCurr ? '$key · 已连接，点击取消' : key),
      trailing: isCurr ? const Icon(Icons.stop_circle_outlined) : null,
      onTap: () async {
        if (isCurr) {
          await _disconnectDlna(device);
          return;
        }
        final generation = ++_receiverSwitchGeneration;
        final url = _url;
        if (url == null || url.isEmpty) {
          SmartDialog.showToast('投屏地址无效');
          return;
        }
        _pauseDlnaBestEffort(_lastDevice);
        setState(() {
          _setActiveDlna(device, key);
          _lastGoogleCastDeviceId = null;
        });
        await PlPlayerController.pauseLocalIfExists(notify: false);
        if (!_isCurrentReceiverSwitch(generation)) return;
        await _googleCast.disconnect();
        if (!_isCurrentReceiverSwitch(generation)) return;
        await device.setUrl(url, title: _title ?? '');
        if (!_isCurrentReceiverSwitch(generation)) return;
        await device.play();
      },
    );
  }

  String? get _currentGoogleCastDeviceId {
    final state = _googleCast.state;
    if (state.connection == CastConnectionState.connected) {
      return state.deviceId ?? _lastGoogleCastDeviceId;
    }
    return _lastGoogleCastDeviceId;
  }

  String? get _currentDlnaDeviceKey => _lastDeviceKey ?? _activeDlnaDeviceKey;

  void _setActiveDlna(DLNADevice? device, String? key) {
    _lastDevice = device;
    _lastDeviceKey = key;
    _activeDlnaDevice = device;
    _activeDlnaDeviceKey = key;
  }

  void _syncGoogleCastSelection(CastRemoteState state, {bool notify = true}) {
    final nextDeviceId = state.connection == CastConnectionState.connected
        ? state.deviceId
        : null;
    if (_lastGoogleCastDeviceId == nextDeviceId) return;
    _lastGoogleCastDeviceId = nextDeviceId;
    if (notify && mounted) setState(() {});
  }

  Future<void> _disconnectGoogleCast() async {
    final generation = ++_receiverSwitchGeneration;
    setState(() {
      _lastGoogleCastDeviceId = null;
    });
    try {
      final disconnected = await _googleCast.disconnect();
      if (!_isCurrentReceiverSwitch(generation)) return;
      if (disconnected) {
        SmartDialog.showToast('已取消投屏');
      } else {
        SmartDialog.showToast('取消 Chromecast 投屏失败');
      }
    } catch (_) {
      if (!_isCurrentReceiverSwitch(generation)) return;
      SmartDialog.showToast('取消 Chromecast 投屏失败');
    }
  }

  Future<void> _disconnectDlna(DLNADevice device) async {
    final generation = ++_receiverSwitchGeneration;
    setState(() {
      _setActiveDlna(null, null);
    });
    try {
      await device.stop();
      if (!_isCurrentReceiverSwitch(generation)) return;
      SmartDialog.showToast('已取消投屏');
    } catch (_) {
      if (!_isCurrentReceiverSwitch(generation)) return;
      SmartDialog.showToast('取消 DLNA 投屏失败');
    }
  }

  Future<void> _connectGoogleCast(GoogleCastDevice device) async {
    final payload = _buildCastPayload();
    if (payload == null) return;
    final generation = ++_receiverSwitchGeneration;

    final previousDlna = _lastDevice;

    setState(() {
      _lastGoogleCastDeviceId = device.deviceID;
      _setActiveDlna(null, null);
    });

    try {
      _pauseDlnaBestEffort(previousDlna);
      await PlPlayerController.pauseLocalIfExists(notify: false);
      if (!_isCurrentReceiverSwitch(generation)) return;
      final connected = await _googleCast.connect(device);
      if (!_isCurrentReceiverSwitch(generation)) return;
      if (!connected) {
        SmartDialog.showToast('连接 Chromecast 失败');
        setState(() {
          _lastGoogleCastDeviceId = null;
        });
        return;
      }

      await _googleCast.load(payload);
      if (!_isCurrentReceiverSwitch(generation)) {
        return;
      }
      SmartDialog.showToast('已连接 ${device.friendlyName}');
    } catch (_) {
      if (!_isCurrentReceiverSwitch(generation)) return;
      SmartDialog.showToast('投屏失败');
      setState(() {
        _lastGoogleCastDeviceId = null;
      });
    }
  }

  bool _isCurrentReceiverSwitch(int generation) {
    return mounted && generation == _receiverSwitchGeneration;
  }

  CastMediaPayload? _buildCastPayload() {
    final url = _url;
    final uri = url == null || url.isEmpty ? null : Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) {
      SmartDialog.showToast('投屏地址无效');
      return null;
    }

    return CastMediaPayload(
      url: uri,
      title: _title ?? '',
      cover: _parseUri(Get.parameters['cover']),
      position: _parseDuration(Get.parameters['position']) ?? Duration.zero,
      duration: _parseDuration(Get.parameters['duration']),
      qualityCode: int.tryParse(Get.parameters['quality'] ?? ''),
    );
  }

  Uri? _parseUri(String? value) {
    if (value == null || value.isEmpty) return null;
    final uri = Uri.tryParse(value);
    return uri == null || !uri.hasScheme ? null : uri;
  }

  Duration? _parseDuration(String? value) {
    if (value == null || value.isEmpty) return null;
    final milliseconds = int.tryParse(value);
    return milliseconds == null ? null : Duration(milliseconds: milliseconds);
  }
}
