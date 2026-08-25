import 'package:PiliPlus/common/widgets/flutter/list_tile.dart';
import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/common/widgets/time_picker.dart' as pili;
import 'package:PiliPlus/common/widgets/view_safe_area.dart';
import 'package:PiliPlus/models/common/network_profile.dart';
import 'package:PiliPlus/models/common/video/video_decode_type.dart';
import 'package:PiliPlus/pages/setting/widgets/ordered_multi_select_dialog.dart';
import 'package:PiliPlus/pages/setting/widgets/select_dialog.dart';
import 'package:PiliPlus/pages/setting/widgets/switch_item.dart';
import 'package:PiliPlus/utils/connectivity_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart' hide ListTile;

class NetworkPolicyPage extends StatefulWidget {
  const NetworkPolicyPage({super.key});

  @override
  State<NetworkPolicyPage> createState() => _NetworkPolicyPageState();
}

class _NetworkPolicyPageState extends State<NetworkPolicyPage> {
  late bool wiredPolicy = Pref.wiredNetworkPolicy;
  late bool wifiPolicy = Pref.wifiNetworkPolicy;
  late int wiredSpeed = Pref.wiredMinLinkSpeed;
  late int wifiMode = Pref.wifiNetworkPolicyMode;
  late int rssi = Pref.wifiRssiThreshold;
  late int wifiSpeed = Pref.wifiMinLinkSpeed;
  NetworkProfile? profile = ConnectivityUtils.current;

  @override
  void initState() {
    super.initState();
    _refreshStatus();
  }

  Future<void> _refreshStatus() async {
    final value = await ConnectivityUtils.resolveForPlayback();
    if (mounted) setState(() => profile = value);
  }

  Future<void> _put(String key, Object value) async {
    await GStorage.setting.put(key, value);
    await ConnectivityUtils.notifySettingsChanged();
    if (mounted) setState(() {});
  }

  Future<int?> _inputInt({
    required String title,
    required int value,
    String? suffix,
    bool signed = false,
  }) {
    var text = value.toString();
    return showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextFormField(
          autofocus: true,
          initialValue: text,
          keyboardType: TextInputType.numberWithOptions(signed: signed),
          inputFormatters: signed
              ? [FilteringTextInputFormatter.allow(RegExp(r'-?\d*'))]
              : [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            suffixText: suffix,
            border: const OutlineInputBorder(borderRadius: .all(.circular(6))),
          ),
          onChanged: (value) => text = value,
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text(
              '取消',
              style: TextStyle(color: ColorScheme.of(context).outline),
            ),
          ),
          TextButton(
            onPressed: () {
              final parsed = int.tryParse(text);
              if (parsed == null ||
                  parsed < (signed ? -100 : 0) ||
                  signed && parsed > 0) {
                SmartDialog.showToast('请输入有效数值');
                return;
              }
              Get.back(result: parsed);
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  Future<void> _setWiredSpeed() async {
    var value = await showDialog<int>(
      context: context,
      builder: (context) => SelectDialog<int>(
        title: '有线协商速率阈值',
        value: {100, 1000, 2500}.contains(wiredSpeed) ? wiredSpeed : -1,
        values: const [
          (100, '百兆（不低于 100 Mbps）'),
          (1000, '千兆（不低于 1000 Mbps）'),
          (2500, '2.5G（不低于 2500 Mbps）'),
          (-1, '自定义'),
        ],
      ),
    );
    if (value == -1 && mounted) {
      value = await _inputInt(
        title: '自定义有线速率阈值',
        value: wiredSpeed,
        suffix: 'Mbps',
      );
    }
    if (value != null && value > 0) {
      wiredSpeed = value;
      await _put(SettingBoxKey.wiredMinLinkSpeed, value);
    }
  }

  Future<void> _showHelp() {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('功能详细说明'),
        content: const SingleChildScrollView(
          child: Text(
            '电脑连接的是有线还是 Wi-Fi，只能说明接入方式，未必能说明这条网络现在是否适合高码率播放。这里可以根据链路协商速率和 Wi-Fi 状态，把当前连接判断为“等效宽带”或“等效移网”，并使用对应的画质、音质和编码偏好。\n\n'
            '这看起来相似，却可能差很多：千兆有线通常比较稳定，降到百兆时可能意味着链路协商出现了变化，也可能只是身处校园网或其他共享网络；Wi-Fi 的信号强度和协商速率，则更能说明这一刻的无线连接是否适合高码率播放。USB 网络共享、手机热点等连接，也可能披着“电脑网络”的外观出现。这项功能用于让电脑在网络条件可能变差时，临时沿用蜂窝网络下的画质、音质和编码偏好。\n\n'
            '这项功能把最终判断归纳为“等效宽带”和“等效移网”。等效宽带使用普通网络下的画质、音质和编码偏好，等效移网使用移动网络下的对应配置。用户可以自行决定哪些有线或 Wi-Fi 状态需要切换，不必受设备类型限制。\n\n'
            '判断只读取当前连接类型、链路协商速率和 Wi-Fi 信号强度，不保存网络名称、IP 地址等无关信息。检测只发生在启动应用、进入播放器等关键节点，不会在播放过程中反复扫描，也不会因为信号的轻微波动频繁切换。所有门限均由用户自行设置，PiliPlus 只负责按照这些规则选择对应的播放配置。\n\n'
            '到了网络高峰期，部分地区的宽带、校园网或特定 CDN 路径可能突然变慢。网络高峰期可以在指定时间段临时使用另一套编码偏好。当前视频保持原样，下一次选择视频流时再应用新的偏好；临时状态只存在于本次运行中，不会改写长期配置，也不会公网测速。\n\n'
            '按流量计费的 Wi-Fi 会直接沿用蜂窝网络偏好。\n\n'
            '系统多做一次判断，只需要一瞬间；人们少遇到一次卡顿，省下的却是真实的时间。人的时间永远比机器值钱。愿这一点小小的自动化，能让每一次播放少一点等待，多一点顺畅。\n\n'
            '思路设计：哥哥科技\n\n\n'
            'PiliPlus，乾杯- ( ゜- ゜)つロ\n'
            '祝大家永远网络通畅，冲浪愉快。',
          ),
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('关闭')),
          TextButton(
            onPressed: () {
              Get
                ..back()
                ..toNamed('/member?mid=501430041');
            },
            child: const Text('访问主页'),
          ),
        ],
      ),
    );
  }

