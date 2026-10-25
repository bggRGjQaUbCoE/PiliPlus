import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/utils/device_fp.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

/// 设备指纹设置：登录与 App 请求里上报的持久设备标识
class DeviceFpPage extends StatefulWidget {
  const DeviceFpPage({super.key});

  @override
  State<DeviceFpPage> createState() => _DeviceFpPageState();
}

class _DeviceFpPageState extends State<DeviceFpPage> {
  static final List<TextInputFormatter> _hexFilter = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-fA-F\d]')),
  ];
  static final List<TextInputFormatter> _textFilter = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\d\-_.]')),
  ];

  late String _deviceId = DeviceFp.deviceId;
  late String _loginSessionId = DeviceFp.loginSessionId;
  String _deviceName = '';
  String _devicePlatform = '';

  @override
  void initState() {
    super.initState();
    _loadDeviceName();
  }

  Future<void> _loadDeviceName() async {
    final (name, platform) = await DeviceFp.deviceNamePair;
    if (!mounted) return;
    setState(() {
      _deviceName = name;
      _devicePlatform = platform;
    });
  }

  Future<void> _editSingle({
    required String title,
    required String description,
    required String value,
    required String hint,
    required List<TextInputFormatter> formatters,
    required String Function() random,
    required void Function(String) onConfirm,
  }) async {
    final controller = TextEditingController(text: value);
    final theme = Theme.of(context);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            isDense: true,
            helperText: description,
            hintText: hint,
            suffixIcon: IconButton(
              onPressed: () => controller.text = random(),
              iconSize: 24,
              tooltip: '随机',
              icon: const Icon(Icons.casino_outlined),
            ),
          ),
          inputFormatters: formatters,
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text(
              '取消',
              style: TextStyle(color: theme.colorScheme.outline),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: controller.text.trim()),
            child: const Text('确定'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result == null || result.isEmpty) return;
    onConfirm(result);
    setState(() {});
  }

  Future<void> _editDeviceName() async {
    final nameController = TextEditingController(text: _deviceName);
    final platformController = TextEditingController(text: _devicePlatform);
    final theme = Theme.of(context);
    final result = await showDialog<(String, String)>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('device_name / device_platform'),
        content: SingleChildScrollView(
          child: Column(
            spacing: 12,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'device_name',
                  hintText: '如 PJZ110',
                  suffixIcon: IconButton(
                    onPressed: () {
                      final (name, platform) = DeviceFp.randomDeviceName();
                      nameController.text = name;
                      platformController.text = platform;
                    },
                    iconSize: 24,
                    tooltip: '随机',
                    icon: const Icon(Icons.casino_outlined),
                  ),
                ),
                inputFormatters: _textFilter,
              ),
              TextField(
                controller: platformController,
                decoration: const InputDecoration(
                  isDense: true,
                  labelText: 'device_platform',
                  hintText: '如 Android16PJZ110',
                ),
                inputFormatters: _textFilter,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text(
              '取消',
              style: TextStyle(color: theme.colorScheme.outline),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(
              result: (
                nameController.text.trim(),
                platformController.text.trim(),
              ),
            ),
            child: const Text('确定'),
          ),
        ],
      ),
    );
    nameController.dispose();
    platformController.dispose();
    if (result == null) return;
    final (name, platform) = result;
    if (name.isEmpty || platform.isEmpty) return;
    DeviceFp.setDeviceName(name, platform);
    setState(() {
      _deviceName = name;
      _devicePlatform = platform;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SimpleScaffold(
      appBar: AppBar(title: const Text('设备指纹')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Text(
              '这些值会随登录请求上报给服务端。使用本机真实值时设备才稳定可用；随机相当于换一台新设备，可能出现二次验证，也可能让扫码授权失败。',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ),
          _buildItem(
            title: 'device_id / bili_local_id',
            value: _deviceId,
            onTap: () => _editSingle(
              title: 'device_id / bili_local_id',
              description: '两者同值，标识本安装',
              value: _deviceId,
              hint: '64 位十六进制',
              formatters: _hexFilter,
              random: DeviceFp.randomDeviceId,
              onConfirm: (value) {
                DeviceFp.deviceId = value;
                _deviceId = value;
              },
            ),
          ),
          _buildItem(
            title: 'login_session_id',
            value: _loginSessionId,
            onTap: () => _editSingle(
              title: 'login_session_id',
              description: '登录会话标识，多次登录保持不变',
              value: _loginSessionId,
              hint: '32 位十六进制',
              formatters: _hexFilter,
              random: DeviceFp.genLoginSessionId,
              onConfirm: (value) {
                DeviceFp.loginSessionId = value;
                _loginSessionId = value;
              },
            ),
          ),
          _buildItem(
            title: 'device_name / device_platform',
            value: _deviceName.isEmpty
                ? ''
                : '$_deviceName / $_devicePlatform',
            onTap: _editDeviceName,
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      title: Text(title),
      subtitle: Text(
        value.isEmpty ? '读取中' : value,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