  String get _status {
    final value = profile;
    if (value == null) return '正在读取当前网络状态';
    final details = <String>[
      '接入方式：${value.transport.label}',
      '最终策略：${value.preferenceLabel}',
      if (value.adapterName case final name?) '适配器：$name',
      if (value.adapterDescription case final description?)
        '适配器描述：$description',
      if (value.rssi case final rssi?) 'RSSI：$rssi dBm',
      if (value.signalLevel case final level?) '系统信号等级：$level/4',
      if (value.linkSpeedMbps case final speed?) '有效协商速率：$speed Mbps',
      if (value.receiveLinkSpeedMbps case final speed?)
        '接收协商速率：$speed Mbps',
      if (value.transmitLinkSpeedMbps case final speed?)
        '发送协商速率：$speed Mbps',
      if (value.downstreamKbps case final speed?)
        '系统估计下行：$speed Kbps',
      if (value.upstreamKbps case final speed?) '系统估计上行：$speed Kbps',
      if (value.interfaceMetric case final metric?) '接口 Metric：$metric',
      if (value.mtu case final mtu?) 'MTU：$mtu',
      if (value.carrierName case final carrier?) '运营商：$carrier',
      if (value.networkType case final type?) '蜂窝网络类型代码：$type',
      '按流量计费：${value.metered ? "是" : "否"}',
      if (value.internet case final internet?)
        '互联网能力：${internet ? "有" : "无"}',
      if (value.validated case final validated?)
        '系统验证：${validated ? "已验证" : "未验证"}',
      if (value.captivePortal case final captivePortal?)
        '门户认证：${captivePortal ? "是" : "否"}',
      if (value.congested case final congested?)
        '拥塞：${congested ? "是" : "否"}',
      if (value.bandwidthConstrained case final constrained?)
        '带宽受限：${constrained ? "是" : "否"}',
      if (value.vpn case final vpn?) 'VPN：${vpn ? "是" : "否"}',
      if (value.roaming case final roaming?) '漫游：${roaming ? "是" : "否"}',
      '弱网络提示：${value.weakHint ? "有" : "无"}',
    ];
    return details.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SimpleScaffold(
      appBar: AppBar(title: const Text('PC 网络状态联动判断')),
      body: ViewSafeArea(
        child: ListView(
          padding: .only(bottom: MediaQuery.viewPaddingOf(context).bottom + 40),
          children: [
            Padding(
              padding: const .fromLTRB(16, 12, 8, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '按当前连接质量选择更合适的画质、音质与编码偏好。检测只在进入播放器或网络连接变化时进行，避免频繁抖动。Android 设备可能只支持其中一部分判断。',
                      style: TextStyle(color: theme.colorScheme.outline),
                    ),
                  ),
                  IconButton(
                    tooltip: '功能详细说明',
                    onPressed: _showHelp,
                    icon: const Icon(Icons.help_outline, size: 20),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('当前网络状态'),
              subtitle: Text(_status),
              trailing: IconButton(
                tooltip: '重新检测',
                onPressed: _refreshStatus,
                icon: const Icon(Icons.refresh),
              ),
            ),
            ListTile(
              title: const Text('应用流量统计'),
              subtitle: const Text('按小时查看上下行，并区分 Wi-Fi、等效移网与真正蜂窝流量'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Get.toNamed('/trafficStats'),
            ),
            const Divider(),
            SetSwitchItem(
              title: '电脑有线状态判断',
              subtitle: '开启后，可按协商速率判断是否沿用蜂窝网络偏好',
              setKey: SettingBoxKey.wiredNetworkPolicy,
              defaultVal: wiredPolicy,
              onChanged: (value) {
                wiredPolicy = value;
                ConnectivityUtils.notifySettingsChanged();
                setState(() {});
              },
            ),
            if (wiredPolicy) ...[
              ListTile(
                title: const Text('速率判断'),
                subtitle: Text('协商速率低于 $wiredSpeed Mbps 时按蜂窝网络处理'),
                onTap: _setWiredSpeed,
                trailing: const Icon(Icons.chevron_right),
              ),
              SetSwitchItem(
                title: '非标准速率时按蜂窝网络处理',
                subtitle: '用于识别部分手机共享、异常协商或特殊网卡连接',
                setKey: SettingBoxKey.wiredNonstandardLinkSpeed,
                defaultVal: Pref.wiredNonstandardLinkSpeed,
                onChanged: (_) => ConnectivityUtils.notifySettingsChanged(),
              ),
            ],
            const Divider(),
            SetSwitchItem(
              title: '电脑 Wi-Fi 状况判断',
              subtitle: '开启后，按下方条件判断是否沿用蜂窝网络偏好',
              setKey: SettingBoxKey.wifiNetworkPolicy,
              defaultVal: wifiPolicy,
              onChanged: (value) {
                wifiPolicy = value;
                ConnectivityUtils.notifySettingsChanged();
                setState(() {});
              },
            ),
            if (wifiPolicy) ...[
              ListTile(
                title: const Text('判断方式'),
                subtitle: Text(
                  const ['仅使用信号判断', '仅使用协商速率判断', '两者同时满足', '两者任一满足'][wifiMode],
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final value = await showDialog<int>(
                    context: context,
                    builder: (context) => SelectDialog<int>(
                      title: 'Wi-Fi 判断方式',
                      value: wifiMode,
                      values: const [
                        (0, '仅使用信号判断'),
                        (1, '仅使用协商速率判断'),
                        (2, '信号和速率同时满足'),
                        (3, '信号或速率任一满足'),
                      ],
                    ),
                  );
                  if (value != null) {
                    wifiMode = value;
                    await _put(SettingBoxKey.wifiNetworkPolicyMode, value);
                  }
                },
              ),
              ListTile(
                title: const Text('Wi-Fi RSSI 阈值'),
                subtitle: Text(
                  rssi == 0
                      ? '0：Windows 下只要使用 Wi-Fi 即按蜂窝网络处理；Android 下仅在系统明确报告弱网络或播放持续卡住时处理'
                      : '信号低于 $rssi dBm 时按蜂窝网络处理；Android 读不到精准 RSSI 时不参与此项判断',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final value = await _inputInt(
                    title: 'Wi-Fi RSSI 阈值',
                    value: rssi,
                    suffix: 'dBm',
                    signed: true,
                  );
                  if (value != null) {
                    rssi = value;
                    await _put(SettingBoxKey.wifiRssiThreshold, value);
                  }
                },
              ),
              ListTile(
                title: const Text('Wi-Fi 协商速率阈值'),
                subtitle: Text('协商速率低于 $wifiSpeed Mbps 时按蜂窝网络处理'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final value = await _inputInt(
                    title: 'Wi-Fi 协商速率阈值',
                    value: wifiSpeed,
                    suffix: 'Mbps',
                  );
                  if (value != null) {
                    wifiSpeed = value;
                    await _put(SettingBoxKey.wifiMinLinkSpeed, value);
                  }
                },
              ),
            ],
            const Divider(),
            ListTile(
              leading: const Icon(Icons.schedule_outlined),
              title: const Text('网络高峰期'),
              subtitle: const Text('按时段临时覆盖编码偏好；支持增加、删除和单独停用条目'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => showDialog<void>(
                context: context,
                builder: (context) => const _NetworkPeakDialog(),
              ).whenComplete(_refreshStatus),
            ),
          ],
        ),
      ),
    );
  }
}

class _NetworkPeakDialog extends StatefulWidget {
  const _NetworkPeakDialog();

  @override
  State<_NetworkPeakDialog> createState() => _NetworkPeakDialogState();
}

class _NetworkPeakDialogState extends State<_NetworkPeakDialog> {
  late List<Map<String, dynamic>> periods = List.of(Pref.networkPeakPeriods);

  Future<void> _save() async {
    await GStorage.setting.put(SettingBoxKey.networkPeakPeriods, periods);
    await ConnectivityUtils.notifySettingsChanged();
  }

  String _time(int minute) =>
      '${(minute ~/ 60).toString().padLeft(2, '0')}:${(minute % 60).toString().padLeft(2, '0')}';

  Future<void> _setTime(int index, String key) async {
    final value = periods[index][key] as int;
    final time = await pili.showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: value ~/ 60, minute: value % 60),
    );
    if (time != null) {
      periods[index][key] = time.hour * 60 + time.minute;
      await _save();
      if (mounted) setState(() {});
    }
  }

  Future<void> _setCodecs() async {
    final value = await showDialog<List<VideoDecodeFormatType>>(
      context: context,
      builder: (context) => OrderedMultiSelectDialog<VideoDecodeFormatType>(
        title: '网络高峰期编码偏好',
        initValues: Pref.networkPeakCodecs,
        values: {
          for (final codec in VideoDecodeFormatType.values) codec: codec.name,
        },
      ),
    );
    if (value != null) {
      await GStorage.setting.put(
        SettingBoxKey.networkPeakCodecs,
        value.map((codec) => codec.name).toList(),
      );
      await ConnectivityUtils.notifySettingsChanged();
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final codecs = Pref.networkPeakCodecs;
    return Dialog(
      clipBehavior: Clip.hardEdge,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640, maxHeight: 620),
        child: Column(
          children: [
            Padding(
              padding: const .fromLTRB(20, 18, 8, 8),
              child: Row(
                children: [
                  const Expanded(
                    child: Text('网络高峰期', style: TextStyle(fontSize: 20)),
                  ),
                  IconButton(
                    tooltip: '关闭',
                    onPressed: Get.back,
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('高峰期编码偏好'),
              subtitle: Text(
                codecs.isEmpty
                    ? '未单独设置：跟随蜂窝网络首选解码格式'
                    : codecs.map((codec) => codec.name).join('、'),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: _setCodecs,
            ),
            const Divider(height: 1),
            Expanded(
              child: periods.isEmpty
                  ? const Center(child: Text('尚未添加高峰时段'))
                  : ListView.builder(
                      itemCount: periods.length,
                      itemBuilder: (context, index) {
                        final period = periods[index];
                        return Card(
                          margin: const .fromLTRB(12, 8, 12, 0),
                          child: Padding(
                            padding: const .symmetric(vertical: 6),
                            child: Column(
                              children: [
                                SwitchListTile(
                                  dense: true,
                                  title: Text('时段 ${index + 1}'),
                                  value: period['enabled'] == true,
                                  onChanged: (value) {
                                    period['enabled'] = value;
                                    _save();
                                    setState(() {});
                                  },
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        dense: true,
                                        title: const Text('开始'),
                                        subtitle: Text(_time(period['start'])),
                                        onTap: () => _setTime(index, 'start'),
                                      ),
                                    ),
                                    Expanded(
                                      child: ListTile(
                                        dense: true,
                                        title: const Text('结束'),
                                        subtitle: Text(_time(period['end'])),
                                        onTap: () => _setTime(index, 'end'),
                                      ),
                                    ),
                                  ],
                                ),
                                ListTile(
                                  dense: true,
                                  title: const Text('生效范围'),
                                  trailing: DropdownButton<int>(
                                    value: period['scope'] as int,
                                    items: const [
                                      DropdownMenuItem(
                                        value: 0,
                                        child: Text('仅等效宽带'),
                                      ),
                                      DropdownMenuItem(
                                        value: 1,
                                        child: Text('全场景网络'),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      if (value == null) return;
                                      period['scope'] = value;
                                      _save();
                                      setState(() {});
                                    },
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton.icon(
                                    onPressed: () {
                                      periods.removeAt(index);
                                      _save();
                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.delete_outline),
                                    label: const Text('删除'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const .fromLTRB(16, 8, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      periods.add({
                        'enabled': true,
                        'start': 19 * 60,
                        'end': 23 * 60,
                        'scope': 0,
                      });
                      _save();
                      setState(() {});
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('增加条目'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
